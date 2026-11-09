# CBCLOUDV2-9168 Tasks - Import hang hoa dac trung xe

## Scope

Task chi xu ly import Excel cho:

- GTGT.
- Ban hang.
- Ve xe.

Ap dung cho:

- BE import truc tiep: `\XBill\Cloud\invoicecore`.
- Worker import nen file > 50 dong: `\XBill\Cloud\svinvoicesendemail`.

## Task List

| ID | Task | Status |
|---|---|---|
| T01 | Xac dinh template moi/cu theo viec ton tai cac cot hang hoa dac trung xe | done |
| T02 | Bo sung field vao row/model import neu service thieu | done |
| T03 | Map `ma_tinh`, `ma_xa` vao `HD_HoaDon_MoRong` | done |
| T04 | Map 16 field xe vao `HD_ChiTiet_MoRong` | done |
| T05 | Validate rule moi chi khi file moi + `tinhchat = 4` + `loaihoadondactrung = 1` | done |
| T06 | Validate bat buoc, gia tri hop le va do dai cac field trong plan | done |
| T07 | Validate `ma_tinh`, `ma_xa` ton tai trong danh muc dia ban | done |
| T08 | Boc `try/catch` phan query danh muc tinh/xa va log ngan gon neu loi | done |
| T09 | Sua mapping cot DB dung `sspktclxxuong`, khong dung `sspktcclxxuong` | done |
| T10 | Sua BE import truc tiep load danh muc tinh/xa tu host DB, khong query tenant DB | done |
| T11 | Sua worker import nen load danh muc tinh/xa tu host/default connection roi truyen vao helper GTGT/BH/Ve xe | done |
| T12 | Build BE import truc tiep | done |
| T13 | Build worker import nen | done |
| T14 | Bo sung validate dinh dang so trong BE import truc tiep: `trongtai` decimal 9,2, `sochongoi` 4 chu so, `chatluongtaisan` decimal 4,2 | done |
| T15 | Dong bo validate dinh dang so trong worker import nen `svinvoicesendemail` de file > 50 dong tra ket qua giong BE | done |
| T16 | Bo sung unit test cho 4 case so dung kieu nhung vuot format: `trongtai`, `sochongoi`, `chatluongtaisan` khi `tinhtrangtaisan = 1`, va `chatluongtaisan` co truyen khi `tinhtrangtaisan = 0` | done |
| T17 | Chay lai unit test/build cho worker import nen sau khi bo sung validate format so | done |
| T18 | Doi chieu lai 3 sheet `Import GTGT`, `Import BH`, `Import KHAC`: moi sheet con 6 case service nen `>50` can pass sau khi sua | done |
| T19 | Them co bat/tat tinh nang `ACTIVE_ND_254` (host `vs_dm_ncc_cauhinh`, `isdeleted = 0`, gia tri `1` = bat) cho BE import truc tiep | done |
| T20 | Gate BE import truc tiep: `IsVehicleAssetFeatureActive()` chan 3 diem (nhan template, doc row, format cot) trong `NhapDSHoaDonExcelHelper.cs` | done |
| T21 | Them endpoint global `GetActiveND254()` trong `DoanhNghiep_ThongTinChungAppService` doc `.Any(CauHinh_Ma == "ACTIVE_ND_254" && CauHinh_GiaTri == "1")`, khong loc `DaiLy_Id` | done |
| T22 | Them proxy `getActiveND254(): Observable<boolean>` vao `DoanhNghiep_ThongTinChungServiceProxy` (khop khuon NSwag) | done |
| T23 | Gate FE form `hoadon-goc`: chi an/hien panel `.xe-panel` va validate/Tinh-Xa ND254 theo `activeND254`; option loai xe + cot `Loai HHDT`, cot cu `So khung`/`So may` giu luong cu | done |
| T24 | Gate FE form `hoadonbanhang`: chi an/hien panel `.xe-panel` va validate/Tinh-Xa ND254 theo `activeND254`; option loai xe + cot `Loai HHDT`, cot cu So khung/So may giu nhu truoc task | done |
| T25 | FE form `vemaybay`: giu option loai xe + cot `Loai HHDT` theo luong cu, khong doc/gate `ACTIVE_ND_254` vi form khong co panel xe ND254 | done |
| T26 | Build BE `invoicecore` sau khi them endpoint: `0 Error(s)` | done |
| T27 | Ra soat lai FE diff, restore generated `build/`, chi giu source can thiet cho gate panel xe `ACTIVE_ND_254` | done |
| T28 | Dong bo 2 cot cu `So khung`/`So may` giua `hoadonbanhang` va `hoadon-goc`: hien khi `soKhungColunm`/`soMayColunm` va `!hasSpecialVehicle()` (khong active panel xe) | done |

## Notes

- BE `invoicecore`: khi dung EF Core, query DB chi lay raw column, sau `.ToList()` moi normalize/build key trong memory de tranh loi EF Core khong translate duoc helper C#.
- Hai bang `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` nam o host DB, khong query bang tenant DB.
- Worker `svinvoicesendemail`: query danh muc tinh/xa dung Dapper tren host/default connection trong `Process.cs`, truyen catalog vao helper; repository van boc `try/catch`.
- Khi query danh muc loi, catalog fallback rong; dong co `ma_tinh`, `ma_xa` se bi validate khong ton tai theo rule danh muc.
- Phan can sua them hien tai tap trung vao validate format so khi import file moi: `trongtai`, `sochongoi`, `chatluongtaisan`; khong them validate ngoai cac field trong Plan.
- `chatluongtaisan` chi bat buoc khi `tinhtrangtaisan = 1`, nhung neu file van truyen gia tri thi luon phai validate `decimal 4,2` de tranh loi DB khi map vao `cltsan`.
- FE da ra soat lai diff sau khi them co `ACTIVE_ND_254`: da restore cac file generated trong `frontend_angular/build/`; chi giu source thay doi o 2 form co panel xe (`hoadon-goc`, `hoadonbanhang`) va `service-proxies.ts`.
- Theo chot scope ngay 2026-08-28: co `ACTIVE_ND_254` chi an/hien panel xe ND254 va validate/Tinh-Xa lien quan; van cho chon `Hang hoa dac trung`, van hien cot `Loai HHDT`, va giu cot cu `So khung`/`So may` nhu truoc task.
- Dong bo 2 form (T28): ca `hoadonbanhang` va `hoadon-goc` deu hien 2 cot rieng `So khung`/`So may` khi `soKhungColunm`/`soMayColunm` bat va `!hasSpecialVehicle()`. Truoc do `hoadon-goc` khong co 2 cot nay trong bang chi tiet, chi co field `so_Khung`/`so_May` ben trong panel xe ND254.
- Hai vung loai tru nhau: 2 cot cu chi hien khi `!hasSpecialVehicle()`, con dong panel xe (`.xe-detail-row`) chi hien khi `hasSpecialVehicle()`. Vi vay `getInvoiceDetailColumnCount()` KHONG cong them 2 cot nay, colspan panel xe khong bi lech.

## Feature Flag ACTIVE_ND_254

Muc dich: bat/tat phan panel nhap chi tiet xe ND254 va validate/Tinh-Xa lien quan qua 1 co cau hinh o host DB, khong deploy lai code. Cac luong cu nhu chon `Hang hoa dac trung`, cot `Loai HHDT`, cot `So khung`/`So may` khong bi tat theo co. Khi khong active panel xe, 2 cot cu `So khung`/`So may` van hien binh thuong o ca `hoadonbanhang` va `hoadon-goc`.

- Nguon co: bang host `vs_dm_ncc_cauhinh`, dieu kien `isdeleted = 0`, `CauHinh_Ma = 'ACTIVE_ND_254'`, `CauHinh_GiaTri = '1'` = bat. Thieu row / khac `'1'` / query loi = tat, giu nguyen luong cu.
- Doc **global theo key**, KHONG loc `DaiLy_Id`, de BE va FE dong nhat.
  - BE import: `NhapDSHoaDonExcelHelper.IsVehicleAssetFeatureActive()` (cache field + try/catch fallback `false`).
  - Endpoint FE: `DoanhNghiep_ThongTinChungAppService.GetActiveND254()` (route `/api/services/hddt/DoanhNghiep_ThongTinChung/GetActiveND254`).
- Luu y: KHONG dung `GetValueNCCCauHinh(ma)` cho co nay vi ham do loc `DaiLy_Id == dn.DaiLy_Id` (theo dai ly) -> lech voi gate import global.

### Pham vi da gate

| Vung | Diem gate | Ghi chu |
|---|---|---|
| BE import truc tiep (`invoicecore`) | 3 diem trong `NhapDSHoaDonExcelHelper.cs` (nhan template, doc row, format cot) | Da xong tu truoc |
| FE form nhap/sua HD (`frontend_angular`) | `hoadon-goc`, `hoadonbanhang`: chi panel xe ND254 + `hasSpecialVehicle()`/validate lien quan | Doc co qua `getActiveND254()`; `vemaybay` khong gate vi khong co panel xe |
| Worker import nen (`svinvoicesendemail`) | Khong co gi de gate | Tinh nang xe chua duoc implement o worker |
| Sendmail (`invoice-sendmail-service`) | Khong can gate o body mail | Mail chi dinh kem PDF/XML dung san, khong tu render field xe |
| XML/PDF (`HoaDonTT3268Utility.cs`) | Chua gate (theo quyet dinh scope) | Co rui ro lam mat field xe khoi XML/PDF cua HD xe da tao neu lat co |

### SQL bat tinh nang

```sql
INSERT INTO vs_dm_ncc_cauhinh (cauhinh_ma, cauhinh_giatri, cauhinh_mota, isdeleted)
VALUES ('ACTIVE_ND_254', '1', N'Bat import/nhap hang hoa dac trung xe (NĐ 254)', 0);
```
