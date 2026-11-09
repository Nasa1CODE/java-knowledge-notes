# CBCLOUDV2-8317 Plan

## Status

- Status: approved (with open Known Gaps — see `expect.md` "Known Gaps In Current Implementation")
- Gate 1 plan review (v1, status-only matrix): approved by user in chat — superseded, see Revision History
- Gate 1 plan review (v2, `statusCode`/`errorCode` on `vs_registertax`): approved by user in chat — superseded (wrong data source)
- Gate 1 plan review (v3, direct `RegisterTax_ID` filter on `vs_transaction_log`): approved by user in chat — superseded, actual code uses a different join
- Gate 1 plan review (v4, this revision — matches user's actual implemented code): documented as-built; Known Gaps below still need explicit BA/TechLead confirmation before final Gate 1 sign-off

## Revision History

- v1 (implemented, approved): `Thông báo` gated by `status` (3/4/5) + cutover-date condition only.
- v2 (implemented, superseded): branched on `DoanhNghiep_TongCucThueDto.StatusCode`/`ErrorCode`. Wrong data source — those fields are never populated by TCT response handlers.
- v3 (planned, superseded): planned a direct `RegisterTax_ID` filter on `vs_transaction_log` with `TransFormCode`/`ResponseStatus` (int). **The user implemented something different** — see v4.
- v4 (this revision, matches actual code): `GetData` now looks up `vs_service_tax` (`ServiceTax`, `Type == dangkythue`, `Reference_ID == registration.Id`) per row, then queries `vs_transaction_log` filtered by that `ServiceTax`'s `Id`/`TransactionCode` and `TransFormCode IN ('102','103','112')`, taking the row with the greatest `Id`. Uses `Transaction_Log.ResponseCode` (string), not `ResponseStatus` (int). Frontend `getThongBaoType` wraps rows 1/3/5 together inside a single `isXacThucSinhTracHocApplicable(record)` check, changing the cutover-date semantics from v1-v3 (see `expect.md` Known Gaps).

## Goal

Add a `Thông báo` table column whose content is determined by `status` (on `vs_registertax`) plus the latest `vs_transaction_log` row for that registration, located via the registration's associated `vs_service_tax` record (the same join pattern `TransactionLogAppService.GetDsTransaction` already uses for the "Lịch sử giao dịch" modal). See the Notification Matrix and Known Gaps sections in `expect.md`.

## Context

- frontend_angular table: `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-tongcucthue-tab.component.html`
- frontend_angular component: `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-tongcucthue-tab.component.ts`
- frontend_angular service proxy: `frontend_angular/src/shared/service-proxies/service-proxies.ts`
- invoicecore app service: `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/CauHinh/DoanhNghiep_TongCucThueAppService.cs`
- invoicecore DTO: `invoicecore/aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/CauHinh/ThongTinDoanhNghiep/DoanhNghiep_TongCucThueDto.cs`
- Config entity: `DM_NCC_CauHinh`, table `vs_dm_ncc_cauhinh`.
- Service tax entity: `HDDT.Core.Domains.CauHinh.ServiceTax` (table `vs_service_tax`) — `Reference_ID` links to the registration (`vs_registertax.Id`) when `Type == ServiceTaxType.dangkythue` (`1`, from `HDDT.Application.Commons.Commons.EnumCommons`). Injected in the AppService as a new field `_iServiceTaxRepository` (`IRepository<ServiceTax>`), distinct from the existing `_serviceTaxRepository` (`ServiceTaxRepository`) already used elsewhere in the file.
- Transaction log entity: `HDDT.Core.Domains.CauHinh.Transaction_Log` (table `vs_transaction_log`) — fields used: `TransFormCode` (string), `ResponseCode` (string), `ServiceTax_ID` (int?), `TransactionCode` (string). Injected as a new field `_iTransLogRepository` (`IRepository<Transaction_Log>`), distinct from the existing `_transactionLogRepository` (`TransactionLogRepository`) already used elsewhere in the file.
- Existing v1/v2 helpers to be extended, not replaced: `getThoiHanXacThuc(record)`, `isXacThucSinhTracHocApplicable(record)`, `loadLinkXacThucSinhTracHoc()`, `loadNgayApDungSinhTracHoc()`.

## Impact Assessment

- Backend: `DoanhNghiep_TongCucThueAppService.GetData` now performs, per row on the current page (after paging), one `ServiceTax` lookup and — if found — one `Transaction_Log` query. This is an N+1 query pattern (one extra pair of queries per row, not batched), unlike the originally planned v3 batched group-by query. For typical page sizes (10-50 rows) this is a bounded, known cost, but it does not scale to very large page sizes.
- DTO: two new fields added to `DoanhNghiep_TongCucThueDto` — `TransFormCode` (string), `ResponseCode` (string, **not** `ResponseStatus` int as v3 planned). Populated only inside `GetData`; not part of the `vs_registertax` schema, not returned by other endpoints (`GetDangKy`, `GetDangKyOrThayDoi`, `GetRegisterFinal`, etc.).
- Constructor: `DoanhNghiep_TongCucThueAppService` now takes two additional constructor parameters (`IRepository<ServiceTax> iServiceTaxRepository`, `IRepository<Transaction_Log> iTransLogRepository`), resolved via DI — no manual wiring needed since ABP resolves `IRepository<T>` automatically.
- Frontend proxy: `DoanhNghiep_TongCucThueDto` (generated class in `service-proxies.ts`) has `transFormCode`/`responseCode` fields (constructor init/toJSON, plus the `IDoanhNghiep_TongCucThueDto` interface) — manually patched since NSwag regen is not run.
- Frontend component: `getThongBaoType(record)` reads `record.transFormCode`/`record.responseCode`. **Behavior change from v1-v3 plan**: the cutover-date check (`isXacThucSinhTracHocApplicable`) now wraps rows 1, 3, and 5 together, rather than gating only row 1 — see `expect.md` Known Gaps point 1 for the resulting behavior difference and open confirmation need.
- Any other screen/report using `DoanhNghiep_TongCucThueDto` is unaffected by the two new fields (additive, nullable).

## Implementation Steps (as actually implemented)

1. Add `TransFormCode`/`ResponseCode` (both `string`) fields to `DoanhNghiep_TongCucThueDto`.
2. Add `IRepository<ServiceTax> iServiceTaxRepository` and `IRepository<Transaction_Log> iTransLogRepository` constructor parameters to `DoanhNghiep_TongCucThueAppService`, assigned to new private fields `_iServiceTaxRepository`/`_iTransLogRepository`.
3. In `GetData`, after paging and mapping to DTOs, loop over each `result` item:
   - Find the matching `ServiceTax` (`Reference_ID == item.Id`, `Type == (int)ServiceTaxType.dangkythue`, matching `DoanhNghiep_Mst`/`DoanhNghiep_CCCD`); skip the row if not found.
   - Query `Transaction_Log` filtered to that `ServiceTax`'s `Id`/`TransactionCode`, matching `DoanhNghiep_Mst`/`DoanhNghiep_CCCD`, and `TransFormCode IN ('102','103','112')`.
   - Take the row with the greatest `Id`; assign `TransFormCode`/`ResponseCode` onto the DTO row.
4. Manually patch `service-proxies.ts`: add `transFormCode`/`responseCode` to the `DoanhNghiep_TongCucThueDto` class (fields, `init()`, `toJSON()`) and to `IDoanhNghiep_TongCucThueDto`.
5. Update `getThongBaoType(record)` in `doanhnghiep-tongcucthue-tab.component.ts`:
   - Read `transFormCode` (trimmed) and `responseCode` (raw, not trimmed) from `record`.
   - Wrap rows 1/3/5 inside a single `if (this.isXacThucSinhTracHocApplicable(record)) { ... }` block.
   - Row 1: `status == 3 && transFormCode === '102'` (no `responseCode` check).
   - Row 3: `status == 4 && transFormCode === '112'` (no `responseCode` check).
   - Row 5: `status == 6 && transFormCode === '103' && responseCode === '20013'`.
   - Fall through to `return 0` otherwise.
6. No `.html` template change needed — the template already calls `getThongBaoType(record)`.
7. Update `expect.md`, `plan.md`, `tasks.md` (this pass) to document the as-implemented behavior and the Known Gaps versus the originally approved matrix.

## Verification Steps

- Source check confirms `GetData`'s `ServiceTax` → `Transaction_Log` lookup matches the pattern in `TransactionLogAppService.GetDsTransaction` (same filter shape: `DoanhNghiep_Mst`/`DoanhNghiep_CCCD`, `ServiceTax_ID`, `TransactionCode`).
- Source check confirms `getThongBaoType(record)` matches the as-implemented logic described in Implementation Steps above (not the originally planned per-row cutover-date/empty-`ResponseCode` conditions).
- **Not yet done**: confirm with BA/TechLead whether Known Gaps 1-3 in `expect.md` (cutover-date wrapping rows 1/3/5, missing `ResponseCode`-empty checks on rows 1/3) are intentional behavior changes or bugs to fix.
- Build frontend_angular with `npm run build` and backend with `dotnet build` before merging — **not run as part of this revision**, per prior explicit user request to skip build/test. In particular, the N+1 `ServiceTax`/`Transaction_Log` lookup pattern and the two new DI constructor parameters have not been verified to compile/run against the real EF Core provider.
- Manual/table trace: for each of the 6 matrix rows plus at least 2 unmatched combinations, confirm actual `Thông báo` cell content against the as-implemented `getThongBaoType`, not the original matrix (they now differ per Known Gaps).

## Rollback

- Revert `DoanhNghiep_TongCucThueAppService.GetData`, the two new constructor parameters, and `DoanhNghiep_TongCucThueDto` to drop the `ServiceTax`/`Transaction_Log` lookup and the two new fields.
- Revert `service-proxies.ts` DTO patch (`transFormCode`/`responseCode`).
- Revert `getThongBaoType(record)` to the v2 `statusCode`/`errorCode` logic, or all the way to v1 status-only logic if the whole matrix approach needs reverting.
