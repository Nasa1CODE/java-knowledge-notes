# CBCLOUDV2-9168 Report - Import hang hoa dac trung xe

## Summary

Da cap nhat tai lieu va implementation cho import hang hoa dac trung xe tren GTGT, Ban hang, Ve xe. Rule moi chi ap dung voi file template moi va dong `tinhchat = 4`, `loaihoadondactrung = 1`; file cu van import binh thuong.

## Files/Services

### invoicecore

- `\XBill\Cloud\invoicecore`
- Import truc tiep file <= 50 dong.
- Map `ma_tinh`, `ma_xa` vao mo rong cap hoa don.
- Map 16 field xe vao mo rong chi tiet.
- Validate bat buoc/gia tri/do dai theo plan.
- Validate ton tai `ma_tinh`, `ma_xa` theo danh muc dia ban.
- Load danh muc dia ban tu host DB bang `SetTenantId(null)`, khong query tenant DB.

### svinvoicesendemail

- `\XBill\Cloud\svinvoicesendemail`
- Import nen file > 50 dong.
- Dong bo model/repository/map/validate voi `invoicecore`.
- Query danh muc dia ban bang Dapper tren host/default connection, sau do truyen catalog vao helper import.

## Query Danh Muc Dia Ban

Da bo sung yeu cau implementation:

- Boc `try/catch` quanh phan query DB lay danh muc tinh/xa.
- Log ngan gon neu query loi.
- Hai bang `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` nam o host DB; tenant DB khong bat buoc co hai bang nay.
- BE dung EF Core khong goi helper C# trong LINQ query SQL; chi query raw column, sau `.ToList()` moi normalize/build key trong memory.
- Worker import nen dung Dapper tren host/default connection va fallback catalog rong khi query loi.

## Feature Flag ACTIVE_ND_254 (bat/tat tinh nang)

Bo sung 1 co cau hinh o host DB de bat/tat phan import/panel chi tiet xe ND254 ma khong deploy lai code. Rieng FE, co chi an/hien panel xe va validate/Tinh-Xa lien quan; option `Hang hoa dac trung`, cot `Loai HHDT`, cot cu `So khung`/`So may` van giu nhu truoc task.

- Nguon co: bang host `vs_dm_ncc_cauhinh`, `isdeleted = 0`, `CauHinh_Ma = 'ACTIVE_ND_254'`, `CauHinh_GiaTri = '1'` = bat. Thieu row / khac `'1'` / query loi = tat (giu nguyen luong cu).
- Doc **global theo key**, KHONG loc `DaiLy_Id`, de BE va FE dong nhat mot ket qua.

### BE

- Gate import truc tiep (`invoicecore`): `NhapDSHoaDonExcelHelper.IsVehicleAssetFeatureActive()` chan 3 diem (nhan template, doc row, format cot), cache field + try/catch fallback `false`. Da hoan thanh tu truoc.
- Endpoint global cho FE: `DoanhNghiep_ThongTinChungAppService.GetActiveND254()` doc `.Any(CauHinh_Ma == "ACTIVE_ND_254" && CauHinh_GiaTri == "1")`, route `/api/services/hddt/DoanhNghiep_ThongTinChung/GetActiveND254`.
- Ly do them endpoint rieng: ham san `GetValueNCCCauHinh(ma)` loc `DaiLy_Id == dn.DaiLy_Id` (theo dai ly) nen se lech voi gate import doc global. Neu dung ham do, config gan theo 1 dai ly se lam BE import bat toan he thong nhung FE chi bat cho dai ly do.

### FE (`frontend_angular`)

- Proxy: them `getActiveND254(): Observable<boolean>` vao `DoanhNghiep_ThongTinChungServiceProxy` (them tay theo dung khuon NSwag de regen sau tai lap y het).
- Da ra soat lai FE diff va restore generated `frontend_angular/build/`; chi giu source can thiet: 2 form co panel xe (`hoadon-goc`, `hoadonbanhang`) va `service-proxies.ts`.
- 2 form co panel xe doc co qua `getActiveND254()` trong `ngOnInit`, gan `activeND254`:
  - `hoadon-goc`: co chi an/hien panel chi tiet xe va `hasSpecialVehicle()` (keo theo Tinh/Xa nguoi mua va cac dau bat buoc CCCD/SDT/DiaChi). Option `Hang hoa dac trung` va cot `Loai HHDT` giu nhu truoc task.
  - `hoadonbanhang`: nhu tren; option `Hang hoa dac trung`, cot `Loai HHDT` va cot cu `So khung`/`So may` giu nhu truoc task.
  - `vemaybay`: khong doc/gate `ACTIVE_ND_254` vi form nay khong co panel chi tiet xe / khong co block Tinh-Xa; option `Hang hoa dac trung` va cot `Loai HHDT` giu nhu truoc task.

### Dong bo 2 cot `So khung` / `So may` (T28)

Truoc thay doi: `hoadonbanhang` co 2 cot rieng `So khung`/`So may` trong bang chi tiet, con `hoadon-goc` khong co - 2 field nay chi ton tai ben trong panel xe ND254 (bi an khi tat co). Ket qua la khi khong active panel xe, `hoadon-goc` khong con cho nhap `so_Khung`/`so_May`.

Da bo sung vao `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.html` 3 vung, dung dung khuon cua `hoadonbanhang.component.html`:

- Header `<thead>`: 2 `<th>` dat truoc cot BKS, dieu kien `soKhungColunm && !hasSpecialVehicle()` / `soMayColunm && !hasSpecialVehicle()`.
- Body HD goc (readonly): 2 `<td>` binding `[value]="item.hD_ChiTiet_MoRong.so_Khung"` / `.so_May`, `disabled`, chi render khi `item.hangHoa_Loai == 4`.
- Body nhap lieu: 2 `<td>` binding `[(ngModel)]="item.hD_ChiTiet_MoRong.so_Khung"` / `.so_May`, `[disabled]="isDCTTNhieuHoaDon"`.

Ten control giu dong bo voi form ban hang: `BS_so_Khung_01{{ i }}`, `BS_so_May_01{{ i }}`.

Colspan: `getInvoiceDetailColumnCount()` khong sua vi 2 cot moi chi hien khi `!hasSpecialVehicle()`, con dong `.xe-detail-row` chi hien khi `hasSpecialVehicle()` - hai truong hop loai tru nhau nen colspan panel xe khong bi lech.

File thay doi: `hoadon-goc.component.html` (+32 dong, `1 file changed, 32 insertions(+)`).

### Ngoai pham vi (khong gate)

- Worker import nen (`svinvoicesendemail`): chua implement tinh nang xe -> khong co gi de gate.
- Sendmail (`invoice-sendmail-service`): mail chi dinh kem PDF/XML dung san, khong tu render field xe.
- XML/PDF (`HoaDonTT3268Utility.cs`): giu nguyen theo quyet dinh scope chi gate FE. Rui ro: neu lat co sau khi da tao HD xe, XML/PDF cua cac HD do co the mat field xe.

### SQL bat tinh nang

```sql
INSERT INTO vs_dm_ncc_cauhinh (cauhinh_ma, cauhinh_giatri, cauhinh_mota, isdeleted)
VALUES ('ACTIVE_ND_254', '1', N'Bat import/nhap hang hoa dac trung xe (NĐ 254)', 0);
```

## Verification

- Build `invoicecore` da pass voi `0 Error(s)` (bao gom endpoint `GetActiveND254()` moi them).
- Build `svinvoicesendemail` da pass voi `0 Error(s)` khi build ra output tam. Build mac dinh co the fail copy DLL neu service/Visual Studio dang giu lock file `AppService.dll`.
- Con cac warning cu cua project, khong phai loi compile cua task nay.
- Manual test theo `testcase.md` chua duoc danh dau da chay tren moi truong that.

## Docs Updated

- `plan.md`
- `expect.md`
- `tasks.md`
- `impact.md`
- `testcase.md`
- `report.md`
