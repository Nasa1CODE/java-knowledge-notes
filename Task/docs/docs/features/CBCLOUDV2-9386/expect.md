# Expect - CBCLOUDV2-9386: Bỏ bắt buộc Địa chỉ thư điện tử khi import Hàng hóa đặc trưng 1

status: testing
services-affected: invoicecore, svinvoicesendemail

## Bối cảnh

Khi import hóa đơn có hàng hóa đặc trưng loại 1, hệ thống hiện bắt buộc trường Email của người mua và trả message `Địa chỉ thư điện tử không được để trống.`. Nghiệp vụ mới cho phép bỏ trống trường này trên hóa đơn GTGT, hóa đơn bán hàng và hóa đơn vé xe.

## Mong muốn

- Áp dụng cho template import mới và hóa đơn có ít nhất một dòng thỏa `tinhchat = 4`, `loaihoadondactrung/loaidactrung = 1`.
- Bỏ required đối với trường Excel `Email`, tương ứng `data.email`/`DNMua_Email` và tên nghiệp vụ `Địa chỉ thư điện tử`.
- Áp dụng đồng nhất cho:
  - Hóa đơn GTGT.
  - Hóa đơn bán hàng.
  - Hóa đơn vé xe.
  - Import trực tiếp tại `invoicecore`.
  - Import nền tại `svinvoicesendemail/AppServiceImportBillHost`.
- Email để trống không làm import thất bại nếu các dữ liệu khác hợp lệ.
- Nếu Email có giá trị thì vẫn validate định dạng và độ dài theo rule hiện tại.

## Acceptance Criteria

- **AC1:** GTGT có hàng hóa đặc trưng loại 1, Email trống, các trường khác hợp lệ thì không trả message required Email ở cả import trực tiếp và import nền.
- **AC2:** Bán hàng có hàng hóa đặc trưng loại 1, Email trống, các trường khác hợp lệ thì không trả message required Email ở cả import trực tiếp và import nền.
- **AC3:** Vé xe có hàng hóa đặc trưng loại 1, Email trống, các trường khác hợp lệ thì không trả message required Email ở cả import trực tiếp và import nền.
- **AC4:** Email có giá trị sai định dạng hoặc vượt giới hạn hiện tại vẫn bị từ chối; task không thay đổi regex hoặc maxlength.
- **AC5:** Các trường người mua còn lại `Tên`, `Địa chỉ`, `Số điện thoại`, `Mã tỉnh`, `Mã xã` và các rule hàng hóa đặc trưng khác giữ nguyên.
- **AC6:** Hóa đơn có dòng cha không phải hàng hóa đặc trưng nhưng dòng con là `tinhchat = 4`, loại đặc trưng 1 cũng được phép bỏ trống Email ở dòng thông tin hóa đơn cha.
- **AC7:** Template cũ hoặc hóa đơn không có dòng hàng hóa đặc trưng loại 1 giữ nguyên hành vi import hiện tại.

## Ngoài phạm vi

- Không sửa frontend hoặc file mẫu Excel.
- Không sửa API tích hợp `api-cloud-service`.
- Không sửa DTO, entity, DB/schema, mapping lưu, XML/PDF hoặc queue contract.
- Không thay đổi maxlength, regex Email hoặc cấu hình gửi email tự động của luồng import thường.
- Không bỏ bắt buộc các trường thông tin người mua khác.

## Câu hỏi mở

Không có.

## Ảnh hưởng người dùng / dữ liệu

Người dùng có thể import ba loại hóa đơn nêu trên mà không nhập Email khi có hàng hóa đặc trưng loại 1. Dữ liệu cũ không cần chuyển đổi; Email có dữ liệu vẫn được lưu vào `DNMua_Email` như hiện tại.

## Tài liệu liên quan

- `features/CBCLOUDV2-9168/` - import hàng hóa đặc trưng.
- `features/CBCLOUDV2-9257/` - điều chỉnh required các field hàng hóa đặc trưng.
- `specs/system.md` - luồng import/worker hóa đơn.
