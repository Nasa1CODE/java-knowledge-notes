# Expect - CBCLOUDV2-9260: Điều chỉnh maxlength khi import Hàng hóa đặc trưng 1

status: testing
services-affected: invoicecore, svinvoicesendemail

## Bối cảnh

Tài liệu Hàng hóa đặc trưng 1 mới thay đổi giới hạn độ dài của bảy trường khi import hóa đơn GTGT, Bán hàng và Vé xe. Validation hiện tại trong luồng import trực tiếp và import nền vẫn dùng giới hạn cũ, vì vậy dữ liệu hợp lệ theo tài liệu mới có thể bị từ chối hoặc dữ liệu mã địa bàn dài hơn quy định mới vẫn được chấp nhận.

## Đối tượng và luồng áp dụng

- Người dùng import Excel hóa đơn GTGT, Bán hàng hoặc Vé xe.
- Luồng trực tiếp xử lý tại `invoicecore` và luồng nền xử lý tại `svinvoicesendemail`.
- Chỉ áp dụng cho template mới và dòng đồng thời có `loaihanghoa = 4`, `loaidactrung = 1` (Hàng hóa đặc trưng loại 1).

## Bảng giới hạn mới

| # | Tên trường | Property import | Giới hạn cũ | Giới hạn mới |
|---|---|---|---:|---:|
| 1 | Mã tỉnh | `ma_tinh` | 3 | 2 |
| 2 | Mã xã | `ma_xa` | 8 | 5 |
| 3 | Tên loại tài sản đăng ký | `ten_loaitaisan` | 200 | 255 |
| 4 | Tên nhãn hiệu | `ten_nhanhieu` | 200 | 255 |
| 5 | Số Giấy chứng nhận chất lượng an toàn kỹ thuật và bảo vệ môi trường (đối với xe nhập khẩu) | `sogiaychungnhanatkt` | 200 | 255 |
| 6 | Số seri Phiếu kiểm tra chất lượng xuất xưởng (xe sản xuất, lắp ráp trong nước) | `soseripktcl` | 200 | 255 |
| 7 | Tên thương mại | `ten_thuongmai` | 300 | 400 |

## Mong muốn

- Hai luồng import áp dụng đúng bảy giới hạn mới và trả message đúng tên trường khi vượt giới hạn.
- Giá trị đúng bằng giới hạn mới được chấp nhận; giá trị vượt một đơn vị bị từ chối.
- Ba loại hóa đơn có hành vi đồng nhất giữa file xử lý trực tiếp và file chuyển sang worker.
- Giữ nguyên required, enum, danh mục tỉnh/xã, parser, mapping DB/XML và maxlength của mọi trường không có trong bảng.
- Dữ liệu được nới maxlength phải lưu đầy đủ, không truncate và không lỗi do cột DB còn giới hạn cũ.

## Acceptance Criteria

- **AC1:** Import trực tiếp GTGT, Bán hàng và Vé xe với template mới, dòng `loaihanghoa = 4`, `loaidactrung = 1` áp dụng đúng cả bảy giới hạn mới.
- **AC2:** Import nền của ba loại hóa đơn áp dụng cùng bảy giới hạn mới như import trực tiếp.
- **AC3:** Với từng trường, dữ liệu đúng bằng giới hạn mới không sinh lỗi maxlength; dữ liệu vượt một đơn vị sinh message `không được vượt quá <N> ký tự` tương ứng.
- **AC4:** Template cũ, dòng `loaihanghoa != 4` hoặc `loaidactrung != 1` không kích hoạt rule maxlength Hàng hóa đặc trưng 1 mới.
- **AC5:** Required và validation nghiệp vụ hiện có của bảy trường giữ nguyên; đặc biệt chứng từ theo `xuatxu`, danh mục tỉnh/xã và điều kiện xe đã qua sử dụng không bị thay đổi.
- **AC6:** Năm trường được nới giới hạn lưu đầy đủ vào `vs_hd_chitiet_morong`; không truncate hoặc lỗi kích thước cột. Hai mã địa bàn tiếp tục map vào bảng mở rộng hóa đơn theo logic hiện tại.
- **AC7:** Không thay đổi API/queue/DTO Excel, vị trí cột, XML tag, frontend hoặc maxlength của field ngoài danh sách.

## Ngoài phạm vi

- Không sửa frontend hoặc file template Excel.
- Không sửa API tích hợp `api-cloud-service`.
- Không thay đổi required, kiểu dữ liệu, enum hoặc điều kiện theo `tinhtrangtaisan`/`xuatxu`.
- Không đổi tên XML tag hoặc mapping property.
- Không chuẩn hóa maxlength của field ngoài danh sách; bảy giới hạn mới được tính theo số ký tự như tài liệu nghiệp vụ.

## Câu hỏi mở

| # | Câu hỏi | Người trả lời | Trạng thái |
|---|---|---|---|
| 1 | Đơn vị maxlength | Source review | Đã chốt theo số ký tự; tài liệu và message nghiệp vụ đều ghi ký tự |
| 2 | Tên cột DB seri | Source review + DBA precheck | Dùng `sspktclxxuong` theo repository/mapping; `SHOW COLUMNS` bắt buộc trước deploy do migration cũ có typo |

## Ảnh hưởng người dùng / dữ liệu

Người import có thể nhập chuỗi dài hơn cho năm trường mô tả và phải dùng mã tỉnh hai ký tự, mã xã năm ký tự. Dữ liệu cũ không cần chuyển đổi; schema chỉ cần mở rộng các cột mô tả trước khi bật validation mới.

## Tài liệu liên quan

- [Ảnh mô tả maxlength CBCLOUDV2-9260](extract/maxlength-requirement.png).
- `features/CBCLOUDV2-9167/plan.md`.
- `features/CBCLOUDV2-9257/` và `features/CBCLOUDV2-9386/`.
- `specs/system.md`, `architecture.md`.
