# CBCLOUDV2-8517 Tasks

## Task 1 - Fix `denngay` validation and parse guard

- Status: completed
- Area/service: `api-cloud-service/`
- Description: Update `DSHoaDonNhapTrucTiepDaKy` so `denngay = null` remains optional, while `denngay = ""`, whitespace, or invalid date format returns validation result `maketqua = "2"` instead of reaching `DateTime.ParseExact` and throwing `FormatException`.
- Acceptance criteria:
  - [x] `denngay = null` skips validation and end-date filter.
  - [x] `denngay = ""` returns `denngay phải là định dạng yyyy-MM-dd`.
  - [x] `denngay = "   "` returns `denngay phải là định dạng yyyy-MM-dd`.
  - [x] Unconditional `DateTime.ParseExact(input.denngay, ...)` is removed.
  - [x] Existing query `.WhereIf(denngay.HasValue, ...)` remains unchanged.
- Verification:
  - [x] Source check in `GuiHoaDonAppService.cs` confirmed guarded validate and parse behavior.
  - [x] `dotnet build src\hddt\WS.Application\WS.Application.csproj --no-restore` completed with `0 Error(s)`.
- Dependencies: None
- Likely touched files:
  - `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`
- Estimated scope: XS

## Task 2 - Confirm unchanged `tungay` required behavior

- Status: completed
- Area/service: `api-cloud-service/`
- Description: Confirm the existing `tungay` validation still returns required validation for null or empty string, and format validation for whitespace or invalid dates.
- Acceptance criteria:
  - [x] `tungay = null` or `""` returns `tungay không được để trống`.
  - [x] `tungay = "   "` or invalid format returns `tungay phải là định dạng yyyy-MM-dd`.
  - [x] Valid `tungay` still reaches the existing query path.
- Verification:
  - [x] Source check confirmed `string.IsNullOrEmpty(input.tungay)` and `TryParseExact` branches remain in place.
- Dependencies: Task 1
- Likely touched files:
  - `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`
- Estimated scope: XS

## Task 3 - Update feature documentation

- Status: completed
- Area/service: `docs/`
- Description: Create the complete feature documentation set for `CBCLOUDV2-8517` so the implemented validation fix is traceable.
- Acceptance criteria:
  - [x] `expect.md` records expected date validation behavior.
  - [x] `plan.md` records implementation approach and verification.
  - [x] `tasks.md` records completed implementation tasks.
  - [x] `testcase.md` records positive, negative, regression, and edge scenarios.
  - [x] `impact.md` records affected and unaffected components.
  - [x] `report.md` records real implementation and build result.
  - [x] `deploy.md` records no special deployment changes.
- Verification:
  - [x] Feature folder contains all required markdown files.
- Dependencies: Task 1, Task 2
- Likely touched files:
  - `docs/features/CBCLOUDV2-8517/*.md`
- Estimated scope: S
