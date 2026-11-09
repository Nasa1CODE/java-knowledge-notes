# CBCLOUDV2-8317 Report

## Summary

v1: Added a `Thông báo` column to the TCT registration list and a backend API to load the biometric/OTP guide link and cutover date from host configuration, gated purely by `status` (3/4/5) plus the cutover-date condition.

v2 (superseded): Replaced the `status`-only display condition with a `status`+`statusCode`+`errorCode` Notification Matrix, assuming `StatusCode`/`ErrorCode` on `DoanhNghiep_TongCucThueDto` (`vs_registertax`) carried the message-type/error codes. **This assumption was wrong** — those fields are never populated by the tax-authority response handlers.

v3 (this revision): Corrected the data source. The message-type code (`102`/`103`/`112`) and error/result code (e.g. `20013`) now come from the **latest `vs_transaction_log` row** for the registration (`TransFormCode`, `ResponseStatus`, joined via `RegisterTax_ID`). The Notification Matrix content itself (rows 1/3/5) is unchanged from v2.

## Files Changed (v3)

- `invoicecore/aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/CauHinh/ThongTinDoanhNghiep/DoanhNghiep_TongCucThueDto.cs` — added `TransFormCode` (string), `ResponseStatus` (int?).
- `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/CauHinh/DoanhNghiep_TongCucThueAppService.cs` — `GetData` now loads the latest matching `vs_transaction_log` row per page row.
- `frontend_angular/src/shared/service-proxies/service-proxies.ts` — manually patched `DoanhNghiep_TongCucThueDto`/`IDoanhNghiep_TongCucThueDto` with `transFormCode`/`responseStatus`.
- `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-tongcucthue-tab.component.ts` — `getThongBaoType(record)` now reads `record.transFormCode`/`record.responseStatus`.
- `docs/features/CBCLOUDV2-8317/expect.md`
- `docs/features/CBCLOUDV2-8317/plan.md`
- `docs/features/CBCLOUDV2-8317/tasks.md`
- `docs/features/CBCLOUDV2-8317/testcase.md`
- `docs/features/CBCLOUDV2-8317/report.md`

No `.html` template change was needed for v3 — the template already calls `getThongBaoType(record)` without depending on which backend fields feed it.

## Implementation Details (v3)

### Backend

- `DoanhNghiep_TongCucThueDto` gains two DTO-only fields (not persisted on `vs_registertax`, not part of the schema):
  ```csharp
  public string TransFormCode { get; set; }
  public int? ResponseStatus { get; set; }
  ```
- `DoanhNghiep_TongCucThueAppService.GetData`, after `PageBy`/`ToListAsync`/`ObjectMapper.Map`:
  - Collects `RegisterTax_ID`s (`Id`) of the **current page only** (`customers`, the already-paged EF result), not the full filtered query.
  - Queries `_transactionLogRepository.GetAll()` filtered to those IDs and `TransFormCode IN ("102", "103", "112")`.
  - Groups by `RegisterTax_ID`, selects the row with the greatest `CreationTime` per group (`OrderByDescending(CreationTime).FirstOrDefault()`).
  - Assigns `TransFormCode`/`ResponseStatus` from the matched log row onto each `DoanhNghiep_TongCucThueDto` in the result list.
  - Wrapped in an `if (registerIds.Any())` guard to skip the query entirely on an empty page.

### Frontend

- `service-proxies.ts`: added `transFormCode!: string | undefined;` and `responseStatus!: number | undefined;` to the `DoanhNghiep_TongCucThueDto` class (declaration, `init()` deserialization, `toJSON()` serialization), and matching entries on the `IDoanhNghiep_TongCucThueDto` interface. This mirrors the existing hand-generated-file pattern already used for `getLinkXacThucSinhTracHoc`/`getNgayApDungSinhTracHoc` in earlier revisions (NSwag regen not run).
- `getThongBaoType(record)` in `doanhnghiep-tongcucthue-tab.component.ts` now reads `record.transFormCode` and `record.responseStatus` (compared as a trimmed string) instead of the v2 `record.statusCode`/`record.errorCode`. The three matched rows (1/3/5), the empty-fallthrough for everything else, and the row-1-only `isXacThucSinhTracHocApplicable(record)` cutover-date gate are otherwise unchanged from v2.
- `isEmptyCode(code)`, `getThoiHanXacThuc(record)`, `isXacThucSinhTracHocApplicable(record)`, `loadLinkXacThucSinhTracHoc()`, `loadNgayApDungSinhTracHoc()` are all unchanged from v1/v2.

## Verification

### Source Check (v3)

```text
PASS: CBCLOUDV2-8317 v3 source checks passed
- DoanhNghiep_TongCucThueDto: TransFormCode (string), ResponseStatus (int?) added.
- GetData: vs_transaction_log lookup scoped to the current page's RegisterTax_ID set (after
  PageBy), filtered to TransFormCode IN ('102','103','112'), max CreationTime per RegisterTax_ID.
- service-proxies.ts: transFormCode/responseStatus added to class + interface, init()/toJSON()
  both updated.
- getThongBaoType(record): reads transFormCode/responseStatus; row 1/3/5 conditions and
  cutover-date gating (row 1 only) unchanged from v2.
```

Editor diagnostics (`get_diagnostics`) reported no errors on any of the 4 modified files (`DoanhNghiep_TongCucThueDto.cs`, `DoanhNghiep_TongCucThueAppService.cs`, `service-proxies.ts`, `doanhnghiep-tongcucthue-tab.component.ts`).

### Build

`npm run build` and `dotnet build` were **not run** for this revision, continuing the same explicit skip-build/test decision from v2. No compile/runtime verification evidence exists beyond the source-level check and editor diagnostics above. In particular, the following have **not** been verified end-to-end:
- That `_transactionLogRepository` (an existing injected dependency, already used elsewhere in the file) resolves correctly with the new LINQ query shape (grouping + `OrderByDescending`+`FirstOrDefault` inside a `Select`, then materialized to a list before building a dictionary) against the real EF Core provider.
- That the manually-patched `service-proxies.ts` fields compile and serialize/deserialize correctly against the real backend JSON response shape.

### CSS

No CSS/style changes were made in v3.

## Deployment

- No schema change, no new config keys, no new tables/columns. `vs_transaction_log.TransFormCode`/`ResponseStatus` already exist. Existing v1 deployment requirements (`LINK_XAC_THUC_SINH_TRAC_HOC`, `NGAY_APDUNG_SINH_TRAC_HOC` host config rows) still apply — see `deploy.md`.
- Rollout risk: any registration with no `vs_transaction_log` row having `TransFormCode` in `102/103/112` will show an empty `Thông báo` cell (correct per `expect.md` General Rule), including registrations that predate this feature or whose TCT response was never logged for any reason.

## Notes

- `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/tokhai-dangky-sdhddt.component.html` was already modified before this task and was not changed for `CBCLOUDV2-8317`.
- Because no build was run, this change has not been verified to compile/run in a real environment. Recommend running `dotnet build` and `npm run build` (or `ng serve`) before merging/deploying to confirm no compile errors and no template binding errors.
