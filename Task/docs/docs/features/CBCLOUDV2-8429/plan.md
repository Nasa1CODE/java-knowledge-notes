# CBCLOUDV2-8429 Plan

## Goal

Move large `BaoCaoDoanhThuTheoSanPham` Excel exports to the existing background export-bill worker while preserving direct export for small datasets, and tag report jobs with `vs_service_exportbill.filetype` so Quản lý xuất file can show the exact file type.

## Context

- Existing invoice export uses `ServiceExportBill`, Rabbit queue `ExportData`, and `AppServiceExportBillHost` for large exports.
- Product revenue report background export already uses `XuatFile_MoTa = "BaoCaoDoanhThuTheoSanPham"`.
- `vs_service_exportbill` now has tenant DB column `filetype int NULL`.
- Old invoice/export rows can have `filetype = NULL` and must display as `Hóa đơn`.

## Impact Assessment

- Backend API: `invoicecore` report app service and export bill DTO/entity.
- Worker service: `svinvoicesendemail/AppServiceExportBillHost`.
- Frontend: `frontend_angular` Quản lý xuất file table.
- Database: tenant table `vs_service_exportbill` has new nullable `filetype` column.
- No queue contract replacement; reuse existing `ExportBillData`.

## Implementation Steps

1. Read export limit by shared key `CLOUD_ACTIVE_MAX_REPORT` from Redis first, DB second, fallback `50000`.
2. In `TaiExcel`, keep direct export when data count is within the limit.
3. When creating background job for product revenue report, set `XuatFile_MoTa = "BaoCaoDoanhThuTheoSanPham"` and `FileType = 1`.
4. Add `FileType` to `ServiceExportBill` entity and `ServiceExportBillDto`.
5. Add/export enum value `1 = BaoCaoDoanhThuTheoSanPham` for report file type handling.
6. Ensure worker domain/repository preserves `filetype` when reading/updating `ServiceExportBill`.
7. Update frontend Quản lý xuất file to show `Báo cáo doanh thu theo sản phẩm` when `fileType == 1`.
8. Keep null/0/unknown `fileType` displayed as `Hóa đơn`.
9. Update `report.md` after code changes with real source verify/build results.

## Verification Steps

- Build invoicecore application project:

```powershell
dotnet build invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj -v:minimal
```

- Build export worker service:

```powershell
dotnet build svinvoicesendemail/AppServiceExportBillHost/AppService/AppService.csproj -v:minimal -p:OutDir=<tmp>/AppServiceExportBillHostBuild/
```

- Source checks:
  - Product report uses `CLOUD_ACTIVE_MAX_REPORT`.
  - Product report job sets `FileType = 1`.
  - Quản lý xuất file maps `fileType == 1` to `Báo cáo doanh thu theo sản phẩm`.
  - Null/0 file type maps to `Hóa đơn`.

## Rollback

- Revert `FileType` code mapping and frontend column changes.
- Keep DB column nullable; old behavior remains compatible if code ignores the column.
- Restore previous product report limit key only if rollback requires matching old config.
