# CBCLOUDV2-9168 Expect - Import hang hoa dac trung xe

## Summary

Cap nhat import Excel cho hoa don GTGT, Ban hang, Ve xe de ho tro bo field hang hoa dac trung xe theo quy dinh moi. File import cu khong co cot moi van import binh thuong.

## Expected Behavior

- Chi ap dung rule moi khi dong import thoa dong thoi:
  - File import la template moi co cac cot hang hoa dac trung xe.
  - `tinhchat = 4`.
  - `loaihoadondactrung = 1`.
- File cu khong co cac cot moi khong bi validate thieu field moi.
- Dong khong thoa `tinhchat = 4` va `loaihoadondactrung = 1` khong bi validate bo field hang hoa dac trung xe.
- Import thanh cong phai luu:
  - `ma_tinh`, `ma_xa` vao `HD_HoaDon_MoRong` / `vs_hd_tonghop_morong`.
  - 16 field xe vao `HD_ChiTiet_MoRong` / `vs_hd_chitiet_morong`.
- `ma_tinh` phai ton tai trong `vs_danhmuc_tinh_thanh`.
- `ma_xa` phai ton tai trong `vs_danhmuc_xa_phuong` va thuoc dung `ma_tinh`.
- Neu query danh muc tinh/xa loi thi phai ghi log ngan gon, khong de import crash boi exception DB.

## Validation Message

- Message validate tra tieng Viet co dau.
- Ten field trong message phai dung ten chi tieu theo file quy dinh.
- Cac loi ton tai danh muc:
  - `Mã tỉnh không tồn tại.`
  - `Mã xã không tồn tại.`

## Out Of Scope

- Khong sua API tich hop/ký/XML truc tiep.
- Khong sua xuat Excel nang cao.
- Khong thay doi DB trong task nay.
- Khong validate them field ngoai cac field da ghi trong `plan.md`.
