# CBCLOUDV2-9335 Impact

## Tổng quan

Thay đổi tập trung vào nội dung log và xử lý ngoại lệ. Không có thay đổi schema cơ sở dữ liệu, không có migration, không đổi contract API hay DTO.

Thay đổi hành vi người dùng thấy được có **đúng một chỗ**: luồng xuất file hàng loạt tại `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs` (khoảng dòng 1425-1430). Trước thay đổi, thông điệp "đang xử lý" và giá trị trạng thái được gán trước khi thao tác khởi tạo tiến trình chạy, và thao tác đó nằm trong khối `catch` rỗng; người dùng vì thế luôn nhận báo thành công kể cả khi tiến trình chưa từng khởi động. Sau thay đổi, thông điệp thành công chỉ trả về khi thao tác thành công; khi publish queue thất bại thì trả thông điệp thất bại và ghi log lỗi. Trước deploy vẫn cần TechLead/QA review riêng cho hành vi này và cần rà mã Angular bằng môi trường runtime.

## Khu vực ảnh hưởng

| Khu vực | Mức | Mô tả |
| --- | --- | --- |
| `invoicecore/` — đường ký số | Cao | Xóa ba dòng ghi thẳng stdout in dữ liệu ký, chuỗi băm và header xác thực. Bỏ secret và XML hóa đơn thô khỏi log lỗi ký. Bọc `try/catch` và thêm log cho lời gọi dịch vụ ký. Cắm handler log vào factory tạo `HttpClient`. |
| `invoicecore/` — tích hợp VPBank | Cao | Áp hàm che cho nhánh thất bại vốn đang bỏ sót, bỏ API key khỏi log, che header xác thực trong lệnh tái hiện, hạ mức log cho trường hợp thành công. Chuyển các hàm che riêng sang lớp dùng chung. |
| `invoicecore/` — xác thực | Cao | Che tham số truy vấn trong URL ghi log tại `TokenAuthController`. Gắn thuộc tính vô hiệu hóa audit lên các action nhận thông tin xác thực. |
| `invoicecore/` — hàng đợi và xuất file | Cao | Thêm log và ném lại ngoại lệ tại điểm đẩy message VAN. Sửa thứ tự gán kết quả ở luồng xuất file hàng loạt. |
| `invoicecore/` — tra cứu công khai | Thấp | Thêm log mức cảnh báo ở phía máy chủ. Nội dung trả về cho người tra cứu không đổi. |
| `api-cloud-service/` | Cao | Bỏ mật khẩu Kafka khỏi log (đang ghi ở mức `Error` nên luôn được ghi). Bỏ HSM secret và phản hồi thô. Thêm log gửi Tổng Cục Thuế. Thay middleware trace bằng bản đọc được header đến và chuyển đăng ký lên trước phần khởi tạo nền tảng. |
| `invoice-management/` | Cao | 11 điểm cùng mẫu trong app service quản lý người dùng ngừng ghi payload và phản hồi thô của các lời gọi Cyber ID, gồm cả luồng đặt lại mật khẩu. Gắn thuộc tính vô hiệu hóa audit lên các action nhận thông tin xác thực. |
| `export-zip-pdf-service/` | Trung bình | Sửa consumer xử lý Fault đang chắc chắn ném `NullReferenceException`. Sửa thông điệp log sai sự thật ở consumer gửi lại. Thêm log cho khối `catch` rỗng trong lớp lập lịch cron. Thêm log cho trình gọi API bảo hiểm xã hội. |
| `bangke-dctt-java-service/` | Cao | Bỏ mật khẩu FTP khỏi log, hạ mức log, thêm hàm che vào lớp tiện ích chuỗi có sẵn. |
| `etran-teanant-service/` | Cao | Như trên. |
| `invoice-sendmail-service/` | Trung bình | Thêm log SMTP/FTP/HTTP handler, khôi phục log lỗi consumer gửi mail, bổ sung log cho các khối `catch` im lặng hoặc ném lại thiếu log, sửa `throw ex;`, thêm `LogSanitizer`, và hạ min-level NLog/Program xuống `Info` để log lời gọi ra ngoài được ghi thật. |
| `invoicecore/aspnet-core/VS.Web.sln` | Thấp | Gỡ tham chiếu tới project kiểm thử không còn tồn tại để lệnh build toàn solution dùng được. |
| `docs/` | Thấp | Bộ tài liệu tính năng mới; cập nhật trạng thái task của `CBCLOUDV2-8307` cho khớp thực tế. |

## Xác nhận không bị ảnh hưởng

- Không thay đổi schema cơ sở dữ liệu, không có migration.
- Không đổi URL, payload JSON, body request/response hay thứ tự gọi của bất kỳ tích hợp nào.
- Có thay đổi có chủ đích về header trace: request outbound qua handler ký số được bổ sung/duy trì `X-Trace-Id`, và `api-cloud-service` trả lại `X-Trace-Id` inbound hợp lệ thay vì luôn sinh mới. Không thêm header chứa dữ liệu nhạy cảm.
- Không đổi contract API body, DTO trả về hay mã trạng thái HTTP, trừ luồng xuất file hàng loạt đã nêu ở trên.
- Không đổi mã nguồn Angular, trừ khả năng phải rà lại màn quản lý tải file cho thay đổi trạng thái nói trên.
- Không đổi hành vi ký số, kết quả ký hay giá trị trả về.
- Không đổi cấu hình Kafka, RabbitMQ, MassTransit hay Hangfire.
- Không đổi contract `EventBus.Messages`.
- Không đổi contract message của `invoice-sendmail-service`; consumer chỉ thêm log và ném lại ngoại lệ sau khi ghi log để MassTransit xử lý theo pipeline hiện có.
- Không đụng tệp sinh tự động hay kết quả biên dịch, trừ việc xóa thư mục kết quả biên dịch cũ của project kiểm thử đã mất mã nguồn.

## Rủi ro đã biết

1. **Việc thêm `throw;` làm lộ các lỗi vốn bị giấu.** Sau khi phát hành, số lỗi ghi nhận sẽ tăng. Đây là mục đích của thay đổi, không phải lỗi mới phát sinh; đội vận hành cần được báo trước, đã ghi trong `deploy.md`.
2. **Che quá tay có thể làm mất thông tin cần để chẩn đoán.** Giảm thiểu bằng cách chỉ che theo danh sách tên trường cố định và luôn giữ endpoint, mã trạng thái, định danh nghiệp vụ, theo `docs/specs/system.md` §7.5.
3. **Thay đổi hành vi luồng xuất file có thể ảnh hưởng giao diện.** Code đã sửa để không báo sai "đang xử lý" khi publish queue thất bại; trước deploy phải rà màn quản lý tải file trên môi trường runtime và có TechLead/QA review riêng.
4. **Lớp che dữ liệu được nhân bản sang bốn repo .NET** vì các repo phát hành độc lập và chưa có hạ tầng gói nội bộ. Lần sửa danh sách tên trường sau này phải áp đồng thời cho cả bốn, nếu không sẽ lệch nhau.
5. **`invoice-sendmail-service` hạ min-level xuống `Info`.** Log SMTP/FTP thành công trước đây bị lọc; sau thay đổi sẽ ghi ra file và làm tăng dung lượng log. Cần theo dõi tốc độ tăng log sau phát hành.
6. **Sửa mã nguồn không làm sạch dữ liệu quá khứ.** Các tệp log hiện có và bảng audit vẫn chứa thông tin xác thực. Xử lý theo `deploy.md`.
6. **Handler log không phủ hết lời gọi ra ngoài.** Factory tạo `HttpClient` chỉ phục vụ đường ký số; phần lớn điểm gọi khởi tạo `HttpClient` trực tiếp. Đây là lý do phải bổ sung log thủ công cho các điểm nóng, và là hạn chế còn tồn tại sau đợt này.

## Việc tồn đọng ngoài phạm vi

Ngoài danh sách trong `expect.md` § Out Of Scope, đợt này ghi nhận thêm hai bản sao mã nguồn không được sửa:

- `CronJobService.cs` còn bản sao ở `api-qldv-service/src/hddt/WS.Application/Worker/` và `invoice-senddata2tct-service/MixPosInvProducer/Producers/`, mang cùng khối `catch` rỗng. Hai repo này nằm ngoài phạm vi đợt này.
- `CallApiHelper.cs` còn bản sao ở `invoice-senddata2tct-service/EntityFramework/Ef.Core/ApiHelper/`, cũng không có câu lệnh log nào và không có `try/catch`.
- `invoice-sendmail-service/DongBoNldApplication/` còn một số mẫu log/catch yếu, nhưng thư mục này không nằm trong `bill-sendmail-service.sln` và phụ thuộc `CallApiHelper` không có trong repo, nên không xử lý trong đợt này.

Các mục này cần được xử lý trong đợt sau để tránh lệch giữa các bản sao hoặc khi xác nhận lại service còn được sử dụng.
