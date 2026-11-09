# CBCLOUDV2-8963 Test Cases

## Scope

Validate **[Cloud][ND254][Admin] Danh mục quốc tịch** for admin Cloud service `invoicemanagement`:

- Backend AppService `DM_NCC_QuocTichAppService`.
- Frontend route `/app/hddt/danhmuc/dmnhacungcap-quoctich`.
- Table `vs_dm_ncc_quoctich` created by manual MariaDB deploy script, not EF migration.
- Redis/ABP cache for non-paged nationality list.
- Excel export/import/template behavior.
- Permission matrix for `Admin.DanhMuc.QuocTich.*`.

## Test Environment / Prerequisites

- Code branch: `hungtq_dev_cloud` from `origin/develop_cloud`.
- DB table `vs_dm_ncc_quoctich` exists in the Cloud admin database.
- Redis/cache configuration uses existing ABP settings; no new secret is required.
- Test role/user can be assigned these permissions independently:
  - `Admin.DanhMuc.QuocTich`
  - `Admin.DanhMuc.QuocTich.Create`
  - `Admin.DanhMuc.QuocTich.Edit`
  - `Admin.DanhMuc.QuocTich.Delete`
  - `Admin.DanhMuc.QuocTich.Import`
- Backend and Angular frontend are running against the same test environment.
- Unless a case says otherwise, use a user that has all above permissions.

## Test Data Baseline

Use sample nationality records from `expect.md`:

| Mã | Tên |
|---|---|
| AD | Andorran |
| AE | Utd.Arab Emir. |
| AF | Afghanistan |
| AG | Antigua/Barbuda |

For duplicate/normalization tests, use disposable codes such as `TC8963AD`, `TC8963AE`, then delete/soft-delete them after validation.

## Test Cases

## TC01 - Menu and route are visible with read permission

- Type: Positive / UI / permission
- Preconditions:
  - Test user has `Admin.DanhMuc.QuocTich`.
- Steps:
  1. Login admin Cloud.
  2. Open menu `Danh mục`.
  3. Click `Quốc tịch`.
- Expected result:
  - Menu item `Quốc tịch` is visible.
  - Browser navigates to `/app/hddt/danhmuc/dmnhacungcap-quoctich`.
  - Nationality list screen loads without authorization error.
- Status: not run manually.

## TC02 - Menu and read APIs are blocked without read permission

- Type: Negative / UI / API / permission
- Preconditions:
  - Test user does not have `Admin.DanhMuc.QuocTich`.
- Steps:
  1. Login admin Cloud.
  2. Check `Danh mục` menu.
  3. Attempt to open `/app/hddt/danhmuc/dmnhacungcap-quoctich` directly.
  4. Attempt API calls for `GetAll`, `GetAllNoPage`, `GetQuocTichForEdit`, `TaiFileDSQuocTich`.
- Expected result:
  - Menu item is hidden or not accessible.
  - Direct route/API read operations are denied by authorization.
  - No nationality data is returned to unauthorized user.
- Status: not run manually.

## TC03 - List nationalities with paging and default sort

- Type: Positive / UI / API
- Preconditions:
  - At least records `AD`, `AE`, `AF` exist and are not soft-deleted.
- Steps:
  1. Open nationality list screen.
  2. Load the first page without search filter.
  3. Change page size or navigate paginator if enough records exist.
- Expected result:
  - List loads successfully.
  - Records are sorted by nationality name by default.
  - Total count and paginator are consistent with visible rows.
  - Soft-deleted rows are not shown.
- Status: not run manually.

## TC04 - Search by nationality code

- Type: Positive / search
- Preconditions:
  - Record `AD - Andorran` exists and is not soft-deleted.
- Steps:
  1. Open nationality list screen.
  2. Enter `AD` in the search box.
  3. Click search.
- Expected result:
  - Result contains matching code `AD`.
  - Non-matching records are filtered out.
  - Paging resets or remains valid for filtered result.
- Status: not run manually.

## TC05 - Search by nationality name

- Type: Positive / search
- Preconditions:
  - Record `AF - Afghanistan` exists and is not soft-deleted.
- Steps:
  1. Open nationality list screen.
  2. Enter `Afghanistan` or partial text such as `Afghan`.
  3. Click search.
- Expected result:
  - Result contains `AF - Afghanistan`.
  - Search matches nationality name.
- Status: not run manually.

## TC06 - Create nationality with valid required data

- Type: Positive / CRUD
- Input:
  - `QuocTich_Ma = "TC8963AD"`
  - `QuocTich_Ten = "Test Nationality 8963 AD"`
  - `QuocTich_HieuLuc = 1`
- Steps:
  1. Open create modal.
  2. Fill valid code/name/effective status.
  3. Save.
  4. Search by `TC8963AD`.
- Expected result:
  - Save succeeds.
  - Created record appears in list/search.
  - Record is stored with audit fields and is not soft-deleted.
- Status: not run manually.

## TC07 - Create normalizes nationality code

- Type: Positive / validation / normalization
- Input:
  - `QuocTich_Ma = " tc 8963 ae "` or another code with spaces/lowercase.
  - `QuocTich_Ten = "Test Nationality 8963 AE"`
- Steps:
  1. Create a new nationality with lowercase/spaced code.
  2. Save.
  3. Search by normalized code.
- Expected result:
  - Save succeeds if normalized code does not duplicate an active record.
  - Stored code is trimmed, spaces removed, converted to uppercase.
  - Search by normalized code returns the created record.
- Status: not run manually.

## TC08 - Create blocks missing code

- Type: Negative / validation
- Input:
  - `QuocTich_Ma = null`, empty, or whitespace.
  - `QuocTich_Ten = "Test Missing Code"`
- Steps:
  1. Open create modal.
  2. Leave code empty.
  3. Save.
- Expected result:
  - Save is blocked.
  - Error message indicates `Mã quốc tịch không được để trống`.
  - No new record is inserted.
- Status: not run manually.

## TC09 - Create blocks missing name

- Type: Negative / validation
- Input:
  - `QuocTich_Ma = "TC8963NONAME"`
  - `QuocTich_Ten = null`, empty, or whitespace.
- Steps:
  1. Open create modal.
  2. Fill code but leave name empty.
  3. Save.
- Expected result:
  - Save is blocked.
  - Error message indicates `Tên quốc tịch không được để trống`.
  - No new record is inserted.
- Status: not run manually.

## TC10 - Create blocks duplicate active code

- Type: Negative / validation
- Preconditions:
  - Active/non-deleted record `TC8963AD` exists.
- Input:
  - `QuocTich_Ma = "TC8963AD"`
  - `QuocTich_Ten = "Duplicate Test"`
- Steps:
  1. Attempt to create another nationality with the same code.
  2. Save.
- Expected result:
  - Save is blocked.
  - Error message indicates `Mã quốc tịch đã tồn tại`.
  - Existing record remains unchanged.
- Status: not run manually.

## TC11 - Create blocks start date after end date

- Type: Negative / validation
- Input:
  - `QuocTich_Ma = "TC8963DATE"`
  - `QuocTich_Ten = "Date Validation Test"`
  - `QuocTich_BatDau = 2026-08-27`
  - `QuocTich_KetThuc = 2026-08-26`
- Steps:
  1. Open create modal.
  2. Fill date range where start date is greater than end date.
  3. Save.
- Expected result:
  - Save is blocked.
  - Error message indicates `Ngày bắt đầu không được lớn hơn ngày kết thúc`.
  - No new record is inserted.
- Status: not run manually.

## TC12 - Edit nationality updates allowed fields but keeps code stable

- Type: Positive / CRUD / regression
- Preconditions:
  - Active record `TC8963AD` exists.
- Steps:
  1. Open edit modal for `TC8963AD`.
  2. Change name, start date, end date, and effective status.
  3. Save.
  4. Reopen edit modal or search the record again.
- Expected result:
  - Save succeeds.
  - Name/date/effective status are updated.
  - Nationality code remains unchanged.
  - No duplicate record is created.
- Status: not run manually.

## TC13 - Delete nationality performs soft-delete and hides from active list

- Type: Positive / CRUD / soft delete
- Preconditions:
  - Active disposable record `TC8963DEL` exists.
- Steps:
  1. Search `TC8963DEL`.
  2. Click delete and confirm.
  3. Search `TC8963DEL` again.
- Expected result:
  - Delete succeeds.
  - Record is soft-deleted.
  - Record no longer appears in active list/search/export.
- Status: not run manually.

## TC14 - Create permission controls create action

- Type: Negative / permission
- Preconditions:
  - Test user has `Admin.DanhMuc.QuocTich` but not `Admin.DanhMuc.QuocTich.Create`.
- Steps:
  1. Open nationality list screen.
  2. Check create button visibility.
  3. Attempt direct API call `CreateOrEdit` with `Id = null`.
- Expected result:
  - Create button is hidden or disabled.
  - Direct create API call is denied.
  - No new record is inserted.
- Status: not run manually.

## TC15 - Edit permission controls edit action

- Type: Negative / permission
- Preconditions:
  - Test user has `Admin.DanhMuc.QuocTich` but not `Admin.DanhMuc.QuocTich.Edit`.
- Steps:
  1. Open nationality list screen.
  2. Check edit action visibility for a row.
  3. Attempt direct API call `CreateOrEdit` with an existing `Id`.
- Expected result:
  - Edit action is hidden or disabled.
  - Direct edit API call is denied.
  - Existing record remains unchanged.
- Status: not run manually.

## TC16 - Delete permission controls delete action

- Type: Negative / permission
- Preconditions:
  - Test user has `Admin.DanhMuc.QuocTich` but not `Admin.DanhMuc.QuocTich.Delete`.
- Steps:
  1. Open nationality list screen.
  2. Check delete action visibility for a row.
  3. Attempt direct API call `Delete`.
- Expected result:
  - Delete action is hidden or disabled.
  - Direct delete API call is denied.
  - Record remains visible and not deleted.
- Status: not run manually.

## TC17 - Import permission controls import and template actions

- Type: Negative / permission
- Preconditions:
  - Test user has `Admin.DanhMuc.QuocTich` but not `Admin.DanhMuc.QuocTich.Import`.
- Steps:
  1. Open nationality list screen.
  2. Check import/template buttons.
  3. Attempt direct API calls `NhapFileExcel` and `TaiFileMau`.
- Expected result:
  - Import/template actions are hidden or disabled.
  - Direct import/template API calls are denied.
  - No records are inserted by import.
- Status: not run manually.

## TC18 - Export Excel uses current filter

- Type: Positive / Excel / export
- Preconditions:
  - Records `AD`, `AE`, `AF` exist and are not soft-deleted.
- Steps:
  1. Search with filter `AD`.
  2. Click export Excel.
  3. Open downloaded file.
- Expected result:
  - Export succeeds and returns a downloadable Excel file.
  - File contains nationality columns with correct values.
  - File data respects current filter; matching records are included and unrelated records are excluded.
- Status: not run manually.

## TC19 - Export Excel with no matching data returns no-data message

- Type: Edge / Excel / export
- Steps:
  1. Search using a value that has no matches, for example `NO_MATCH_8963`.
  2. Click export Excel.
- Expected result:
  - Export does not create a misleading data file.
  - User receives `Không có dữ liệu` or equivalent no-data message.
- Status: not run manually.

## TC20 - Download Excel template

- Type: Positive / Excel / template
- Preconditions:
  - Test user has `Admin.DanhMuc.QuocTich.Import`.
- Steps:
  1. Open import modal.
  2. Click download template.
  3. Open downloaded template file.
- Expected result:
  - Template download succeeds.
  - Template is for nationality catalog and has the expected nationality import headers.
  - Empty template does not contain business data.
- Status: not run manually.

## TC21 - Import valid Excel creates nationalities

- Type: Positive / Excel / import
- Preconditions:
  - Test user has `Admin.DanhMuc.QuocTich.Import`.
  - Import file uses the correct template/header.
- Input file rows:
  - `TC8963IM1 - Import Nationality 1`
  - `TC8963IM2 - Import Nationality 2`
- Steps:
  1. Download template.
  2. Fill valid rows.
  3. Import file.
  4. Search imported codes.
- Expected result:
  - Import succeeds.
  - New records are created with normalized codes.
  - Imported records appear in list/search without service restart.
- Status: not run manually.

## TC22 - Import invalid header is rejected

- Type: Negative / Excel / import
- Input:
  - Excel file with missing, renamed, or reordered required nationality headers.
- Steps:
  1. Import the invalid file.
- Expected result:
  - Import is rejected before writing data.
  - Error message clearly indicates invalid header/template.
  - No partial data is inserted.
- Status: not run manually.

## TC23 - Import invalid data is rejected with clear row-level error

- Type: Negative / Excel / import
- Input rows:
  - Missing code.
  - Missing name.
  - Duplicate code already active in DB.
  - Start date greater than end date.
- Steps:
  1. Import file containing invalid rows.
- Expected result:
  - Import returns validation error message(s) that identify invalid data clearly.
  - Duplicate/required/date validation is enforced.
  - Invalid rows are not inserted.
- Status: not run manually.

## TC24 - GetAllNoPage caches nationality list

- Type: Positive / cache / API
- Preconditions:
  - Cache is empty or has been cleared.
  - At least one active nationality exists.
- Steps:
  1. Call `GetAllNoPage` once.
  2. Call `GetAllNoPage` again without changing data.
  3. If Redis/cache inspection is available, inspect cache name/key.
- Expected result:
  - First call returns active nationality list and populates ABP cache.
  - Second call returns the same data without error.
  - Cache name/key are `DM_NCC_QuocTich` / `All`.
- Status: not run manually.

## TC25 - Cache is cleared after create

- Type: Positive / cache / CRUD
- Preconditions:
  - `GetAllNoPage` was called once to populate cache.
- Steps:
  1. Create `TC8963CACHE1`.
  2. Call `GetAllNoPage` again.
- Expected result:
  - New record appears in non-paged list immediately.
  - Service restart or manual Redis flush is not required.
- Status: not run manually.

## TC26 - Cache is cleared after edit

- Type: Positive / cache / CRUD
- Preconditions:
  - Active record `TC8963CACHE1` exists.
  - `GetAllNoPage` was called once to populate cache.
- Steps:
  1. Edit name/effective status of `TC8963CACHE1`.
  2. Call `GetAllNoPage` again.
- Expected result:
  - Updated values appear in non-paged list immediately.
  - Stale cached values are not returned.
- Status: not run manually.

## TC27 - Cache is cleared after delete

- Type: Positive / cache / CRUD
- Preconditions:
  - Active record `TC8963CACHEDEL` exists.
  - `GetAllNoPage` was called once to populate cache.
- Steps:
  1. Delete `TC8963CACHEDEL`.
  2. Call `GetAllNoPage` again.
- Expected result:
  - Deleted record is absent from non-paged list immediately.
  - Stale cached record is not returned.
- Status: not run manually.

## TC28 - Cache is cleared after import

- Type: Positive / cache / Excel / import
- Preconditions:
  - `GetAllNoPage` was called once to populate cache.
- Steps:
  1. Import valid Excel with code `TC8963CACHEIM`.
  2. Call `GetAllNoPage` again.
- Expected result:
  - Imported record appears in non-paged list immediately.
  - Service restart or manual Redis flush is not required.
- Status: not run manually.

## TC29 - Backend build passes

- Type: Build / regression
- Command:

```powershell
dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln"
```

- Expected result:
  - Build exits with code `0`.
  - `0 Error(s)`.
  - Existing warnings may remain, but no new blocking compile error is introduced.
- Observed result:
  - Build succeeded with `0 Error(s)` and existing warnings.
- Status: source/build verified.

## TC30 - Angular production build passes with compatible Node

- Type: Build / regression
- Notes:
  - System Node `v24.14.1` is not compatible with the legacy Angular dependency chain because `http_parser` is unavailable.
  - Node 10 requires increased heap for production build.
- Command:

```powershell
npx -p node@10 node --max_old_space_size=4096 node_modules/@angular/cli/bin/ng build --prod
```

- Expected result:
  - Build exits with code `0`.
  - Generated frontend compiles with `DM_NCC_QuocTichServiceProxy` and new components registered.
- Observed result:
  - Build completed successfully with exit code `0`.
- Status: source/build verified.

## TC31 - Git whitespace check passes

- Type: Static check / regression
- Command:

```powershell
git -C "D:\BILL\invoicemanagement" diff --check
```

- Expected result:
  - No trailing whitespace or whitespace error is reported in changed files.
- Observed result:
  - No output after cleanup.
- Status: source verified.

## Traceability Matrix

| Acceptance Criteria | Covered by |
|---|---|
| Route/menu riêng | TC01, TC02 |
| Read/create/edit/delete/import permission | TC01, TC02, TC14, TC15, TC16, TC17 |
| Tìm kiếm theo mã/tên | TC04, TC05 |
| Thêm mới validate/normalize/duplicate | TC06, TC07, TC08, TC09, TC10, TC11 |
| Sửa giữ mã ổn định | TC12 |
| Xóa soft-delete, không hiển thị active list | TC13, TC27 |
| Xuất Excel theo filter | TC18, TC19 |
| Tải file mẫu/import Excel/validate duplicate | TC20, TC21, TC22, TC23 |
| Cache Redis qua ABP `ICacheManager` | TC24 |
| Clear cache sau Create/Update/Delete/Import | TC25, TC26, TC27, TC28 |
| Không dùng EF migration; DB script deploy | Prerequisites + deploy verification |
| Build/test/manual thật, không fake pass | TC29, TC30, TC31 + manual statuses |

## Cleanup After Manual Test

- Soft-delete or remove disposable records whose codes start with `TC8963`.
- If Redis/cache was manually inspected or flushed, record the exact action in `report.md`.
- Do not mark manual cases as passed until they are run against an environment with the DB table and permissions configured.
