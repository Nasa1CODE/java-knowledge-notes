# CBCLOUDV2-8429 Testcase

## Source

- Based on `expect.md` and follow-up rule for `vs_service_exportbill.filetype`.

## Test Cases

| ID | Scenario | Steps | Expected Result | Status |
| --- | --- | --- | --- | --- |
| TC-01 | Small report export | Export BaoCaoDoanhThuTheoSanPham with data count under or equal configured limit. | API returns Excel directly as before. | not run manually |
| TC-02 | Large report export creates job | Export report with data count greater than configured limit. | API creates `ServiceExportBill`, sends queue message, and returns background export message. | verified by source/build |
| TC-03 | Queue target compatibility | Check invoicecore `QueueExportHoaDon` and worker `ExportBill:QueueName`. | Both use `ExportData`. | verified by source |
| TC-04 | Worker report routing | Process export job with `XuatFile_MoTa = "BaoCaoDoanhThuTheoSanPham"`. | Worker calls `BaoCaoDoanhThuTheoSanPhamExportService`, not invoice helper. | pending - current worker checkout has no report route source |
| TC-05 | Existing invoice export regression | Process normal invoice export job. | Existing invoice export flow remains unchanged. | verified by source/build |
| TC-06 | Missing config fallback | Redis/DB value missing or invalid for `CLOUD_ACTIVE_MAX_REPORT`. | Limit falls back to `50000`. | verified by source/build |
| TC-07 | Export metadata location | Inspect report output DTO and job input model. | `TotalCount` and `MaxReportCount` are stored in export input object, not public report output DTO. | verified by source/build |
| TC-08 | Product report file type saved | Create product revenue report background job. | `vs_service_exportbill.filetype = 1`. | verified by source/build |
| TC-09 | Product report file type display | Open Quản lý xuất file for a product report job. | Loại file shows `Báo cáo doanh thu theo sản phẩm`. | verified by source |
| TC-10 | Old/null file type display | Open Quản lý xuất file for invoice/old rows where `filetype` is null/0. | Loại file shows `Hóa đơn`. | verified by source |
| TC-11 | Shared config key | Source verify report limit lookup. | Product report uses `CLOUD_ACTIVE_MAX_REPORT`, not `ACTIVE_MAX_PRODUCT_REVENUE_REPORT`. | verified by source/build |

## Verification Evidence

- Updated in `report.md` with real command results on 2026-07-07.
