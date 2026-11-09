# CBCLOUDV2-7209 - Đánh giá ảnh hưởng

## Mục đích

`CBCLOUDV2-7209` bổ sung luồng ký Token MTT trong `api-cloud-service/`: tạo XML chưa ký, nhận/kiểm tra XML đã ký, lưu hóa đơn đã ký và gửi hóa đơn TT78 đủ điều kiện tới TCT qua file storage và Kafka hiện hữu.

## Phạm vi thay đổi

- Loại thay đổi: API backend, nghiệp vụ hóa đơn, trạng thái dữ liệu, kiểm tra chữ ký bên ngoài, file storage và Kafka producer.
- Hợp đồng API: bổ sung phương thức application service theo quy ước HDDT hiện hữu; không thấy thay đổi DTO trong staged source.
- Dữ liệu: cập nhật hóa đơn hiện hữu; thêm dữ liệu theo dõi vào `ServiceTax` và `Transaction_Log`.
- Schema/migration: không có thay đổi được quan sát.
- Cấu hình: thêm phụ thuộc dịch vụ kiểm tra chữ ký XML; không ghi giá trị cấu hình vào tài liệu.

## Thành phần bị ảnh hưởng

| Tầng | Thành phần | Mức độ | Lý do |
| --- | --- | --- | --- |
| API backend | `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/XuLyHoaDonAppService.cs` | Cao | Thêm API tải/gửi XML, điều phối ký, cập nhật trạng thái, gửi TCT, email và xóa cache. |
| Helper XML/ký | `api-cloud-service/src/hddt/WS.Application/Commons/HoaDon/HoaDonHelper.cs` | Cao | Tạo XML MTT, quản lý phiên, kiểm tra chữ ký, cấp số và upload XML. |
| TCT service | `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/TCTAppService.cs` | Cao | Tạo dữ liệu theo dõi, lưu XML thông điệp, cập nhật trạng thái và phát Kafka. |
| Gửi hóa đơn hiện hữu | `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs` | Thấp | Điều chỉnh tham chiếu hóa đơn và thông báo kết quả MTT. |
| Cấu hình host | `api-cloud-service/src/zero/VS.Web.Host/appsettings.json` | Trung bình | Thêm tham chiếu dịch vụ kiểm tra chữ ký. |
| Dữ liệu | `HD_HoaDon`, `ServiceTax`, `Transaction_Log` | Cao | Cập nhật/truy vết trạng thái ký và gửi TCT. |
| Cache | Distributed cache và cache helper hiện hữu | Trung bình | Lưu phiên ký và xóa cache sau khi nhận XML đã ký. |
| File storage | `FileManager`, `FilePath` hiện hữu | Cao | Lưu XML hóa đơn đã ký và XML thông điệp TCT. |
| Kafka | `TCTProducer` và topic cấu hình | Cao | Phát XML đã ký tới xử lý TCT phía sau. |
| Email | `HoaDonHelper.GuiEmail` hiện hữu | Thấp | Giữ hành vi gửi mail tự động có điều kiện. |

## Không thuộc phạm vi

- `frontend_angular/`: không có source thay đổi được xem; cần xác nhận riêng việc gọi API và ký Token phía client.
- DTO và generated service proxy: không có file DTO/proxy thay đổi trong staged source.
- Schema/migration: không thay đổi entity schema hoặc migration.
- Kafka consumer và xử lý phản hồi TCT: chỉ thay đổi phía producer; chưa xác nhận TCT tiếp nhận.
- Worker: không thay đổi `export-zip-pdf-service/`, `invoice-senddata2tct-service/`, `invoice-sendmail-service/`, `svinvoicesendemail/`.
- `GuiTCT` hiện hữu: vẫn tồn tại; `GuiTCTMTT` là luồng MTT riêng.

## Rủi ro và hạn chế

- Dịch vụ kiểm tra chữ ký là phụ thuộc HTTP bên ngoài; lỗi mạng, timeout, TLS hoặc response không tương thích sẽ chặn hoàn tất ký.
- Mã phiên nằm trong cache và có thể hết hạn; client phải yêu cầu XML chưa ký mới khi phiên hết hạn.
- Cập nhật trạng thái hóa đơn, file storage và Kafka diễn ra qua các ranh giới giao dịch khác nhau; khi lỗi cần kiểm tra đồng thời hóa đơn, `ServiceTax`, `Transaction_Log`, file và log producer.
- Producer Kafka thành công không đồng nghĩa TCT đã chấp nhận thông điệp.
- Điều kiện gửi TCT phụ thuộc phê duyệt doanh nghiệp, phương thức gửi, loại chứng thư, TT78, loại hóa đơn và `MTDiep` trong XML.
- Không tìm thấy automated test theo các phương thức MTT mới dưới `api-cloud-service/test/`.

## Chưa kiểm chứng

- `git pull` trong `docs/` không chạy được vì remote yêu cầu credential trong phiên không tương tác.
- Chưa chạy build `WS.Application.csproj` trong lần lập tài liệu.
- Chưa chạy unit test, integration test, Postman, staging, Kafka, file storage hoặc dịch vụ kiểm tra chữ ký.
- Chưa xác nhận frontend/client đã được tạo và deploy để gọi API mới.

## Kết luận

Rủi ro release ở mức trung bình-cao vì thay đổi liên quan trạng thái hóa đơn, XML đã ký, dịch vụ kiểm tra bên ngoài, file storage và Kafka/TCT. Chỉ nên release sau khi chạy end-to-end các kịch bản trong `testcase.md` trên môi trường cô lập và xác nhận đầy đủ phụ thuộc vận hành.
