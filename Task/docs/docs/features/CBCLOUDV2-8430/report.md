# CBCLOUDV2-8430 Report

## Summary

Implemented background Excel export for large `TinhHinhSuDungHoaDon/TaiExcelTheoBenMua` exports. Small exports continue to download directly; large exports create a `vs_service_exportbill` job and are processed by `AppServiceExportBillHost` through the existing `ExportData` queue.

## Files Changed

### invoicecore

- `src/hddt/HDDT.Application/AppServices/BaoCao/TinhHinhSuDungHoaDonAppService.cs`
- `src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/Repositories/HoaDon/HD_HoaDonRepository.cs`
- `src/zero/VS.Web.Host/appsettings.json`

### AppServiceExportBillHost

- `AppService/Models/TinhHinhSuDungHoaDonTheoBenMuaModels.cs`
- `AppService/Service/TinhHinhSuDungHoaDonTheoBenMuaExportService.cs`
- `AppService/Repositories/IHD_HoaDonRepository.cs`
- `AppService/Repositories/HD_HoaDonRepository.cs`
- `AppService/Process.cs`

### Frontend

- `frontend_angular/src/app/hddt/baocao/tinhhinhsudunghoadontheobenmua/tinhhinhsudunghoadontheobenmua.component.ts`

## Implementation Details

- Added dedicated config key `ACTIVE_MAX_BUYER_REVENUE_REPORT`, configured by `Report:BuyerRevenueMaxReportKey`.
- API reads limit from Redis first, DB second, fallback `50000`.
- API counts raw invoice rows with the same filter as `TaiExcelTheoBenMua` before loading full data.
- API creates `ServiceExportBill` with `XuatFile_MoTa = "TinhHinhSuDungHoaDonTheoBenMua"` when over limit.
- Worker routes the new report type to a dedicated export service and keeps invoice/product-report routes unchanged.
- frontend_angular displays a clickable background export popup for `status == 2`.

## Verification

```text
rg -n "BuyerRevenueMaxReportKey|ACTIVE_MAX_BUYER_REVENUE_REPORT|TinhHinhSuDungHoaDonTheoBenMua|CountBaoCaoTheoBenMuaRs|SendExportBill" ...
Result: verified API key, count, job type, and queue send.

rg -n "TinhHinhSuDungHoaDonTheoBenMua|GetTinhHinhSuDungHoaDonTheoBenMuaData|BaoCaoDoanhThuTheoSanPham|XuatFile_MoTa" svinvoicesendemail/AppServiceExportBillHost/AppService
Result: verified worker route, service, model, and repository method.

rg -n "result\.status == 2|message\.success|xuatfile-excel|downloadTempFile" frontend_angular/src/app/hddt/baocao/tinhhinhsudunghoadontheobenmua/tinhhinhsudunghoadontheobenmua.component.ts
Result: verified status 2 popup and direct download branch.

dotnet build invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj -v:minimal
Result: Build succeeded, 0 Error(s).

dotnet build svinvoicesendemail/AppServiceExportBillHost/AppService/AppService.csproj -v:minimal -p:OutDir=<tmp>/AppServiceExportBillHostBuild/
Result: Build succeeded, 0 Error(s).
```

## Notes

- Frontend build was not run; frontend_angular verification was source-based.
- Manual runtime testing was not run in this environment.
- Worker build warnings are existing .NET Core 2.1 EOL/package vulnerability warnings.
## FileType / Shared Config Update - 2026-07-07

### Files Changed

#### invoicecore

- `invoicecore/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/NhapExcel/ServiceExportBill.cs`
- `invoicecore/aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/HoaDon/ExportBill/ServiceExportBillDto.cs`
- `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/BaoCao/TinhHinhSuDungHoaDonAppService.cs`

#### AppServiceExportBillHost

- `svinvoicesendemail/AppServiceExportBillHost/DapperCore/Domain/ServiceExportBill.cs`
- `svinvoicesendemail/AppServiceExportBillHost/DapperCore/Repositories/ServiceExportBillRepository.cs`

#### frontend_angular

- `frontend_angular/src/app/hddt/hoadon/quanlyxuatfile/quanlyxuatfile.component.ts`
- `frontend_angular/src/app/hddt/hoadon/quanlyxuatfile/quanlyxuatfile.component.html`
- `frontend_angular/src/shared/service-proxies/service-proxies.ts`

### Implementation Details

- Buyer revenue report limit key now uses `CLOUD_ACTIVE_MAX_REPORT` directly, with Redis first, DB second, fallback `50000`.
- Buyer report background job discriminator changed in API to `BaoCaoDoanhThuTheoBenMua`.
- Added nullable `filetype` mapping as `FileType` on API entity and DTO.
- Buyer report background job sets `FileType = 2`.
- Worker Dapper `ServiceExportBill` now has `FileType`; repository insert/update preserves `filetype`.
- Quản lý xuất file now shows column `Loại file`:
  - `1` -> `Báo cáo doanh thu theo sản phẩm`
  - `2` -> `Báo cáo doanh thu theo bên mua`
  - null/0/other -> `Hóa đơn`
- Small exports under/equal config still download directly and do not create `vs_service_exportbill`, so no `filetype` row is created for those direct downloads.

### Verification

```text
dotnet build invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj -v:quiet -clp:ErrorsOnly
Result: Build succeeded, 2 Warning(s), 0 Error(s).

rg -n "ACTIVE_MAX_PRODUCT_REVENUE_REPORT|ACTIVE_MAX_BUYER_REVENUE_REPORT|ProductRevenueMaxReportKey|BuyerRevenueMaxReportKey" ...
Result: no matches in API/worker source scope.

rg -n "FileType = \(int\)ServiceExportBillFileType|CLOUD_ACTIVE_MAX_REPORT|BaoCaoDoanhThuTheoBenMua" src/hddt/HDDT.Application src/hddt/HDDT.Core
Result: verified buyer FileType = 2, API discriminator `BaoCaoDoanhThuTheoBenMua`, and shared key `CLOUD_ACTIVE_MAX_REPORT`.

dotnet build svinvoicesendemail/AppServiceExportBillHost/AppService/AppService.csproj -v:quiet -clp:ErrorsOnly -p:OutDir=<tmp>/AppServiceExportBillHostBuild/
Result: Build succeeded, 55 Warning(s), 0 Error(s).

rg -n "fileType|Báo cáo doanh thu theo sản phẩm|Báo cáo doanh thu theo bên mua|Hóa đơn|LoaiFile|getLoaiFile" frontend_angular/src/app/hddt/hoadon/quanlyxuatfile frontend_angular/src/shared/service-proxies/service-proxies.ts
Result: verified FE column, mapping text, and proxy `fileType`.

yarn.cmd run publish
Result: failed with JavaScript heap out of memory.

$env:NODE_OPTIONS='--max_old_space_size=8192'; yarn.cmd run publish
Result: timed out after 424 seconds.
```

### Remaining Risk

- Current `svinvoicesendemail/AppServiceExportBillHost` checkout does not contain source matches for `BaoCaoDoanhThuTheoBenMua` or fallback `TinhHinhSuDungHoaDonTheoBenMua` report routing/service. The API discriminator and filetype persistence are implemented and build, but worker report route implementation remains pending in this checkout.
## Follow-up plan - route by FileType - 2026-07-08

- Change worker buyer report branch from `XuatFile_MoTa == "TinhHinhSuDungHoaDonTheoBenMua"` to `FileType == 2`.
- Keep existing report export service logic; only change the discriminator.
- Move FE `Loại file` column after `Ngày xử lý`.
- Verify worker build and FE source after change.
## Follow-up result - route by FileType - 2026-07-08

### Files Changed

- `svinvoicesendemail/AppServiceExportBillHost/AppService/Process.cs`
- `frontend_angular/src/app/hddt/hoadon/quanlyxuatfile/quanlyxuatfile.component.html`

### Implementation Details

- Worker buyer report route now checks `exportJob.FileType == 2` instead of `exportJob.XuatFile_MoTa == "TinhHinhSuDungHoaDonTheoBenMua"`.
- Worker report-completion branch now checks `export.FileType == 1 || export.FileType == 2` instead of report names in `XuatFile_MoTa`.
- FE `Loại file` column was moved to after `Ngày xử lý`.

### Verification

```text
rg -n 'XuatFile_MoTa == "BaoCaoDoanhThuTheoSanPham"|XuatFile_MoTa == "TinhHinhSuDungHoaDonTheoBenMua"|FileType == 1|FileType == 2' svinvoicesendemail/AppServiceExportBillHost/AppService/Process.cs
Result: only `FileType == 1`, `FileType == 2`, and `export.FileType == 1 || export.FileType == 2` remain for report routing.

dotnet build svinvoicesendemail/AppServiceExportBillHost/AppService/AppService.csproj -v:quiet -clp:ErrorsOnly -p:OutDir=<tmp>/AppServiceExportBillHostBuild/
Result: Build succeeded, 22 Warning(s), 0 Error(s).

Get-Content frontend_angular/src/app/hddt/hoadon/quanlyxuatfile/quanlyxuatfile.component.html
Result: verified `LoaiFile` header/body is after `NgayXuLy`.
```
## EnumCommons refactor plan - 2026-07-08

- Move ServiceExportBillFileType from ServiceExportBill.cs to HDDT.Application.Commons.Commons.EnumCommons.cs.
- Add HoaDon = 0 for future invoice file type usage and current null/0 display behavior.
- Keep existing report values: product = 1, buyer = 2.

## EnumCommons refactor result - 2026-07-08

### Files Changed

- `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/Commons/EnumCommons.cs`
- `invoicecore/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/NhapExcel/ServiceExportBill.cs`

### Implementation Details

- Moved `ServiceExportBillFileType` to `EnumCommons.cs` so invoice/report file types can share the same enum.
- Added `HoaDon = 0` for future invoice file type usage and current null/0 display behavior.
- Kept report values unchanged: product = 1, buyer = 2.

### Verification

```text
rg -n "ServiceExportBillFileType|HoaDon = 0|BaoCaoDoanhThuTheoSanPham = 1|BaoCaoDoanhThuTheoBenMua = 2" ...
Result: enum exists in EnumCommons.cs; report app services still reference the same enum values.

dotnet build invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj -v:quiet -clp:ErrorsOnly
Result: Build succeeded, 220 Warning(s), 0 Error(s).
```
## Appsettings config key plan - 2026-07-08

- Add `Report:MaxReportKey = CLOUD_ACTIVE_MAX_REPORT` to `invoicecore/aspnet-core/src/zero/VS.Web.Host/appsettings.json`.
- Update report services to read `_appConfiguration["Report:MaxReportKey"]`, fallback `CLOUD_ACTIVE_MAX_REPORT`.
- Keep Redis first, DB second, fallback value `50000`.
## Appsettings config key result - 2026-07-08

### Files Changed

- `invoicecore/aspnet-core/src/zero/VS.Web.Host/appsettings.json`
- `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/BaoCao/BaoCaoDoanhThuTheoSanPhamAppService .cs`
- `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/BaoCao/TinhHinhSuDungHoaDonAppService.cs`

### Implementation Details

- Added appsetting `Report:MaxReportKey = CLOUD_ACTIVE_MAX_REPORT`.
- Product and buyer report services read `_appConfiguration["Report:MaxReportKey"]`.
- If appsetting is missing/empty, services fallback to `CLOUD_ACTIVE_MAX_REPORT`.
- Redis first, DB second, and default `50000` behavior are unchanged.

### Verification

```text
rg -n 'Report:MaxReportKey|CLOUD_ACTIVE_MAX_REPORT' src/hddt/HDDT.Application/AppServices/BaoCao src/zero/VS.Web.Host/appsettings.json
Result: verified appsetting and both service usages.

dotnet build invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj -v:quiet -clp:ErrorsOnly
Result: Build succeeded, 204 Warning(s), 0 Error(s).
```