# CBCLOUDV2-9335 Test Cases

Chuỗi sentinel dùng cho mọi case kiểm tra rò rỉ: `ZZ-sentinel-9335`. Dùng chuỗi này làm giá trị mật khẩu hoặc token khi chạy thử, rồi tìm lại trong tệp log và trong bảng audit. Không dùng giá trị bí mật thật để kiểm thử.

Trạng thái chỉ được cập nhật bằng kết quả chạy thật, kèm bằng chứng ghi vào `report.md`. Các case phụ thuộc môi trường runtime được giữ `not run` nếu chưa chạy trên service thật.

## Kiểm tra tĩnh

| TC | Mô tả | Cách chạy | Kỳ vọng | Task | Status |
| --- | --- | --- | --- | --- | --- |
| TC01 | Build các solution .NET trong phạm vi | 5 lệnh `dotnet build` trong `plan.md` § Verification Plan | Cả 5 lệnh thành công | B0.1, toàn bộ C | passed |
| TC02 | Build 2 service Java trong phạm vi | Maven Wrapper `.\mvnw.cmd -q -DskipTests compile` trong thư mục từng service | Cả 2 lệnh thành công | C1.2 | passed |
| TC03 | Không còn log ghép giá trị nhạy cảm | Rà soát tĩnh theo từng repo trong scope | Rỗng, hoặc chỉ còn kết quả đã đi qua lớp che dữ liệu và được rà mắt xác nhận từng dòng | C1.2, C1.3a-e | passed |
| TC04 | Không còn ghi thẳng stdout trong đường ký số | Lệnh rà soát tĩnh số 2 trong `plan.md` | Rỗng | C1.3b | passed |
| TC05 | Không còn dump thân request/response ở các tệp đã sửa | Lệnh rà soát tĩnh số 3 trong `plan.md` | Rỗng hoặc chỉ còn biến dùng để parse/truyền request, không còn log/comment raw | C1.3b, C1.3c | passed |
| TC06 | Không còn khối `catch` rỗng ở các tệp đã sửa | Lệnh rà soát tĩnh số 4 trong `plan.md` | Rỗng | C2.1, C2.2 | passed |
| TC07 | Solution không còn tham chiếu project mồ côi | `rg -n "TraceIdMiddleware.Tests" invoicecore/aspnet-core/VS.Web.sln` | Rỗng | B0.1 | passed |
| TC07a | `invoice-sendmail-service` build thành công | `dotnet build "d:\Source\bill_cloud\invoice-sendmail-service\bill-sendmail-service.sln" --nologo -v:minimal` | Build thành công | C4.1-C4.7 | passed |
| TC07b | `invoice-sendmail-service` không còn `throw ex;`, stdout, sensitive-keyword log, catch rỗng trong in-scope project | 4 lệnh scan riêng ở `plan.md` § Rà soát tĩnh | Rỗng | C4.1-C4.7 | passed |

## Yêu cầu 3 — không ghi thông tin nhạy cảm

| TC | Mô tả | Cách chạy | Kỳ vọng | Task | Status |
| --- | --- | --- | --- | --- | --- |
| TC08 | Đăng nhập sai không để lại mật khẩu trong tệp log | Gọi endpoint xác thực với mật khẩu sentinel | Đếm số lần xuất hiện sentinel trong `App_Data/Logs/*.txt` bằng 0 | C1.3e | not run |
| TC09 | Đăng nhập sai không để lại mật khẩu trong bảng audit | Sau TC08, đọc bản ghi audit mới nhất | Trường tham số đầu vào không chứa sentinel | C1.4 | not run |
| TC10 | Luồng đặt lại mật khẩu Cyber ID không ghi payload | Chạy luồng đặt lại mật khẩu với sentinel | Log có endpoint đã che và mã trạng thái; không xuất hiện sentinel, không có thân phản hồi thô | C1.3c | not run |
| TC11 | Ký số không để lộ thông tin xác thực ra stdout | Ký một hóa đơn | stdout không chứa chuỗi `Authorization`; log có endpoint, định danh, mã trạng thái và thời lượng | C1.3b, C2.4 | not run |
| TC12 | Log ký số không chứa XML hóa đơn thô | Sau TC11, đọc tệp log | Không có nội dung XML hóa đơn; chỉ có định danh và độ dài | C1.3b | not run |
| TC13 | Đẩy tệp FTP không ghi mật khẩu | Chạy `pushToFtp` với mật khẩu sentinel ở cả hai service Java | Tìm sentinel trong tệp log ra kết quả rỗng; log còn địa chỉ và tên đăng nhập | C1.2 | not run |
| TC14 | Kafka gửi Tổng Cục Thuế không ghi mật khẩu | Gửi một message | Log không chứa mật khẩu hay tên đăng nhập; còn địa chỉ broker và tên topic | C1.3a | not run |
| TC15 | Tích hợp VPBank không lộ token ở nhánh thất bại | Gọi một API VPBank thất bại có chủ đích | `App_Data/Logs/VPBank.txt` không chứa token nguyên vẹn; nhánh thất bại che giống nhánh thành công | C1.3d | not run |
| TC16 | Lệnh tái hiện không chứa header xác thực nguyên vẹn | Sau TC15, đọc tệp log tích hợp | Header xác thực đã bị che | C1.3d | not run |
| TC16a | Gửi mail không ghi password/body/recipient/attachment/XML | Chạy `invoice-sendmail-service` gửi mail với sentinel trong cấu hình test | Log có host/port/id/thời lượng; không có sentinel hoặc nội dung mail/XML | C4.2, C4.3 | not run |

## Yêu cầu 1 — luồng dừng phải có log

| TC | Mô tả | Cách chạy | Kỳ vọng | Task | Status |
| --- | --- | --- | --- | --- | --- |
| TC17 | Đẩy message VAN thất bại có log | Tắt RabbitMQ rồi gọi luồng gửi VAN | Có log mức `Error` kèm routing key và định danh hóa đơn; ngoại lệ nổi lên tầng trên | C2.1 | not run |
| TC18 | Xuất file hàng loạt thất bại báo đúng | Tắt RabbitMQ rồi bấm xuất file | Giao diện báo thất bại, không còn báo đang xử lý; máy chủ có log lỗi | C2.2 | not run |
| TC19 | Xuất file hàng loạt thành công không đổi | Bật lại RabbitMQ rồi bấm xuất file | Thông điệp và giá trị trạng thái giống hệt trước thay đổi; tiến trình chạy bình thường | C2.2 | not run |
| TC20 | Consumer xử lý Fault không ném lỗi null | Đẩy một message vào hàng đợi Fault | Consumer ghi log kèm danh sách ngoại lệ và định danh message; không có `NullReferenceException` | C2.3 | not run |
| TC21 | Job cron lỗi vẫn sống và có log | Chạy job với cấu hình gây lỗi có chủ đích | Có log mức `Error` kèm tên job; tiến trình không dừng | C2.5 | not run |
| TC22 | Tra cứu công khai không có kết quả vẫn ghi lý do | Tra cứu bằng mã không tồn tại | Phản hồi trả về giữ nguyên như trước; máy chủ có log mức `Warn` kèm lý do và mã tra cứu | C2.6 | not run |
| TC22a | SendMailConsumer lỗi có log trước khi MassTransit xử lý | Đẩy message gửi mail lỗi vào RabbitMQ | Có log `Error` kèm `sendEmailId`, `tenantId`, `hoaDonId`; exception được ném lại | C4.3 | not run |
| TC22b | QueryProducer timer lỗi vẫn sống và có log | Chạy producer với cấu hình gây lỗi có chủ đích | Có log `Error`; producer không dừng | C4.5 | not run |
| TC22c | Lỗi XML mail/VAN không bị nuốt im lặng | Chạy case sinh XML lỗi có chủ đích | Có log lỗi kèm type/định danh; không log XML thô | C4.4 | not run |

## Yêu cầu 2 — log đầy đủ lời gọi ra ngoài

| TC | Mô tả | Cách chạy | Kỳ vọng | Task | Status |
| --- | --- | --- | --- | --- | --- |
| TC23 | Lời gọi qua factory sinh log đầy đủ | Ký một hóa đơn | Có đúng một cặp log bắt đầu và kết thúc, gồm method, endpoint đã che, mã trạng thái và thời lượng | C3.1, C3.2 | not run |
| TC24 | Lời gọi qua factory thất bại vẫn sinh log | Trỏ sang địa chỉ dịch vụ không tồn tại rồi ký | Có log kèm thông tin lỗi; ngoại lệ được ném lại | C3.1, C3.2 | not run |
| TC25 | Handler không ghi thân và header | Sau TC23, đọc tệp log | Không có thân request, thân response hay header trong log | C3.1 | not run |
| TC26 | Gửi Tổng Cục Thuế có log kết quả | Gửi một message | Có log kèm tên topic, định danh message, kết quả và thời lượng | C3.3 | not run |
| TC27 | Gọi API bảo hiểm xã hội lỗi có log | Gọi với địa chỉ sai | Có log lỗi thay vì im lặng; có log bắt đầu và log kết thúc | C3.3 | not run |
| TC28 | Trace ID được giữ qua một hop | Gọi `api-cloud-service` với header trace cố định | Phản hồi trả lại đúng giá trị đã gửi, không phải giá trị mới sinh; log của service mang cùng giá trị | C3.4 | not run |
| TC29 | Trace ID sinh mới khi thiếu hoặc không hợp lệ | Gọi không kèm header, rồi gọi với header quá dài hoặc chứa ký tự không hợp lệ | Cả hai lần nhận giá trị mới sinh hợp lệ | C3.4 | not run |
| TC30 | Log tích hợp VPBank có trường trace ID | Gọi một API VPBank | `App_Data/Logs/VPBank.txt` có trường trace ID giống appender chính | C3.4 | not run |
| TC31 | Request đi ra mang header trace | Ký một hóa đơn và quan sát request gửi đi | Request có header trace khớp giá trị trong ngữ cảnh log | C3.4 | not run |
| TC31a | SMTP của `invoice-sendmail-service` có log bắt đầu/kết thúc | Gửi mail thật | Có log host/port/status nghiệp vụ và thời lượng | C4.2 | not run |
| TC31b | FTP download của `invoice-sendmail-service` có log bắt đầu/kết thúc/lỗi | Tải file XML qua FTP và chạy một case lỗi FTP | Có log host/filePath/bytes hoặc lỗi/thời lượng, không có FTP password | C4.4 | not run |
| TC31c | HTTP handler của `invoice-sendmail-service` không log query nhạy cảm | Gắn handler vào một `HttpClient` test rồi gọi URL có query sentinel | URL trong log đã che query nhạy cảm; không có body/header | C4.6 | not run |

## Không hồi quy

| TC | Mô tả | Cách chạy | Kỳ vọng | Task | Status |
| --- | --- | --- | --- | --- | --- |
| TC32 | Phản hồi API không đổi ở các endpoint đã chạm | So sánh phản hồi trước và sau tại từng endpoint | Cùng mã trạng thái, cùng thân phản hồi; ngoại lệ duy nhất là luồng xuất file hàng loạt | Toàn bộ C | not run |
| TC33 | Lời gọi Cyber ID không đổi | Đối chiếu URL, payload JSON, header và việc phân tích phản hồi trước và sau | Chỉ dòng log đổi, mọi thứ khác giữ nguyên | C1.3c | not run |
| TC34 | Ký số cho kết quả không đổi | Ký cùng một hóa đơn trước và sau | Kết quả ký và giá trị trả về giống nhau | C1.3b, C2.4, C3.2 | not run |
| TC35 | Audit vẫn ghi bình thường cho action khác | Gọi một action không nhận thông tin xác thực | Bản ghi audit vẫn được tạo như trước | C1.4 | not run |

## Ghi chú trạng thái

- TC01-TC07b đã có bằng chứng trong `report.md`.
- Các case runtime từ TC08 trở đi, gồm các case bổ sung của `invoice-sendmail-service`, chưa chạy vì cần môi trường ứng dụng đang chạy và các phụ thuộc ngoài như DB audit, RabbitMQ, Kafka, FTP, SMTP, Cyber ID, VPBank, HSM/signing-service, log runtime/container hoặc UI.
