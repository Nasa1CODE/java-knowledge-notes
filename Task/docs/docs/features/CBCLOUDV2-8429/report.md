# CBCLOUDV2-8429 Report

## Summary

Implemented background Excel export for large BaoCaoDoanhThuTheoSanPham reports by reusing the existing export-bill queue and `AppServiceExportBillHost` worker. Small exports continue to run directly in the API.

## Files Changed

### invoicecore

- `src/hddt/HDDT.Application/AppServices/BaoCao/BaoCaoDoanhThuTheoSanPhamAppService .cs`
- `src/zero/VS.Web.Host/appsettings.json`

### AppServiceExportBillHost

- `AppService/Models/BaoCaoDoanhThuTheoSanPhamModels.cs`
- `AppService/Repositories/IHD_HoaDonRepository.cs`
- `AppService/Repositories/HD_HoaDonRepository.cs`
- `AppService/Service/BaoCaoDoanhThuTheoSanPhamExportService.cs`
- `AppService/Process.cs`

## Implementation Details

- Added report type discriminator `BaoCaoDoanhThuTheoSanPham`.
- Large report export now creates `ServiceExportBill` and sends `ExportBillData` through existing `SendExportBill`.
- The API returns:

```text
Tiến trình xuất file đang thực hiện, vui lòng download file tại Quản lý tải file
```

- `ACTIVE_MAX_PRODUCT_REVENUE_REPORT` is read from Redis first, then DB, with fallback `50000`.
- `TotalCount` and `MaxReportCount` are stored in the serialized export input object.
- Public report output DTO no longer carries export-job metadata.
- Worker service routes report jobs to a dedicated `BaoCaoDoanhThuTheoSanPhamExportService`.
- Existing invoice export flow remains routed through `NhapDSHoaDonExcelHelper`.

## Verification

### invoicecore Build

```text
dotnet build invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj
```

Result:

```text
Build succeeded.
0 Error(s)
```

Warnings are existing project warnings.

### Worker Build

```text
dotnet build svinvoicesendemail/AppServiceExportBillHost/AppService.sln
```

Result:

```text
Build succeeded.
0 Error(s)
```

Warnings are existing .NET Core 2.1/package vulnerability and unreachable-code warnings.

## Follow-up Notes

- Existing Excel export worker creates one `.xlsx` file per job and does not split/zip large Excel output.
- Very large report exports may still require future memory/performance optimization, such as SQL aggregation or streaming file output.
## Frontend Update

### Files Changed

- `frontend_angular/src/app/hddt/baocao/doanhthutheosanpham/doanhthutheosanpham.component.ts`

### Implementation Details

- `xuatFileExcel()` now handles `TaiExcel` response `status == 2` with the same popup style used by invoice Excel export.
- The popup uses `this.message.success(messageFullLink, this.l('ThongBao'), true)` so the HTML link is clickable.
- The link points to `/app/hddt/hoadon/xuatfile-excel`.
- `status == 1` direct file download and other warning behavior remain unchanged.
- `xembaocao()` was not changed.

### Frontend Verification

```text
rg -n "result\.status == 2|message\.success|xuatfile-excel|downloadTempFile|notify\.warn" frontend_angular/src/app/hddt/baocao/doanhthutheosanpham/doanhthutheosanpham.component.ts
Result: verified status 2 popup branch, direct download branch, export-file link, and warning fallback.

rg -n "message\.success\(messageFullLink, this\.l\('ThongBao'\), true\)|xuatfile-excel" frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.component.ts frontend_angular/src/app/hddt/baocao/doanhthutheosanpham/doanhthutheosanpham.component.ts
Result: verified report popup uses the same message.success(..., true) pattern and link as invoice Excel export.
```

Frontend build was not run for this UI-only change; verification was source-based per approved plan.
## Download Filename Update

### Files Changed

- `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/ExportBill/ExportBillAppService.cs`

### Implementation Details

- `DownloadFile(int id)` now derives `FileDto.FileName` from `Path.GetFileName(export.XuatFile_DuongDan)`.
- If `XuatFile_DuongDan` does not contain a filename, it falls back to the previous default `ExportFile.xlsx`.
- No additional DB query, schema change, queue change, worker change, or frontend_angular change is required for this filename fix.

### Verification

```text
rg -n "Path\.GetFileName|ExportFile\.xlsx|new FileDto\(fileName|DownloadFile\(" src/hddt/HDDT.Application/AppServices/ExportBill/ExportBillAppService.cs
Result: verified filename is derived from XuatFile_DuongDan with ExportFile.xlsx fallback.

dotnet build invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj -v:minimal
Result: Build succeeded, 0 Error(s).
```
## FileType / Shared Config Update - 2026-07-07

### Files Changed

#### invoicecore

- `invoicecore/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/NhapExcel/ServiceExportBill.cs`
- `invoicecore/aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/HoaDon/ExportBill/ServiceExportBillDto.cs`
- `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/BaoCao/BaoCaoDoanhThuTheoSanPhamAppService .cs`

#### AppServiceExportBillHost

- `svinvoicesendemail/AppServiceExportBillHost/DapperCore/Domain/ServiceExportBill.cs`
- `svinvoicesendemail/AppServiceExportBillHost/DapperCore/Repositories/ServiceExportBillRepository.cs`

#### frontend_angular

- `frontend_angular/src/app/hddt/hoadon/quanlyxuatfile/quanlyxuatfile.component.ts`
- `frontend_angular/src/app/hddt/hoadon/quanlyxuatfile/quanlyxuatfile.component.html`
- `frontend_angular/src/shared/service-proxies/service-proxies.ts`

### Implementation Details

- Product revenue report limit key now uses `CLOUD_ACTIVE_MAX_REPORT` directly, with Redis first, DB second, fallback `50000`.
- Added nullable `filetype` mapping as `FileType` on API entity and DTO.
- Product revenue report background job sets `FileType = 1`.
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
Result: verified product FileType = 1 and shared key `CLOUD_ACTIVE_MAX_REPORT`.

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

- Current `svinvoicesendemail/AppServiceExportBillHost` checkout does not contain source matches for `BaoCaoDoanhThuTheoSanPham` report routing/service. The filetype persistence is implemented and builds, but worker report route verification remains pending in this checkout.
## Follow-up plan - route by FileType - 2026-07-08

- Change worker product report branch from `XuatFile_MoTa == "BaoCaoDoanhThuTheoSanPham"` to `FileType == 1`.
- Keep existing report export service logic; only change the discriminator.
- Move FE `Loại file` column after `Ngày xử lý`.
- Verify worker build and FE source after change.
## Follow-up result - route by FileType - 2026-07-08

### Files Changed

- `svinvoicesendemail/AppServiceExportBillHost/AppService/Process.cs`
- `frontend_angular/src/app/hddt/hoadon/quanlyxuatfile/quanlyxuatfile.component.html`

### Implementation Details

- Worker product report route now checks `exportJob.FileType == 1` instead of `exportJob.XuatFile_MoTa == "BaoCaoDoanhThuTheoSanPham"`.
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