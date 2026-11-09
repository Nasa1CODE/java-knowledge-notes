# CBCLOUDV2-8317 Expect

## Feature Status

- Status: approved
- Class: Standard

## Revision History

- v1 (approved, implemented): `Thông báo` gated purely by `status` (3/4/5) plus the `NGAY_APDUNG_SINH_TRAC_HOC` cutover-date condition.
- v2 (approved, superseded): `Thông báo` content driven by `status` + `StatusCode` + `ErrorCode` on `DoanhNghiep_TongCucThueDto` (`vs_registertax`). **This was based on an incorrect assumption** — `vs_registertax.StatusCode`/`ErrorCode` are not populated by any of the tax-authority response handlers.
- v3 (approved, superseded — see v4): `Thông báo` content driven by `status` + the latest `vs_transaction_log` row selected directly by `RegisterTax_ID`, using `TransFormCode` + `ResponseStatus` (int).
- v4 (approved, this revision — matches actual implemented code): `Thông báo` content is driven by `status` (on `vs_registertax`) + the latest `vs_transaction_log` row for that registration, where the log row is found via the same **`vs_service_tax` (`ServiceTax`) → `vs_transaction_log`** join used elsewhere in this codebase (`TransactionLogAppService.GetDsTransaction`), not by a direct `RegisterTax_ID` filter. The log fields used are `TransFormCode` (string) and `ResponseCode` (string) — not `ResponseStatus` (int) as assumed in v3. The cutover-date condition now gates **all three** content rows (1/3/5), not just row 1.

## Data Source (v4 — matches implemented code)

- `DoanhNghiep_TongCucThueAppService.GetData`, for each row on the current page (after paging):
  1. Looks up `vs_service_tax` (`ServiceTax`, via `_iServiceTaxRepository`) with `Reference_ID == item.Id`, `Type == ServiceTaxType.dangkythue` (`1`), and matching `DoanhNghiep_Mst`/`DoanhNghiep_CCCD`. This is the same "service tax" record created when the registration was signed/sent (`SaveAndSignDangKy`) or resent.
  2. If no matching `ServiceTax` is found, the row is skipped — `TransFormCode`/`ResponseCode` stay `null` on the DTO (cell renders empty).
  3. If found, queries `vs_transaction_log` (`Transaction_Log`, via `_iTransLogRepository`) filtered to matching `DoanhNghiep_Mst`/`DoanhNghiep_CCCD`, `ServiceTax_ID == svObj.Id`, `TransactionCode == svObj.TransactionCode`, and `TransFormCode IN ("102", "103", "112")`.
  4. Takes the row with the greatest `Id` (not `CreationTime`) as the "latest" log — `.OrderByDescending(o => o.Id).FirstOrDefault()`.
  5. Assigns `TransFormCode` and `ResponseCode` (both `string`) from that log row onto the DTO.
- `DoanhNghiep_TongCucThueDto` has two new fields for this: `TransFormCode` (`string`) and `ResponseCode` (`string`). **Not** `ResponseStatus` (int) as planned in v3 — the implemented code reads `Transaction_Log.ResponseCode` (string), matching the same field already used by `TransactionLogAppService.GetDsTransaction`/the "Lịch sử giao dịch" modal's "Mã phản hồi" column.
- Frontend: `getThongBaoType(record)` reads `record.transFormCode` (string, trimmed) and `record.responseCode` (compared directly, not trimmed/null-checked in the current implementation — see Known Gaps below).

## Business Goal

On the `/app/hddt/cauhinh/doanhnghieptongcucthue` list screen, users need a clear notification column that explains biometric/OTP verification requirements, tax-authority rejection reasons, and cancellation notices, after the tax authority processes a registration request. The biometric/OTP notification must only apply to registrations signed on or after a configurable cutover date, so records signed before the biometric/OTP requirement took effect do not show a confusing message.

## Scope

- Add a `Thông báo` column to the registration table.
- Add a new host config key `NGAY_APDUNG_SINH_TRAC_HOC` in `vs_dm_ncc_cauhinh` (`CauHinh_GiaTri` holds a date string, e.g. `dd/MM/yyyy`) representing the cutover date from which the biometric/OTP requirement applies.
- `Thông báo` content is determined by the combination of `status` (on `vs_registertax`) and the latest `vs_transaction_log` row's `TransFormCode`/`ResponseCode` for that registration (found via the `vs_service_tax` join described in Data Source above), per the matrix below. `TransFormCode`/`ResponseCode` are surfaced on `DoanhNghiep_TongCucThueDto` as new fields populated by `GetData`; no schema change.

### Notification Matrix

| # | `status` | `TransFormCode` | `ResponseCode` condition | `Thông báo` content | Cutover-date condition applies? |
| --- | --- | --- | --- | --- | --- |
| 1 | 3 (CQT Đã tiếp nhận) | `"102"` | (not checked in current code — see Known Gaps) | `Quý khách vui lòng thực hiện sinh trắc học/OTP qua ứng dụng eTax Mobile trước HH:mm ngày dd/MM/yyyy` + `Hướng dẫn xác thực xem tại: Link` | **Yes** — only when `doanhNghiep_NgayKy` is not null and greater than `NGAY_APDUNG_SINH_TRAC_HOC` |
| 2 | 4 (CQT Không tiếp nhận) | `"102"` | not null/empty ("Có mã lỗi") | Empty | (not reachable in current code — see Known Gaps) |
| 3 | 4 (CQT Không tiếp nhận) | `"112"` | (not checked in current code — see Known Gaps) | `Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị.` | **Yes** (per implemented code — see Revision History v4; originally specified as "No" in v1-v3) |
| 4 | 5 (CQT Chấp nhận) | `"103"` | null/empty ("Không có") | Empty | No (row never matched — see Known Gaps) |
| 5 | 6 (CQT Không chấp nhận) | `"103"` | `== "20013"` | `Quá hạn thực hiện sinh trắc học/OTP.` | **Yes** (per implemented code — see Revision History v4; originally specified as "No" in v1-v3) |
| 6 | 6 (CQT Không chấp nhận) | `"103"` | not null/empty and `!= "20013"` ("Khác") | Empty | No |

- Verification deadline (used inside row 1's message) is calculated from `doanhNghiep_NgayKy` plus one day, preserving hour and minute.
- Link is retrieved by a backend API from host table `vs_dm_ncc_cauhinh` using key `LINK_XAC_THUC_SINH_TRAC_HOC`.
- Cutover date is retrieved by a backend API from host table `vs_dm_ncc_cauhinh` using key `NGAY_APDUNG_SINH_TRAC_HOC`.

## General Rule

- Any row whose `(status, TransFormCode, ResponseCode)` combination does not exactly match one of the rows in the Notification Matrix must render the `Thông báo` cell empty (no text, no leftover markup) — this includes `status` values not covered above (`-1, 0, 1, 2, 7`), and `TransFormCode`/`ResponseCode` combinations not listed for a covered `status`.
- No fallback message is ever substituted for an unmatched combination.
- If a registration has no matching `vs_service_tax`/`vs_transaction_log` row at all (`TransFormCode`/`ResponseCode` both `undefined` on the DTO), the cell also renders empty — this is treated the same as an unmatched combination.

## Known Gaps In Current Implementation (must be confirmed with BA/TechLead before this revision can be marked fully verified)

The code as written by the user does not exactly implement rows 1/3/4/5 of the matrix above. These gaps are documented here rather than silently "fixed" in this doc, since the actual intended behavior needs confirmation:

1. **Cutover-date condition now wraps rows 1, 3, and 5 together** (`if (this.isXacThucSinhTracHocApplicable(record)) { row1; row3; row5 }` in `getThongBaoType`), instead of gating only row 1 as specified in v1-v3 of `expect.md`. This means rows 3 and 5 (NNT-cancellation notice, OTP-expired notice) now **also require** `doanhNghiep_NgayKy` to be set and after the cutover date — they will render empty for any registration signed before the cutover date, even if `TransFormCode`/`ResponseCode` match. **Needs confirmation: is this the intended behavior, or should rows 3/5 remain unconditional on the cutover date as originally specified?**
2. **Row 1 no longer checks `ResponseCode` is empty.** The condition is now only `record.status == 3 && transFormCode === '102'`, with no check that `ResponseCode` is null/empty. This means a `status == 3`/`TransFormCode == "102"` row **with** a `ResponseCode` value would still match row 1 (previously matrix row 2 said this combination should render empty). **Needs confirmation: should row 1 still require an empty `ResponseCode`, per matrix row 2?**
3. **Row 3 no longer checks `ResponseCode` is empty**, for the same reason as point 2 — the condition is only `record.status == 4 && transFormCode === '112'`.
4. **Row 4 (`status==5`) can never be reached** by the current `getThongBaoType` — there is no `status == 5` branch at all, so it always falls through to `return 0` (empty), which happens to match the matrix's "Empty" expectation for row 4, but not by design (it is a byproduct of no branch existing for `status == 5`).
5. **`responseCode` comparison is not defensively trimmed/null-checked** — `const responseStatus = record.responseCode;` is used directly (no `.toString().trim()`), unlike `transFormCode`. If the backend ever returns `ResponseCode` with surrounding whitespace, the `responseStatus === '20013'` comparison in row 5 could fail unexpectedly.
6. **Backend field is `ResponseCode` (string), not `ResponseStatus` (int).** `Transaction_Log.ResponseCode` is populated with the tax-authority error code (e.g. from `MaLoi`/`vsServiceTax.getResponsecode()` in the Java handlers) — this is a different, more appropriate field than the `ResponseStatus` (int, typically `1`/`2` "result type") used in the superseded v3 assumption. This part of the v4 correction is confirmed correct.

## Out Of Scope

- Do not change registration status workflow.
- Do not change database schema — `vs_transaction_log.TransFormCode`/`ResponseCode` and `vs_service_tax` already exist; only two new DTO-only fields are added to `DoanhNghiep_TongCucThueDto` (`TransFormCode`, `ResponseCode`), populated at query time, not persisted anywhere new.
- Do not add notifications for other screens unless separately requested.
- Do not use `releaseDate` for deadline calculation.
- Do not fall back to `creationTime` for the deadline/cutover comparison when `doanhNghiep_NgayKy` is null; treat it as "condition not met" and leave the cell empty instead.

## Assumptions Used (superseded by Known Gaps above where they conflict)

- `TransFormCode`/`ResponseCode` are compared as trimmed exact string matches (`transFormCode` is trimmed in code; `responseCode`/`responseStatus` variable is **not** trimmed in the current implementation — see Known Gaps point 5).
- The "latest" `vs_transaction_log` row per registration is selected via the `vs_service_tax` join (`ServiceTax_ID` + `TransactionCode` match), filtered to `TransFormCode IN ('102','103','112')`, taking the row with the greatest `Id`.
- The cutover-date condition, as originally specified, applies only to row 1 — **superseded** by the implemented code, which wraps rows 1/3/5 together (see Known Gaps point 1).

## Open Questions Resolution (confirmed by user in chat, v1-v3)

1. ~~Cutover-date condition applies only to row 1~~ — **superseded by the v4 implemented code**, which applies it to rows 1/3/5 together (see Known Gaps point 1; needs re-confirmation).
2. `TransFormCode`/error-code comparison: trimmed exact string match — confirmed for `transFormCode`; **not applied** to `responseCode` in the current code (see Known Gaps point 5).
3. No other `(status, TransFormCode, ResponseCode)` combination needs a defined message. Every unmatched combination renders the `Thông báo` cell empty, per the General Rule.
4. `status == 6` ("CQT Không chấp nhận") is an existing status value already rendered with a label in the "Trạng thái đăng ký" column of `doanhnghiep-tongcucthue-tab.component.html`; this ticket only adds a new `Thông báo` cell branch for it and does not change that existing label.
5. (v3, superseded by v4) The data source for the message-type code and error/result code is **not** a direct `RegisterTax_ID` filter on `vs_transaction_log` as v3 planned. The implemented code instead joins through `vs_service_tax` (`ServiceTax_ID` + `TransactionCode`), the same pattern already used by `TransactionLogAppService.GetDsTransaction`.
6. (v4, new) The error/result code field is `Transaction_Log.ResponseCode` (string), not `ResponseStatus` (int) as v3 assumed.

## Acceptance Criteria

- Table contains a `Thông báo` column.
- Row 1/3/5 content renders per the implemented `getThongBaoType` logic (see Data Source and Known Gaps above) — **note this currently differs from the originally specified per-row cutover-date and `ResponseCode`-empty conditions; Known Gaps 1-3 must be resolved with BA/TechLead before this criterion can be considered fully met.**
- Any row not matching a Notification Matrix combination renders the `Thông báo` cell empty, with no fallback content.
- The deadline in row 1 displays as `HH:mm ngày dd/MM/yyyy` using `doanhNghiep_NgayKy + 1 day`.
- The guide link is loaded from `vs_dm_ncc_cauhinh.CauHinh_GiaTri` for `CauHinh_Ma = LINK_XAC_THUC_SINH_TRAC_HOC`.
- The cutover date is loaded from `vs_dm_ncc_cauhinh.CauHinh_GiaTri` for `CauHinh_Ma = NGAY_APDUNG_SINH_TRAC_HOC`.
- `TransFormCode`/`ResponseCode` are populated on each page's rows by `GetData`, sourced from the latest matching `vs_transaction_log` row found via the `vs_service_tax` join (not a direct `RegisterTax_ID` filter).
