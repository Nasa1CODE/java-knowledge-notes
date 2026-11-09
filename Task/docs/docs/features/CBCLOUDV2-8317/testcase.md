# CBCLOUDV2-8317 Testcase

## Source

- Based on `expect.md` (v3 — `status` + latest `vs_transaction_log.TransFormCode`/`ResponseStatus` Notification Matrix).

## Test Cases — v1 (status-only matrix, superseded)

| ID | Scenario | Steps | Expected Result | Status |
| --- | --- | --- | --- | --- |
| TC-01 | `CQT Đã tiếp nhận` shows biometric/OTP notification | Inspect source for a row with `record.status == 3`. | `Thông báo` column shows biometric/OTP message, deadline, and guide link. | superseded by TC-11 |
| TC-02 | Deadline uses `doanhNghiep_NgayKy` when present | Inspect helper `getThoiHanXacThuc`. | Deadline equals `doanhNghiep_NgayKy + 1 day`, formatted `HH:mm ngày dd/MM/yyyy`. | passed by source verification |
| TC-03 | Deadline falls back to `creationTime` | Inspect helper `getThoiHanXacThuc`. | Deadline equals `creationTime + 1 day`, formatted `HH:mm ngày dd/MM/yyyy`. | superseded — `expect.md` v2 explicitly forbids fallback to `creationTime`; helper `getThoiHanXacThuc` was not changed and still has no fallback |
| TC-04 | `CQT Không tiếp nhận` shows expired message | Inspect source for a row with `record.status == 4`. | `Thông báo` column shows `Quá hạn thực hiện sinh trắc học/OTP`. | superseded by TC-13 (message moved to `status == 6` / `errorCode == "20013"`) |
| TC-05 | `CQT Chấp nhận` shows no notification | Inspect source for no notification block on `record.status == 5`. | `Thông báo` column has no `status == 5` content. | passed by source verification (still true under v2, see TC-14) |
| TC-06 | Guide link comes from host config | Inspect `GetLinkXacThucSinhTracHoc`. | API returns `vs_dm_ncc_cauhinh.CauHinh_GiaTri` for key `LINK_XAC_THUC_SINH_TRAC_HOC`. | passed by source verification |

## Test Cases — v2 (`status`+`statusCode`+`errorCode` on `vs_registertax`, superseded — wrong data source)

| ID | Scenario | Steps | Expected Result | Status |
| --- | --- | --- | --- | --- |
| TC-11 | Matrix row 1: `status==3`, `statusCode=="102"`, no `errorCode`, cutover met | Inspect `getThongBaoType(record)` v2. | `Thông báo` shows biometric/OTP message + deadline + guide link. | superseded by TC-31 — `statusCode`/`errorCode` were never populated on `vs_registertax` for TCT responses |
| TC-12 | Matrix row 2: `status==4`, `statusCode=="102"`, `errorCode` present | Inspect `getThongBaoType(record)` v2. | `Thông báo` cell empty. | superseded by TC-32 |
| TC-13 | Matrix row 3: `status==4`, `statusCode=="112"`, no `errorCode` | Inspect `getThongBaoType(record)` v2. | `Thông báo` shows `Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị.`. | superseded by TC-33 |
| TC-14 | Matrix row 4: `status==5`, `statusCode=="103"`, no `errorCode` | Inspect `getThongBaoType(record)` v2. | `Thông báo` cell empty. | superseded by TC-34 |
| TC-15 | Matrix row 5: `status==6`, `statusCode=="103"`, `errorCode=="20013"` | Inspect `getThongBaoType(record)` v2. | `Thông báo` shows `Quá hạn thực hiện sinh trắc học/OTP.`. | superseded by TC-35 |
| TC-16 | Matrix row 6: `status==6`, `statusCode=="103"`, `errorCode` present and `!= "20013"` | Inspect `getThongBaoType(record)` v2. | `Thông báo` cell empty. | superseded by TC-36 |
| TC-17 | General Rule: unmatched combination | Inspect `getThongBaoType(record)` v2. | `Thông báo` cell empty, no fallback text. | superseded by TC-37 (still true in v3) |
| TC-18 | Row 1 cutover-date condition not met | Inspect `isXacThucSinhTracHocApplicable(record)` v2. | `Thông báo` cell empty. | superseded by TC-38 (still true in v3) |
| TC-19 | Cutover-date condition does NOT gate rows 3/5 | Inspect `getThongBaoType(record)` v2. | Rows 3/5 content shows regardless of cutover date. | superseded by TC-39 (still true in v3) |
| TC-20 | Guide link comes from host config | Inspect `GetLinkXacThucSinhTracHoc` (unchanged). | API returns `vs_dm_ncc_cauhinh.CauHinh_GiaTri` for key `LINK_XAC_THUC_SINH_TRAC_HOC`. | passed by source verification (still true in v3) |
| TC-21 | Cutover date comes from host config | Inspect `GetNgayApDungSinhTracHoc` (unchanged). | API returns `vs_dm_ncc_cauhinh.CauHinh_GiaTri` for key `NGAY_APDUNG_SINH_TRAC_HOC`, parsed `dd/MM/yyyy`. | passed by source verification (still true in v3) |

## Test Cases — v3 (`status` + latest `vs_transaction_log.TransFormCode`/`ResponseStatus`)

| ID | Scenario | Steps | Expected Result | Status |
| --- | --- | --- | --- | --- |
| TC-30 | Backend loads latest `vs_transaction_log` row per registration, after paging | Inspect `DoanhNghiep_TongCucThueAppService.GetData`: the `_transactionLogRepository` query runs on `registerIds` derived from `customers` (the already-`PageBy`'d list), not from the pre-paging `query`. | `GetData` only queries `vs_transaction_log` for the current page's rows. | passed by source verification |
| TC-31 | Matrix row 1: `status==3`, `TransFormCode=="102"`, no `ResponseStatus`, cutover met | Inspect `getThongBaoType(record)` v3 in `doanhnghiep-tongcucthue-tab.component.ts`, and `GetData`'s group-by-max-`CreationTime` selection filtered to `TransFormCode IN ('102','103','112')`. | `Thông báo` shows biometric/OTP message + deadline (`getThoiHanXacThuc`) + guide link, only when `isXacThucSinhTracHocApplicable(record)` is also true. | passed by source verification |
| TC-32 | Matrix row 2: `status==4`, `TransFormCode=="102"`, `ResponseStatus` present | Inspect `getThongBaoType(record)`: row 1 condition requires `!hasResponseStatus`, and `status==4` never matches row 1/3/5. | `Thông báo` cell empty. | passed by source verification |
| TC-33 | Matrix row 3: `status==4`, `TransFormCode=="112"`, no `ResponseStatus` | Inspect `getThongBaoType(record)` row-3 branch. | `Thông báo` shows `Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị.`, with no cutover-date condition applied. | passed by source verification |
| TC-34 | Matrix row 4: `status==5`, `TransFormCode=="103"`, no `ResponseStatus` | Inspect `getThongBaoType(record)`: no branch matches `status==5`. | `Thông báo` cell empty. | passed by source verification |
| TC-35 | Matrix row 5: `status==6`, `TransFormCode=="103"`, `ResponseStatus==20013` | Inspect `getThongBaoType(record)` row-5 branch. | `Thông báo` shows `Quá hạn thực hiện sinh trắc học/OTP.`, with no cutover-date condition applied. | passed by source verification |
| TC-36 | Matrix row 6: `status==6`, `TransFormCode=="103"`, `ResponseStatus` present and `!= 20013` | Inspect `getThongBaoType(record)`: row-5 branch requires exact `responseStatus === '20013'` (string-compared). | `Thông báo` cell empty. | passed by source verification |
| TC-37 | General Rule: unmatched combination (e.g. `status==3`, `TransFormCode!="102"`, or no matching `vs_transaction_log` row at all) | Inspect `getThongBaoType(record)`: falls through to `return 0` when no branch matches, including when `record.transFormCode`/`record.responseStatus` are both `undefined` (no matching log row found in `GetData`). | `Thông báo` cell empty, no fallback text. | passed by source verification |
| TC-38 | Row 1 cutover-date condition not met | Inspect `isXacThucSinhTracHocApplicable(record)` short-circuit inside the row-1 branch. | `Thông báo` cell empty even though `status==3`/`TransFormCode=="102"`/no `ResponseStatus`. | passed by source verification |
| TC-39 | Cutover-date condition does NOT gate rows 3/5 | Inspect `getThongBaoType(record)`: row-3 and row-5 branches do not call `isXacThucSinhTracHocApplicable`. | Rows 3/5 content shows regardless of `doanhNghiep_NgayKy`/cutover date. | passed by source verification |

## Verification Evidence

```text
PASS: CBCLOUDV2-8317 v3 source checks passed
- DoanhNghiep_TongCucThueDto has new TransFormCode (string) / ResponseStatus (int?) fields.
- GetData queries _transactionLogRepository for the current page's RegisterTax_ID set only,
  filters TransFormCode IN ('102','103','112'), groups by RegisterTax_ID, and takes the row
  with the greatest CreationTime per group.
- service-proxies.ts DoanhNghiep_TongCucThueDto/IDoanhNghiep_TongCucThueDto patched with
  transFormCode/responseStatus (fields, init(), toJSON()).
- getThongBaoType(record) reads record.transFormCode/record.responseStatus; matrix rows 1/3/5
  and the row-1-only cutover-date gating are unchanged from v2.
- No TypeScript/C# diagnostics reported on any of the 4 modified files.
```

Note: `npm run build` / `dotnet build` were not run for this revision per the same skip-build/test constraint carried over from v2. No automated build/runtime verification evidence is available; only source-level review and editor diagnostics above.
