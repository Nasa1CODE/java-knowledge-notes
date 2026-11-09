# Tasks — CBCLOUDV2-8963

> Sinh theo [rules/01-create-plan.md](../../rules/01-create-plan.md). Cập nhật status và link commit/PR trong lúc làm.
> **Service** phải là `service-key` đúng theo Service registry ([../../AGENTS.md](../../AGENTS.md)).

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 0 | Chốt AC, schema, cache Redis, nhánh Cloud và phạm vi host-level | — | pending | XS | |
| 1 | BE Cloud: thêm entity/DTO/DbSet/permission quốc tịch | invoice-management/aspnet-core | pending | M | |
| 2 | BE Cloud: AppService CRUD + Excel + Redis cache | invoice-management/aspnet-core | pending | M | |
| 3 | FE Cloud: regenerate NSwag service proxy | invoice-management/angular | pending | XS | |
| 4 | FE Cloud: thêm màn Danh mục quốc tịch | invoice-management/angular | pending | M | |
| 5 | Deploy docs và manual verification Cloud | invoice-management/aspnet-core, invoice-management/angular | pending | S | |

---

## Task 0 — Chốt AC, schema, cache Redis, nhánh Cloud và phạm vi host-level

- **Status:** pending
- **Service:** — (BA/DEV/TechLead/DBA, không code)
- **Mô tả:** Chốt các câu hỏi chặn trong `plan.md`: AC, cache Redis, quy trình tạo bảng, bộ cột/ràng buộc, phạm vi host-level, nhánh Cloud.
- **Tiêu chí chấp nhận:**
  - [ ] `expect.md` có Acceptance Criteria rõ cho CRUD/search/export/import/file mẫu/cache Redis/phân quyền.
  - [ ] `plan.md` B0–B5 có dòng **Chốt:** kèm ngày/người chốt.
  - [ ] DBA/TechLead xác nhận cách tạo bảng `vs_dm_ncc_quoctich` và rollback cho Cloud; không dùng EF migration.
  - [ ] Repo `D:\BILL\invoicemanagement` ở nhánh `hungtq_dev_cloud` sinh từ `origin/develop_cloud` và working tree sạch trước khi code.
- **Kiểm chứng:**
  - [ ] Đọc `expect.md`, `plan.md`, `git status -sb` trước khi bắt đầu rule 02.
- **Phụ thuộc:** Không
- **File dự kiến chạm:**
  - `docs/features/CBCLOUDV2-8963/expect.md`
  - `docs/features/CBCLOUDV2-8963/plan.md`
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>

---

## Task 1 — BE Cloud: thêm entity/DTO/DbSet/permission quốc tịch

- **Status:** pending
- **Service:** `invoice-management/aspnet-core`
- **Mô tả:** Tạo lớp nền cho danh mục quốc tịch trên Cloud theo pattern Cloud `DM_NCC_NganHang`: entity host-level, DTO/input, AutoMapper, `DbSet`, permission `Admin.DanhMuc.QuocTich.*`.
- **Tiêu chí chấp nhận:**
  - [ ] Có entity `DM_NCC_QuocTich` map `[Table("vs_dm_ncc_quoctich")]`, `[MultiTenancySide(MultiTenancySides.Host)]`, kế thừa `FullAuditedEntity` nếu B4 chốt host-level.
  - [ ] `HDDTDbContext` có `DbSet<DM_NCC_QuocTich>`.
  - [ ] Có DTO/input đủ field: `QuocTich_Ma`, `QuocTich_Ten`, `QuocTich_BatDau`, `QuocTich_KetThuc`, `QuocTich_HieuLuc`.
  - [ ] `CustomDtoMapper` map 2 chiều entity ↔ DTO.
  - [ ] Permission `Admin.DanhMuc.QuocTich`, `.Create`, `.Edit`, `.Delete`, `.Import` được khai báo và đăng ký; localization có label cần thiết.
- **Kiểm chứng:**
  - [ ] `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` → Build succeeded, 0 error.
- **Phụ thuộc:** Task 0 / Gate 1
- **File dự kiến chạm:**
  - `src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_QuocTich.cs`
  - `src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs`
  - `src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCQuocTich/DMNCCQuocTichDto.cs`
  - `src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCQuocTich/GetAllDSQuocTichInput.cs`
  - `src/hddt/HDDT.Application/CustomDtoMapper.cs`
  - `src/hddt/HDDT.Core/Authorization/AppPermissions.cs`
  - `src/hddt/HDDT.Core/Authorization/AppAuthorizationProvider.cs`
  - `src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 2 — BE Cloud: AppService CRUD + Excel + Redis cache

- **Status:** pending
- **Service:** `invoice-management/aspnet-core`
- **Mô tả:** Tạo `DM_NCC_QuocTichAppService` có tìm kiếm/phân trang, `GetAllNoPage` dùng cache, thêm/sửa/xóa, xuất Excel, nhập Excel, tải file mẫu; thêm logic clear cache sau mọi thay đổi dữ liệu.
- **Tiêu chí chấp nhận:**
  - [ ] `GetAll` tìm theo mã/tên, phân trang/sort như danh mục NCC Cloud hiện có.
  - [ ] `CreateOrEdit`, `Delete` validate mã/tên, normalize mã uppercase, chặn trùng mã chưa xóa.
  - [ ] `TaiFileDSQuocTich`, `NhapFileExcel`, `TaiFileMau` hoạt động theo pattern Excel helper hiện có.
  - [ ] Có cache Redis qua ABP `ICacheManager` cho danh sách quốc tịch không phân trang; clear cache sau Create/Update/Delete/Import.
  - [ ] Có try/catch/logging an toàn để trace lỗi runtime Cloud; không log secret hoặc base64 file import.
- **Kiểm chứng:**
  - [ ] Backend build pass.
  - [ ] **[manual/API]** Gọi API tạo/sửa/xóa/import → gọi lại API danh sách cache → dữ liệu mới hiển thị ngay, không cần restart.
- **Phụ thuộc:** Task 1
- **File dự kiến chạm:**
  - `src/hddt/HDDT.Application/AppServices/DanhMuc/DMNhaCungCap/DM_NCC_QuocTichAppService.cs`
  - `src/hddt/HDDT.Application/Commons/DanhMuc/DMNhaCungCap/DMNhaCungCap_THNTExcelHelper.cs`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 3 — FE Cloud: regenerate NSwag service proxy

- **Status:** pending
- **Service:** `invoice-management/angular`
- **Mô tả:** Chạy BE admin Cloud local và regenerate NSwag proxy để FE có `DM_NCC_QuocTichServiceProxy`. Không sửa tay logic file sinh.
- **Tiêu chí chấp nhận:**
  - [ ] Swagger có AppService quốc tịch sau Task 2.
  - [ ] `service-proxies.ts` được regenerate từ `angular/nswag/refresh.bat` và có `DM_NCC_QuocTichServiceProxy`.
  - [ ] Không chỉnh tay logic trong `service-proxies.ts`.
- **Kiểm chứng:**
  - [ ] BE host chạy được; `swagger/v1/swagger.json` có `DM_NCC_QuocTich`.
  - [ ] `cd "D:\BILL\invoicemanagement\angular\nswag" && refresh.bat` → proxy sinh đúng.
- **Phụ thuộc:** Task 2
- **File dự kiến chạm:**
  - `src/shared/service-proxies/service-proxies.ts`
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>

---

## Task 4 — FE Cloud: thêm màn Danh mục quốc tịch

- **Status:** pending
- **Service:** `invoice-management/angular`
- **Mô tả:** Tạo màn danh mục quốc tịch theo pattern Cloud `danhmuc/dmnhacungcap/nganhang`: danh sách + tìm kiếm + thêm/sửa modal + nhập Excel modal + xuất Excel + xóa; thêm route/module/menu/provider.
- **Tiêu chí chấp nhận:**
  - [ ] Route `/app/hddt/danhmuc/dmnhacungcap-quoctich` mở được màn danh sách quốc tịch.
  - [ ] Menu `DanhMuc` có item Quốc tịch và bị ràng quyền `Admin.DanhMuc.QuocTich`.
  - [ ] Tạo/sửa/xóa/tìm kiếm/xuất Excel/nhập Excel gọi đúng `DM_NCC_QuocTichServiceProxy`.
  - [ ] UI dùng style/pattern PrimeNG/ABP giống danh mục NCC Cloud hiện có; ô search và nút tìm kiếm nằm gần nhau.
  - [ ] `service-proxy.module.ts` có provider `DM_NCC_QuocTichServiceProxy` để tránh lỗi runtime `No provider`.
- **Kiểm chứng:**
  - [ ] `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` → 0 error.
  - [ ] **[manual]** Mở màn, thao tác CRUD/search/export/import với dữ liệu sample `AD`, `AE`, `AF`.
- **Phụ thuộc:** Task 3
- **File dự kiến chạm:**
  - `src/app/hddt/danhmuc/dmnhacungcap/quoctich/*`
  - `src/app/hddt/hddt-routing.module.ts`
  - `src/app/hddt/hddt.module.ts`
  - `src/app/shared/layout/nav/app-navigation.service.ts`
  - `src/shared/service-proxies/service-proxy.module.ts`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 5 — Deploy docs và manual verification Cloud

- **Status:** pending
- **Service:** `invoice-management/aspnet-core`, `invoice-management/angular`
- **Mô tả:** Hoàn thiện `deploy.md`, chạy build/kiểm thử manual Cloud, ghi nhận kết quả thật vào `report.md`.
- **Tiêu chí chấp nhận:**
  - [ ] `deploy.md` có script tạo bảng/rollback MariaDB, thứ tự deploy, ghi chú Redis/cache, seed/import dữ liệu nếu có.
  - [ ] BE build, FE type-check/build/manual status đã ghi kết quả thật trong `report.md`.
  - [ ] Đề xuất diff Gate 2 cho docs nền được liệt kê.
- **Kiểm chứng:**
  - [ ] Backend build pass.
  - [ ] Frontend TypeScript check pass.
  - [ ] **[manual]** CRUD/search/export/import/cache trên màn quốc tịch Cloud.
- **Phụ thuộc:** Task 1–4
- **File dự kiến chạm:**
  - `docs/features/CBCLOUDV2-8963/deploy.md`
  - `docs/features/CBCLOUDV2-8963/report.md`
  - `docs/features/CBCLOUDV2-8963/impact.md`
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

---

> **Tách task** nếu: chạm hơn 8 file · đụng nhiều hệ thống con độc lập · tiêu chí chấp nhận mơ hồ · tiêu đề nối hai việc bằng chữ "và".
> Task `cancelled` phải ghi lý do.
