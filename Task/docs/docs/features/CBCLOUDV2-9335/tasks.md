# CBCLOUDV2-9335 Tasks

Ký hiệu phase theo `plan.md`. Chuỗi sentinel dùng cho mọi kiểm thử rò rỉ: `ZZ-sentinel-9335`.

---

## Task A.1 - Bộ tài liệu tính năng

- Status: completed
- Area/service: `docs/`
- Description: Tạo bộ tài liệu đầy đủ cho CBCLOUDV2-9335 theo `docs/rules/01-create-plan.md`, lấy `CBCLOUDV2-9170` làm mẫu định dạng.
- Acceptance criteria:
  - [ ] Có đủ `expect.md`, `plan.md`, `tasks.md`, `impact.md`, `testcase.md`, `deploy.md`, `report.md`.
  - [ ] Không tài liệu nào chứa giá trị bí mật thật; điểm rò rỉ được mô tả bằng đường dẫn và số dòng.
  - [ ] Service được gọi bằng tên thư mục cục bộ, không dùng tên repo git.
  - [ ] `report.md` để trống phần kết quả, chỉ điền bằng output lệnh thật.
- Verification:
  - [ ] Đối chiếu chéo `expect.md`, `plan.md`, `tasks.md`, `impact.md` không mâu thuẫn nhau.
  - [ ] `rg -n -i "password|secret|apikey" docs/features/CBCLOUDV2-9335/` không trả về giá trị bí mật thật nào.
- Dependencies: None
- Likely touched files:
  - `docs/features/CBCLOUDV2-9335/*.md`
- Estimated scope: M

## Task A.2 - Cập nhật trạng thái CBCLOUDV2-8307

- Status: completed
- Area/service: `docs/`
- Description: Task 1-3 của `CBCLOUDV2-8307` đã được thực hiện trên thực tế (middleware trace và mẫu log4net có trường trace) nhưng `tasks.md` vẫn ghi `pending`. Cập nhật trạng thái cho khớp thực tế và ghi chú khác biệt về đường dẫn tệp so với kế hoạch ban đầu.
- Acceptance criteria:
  - [ ] Trạng thái các task đã hoàn thành phản ánh đúng mã nguồn hiện có.
  - [ ] Ghi chú rõ middleware nằm ở thư mục `Middleware/` chứ không phải `Infrastructure/` như kế hoạch ban đầu.
  - [ ] Không sửa nội dung mô tả hay tiêu chí nghiệm thu của ticket cũ.
- Verification:
  - [ ] `invoicecore/aspnet-core/src/zero/VS.Web.Host/Middleware/TraceIdMiddleware.cs` tồn tại và được đăng ký trong `Startup.cs`.
  - [ ] `invoicecore/aspnet-core/src/zero/VS.Web.Host/log4net.config` có `%property{traceId}` trong appender chính.
- Dependencies: None
- Likely touched files:
  - `docs/features/CBCLOUDV2-8307/tasks.md`
- Estimated scope: XS

---

## Task B0.1 - Gỡ tham chiếu project mồ côi khỏi solution

- Status: completed
- Area/service: `invoicecore/`
- Description: `VS.Web.sln` tham chiếu tới `test\TraceIdMiddleware.Tests\TraceIdMiddleware.Tests.csproj`. Tệp `.csproj` không tồn tại và thư mục không còn tệp mã nguồn nào, chỉ sót `bin/` và `obj/` cũ. Gỡ khối `Project`/`EndProject` cùng các dòng `ProjectConfigurationPlatforms` theo GUID tương ứng, rồi xóa thư mục còn lại. Hạn chế này đã được ghi nhận trong `docs/features/CBCLOUDV2-9170/impact.md`.
- Acceptance criteria:
  - [ ] `VS.Web.sln` không còn tham chiếu tới project không tồn tại.
  - [ ] Không project nào khác bị gỡ khỏi solution.
  - [ ] Không mất tệp mã nguồn nào.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` không còn báo lỗi thiếu project.
  - [ ] `rg -n "TraceIdMiddleware.Tests" invoicecore/aspnet-core/VS.Web.sln` trả về rỗng.
- Dependencies: None
- Likely touched files:
  - `invoicecore/aspnet-core/VS.Web.sln`
  - `invoicecore/aspnet-core/test/TraceIdMiddleware.Tests/` (xóa)
- Estimated scope: XS

---

## Task C1.1 - Lớp che dữ liệu dùng chung cho .NET

- Status: completed
- Area/service: `invoicecore/`, `api-cloud-service/`, `invoice-management/`
- Description: Tạo lớp tĩnh `LogSanitizer` trong tầng Core của mỗi repo, gom các hàm che dữ liệu hiện nằm dạng `private static` trong `VPBankLendingAppService` và các bản `Truncate` trùng lặp. Gồm `MaskSecret`, `MaskJson`, `MaskUrl`, `Truncate`. Danh sách tên trường cần che là hằng số dùng chung, gồm các biến thể của mật khẩu, token, secret, API key, chữ ký, OTP và mã PIN. Không tạo package chung giữa các repo vì chúng phát hành độc lập và chưa có hạ tầng gói nội bộ.
- Acceptance criteria:
  - [ ] `MaskSecret` che phần giữa của chuỗi, che toàn bộ với chuỗi ngắn, và xử lý được chuỗi rỗng hoặc null mà không ném ngoại lệ.
  - [ ] `MaskJson` che giá trị của mọi trường có tên thuộc danh sách, không phân biệt hoa thường, và trả lại nguyên chuỗi đầu vào khi không phân tích được JSON.
  - [ ] `MaskUrl` che giá trị tham số truy vấn có tên thuộc danh sách, giữ nguyên phần đường dẫn.
  - [ ] `Truncate` giới hạn độ dài và xử lý được đầu vào null.
  - [ ] Ba repo trong task này có cùng danh sách tên trường; bản của `invoice-sendmail-service` theo Task C4.1.
- Verification:
  - [ ] `dotnet build` từng solution thành công.
  - [ ] Kiểm tra thủ công bằng chuỗi mẫu chứa `ZZ-sentinel-9335` ở cả dạng JSON và chuỗi truy vấn: giá trị bị che trong kết quả trả về.
- Dependencies: Task B0.1
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Core/Commons/LogSanitizer.cs`
  - `api-cloud-service/src/hddt/WS.Core/Commons/LogSanitizer.cs`
  - `invoice-management/aspnet-core/src/hddt/HDDT.Core/Commons/LogSanitizer.cs`
- Estimated scope: M

## Task C1.2 - Che mật khẩu FTP trong hai service Java

- Status: completed
- Area/service: `bangke-dctt-java-service/`, `etran-teanant-service/`
- Description: Bổ sung hàm che vào `StringHelper.java` đã tồn tại ở cả hai repo. Sửa dòng log trong `pushToFtp` của `FTPUtils.java` (dòng 92 ở `bangke-dctt-java-service`, dòng 93 ở `etran-teanant-service`): bỏ hẳn tham số mật khẩu, giữ địa chỉ và tên đăng nhập, hạ mức xuống `debug`. Xóa luôn dòng tương tự đang bị chú thích ở dòng 32 để không bị bỏ chú thích trở lại.
- Acceptance criteria:
  - [ ] Không dòng log nào trong `FTPUtils.java` ghi giá trị mật khẩu.
  - [ ] Dòng log còn lại vẫn nhận diện được địa chỉ FTP và tên đăng nhập.
  - [ ] Hành vi kết nối và đẩy tệp không đổi.
- Verification:
  - [ ] `mvn -q -DskipTests compile` thành công ở cả hai repo.
  - [ ] `rg -n -i "PASSWORD" */src/main/java/vn/sample/multitenancy/utils/FTPUtils.java` không còn dòng log nào ghi giá trị.
  - [ ] Chạy `pushToFtp` với mật khẩu sentinel, tìm sentinel trong tệp log ra kết quả rỗng.
- Dependencies: None
- Likely touched files:
  - `bangke-dctt-java-service/src/main/java/vn/sample/multitenancy/utils/FTPUtils.java`
  - `bangke-dctt-java-service/src/main/java/vn/sample/multitenancy/utils/StringHelper.java`
  - `etran-teanant-service/src/main/java/vn/sample/multitenancy/utils/FTPUtils.java`
  - `etran-teanant-service/src/main/java/vn/sample/multitenancy/utils/StringHelper.java`
- Estimated scope: S

## Task C1.3a - Xóa thông tin xác thực khỏi log của api-cloud-service

- Status: completed
- Area/service: `api-cloud-service/`
- Description: Ba điểm. `TCTProducer.cs` dòng 50 ghi mật khẩu Kafka ở mức `Error` nên luôn được ghi: bỏ mật khẩu và tên đăng nhập, giữ địa chỉ broker và tên topic, hạ mức vì đây không phải lỗi. `GuiHoaDonAppService.cs` dòng 13312 ghi HSM secret: bỏ secret, giữ định danh dịch vụ. Dòng 13917 ghi URL và phản hồi thô: dùng `MaskUrl`, bỏ phản hồi, thay bằng mã trạng thái HTTP.
- Acceptance criteria:
  - [ ] Không log nào trong ba điểm ghi mật khẩu, secret hay phản hồi thô.
  - [ ] Log còn lại nhận diện được đích gọi và kết quả.
  - [ ] Cấu hình Kafka và hành vi gửi không đổi.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\api-cloud-service\VS.WS.sln" --nologo -v:minimal` thành công.
  - [ ] Lệnh rà soát tĩnh số 1 trong `plan.md` không còn trả về ba điểm này.
- Dependencies: Task C1.1
- Likely touched files:
  - `api-cloud-service/src/hddt/WS.Application/Commons/Kafka/Producer/TCTProducer.cs`
  - `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`
- Estimated scope: S

## Task C1.3b - Xóa thông tin xác thực khỏi log ký số của invoicecore

- Status: completed
- Area/service: `invoicecore/`
- Description: Xóa ba lời gọi `Console.Out.WriteLine` ở `HMACDelegatingHandler.cs` dòng 128, 147, 148, đang in dữ liệu ký thô, chuỗi băm và header `Authorization` thẳng ra stdout; chúng không đi qua log4net nên không lọc được bằng cấu hình. Ở `SignFile.cs`, dòng 230 bỏ tham số secret và giữ địa chỉ dịch vụ, định danh cùng mã trạng thái; dòng 219 bỏ payload và XML đã ký, giữ định danh và độ dài.
- Acceptance criteria:
  - [ ] Không còn lời gọi ghi thẳng stdout trong thư mục `ChuKySo/`.
  - [ ] Không log nào ghi secret, header `Authorization`, chữ ký thô hay XML hóa đơn thô.
  - [ ] Log lỗi ký vẫn nhận diện được địa chỉ dịch vụ, định danh và mã trạng thái.
  - [ ] Hành vi ký và giá trị trả về không đổi.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` thành công.
  - [ ] Lệnh rà soát tĩnh số 2 và số 3 trong `plan.md` trả về rỗng.
  - [ ] Ký một hóa đơn thật, stdout không chứa chuỗi `Authorization`.
- Dependencies: Task C1.1
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/Lib/HMACDelegatingHandler.cs`
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/SignFile.cs`
- Estimated scope: S

## Task C1.3c - Xóa payload và phản hồi Cyber ID khỏi log

- Status: completed
- Area/service: `invoice-management/`
- Description: 11 điểm cùng một mẫu trong `QuanLyUserAppService.cs` (dòng 778, 828, 834, 892, 898, 964, 974, 1029, 1037, 1094) ghi URL, payload và phản hồi thô của các lời gọi Cyber ID, gồm cả luồng đặt lại mật khẩu, đăng nhập và đăng ký định danh. Thay bằng `MaskUrl` cho URL, bỏ payload và phản hồi, ghi mã trạng thái HTTP và độ dài phản hồi. Sửa một điểm làm mẫu rồi áp cho cả nhóm.
- Acceptance criteria:
  - [ ] Không điểm nào trong 11 điểm ghi payload hay phản hồi thô.
  - [ ] Mỗi log nhận diện được endpoint đã che và mã trạng thái HTTP.
  - [ ] URL gọi ra, payload JSON, header và việc phân tích phản hồi không đổi.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoice-management\aspnet-core\VS.Web.sln" --nologo -v:minimal` thành công.
  - [ ] Lệnh rà soát tĩnh số 3 trong `plan.md` trả về rỗng cho tệp này.
  - [ ] Chạy luồng đặt lại mật khẩu với sentinel, tìm sentinel trong tệp log ra kết quả rỗng.
- Dependencies: Task C1.1
- Likely touched files:
  - `invoice-management/aspnet-core/src/hddt/HDDT.Application/AppServices/QuanLy/QuanLyUserAppService.cs`
- Estimated scope: M

## Task C1.3d - Che token và API key trong tích hợp VPBank

- Status: completed
- Area/service: `invoicecore/`
- Description: Bốn điểm trong `VPBankLendingAppService.cs`. Dòng 1279 ở nhánh thất bại ghi thân phản hồi chưa qua hàm che, trong khi nhánh thành công ở dòng 1276 thì có, nên token rò đúng lúc lỗi: bổ sung hàm che cho khớp. Dòng 836 ghi nguyên API key và dùng mức `Error` cho trường hợp thành công: bỏ API key và hạ mức. Dòng 843 và 971 dựng lệnh tái hiện có chứa header `Authorization` chưa che, đúng như cảnh báo của tác giả ở dòng 1136-1137: che header theo danh sách tên trường. Chuyển các hàm che riêng sang dùng `LogSanitizer`.
- Acceptance criteria:
  - [ ] Nhánh thất bại và nhánh thành công dùng cùng một hàm che.
  - [ ] Không log nào ghi API key hay header `Authorization` nguyên vẹn.
  - [ ] Mức log phản ánh đúng kết quả: thành công không ghi ở mức `Error`.
  - [ ] Bảng lưu vết tích hợp trong cơ sở dữ liệu và hành vi gọi không đổi.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` thành công.
  - [ ] Gọi một API VPBank thất bại có chủ đích, kiểm tra `App_Data/Logs/VPBank.txt` không chứa token nguyên vẹn.
- Dependencies: Task C1.1
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/VPBank/VPBankLendingAppService.cs`
- Estimated scope: M

## Task C1.3e - Che URL mang mật khẩu trong TokenAuthController

- Status: completed
- Area/service: `invoicecore/`
- Description: `TokenAuthController.cs` dòng 736, 759, 768 ghi biến URL. Một phương thức cùng lớp ở dòng 791-800 dựng URL có ghép tham số mật khẩu vào chuỗi truy vấn. Áp `MaskUrl` cho toàn bộ các điểm ghi URL trong lớp này để chặn cả đường rò hiện tại lẫn khả năng ghép nhầm về sau.
- Acceptance criteria:
  - [ ] Mọi điểm ghi URL trong lớp đều đi qua `MaskUrl`.
  - [ ] Log vẫn nhận diện được đường dẫn endpoint.
  - [ ] Việc dựng URL, gọi ra ngoài và luồng xác thực không đổi.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` thành công.
  - [ ] Chạy luồng xác thực với mật khẩu sentinel, tìm sentinel trong tệp log ra kết quả rỗng.
- Dependencies: Task C1.1
- Likely touched files:
  - `invoicecore/aspnet-core/src/zero/VS.Web.Core/Controllers/TokenAuthController.cs`
- Estimated scope: S

## Task C1.4 - Chặn rò rỉ thông tin xác thực qua bảng audit

- Status: completed
- Area/service: `invoicecore/`, `api-cloud-service/`, `invoice-management/`
- Description: Tính năng audit của nền tảng đang bật cho cả người dùng ẩn danh (`VSCoreModule.cs` dòng 47 ở mỗi repo) và tham số đầu vào của lời gọi được lưu nguyên vào bảng `AbpAuditLogs`. `invoicecore` có lớp lưu audit chỉ ghi khi có ngoại lệ, mà đó đúng là trường hợp đăng nhập sai, thời điểm tham số đang mang mật khẩu. Hai repo còn lại ghi tham số của mọi lời gọi. Gắn thuộc tính vô hiệu hóa audit lên các action nhận thông tin xác thực: xác thực, đổi mật khẩu, đặt lại mật khẩu, đăng ký định danh.
- Acceptance criteria:
  - [ ] Bản ghi audit sinh ra từ các action này không chứa giá trị mật khẩu hay token.
  - [ ] Các action khác vẫn được ghi audit như cũ.
  - [ ] Hành vi xác thực và phân quyền không đổi.
- Verification:
  - [ ] `dotnet build` từng solution thành công.
  - [ ] Đăng nhập sai với mật khẩu sentinel, truy vấn bản ghi audit mới nhất và xác nhận không chứa sentinel.
- Dependencies: Task C1.1
- Likely touched files:
  - `invoicecore/aspnet-core/src/zero/VS.Web.Core/Controllers/TokenAuthController.cs`
  - `invoice-management/aspnet-core/src/hddt/HDDT.Application/AppServices/QuanLy/QuanLyUserAppService.cs`
  - `api-cloud-service/src/hddt/WS.Application/AppServices/` (các action nhận credential)
- Estimated scope: M

---

## Task C2.1 - Ghi log khi gửi hóa đơn sang VAN thất bại

- Status: completed
- Area/service: `invoicecore/`
- Description: `SendQueueMessage.cs`, phương thức `SendXMLVAN`, có khối `catch (Exception ex) { int a = 1; }` bọc quanh thao tác đẩy message vào RabbitMQ với routing key `vendor_send_request_van`. Hóa đơn không sang được VAN mà không để lại dòng log nào. Thay bằng log mức `Error` kèm routing key, định danh hóa đơn và tenant, rồi ném lại bằng `throw;`. Rà cả tệp cho các khối `catch` rỗng cùng mẫu.
- Acceptance criteria:
  - [ ] Thao tác đẩy message thất bại sinh log mức `Error` chứa routing key và định danh nghiệp vụ khả dụng.
  - [ ] Ngoại lệ được ném lại giữ nguyên stack.
  - [ ] Không còn khối `catch` rỗng trong tệp.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` thành công.
  - [ ] Lệnh rà soát tĩnh số 4 trong `plan.md` trả về rỗng cho tệp này.
  - [ ] Tắt RabbitMQ rồi gọi luồng gửi VAN: có log lỗi kèm định danh hóa đơn, ngoại lệ nổi lên tầng trên.
- Dependencies: Task B0.1
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/Commons/SendQueueMessage.cs`
- Estimated scope: S

## Task C2.2 - Sửa phản hồi sai của luồng xuất file hàng loạt

- Status: completed
- Area/service: `invoicecore/`
- Description: Tại `HoaDonAppService.cs` dòng khoảng 1425-1430, thông điệp "Tiến trình xuất file đang thực hiện" và giá trị trạng thái được gán **trước** khi thao tác khởi tạo tiến trình chạy, và thao tác đó nằm trong khối kết thúc bằng `catch (Exception ex) { }`. Khi đẩy message thất bại, người dùng vẫn thấy báo đang xử lý còn tệp thì không bao giờ có. Chuyển việc gán thông điệp và trạng thái xuống sau khi thao tác thành công; nhánh `catch` ghi log và trả thông điệp thất bại. **Đây là thay đổi hành vi người dùng thấy được, cần TechLead xác nhận riêng.**
- Acceptance criteria:
  - [ ] Thông điệp thành công chỉ trả về khi tiến trình thực sự được khởi tạo.
  - [ ] Nhánh thất bại ghi log mức `Error` và trả thông điệp thất bại.
  - [ ] Giao diện Angular xử lý được giá trị trạng thái thất bại mà không lỗi.
  - [ ] Luồng thành công giữ nguyên thông điệp và giá trị trạng thái như cũ.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` thành công.
  - [ ] Rà mã Angular của màn tải file để xác nhận giá trị trạng thái thất bại được xử lý.
  - [ ] Tắt RabbitMQ rồi bấm xuất file: giao diện báo thất bại, máy chủ có log lỗi.
  - [ ] Bật lại RabbitMQ: luồng thành công không đổi so với trước.
- Dependencies: Task B0.1; TechLead phê duyệt riêng
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs`
- Estimated scope: S

## Task C2.3 - Sửa hai consumer của export-zip-pdf-service

- Status: completed
- Area/service: `export-zip-pdf-service/`
- Description: Hai vấn đề riêng biệt. `SendDataBKFaultConsumer.cs` có constructor rỗng khiến trường logger và mediator để null, rồi `Consume` truy cập thẳng logger, gây `NullReferenceException` chắc chắn — mà đây lại chính là consumer xử lý Fault. Bỏ constructor rỗng để container tiêm phụ thuộc như các consumer khác cùng thư mục, và ghi log được danh sách ngoại lệ của Fault cùng định danh message. `ResendConsumer.cs` ghi log "Start handle" rồi toàn bộ phần xử lý bị chú thích lại, message vẫn được xác nhận nên mất hẳn. **Không tự bỏ chú thích**; đổi thông điệp log cho đúng sự thật là message đã nhận và bị bỏ qua, kèm ghi chú trỏ về ticket này. Chờ chủ sở hữu service trả lời câu hỏi mở số 1 trong `plan.md` trước khi quyết định cuối cùng.
- Acceptance criteria:
  - [ ] Consumer xử lý Fault nhận được phụ thuộc qua container và không còn ném `NullReferenceException`.
  - [ ] Log của consumer Fault chứa danh sách ngoại lệ và định danh message.
  - [ ] Thông điệp log của consumer gửi lại phản ánh đúng việc message bị bỏ qua.
  - [ ] Không bỏ chú thích phần xử lý khi chưa có xác nhận của chủ sở hữu service.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\export-zip-pdf-service\bill-worker-service.sln" --nologo -v:minimal` thành công.
  - [ ] Đẩy một message vào hàng đợi Fault: consumer ghi log thay vì ném ngoại lệ.
- Dependencies: Trả lời câu hỏi mở số 1 trong `plan.md`
- Likely touched files:
  - `export-zip-pdf-service/ConsumerApplication/EventBusComsumer/SendDataBKFaultConsumer.cs`
  - `export-zip-pdf-service/ResendInvConsumer/EventBusComsumer/ResendConsumer.cs`
- Estimated scope: S

## Task C2.4 - Bọc xử lý ngoại lệ và log cho lời gọi ký số

- Status: completed
- Area/service: `invoicecore/`
- Description: Phương thức `PdfOriginalSignApi` trong `SignFile.cs` gọi dịch vụ ký mà không có `try/catch` và không có log. Bọc `try/catch`, ghi log bắt đầu và kết thúc kèm địa chỉ dịch vụ, định danh, mã trạng thái và thời lượng, rồi ném lại bằng `throw;`. Thực hiện gộp với Task C1.3b và Task C3.3 vì cùng chạm tệp này.
- Acceptance criteria:
  - [ ] Lời gọi thành công và thất bại đều sinh log kèm mã trạng thái và thời lượng.
  - [ ] Ngoại lệ được ném lại giữ nguyên stack.
  - [ ] Không log nào ghi secret, chữ ký thô hay XML thô.
  - [ ] Kết quả ký và giá trị trả về không đổi.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` thành công.
  - [ ] Ký một hóa đơn thành công: có log kèm thời lượng.
  - [ ] Trỏ sang địa chỉ dịch vụ không tồn tại: có log lỗi, ngoại lệ nổi lên tầng trên.
- Dependencies: Task C1.3b
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/SignFile.cs`
- Estimated scope: S

## Task C2.5 - Ghi log khi job cron thất bại

- Status: completed
- Area/service: `export-zip-pdf-service/`
- Description: `CronJobService.cs` có khối `catch` rỗng bao quanh phần lập lịch, khiến job chết âm thầm. Bổ sung log mức `Error` kèm tên job và giữ nguyên việc **không** ném lại, vì ném lại ở đây sẽ dừng hẳn job. Lớp này còn có bản sao ở `api-qldv-service` và `invoice-senddata2tct-service`; hai repo đó nằm ngoài phạm vi đợt này nên không sửa, ghi lại thành việc tồn đọng trong `impact.md`.
- Acceptance criteria:
  - [ ] Ngoại lệ trong phần lập lịch sinh log mức `Error` kèm tên job.
  - [ ] Job tiếp tục chạy, không bị dừng bởi thay đổi này.
  - [ ] Chu kỳ và hành vi lập lịch không đổi.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\export-zip-pdf-service\bill-worker-service.sln" --nologo -v:minimal` thành công.
  - [ ] Chạy job với cấu hình gây lỗi có chủ đích: có log lỗi và tiến trình vẫn sống.
- Dependencies: None
- Likely touched files:
  - `export-zip-pdf-service/MixPosInvProducer/Producers/CronJobService.cs`
- Estimated scope: XS

## Task C2.6 - Ghi log nguyên nhân khi tra cứu hóa đơn công khai không có kết quả

- Status: completed
- Area/service: `invoicecore/`
- Description: `TraCuuHoaDonAppService.cs` dòng 1308 và 1365 trả DTO rỗng cho người tra cứu mà không ghi nguyên nhân, nên không điều tra được khi khách báo không tra được hóa đơn. Giữ nguyên DTO rỗng trả ra ngoài để không lộ chi tiết lỗi, nhưng bổ sung log mức `Warn` ở phía máy chủ kèm lý do và mã tra cứu.
- Acceptance criteria:
  - [ ] Mỗi nhánh trả về rỗng đều sinh log mức `Warn` kèm lý do và mã tra cứu.
  - [ ] Nội dung trả về cho người tra cứu không đổi.
  - [ ] Log không chứa dữ liệu thuế hay thông tin khách hàng nhạy cảm.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` thành công.
  - [ ] Tra cứu bằng mã không tồn tại: phản hồi giữ nguyên như trước, máy chủ có log cảnh báo.
- Dependencies: Task B0.1
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/TraCuuHoaDonAppService.cs`
- Estimated scope: S

---

## Task C3.1 - Handler log lời gọi ra ngoài

- Status: completed
- Area/service: `invoicecore/`
- Description: Tạo `OutboundLoggingHandler` chuyển thể từ `invoice-sendmail-service/Common.Logging/LoggingDelegatingHandler.cs`, đổi sang kiểu logger mà nền tảng ABP dùng thay vì kiểu của thư viện logging tiêu chuẩn. Đặt cạnh `LogSanitizer` trong tầng Core. Ghi HTTP method, endpoint đã che, mã trạng thái, thời lượng và trace ID. Không ghi thân, không ghi header. Bắt ngoại lệ, ghi log rồi ném lại.
- Acceptance criteria:
  - [ ] Lời gọi thành công và thất bại đều sinh đúng một cặp log bắt đầu và kết thúc.
  - [ ] Log chứa method, endpoint đã che, mã trạng thái và thời lượng.
  - [ ] Không log nào chứa thân request, thân response hay header.
  - [ ] Ngoại lệ được ném lại giữ nguyên stack.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` thành công.
  - [ ] Gọi thử qua handler tới một địa chỉ trả lỗi: có log kèm mã trạng thái.
- Dependencies: Task C1.1
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Core/Commons/OutboundLoggingHandler.cs`
- Estimated scope: S

## Task C3.2 - Cắm handler vào factory tạo HttpClient

- Status: completed
- Area/service: `invoicecore/`
- Description: `HttpClientFactory.cs` hiện tạo `HttpClient` với riêng handler ký HMAC. Nối `OutboundLoggingHandler` vào chuỗi, đặt bên ngoài handler ký để quan sát được request sau cùng. Ghi rõ giới hạn trong `impact.md`: factory này chỉ phục vụ đường ký số, phần lớn lời gọi ra ngoài dùng `HttpClient` khởi tạo trực tiếp và không đi qua factory nào, nên handler không phủ hết. Việc chuyển các điểm đó sang factory nằm ngoài phạm vi.
- Acceptance criteria:
  - [ ] Mọi lời gọi qua factory sinh log theo tiêu chí của Task C3.1.
  - [ ] Thứ tự handler bảo đảm log phản ánh request sau khi đã ký.
  - [ ] Hành vi ký và kết quả gọi không đổi.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` thành công.
  - [ ] Ký một hóa đơn: có log lời gọi ra ngoài kèm mã trạng thái và thời lượng.
- Dependencies: Task C3.1
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/Lib/HttpClientFactory.cs`
- Estimated scope: XS

## Task C3.3 - Bổ sung log cho các điểm gọi ra ngoài không qua factory

- Status: completed
- Area/service: `api-cloud-service/`, `export-zip-pdf-service/`
- Description: Áp mẫu log đã có trong `VPBankLendingAppService.SendEncryptedJsonAsync` (đo thời lượng, mang mã định danh xuyên suốt, đọc mã trạng thái và thân phản hồi trước khi ném ngoại lệ, khối `finally` bảo đảm luôn ghi dòng kết thúc) cho hai điểm: `TCTProducer.cs` gửi Tổng Cục Thuế qua Kafka hiện không có log thành công hay thất bại nào ngoài dòng rò mật khẩu đã xử lý ở Task C1.3a; và `CallApiHelper.cs` gọi API bảo hiểm xã hội, 88 dòng, không có câu lệnh log nào và không có `try/catch`. Các điểm nóng còn lại đã gộp vào Task C1.3c, C2.4 và C1.2. Bản sao của `CallApiHelper.cs` ở `invoice-senddata2tct-service` nằm ngoài phạm vi, ghi lại thành việc tồn đọng.
- Acceptance criteria:
  - [ ] Mỗi lời gọi sinh log bắt đầu và log kết thúc, kể cả khi ném ngoại lệ.
  - [ ] Log chứa đích gọi, kết quả, thời lượng và định danh nghiệp vụ khả dụng.
  - [ ] Không log nào chứa thông tin xác thực hay thân phản hồi thô.
  - [ ] Hành vi gọi và giá trị trả về không đổi.
- Verification:
  - [ ] `dotnet build` hai solution liên quan thành công.
  - [ ] Gửi một message tới Tổng Cục Thuế: có log kèm topic, định danh message và thời lượng.
  - [ ] Gọi API bảo hiểm xã hội với địa chỉ sai: có log lỗi thay vì im lặng.
- Dependencies: Task C1.1, Task C1.3a
- Likely touched files:
  - `api-cloud-service/src/hddt/WS.Application/Commons/Kafka/Producer/TCTProducer.cs`
  - `export-zip-pdf-service/EntityFramework/Ef.Core/ApiHelper/CallApiHelper.cs`
- Estimated scope: M

## Task C3.4 - Vá hạ tầng trace ID

- Status: completed
- Area/service: `api-cloud-service/`, `invoicecore/`
- Description: Ba việc nhỏ. Middleware trace của `api-cloud-service` không đọc header đến mà luôn sinh giá trị mới, làm đứt chuỗi trace ngay hop đầu, lại đăng ký sau phần khởi tạo nền tảng nên log do nền tảng phát ra không có trace ID; thay bằng bản đã hoạt động đúng ở `invoicecore` và chuyển đăng ký lên đầu. Appender ghi log tích hợp VPBank trong `log4net.config` thiếu trường trace ID trong khi appender chính cùng tệp thì có; bổ sung cho khớp. Cho `OutboundLoggingHandler` gắn header trace vào request đi ra, nối với khóa đã khai báo sẵn trong handler ký HMAC.
- Acceptance criteria:
  - [ ] Request có header trace hợp lệ nhận lại đúng giá trị đó, không phải giá trị mới sinh.
  - [ ] Request thiếu header hoặc header không hợp lệ nhận giá trị mới sinh.
  - [ ] Ngữ cảnh trace được khôi phục kể cả khi tầng dưới ném ngoại lệ.
  - [ ] Log ghi vào tệp tích hợp VPBank có trường trace ID.
  - [ ] Request đi ra qua handler mang header trace.
- Verification:
  - [ ] `dotnet build` hai solution liên quan thành công.
  - [ ] Gọi `api-cloud-service` với header trace cố định: phản hồi trả về đúng giá trị đó và log chứa giá trị đó.
  - [ ] Gọi một API VPBank: tệp log tích hợp chứa trường trace ID.
- Dependencies: Task C3.1
- Likely touched files:
  - `api-cloud-service/src/zero/VS.Web.Host/Middleware/TraceIdMiddleware.cs`
  - `api-cloud-service/src/zero/VS.Web.Host/Startup/Startup.cs`
  - `invoicecore/aspnet-core/src/zero/VS.Web.Host/log4net.config`
  - `invoicecore/aspnet-core/src/hddt/HDDT.Core/Commons/OutboundLoggingHandler.cs`
- Estimated scope: M

---

## Task C4.1 - Lớp che dữ liệu cho invoice-sendmail-service

- Status: completed
- Area/service: `invoice-sendmail-service/`
- Description: Tạo `Common.Logging/LogSanitizer.cs` với cùng nhóm hàm `MaskSecret`, `MaskJson`, `MaskUrl`, `Truncate`, `IsSensitiveField` như các repo .NET đã sửa, để che password/token/secret/API key khi cần log URL hoặc dữ liệu kỹ thuật.
- Acceptance criteria:
  - [ ] Có lớp che dữ liệu dùng chung trong `Common.Logging`.
  - [ ] Danh sách tên trường nhạy cảm bao phủ password, token, authorization, secret, API key, chữ ký, OTP và PIN.
  - [ ] Không log giá trị bí mật nguyên vẹn.
- Verification:
  - [ ] `dotnet build "d:\Source\bill_cloud\invoice-sendmail-service\bill-sendmail-service.sln" --nologo -v:minimal` thành công.
  - [ ] Scan sensitive-keyword log trong in-scope project trả về rỗng.
- Dependencies: None
- Likely touched files:
  - `invoice-sendmail-service/Common.Logging/LogSanitizer.cs`
- Estimated scope: S

## Task C4.2 - Log SMTP và xử lý ngoại lệ gửi mail

- Status: completed
- Area/service: `invoice-sendmail-service/ConsumerApplication`
- Description: Sửa `EmailManager.SendMail` để log cấu hình/gọi SMTP ở mức phù hợp, thêm log bắt đầu/thành công/thất bại có thời lượng, bỏ stdout certificate, và đổi `throw ex;` thành `throw;`. Log chỉ giữ host, port, `sendEmailId`, `tenantId`, `hoaDonId`; không ghi password, body mail, người nhận, attachment hay XML.
- Acceptance criteria:
  - [ ] Gửi SMTP thành công có log bắt đầu và kết thúc kèm thời lượng.
  - [ ] Gửi SMTP thất bại có log lỗi rồi ném lại bằng `throw;`.
  - [ ] Không còn ghi certificate ra stdout.
  - [ ] Không log password/body/recipient/attachment/XML.
- Verification:
  - [ ] Build solution thành công.
  - [ ] Scan `throw ex;`, stdout và sensitive-keyword log trả về rỗng.
  - [ ] Chạy gửi mail thật với sentinel và kiểm tra log runtime không chứa sentinel.
- Dependencies: Task C4.1
- Likely touched files:
  - `invoice-sendmail-service/ConsumerApplication/Common/EmailManager.cs`
- Estimated scope: S

## Task C4.3 - Khôi phục log lỗi consumer gửi mail

- Status: completed
- Area/service: `invoice-sendmail-service/ConsumerApplication`
- Description: Bỏ comment/khôi phục `try/catch` trong `SendMailConsumer.Consume`, ghi log khi bắt đầu xử lý và khi lỗi bằng các định danh message (`sendEmailId`, `tenantId`, `hoaDonId`), rồi `throw;` để MassTransit xử lý retry/fault theo pipeline hiện có.
- Acceptance criteria:
  - [ ] Consumer có log bắt đầu xử lý message.
  - [ ] Khi lỗi, consumer ghi log `Error` kèm định danh nghiệp vụ rồi ném lại.
  - [ ] Không log toàn bộ message payload hoặc email người nhận.
- Verification:
  - [ ] Build solution thành công.
  - [ ] Scan sensitive-keyword log trả về rỗng.
  - [ ] Chạy message lỗi qua RabbitMQ runtime và xác nhận có log lỗi.
- Dependencies: Task C4.2
- Likely touched files:
  - `invoice-sendmail-service/ConsumerApplication/EventBusComsumer/SendMailConsumer.cs`
- Estimated scope: XS

## Task C4.4 - Log các catch im lặng trong utility mail/XML/FTP

- Status: completed
- Area/service: `invoice-sendmail-service/ConsumerApplication`, `invoice-sendmail-service/EntityFramework`
- Description: Bổ sung log cho các khối `catch` trong `CommonSendmail`, `FileManager`, `HoaDonUtility`, `HoaDonUtilityBase`, `HoaDonTT3268Utility` và sửa `throw ex;` còn lại trong `FilePathHelper`. Với FTP download giữ nguyên hành vi trả `null`; với các chỗ rethrow thì log rồi `throw;`.
- Acceptance criteria:
  - [ ] Không còn `throw ex;` trong in-scope service.
  - [ ] Không còn khối `catch` rỗng trong in-scope project.
  - [ ] FTP download lỗi có log kèm host, file path và thời lượng, nhưng không ghi FTP password.
  - [ ] Lỗi serialize/parse XML có log định danh type/độ dài, không ghi XML thô.
- Verification:
  - [ ] Build solution thành công.
  - [ ] Scan `throw ex;` và catch rỗng trả về rỗng.
- Dependencies: None
- Likely touched files:
  - `invoice-sendmail-service/ConsumerApplication/Common/CommonSendmail.cs`
  - `invoice-sendmail-service/ConsumerApplication/Common/FileManager.cs`
  - `invoice-sendmail-service/ConsumerApplication/QuanLyHoaDon/HoaDonUtil/HoaDonUtility.cs`
  - `invoice-sendmail-service/ConsumerApplication/QuanLyHoaDon/HoaDonUtil/HoaDonUtilityBase.cs`
  - `invoice-sendmail-service/ConsumerApplication/QuanLyHoaDon/HoaDonUtil/HoaDonTT3268Utility.cs`
  - `invoice-sendmail-service/EntityFramework/Ef.Core/Helper/FilePathHelper.cs`
- Estimated scope: M

## Task C4.5 - Log lỗi timer của QueryProducer

- Status: completed
- Area/service: `invoice-sendmail-service/ProducerApplication`
- Description: Inject `ILogger<QueryProducer>` và ghi log trong catch của vòng lặp timer. Giữ nguyên việc không ném lại vì rethrow tại đây sẽ dừng producer nền.
- Acceptance criteria:
  - [ ] Timer lỗi có log `Error`.
  - [ ] Producer không bị dừng bởi thay đổi log.
  - [ ] Chu kỳ và hành vi publish không đổi.
- Verification:
  - [ ] Build solution thành công.
  - [ ] Chạy producer với cấu hình lỗi và xác nhận có log runtime.
- Dependencies: None
- Likely touched files:
  - `invoice-sendmail-service/ProducerApplication/Services/QueryProducer.cs`
- Estimated scope: XS

## Task C4.6 - Harden LoggingDelegatingHandler của sendmail service

- Status: completed
- Area/service: `invoice-sendmail-service/Common.Logging`
- Description: Sửa `LoggingDelegatingHandler` để log method, URL đã qua `LogSanitizer.MaskUrl`, status code và thời lượng; không ghi body/header; log lỗi rồi giữ hành vi trả `BadGateway`. Handler hiện không có call site trong solution nên chỉ verify tĩnh/build.
- Acceptance criteria:
  - [ ] URL log không chứa query nhạy cảm nguyên vẹn.
  - [ ] Log thành công/thất bại có status code hoặc lỗi và thời lượng.
  - [ ] Không log body/header.
  - [ ] Hành vi trả `BadGateway` khi lỗi được giữ nguyên.
- Verification:
  - [ ] Build solution thành công.
  - [ ] Scan sensitive-keyword log trả về rỗng.
- Dependencies: Task C4.1
- Likely touched files:
  - `invoice-sendmail-service/Common.Logging/LoggingDelegatingHandler.cs`
- Estimated scope: S

## Task C4.7 - Hạ ngưỡng ghi log của Consumer/Producer xuống Info

- Status: completed
- Area/service: `invoice-sendmail-service/ConsumerApplication`, `invoice-sendmail-service/ProducerApplication`
- Description: Đổi `logging.SetMinimumLevel` và rule NLog từ `Warning`/`Error` xuống `Information` để log outbound success của SMTP/FTP/HTTP được ghi thật. Ghi rõ rủi ro tăng dung lượng log trong `deploy.md`.
- Acceptance criteria:
  - [ ] `ConsumerApplication` ghi được log `Information`.
  - [ ] `ProducerApplication` ghi được log `Information`.
  - [ ] Không có cấu hình mới hoặc thay đổi manifest deploy.
- Verification:
  - [ ] Build solution thành công.
  - [ ] Kiểm tra runtime sau phát hành để đo tốc độ tăng log.
- Dependencies: Task C4.2, Task C4.5, Task C4.6
- Likely touched files:
  - `invoice-sendmail-service/ConsumerApplication/Program.cs`
  - `invoice-sendmail-service/ConsumerApplication/nlog.config`
  - `invoice-sendmail-service/ProducerApplication/Program.cs`
  - `invoice-sendmail-service/ProducerApplication/nlog.config`
- Estimated scope: XS

---

## Task E.1 - Hoàn tất bằng chứng kiểm thử

- Status: completed
- Area/service: `docs/`
- Description: Chạy toàn bộ lệnh trong phần Verification Plan của `plan.md` và các case trong `testcase.md`, ghi kết quả thật vào `report.md`. Cập nhật `impact.md` theo danh sách tệp thực sự đã đổi.
- Acceptance criteria:
  - [ ] `report.md` chỉ chứa output và kết quả thật, và liệt kê rõ những kiểm tra chưa chạy được.
  - [ ] `impact.md` khớp danh sách tệp thực tế đã đổi.
  - [ ] `testcase.md` có trạng thái cho từng case.
- Verification:
  - [ ] Đối chiếu chéo `expect.md`, `plan.md`, `tasks.md`, `testcase.md`, `impact.md`, `report.md` không mâu thuẫn nhau.
- Dependencies: Toàn bộ task Phase C
- Likely touched files:
  - `docs/features/CBCLOUDV2-9335/report.md`
  - `docs/features/CBCLOUDV2-9335/impact.md`
  - `docs/features/CBCLOUDV2-9335/testcase.md`
- Estimated scope: S
