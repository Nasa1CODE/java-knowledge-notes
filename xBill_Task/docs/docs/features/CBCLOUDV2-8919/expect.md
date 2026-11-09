# CBCLOUDV2-8919 Expect

## Feature Status

- Status: done
- Class: XS

## Business Goal

Hiển thị và đồng bộ đúng checkbox `Hóa đơn chiết khấu thương mại` trên các màn lập hóa đơn vé máy bay, hóa đơn bán hàng và hóa đơn gốc.

## Scope

- Frontend: `frontend_angular/`
- Screens:
  - `/app/hddt/vemaybay`
  - `/app/hddt/hoadon-hoadonbanhang-goc`
  - `/app/hddt/hoadon-hoadon-goc`
- Related DB field: `vs_hd_tonghop.QuanLy_XacThuc_Loai`

## Expected Behavior

- Checkbox CKTM hiện cho hóa đơn loại `1`, `3`, `5`.
- Checkbox được tick sẵn khi hóa đơn gốc có `QuanLy_XacThuc_Loai = 1`.
- Với hóa đơn thay thế/điều chỉnh, trạng thái checkbox được lấy từ hóa đơn gốc nếu có.
- Khi user bỏ tick, giá trị lưu xuống là `0`.
- Khi user tick, giá trị lưu xuống là `1`.

## Out Of Scope

- Không đổi cấu trúc DB.
- Không đổi API `GetHoaDonBiDieuChinh`.
- Không đổi logic tính tổng CKTM `TongHop_TongTien_KhoanKhac`.
- Không đổi logic ký/lưu hóa đơn ngoài field checkbox này.

## Acceptance Criteria

- Màn `vemaybay` hiển thị checkbox CKTM cho `mau_HoaDon_Loai` 1, 3, 5.
- Màn `hoadonbanhang` hiển thị checkbox CKTM cho `mau_HoaDon_Loai` 1, 3, 5.
- Màn `hoadon-goc` hiển thị checkbox CKTM cho `mau_HoaDon_Loai` 1, 3, 5.
- Hóa đơn thay thế/điều chỉnh lấy đúng trạng thái từ `hoaDonGoc.quanLy_XacThuc_Loai`.
- Lưu hóa đơn vẫn ghi đúng `QuanLy_XacThuc_Loai` lên DB.
