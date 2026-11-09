# Impact - CBCLOUDV2-9386

## 1. Mục đích

Bỏ required Địa chỉ thư điện tử khi import GTGT, Bán hàng và Vé xe có hàng hóa đặc trưng loại 1, đồng bộ giữa `invoicecore` và `svinvoicesendemail`.

## 2. Phạm vi thay đổi

- Chỉ logic: có, nới validation required.
- Đụng dữ liệu: Email trống có thể được lưu null/rỗng theo mapping hiện tại.
- Đổi schema/migration: không.
- Đổi contract API/queue: không.

## 3. Thành phần bị ảnh hưởng

### Backend

| Service | File / method | Mức | Lý do |
|---|---|---|---|
| `invoicecore` | `NhapDSHoaDonExcelHelper.ValidateVehicleAssetImportBuyerFields(...)` | Trung bình | Shared cho GTGT/Bán hàng/Vé xe trực tiếp |
| `svinvoicesendemail` | `VehicleAssetImportHelper.ValidateBuyerFields(...)` | Trung bình | Shared cho ba router import nền |
| `svinvoicesendemail` | `VehicleAssetImportHelperTests.cs` | Thấp | Cập nhật expected và regression |

### Frontend

Không ảnh hưởng; không sửa màn hình hoặc file mẫu.

### Database

| Bảng/cột | Thay đổi | Mức | Migration |
|---|---|---|---|
| `HD_HoaDon.DNMua_Email` / cột hiện tại | Không đổi schema; cho phép giá trị trống từ phạm vi task | Thấp | Không |

### Queue/tích hợp/cấu hình

Không đổi queue, message DTO, API, cấu hình gửi email, XML/PDF, FTP, HSM hoặc CQT.

## 4. Xác nhận không bị ảnh hưởng

| Vùng | Vì sao không bị ảnh hưởng |
|---|---|
| Parser và mapping Email | Vẫn đọc `Email` vào `data.email` và map `DNMua_Email` |
| Regex/maxlength | Chỉ xóa required; giữ validation khi có dữ liệu |
| Tên/Địa chỉ/SĐT/Tỉnh/Xã | Các required check vẫn giữ nguyên |
| Field hàng hóa đặc trưng | Không sửa validator chi tiết hoặc mapping |
| Template cũ/subtype khác 1 | Không thay đổi điều kiện kích hoạt helper |
| API tích hợp | Thuộc repo và task khác |

## 5. Rủi ro và hạn chế

| Rủi ro/hạn chế | Mức | Xử lý |
|---|---|---|
| Hai service trả kết quả khác nhau | Trung bình | Sửa cùng rule và đối chiếu file <=50/>50 dòng |
| Email sai được cho qua nhầm | Trung bình | Test invalid và maxlength sau khi bỏ required |
| Dòng con kích hoạt rule nhưng cha vẫn lỗi | Trung bình | Test riêng cấu trúc cha/con |
| Không có Email để gửi hóa đơn tự động | Trung bình | Task chỉ đổi required đặc trưng; không đổi cấu hình gửi email, BA/QA xác nhận hành vi nghiệp vụ |

## 6. Chưa được kiểm chứng

| Việc chưa làm | Vì sao |
|---|---|
| Manual GTGT/Bán hàng/Vé xe import trực tiếp `<= 50` dòng | Chưa có tenant/file kiểm thử runtime trong phiên làm việc |
| Manual GTGT/Bán hàng/Vé xe import nền `> 50` dòng | Chưa có tenant/file kiểm thử và chưa vận hành queue worker trong phiên làm việc |

Đã kiểm chứng tự động ngày 2026-09-08:

- `invoicecore`: build `HDDT.Application.csproj` thành công, 0 error.
- `svinvoicesendemail`: 35/35 test pass; build `AppService.sln` thành công, 0 error.
- Test khóa điều kiện nhận diện chỉ trả `true` khi `loaihanghoa == 4 && loaidactrung == 1`, bao gồm negative case `loaidactrung` null/2/3 và `loaihanghoa != 4`.

## 7. Kết luận

Code và automated test đã hoàn tất. Rủi ro còn lại ở mức trung bình cho tới khi regression thủ công đủ sáu luồng import và Email sai định dạng trên dữ liệu runtime.
