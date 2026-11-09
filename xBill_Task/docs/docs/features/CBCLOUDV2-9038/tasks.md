---
feature: CBCLOUDV2-9038
status: in-progress
owner: AI + DEV
updated_at: 2026-09-24
---

# Tasks — CBCLOUDV2-9038

> Sinh theo [rules/01-create-plan.md](../../rules/01-create-plan.md). Cập nhật status và link commit/PR trong lúc làm.
> **Service** phải là `service-key` đúng theo Service registry ([../../AGENTS.md](../../AGENTS.md)).

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Pre-check Gate 1, branch, DB/deploy scope | invoice-management | completed | XS | N/A (chưa commit) |
| 2 | BE: entity/DTO/DbSet/permission lý do điều chỉnh/thay thế | invoice-management | completed | M | N/A (chưa commit) |
| 3 | BE: AppService CRUD/search/export/import/cache | invoice-management | completed | M | N/A (chưa commit) |
| 4 | FE: regenerate NSwag proxy | invoice-management | completed | XS | N/A (chưa commit) |
| 5 | FE: màn danh mục lý do điều chỉnh/thay thế | invoice-management | completed | M | N/A (chưa commit) |
| 6 | Deploy docs, seed và verification report | invoice-management | completed | S | N/A (chưa commit) |

---

## Task 1 — Pre-check Gate 1, branch, DB/deploy scope

- **Status:** completed
- **Completed at:** 2026-09-24
- **Service:** `invoice-management`
- **Mô tả:** Xác nhận plan đã được Gate 1 duyệt, repo code admin Cloud đúng branch feature từ `origin/develop_cloud`, working tree sạch, và chuẩn bị `deploy.md` với phạm vi DB/cache/seed trước khi code runtime.
- **Tiêu chí chấp nhận:**
  - [ ] `plan.md` có đủ chữ ký DEV self-review và TechLead approve trước khi Rule 02/code.
  - [ ] Repo thực tế `D:\BILL\invoicemanagement` đúng branch feature được duyệt, không làm trên repo FUTA/Liên Sơn.
  - [ ] Working tree code sạch trước khi sửa; không tự tạo/switch branch nếu chưa được user yêu cầu.
  - [ ] `deploy.md` draft ghi rõ bảng mới `vs_dm_ncc_lydo_dieuchinhthaythe`, seed/rollback, Redis cache name/key, không EF migration.
- **Kiểm chứng:**
  - [ ] `git -C "D:\BILL\invoicemanagement" status -sb` → đúng branch feature được duyệt và không có thay đổi ngoài scope.
  - [ ] Đọc `features/CBCLOUDV2-9038/plan.md` → Gate 1 approval block đã được human điền.
- **Phụ thuộc:** Không.
- **File dự kiến chạm:**
  - `features/CBCLOUDV2-9038/deploy.md`
  - `features/CBCLOUDV2-9038/plan.md` (chỉ human cập nhật approval/status)
- **Ước lượng:** XS
- **Commit/PR:** N/A (chưa commit)

---

## Task 2 — BE: entity/DTO/DbSet/permission lý do điều chỉnh/thay thế

- **Status:** completed
- **Completed at:** 2026-09-24
- **Service:** `invoice-management`
- **Mô tả:** Tạo nền backend cho danh mục lý do điều chỉnh/thay thế theo pattern `DM_NCC_QuocTich`: entity host-level map bảng `vs_dm_ncc_lydo_dieuchinhthaythe`, DbSet, DTO/input, AutoMapper, permission và localization.
- **Tiêu chí chấp nhận:**
  - [ ] Có entity `DM_NCC_LyDoDieuChinhThayThe` map `[Table("vs_dm_ncc_lydo_dieuchinhthaythe")]`, `[MultiTenancySide(MultiTenancySides.Host)]`, kế thừa `FullAuditedEntity`.
  - [ ] `HDDTDbContext` có `DbSet<DM_NCC_LyDoDieuChinhThayThe>`.
  - [ ] DTO/input có đủ field: mã, tên lý do, ghi chú, ngày bắt đầu, ngày kết thúc, hiệu lực.
  - [ ] `CustomDtoMapper` map entity ↔ DTO.
  - [ ] Danh mục lý do điều chỉnh/thay thế dùng chung permission `Admin.DanhMuc.QuocTich`, `.Create`, `.Edit`, `.Delete`, `.Import` để hiển thị/thao tác giống danh mục quốc tịch; localization có label tiếng Việt cần thiết.
- **Kiểm chứng:**
  - [ ] `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` → Build succeeded, 0 error.
- **Phụ thuộc:** Task 1 / Gate 1.
- **File dự kiến chạm:**
  - `aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_LyDoDieuChinhThayThe.cs`
  - `aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs`
  - `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLyDoDieuChinhThayThe/DMNCCLyDoDieuChinhThayTheDto.cs`
  - `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLyDoDieuChinhThayThe/GetAllDSLyDoDieuChinhThayTheInput.cs`
  - `aspnet-core/src/hddt/HDDT.Application/CustomDtoMapper.cs`
  - `aspnet-core/src/hddt/HDDT.Core/Authorization/AppPermissions.cs`
  - `aspnet-core/src/hddt/HDDT.Core/Authorization/AppAuthorizationProvider.cs`
  - `aspnet-core/src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml`
- **Ước lượng:** M
- **Commit/PR:** N/A (chưa commit)

---

## Task 3 — BE: AppService CRUD/search/export/import/cache

- **Status:** completed
- **Completed at:** 2026-09-24
- **Service:** `invoice-management`
- **Mô tả:** Tạo `DM_NCC_LyDoDieuChinhThayTheAppService` có danh sách/search/paging/sorting, `GetAllNoPage` cache Redis, thêm/sửa/xóa, export Excel, import Excel, tải file mẫu, validation và logging an toàn.
- **Tiêu chí chấp nhận:**
  - [ ] `GetAll` tìm theo mã/tên lý do, phân trang/sort đúng pattern PrimeNG/ABP.
  - [ ] `CreateOrEdit` validate required/maxlength/trùng mã/date range; create normalize mã trim/bỏ khoảng trắng/uppercase; edit không đổi mã.
  - [ ] `Delete` soft-delete bản ghi và clear cache.
  - [ ] `TaiFileDSLyDoDieuChinhThayThe`, `TaiFileMau`, `NhapFileExcel` dùng header/sheet nghiệp vụ lý do điều chỉnh/thay thế, validate header/data/duplicate/date format.
  - [ ] Import/export/logging không ghi raw Excel/base64/file content, secrets, token/JWT, connection string hoặc dữ liệu ngoài phạm vi danh mục.
  - [ ] Cache `DM_NCC_LyDoDieuChinhThayThe` key `All` dùng ABP `ICacheManager`; clear sau create/update/delete/import.
- **Kiểm chứng:**
  - [ ] Backend build pass theo lệnh ở Task 2.
  - [ ] **[manual/API]** Create/edit/delete/import → gọi lại `GetAllNoPage` → dữ liệu mới hiển thị ngay, không cần restart.
- **Phụ thuộc:** Task 2.
- **File dự kiến chạm:**
  - `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/DMNhaCungCap/DM_NCC_LyDoDieuChinhThayTheAppService.cs`
  - `aspnet-core/src/hddt/HDDT.Application/Commons/DanhMuc/DMNhaCungCap/DMNhaCungCap_THNTExcelHelper.cs`
- **Ước lượng:** M
- **Commit/PR:** N/A (chưa commit)

---

## Task 4 — FE: regenerate NSwag proxy

- **Status:** completed
- **Completed at:** 2026-09-24
- **Service:** `invoice-management`
- **Mô tả:** Chạy BE admin Cloud local và regenerate NSwag proxy để Angular có `DM_NCC_LyDoDieuChinhThayTheServiceProxy`; không sửa tay logic generated proxy.
- **Tiêu chí chấp nhận:**
  - [ ] Swagger có AppService `DM_NCC_LyDoDieuChinhThayThe` sau Task 3.
  - [ ] `service-proxies.ts` được regenerate từ `angular/nswag/refresh.bat` và có service proxy mới.
  - [ ] Không chỉnh tay logic generated proxy ngoài kết quả regenerate.
- **Kiểm chứng:**
  - [ ] Chạy BE host → `swagger/v1/swagger.json` có `DM_NCC_LyDoDieuChinhThayThe`.
  - [ ] `cd "D:\BILL\invoicemanagement\angular\nswag" && refresh.bat` → proxy sinh đúng.
- **Phụ thuộc:** Task 3.
- **File dự kiến chạm:**
  - `angular/src/shared/service-proxies/service-proxies.ts`
- **Ước lượng:** XS
- **Commit/PR:** N/A (chưa commit)

---

## Task 5 — FE: màn danh mục lý do điều chỉnh/thay thế

- **Status:** completed
- **Completed at:** 2026-09-24
- **Service:** `invoice-management`
- **Mô tả:** Tạo màn Angular danh mục lý do điều chỉnh/thay thế theo pattern `danhmuc/dmnhacungcap/quoctich`: list/search/sort/page, modal thêm/sửa, modal import, export, delete, route, menu, module declaration và proxy provider.
- **Tiêu chí chấp nhận:**
  - [ ] Route `/app/hddt/danhmuc/dmnhacungcap-lydodctt` mở được màn danh sách.
  - [ ] Menu `DanhMuc` có item “Lý do điều chỉnh/thay thế” dùng chung permission `Admin.DanhMuc.QuocTich` để hiển thị giống danh mục quốc tịch.
  - [ ] Nút thêm/sửa/xóa/import ẩn/hiện theo permission `Admin.DanhMuc.QuocTich.*`; user thiếu quyền không thao tác được.
  - [ ] UI hiển thị STT, mã, tên lý do, ngày bắt đầu, ngày kết thúc, hiệu lực, thao tác; search/filter/sort/page đúng.
  - [ ] Thêm mới default hiệu lực bật; edit không cho đổi mã; frontend validate required/maxlength cơ bản và backend validate cuối.
  - [ ] Export/import/template gọi đúng proxy mới; provider proxy được đăng ký để tránh `NullInjector: No provider`.
- **Kiểm chứng:**
  - [ ] `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` → 0 error.
  - [ ] **[manual]** Mở màn, tìm kiếm, thêm, sửa, xóa, export, tải template, import hợp lệ, import lỗi validate.
- **Phụ thuộc:** Task 4.
- **File dự kiến chạm:**
  - `angular/src/app/hddt/danhmuc/dmnhacungcap/lydodctt/*`
  - `angular/src/app/hddt/hddt-routing.module.ts`
  - `angular/src/app/hddt/hddt.module.ts`
  - `angular/src/app/shared/layout/nav/app-navigation.service.ts`
  - `angular/src/shared/service-proxies/service-proxy.module.ts`
- **Ước lượng:** M
- **Commit/PR:** N/A (chưa commit)

---

## Task 6 — Deploy docs, seed và verification report

- **Status:** completed
- **Completed at:** 2026-09-24
- **Service:** `invoice-management`
- **Mô tả:** Hoàn thiện `deploy.md` với SQL create/seed/rollback, chạy verification thật, ghi `report.md`, finalize `impact.md`, và đề xuất diff Gate 2 cho docs nền.
- **Tiêu chí chấp nhận:**
  - [ ] `deploy.md` có SQL tạo bảng `vs_dm_ncc_lydo_dieuchinhthaythe`, seed chống trùng mã từ nguồn tham chiếu đã review, rollback DB/app/cache.
  - [ ] Nếu ảnh/nguồn seed không đọc chắc chắn, không invent seed; ghi blocker/need BA confirmation trong `deploy.md`/`report.md`.
  - [ ] `report.md` ghi file thay đổi thật và output thật của backend build/frontend type-check/manual checks; không ghi secret/config value.
  - [ ] `impact.md` finalized theo blast radius thật sau code.
  - [ ] Đề xuất docs diff Gate 2 cho specs/architecture/databases/design nếu có.
- **Kiểm chứng:**
  - [ ] Backend build pass theo Task 2.
  - [ ] Frontend TypeScript check pass theo Task 5.
  - [ ] **[manual]** CRUD/search/export/import/cache trên màn lý do điều chỉnh/thay thế Cloud.
- **Phụ thuộc:** Task 1–5.
- **File dự kiến chạm:**
  - `features/CBCLOUDV2-9038/deploy.md`
  - `features/CBCLOUDV2-9038/report.md`
  - `features/CBCLOUDV2-9038/impact.md`
- **Ước lượng:** S
- **Commit/PR:** N/A (chưa commit)

---

> **Tách task** nếu: chạm hơn 8 file · đụng nhiều hệ thống con độc lập · tiêu chí chấp nhận mơ hồ · tiêu đề nối hai việc bằng chữ "và".
> Task `cancelled` phải ghi lý do.
