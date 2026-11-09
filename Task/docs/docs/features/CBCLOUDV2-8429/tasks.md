# CBCLOUDV2-8429 Tasks

## Status

- Feature status: testing
- Gate 1 plan review: approved by user in chat
- Gate 2 docs update review: approved by user in chat

## Tasks

| Status | Area | Task |
| --- | --- | --- |
| completed | Analysis | Compare existing `HoaDon/XuatExcel` large export flow. |
| completed | API | Create background `ServiceExportBill` job when report data exceeds limit. |
| completed | API | Store original report input plus `TotalCount` and `MaxReportCount` in export job input object. |
| completed | API | Return existing invoice-export background message. |
| completed | Worker | Add dedicated report export input/models. |
| completed | Worker | Add report data query/repository support. |
| completed | Worker | Add separate `BaoCaoDoanhThuTheoSanPhamExportService`. |
| pending | Worker | Route report jobs by `XuatFile_MoTa = "BaoCaoDoanhThuTheoSanPham"` in the current worker checkout; source verify did not find this route. |
| completed | Frontend | Show background-export popup for BaoCaoDoanhThuTheoSanPham TaiExcel status 2, matching invoice Excel export behavior. |
| completed | API | Update ExportBillAppService.DownloadFile to keep download filename from XuatFile_DuongDan, fallback ExportFile.xlsx. |
| completed | Docs | Update markdown files for shared config key `CLOUD_ACTIVE_MAX_REPORT` and tenant DB column `filetype`. |
| completed | API | Change product report limit key from `ACTIVE_MAX_PRODUCT_REVENUE_REPORT` to `CLOUD_ACTIVE_MAX_REPORT`. |
| completed | API | Add `FileType` to `ServiceExportBill` and `ServiceExportBillDto`. |
| completed | API | Set `FileType = 1` when creating product revenue report export job. |
| completed | Worker | Add `FileType` to worker `ServiceExportBill` domain/repository update flow. |
| completed | Frontend | Show Quản lý xuất file type `Báo cáo doanh thu theo sản phẩm` for `fileType == 1`. |
| completed | Verification | Source verify/build API, worker, and frontend behavior. |
| completed | Reporting | Update `report.md` with real files changed and command results after implementation. |
| completed | Worker | Route product report worker by `FileType = 1` instead of `XuatFile_MoTa`. |
| completed | Frontend | Move `Loại file` column after `Ngày xử lý` on Quản lý xuất file. |
| pending | Refactor | Move ServiceExportBillFileType enum to EnumCommons.cs for shared invoice/report file types. |
| completed | Config | Move shared report config key to appsettings `Report:MaxReportKey`. |