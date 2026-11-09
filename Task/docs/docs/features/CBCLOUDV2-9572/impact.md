---
feature: CBCLOUDV2-9572
updated_at: 2026-09-14
---

# Impact - CBCLOUDV2-9572

## Phạm Vi Ảnh Hưởng

| Thành phần | Ảnh hưởng dự kiến |
|---|---|
| Import Bán hàng | Cần validate lại người mua khi có hàng hóa đặc trưng `1` |
| Import GTGT | Cần validate lại người mua khi có hàng hóa đặc trưng `1` |
| Import Vé xe | Cần validate lại người mua khi có hàng hóa đặc trưng `1` |
| Service nền `svinvoicesendemail` | Cần sửa đồng bộ validator import nền, vì service có helper riêng |
| Validate người mua | `<Ten>` và `<MST>` bắt buộc; `<CCCDan>` không bắt buộc |
| Mapping DB/XML | Không đổi schema; chỉ đảm bảo dữ liệu bắt buộc trước khi lưu/sinh |
| File mẫu | Chưa dự kiến đổi layout |

## Tác Động Nghiệp Vụ

Khi import hóa đơn có hàng hóa đặc trưng loại `1`, user phải nhập đủ:

- Tên đơn vị người mua để sinh `<Ten>`.
- MST/CCCD chủ hộ để sinh `<MST>`.

User không bắt buộc nhập CCCD để sinh `<CCCDan>`. Trường `<CCCDan>` chỉ sinh/lưu khi có dữ liệu theo mapping hiện tại.

Rule chỉ áp dụng khi import đang bật NĐ254 qua `ACTIVE_ND_254`/`IsActiveND254()` và hóa đơn có hàng hóa đặc trưng loại `1`.

## Ghi Chú Service Nền

`D:\XBill\Cloud\svinvoicesendemail` cần được test cùng `invoicecore`, vì import nền đang có helper riêng:

| Luồng | File cần chú ý | Điểm cần kiểm |
|---|---|---|
| Gate NĐ254 | `AppServiceImportBillHost\AppService\Process.cs` dòng 182, 328 | Đã lấy `ACTIVE_ND_254` qua `IsActiveND254()` |
| GTGT nền | `Service\NhapDSHoaDonExcelHelper.cs` dòng 100, 1177 | Validate NĐ254 chạy khi `activeND254` và dòng đặc trưng `1` |
| Bán hàng nền | `Service\BanHang_ExcelHelper.cs` dòng 95, 967 | Validate NĐ254 chạy khi `activeND254` và dòng đặc trưng `1` |
| Vé xe nền | `Service\ImportVeXeHelper.cs` dòng 220, 1203 | Validate NĐ254 chạy khi `activeND254` và dòng đặc trưng `1` |
| Validator chung | `Models\VehicleAssetImportHelper.cs` method `ValidateBuyerFields` | Cần thêm required `tendonvi` và `mst`; không required `cccd` |

Hiện trạng service nền: `ValidateBuyerFields` đang bắt buộc `nguoimuahang`, `diachi`, `sdt`, nhưng chưa bắt buộc `tendonvi` và `mst`. Vì `<Ten>` đang map từ `tendonvi`, `<MST>` map từ `mst`, nếu chỉ sửa `invoicecore` thì import qua service nền vẫn có thể lọt file thiếu hai trường này.

## Ghi Chú Cho Tester

Tester cần test đủ ba loại import:

- Bán hàng.
- GTGT.
- Vé xe.

Với mỗi loại import, cần test các nhóm case:

| Case | Input | Kỳ vọng |
|---|---|---|
| 1 | Có hàng hóa đặc trưng `1`, thiếu tên đơn vị | Import báo lỗi required `<Ten>` |
| 2 | Có hàng hóa đặc trưng `1`, tên đơn vị toàn whitespace | Import báo lỗi required `<Ten>` |
| 3 | Có hàng hóa đặc trưng `1`, thiếu MST/CCCD chủ hộ | Import báo lỗi required `<MST>` |
| 4 | Có hàng hóa đặc trưng `1`, MST/CCCD chủ hộ toàn whitespace | Import báo lỗi required `<MST>` |
| 5 | Có hàng hóa đặc trưng `1`, thiếu CCCD | Import không báo lỗi required `<CCCDan>` |
| 6 | Có hàng hóa đặc trưng `1`, đủ tên đơn vị và MST, CCCD rỗng | Import thành công nếu không lỗi rule khác |
| 7 | Không có hàng hóa đặc trưng `1`, thiếu tên/MST/CCCD | Giữ hành vi validate cũ của import |
| 8 | Hàng hóa đặc trưng loại `2/3`, thiếu CCCD | Không áp rule required của loại `1` |
| 9 | `ACTIVE_ND_254` tắt, có hàng hóa đặc trưng `1`, thiếu tên đơn vị/MST | Giữ hành vi cũ, không bật rule required mới |
| 10 | Import qua service nền, có hàng hóa đặc trưng `1`, thiếu tên đơn vị | Service nền báo lỗi giống import trực tiếp |
| 11 | Import qua service nền, có hàng hóa đặc trưng `1`, thiếu MST/CCCD chủ hộ | Service nền báo lỗi giống import trực tiếp |
| 12 | Import qua service nền, có hàng hóa đặc trưng `1`, thiếu CCCD | Service nền không báo lỗi required `<CCCDan>` |

## Rủi Ro

| Rủi ro | Mức | Kiểm soát |
|---|---|---|
| Một luồng import còn bắt buộc CCCD | Cao | Test đủ BH/GTGT/Vé xe với CCCD rỗng |
| Chỉ sửa một loại import, bỏ sót loại khác | Cao | Search source theo ba router/helper import |
| Sửa `invoicecore` nhưng bỏ sót service nền | Cao | Test thêm `svinvoicesendemail` với cùng bộ case |
| Bắt buộc tên/MST cho cả hóa đơn không có hàng hóa đặc trưng `1` | Trung bình | Test case không có loại `1` |
| Rule chạy khi `ACTIVE_ND_254` tắt | Trung bình | Test tắt config và import lại file thiếu tên/MST |
| Message lỗi không rõ dòng import | Trung bình | Giữ pattern báo lỗi hiện tại, kiểm tra file nhiều dòng |
| Validate bị duplicate và trả lỗi lặp | Thấp | Ưu tiên helper chung hoặc guard không lặp theo hóa đơn |

## Rollback

Rollback source validate import về trạng thái trước task. Không cần rollback DB/schema vì task không thay đổi cấu trúc dữ liệu.
