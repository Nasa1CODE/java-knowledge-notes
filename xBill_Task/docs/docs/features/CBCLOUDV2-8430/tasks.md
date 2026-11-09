# CBCLOUDV2-8430 Tasks

## Status

- Feature status: implemented
- Gate 1 plan review: approved by user in chat
- Gate 2 docs update review: approved by user in chat

## Tasks

| Status | Area | Task |
| --- | --- | --- |
| completed | Docs | Create initial task markdown files before code changes. |
| completed | API | Add raw count check for TaiExcelTheoBenMua filters. |
| completed | API | Create ServiceExportBill job and send ExportData queue message when over limit. |
| completed | Worker | Add dedicated TinhHinhSuDungHoaDonTheoBenMua export models/service/repository logic. |
| completed | Frontend | Show status 2 background export popup for TaiExcelTheoBenMua. |
| completed | Verification | Build API and worker; source verify route/queue/frontend_angular popup. |
| completed | Reporting | Update report/testcase/deploy docs with real results. |
| completed | Docs | Update markdown files for shared config key `CLOUD_ACTIVE_MAX_REPORT` and tenant DB column `filetype`. |
| completed | API | Change buyer report limit key from `ACTIVE_MAX_BUYER_REVENUE_REPORT` to `CLOUD_ACTIVE_MAX_REPORT`. |
| completed | API | Change buyer report discriminator to `BaoCaoDoanhThuTheoBenMua`. |
| completed | API | Add `FileType` to `ServiceExportBill` and `ServiceExportBillDto`. |
| completed | API | Set `FileType = 2` when creating buyer revenue report export job. |
| pending | Worker | Route `BaoCaoDoanhThuTheoBenMua` and keep fallback for `TinhHinhSuDungHoaDonTheoBenMua`. |
| completed | Worker | Add `FileType` to worker `ServiceExportBill` domain/repository update flow. |
| completed | Frontend | Show Quản lý xuất file type `Báo cáo doanh thu theo bên mua` for `fileType == 2`. |
| completed | Verification | Source verify/build API, worker, and frontend behavior. |
| completed | Reporting | Update `report.md` with real files changed and command results after implementation. |
| completed | Worker | Route buyer report worker by `FileType = 2` instead of `XuatFile_MoTa`. |
| completed | Frontend | Move `Loại file` column after `Ngày xử lý` on Quản lý xuất file. |
| pending | Refactor | Move ServiceExportBillFileType enum to EnumCommons.cs for shared invoice/report file types. |
| completed | Config | Move shared report config key to appsettings `Report:MaxReportKey`. |