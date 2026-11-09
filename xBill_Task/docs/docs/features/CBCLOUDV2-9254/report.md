# CBCLOUDV2-9254 Report

## Status

- Implementation complete.
- Build verification complete.
- Manual QA pending on environment with affected data.

## Problem

`GetDSHoaDon` cua `VanBanThoaThuanAppService` khong lay len cac VBTT co du lieu bien ban thieu `TongHop_Id`.

Root cause:

- `HD_HoaDon.HD_BienBanThoaThuan` duoc EF join qua `HD_BienBanThoaThuan.TongHop_Id`.
- Query cu bat buoc `e.HD_BienBanThoaThuan != null`.
- Khi `TongHop_Id IS NULL`, navigation null va hoa don bi loai du da co `QuanLy_VanBanThoaThuan`.

## Change Applied

File:

- `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/VanBanThoaThuanAppService.cs`

Changed logic in `GetDSHoaDon`:

```csharp
var bienBanThoaThuanQuery = _bienBanThoaThuanRepository.GetAll();

!bienBanThoaThuanQuery.Any(bb => bb.KieuBienBan == 1 &&
                                (bb.TongHop_Id == e.Id ||
                                 (e.QuanLy_VanBan_Id.HasValue && bb.Id == e.QuanLy_VanBan_Id.Value)))
```

The query still requires:

```csharp
e.QuanLy_VanBanThoaThuan != null && e.QuanLy_VanBanThoaThuan != ""
```

## Verification

Command:

```powershell
dotnet build D:\XBill\Cloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\HDDT.Application.csproj
```

Result:

- `0 Error(s)`
- Existing warnings remain, including project warnings and `SSH.NET` vulnerability advisory.

## Manual QA Pending

- Verify affected VBTT records with `vs_hd_bienbanthoathuan.TongHop_Id IS NULL` appear on `/app/hddt/hoadon/vanbanthoathuan`.
- Verify xem/tai file for those records.
- Verify `KieuBienBan = 1` records matched by `TongHop_Id` remain excluded.
- Verify `KieuBienBan = 1` records matched by `QuanLy_VanBan_Id` remain excluded even when `TongHop_Id IS NULL`.
