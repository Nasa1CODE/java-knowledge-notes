---
feature: CBCLOUDV2-9038
title: "[DEV] [CLOUD] [ND254] [Admin] Danh mục lý do điều chỉnh/thay thế"
status: approved
service: invoice-management
service-repo: ./invoice-management
services-affected: [invoice-management]
owner: AI + DEV
created_at: 2026-09-23
updated_at: 2026-09-23
---

# Plan — CBCLOUDV2-9038: [DEV] [CLOUD] [ND254] [Admin] Danh mục lý do điều chỉnh/thay thế

> DEV sở hữu. Sinh cùng AI theo [rules/01-create-plan.md](../../rules/01-create-plan.md). **DEV bắt buộc tự review trước khi trình Gate 1.**
> Status vòng đời feature nằm ở `expect.md`. Ở đây chỉ là trạng thái của bản plan.

plan-status: approved   # draft → plan-review → approved  (CHỈ cho bản plan)

service: invoice-management
service-repo: ./invoice-management

## 1. Blocking questions

None.

## 2. Approach summary

Tạo danh mục host-level **Lý do điều chỉnh/thay thế** trong admin Cloud, theo pattern đã tồn tại của **Danh mục quốc tịch** trong repo Cloud `invoicemanagement`: backend ABP thêm entity/DTO/AppService/permission/Excel/cache, frontend Angular thêm route/menu/component/modal/import-export, và DB tạo bảng nghiệp vụ mới bằng SQL script/rollback trong `deploy.md` khi implement. Không thay đổi invoice issuance/searchBill/workers/message contract. Service-key trong docs dùng canonical registry `invoice-management`; source checkout hiện có trong workspace là `D:\BILL\invoicemanagement` (git repo `invoicemanagement`, branch `develop_cloud`) để DEV dùng khi Rule 02.

## 3. Requirement trace

| AC trong `expect.md` | Covered by section |
|---|---|
| AC1 — Menu, phân quyền và truy cập màn hình | §5.1, §8, §11 |
| AC2 — Danh sách, tìm kiếm, phân trang và sắp xếp | §5.2, §11 |
| AC3 — Thêm mới lý do điều chỉnh/thay thế | §5.3, §7, §11 |
| AC4 — Chỉnh sửa lý do điều chỉnh/thay thế | §5.4, §7, §11 |
| AC5 — Xóa lý do điều chỉnh/thay thế | §5.5, §7, §11 |
| AC6 — Seed dữ liệu mẫu | §5.6, §7, §11 |
| AC7 — Export Excel | §5.7, §11 |
| AC8 — Import Excel và an toàn thông tin | §5.8, §11, §12 |
| AC9 — Redis cache | §5.9, §8, §11 |
| AC10 — Kiểm chứng tối thiểu trước bàn giao | §11 |

## 4. Affected services

| Service | Severity | Main change |
|---|---:|---|
| `invoice-management` | Cao | Admin portal Cloud: thêm bảng `vs_dm_ncc_lydo_dieuchinhthaythe`, BE ABP AppService dynamic API, FE Angular screen/menu/route/proxy/provider, Redis cache/invalidation. |

## 5. Detailed design, per acceptance criterion

### 5.1 AC1 — Menu, phân quyền và truy cập màn hình

- **Approach:** Thêm permission riêng cho danh mục lý do điều chỉnh/thay thế dưới nhóm `Admin.DanhMuc`, tương tự `Admin.DanhMuc.QuocTich`: quyền xem màn hình/danh sách, `Create`, `Edit`, `Delete`, `Import`. Menu `DanhMuc` hiển thị item mới chỉ khi user có quyền xem. Nút thêm/sửa/xóa/import trên component kiểm quyền tương ứng theo pattern hiện hữu.
- **API:** Dynamic ABP AppService mới `DM_NCC_LyDoDieuChinhThayTheAppService`; các method chính dùng permission riêng:
  - `GetAll(Filter, Sorting, SkipCount, MaxResultCount)` → `PagedResultDto<DMNCCLyDoDieuChinhThayTheDto>`; permission xem.
  - `GetLyDoDieuChinhThayTheForEdit(EntityDto<int>)` → DTO; permission xem.
  - `CreateOrEdit(DMNCCLyDoDieuChinhThayTheDto)` → `FileDataDto`; tự check `Create`/`Edit` theo `Id`.
  - `Delete(EntityDto<int>)`; permission `Delete`.
  - `NhapFileExcel(FileDataDto)`, `TaiFileMau()`; permission `Import`.
  - `TaiFileDSLyDoDieuChinhThayThe(Filter, Sorting)`; permission xem.
- **Backend:**
  - `aspnet-core/src/hddt/HDDT.Core/Authorization/AppPermissions.cs`: thêm `Admin_DanhMuc_LyDoDieuChinhThayThe`, `.Create`, `.Edit`, `.Delete`, `.Import` cạnh block `Admin_DanhMuc_QuocTich`.
  - `aspnet-core/src/hddt/HDDT.Core/Authorization/AppAuthorizationProvider.cs`: đăng ký child permission dưới `danhmucadmin`, ưu tiên `multiTenancySides: MultiTenancySides.Host` nếu pattern danh mục quốc tịch/host-level đang dùng.
  - `aspnet-core/src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml`: thêm label `LyDoDieuChinhThayThe`, `TaoMoiLyDoDieuChinhThayThe`, `ChinhSuaLyDoDieuChinhThayThe`, `XoaLyDoDieuChinhThayThe`, `NhapDanhSachLyDoDieuChinhThayThe`.
  - `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/DMNhaCungCap/DM_NCC_LyDoDieuChinhThayTheAppService.cs`: annotate `[AbpAuthorize]` và method-level permission.
- **Frontend:**
  - `angular/src/app/shared/layout/nav/app-navigation.service.ts`: thêm `new AppMenuItem('LyDoDieuChinhThayThe', 'Admin.DanhMuc.LyDoDieuChinhThayThe', 'la la-list', '/app/hddt/danhmuc/dmnhacungcap-lydodctt')` trong nhóm `DanhMuc` gần `QuocTich`.
  - `angular/src/app/hddt/hddt-routing.module.ts`: thêm route `danhmuc/dmnhacungcap-lydodctt` tới component list.
  - `angular/src/app/hddt/hddt.module.ts`: declare list component, edit modal, import modal.
  - `angular/src/shared/service-proxies/service-proxy.module.ts`: đăng ký provider `DM_NCC_LyDoDieuChinhThayTheServiceProxy` sau khi regenerate proxy.
- **Data:** None beyond table in §7.
- **Docs to update:** `docs/specs/system.md`/future danh mục-config domain, `docs/databases/README.md` hoặc SQL table file after DBA review.

### 5.2 AC2 — Danh sách, tìm kiếm, phân trang và sắp xếp

- **Approach:** List screen theo PrimeNG/ABP pattern `quoctich`: hiển thị STT, mã, tên lý do, ngày bắt đầu, ngày kết thúc, hiệu lực, thao tác. Keyword search áp dụng cho mã và mô tả/tên lý do. Sorting và paging dùng `PagedListingComponentBase`/`primengTableHelper` hiện hữu; export dùng cùng `Filter` và `Sorting` với list.
- **API:** `GetAll(string Filter, string Sorting, int SkipCount, int MaxResultCount)`:
  - Query `_repository.GetAll()`; nếu `Filter` có giá trị thì `WhereIf` trên `LyDo_Ma.Contains(Filter)` hoặc `LyDo_Ten.Contains(Filter)`.
  - Sort default theo tên lý do tăng dần, ví dụ `lyDo_Ten asc`; `PageBy(input)`.
  - Return `PagedResultDto<DMNCCLyDoDieuChinhThayTheDto>`.
  - Error case: log method/filter/sorting/skip/max đã truncate, không log dữ liệu nhạy cảm.
- **Backend:**
  - DTO input mới `GetAllDSLyDoDieuChinhThayTheInput.cs` kế thừa `PagedAndSortedResultRequestDto`, có `Filter`.
  - DTO list `DMNCCLyDoDieuChinhThayTheDto` chứa `Id`, `LyDo_Ma`, `LyDo_Ten`, `LyDo_GhiChu`, `LyDo_BatDau`, `LyDo_KetThuc`, `LyDo_HieuLuc` + audit fields cần thiết theo pattern.
  - `CustomDtoMapper.cs` map entity ↔ DTO.
- **Frontend:**
  - Folder dự kiến `angular/src/app/hddt/danhmuc/dmnhacungcap/lydodctt/` gồm list component/template và modal.
  - Template dùng `.primeng-datatable-container`, `<p-table>`/datatable pattern hiện hữu, search input + nút tìm kiếm đặt gần nhau theo `conventions/fe-cloud.md`.
  - Action column ẩn/hiện theo `isGranted('Admin.DanhMuc.LyDoDieuChinhThayThe.Edit/Delete')`.
- **Data:** Select from `vs_dm_ncc_lydo_dieuchinhthaythe`, mặc định không hiển thị bản ghi soft-delete (`IsDeleted = 0` do ABP repository filter).
- **Docs to update:** specs danh mục cấu hình.

### 5.3 AC3 — Thêm mới lý do điều chỉnh/thay thế

- **Approach:** `CreateOrEdit` khi `Id` null/0 thì gọi private `Create`. Normalize mã giống quốc tịch: trim, bỏ khoảng trắng, ConvertToUnSign, uppercase; trim tên lý do/ghi chú; ngày bắt đầu lấy đầu ngày local; ngày kết thúc lấy cuối ngày local; hiệu lực mặc định `1`.
- **API:** `CreateOrEdit(DMNCCLyDoDieuChinhThayTheDto input)` → `FileDataDto`:
  - `Status = 1` nếu thành công.
  - `Status = 2`, `Message` tiếng Việt nếu validate fail.
  - Throw `AbpAuthorizationException` nếu thiếu quyền create.
- **Backend:**
  - Entity `DM_NCC_LyDoDieuChinhThayThe` kế thừa `FullAuditedEntity`, `[Table("vs_dm_ncc_lydo_dieuchinhthaythe")]`, `[MultiTenancySide(MultiTenancySides.Host)]` theo pattern quốc tịch.
  - `HDDTDbContext.cs`: thêm `DbSet<DM_NCC_LyDoDieuChinhThayThe> DSLyDoDieuChinhThayThe` cạnh `DSQuocTich`/`DSNganHang`.
  - Validate: mã required <= 200, tên lý do required <= 1500, ghi chú <= 2000, mã unique trong bản ghi chưa xóa, ngày bắt đầu <= ngày kết thúc.
  - Sau insert gọi `ClearCache()`.
- **Frontend:**
  - Edit modal giống `thongtin-dmnccquoctich-modal.component.ts`: `show(0)` tạo DTO mới, `hieuluc = true`; `save()` set hiệu lực rồi gọi proxy `createOrEdit`.
  - Field mã enable khi create, disable/read-only khi edit.
  - Validate client-side mức cơ bản bằng required/maxlength; backend là nguồn validate cuối.
- **Data:** Insert row mới vào `vs_dm_ncc_lydo_dieuchinhthaythe`; audit/soft-delete columns do ABP/entity fill.
- **Docs to update:** DB SQL table + deploy note.

### 5.4 AC4 — Chỉnh sửa lý do điều chỉnh/thay thế

- **Approach:** Edit chỉ update tên lý do, ghi chú, ngày bắt đầu, ngày kết thúc, hiệu lực; không update mã. Validate dùng chung `ValidateData` nhưng duplicate check bỏ qua `Id` hiện tại.
- **API:** `GetLyDoDieuChinhThayTheForEdit(EntityDto<int>)` lấy DTO; `CreateOrEdit` branch update khi `Id > 0`.
- **Backend:**
  - Private `Update(DMNCCLyDoDieuChinhThayTheDto input)` load entity bằng repository, trả lỗi nếu không tìm thấy.
  - `NormalizeEdit` giữ nguyên `LyDo_Ma`, update các field allowed và audit modification.
  - Sau update gọi `ClearCache()`.
- **Frontend:** Modal edit nhận `id`, gọi `getLyDoDieuChinhThayTheForEdit`, disable mã.
- **Data:** Update bản ghi hiện hữu chưa soft-delete.
- **Docs to update:** specs danh mục cấu hình.

### 5.5 AC5 — Xóa lý do điều chỉnh/thay thế

- **Approach:** Delete theo pattern ABP repository `DeleteAsync(input.Id)` để soft-delete với `FullAuditedEntity`; UI confirm trước khi gọi; list refresh sau success.
- **API:** `Delete(EntityDto<int> input)` permission `Admin.DanhMuc.LyDoDieuChinhThayThe.Delete`; sau delete clear cache.
- **Backend:** Log chỉ `Id`, không log payload khác.
- **Frontend:** Action delete button chỉ hiển thị khi có quyền; dùng confirm/notify pattern hiện hữu.
- **Data:** `IsDeleted = 1`, `DeletionTime`/`DeleterUserId` được set; row không còn trong list mặc định.
- **Docs to update:** None beyond specs/DB behavior.

### 5.6 AC6 — Seed dữ liệu mẫu

- **Approach:** Seed tham chiếu lấy từ ảnh/tài liệu feature (`features/CBCLOUDV2-9038/image.png` / đường dẫn BA nêu trong `expect.md`) và đưa vào `deploy.md` dưới dạng SQL `INSERT ... SELECT ... WHERE NOT EXISTS` hoặc script seed tương đương do DBA/TechLead review. Không hardcode seed vào AppService. Không tự invent row ngoài nguồn ảnh.
- **API:** None.
- **Backend:** None cho runtime code; chỉ cần table hỗ trợ import/seed.
- **Frontend:** Import Excel có thể dùng để nạp seed nếu TechLead chọn thay vì SQL seed.
- **Data:** Seed chống trùng theo mã normalized, chỉ insert khi chưa có bản ghi chưa xóa cùng mã. Cần ghi rõ rollback seed: soft-delete theo danh sách mã seed hoặc drop bảng nếu rollback toàn feature.
- **Docs to update:** `deploy.md` khi Rule 02 phải có seed script/rollback thật; nếu ảnh không đủ rõ, DEV/BA phải xác nhận row trước khi chạy deploy.

### 5.7 AC7 — Export Excel

- **Approach:** Reuse `DMNhaCungCap_THNTExcelHelper` pattern quốc tịch, thêm method export riêng để tránh copy header quốc tịch. Export dùng filter/sorting hiện tại, không export audit/user/config/secrets.
- **API:** `TaiFileDSLyDoDieuChinhThayThe(string Filter, string Sorting)` → `TaiFile`:
  - Nếu không có dữ liệu: `message = "Không có dữ liệu"`.
  - Nếu có: `status = 1`, `filedto` từ helper export.
- **Backend:**
  - `aspnet-core/src/hddt/HDDT.Application/Commons/DanhMuc/DMNhaCungCap/DMNhaCungCap_THNTExcelHelper.cs`: thêm `ExportToFileLyDoDieuChinhThayThe(List<DMNCCLyDoDieuChinhThayTheDto>)`.
  - Header/sheet name nghiệp vụ: `Danh mục lý do điều chỉnh/thay thế`.
  - Columns: STT, Mã, Tên lý do/Mô tả, Ngày bắt đầu, Ngày kết thúc, Hiệu lực.
- **Frontend:** Nút export gọi proxy với `filterText`/`primengTableHelper.getSorting(...)`; download qua helper hiện hữu.
- **Data:** Read-only, query không đưa audit/user identity vào DTO export.
- **Docs to update:** None beyond testcase/report.

### 5.8 AC8 — Import Excel và an toàn thông tin

- **Approach:** Thêm template `.xlsx` và import parser/validator riêng cho danh mục lý do điều chỉnh/thay thế. Validate header trước data; validate required/length/duplicate in file/duplicate DB/date range/date format. Không log raw Excel/base64/file content.
- **API:**
  - `TaiFileMau()` → `FileDto` template.
  - `NhapFileExcel(FileDataDto file)` → `FileDataDto` result; `Status = 1` success, `Status = 2` + message/file lỗi theo pattern nếu data invalid.
- **Backend:**
  - Trong `DM_NCC_LyDoDieuChinhThayTheAppService.NhapFileExcel`, chỉ log `FileName` đã truncate, `HasFileData`, số dòng/summary lỗi nếu helper trả được; không log `file.FileData`, base64 hoặc raw cell content ngoài thông báo validate cần thiết.
  - Helper import decode file, validate header template, normalize mã như create, gom duplicate trong file, check duplicate DB trên bản ghi chưa xóa, validate date range/date format; chỉ insert khi toàn file hợp lệ hoặc theo pattern hiện hữu nếu pattern trả file lỗi trước khi insert.
  - Sau import success gọi `ClearCache()`.
- **Frontend:** Import modal theo pattern quốc tịch, chỉ chấp nhận `.xlsx`, hiển thị lỗi/file lỗi theo response.
- **Data:** Bulk insert valid rows; no partial invalid data unless existing pattern explicitly supports partial import with row-level error file — nếu pattern hiện hữu partial, plan yêu cầu không tạo dòng invalid.
- **Docs to update:** Security notes in report/deploy; no secrets.

### 5.9 AC9 — Redis cache

- **Approach:** Cache danh sách không phân trang bằng ABP `ICacheManager` giống `DM_NCC_QuocTichAppService`. Cache name/key riêng cho catalog này; clear toàn cache name sau create/update/delete/import.
- **API:** `GetAllNoPage()` → `ListResultDto<DMNCCLyDoDieuChinhThayTheDto>`; permission xem.
- **Backend:**
  - Constants: `CacheName = "DM_NCC_LyDoDieuChinhThayThe"`, `CacheKeyAll = "All"`.
  - `GetAllNoPage` đọc `cache.GetOrDefault<string, List<...>>(CacheKeyAll)`, miss thì query repository order by tên lý do rồi `SetAsync`.
  - `ClearCache()` gọi `_cacheManager.GetCache(CacheName).ClearAsync()`.
  - Không thêm config key mới; chỉ dùng `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId` hiện có theo convention, không ghi giá trị.
- **Frontend:** Nếu cần dropdown/internal consumer tương lai sẽ gọi `GetAllNoPage`; màn list chính vẫn dùng `GetAll` để filter/paging.
- **Data:** Cache chứa DTO danh mục host-level đã được filter soft-delete.
- **Docs to update:** `deploy.md` ghi cache name/key và cách clear khi rollback.

## 6. Implementation order

1. **Pre-check Rule 02:** xác nhận Gate 1 đã được human duyệt, repo `D:\BILL\invoicemanagement` ở đúng branch feature từ `origin/develop_cloud`, working tree sạch; không tự tạo/switch branch nếu chưa được yêu cầu.
2. **DB/deploy draft trước code BE runtime:** viết `deploy.md` với script tạo bảng/seed/rollback để DBA review; không chạy EF migration.
3. **Backend foundation:** entity, DbSet, DTO/input, AutoMapper, permissions/localization.
4. **Backend AppService + Excel + cache:** CRUD/search/export/import/template/GetAllNoPage/invalidation/logging an toàn.
5. **Regenerate NSwag proxy:** chạy host và `angular/nswag/refresh.bat`; không sửa tay generated proxy logic.
6. **Frontend:** component/modal/import modal/route/module/menu/provider.
7. **Verification/report/impact finalize:** build BE, type-check FE, manual CRUD/search/export/import/cache; cập nhật `report.md`, finalize `impact.md`, hoàn thiện `deploy.md`.

## 7. Database changes

- **Có đổi schema:** tạo bảng mới `vs_dm_ncc_lydo_dieuchinhthaythe` cho danh mục NCC/admin Cloud. **Không dùng EF migration**.
- **SQL/deploy file:** `features/CBCLOUDV2-9038/deploy.md` trong Rule 02, gồm create table, seed, rollback.
- **Đề xuất schema để DBA/TechLead review:**
  - `Id INT NOT NULL AUTO_INCREMENT` primary key.
  - `LyDo_Ma VARCHAR(200) NOT NULL` — mã normalized; AC gọi `Mã`.
  - `LyDo_Ten VARCHAR(1500) NOT NULL` — tên lý do/mô tả; AC gọi `Tên lý do`/`mô tả`.
  - `LyDo_GhiChu VARCHAR(2000) NULL` — ghi chú.
  - `LyDo_BatDau DATETIME(6) NULL`.
  - `LyDo_KetThuc DATETIME(6) NULL`.
  - `LyDo_HieuLuc INT NULL` — default logic app là `1`; DBA có thể đặt DB default `1` nếu thống nhất.
  - Audit/soft-delete ABP: `CreationTime DATETIME(6) NOT NULL`, `CreatorUserId BIGINT NULL`, `LastModificationTime DATETIME(6) NULL`, `LastModifierUserId BIGINT NULL`, `IsDeleted TINYINT(1) NOT NULL DEFAULT 0`, `DeleterUserId BIGINT NULL`, `DeletionTime DATETIME(6) NULL`.
  - Unique active code: ưu tiên generated virtual column `LyDo_Ma_Active` = `CASE WHEN IsDeleted = 0 THEN LyDo_Ma ELSE NULL END`, unique key trên cột này, giống deploy note của quốc tịch; fallback là unique (`LyDo_Ma`, `IsDeleted`) nếu MariaDB không hỗ trợ generated column.
  - Index: `IX_vs_dm_ncc_lydo_dctt_isdeleted` trên `IsDeleted`, `IX_vs_dm_ncc_lydo_dctt_ten` trên prefix `LyDo_Ten(255)`.
- **Effect on existing data:** Không thay đổi bảng hiện hữu; bảng mới rỗng trước seed/import.
- **Seed:** lấy rows từ nguồn tham chiếu trong `expect.md`/`image.png`, chống insert trùng mã; rollback seed bằng soft-delete danh sách mã seed hoặc drop table khi rollback toàn feature.
- **Rollback:** revert BE/FE; DBA drop table nếu rollback toàn bộ hoặc soft-delete seed/import rows theo danh sách mã đã seed.

## 8. Configuration changes

- **Config keys mới:** None.
- **Redis config:** dùng key hiện có `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId` (chỉ tên key; không ghi giá trị).
- **Permissions mới:**
  - `Admin.DanhMuc.LyDoDieuChinhThayThe`
  - `Admin.DanhMuc.LyDoDieuChinhThayThe.Create`
  - `Admin.DanhMuc.LyDoDieuChinhThayThe.Edit`
  - `Admin.DanhMuc.LyDoDieuChinhThayThe.Delete`
  - `Admin.DanhMuc.LyDoDieuChinhThayThe.Import`
- **Queue/job/env:** None.

## 9. External and inter-service integrations

| Surface | Compatibility verdict |
|---|---|
| REST/dynamic ABP API | Backward compatible: chỉ thêm AppService endpoint mới, không đổi endpoint hiện hữu. FE admin cần regenerate proxy để dùng endpoint mới. |
| Message queues/RabbitMQ/Kafka | None — out of scope. |
| XML/PDF/tax templates/HSM/tax authority | None — out of scope. |
| Public lookup/searchBill/customer portal | None — out of scope. |
| Redis | Dùng cache name mới, không dùng chung key với quốc tịch hoặc danh mục khác. |

## 10. Backward compatibility

Backward compatible với các luồng hiện hữu vì chỉ thêm bảng/API/menu mới. Rủi ro chính là generated NSwag proxy có diff lớn nhưng hợp đồng cũ không đổi; mitigation là regenerate từ Swagger đúng BE và chỉ dùng provider mới. Không thay đổi queue/message/XML/PDF/invoice issuance/public lookup.

## 11. Verification plan

| # | Lệnh / bước kiểm | Kết quả kỳ vọng |
|---|---|---|
| 1 | `git -C "D:\BILL\invoicemanagement" status -sb` | Đúng branch feature được duyệt từ `origin/develop_cloud`, working tree sạch trước Rule 02/code. |
| 2 | `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` | Build succeeded, 0 error. |
| 3 | Chạy BE admin Cloud local để mở Swagger | Host lên được; Swagger có `DM_NCC_LyDoDieuChinhThayThe` AppService. |
| 4 | `cd "D:\BILL\invoicemanagement\angular\nswag" && refresh.bat` | `service-proxies.ts` regenerate có `DM_NCC_LyDoDieuChinhThayTheServiceProxy`; không sửa tay logic generated. |
| 5 | `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` | TypeScript check 0 error. |
| 6 | **[manual]** User có `Admin.DanhMuc.LyDoDieuChinhThayThe` mở `/app/hddt/danhmuc/dmnhacungcap-lydodctt`; user không có quyền không thấy menu/nút | Đúng phân quyền màn hình/nút/API. |
| 7 | **[manual]** Tìm kiếm theo mã/tên lý do, sort/paging | List lọc/sort/paging đúng, STT đúng trang. |
| 8 | **[manual]** Thêm bản ghi hợp lệ; thử thiếu mã/tên, dài quá max, trùng mã, ngày bắt đầu > ngày kết thúc | Hợp lệ lưu được; invalid trả message rõ; cache được clear. |
| 9 | **[manual]** Sửa tên/ghi chú/date/hiệu lực; kiểm mã read-only/không đổi | Update đúng field allowed; mã không đổi; cache clear. |
| 10 | **[manual]** Xóa bản ghi vừa tạo | Soft-delete; không còn trong list mặc định; cache clear. |
| 11 | **[manual]** Export theo filter/sorting hiện tại | Excel đúng sheet/header nghiệp vụ, chỉ có STT/mã/mô tả/ngày/hiệu lực, không có secret/audit/user identity. |
| 12 | **[manual]** Tải template, import `.xlsx` hợp lệ và import file sai header/duplicate/invalid date/length | Import hợp lệ tạo dữ liệu; invalid trả lỗi/file lỗi theo pattern, không tạo dữ liệu invalid, không log raw base64/cell content. |
| 13 | **[manual/Redis]** Gọi `GetAllNoPage`, sau đó create/edit/delete/import rồi gọi lại | Cache `DM_NCC_LyDoDieuChinhThayThe/All` trả dữ liệu mới không cần restart. |

Không báo pass nếu chưa chạy thật; lệnh không chạy được phải ghi `N/A` kèm lý do verifiable trong `report.md`.

## 12. Risks and rollback

| Risk | Severity | Mitigation / rollback |
|---|---:|---|
| Workspace path lệch registry (`./invoice-management` vs local `D:\BILL\invoicemanagement`) | Trung bình | Plan dùng service-key canonical `invoice-management`; Rule 02 xác nhận repo thực tế trước code; không sửa nhầm FUTA/Liên Sơn. |
| Tạo bảng mới sai schema/unique active | Cao | SQL trong `deploy.md` phải DBA/TechLead review; không EF migration; rollback drop/soft-delete seed. |
| Seed từ ảnh bị nhập sai | Cao | Không invent row; DEV transcribe từ nguồn feature và BA/TechLead review seed trước deploy; rollback seed theo mã. |
| Permission/menu sai làm lộ chức năng admin | Cao | Quyền riêng, kiểm menu + API authorization manual. Rollback revert permission/menu/AppService. |
| Import log lộ raw Excel/base64 hoặc dữ liệu không liên quan | Cao | Logging chỉ file name truncate/số dòng/message validate; code review helper import. Rollback/hotfix logging. |
| Cache stale sau thay đổi dữ liệu | Trung bình | Centralize `ClearCache()` sau create/update/delete/import; manual Redis test; rollback clear cache thủ công + revert code. |
| NSwag generated proxy gây diff/conflict | Trung bình | Regenerate một lần sau BE ổn; không sửa tay generated proxy; rollback regenerate lại từ Swagger cũ hoặc revert file. |

## 13. Alternatives considered

1. **Copy trực tiếp feature quốc tịch và rename toàn bộ:** rejected — dễ copy header/export/cache key/permission sai; Cloud/LS và từng danh mục đã diverge, phải port thủ công theo pattern hiện tại.
2. **Không cache danh mục mới:** rejected — AC9 yêu cầu Redis cache và invalidation.
3. **Seed hardcode trong AppService:** rejected — seed/deploy thuộc DB/deploy review, tránh runtime code chứa dữ liệu seed và dễ rollback.
4. **Dùng EF migration cho bảng `vs_*`:** rejected — project rule cấm EF migration cho business schema.

## 14. Assumptions

- Service-key canonical là `invoice-management`; tên `invoicemanagement` trong `expect.md` là tên repo/local checkout thực tế, không phải service-key docs.
- Dữ liệu danh mục scope host-level giống `DM_NCC_QuocTich` (`[MultiTenancySide(MultiTenancySides.Host)]`) vì AC nói cùng scope danh mục quốc tịch.
- Prefix entity/DTO dùng `DM_NCC_LyDoDieuChinhThayThe`; route ngắn dùng `dmnhacungcap-lydodctt` để tránh path quá dài nhưng label/menu hiển thị đầy đủ tiếng Việt.
- Cache name/key đúng nghiệp vụ là `DM_NCC_LyDoDieuChinhThayThe` / `All`; câu AC9 ghi “nhóm ngành nghề” được hiểu là copy-paste từ ticket khác và không dùng tên đó.
- Seed rows lấy từ `features/CBCLOUDV2-9038/image.png`/nguồn BA nêu; Rule 02 không được invent dữ liệu nếu ảnh/nguồn không rõ.

## 15. Open questions

None for Gate 1 planning. Các giả định ở §14 cần DEV/TechLead review trước approve; nếu reviewer không đồng ý giả định nào thì sửa plan trước Rule 02.

## 16. Proposed docs updates (Gate 2)

- `docs/specs/system.md`: bổ sung danh mục admin Cloud “Lý do điều chỉnh/thay thế” trong nhóm danh mục/cấu hình, nêu CRUD/search/import/export/cache và không ảnh hưởng phát hành hóa đơn.
- `docs/architecture.md`: nếu cần, bổ sung note admin Cloud có danh mục mới dùng ABP dynamic API + Redis cache riêng.
- `docs/databases/databasetenant.vs_dm_ncc_lydo_dieuchinhthaythe.sql` hoặc vị trí SQL theo convention docs DB: thêm schema sau DBA/TechLead review.
- `docs/databases/README.md`: thêm entry table nếu docs DB index được mở rộng.
- `docs/design.md`: không cần token/style mới; nếu cập nhật thì chỉ ghi màn dùng Metronic/PrimeNG pattern hiện hữu.

## 17. Deviations found during implementation

None yet. Filled by Rule 02 while implementing.

## 18. Approval (Gate 1)

- [x] DEV tự review: hungtq — ngày 2026-09-23 — link commit/PR [CBCLOUDV2-9038](https://jira.cybertech.vn/browse/CBCLOUDV2-9038)
- [x] TechLead approve: tienvv — ngày 2026-09-23 — link commit/PR [CBCLOUDV2-9038](https://jira.cybertech.vn/browse/CBCLOUDV2-9038)

> Khi block này đủ chữ ký và plan-status được human cập nhật `approved`, mới chạy Rule 02/code.
