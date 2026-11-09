# CBCLOUDV2-9181 Test Cases

## TC01 - Edit hoa don dieu chinh da bo tick CKTM

- Preconditions:
  - Hoa don goc co `QuanLy_XacThuc_Loai = 1`.
  - Hoa don dieu chinh `mau_HoaDon_Loai = 5` da luu `QuanLy_XacThuc_Loai = 0`.
- Steps:
  1. Goi `GetHoaDon?Id=<id dieu chinh>&isView=false`.
  2. Xac nhan response top-level `quanLy_XacThuc_Loai = 0`.
  3. Mo man edit hoa don dieu chinh.
- Expected:
  - Checkbox "Hoa don chiet khau thuong mai" khong tick.
  - UI khong lay `hoaDonGoc.quanLy_XacThuc_Loai = 1` de tick lai.

## TC02 - Edit hoa don dieu chinh da tick CKTM

- Preconditions:
  - Hoa don dieu chinh `mau_HoaDon_Loai = 5` da luu `QuanLy_XacThuc_Loai = 1`.
- Steps:
  1. Mo man edit hoa don dieu chinh.
- Expected:
  - Checkbox tick.

## TC03 - Tao moi hoa don dieu chinh van ke thua tu hoa don goc

- Preconditions:
  - Hoa don goc co `QuanLy_XacThuc_Loai = 1`.
  - Dang tao moi hoa don dieu chinh, chua co `id`.
- Steps:
  1. Tao hoa don dieu chinh tu hoa don goc.
- Expected:
  - Checkbox tick mac dinh nhu luong cu cua `CBCLOUDV2-8919`.

## TC04 - Edit hoa don thay the da bo tick CKTM

- Preconditions:
  - Hoa don goc co `QuanLy_XacThuc_Loai = 1`.
  - Hoa don thay the `mau_HoaDon_Loai = 3` da luu `QuanLy_XacThuc_Loai = 0`.
- Steps:
  1. Goi `GetHoaDon?Id=<id thay the>&isView=false`.
  2. Mo man edit hoa don thay the.
- Expected:
  - Checkbox khong tick.

## TC05 - Tao moi hoa don thay the van ke thua tu hoa don goc

- Preconditions:
  - Hoa don goc co `QuanLy_XacThuc_Loai = 1`.
  - Dang tao moi hoa don thay the, chua co `id`.
- Steps:
  1. Tao hoa don thay the tu hoa don goc.
- Expected:
  - Checkbox tick mac dinh.

## TC06 - Save sau khi doi checkbox

- Steps:
  1. Mo hoa don dieu chinh/thay the dang edit.
  2. Tick checkbox va luu.
  3. Kiem tra request `CreateOrEditInv`.
  4. Bo tick checkbox va luu lai.
- Expected:
  - Khi tick, request gui top-level `quanLy_XacThuc_Loai = 1`.
  - Khi bo tick, request gui top-level `quanLy_XacThuc_Loai = 0`.
  - DB `vs_hd_tonghop.QuanLy_XacThuc_Loai` cap nhat theo request.

## TC07 - Hoa don goc khong bi anh huong

- Steps:
  1. Mo hoa don goc `mau_HoaDon_Loai = 1`.
  2. Tick/bo tick checkbox va luu.
- Expected:
  - Hanh vi nhu truoc task.
  - Khong phu thuoc `hoaDonGoc`.
