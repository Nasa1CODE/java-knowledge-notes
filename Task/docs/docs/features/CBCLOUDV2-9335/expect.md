# CBCLOUDV2-9335 Expect

## Feature Status

- Status: draft
- Class: Large

## Business Goal

Chấm dứt việc ghi thông tin xác thực (mật khẩu, token, secret, API key) ra log ứng dụng và bảng audit; bảo đảm mọi luồng nghiệp vụ chính khi dừng bất thường đều để lại log truy vết được; và bảo đảm mọi lời gọi sang service bên ngoài đều có log nhận diện được endpoint, kết quả và thời lượng.

Ba mục tiêu này bám sát yêu cầu gốc: (1) log + try/catch đầy đủ để luồng dừng là có log; (2) log đầy đủ các phần gọi sang service khác; (3) không lưu password/token/thông tin nhạy cảm trong log.

Hiện trạng đang vi phạm `docs/specs/system.md` §7.1 ("Secrets must not be added to documentation, comments, generated examples, or logs" và "JWTs, passwords, tokens, raw sensitive XML, and customer/tax data must not be logged casually") và §7.5 ("Services must log enough context to diagnose failures without exposing secrets or sensitive tax data").

## Scope

Phạm vi đợt này là **ưu tiên rủi ro cao**, không quét toàn bộ 12 service.

- Service: `invoicecore`, `api-cloud-service`, `invoice-management`, `export-zip-pdf-service`, `bangke-dctt-java-service`, `etran-teanant-service`, `invoice-sendmail-service`.
- Loại bỏ khỏi log các giá trị nhạy cảm tại những điểm đã xác minh có rò rỉ đang hoạt động: mật khẩu FTP (2 service Java), mật khẩu Kafka và HSM secret (`api-cloud-service`), header `Authorization`/chữ ký HMAC ghi ra stdout (`invoicecore`), payload và response thô của các lời gọi Cyber ID (`invoice-management`), token và API key trong tích hợp VPBank (`invoicecore`).
- Bổ sung lớp che dữ liệu dùng chung (`LogSanitizer`) cho mỗi repo .NET và hàm tương ứng trong `StringHelper` cho 2 repo Java, thay cho các hàm mask đang nằm rải rác dạng `private static` trong app service.
- Chặn rò rỉ thông tin xác thực qua bảng `AbpAuditLogs` bằng `[DisableAuditing]` trên các action nhận credential.
- Bổ sung log và try/catch tại 8 điểm nuốt lỗi đã xác minh nằm trên luồng nghiệp vụ chính: gửi hóa đơn sang VAN, xuất file hàng loạt, 2 consumer của `export-zip-pdf-service`, gửi Tổng Cục Thuế qua Kafka, ký số, cron POS, tra cứu hóa đơn công khai.
- Bổ sung `OutboundLoggingHandler` dùng chung, cắm vào `HttpClientFactory` hiện có; bổ sung log thủ công cho các điểm gọi ra ngoài không đi qua factory.
- Mở rộng cùng nguyên tắc sang `invoice-sendmail-service`: thêm log SMTP/FTP/HTTP handler, khôi phục log lỗi consumer gửi mail, bổ sung log cho các khối `catch` im lặng hoặc ném lại thiếu log, sửa `throw ex;`, và hạ ngưỡng ghi log của Consumer/Producer xuống `Info` để log lời gọi ra ngoài được ghi thật.
- Sửa `TraceIdMiddleware` của `api-cloud-service` để nhận header `X-Trace-Id` đến và đăng ký trước `app.UseAbp()`; bổ sung `%property{traceId}` cho appender `VPBankFileAppender` của `invoicecore`.
- Gỡ tham chiếu project mồ côi trong `invoicecore/aspnet-core/VS.Web.sln` để lệnh build chuẩn dùng được.
- Giữ nguyên hành vi nghiệp vụ. Ngoại lệ được phép duy nhất: luồng xuất file hàng loạt hiện báo "đang xử lý" ngay cả khi khởi tạo tiến trình thất bại.

## Out Of Scope

- Không mã hóa giá trị nhạy cảm để giữ lại trong log. Giá trị nhạy cảm phải bị loại bỏ hoàn toàn.
- Không đổi URL, payload, header, thứ tự gọi, contract API, DTO trả về của bất kỳ tích hợp nào; chỉ nội dung log thay đổi.
- Không thay đổi schema cơ sở dữ liệu, không có migration.
- Không thêm `TraceIdMiddleware` cho `api-qldv-service` và `invoice-management`.
- Không truyền trace ID qua RabbitMQ, MassTransit, Kafka hay Hangfire; không thêm field trace vào contract `EventBus.Messages`.
- Không thêm MDC hay `%X{}` cho 2 service Java.
- Không bật `SeriLogger` gửi Elasticsearch ở `invoice-sendmail-service`.
- Không xử lý `invoice-sendmail-service/DongBoNldApplication/` vì thư mục này không nằm trong `bill-sendmail-service.sln` và phụ thuộc type không có trong repo.
- Không áp `[DisableAuditing]`/`AbpAuditLogs` cho `invoice-sendmail-service` vì service này không dùng ABP audit cho các API nhận credential.
- Không thay đổi manifest Kubernetes để mount volume log.
- Không chuyển các điểm khởi tạo `HttpClient` trực tiếp sang `IHttpClientFactory`.
- Không xử lý các điểm nuốt lỗi ngoài 8 điểm đã liệt kê trong Scope.
- Không dọn dữ liệu nhạy cảm đã ghi trong log cũ và bảng `AbpAuditLogs`; đây là việc vận hành, ghi khuyến nghị trong `deploy.md`.

## Acceptance Criteria

### Yêu cầu 1 — luồng dừng phải có log

- Mỗi điểm trong 8 điểm ban đầu và các điểm bổ sung của `invoice-sendmail-service` thuộc Scope, khi thao tác thất bại, ghi được ít nhất một dòng log mức `Error` hoặc `Warn` chứa nguyên nhân và định danh nghiệp vụ khả dụng (invoice ID, tenant ID, message ID hoặc mã tra cứu).
- Khối `catch` đã có log thì ném lại ngoại lệ bằng `throw;` giữ nguyên stack, trừ vòng lặp cron nơi việc ném lại sẽ dừng job.
- Consumer xử lý Fault của `export-zip-pdf-service` không còn phát sinh `NullReferenceException` khi nhận message.
- Luồng xuất file hàng loạt chỉ báo "đang xử lý" khi tiến trình thực sự được khởi tạo thành công; khi thất bại thì báo thất bại và ghi log.

### Yêu cầu 2 — log đầy đủ lời gọi ra ngoài

- Mọi lời gọi đi qua `HttpClientFactory` sinh log gồm HTTP method, endpoint đã che, mã trạng thái trả về và thời lượng.
- Các điểm gọi ra ngoài thuộc Scope nhưng không đi qua factory (Kafka gửi Tổng Cục Thuế, API BHXH, ký số, Cyber ID, đẩy file FTP, SMTP/FTP của `invoice-sendmail-service`) có log bắt đầu và log kết thúc, kể cả khi ném ngoại lệ.
- Không dòng log nào trong nhóm này ghi thân request, thân response, header hay chuỗi truy vấn nguyên vẹn.
- Request có header `X-Trace-Id` hợp lệ gửi tới `api-cloud-service` nhận lại đúng giá trị đó, và log của service mang cùng giá trị.

### Yêu cầu 3 — không ghi thông tin nhạy cảm

- Không log nào trong phạm vi ghi ra: mật khẩu, mật khẩu xác nhận, URL hay chuỗi truy vấn mang mật khẩu, token truy cập hoặc làm mới, header `Authorization`, HSM secret, API key, OTP, chữ ký thô, hay XML hóa đơn thô.
- Không lời gọi `Console.Out.WriteLine` nào còn lại trong đường ký số; các giá trị này trước đây đi thẳng ra stdout nên không lọc được qua cấu hình log4net.
- Bảng `AbpAuditLogs` không lưu tham số đầu vào của các action nhận credential.
- Các log đã sửa vẫn giữ đủ endpoint, mã trạng thái và định danh nghiệp vụ để chẩn đoán sự cố, theo §7.5.

## Approved Design

### Lớp che dữ liệu dùng chung

Mỗi repo .NET có một lớp `LogSanitizer` tĩnh đặt trong tầng Core, gom các hàm hiện đang nằm dạng `private static` trong `VPBankLendingAppService` và các bản `Truncate` trùng lặp:

- `MaskSecret` giữ vài ký tự đầu và cuối, thay phần giữa; chuỗi quá ngắn thì che toàn bộ.
- `MaskJson` che theo danh sách tên trường cố định, gồm các biến thể của mật khẩu, token, secret, API key, chữ ký, OTP và mã PIN. Bản hiện hữu chỉ che mỗi trường chữ ký, đây là lý do token vẫn lọt ở nhánh thất bại của tích hợp VPBank.
- `MaskUrl` che giá trị của các tham số truy vấn có tên thuộc cùng danh sách trên.
- `Truncate` giới hạn độ dài chuỗi ghi log.

Không tạo package dùng chung giữa các repo: chúng phát hành độc lập và chưa có hạ tầng gói nội bộ. Hai repo Java bổ sung hàm tương ứng vào `StringHelper` đã tồn tại sẵn.

Danh sách tên trường là cố định và được rà soát khi thêm tích hợp mới. Cách này giữ được endpoint, mã trạng thái và định danh nghiệp vụ trong log, tránh việc che quá tay làm mất khả năng chẩn đoán.

### Nguyên tắc loại bỏ, không mã hóa

Giá trị nhạy cảm bị loại khỏi log hoàn toàn. Không thay bằng bản mã: bản mã vẫn là dữ liệu bí mật, vẫn có thể bị giải mã hoặc dùng lại. Nguyên tắc này kế thừa quyết định đã duyệt của `CBCLOUDV2-8307`.

### Log lời gọi ra ngoài

Một `OutboundLoggingHandler` chuyển thể từ handler log đã có của `invoice-sendmail-service`, đổi sang kiểu logger mà nền tảng ABP dùng. Handler ghi HTTP method, endpoint đã che, mã trạng thái, thời lượng và trace ID; không ghi thân hay header; bắt ngoại lệ, ghi log rồi ném lại.

Handler được cắm vào `HttpClientFactory` hiện có, đặt bên ngoài handler ký HMAC để quan sát được request sau cùng. Factory này hiện chỉ phục vụ đường ký số, nên handler không phủ hết các lời gọi ra ngoài. Các điểm còn lại trong Scope được bổ sung log thủ công theo mẫu đã có trong tích hợp VPBank: đo thời lượng, mang một mã định danh xuyên suốt, đọc mã trạng thái và thân phản hồi trước khi ném ngoại lệ, và có khối `finally` bảo đảm luôn ghi được dòng kết thúc.

### Xử lý ngoại lệ

Khối `catch` ghi log rồi ném lại bằng `throw;` để giữ stack. Vòng lặp cron là ngoại lệ: ở đó ném lại sẽ dừng job, nên chỉ ghi log và tiếp tục. Luồng tra cứu hóa đơn công khai vẫn trả DTO rỗng cho người tra cứu để không lộ chi tiết lỗi ra ngoài, nhưng ghi lý do ở phía máy chủ.

### Trace ID

`TraceIdMiddleware` của `api-cloud-service` được thay bằng bản đã hoạt động đúng ở `invoicecore`: nhận header đến khi hợp lệ, sinh mới khi thiếu hoặc không hợp lệ, và khôi phục ngữ cảnh trong khối `finally`. Middleware chuyển lên trước `app.UseAbp()` để log do nền tảng phát ra cũng mang trace ID. Appender ghi log tích hợp VPBank bổ sung trường trace ID cho khớp appender chính trong cùng tệp cấu hình.

### Verification

- Build từng solution của các repo trong Scope.
- Rà soát tĩnh bằng `rg` để xác nhận không còn mẫu log ghép giá trị nhạy cảm, không còn ghi thẳng stdout trong đường ký số, và không còn khối `catch` rỗng trong các tệp đã sửa.
- Chạy thật từng luồng với một chuỗi mật khẩu sentinel và kiểm tra chuỗi đó vắng mặt trong tệp log và trong bảng `AbpAuditLogs`.
- Kiểm tra luồng thất bại có sinh log: tắt RabbitMQ rồi chạy gửi VAN và xuất file hàng loạt.
- Kiểm tra trace ID được giữ nguyên qua một hop và xuất hiện trong log tích hợp VPBank.
