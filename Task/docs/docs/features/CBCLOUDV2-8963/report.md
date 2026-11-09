# Report — CBCLOUDV2-8963

## 1. Tóm tắt triển khai

Chưa triển khai code. Feature đang ở giai đoạn lập tài liệu/Gate 1 cho hệ thống Cloud.

Dự kiến triển khai:

- BE: entity/DTO/DbSet/permission/AppService CRUD/search/export/import/file mẫu/cache Redis cho danh mục quốc tịch trên Cloud.
- FE: regenerate NSwag proxy, thêm màn danh mục quốc tịch, route, module declaration, provider và menu trên Cloud.
- Docs: tạo hướng dẫn deploy/rollback DB MariaDB và ghi nhận kết quả kiểm chứng thật.

## 2. File đã chạm

### Docs

- `docs/features/CBCLOUDV2-8963/expect.md`
- `docs/features/CBCLOUDV2-8963/plan.md`
- `docs/features/CBCLOUDV2-8963/tasks.md`
- `docs/features/CBCLOUDV2-8963/impact.md`
- `docs/features/CBCLOUDV2-8963/deploy.md`
- `docs/features/CBCLOUDV2-8963/report.md`

### Backend `invoice-management/aspnet-core`

Chưa code. Dự kiến sau Gate 1:

- `src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_QuocTich.cs`
- `src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs`
- `src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCQuocTich/*`
- `src/hddt/HDDT.Application/CustomDtoMapper.cs`
- `src/hddt/HDDT.Core/Authorization/AppPermissions.cs`
- `src/hddt/HDDT.Core/Authorization/AppAuthorizationProvider.cs`
- `src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml`
- `src/hddt/HDDT.Application/AppServices/DanhMuc/DMNhaCungCap/DM_NCC_QuocTichAppService.cs`
- `src/hddt/HDDT.Application/Commons/DanhMuc/DMNhaCungCap/DMNhaCungCap_THNTExcelHelper.cs`

### Frontend `invoice-management/angular`

Chưa code. Dự kiến sau Gate 1:

- `src/shared/service-proxies/service-proxies.ts`
- `src/shared/service-proxies/service-proxy.module.ts`
- `src/app/hddt/danhmuc/dmnhacungcap/quoctich/*`
- `src/app/hddt/hddt-routing.module.ts`
- `src/app/hddt/hddt.module.ts`
- `src/app/shared/layout/nav/app-navigation.service.ts`

## 3. Kết quả kiểm chứng

| Hạng mục | Lệnh/bước | Kết quả thật |
|---|---|---|
| Git branch Cloud | `git -C "D:\BILL\invoicemanagement" switch -c hungtq_dev_cloud origin/develop_cloud` | **Pass** — đã tạo nhánh `hungtq_dev_cloud` tracking `origin/develop_cloud`. |
| Docs CBCLOUDV2-8963 | Tạo folder `docs/features/CBCLOUDV2-8963/` và các file draft | **Pass** — đã tạo bộ docs draft: `expect.md`, `plan.md`, `tasks.md`, `impact.md`, `deploy.md`, `report.md`. |
| Gate 1 | DEV self-review + TechLead approve trong `plan.md`, `expect.md status: approved` | **Chưa thực hiện** — cần người duyệt/chốt, AI không tự approve. |
| BE build | `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` | **Chưa thực hiện cho code 8963** — chưa code theo rule 02. |
| Swagger/NSwag | Chạy BE Cloud local và `angular/nswag/refresh.bat` | **Chưa thực hiện** — cần code BE trước. |
| FE TypeScript check | `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` | **Chưa thực hiện cho code 8963** — chưa code FE. |
| Manual CRUD/search/export/import/cache | Mở màn và thao tác sample `AD`, `AE`, `AF`; kiểm Redis stale cache sau thay đổi dữ liệu | **Chưa thực hiện** — cần Gate 1, code, DB đã tạo bảng `vs_dm_ncc_quoctich` và Redis/môi trường Cloud chạy được. |

## 4. DB deploy script

- `deploy.md` đã có script tạo/rollback bảng `vs_dm_ncc_quoctich` cho MariaDB Cloud.
- Script chính dùng `AUTO_INCREMENT`, `DATETIME(6)`, `TINYINT(1)` cho `IsDeleted`, charset/collation `utf8mb4_unicode_ci`.
- Unique mã active dùng generated column `QuocTich_Ma_Active` để chỉ enforce trùng mã với bản ghi chưa xóa mềm (`IsDeleted = 0`).
- Có fallback MariaDB nếu môi trường không hỗ trợ generated column, nhưng fallback có hạn chế với trường hợp xóa/tạo lại cùng mã nhiều lần.

## 5. Manual/API còn cần làm

- Gate 1: DEV tự review, TechLead approve, human đổi `expect.md` sang `status: approved`.
- DBA/TechLead review và chạy SQL tạo bảng Cloud trong `deploy.md`.
- Gán quyền `Admin.DanhMuc.QuocTich.*` cho role test phù hợp.
- Mở route `/app/hddt/danhmuc/dmnhacungcap-quoctich`.
- Tạo/sửa/xóa/tìm kiếm mã `AD`, `AE`, `AF`.
- Tải file mẫu, nhập Excel, xuất Excel.
- Gọi danh sách/cache, thay đổi dữ liệu, đọc lại để xác nhận cache clear/cập nhật không cần restart.

## 6. Đề xuất Gate 2 docs nền

- `specs/danh-muc-cau-hinh.md`: thêm `DM_NCC_QuocTich` vào nhóm danh mục NCC Cloud, ghi rõ CRUD/import/export/cache Redis.
- `databases/README.md`: sau khi DBA chốt schema, thêm bảng `vs_dm_ncc_quoctich` vào nhóm bảng `DM_NCC_*`.
- `architecture.md`: nếu cache danh mục admin trở thành pattern chung, bổ sung ghi chú cache Redis/invalidation cho danh mục.
- `conventions/`: cân nhắc bổ sung convention riêng cho admin service Cloud vì hiện chưa có file convention admin service để rule 02 đọc.

## 7. Kết luận

Đã tạo bộ docs draft cho CBCLOUDV2-8963 và chuẩn bị nhánh git Cloud `hungtq_dev_cloud`. Chưa triển khai code vì `expect.md` đang `draft` và Gate 1 chưa được người duyệt. Sau khi Gate 1 approved, tiếp tục port code từ nghiệp vụ CBCLOUDV2-8988 sang codebase Cloud theo task 1–5.
