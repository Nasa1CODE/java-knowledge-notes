# CBCLOUDV2-9254 Plan

## Context

Sau nang cap, mot so du lieu VBTT cu khong hien thi tren man danh sach vi record bien ban thoa thuan thieu `TongHop_Id`. Trong khi do hoa don van co `QuanLy_VanBanThoaThuan` va co the dung `record.id` de xem/tai file.

## Implementation Plan

1. Kiem tra endpoint `VanBanThoaThuan/GetDSHoaDon` trong `invoicecore`.
2. Xac nhan frontend danh sach chi can thong tin hoa don va thao tac xem/tai file theo `record.id`, khong phu thuoc truc tiep `HdBienBanThoaThuanDto`.
3. Sua query backend de khong bat buoc co navigation `HD_BienBanThoaThuan`.
4. Tach dieu kien hien thi VBTT va dieu kien loai tru van ban chung tu:
   - Hien thi theo `QuanLy_VanBanThoaThuan`.
   - Loai `KieuBienBan = 1` neu bien ban match qua `TongHop_Id` hoac `QuanLy_VanBan_Id`.
5. Build `HDDT.Application` de xac nhan khong loi compile.
6. Cap nhat docs feature cho ticket.

## Affected Source

- `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/VanBanThoaThuanAppService.cs`

## Planned Query Change

Before:

```csharp
e.HD_BienBanThoaThuan != null && e.HD_BienBanThoaThuan.KieuBienBan != 1
```

After:

```csharp
var bienBanThoaThuanQuery = _bienBanThoaThuanRepository.GetAll();

!bienBanThoaThuanQuery.Any(bb => bb.KieuBienBan == 1 &&
                                (bb.TongHop_Id == e.Id ||
                                 (e.QuanLy_VanBan_Id.HasValue && bb.Id == e.QuanLy_VanBan_Id.Value)))
```

Hoa don van phai co:

```csharp
e.QuanLy_VanBanThoaThuan != null && e.QuanLy_VanBanThoaThuan != ""
```

## Verification Plan

- Static source review: confirm query no longer requires `HD_BienBanThoaThuan != null`.
- Build backend application project.
- Manual QA:
  - Tao/lay mau hoa don co `QuanLy_VanBanThoaThuan` va bien ban `TongHop_Id IS NULL`.
  - Goi `GetDSHoaDon?filter=&SkipCount=0&MaxResultCount=10`.
  - Xac nhan du lieu hien tren danh sach.
  - Xem va tai file VBTT tu danh sach.

## Risk Notes

- Cac hoa don co ten/file VBTT nhung khong co bien ban lien ket se hien thi. Day la behavior mong muon cho du lieu cu.
- Neu du lieu chung tu `KieuBienBan = 1` thieu ca `TongHop_Id` va hoa don cung khong luu `QuanLy_VanBan_Id`, query khong co khoa nao de xac dinh lien ket va loai tru. Can QA kiem tra neu co nhom du lieu bat thuong nay.
