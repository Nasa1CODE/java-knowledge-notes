# CBCLOUDV2-9335 Plan

## Goal

Thực hiện các mục tiêu trong `expect.md`: loại bỏ thông tin xác thực khỏi log ứng dụng và bảng audit, bảo đảm 8 luồng nghiệp vụ chính ban đầu và các luồng bổ sung của `invoice-sendmail-service` khi dừng bất thường đều có log, và bổ sung log cho các lời gọi sang service bên ngoài.

Truy vết: yêu cầu 3 của `expect.md` → Phase C1; yêu cầu 1 → Phase C2; yêu cầu 2 → Phase C3; phần mở rộng `invoice-sendmail-service` → Phase C4.

## Context

Khảo sát trực tiếp mã nguồn cho thấy thông tin xác thực **đang** được ghi plaintext ra tệp log và stdout ở thời điểm hiện tại, không phải rủi ro lý thuyết. Cụ thể gồm mật khẩu FTP ở cả hai service Java, mật khẩu Kafka ghi ở mức `Error` nên luôn được ghi, HSM secret, header `Authorization` cùng chữ ký thô ghi thẳng ra stdout, và toàn bộ payload cùng phản hồi của các lời gọi Cyber ID kể cả luồng đặt lại mật khẩu.

Song song, mã C# trong workspace có 258 điểm nuốt lỗi: 34 khối `catch` rỗng hoàn toàn và 224 khối có thân nhưng không ghi log và không ném lại. Một số điểm nằm đúng trên luồng nghiệp vụ chính, khiến hóa đơn không gửi được sang VAN hoặc tiến trình xuất file không khởi động mà không để lại dấu vết nào.

Chất lượng log các lời gọi ra ngoài rất không đồng đều. Tích hợp VPBank có đủ endpoint, mã trạng thái, thời lượng, mã định danh xuyên suốt và cả bảng lưu vết trong cơ sở dữ liệu; trong khi trình gọi API bảo hiểm xã hội không có một câu lệnh log nào và cũng không có `try/catch`.

Ba yêu cầu này đến từ đề bài trực tiếp, và hiện trạng đang vi phạm `docs/specs/system.md` §7.1 và §7.5.

## Assumptions

- Các tệp log hiện hành trong `App_Data/Logs/` và `/u01/logs/` đã chứa thông tin xác thực. Thay đổi mã nguồn không làm sạch dữ liệu quá khứ.
- Các repo .NET trong phạm vi phát hành độc lập với nhau; chưa có hạ tầng gói nội bộ để chia sẻ mã dùng chung, nên lớp `LogSanitizer` được nhân bản cho từng repo thay vì đóng gói.
- Nội dung log không phải là contract với hệ thống bên ngoài; không có bộ phân tích log tự động nào phụ thuộc vào định dạng thông điệp hiện tại. Cần xác nhận với đội vận hành trước khi phát hành.
- `HDDT.Application` đã tham chiếu `HDDT.Core`, nên lớp dùng chung đặt ở Core sẽ dùng được ngay mà không cần thêm tham chiếu project.

## Open Questions

1. Trong `export-zip-pdf-service`, phần xử lý của consumer gửi lại hóa đơn đang bị chú thích lại. Đây là chủ đích (luồng đã ngừng dùng) hay là sót? Cần chủ sở hữu service trả lời trước khi chốt cách xử lý ở Task C2.3. Chưa có câu trả lời thì chỉ sửa thông điệp log cho đúng sự thật, không tự bỏ chú thích.
2. Việc xoay vòng mật khẩu FTP, mật khẩu Kafka, HSM secret và API key VPBank sau khi phát hành do ai chịu trách nhiệm, và có thực hiện trong đợt này không?
3. Giao diện Angular của luồng xuất file hàng loạt có phụ thuộc vào giá trị trạng thái trả về hiện tại không? Cần rà trước khi thực hiện Task C2.2.

## Out Of Scope

Theo `expect.md` § Out Of Scope. Tóm tắt các hạng mục hạ tầng để lại đợt sau: thêm middleware trace cho 2 service còn thiếu, truyền trace ID qua hàng đợi, MDC cho Java, bật gửi log tập trung, mount volume log trong Kubernetes, chuyển các điểm khởi tạo `HttpClient` trực tiếp sang factory, và 250 điểm nuốt lỗi còn lại.

## Impact Assessment

Chi tiết trong `impact.md`. Tóm tắt:

- Thay đổi tập trung ở nội dung log và xử lý ngoại lệ. Không có thay đổi schema, migration, contract API hay DTO.
- Thay đổi hành vi người dùng thấy được có đúng một chỗ: luồng xuất file hàng loạt hiện báo "đang xử lý" ngay cả khi khởi tạo tiến trình thất bại. Cần TechLead xác nhận riêng.
- Bảy repo/service bị ảnh hưởng sau phần mở rộng: sáu service ban đầu và `invoice-sendmail-service`. Lớp lập lịch cron có bản sao độc lập ở ba repo; đợt này chỉ sửa bản trong `export-zip-pdf-service`, hai bản còn lại nằm ngoài phạm vi và được ghi thành việc tồn đọng.
- Việc bổ sung `throw;` ở những nơi trước đây nuốt lỗi sẽ làm các lỗi vốn bị giấu trở nên hiển thị sau khi phát hành. Đây là mục đích, nhưng đội vận hành cần được báo trước.

## Dependency And Implementation Order

```
Phase A  A.1 (bộ tài liệu) + A.2 (cập nhật trạng thái CBCLOUDV2-8307)
   ↓
        Gate 1: DEV review + TechLead phê duyệt
   ↓
Phase B  B0.1 gỡ tham chiếu project mồ côi → mở khóa lệnh build chuẩn
   ↓
Phase C1  C1.1 (lớp che dữ liệu) ──→ C1.3 (áp dụng)
          C1.2 (Java) và C1.4 (audit) độc lập, làm song song được
   ↓
Phase C2  C2.1 … C2.6 độc lập nhau
   ↓
Phase C3  C3.1 (handler) → C3.2 (cắm vào factory) → C3.3 (điểm nóng)
          C3.4 (trace ID) độc lập
   ↓
Phase C4  C4.1-C4.7 mở rộng invoice-sendmail-service
   ↓
        Điền report.md bằng kết quả lệnh thật
```

Phase C1 nên phát hành thành một đợt riêng đi trước: nó chặn rò rỉ ngay và có rủi ro hồi quy thấp nhất trong ba nhóm.

## Phased Approach

### Nguyên tắc áp dụng cho toàn bộ các phase

1. Giá trị nhạy cảm bị loại khỏi log hoàn toàn, không mã hóa để giữ lại.
2. Không đổi hành vi nghiệp vụ: giữ nguyên URL, payload, header, thứ tự gọi và giá trị trả về. Thay đổi người dùng thấy được duy nhất là Task C2.2, đã ghi rõ trong `impact.md`; phần C4 chỉ bổ sung log/khôi phục rethrow nội bộ để pipeline hiện có nhìn thấy lỗi.
3. Khối `catch` ghi log rồi ném lại bằng `throw;` giữ nguyên stack. Không dùng `throw ex`. Ngoại lệ là vòng lặp cron, nơi ném lại sẽ dừng job.
4. Log ghi định danh, không ghi nội dung: endpoint, mã trạng thái, thời lượng, mã nghiệp vụ. Không ghi thân request, thân response, header hay chuỗi truy vấn nguyên vẹn.

### Phase B — Gỡ chặn build

Solution chính của `invoicecore` tham chiếu tới một project kiểm thử không còn tệp `.csproj` và không còn tệp mã nguồn nào, chỉ sót thư mục kết quả biên dịch cũ. Vì vậy lệnh build toàn solution hiện thất bại vì lý do có sẵn, không liên quan tới thay đổi của ticket này. Hạn chế này cũng đã được ghi nhận trong `docs/features/CBCLOUDV2-9170/impact.md`.

Gỡ tham chiếu mồ côi khỏi solution và xóa thư mục còn lại. Đã đối chiếu bốn solution khác trong phạm vi: không solution nào khác có tham chiếu hỏng.

### Phase C1 — Chặn rò rỉ thông tin xác thực

Ưu tiên cao nhất vì đây là các điểm đang ghi plaintext, sửa được ngay và rủi ro hồi quy gần bằng không.

**C1.1** tạo lớp `LogSanitizer` tĩnh trong tầng Core của mỗi repo .NET, gom các hàm che dữ liệu hiện nằm dạng `private static` trong app service tích hợp VPBank và các bản `Truncate` trùng lặp. Bản hiện hữu chỉ che mỗi trường chữ ký; danh sách tên trường được mở rộng sang các biến thể của mật khẩu, token, secret, API key, OTP và mã PIN. Bổ sung hàm che tham số truy vấn trong URL, cần cho các chỗ ghép mật khẩu vào chuỗi truy vấn.

**C1.2** bổ sung hàm che tương ứng vào lớp tiện ích chuỗi đã có sẵn ở cả hai repo Java, rồi sửa hai điểm ghi mật khẩu FTP: bỏ hẳn tham số mật khẩu, giữ địa chỉ và tên đăng nhập, hạ mức log. Dòng tương tự đang bị chú thích lại ở đầu tệp cũng xóa luôn để không bị bỏ chú thích trở lại.

**C1.3** áp dụng lớp che dữ liệu hoặc bỏ hẳn tham số tại các điểm đã xác minh, liệt kê trong `tasks.md`. Nhóm lớn nhất là 11 điểm cùng một mẫu trong app service quản lý người dùng của `invoice-management`; sửa một lần rồi áp cho cả nhóm. Ba dòng ghi thẳng ra stdout trong đường ký số bị xóa: chúng không đi qua log4net nên không thể lọc bằng cấu hình.

**C1.4** chặn rò rỉ qua bảng audit. Tính năng audit của nền tảng đang bật cho cả người dùng ẩn danh ở cả bốn repo .NET, và tham số đầu vào của lời gọi được lưu nguyên vào bảng audit. Riêng `invoicecore` có một lớp lưu audit chỉ ghi khi có ngoại lệ, mà đó đúng là trường hợp đăng nhập sai — thời điểm tham số đang mang mật khẩu. Ba repo còn lại ghi tham số của mọi lời gọi. Cách xử lý là gắn thuộc tính vô hiệu hóa audit lên các action nhận thông tin xác thực.

### Phase C2 — Luồng dừng phải có log

Không xử lý toàn bộ 258 điểm nuốt lỗi. Chỉ 8 điểm đã xác minh nằm trên luồng nghiệp vụ chính, liệt kê trong `tasks.md`. Với mỗi điểm: ghi log kèm nguyên nhân và định danh nghiệp vụ, rồi ném lại ngoại lệ, trừ vòng lặp cron và luồng tra cứu công khai.

Riêng luồng xuất file hàng loạt còn phải sửa thứ tự: hiện thông điệp thành công được gán trước khi thao tác khởi tạo tiến trình chạy, và thao tác đó nằm trong khối `catch` rỗng. Người dùng vì thế luôn thấy "đang xử lý" kể cả khi tiến trình chưa từng khởi động.

### Phase C3 — Log lời gọi ra ngoài

**C3.1** tạo `OutboundLoggingHandler` chuyển thể từ handler log đã có của `invoice-sendmail-service`, đổi sang kiểu logger mà nền tảng dùng, đặt cạnh `LogSanitizer`.

**C3.2** cắm handler vào factory tạo `HttpClient` hiện có, đặt bên ngoài handler ký HMAC để quan sát được request sau cùng. Cần nói rõ giới hạn: factory này chỉ phục vụ đường ký số, còn phần lớn lời gọi ra ngoài dùng `HttpClient` khởi tạo trực tiếp và không đi qua factory nào. Handler vì thế không phủ hết, và đó là lý do có C3.3.

**C3.3** bổ sung log thủ công cho các điểm nóng không đi qua factory, theo mẫu đã có trong tích hợp VPBank: đo thời lượng, mang mã định danh xuyên suốt, đọc mã trạng thái và thân phản hồi trước khi ném ngoại lệ, và có khối `finally` bảo đảm luôn ghi dòng kết thúc. Một số mục trùng tệp với C1.3 và C2.4, nên thực hiện gộp.

**C3.4** sửa hạ tầng trace ID ở mức chi phí thấp: thay middleware của `api-cloud-service` bằng bản đã hoạt động đúng ở `invoicecore` và chuyển đăng ký lên trước phần khởi tạo nền tảng; bổ sung trường trace ID cho appender ghi log tích hợp VPBank; cho handler log gắn header trace vào request đi ra.

### Phase C4 — Mở rộng sang invoice-sendmail-service

`invoice-sendmail-service` ban đầu chỉ được dùng làm mẫu tham khảo cho `LoggingDelegatingHandler`; sau yêu cầu bổ sung, service này được đưa vào cùng ticket. Scope build là `bill-sendmail-service.sln`: `ConsumerApplication`, `ProducerApplication`, `Common.Logging`, `Ef.Core`, `EventBus.Messages`. `DongBoNldApplication/` không nằm trong solution và phụ thuộc type không có trong repo nên vẫn ngoài phạm vi.

**C4.1** thêm `Common.Logging/LogSanitizer.cs` để dùng cùng chuẩn che secret/JSON/URL như các repo .NET khác.

**C4.2** sửa `EmailManager.SendMail`: log cấu hình SMTP ở mức `Information`, thêm log bắt đầu/thành công/thất bại kèm host, port, `sendEmailId`, `tenantId`, `hoaDonId`, thời lượng; không ghi password, body mail, người nhận, attachment hay XML; đổi `throw ex;` thành `throw;`; bỏ ghi certificate ra stdout.

**C4.3** khôi phục `try/catch` trong `SendMailConsumer` để lỗi xử lý message có log trước khi ném lại cho MassTransit pipeline.

**C4.4** bổ sung log cho các khối `catch` im lặng hoặc ném lại thiếu log trong `CommonSendmail`, `HoaDonUtility`, `HoaDonUtilityBase`, `HoaDonTT3268Utility`, `FilePathHelper` và `FileManager`. Với vòng lặp/tải FTP vốn trả `null`, giữ nguyên hành vi trả `null`; với các chỗ rethrow thì ghi log rồi `throw;`.

**C4.5** thêm log cho `QueryProducer` khi timer lỗi, không rethrow để không dừng vòng lặp nền.

**C4.6** harden `Common.Logging/LoggingDelegatingHandler`: log method, URL đã `MaskUrl`, status, thời lượng; không ghi body/header; log lỗi rồi giữ hành vi trả `BadGateway`. Handler hiện không có call site trong solution, nên chỉ verify tĩnh/build.

**C4.7** hạ min-level log của `ConsumerApplication` và `ProducerApplication` từ `Warning`/`Error` xuống `Information` trong cả `Program.cs` và `nlog.config` để log thành công của SMTP/FTP/HTTP được ghi thật.

### Phase A — Tài liệu

Bộ tài liệu tính năng đầy đủ trong thư mục này. Ràng buộc theo `AGENTS.md` và `docs/specs/system.md` §7.1: mô tả điểm rò rỉ bằng đường dẫn và số dòng, không sao chép giá trị bí mật vào tài liệu; gọi service bằng tên thư mục cục bộ.

Kèm theo: cập nhật `docs/features/CBCLOUDV2-8307/tasks.md`, nơi ba task đã thực hiện xong trên thực tế nhưng vẫn ghi trạng thái chờ. Việc này không tính vào phạm vi mã nguồn của ticket.

## Verification Plan

### Build

```powershell
dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal
dotnet build "d:\Source\bill_cloud\api-cloud-service\VS.WS.sln" --nologo -v:minimal
dotnet build "d:\Source\bill_cloud\invoice-management\aspnet-core\VS.Web.sln" --nologo -v:minimal
dotnet build "d:\Source\bill_cloud\export-zip-pdf-service\bill-worker-service.sln" --nologo -v:minimal
dotnet build "d:\Source\bill_cloud\invoice-sendmail-service\bill-sendmail-service.sln" --nologo -v:minimal
```

```bash
cd /d/Source/bill_cloud/bangke-dctt-java-service && mvn -q -DskipTests compile
cd /d/Source/bill_cloud/etran-teanant-service   && mvn -q -DskipTests compile
```

Lệnh đầu tiên chỉ có nghĩa sau khi Task B0.1 hoàn thành; trước đó nó thất bại vì tham chiếu project mồ côi có sẵn.

### Rà soát tĩnh

```bash
cd /d/Source/bill_cloud

# 1. Không còn log ghép giá trị nhạy cảm
rg -n -i --glob '!**/obj/**' --glob '!**/bin/**' \
  '(Logger\.(Info|Warn|Error|Debug|Fatal)|log\.(info|warn|error|debug))[^;]*\b(password|passWord|passWordConfig|ftpPassword|Service_Secret|secret|apikey|ApiKey|access_token|Authorization)\b' \
  invoicecore api-cloud-service invoice-management bangke-dctt-java-service etran-teanant-service

# 2. Không còn ghi thẳng stdout trong đường ký số
rg -n 'Console\.(Out\.)?Write(Line)?' \
  invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/

# 3. Không còn dump thân request/response ở các tệp đã sửa
rg -n 'datares|stringPayload|base64xmlSigned' \
  invoice-management/aspnet-core/src/hddt/HDDT.Application/AppServices/QuanLy/QuanLyUserAppService.cs \
  invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/SignFile.cs

# 4. Không còn catch rỗng ở các tệp đã sửa
rg -n -U --glob '!**/obj/**' 'catch\s*\([^)]*\)\s*\{\s*(int a = 1;)?\s*\}' \
  invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/Commons/SendQueueMessage.cs \
  invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs

# 5. Kiểm tra riêng invoice-sendmail-service
cd /d/Source/bill_cloud/invoice-sendmail-service
rg -n 'throw ex;' --glob '!**/bin/**' --glob '!**/obj/**'
rg -n 'Console\.(Out\.)?Write(Line)?' --glob '!**/bin/**' --glob '!**/obj/**'
rg -n -i '(_logger|Logger)\.(LogInformation|LogWarning|LogError|LogDebug|LogCritical|Info|Warn|Error|Debug)[^;]*\b(password|matkhau|MatKhau|secret|token|authorization|apikey|api_key)\b' ConsumerApplication ProducerApplication Common.Logging EntityFramework EventBus.Messages
rg -n -U 'catch\s*\([^)]*\)\s*\{\s*\}' ConsumerApplication ProducerApplication Common.Logging EntityFramework EventBus.Messages
```

Lệnh 2, 3, 4 phải trả về rỗng. Lệnh 1 hoặc trả về rỗng, hoặc chỉ còn các kết quả đã đi qua `LogSanitizer` và phải rà mắt xác nhận từng dòng.

### Kiểm thử chạy thật

Chi tiết trong `testcase.md`. Dùng chuỗi sentinel `ZZ-sentinel-9335` làm mật khẩu thử ở mọi kịch bản kiểm tra rò rỉ, rồi tìm chuỗi này trong tệp log và trong bảng audit. Kiểm tra luồng thất bại bằng cách tắt RabbitMQ rồi chạy gửi VAN và xuất file hàng loạt. Kiểm tra trace ID bằng cách gửi một giá trị cố định qua header và đối chiếu giá trị trả về cùng nội dung log.

### Không hồi quy

- Đối chiếu phản hồi API trước và sau ở các endpoint đã chạm: cùng mã trạng thái, cùng thân phản hồi. Ngoại lệ là luồng xuất file hàng loạt, đã cố ý đổi.
- Với app service quản lý người dùng: xác nhận URL, payload JSON, header và việc phân tích phản hồi không đổi; chỉ dòng log đổi.

## Risk Matrix

| Rủi ro | Mức | Giảm thiểu |
| --- | --- | --- |
| Che quá tay làm mất thông tin cần để chẩn đoán sự cố | Trung bình | Chỉ che theo danh sách tên trường cố định; luôn giữ endpoint, mã trạng thái và định danh nghiệp vụ, theo §7.5 |
| Đổi hành vi luồng xuất file làm hỏng giao diện đang phụ thuộc giá trị trạng thái | Trung bình | Rà mã Angular trước khi sửa; cần TechLead phê duyệt riêng cho Task C2.2 |
| Bổ sung `throw;` làm lộ các lỗi vốn bị giấu, gây cảm giác lỗi tăng sau phát hành | Trung bình | Đây là mục đích của thay đổi. Cảnh báo đội vận hành trong `deploy.md`: số lỗi không tăng, chỉ là trước đây bị che |
| Sót điểm khi sửa 11 vị trí cùng mẫu trong một tệp | Thấp | Lệnh rà soát tĩnh số 1 và số 3 bắt được chỗ sót |
| Chạm lớp cơ sở của cron ảnh hưởng ba repo | Thấp | Chỉ thêm log, giữ nguyên việc không ném lại để job không bị dừng |
| Gỡ project khỏi solution | Thấp | Đã xác minh thư mục không còn tệp mã nguồn nào, chỉ còn kết quả biên dịch cũ |
| Nhân bản `LogSanitizer` sang nhiều repo gây lệch nhau về sau | Thấp | Ghi rõ trong `impact.md` để lần sửa danh sách tên trường được áp đồng thời cho các repo |

## Deployment Notes

Chi tiết trong `deploy.md`. Hai điểm bắt buộc:

- Phase C1 nên là một đợt phát hành riêng, đi trước, vì nó chặn rò rỉ ngay và rủi ro hồi quy thấp nhất.
- Sửa mã nguồn không làm sạch dữ liệu quá khứ. Các tệp log hiện có và bảng audit vẫn chứa thông tin xác thực, nên cần xoay vòng mật khẩu FTP, mật khẩu Kafka, HSM secret và API key VPBank, đồng thời cân nhắc dọn dữ liệu audit cũ.
