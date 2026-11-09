# Impact - CBCLOUDV2-9260

## 1. Mục đích

Đánh giá ảnh hưởng khi đổi bảy maxlength Hàng hóa đặc trưng loại 1 cho import GTGT, Bán hàng và Vé xe ở direct/background flow.

## 2. Phạm vi thay đổi

- Validation import: có, hai shared helper.
- Tenant DB: có, mở rộng năm cột string.
- Queue/API/DTO/template/XML tag: không đổi.
- Frontend: không.

## 3. Thành phần ảnh hưởng

| Service | File / vùng | Mức | Lý do |
|---|---|---|---|
| `invoicecore` | `NhapDSHoaDonExcelHelper.ValidateVehicleAssetImportDetailFields(...)` | Trung bình | Năm maxlength chi tiết |
| `invoicecore` | `ValidateVehicleAssetImportLocationFields(...)` | Trung bình | Siết Mã tỉnh/Mã xã |
| `invoicecore` | tenant SQL `vs_hd_chitiet_morong` | Cao | Năm cột cũ 200/300 nhỏ hơn rule mới |
| `svinvoicesendemail` | `VehicleAssetImportHelper.ValidateDetailFields(...)` | Trung bình | Worker dùng chung ba router |
| `svinvoicesendemail` | `ValidateLocationFields(...)` | Trung bình | Worker phải đồng nhất direct |
| `svinvoicesendemail` | `VehicleAssetImportHelperTests.cs` | Thấp | Boundary/gate/regression tests |

## 4. Dữ liệu

| DB column | Hiện có theo migration | Mới | Hành động |
|---|---:|---:|---|
| `sgcnatkthuat` | 200 | 255 | Mở rộng |
| `sspktclxxuong` hoặc tên thực tế | 200 | 255 | Xác nhận tên rồi mở rộng |
| `tltsdky` | 200 | 255 | Mở rộng |
| `ttmai` | 300 | 400 | Mở rộng |
| `tnhieu` | 200 | 255 | Mở rộng |

Không thu hẹp DB của `ma_tinh`/`ma_xa`; chỉ validation input đổi thành 2/5. Snapshot docs hiện chưa phản ánh đầy đủ nhóm cột mới và cần cập nhật ở Gate 2.

## 5. Xác nhận không ảnh hưởng

| Vùng | Lý do |
|---|---|
| Frontend/template Excel | Không đổi layout/cột |
| API và queue DTO | Không đổi contract |
| Parser/mapping | Chỉ đổi threshold |
| XML tag | Không đổi tên/cấu trúc |
| Required/enum/catalog | Giữ nguyên block hiện tại |
| Template cũ/subtype khác | Gate hiện tại giữ nguyên |
| Field ngoài bảy field | Không sửa constants |

## 6. Rủi ro

| Rủi ro | Mức | Xử lý |
|---|---|---|
| Code deploy trước DB | Cao | Migration mở rộng chạy trước code |
| Tên cột seri không đồng nhất giữa migration/repository | Cao | DBA kiểm tra schema thật trước SQL |
| Byte/ký tự hiện không đồng nhất | Cao | Helper ký tự phạm vi bảy field ở direct; test Unicode direct/background |
| Mã địa bàn cũ dài hơn giới hạn mới | Trung bình | Test và thông báo dữ liệu đầu vào mới |
| Worktree worker có thay đổi task khác | Trung bình | Không overwrite; implementation phải merge cẩn thận |

## 7. Chưa kiểm chứng

- Chưa xác nhận schema tenant runtime và tên cột seri.
- Worker đã có automated test theo ký tự; direct build pass nhưng chưa manual Unicode boundary.
- SQL migration đã tạo nhưng chưa được DBA review/apply.
- Chưa manual import sáu luồng.

## 8. Kết luận

Code và automated test đã hoàn tất, hai service build 0 error. Rủi ro còn ở mức cao cho tới khi DBA precheck/apply schema và QA kiểm tra sáu luồng direct/background trên tenant test.
