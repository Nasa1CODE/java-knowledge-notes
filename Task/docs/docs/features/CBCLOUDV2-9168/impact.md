# CBCLOUDV2-9168 Impact - Import hang hoa dac trung xe

## Pham Vi Anh Huong

Task chi anh huong luong import Excel cho hoa don GTGT, Ban hang, Ve xe.

| Thanh phan | Anh huong |
|---|---|
| `\XBill\Cloud\invoicecore` | Import truc tiep file <= 50 dong; map/validate field moi; validate danh muc tinh/xa |
| `\XBill\Cloud\svinvoicesendemail` | Import nen file > 50 dong; dong bo map/validate voi BE |
| Database | Khong thay doi schema trong task nay |
| API tich hop/ký/XML | Khong anh huong |
| Xuat Excel nang cao | Khong anh huong |
| `frontend_angular` | Co `ACTIVE_ND_254` chi an/hien panel xe ND254 va validate/Tinh-Xa lien quan o `hoadon-goc`, `hoadonbanhang`; option `Hang hoa dac trung`, cot `Loai HHDT` va cot cu `So khung`/`So may` giu nhu truoc task; `vemaybay` khong doc/gate co vi khong co panel xe |
| Bang chi tiet 2 form `hoadon-goc`, `hoadonbanhang` | Da dong bo: khi `!hasSpecialVehicle()` (khong active panel xe) thi hien 2 cot rieng `So khung`/`So may` theo `soKhungColunm`/`soMayColunm`. `hoadon-goc` truoc day khong co 2 cot nay -> co them 2 cot moi trong bang chi tiet |
| Endpoint `DoanhNghiep_ThongTinChung.GetActiveND254` | Doc co global tren host DB, khong loc `DaiLy_Id` |

## Feature Flag ACTIVE_ND_254

- Co host `vs_dm_ncc_cauhinh` (`isdeleted = 0`, `CauHinh_Ma = 'ACTIVE_ND_254'`, `CauHinh_GiaTri = '1'` = bat). Thieu / khac / loi = tat, giu luong cu.
- Doc global theo key (khong loc `DaiLy_Id`) de BE import va FE cung ket qua. KHONG dung `GetValueNCCCauHinh(ma)` vi ham do loc theo dai ly.
- Rui ro can luu y: khong gate XML/PDF (`HoaDonTT3268Utility.cs`). Neu tat co sau khi da tao HD xe, XML/PDF cua cac HD do co the mat field xe. Sendmail va worker import nen khong can gate.

## Dong Bo 2 Cot So Khung / So May

- Dieu kien hien: `soKhungColunm && !hasSpecialVehicle()` va `soMayColunm && !hasSpecialVehicle()`, ap dung dong nhat o `hoadonbanhang.component.html` va `hoadon-goc.component.html` (header + body readonly + body nhap lieu).
- Binding: body readonly dung `[value]="item.hD_ChiTiet_MoRong.so_Khung"` / `.so_May` + `disabled`; body nhap lieu dung `[(ngModel)]` + `[disabled]="isDCTTNhieuHoaDon"`; ten control `BS_so_Khung_01{{ i }}` / `BS_so_May_01{{ i }}`.
- 2 cot nay va dong panel xe (`.xe-detail-row`, dieu kien `hasSpecialVehicle()`) loai tru nhau -> `getInvoiceDetailColumnCount()` khong can cong them, colspan panel xe khong lech.
- Anh huong be rong bang chi tiet cua `hoadon-goc`: khi `soKhungColunm`/`soMayColunm` bat, bang co them 2 cot so voi truoc; can kiem tra layout/scroll ngang.

## Anh Huong Luong Cu

- File import cu khong co cot moi van import binh thuong.
- File cu co dong `tinhchat = 4` va `loaihoadondactrung = 1` nhung khong du cum cot moi van khong kich hoat validate cac field moi, bao gom `ma_tinh`, `ma_xa` va 16 field xe.
- Dong import khong phai `tinhchat = 4` hoac khong phai `loaihoadondactrung = 1` khong chay validate field xe.
- Cac loai import ngoai GTGT/Ban hang/Ve xe khong nam trong scope task nay.

## Rui Ro Can Test

- Nhan dien sai file moi/cu co the lam file cu bi validate thieu field moi.
- Sai vi tri cot giua GTGT, Ban hang, Ve xe co the map nham du lieu.
- Worker import nen neu khong dong bo BE se lam file <= 50 dong va > 50 dong tra ket qua khac nhau.
- Query danh muc tinh/xa loi phai duoc log ngan gon va khong lam import crash boi exception DB.
- Neu danh muc thieu ma tinh/ma xa hop le cua khach hang thi import se bi reject voi message khong ton tai.
- Validate thong tin cap hoa don/nguoi mua neu thuc hien trong helper validate tung dong se lam hoa don nhieu dong chi tiet bi bao loi lap theo tung dong con. Can tach validate cap hoa don va cap dong chi tiet.

## Cap Nhat Anh Huong Validate Nhieu Dong Chi Tiet

Thong tin nguoi mua va dia ban dang ky la du lieu cap hoa don, khong phai du lieu rieng cua tung dong chi tiet. Cac field sau chi duoc validate mot lan theo dong hoa don chinh khi hoa don co it nhat mot dong `tinhchat = 4` va `loaihoadondactrung = 1`:

- `nguoimuahang` / `Tên`.
- `mst` / `Mã số thuế` neu co truyen thi validate do dai.
- `diachi` / `Địa chỉ`.
- `ma_tinh` / `Mã tỉnh`.
- `ma_xa` / `Mã xã`.
- `sdt` / `Số điện thoại`.
- `email` / `Địa chỉ thư điện tử`.

Cac field hang hoa dac trung xe van validate theo tung dong chi tiet:

- `sokhung`, `somay`, `loaitaisan`, `tinhtrangtaisan`, `xuatxu`, `sogiaychungnhanatkt`, `soseripktcl`, `ma_nuocsx`, `ten_loaitaisan`, `namsanxuat`, `ten_thuongmai`, `ten_nhanhieu`, `kieuloaixe`, `thetich_congsuat`, `trongtai`, `sochongoi`, `chatluongtaisan`, `sobienkiemsoat`.

Ket qua mong doi:

- Hoa don nhieu dong chi tiet chi dien thong tin nguoi mua/dia ban o dong hoa don chinh van import hop le.
- Dong chi tiet con de trong `nguoimuahang`, `diachi`, `ma_tinh`, `ma_xa`, `sdt`, `email` khong bi bao loi rieng.
- Neu dong hoa don chinh thieu field cap hoa don bat buoc thi bao loi mot lan theo dong hoa don chinh.
- Dong xe dac trung nao thieu/sai 16 field xe thi van bao loi theo dung dong chi tiet do.

## Query Danh Muc Tinh Xa

- `ma_tinh` validate theo `vs_danhmuc_tinh_thanh`.
- `ma_xa` validate theo `vs_danhmuc_xa_phuong` va cap `ma_tinh`.
- Hai bang danh muc nay nam o host DB. Neu code query bang tenant DB se gap loi table not found hoac catalog rong, dan toi validate sai `Mã tỉnh không tồn tại.` / `Mã xã không tồn tại.`.
- BE dung EF Core phai normalize sau khi lay du lieu ve memory, khong goi helper C# trong LINQ query translate SQL.
- Worker dung Dapper can load catalog bang host/default connection, boc `try/catch` quanh query va log `Import validate địa bàn lỗi`.

## Ket Qua Mong Doi Khi Query Loi

- He thong ghi log ngan gon de truy vet.
- Khong nem exception DB ra ngoai lam import crash.
- Catalog fallback rong.
- Neu dong kich hoat rule co truyen `ma_tinh`, `ma_xa`, ket qua validate bao:
  - `Mã tỉnh không tồn tại.`
  - `Mã xã không tồn tại.`
