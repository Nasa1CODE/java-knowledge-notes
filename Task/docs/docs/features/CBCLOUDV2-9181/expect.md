# CBCLOUDV2-9181 Expect

## Scope

Sua rieng hanh vi load state checkbox "Hoa don chiet khau thuong mai" tren cac man lap hoa don da duoc cap nhat trong `CBCLOUDV2-8919`.

Ap dung cho:

- Hoa don thay the: `mau_HoaDon_Loai = 3`.
- Hoa don dieu chinh: `mau_HoaDon_Loai = 5`.
- Cac man co checkbox CKTM:
  - `hoadon-goc`
  - `hoadonbanhang`
  - `vemaybay`

## Expected Behavior

- Khi tao moi hoa don thay the/dieu chinh tu hoa don goc:
  - Neu hoa don goc co `quanLy_XacThuc_Loai = 1`, checkbox mac dinh tick.
  - Neu hoa don goc co `quanLy_XacThuc_Loai = 0`, checkbox mac dinh bo tick.
- Khi edit hoa don thay the/dieu chinh da ton tai:
  - Checkbox phai theo top-level `hoaDon.quanLy_XacThuc_Loai` cua hoa don hien tai.
  - Khong duoc overwrite bang `hoaDon.hoaDonGoc.quanLy_XacThuc_Loai`.
- Neu API tra:

```json
{
  "quanLy_XacThuc_Loai": 0,
  "hoaDonGoc": {
    "quanLy_XacThuc_Loai": 1
  }
}
```

thi checkbox phai bo tick.

- Neu API tra top-level `quanLy_XacThuc_Loai = 1`, checkbox phai tick.
- Khi nguoi dung thay doi checkbox, save tiep tuc gui top-level `quanLy_XacThuc_Loai` theo gia tri checkbox.

## Out Of Scope

- Khong sua API `GetHoaDon`.
- Khong sua `CreateOrEditInv`.
- Khong sua DB/schema.
- Khong doi logic tinh tien CKTM.
- Khong doi visibility checkbox da mo trong `CBCLOUDV2-8919`.
