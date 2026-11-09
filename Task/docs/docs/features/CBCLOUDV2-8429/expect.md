# CBCLOUDV2-8429 Expect

## Feature Status

- Status: approved
- Class: Medium

## Business Goal

When exporting BaoCaoDoanhThuTheoSanPham with a large dataset, the API should not block or fail in the request/response flow. It should create an asynchronous export job and let the existing export bill worker process the Excel file in the background.

## Scope

- Backend report service: `BaoCaoDoanhThuTheoSanPhamAppService`.
- Export method: `TaiExcel`.
- Data method: `LayDuLieu`.
- Configuration key: `ACTIVE_MAX_PRODUCT_REVENUE_REPORT`.
- Queue: existing export bill queue `ExportData` through `SendExportBill`.
- Worker service: `AppServiceExportBillHost`.
- Job discriminator: `XuatFile_MoTa = "BaoCaoDoanhThuTheoSanPham"`.

## Expected Behavior

- Small report exports continue to return Excel directly from the API.
- Large report exports create a `ServiceExportBill` job and send it to the existing export queue.
- API returns:

```text
Tiến trình xuất file đang thực hiện, vui lòng download file tại Quản lý tải file
```

- Export limit is read from Redis first by key `ACTIVE_MAX_PRODUCT_REVENUE_REPORT`; if Redis does not contain the key, read from DB; if missing or invalid, fallback to `50000`.
- The original export input is serialized into `XuatFile_ThamSo`.
- `TotalCount` and `MaxReportCount` are stored inside the export-job input object, not in the public report output DTO.
- The worker service handles `BaoCaoDoanhThuTheoSanPham` in a separate report export class and updates `vs_service_exportbill` status/path like existing invoice exports.

## Out Of Scope

- Do not change database schema.
- Do not add migrations or seed data.
- Do not split large Excel output into multiple files.
- Do not change existing invoice export behavior.
- Do not move report logic into the shared invoice Excel helper.

## Acceptance Criteria

- `TaiExcel` creates a background job when report data exceeds the configured limit.
- The background job is sent to the same `ExportData` queue consumed by `AppServiceExportBillHost`.
- Existing small export flow remains unchanged.
- The worker creates one Excel file for the report and updates the export job status.
- Build succeeds for both `HDDT.Application` and `AppServiceExportBillHost`.