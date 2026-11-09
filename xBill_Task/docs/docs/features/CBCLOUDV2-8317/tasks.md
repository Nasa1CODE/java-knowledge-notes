# CBCLOUDV2-8317 Tasks

## Status

- Feature status: approved (with open Known Gaps — see `expect.md`)
- Gate 1 plan review (v1, status-only matrix): approved by user in chat — superseded
- Gate 1 plan review (v2, `statusCode`/`errorCode` on `vs_registertax`): approved by user in chat — superseded (wrong data source)
- Gate 1 plan review (v3, direct `RegisterTax_ID` filter on `vs_transaction_log`): approved by user in chat — superseded, actual code differs
- Gate 1 plan review (v4, `vs_service_tax` join, matches actual code): documented as-built; Known Gaps need BA/TechLead confirmation
- Gate 2 docs update review: not required

## Tasks — v1 (status-only matrix, implemented)

| Status | Area | Task |
| --- | --- | --- |
| completed | Requirement | Fill `expect.md` with notification behavior, deadline rule, and link source. |
| completed | Planning | Create/update `plan.md` from `expect.md`. |
| completed | Verification | Run red checks for missing API/proxy/UI notification code. |
| completed | invoicecore | Add `GetLinkXacThucSinhTracHoc` API in `DoanhNghiep_TongCucThueAppService`. |
| completed | frontend_angular proxy | Add `getLinkXacThucSinhTracHoc` to `service-proxies.ts`. |
| completed | frontend_angular | Add notification link loading, deadline formatting helpers, and notification logic. |
| completed | frontend_angular | Add `Thông báo` column to the registration table. |
| completed | Verification | Run source checks and build commands. |
| completed | Reporting | Update `testcase.md`, `report.md`, and `deploy.md` from actual evidence. |
| completed | Requirement | Update `expect.md` with cutover-date config gating rule (`NGAY_APDUNG_SINH_TRAC_HOC`). |
| completed | Planning | Update `plan.md` implementation/verification/rollback steps for the cutover-date condition. |
| completed | invoicecore | Add `GetNgayApDungSinhTracHoc` API in `DoanhNghiep_TongCucThueAppService`. |
| completed | frontend_angular proxy | Add `getNgayApDungSinhTracHoc` to `service-proxies.ts`. |
| completed | frontend_angular | Load cutover date and add `isXacThucSinhTracHocApplicable(record)` helper. |
| completed | frontend_angular | Gate `status == 3` / `status == 4` notification cells behind the cutover-date condition. |
| completed | Verification | Run source checks and build commands for the cutover-date change. |
| completed | Reporting | Update `testcase.md`, `report.md`, and `deploy.md` with cutover-date config evidence. |

## Tasks — v2 (`statusCode` / `errorCode` matrix revision, draft)

| Status | Area | Task |
| --- | --- | --- |
| completed | Requirement | Rewrite `expect.md` Scope/Acceptance Criteria as the `status`+`statusCode`+`errorCode` Notification Matrix (6 rows), add Open Questions and Assumptions. |
| completed | Requirement | Get Open Questions in `expect.md` answered (confirmed by user in chat: cutover-date applies only to row 1; exact trimmed string match; no other combination needs coverage; `status == 6` label is pre-existing). |
| completed | Planning | Rewrite `plan.md` Goal/Context/Impact Assessment/Implementation/Verification/Rollback for the matrix revision. |
| completed | Planning | Gate 1 re-approval of `plan.md`/`tasks.md` v2 (approved by user in chat). |
| completed | frontend_angular | Implement `getThongBaoType(record)` evaluating the 6-row Notification Matrix in `doanhnghiep-tongcucthue-tab.component.ts`, reusing `isXacThucSinhTracHocApplicable(record)` for row 1 only. |
| completed | frontend_angular | Update `doanhnghiep-tongcucthue-tab.component.html` `Thông báo` cell to render matrix rows 1/3/5 via `getThongBaoType(record)`; rows 2/4/6 and any other combination render empty with no fallback. |
| completed | Verification | Source-check each matrix row's exact condition against the implemented helper (see `report.md`). |
| skipped | Verification | Build frontend_angular with `npm run build` — skipped per explicit user request; not run. |
| completed | Reporting | Update `testcase.md`, `report.md`, `deploy.md` with the 6-row matrix scenarios and source-check evidence. |

## Tasks — v3 (`vs_transaction_log` data source correction, planned — superseded by v4 actual code)

| Status | Area | Task |
| --- | --- | --- |
| completed | Requirement | Update `expect.md` Data Source/Notification Matrix/Assumptions/Open Questions to use `vs_transaction_log.TransFormCode`/`ResponseStatus` (latest row per registration) instead of `vs_registertax.StatusCode`/`ErrorCode`. |
| completed | Planning | Rewrite `plan.md` for the v3 data-source correction (new backend query, new DTO fields, updated impact/verification/rollback). |
| superseded | invoicecore | Add `TransFormCode`/`ResponseStatus` fields to `DoanhNghiep_TongCucThueDto` — superseded, user implemented `ResponseCode` (string) instead of `ResponseStatus` (int), see v4. |
| superseded | invoicecore | Plan: query `_transactionLogRepository` directly by `RegisterTax_ID`, grouped, max `CreationTime` — superseded, user implemented a `ServiceTax`-join lookup instead, see v4. |
| completed | frontend_angular proxy | Manually patch `service-proxies.ts`: add `transFormCode`/`responseStatus` to `DoanhNghiep_TongCucThueDto` (fields, `init()`, `toJSON()`) and to `IDoanhNghiep_TongCucThueDto`. |
| superseded | frontend_angular | Plan: `getThongBaoType(record)` reads `record.transFormCode`/`record.responseStatus`, row-1-only cutover gating — superseded, user's actual code reads `record.responseCode` and wraps rows 1/3/5 in the cutover check, see v4. |

## Tasks — v4 (`vs_service_tax` join, matches user's actual implemented code)

| Status | Area | Task |
| --- | --- | --- |
| completed | Requirement | Rewrite `expect.md` Revision History/Data Source/Notification Matrix to match the actual implemented `GetData`/`getThongBaoType` code (`vs_service_tax` join, `ResponseCode` string field, cutover-date wraps rows 1/3/5). Add "Known Gaps In Current Implementation" section documenting the 6 behavior differences from the originally approved matrix. |
| completed | Planning | Rewrite `plan.md` Revision History/Context/Impact Assessment/Implementation Steps/Verification/Rollback to describe the as-built code (new `_iServiceTaxRepository`/`_iTransLogRepository` fields, N+1 per-row lookup, `ResponseCode` not `ResponseStatus`). |
| completed | invoicecore | (Already done by user) Add `IRepository<ServiceTax> iServiceTaxRepository` and `IRepository<Transaction_Log> iTransLogRepository` constructor parameters; add `TransFormCode`/`ResponseCode` to `DoanhNghiep_TongCucThueDto`; implement the per-row `ServiceTax` → `Transaction_Log` lookup in `GetData`. |
| completed | frontend_angular | (Already done by user) Update `getThongBaoType(record)` to read `record.transFormCode`/`record.responseCode`, wrapping rows 1/3/5 inside a single `isXacThucSinhTracHocApplicable(record)` check. |
| completed | Verification | Diagnostics check confirms no TypeScript/C# compile errors reported by editor tooling on the modified files. |
| pending | Requirement | Confirm with BA/TechLech whether Known Gaps 1-3 (cutover-date wrapping rows 1/3/5 instead of row 1 only; rows 1/3 no longer requiring an empty `ResponseCode`) are intentional or need to be fixed to match the originally approved matrix. |
| pending | Verification | Build backend (`dotnet build`) and frontend (`npm run build`) — not run yet; recommended before merge/deploy, especially given the new N+1 query pattern and new DI constructor parameters. |
| completed | Requirement | Create `impact.md` for this feature per `docs/rules/04-create-impact.md` (did not exist before this pass). |
| pending | Reporting | Update `testcase.md`, `report.md` to describe the actual implemented behavior — not part of this pass; only `expect.md`/`impact.md`/`plan.md`/`tasks.md` were requested. |
