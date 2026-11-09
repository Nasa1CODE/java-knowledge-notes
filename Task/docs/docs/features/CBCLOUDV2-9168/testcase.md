# CBCLOUDV2-9168 Testcase - Import hang hoa dac trung xe

## Precondition

- Co file mau moi cho GTGT, Ban hang, Ve xe voi cac cot hang hoa dac trung xe.
- Co file mau cu tuong ung khong co cac cot moi.
- Co du lieu danh muc:
  - `vs_danhmuc_tinh_thanh`.
  - `vs_danhmuc_xa_phuong`.
- Co moi truong chay du 2 nhanh:
  - Import truc tiep file <= 50 dong.
  - Import nen file > 50 dong.

## Test Cases

| ID | Scenario | Steps | Expected Result | Status |
|---|---|---|---|---|
| TC-01 | GTGT file cu | Import file GTGT cu khong co cot moi | Import thanh cong nhu cu, khong bao thieu field moi | not run |
| TC-02 | Ban hang file cu | Import file Ban hang cu khong co cot moi | Import thanh cong nhu cu | not run |
| TC-03 | Ve xe file cu | Import file Ve xe cu khong co cot moi | Import thanh cong nhu cu | not run |
| TC-03.1 | GTGT file cu co dong dac thu xe cu | Import file GTGT cu khong co cum cot moi, nhung co dong `tinhchat = 4` va `loaihoadondactrung = 1` | Khong validate `ma_tinh`, `ma_xa` va 16 field xe moi | not run |
| TC-04 | File moi nhung `tinhchat != 4` | Import file moi, dong hang co `tinhchat` khac 4 | Khong validate field xe | not run |
| TC-05 | File moi, `tinhchat = 4`, `loaihoadondactrung != 1` | Import dong khong phai hang hoa dac trung xe | Khong validate field xe | not run |
| TC-06 | File moi kich hoat rule du field | Import dong `tinhchat = 4`, `loaihoadondactrung = 1`, du field bat buoc | Import thanh cong, luu `ma_tinh`, `ma_xa` va 16 field xe dung DB | not run |
| TC-07 | Thieu `ma_tinh` | Import dong kich hoat rule thieu `ma_tinh` | Bao loi `Mã tỉnh không được để trống.` | not run |
| TC-08 | Thieu `ma_xa` | Import dong kich hoat rule thieu `ma_xa` | Bao loi `Mã xã không được để trống.` | not run |
| TC-09 | `ma_tinh` khong ton tai | Import dong kich hoat rule voi `ma_tinh` khong co trong danh muc | Bao loi `Mã tỉnh không tồn tại.` | not run |
| TC-10 | `ma_xa` khong ton tai | Import dong kich hoat rule voi `ma_xa` khong co trong danh muc | Bao loi `Mã xã không tồn tại.` | not run |
| TC-11 | `ma_xa` khong thuoc `ma_tinh` | Import dong co `ma_tinh` hop le, `ma_xa` hop le nhung khong thuoc tinh do | Bao loi `Mã xã không tồn tại.` | not run |
| TC-12 | Query danh muc tinh/xa loi | Gia lap loi query danh muc khi import file moi kich hoat rule | Co log ngan gon, import khong crash boi exception DB, validate bao ma tinh/ma xa khong ton tai | not run |
| TC-13 | Xe nhap khau | `xuatxu = 1`, co `sogiaychungnhanatkt` | Import thanh cong | not run |
| TC-14 | Xe trong nuoc | `xuatxu = 0`, co `soseripktcl` | Import thanh cong | not run |
| TC-15 | Thieu field dieu kien nhap khau | `xuatxu = 1`, thieu `sogiaychungnhanatkt` | Bao loi dung ten field | not run |
| TC-16 | Thieu field dieu kien trong nuoc | `xuatxu = 0`, thieu `soseripktcl` | Bao loi dung ten field | not run |
| TC-17 | Xe da qua su dung du field | `tinhtrangtaisan = 1`, co `chatluongtaisan`, `sobienkiemsoat` | Import thanh cong | not run |
| TC-18 | Xe da qua su dung thieu field | `tinhtrangtaisan = 1`, thieu `chatluongtaisan` hoac `sobienkiemsoat` | Bao loi dung ten field | not run |
| TC-19 | Validate do dai `ma_tinh` | Truyen `ma_tinh` qua 3 ky tu | Bao loi do dai | not run |
| TC-20 | Validate do dai `ma_xa` | Truyen `ma_xa` qua 8 ky tu | Bao loi do dai | not run |
| TC-21 | Validate format `trongtai` | Dong kich hoat rule, truyen `trongtai` vuot `decimal 9,2`, vi du `12345678.12` | Bao loi `Trọng tải dữ liệu không hợp lệ.` | not run |
| TC-22 | Validate format `sochongoi` | Dong kich hoat rule, truyen `sochongoi` vuot 4 chu so, vi du `10000` | Bao loi `Số người cho phép chở dữ liệu không hợp lệ.` | not run |
| TC-23 | Validate format `chatluongtaisan` | Dong kich hoat rule, `tinhtrangtaisan = 1`, truyen `chatluongtaisan` vuot `decimal 4,2`, vi du `123.45` | Bao loi `Chất lượng tài sản % dữ liệu không hợp lệ.` | not run |
| TC-24 | Validate format `chatluongtaisan` khi xe chua qua su dung | Dong kich hoat rule, `tinhtrangtaisan = 0`, van truyen `chatluongtaisan` vuot `decimal 4,2`, vi du `123.45` | Bao loi `Chất lượng tài sản % dữ liệu không hợp lệ.`, khong de loi DB `cltsan` | not run |
| TC-25 | Import nen > 50 dong | Import file moi > 50 dong qua worker | Ket qua validate/map giong BE truc tiep | not run |
| TC-26 | Mot hoa don nhieu dong, chi dong chinh co thong tin nguoi mua | Import file moi co 1 hoa don gom nhieu dong chi tiet; dong dau co `nguoimuahang`, `diachi`, `ma_tinh`, `ma_xa`, `sdt`, `email`; cac dong chi tiet con de trong cac field nay | Khong bao loi lap `Tên`, `Địa chỉ`, `Mã tỉnh`, `Mã xã`, `Số điện thoại`, `Địa chỉ thư điện tử` tren dong chi tiet con | not run |
| TC-27 | Dong hoa don chinh thieu thong tin cap hoa don | Import file moi co dong xe dac trung, dong hoa don chinh thieu `ma_tinh` hoac `ma_xa` | Chi bao loi field cap hoa don theo dong hoa don chinh, khong lap loi theo tung dong chi tiet con | not run |
| TC-28 | Dong chi tiet con thieu field xe | Import file moi nhieu dong, dong chi tiet con co `tinhchat = 4`, `loaihoadondactrung = 1` nhung thieu `sokhung` hoac `somay` | Van bao loi 16 field xe theo dung dong chi tiet con | not run |

## Coverage theo file testcase Google Sheet

Da doi chieu 3 sheet:

| Sheet | Tong case | Da dat uoc tinh sau fix | Con thieu |
|---|---:|---:|---:|
| `Import GTGT` | 412 | 412 | 0 |
| `Import BH` | 412 | 412 | 0 |
| `Import KHAC` / Ve xe | 412 | 412 | 0 |

6 case truoc do con thieu moi sheet deu nam o nhanh import nen `> 50` va da duoc bo sung:

- HD thuong `> 50`: `trongtai` vuot `decimal 9,2`, `sochongoi` vuot 4 chu so, `chatluongtaisan` vuot `decimal 4,2`.
- HD MTT `> 50`: `trongtai` vuot `decimal 9,2`, `sochongoi` vuot 4 chu so, `chatluongtaisan` vuot `decimal 4,2`.

## FE - Cot `So khung` / `So may` va co `ACTIVE_ND_254`

| ID | Form | Dieu kien | Ket qua mong doi |
|---|---|---|---|
| FE01 | `hoadonbanhang` | Co `ACTIVE_ND_254` = tat, dong chi tiet co `hangHoa_Loai = 4` | Van chon duoc `Hang hoa dac trung`, van hien cot `Loai HHDT`, hien 2 cot `So khung`/`So may`, khong hien panel xe ND254 |
| FE02 | `hoadon-goc` | Co `ACTIVE_ND_254` = tat, dong chi tiet co `hangHoa_Loai = 4` | Giong FE01: hien 2 cot `So khung`/`So may` (moi bo sung), khong hien panel xe ND254 |
| FE03 | `hoadon-goc` | Co bat, dong chi tiet co `hangHoa_Loai = 4` va `loai_HangHoa_DacTrung = 1` (`hasSpecialVehicle()` = true) | An 2 cot `So khung`/`So may` o bang chi tiet, hien panel xe ND254 chua day du field xe |
| FE04 | `hoadon-goc` | Nhu FE03 | Colspan cua dong panel xe khop so cot header, bang khong bi vo layout |
| FE05 | `hoadon-goc` | Co tat, nhap `So khung`/`So may` roi luu hoa don | Gia tri luu dung vao `hD_ChiTiet_MoRong.so_Khung` / `so_May` |
| FE06 | `hoadon-goc` | Mo lai HD goc da luu o che do readonly, co tat | 2 cot hien gia tri `so_Khung`/`so_May` va o trang thai `disabled` |
| FE07 | `hoadon-goc` | Truong hop DCTT nhieu hoa don (`isDCTTNhieuHoaDon` = true), co tat | 2 o nhap `So khung`/`So may` bi `disabled` |
| FE08 | `vemaybay` | Co bat hoac tat | Khong doi hanh vi so voi truoc task; form khong doc co |

## Regression

- GTGT/Ban hang/Ve xe file cu voi nhieu dong chi tiet.
- Dong khuyen mai/chiet khau/ghi chu trong file cu.
- File moi co mot so dong kich hoat rule va mot so dong khong kich hoat rule.
- File moi mot hoa don nhieu dong chi tiet, chi dong hoa don chinh co thong tin nguoi mua/dia ban.
- Message validate phai la tieng Viet co dau.
