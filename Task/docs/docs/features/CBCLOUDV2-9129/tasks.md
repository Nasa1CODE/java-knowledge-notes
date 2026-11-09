# Tasks — CBCLOUDV2-9129

> Sinh theo [rules/01-create-plan.md](../../rules/01-create-plan.md). Cập nhật status và link commit/PR trong lúc làm.
> **Service** phải là `service-key` đúng theo Service registry ([../../AGENTS.md](../../AGENTS.md)).

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Chuẩn bị branch, xác nhận DB scope và SQL deploy | invoice-management/docs | in-progress | S | |
| 2 | Bổ sung backend entity/DTO/mapper/DbContext | invoice-management | done | S | |
| 3 | Bổ sung backend AppService, validate, cache Redis | invoice-management | done | M | |
| 4 | Bổ sung permission, localization, Excel export/import | invoice-management | done | M | |
| 5 | Generate NSwag proxy và register provider | invoice-management | done | S | |
| 6 | Bổ sung frontend route/menu/list/modal/import | invoice-management | done | M | |
| 7 | Kiểm chứng build/manual/security/cache | invoice-management | in-progress | M | |
| 8 | Hoàn tất docs Gate 1/Gate 2 handoff | docs | ready | S | |

---

## Task 1 — Chuẩn bị branch, xác nhận DB scope và SQL deploy

- **Status:** in-progress
- **Service:** `invoice-management`, `docs`
- **Mô tả:** Chuẩn bị nhánh làm việc từ `origin/develop_cloud`, xác nhận scope DB cho bảng `vs_dm_ncc_loaictdt`, viết SQL create/seed/rollback theo đúng host/tenant DB.
- **Tiêu chí hoàn thành / DoD:**
  - [ ] Repo source ở branch `hungtq_dev_cloud_CBCLOUDV2-9129` từ base `origin/develop_cloud` hoặc trạng thái branch được ghi rõ nếu không switch được.
  - [ ] TechLead/DBA xác nhận bảng `vs_dm_ncc_loaictdt` thuộc host DB hay tenant DB trước khi chạy SQL.
  - [ ] Có SQL create table với audit columns theo `FullAuditedEntity` và field nghiệp vụ `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_BatDau`, `LoaiCTDT_KetThuc`, `LoaiCTDT_HieuLuc`.
  - [ ] Có seed 8 dòng từ [expect.md](expect.md), chống insert trùng mã khi deploy lại.
  - [ ] Có rollback xóa seed/drop table an toàn, nêu rõ điều kiện không drop khi đã có dữ liệu thật.
  - [ ] Không dùng EF migration cho `vs_*`.
- **Kiểm chứng:**
  - [ ] Review SQL thủ công với DBA/TechLead.
  - [ ] Chạy SQL trên môi trường local/dev phù hợp nếu được phép; kỳ vọng table/seed đúng và rollback chạy được trên DB test.
- **Phụ thuộc:** [plan.md](plan.md) được Gate 1 review; xác nhận DB scope.
- **File dự kiến chạm:**
  - `docs/databases/databasehost.vs_dm_ncc_loaictdt.sql` hoặc `docs/databases/databasetenant.vs_dm_ncc_loaictdt.sql`
  - `docs/features/CBCLOUDV2-9129/deploy.md`
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

---

## Task 2 — Bổ sung backend entity/DTO/mapper/DbContext

- **Status:** done
- **Service:** `invoice-management`
- **Mô tả:** Thêm lớp domain và DTO cho danh mục loại chứng từ điện tử, đăng ký DbSet và mapping AutoMapper.
- **Tiêu chí hoàn thành / DoD:**
  - [x] Có entity `DM_NCC_LoaiCTDT` map bảng `vs_dm_ncc_loaictdt`.
  - [x] Entity dùng `FullAuditedEntity` và `MultiTenancySide` đúng với DB scope đã chốt trong plan (`Host`); DBA/TechLead vẫn cần xác nhận trước deploy SQL.
  - [x] Có DTO `DMNCCLoaiCTDTDto` gồm đủ field AC.
  - [x] Có input DTO search/page theo pattern danh mục quốc tịch.
  - [x] `HDDTDbContext` có `DbSet` tương ứng.
  - [x] `CustomDtoMapper` map entity ↔ DTO.
- **Kiểm chứng:**
  - [x] Backend compile qua bước build ở Task 7: `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln"` → `Build succeeded.`
  - [x] Review naming namespace/path giống `DMNCCQuocTich`.
- **Phụ thuộc:** Task 1 chốt DB scope/schema.
- **File dự kiến chạm:**
  - `invoice-management/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_LoaiCTDT.cs`
  - `invoice-management/aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLoaiCTDT/DMNCCLoaiCTDTDto.cs`
  - `invoice-management/aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLoaiCTDT/GetAllDSLoaiCTDTInput.cs`
  - `invoice-management/aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs`
  - `invoice-management/aspnet-core/src/hddt/HDDT.Application/CustomDtoMapper.cs`
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

---

## Task 3 — Bổ sung backend AppService, validate, cache Redis

- **Status:** done
- **Service:** `invoice-management`
- **Mô tả:** Tạo AppService CRUD/search/cache cho danh mục loại chứng từ điện tử theo pattern `DM_NCC_QuocTichAppService`.
- **Tiêu chí hoàn thành / DoD:**
  - [x] Có `DM_NCC_LoaiCTDTAppService` với các method tối thiểu: `GetAll`, `GetAllNoPage`, `GetLoaiCTDTForEdit`, `CreateOrEdit`, `Delete`, `TaiFileDSLoaiCTDT`, `NhapFileExcel`, `TaiFileMau`.
  - [x] `GetAll` filter theo mã/mô tả, sort/page đúng.
  - [x] `CreateOrEdit` dispatch đúng create/update và kiểm tra permission tương ứng.
  - [x] Validate required/max length/duplicate/date range đúng AC.
  - [x] `Delete` thực hiện ngừng hiệu lực (`LoaiCTDT_HieuLuc = 0`), không hard delete.
  - [x] Cache sử dụng `ICacheManager`, cache name `DM_NCC_LoaiCTDT`, key `All`.
  - [x] Cache được clear sau Create/Update/Ngừng hiệu lực/Import.
  - [x] Logging không ghi secrets, raw file/base64, token/JWT hoặc dữ liệu nhạy cảm ngoài scope.
- **Kiểm chứng:**
  - [ ] Unit/manual call API với dữ liệu hợp lệ/lỗi validate.
  - [ ] Manual kiểm tra cache trước/sau mutation không trả dữ liệu cũ.
  - [x] Backend build ở Task 7 pass: `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln"` → `Build succeeded.`
- **Phụ thuộc:** Task 2.
- **File dự kiến chạm:**
  - `invoice-management/aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/DMNhaCungCap/DM_NCC_LoaiCTDTAppService.cs`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 4 — Bổ sung permission, localization, Excel export/import

- **Status:** done
- **Service:** `invoice-management`
- **Mô tả:** Thêm permission tree, text tiếng Việt và helper export/import/template cho danh mục loại chứng từ điện tử.
- **Tiêu chí hoàn thành / DoD:**
  - [x] Có permission constants `Admin.DanhMuc.LoaiCTDT`, `.Create`, `.Edit`, `.Delete`, `.Import`.
  - [x] Permission được register dưới nhóm danh mục admin tương tự `QuocTich`.
  - [x] Có localization keys: `LoaiChungTuDienTu`, `TaoMoiLoaiChungTuDienTu`, `ChinhSuaLoaiChungTuDienTu`, `NgungHieuLucLoaiChungTuDienTu`, `NhapDanhSachLoaiChungTuDienTu`, `ThongTinLoaiChungTuDienTu`.
  - [x] Export Excel có file/sheet/header đúng nghiệp vụ, whitelist cột STT/Mã/Mô tả/Bắt đầu/Kết thúc/Hiệu lực.
  - [x] Import Excel chỉ nhận `.xlsx` theo template, validate header/data/duplicate/date.
  - [x] Import/export không lộ secrets/config/token/JWT/audit/internal IDs/user info theo phần code thêm mới.
- **Kiểm chứng:**
  - [ ] Role không có quyền không thấy/không thao tác được chức năng tương ứng.
  - [ ] Export file mở được, cột đúng và filter/sorting đúng.
  - [ ] Import file mẫu thành công; file sai header/trùng mã/date sai trả lỗi an toàn.
  - [x] Backend build ở Task 7 pass: `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln"` → `Build succeeded.`
- **Phụ thuộc:** Task 3 cho AppService contract; Task 1 cho schema field.
- **File dự kiến chạm:**
  - `invoice-management/aspnet-core/src/hddt/HDDT.Core/Authorization/AppPermissions.cs`
  - `invoice-management/aspnet-core/src/hddt/HDDT.Core/Authorization/AppAuthorizationProvider.cs`
  - `invoice-management/aspnet-core/src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml`
  - `invoice-management/aspnet-core/src/hddt/HDDT.Application/Commons/DanhMuc/DMNhaCungCap/DMNhaCungCap_THNTExcelHelper.cs`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 5 — Generate NSwag proxy và register provider

- **Status:** done
- **Service:** `invoice-management`
- **Mô tả:** Generate Angular service proxy từ backend contract và đăng ký provider cho service mới.
- **Tiêu chí hoàn thành / DoD:**
  - [x] `service-proxies.ts` có generated `DM_NCC_LoaiCTDTServiceProxy` và DTO liên quan sau khi chạy NSwag.
  - [x] Không sửa tay generated proxy; proxy được sinh bằng `angular/nswag/refresh.bat`.
  - [x] `service-proxy.module.ts` đăng ký provider `ApiServiceProxies.DM_NCC_LoaiCTDTServiceProxy`.
  - [x] Angular compile/type-check nhận proxy mới.
- **Kiểm chứng:**
  - [x] Generate proxy không lỗi: `angular/nswag/refresh.bat` → `Done.`
  - [x] Frontend type-check/build ở Task 7 pass: `.\node_modules\.bin\tsc -p src\tsconfig.json --noEmit` → completed with no output.
- **Phụ thuộc:** Backend AppService build được từ Task 3/4.
- **File dự kiến chạm:**
  - `invoice-management/angular/src/shared/service-proxies/service-proxies.ts`
  - `invoice-management/angular/src/shared/service-proxies/service-proxy.module.ts`
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

---

## Task 6 — Bổ sung frontend route/menu/list/modal/import

- **Status:** done
- **Service:** `invoice-management`
- **Mô tả:** Tạo màn hình Angular danh mục loại chứng từ điện tử theo pattern `dmnhacungcap-quoctich`.
- **Tiêu chí hoàn thành / DoD:**
  - [x] Có route `/app/hddt/danhmuc/dmnhacungcap-loaictdt`.
  - [x] Có menu item `LoaiChungTuDienTu` với permission `Admin.DanhMuc.LoaiCTDT`.
  - [x] Component danh sách có filter, PrimeNG table, paginator, sorting, export/import/add/action buttons.
  - [x] Modal thêm/sửa có mã, mô tả, ngày bắt đầu, ngày kết thúc, hiệu lực; mã disabled khi edit.
  - [x] Action “ngừng hiệu lực” dùng confirm wording phù hợp, không gây hiểu là hard delete nếu có thể.
  - [x] Import modal chọn `.xlsx`, tải file mẫu, gọi proxy import, không log/nêu raw file content ở UI.
  - [x] Buttons hiển thị theo permission tương ứng.
- **Kiểm chứng:**
  - [x] Angular type-check/build ở Task 7 pass: `.\node_modules\.bin\tsc -p src\tsconfig.json --noEmit` → completed with no output.
  - [ ] Manual mở menu, search/page/sort, thêm/sửa/ngừng hiệu lực, export/import.
- **Phụ thuộc:** Task 5 có proxy; Task 4 có localization/permission.
- **File dự kiến chạm:**
  - `invoice-management/angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/dmnhacungcap-loaictdt.component.ts`
  - `invoice-management/angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/dmnhacungcap-loaictdt.component.html`
  - `invoice-management/angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/thongtin-dmnccloaictdt-modal.component.ts`
  - `invoice-management/angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/thongtin-dmnccloaictdt-modal.component.html`
  - `invoice-management/angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/nhap-file-dmnccloaictdt-modal.component.ts`
  - `invoice-management/angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/nhap-file-dmnccloaictdt-modal.component.html`
  - `invoice-management/angular/src/app/hddt/hddt-routing.module.ts`
  - `invoice-management/angular/src/app/hddt/hddt.module.ts`
  - `invoice-management/angular/src/app/shared/layout/nav/app-navigation.service.ts`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 7 — Kiểm chứng build/manual/security/cache

- **Status:** in-progress
- **Service:** `invoice-management`
- **Mô tả:** Chạy kiểm chứng kỹ thuật và manual testcase trước khi bàn giao review.
- **Tiêu chí hoàn thành / DoD:**
  - [x] Backend build pass.
  - [x] Frontend type-check/build tối thiểu pass.
  - [ ] Manual testcase CRUD/search/export/import/security/cache pass hoặc có log lỗi rõ.
  - [x] Không có secrets/token/connection string thật trong docs/code/logs được thêm bởi ticket theo phần code/docs đã thêm.
  - [ ] Ghi lại command/output chính trong report hoặc PR notes.
- **Kiểm chứng:**
  - [x] `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln"` → `Build succeeded.`
  - [x] NSwag generate proxy theo quy trình repo: `angular/nswag/refresh.bat` → `Done.`
  - [x] `.\node_modules\.bin\tsc -p src\tsconfig.json --noEmit` trong `D:\BILL\invoicemanagement\angular` → completed with no output.
  - [ ] Thực thi testcase trong [testcase.md](testcase.md).
- **Phụ thuộc:** Task 1–6.
- **File dự kiến chạm:**
  - `docs/features/CBCLOUDV2-9129/report.md` nếu Rule sau yêu cầu report.
  - Không chạm code nếu chỉ chạy test, trừ fix lỗi phát hiện.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 8 — Hoàn tất docs Gate 1/Gate 2 handoff

- **Status:** ready
- **Service:** `docs`
- **Mô tả:** Cập nhật tài liệu feature và các docs liên quan sau khi plan/test/deploy được review.
- **Tiêu chí hoàn thành / DoD:**
  - [ ] [expect.md](expect.md), [plan.md](plan.md), [impact.md](impact.md), [deploy.md](deploy.md), [testcase.md](testcase.md) thống nhất AC/scope/risks.
  - [ ] Gate 1 checklist được DEV/TechLead điền bởi người có thẩm quyền, AI không tự tick.
  - [ ] Nếu sau implement có thay đổi specs/system/design/database docs thì cập nhật theo Rule tương ứng.
  - [ ] Các assumption không còn đúng được sửa trong plan/deploy/testcase.
- **Kiểm chứng:**
  - [ ] Review chéo links/file paths/status.
  - [ ] Chạy layout/docs check nếu môi trường cho phép.
- **Phụ thuộc:** Gate 1 approval và kết quả implement/test ở các rule sau.
- **File dự kiến chạm:**
  - `docs/features/CBCLOUDV2-9129/*.md`
  - `docs/databases/*.sql`
  - `docs/specs/system.md` hoặc docs domain liên quan nếu cần
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>
