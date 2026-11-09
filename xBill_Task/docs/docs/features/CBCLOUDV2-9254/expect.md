# CBCLOUDV2-9254 Expect

## Title

[Phat sinh sau nang cap][CLOUD] Khong lay len day du du lieu VBTT

## Scope

Sua danh sach Van ban thoa thuan (VBTT) tren Cloud de hien thi day du cac VBTT khach hang da tao, bao gom du lieu cu co file/ten VBTT tren hoa don nhung ban ghi `vs_hd_bienbanthoathuan` bi thieu `TongHop_Id`.

Endpoint chinh:

- `GET /api/services/hddt/VanBanThoaThuan/GetDSHoaDon`
- Man hinh: `/app/hddt/hoadon/vanbanthoathuan`

## Current Behavior

- Danh sach VBTT khong lay len cac hoa don co `QuanLy_VanBanThoaThuan` nhung navigation `HD_BienBanThoaThuan` khong join duoc do `vs_hd_bienbanthoathuan.TongHop_Id IS NULL`.
- Nguyen nhan: query bat buoc `e.HD_BienBanThoaThuan != null`.

## Expected Behavior

- Danh sach VBTT hien thi cac hoa don da co `QuanLy_VanBanThoaThuan`.
- Khong bat buoc ban ghi bien ban phai co `TongHop_Id` moi duoc hien thi.
- Van giu rule loai tru `KieuBienBan = 1` (van ban chung tu) khi xac dinh duoc bien ban qua `TongHop_Id` hoac `QuanLy_VanBan_Id`.
- Cac filter hien co van giu nguyen:
  - `loaihd = 1`: hoa don dieu chinh va hoa don goc co VBTT.
  - `loaihd = 2`: hoa don thay the.
  - `loaihd = 3`: hoa don xoa bo.
  - `filter`: tim theo `Mau_HopDong_So` hoac `DNMua_Ten`.
- Chuc nang xem/tai file VBTT theo `record.id` tiep tuc hoat dong.

## Out Of Scope

- Khong sua schema DB.
- Khong cap nhat du lieu cu hang loat.
- Khong doi luong tao/sua VBTT.
- Khong doi API tra cuu ngoai public.
- Khong doi logic file storage VBTT.
