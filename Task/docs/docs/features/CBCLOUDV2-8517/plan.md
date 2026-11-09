# CBCLOUDV2-8517 Plan

## Goal

Fix date validation in `DSHoaDonNhapTrucTiepDaKy` so invalid date inputs return clear validation result `maketqua = "2"` and optional `denngay = null` remains valid.

## Context

- `api-cloud-service/` is the Cloud API service documented in `docs/AGENTS.md` and `docs/architecture.md`.
- The affected method is in `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.
- Existing logic parses `tungay` and `denngay` before querying invoices.
- Existing query uses nullable date filters with `.WhereIf(tungay.HasValue, ...)` and `.WhereIf(denngay.HasValue, ...)`.

## Assumptions

- `tungay` remains mandatory.
- `denngay` remains optional only when the JSON value is `null`.
- Empty string and whitespace are intentional client input errors and must return validation error, not runtime exception.
- Existing response contract `ResultDSHoaDonParam` must remain unchanged.

## Out Of Scope

- No DTO changes.
- No database changes.
- No frontend changes.
- No API route or authentication changes.
- No broader date validation refactor.

## Impact Assessment

- Backend API impact is low and limited to one method in `GuiHoaDonAppService.cs`.
- Query semantics are preserved for valid dates and for `denngay = null`.
- Runtime stability improves for `denngay = ""` because the API now returns validation result instead of throwing `FormatException`.
- No queue, config, database, migration, or deployment dependency is introduced.

## Implementation Steps

1. Keep existing `tungay` required validation.
2. Change `denngay` validation so only `null` skips validation.
3. Use `DateTime.TryParseExact` for every non-null `denngay`, causing empty string and whitespace to return format validation error.
4. Remove the unconditional `DateTime.ParseExact(input.denngay, ...)` call that could throw for `""`.
5. Keep guarded parse for `denngay` before query execution.
6. Preserve existing nullable query filter `.WhereIf(denngay.HasValue, ...)`.
7. Build `api-cloud-service/src/hddt/WS.Application/WS.Application.csproj`.

## Verification Steps

- Source check:
  - `denngay` validation uses `input.denngay != null` before `TryParseExact`.
  - `denngay` parse is guarded by `!string.IsNullOrEmpty(input.denngay)`.
  - No unconditional `DateTime.ParseExact(input.denngay, ...)` remains in `DSHoaDonNhapTrucTiepDaKy`.

- Build command:

```powershell
dotnet build src\hddt\WS.Application\WS.Application.csproj --no-restore
```

- Manual API checks:
  - `denngay = null` passes validation.
  - `denngay = ""` returns `maketqua = "2"` and `denngay phải là định dạng yyyy-MM-dd`.
  - `denngay = "   "` returns `maketqua = "2"` and `denngay phải là định dạng yyyy-MM-dd`.
  - `tungay = null` or `""` returns required validation message.
  - Valid date range still queries invoices.

## Risk Matrix

| Risk | Impact | Mitigation | Rollback / Follow-up |
| --- | --- | --- | --- |
| Clients previously sent `denngay = ""` expecting no end-date filter | Low | Requirement states only `null` is optional; empty string is invalid | Client can send `null` to skip end-date filter |
| Message concatenation has no separator when multiple validation errors occur | Low | Preserve existing message style to avoid response contract changes | Can be improved separately if BA requests |
| Manual API execution not run in this session | Low | Build and source checks completed; manual cases documented for QA | QA can verify with Postman/API test |

## Deployment Notes

No database, config, environment, queue, migration, or scheduled job changes are required. Deploy the normal `api-cloud-service/` application artifact containing the updated `WS.Application` assembly.
