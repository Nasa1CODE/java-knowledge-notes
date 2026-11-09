# CBCLOUDV2-8430 Plan

## Goal

Apply background export for `TinhHinhSuDungHoaDon/TaiExcelTheoBenMua` using existing `ServiceExportBill`, Rabbit queue `ExportData`, and `AppServiceExportBillHost`, then tag jobs with `vs_service_exportbill.filetype` so Quản lý xuất file shows `Báo cáo doanh thu theo bên mua`.

## Key Changes

- Use shared report limit key `CLOUD_ACTIVE_MAX_REPORT`.
- Read Redis first, DB second, fallback `50000`.
- API keeps direct export for `totalCount <= maxReportCount`.
- API creates background job for large buyer report exports with:
  - `XuatFile_MoTa = "BaoCaoDoanhThuTheoBenMua"`
  - `FileType = 2`
- Worker routes `BaoCaoDoanhThuTheoBenMua` to the buyer report export service.
- Worker keeps fallback route for old queued jobs with `XuatFile_MoTa = "TinhHinhSuDungHoaDonTheoBenMua"`.
- Frontend Quản lý xuất file shows `Báo cáo doanh thu theo bên mua` when `fileType == 2`.
- Existing invoice export flow remains unchanged; null/0 file type displays `Hóa đơn`.

## Constraints

- Tenant DB has nullable column `vs_service_exportbill.filetype`.
- No Rabbit contract change.
- No change to `BaoCaoTheoBenMua` view/report API.
- Count is raw invoice rows, not buyer groups.
- No data migration for old rows.

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
  - Buyer report uses `CLOUD_ACTIVE_MAX_REPORT`.
  - Buyer report job sets `XuatFile_MoTa = "BaoCaoDoanhThuTheoBenMua"` and `FileType = 2`.
  - Worker handles both new and old buyer report discriminator values.
  - Quản lý xuất file maps `fileType == 2` to `Báo cáo doanh thu theo bên mua`.
