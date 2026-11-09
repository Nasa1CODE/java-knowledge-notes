# CBCLOUDV2-8919 Plan

## Goal

Sửa luồng hiển thị CKTM để checkbox xuất hiện và được tick đúng trên 3 màn lập hóa đơn, đồng thời giữ đồng bộ với field lưu DB `QuanLy_XacThuc_Loai`.

## Context

- Checkbox CKTM hiện đang bind vào `tinhChatHoaDon`.
- Mỗi màn có condition hiển thị riêng, trước đó chỉ mở cho `mau_HoaDon_Loai == 1`.
- Với hóa đơn thay thế/điều chỉnh, BE trả `QuanLy_XacThuc_Loai` trong DTO hóa đơn gốc nhưng FE không copy sang object đang render.
- Field persist của checkbox là `QuanLy_XacThuc_Loai` trên `vs_hd_tonghop`.

## Assumptions

- Hóa đơn loại `3` và `5` cần dùng cùng checkbox CKTM như hóa đơn loại `1`.
- Trạng thái checkbox của hóa đơn thay thế/điều chỉnh nên kế thừa từ hóa đơn gốc nếu có.
- Không thay đổi luồng save/sign hiện có.

## Out Of Scope

- Không sửa BE `GetHoaDonBiDieuChinh`.
- Không sửa schema DB.
- Không đổi cách tính CKTM/tổng tiền.
- Không thêm checkbox mới ở màn khác ngoài 3 màn đã nêu.

## Impact Assessment

| Layer | File / Component | Impact level | Ghi chú |
| --- | --- | --- | --- |
| Frontend | `src/app/hddt/hoadon/vemaybay/vemaybay.component.html` | Trung bình | Mở condition hiển thị checkbox |
| Frontend | `src/app/hddt/hoadon/vemaybay/vemaybay.component.ts` | Trung bình | Map trạng thái từ `hoaDonGoc` |
| Frontend | `src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html` | Trung bình | Mở condition hiển thị checkbox |
| Frontend | `src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts` | Trung bình | Map trạng thái từ `hoaDonGoc` |
| Frontend | `src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.html` | Trung bình | Mở condition hiển thị checkbox |
| Frontend | `src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts` | Trung bình | Map trạng thái từ `hoaDonGoc` |
| Database | `vs_hd_tonghop.QuanLy_XacThuc_Loai` | Thấp | Field lưu trạng thái đã có sẵn |

## Implementation Steps

1. Mở condition checkbox cho `mau_HoaDon_Loai == 1 || 3 || 5` trên cả 3 màn.
2. Với hóa đơn thay thế/điều chỉnh, copy `hoaDonGoc.quanLy_XacThuc_Loai` sang `hoaDon.quanLy_XacThuc_Loai`.
3. Giữ nguyên binding hiện có của `tinhChatHoaDon`.
4. Giữ nguyên logic save để field vẫn đi xuống `QuanLy_XacThuc_Loai`.
5. Cập nhật docs task, impact, report, testcase.

## Verification

- Kiểm tra checkbox hiển thị trên:
  - `/app/hddt/vemaybay`
  - `/app/hddt/hoadon-hoadonbanhang-goc`
  - `/app/hddt/hoadon-hoadon-goc`
- Manual check loại `1`, `3`, `5`.
- Manual check trạng thái tick theo `hoaDonGoc.quanLy_XacThuc_Loai`.
- Build FE nếu môi trường cho phép.
