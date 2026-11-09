# CBCLOUDV2-8352 Tasks

## Status

- Feature status: code implemented and backend/worker builds verified; live functional tests and BA confirmation of Open Questions are still pending
- Gate 1 plan review: not requested to BA/TechLead; user instructed implementation to proceed directly
- Gate 2 docs update review: not applicable yet

## Tasks

| Status | Area | Task |
| --- | --- | --- |
| pending | Docs | Resolve remaining open questions with BA (new dropdown values, remove-vs-keep aggregate "CQT đã chấp nhận", chứng từ NULL vs 0 semantics, chứng từ Đã ký split scope, xuất Excel nâng cao values); update `expect.md`/`plan.md`. |
| completed | invoicecore | Add email-status split for `TCTDaChapNhan` in `HoaDonAppService.GetDataFilterTable_New`, covering both regular invoices and HD MTT (`Mau_HoaDon_Loai` 6/7) since both live in `HD_HoaDon`. |
| completed | invoicecore + frontend_angular | Add CQT chấp nhận email-status split to `HoaDonAppService.XuatExcelNangCao` (all 3 branches: LoaiXuatExcel 0/1/thuế suất) via new `DanhSachHoaDonNangCaoInput.TrangThaiChiTiet` field. Frontend `xuatExcelNangcao` passes `filterTable.trangThai_HD`; proxy `service-proxies.ts` updated with the new field (manual proxy patch — NSwag regen not available). |
| completed | invoicecore | Add email-status split for `tctdachapnhan` in `ChungTuKhauTruThueAppService.Filter` and `ExportExcelCt`. |
| completed | invoicecore | Add email-status split for `daky` (`Ct_TrangThai == 3`) in `ChungTuKhauTruThueAppService.Filter` and `ExportExcelCt` — values `13` (Đã ký và đã gửi mail) / `14` (Đã ký và chưa gửi mail). |
| completed | frontend_angular | Add 2 new `<option>` (`13`/`14`, Đã ký và đã/chưa gửi mail) to `TrangthaiCombobox` in `dschungtukhautruthue.component.html`. |
| completed | svinvoicesendemail | Fix background export queue (>200 rows) worker (`AppServiceExportBillHost`): added `TrangThaiChiTiet` field + query branches for Xuất Excel nâng cao (gap introduced by this ticket's Task 2), and fixed a pre-existing bug where the plain `XuatExcel` (>200 rows) worker path ignored `Filter.TrangThai_HoaDon` entirely for all status values 0-10 (per user decision to fix now). |
| completed | frontend_angular | Add 2 new options to `loaiTrangThaiList` in `hoadon.component.ts`. Table status badge kept at original label (only filter labels changed). |
| completed | frontend_angular | Add 2 new `<option>` to `TrangthaiCombobox` in `dschungtukhautruthue.component.html`. Table status badge kept at original label (only filter labels changed). |
| pending | Verification | Run `npm run build` and manual filter/export checks, including the >200-row worker path. Backend and worker `dotnet build` verification is completed. |
| completed | Reporting | Update `report.md` and `testcase.md` with real changed files and verification output after implementation. |
| completed | Reporting | Create `impact.md` with impact assessment for stakeholders/BA. |

## Task Details

### Task 0 - Resolve open questions with BA before implementation

- Area/service: `docs/`
- Description: Get BA confirmation on the open questions listed in `expect.md`. Update `expect.md` and `plan.md` assumptions accordingly.
- Acceptance criteria: all open questions have a recorded BA answer; `plan.md` assumptions no longer say "Not confirmed with BA".
- Verification: manual review of `expect.md`/`plan.md`.
- Dependencies: None
- Likely touched files: `docs/features/CBCLOUDV2-8352/expect.md`, `docs/features/CBCLOUDV2-8352/plan.md`
- Estimated scope: XS

### Task 1 - Add CQT chấp nhận email-status filter to Danh sách hóa đơn search

- Status: completed
- Area/service: `invoicecore/`
- Description: Added two `WhereIf` branches (`trangThai == 11`/`12`) in `GetDataFilterTable_New` splitting `QuanLy_TrangThai == HoaDon_TrangThai.TCTDaChapNhan` by `QuanLy_GuiEmail`. `HD_HoaDon` covers both regular invoices and HD MTT (`Mau_HoaDon_Loai` 6/7), so no separate MTT change was needed. `vs_hdpos`/`HD_Pos` batch-status combobox is out of scope and not touched. Legacy `GetDataFilterTable` was left unchanged (it never handled value `8` either).
- Acceptance criteria: filtering by each new value returns only matching `QuanLy_TrangThai == 8` rows split correctly by `QuanLy_GuiEmail`, for both regular and MTT invoice rows; no other status changes. — met by code inspection; not yet verified against a running app.
- Verification: `dotnet build` not run (skipped per user instruction); manual filter check in running app not yet done.
- Dependencies: None
- Likely touched files: `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs`
- Estimated scope: S

### Task 2 - Add CQT chấp nhận email-status filter to Xuất Excel nâng cao

- Status: completed (per user request in a later pass)
- Area/service: `invoicecore/` + `frontend_angular/`
- Description: Added a new `TrangThaiChiTiet` (int?) field to `DanhSachHoaDonNangCaoInput` carrying the detail status dropdown value, since `XuatExcelNangCao`'s existing `input.TrangThai` is the **tab** value, not the detail dropdown. Added `WhereIf(TrangThaiChiTiet == 8/11/12)` branches (CQT chấp nhận: all / đã gửi mail `QuanLy_GuiEmail > 0` / chưa gửi mail `null||0`) to all three branches of `XuatExcelNangCao` (`LoaiXuatExcel == 0`, `== 1`, and `else`/thuế suất). Frontend `xuatExcelNangcao` now sets `input.trangThaiChiTiet = filterTable.trangThai_HD`. Generated `service-proxies.ts` was manually patched to include the new field (NSwag regeneration not available). The existing tab-based `input.TrangThai` logic was left unchanged.
- Acceptance criteria: selecting a CQT chấp nhận detail status (8/11/12) then Xuất Excel nâng cao returns rows matching that status; other statuses/behaviour unchanged. — met by code inspection; not yet verified against a running app.
- Verification: `dotnet build`/`npm run build` not run. `get_diagnostics`: backend + proxy clean; component shows a stale-cache "property does not exist" error for `trangThaiChiTiet` that resolves once the TS language server reloads the patched proxy (field confirmed present in class/interface/init/toJSON).
- Dependencies: None
- Likely touched files: `HoaDonAppService.cs`, `DanhSachHoaDonNangCaoInput.cs`, `hoadon.component.ts`, `frontend_angular/src/shared/service-proxies/service-proxies.ts`
- Estimated scope: M

### Task 3 - Add CQT chấp nhận email-status filter to Danh sách chứng từ

- Status: completed
- Area/service: `invoicecore/`
- Description: Added two branches (`input.TrangThai == 11`/`12`) splitting `Ct_TrangThai == TrangThaiChungTu.tctdachapnhan` by `QuanLy_GuiEmail` in both `Filter` and `ExportExcelCt`. "Đã ký và đã/chưa gửi mail" split for `Ct_TrangThai == 3` was NOT added (out of scope for this pass, per ticket title focus on CQT chấp nhận only).
- Acceptance criteria: filtering/exporting by each new value returns only matching `Ct_TrangThai == 8` rows split correctly; no other status changes. — met by code inspection; not yet verified against a running app.
- Verification: `dotnet build` not run (skipped per user instruction); manual filter/export check not yet done.
- Dependencies: None
- Likely touched files: `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/ChungTuKhauTruThue/ChungTuKhauTruThueAppService.cs`
- Estimated scope: S

### Task 4 - Add new status options to Danh sách hóa đơn frontend

- Status: completed
- Area/service: `frontend_angular/`
- Description: Added two entries (`11`, `12`) to `loaiTrangThaiList` in `hoadon.component.ts`. The `quanLy_TrangThai==8` table badge in `hoadon.component.html` is kept at its original single label `CQT đã chấp nhận` — per user instruction only the filter dropdown labels were changed, table badge unchanged.
- Acceptance criteria: dropdown shows both new options; table badge keeps original label; other labels unchanged. — met by code inspection; not yet verified in a running app.
- Verification: `npm run build` not run (skipped per user instruction); manual dropdown/badge check not yet done.
- Dependencies: None
- Likely touched files: `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.component.ts`, `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.component.html`
- Estimated scope: S

### Task 5 - Add new status options to Danh sách chứng từ frontend

- Status: completed
- Area/service: `frontend_angular/`
- Description: Added two `<option>` entries (`11`, `12`) to `TrangthaiCombobox`. The `ct_TrangThai == 8` table badge is kept at its original single label `CQT đã chấp nhận` — per user instruction only the filter dropdown labels were changed, table badge unchanged.
- Acceptance criteria: dropdown shows both new options; table badge keeps original label; other labels unchanged. — met by code inspection; not yet verified in a running app.
- Verification: `npm run build` not run (skipped per user instruction); manual dropdown/badge check not yet done.
- Dependencies: None
- Likely touched files: `frontend_angular/src/app/hddt/chungtukhautruthue/dschungtukhautruthue/dschungtukhautruthue.component.html`
- Estimated scope: S

### Task 6 - Update report/testcase docs after implementation

- Status: completed
- Area/service: `docs/`
- Description: Created `report.md` with real changed files, implementation details, unconfirmed design decisions, and verification status (build/test skipped). Created `testcase.md` with test scenarios for tester derived from `expect.md`, all marked `not run` pending real manual verification.
- Acceptance criteria: `report.md`/`testcase.md` reflect actual implementation and verification. — met.
- Verification: manual review against actual code.
- Dependencies: Task 1, Task 3, Task 4, Task 5
- Likely touched files: `docs/features/CBCLOUDV2-8352/report.md`, `docs/features/CBCLOUDV2-8352/testcase.md`
- Estimated scope: S

### Task 7 - Create impact.md

- Status: completed
- Area/service: `docs/`
- Description: Created `impact.md` summarizing affected components (backend, frontend, database), out-of-scope items confirmed unaffected, known risks/limitations (Xuất Excel nâng cao gap, unconfirmed design decisions), and what remains unverified.
- Acceptance criteria: `impact.md` covers all affected files/services and known risks. — met.
- Verification: manual review against `report.md`/`plan.md`.
- Dependencies: Task 6
- Likely touched files: `docs/features/CBCLOUDV2-8352/impact.md`
- Estimated scope: XS

### Task 8 - Fix background export worker (svinvoicesendemail/AppServiceExportBillHost) queue gap

- Status: completed
- Area/service: `svinvoicesendemail/`
- Description: When `HoaDonAppService.XuatExcel`/`XuatExcelNangCao` return more than 200 rows, the request is queued (`vs_service_exportbill.XuatFile_ThamSo` JSON) and processed asynchronously by a separate worker (`AppServiceExportBillHost`) that has its own duplicated DTOs and raw-SQL query builders (not shared with `invoicecore`). Found and fixed, per user decision to achieve full parity with the on-screen list (option 2):
  1. New `TrangThaiChiTiet` field (added earlier in this ticket to `invoicecore`'s `DanhSachHoaDonNangCaoInput`) was missing from the worker's own copy — fixed by adding the field + matching `quanly_trangthai = 8 [AND quanly_guiemail...]` SQL branches to all 3 nâng cao worker query methods.
  2. Pre-existing bug: the worker's plain `GetDataExcel(DanhSachHoaDonInput...)` never read `Filter.TrangThai_HoaDon` (detail dropdown, 0-12) nor correctly handled the tab filter (`input.TrangThai`, was `!= null → quanly_trangthai <> 0` instead of the real tab logic) — fixed both, replicated exactly from `HoaDonAppService.GetDataFilterTable_New`/`XuatExcel`. Tab-filter fix applied to all 4 worker methods (plain + 3 nâng cao) since all had the same wrong `<> 0` check.
  3. Full parity pass: added the remaining `Filter.*` fields the on-screen search/Xuất Excel sends but the worker's plain export ignored — `Mau_So`, `TongTienTu`/`TongTienDen`, `Mau_HoaDon_Loai` (detail), `KyHieuSelects` (multi mẫu/ký hiệu), `ThanhToan_PhuongThuc`, `TaiKhoanTao`/`TaiKhoanKy` (LIKE match). Xuất Excel nâng cao's own input has no equivalent extra fields, so its 3 worker methods needed no further parity work beyond items 1-2.
- Acceptance criteria: background-queued Xuất Excel/Xuất Excel nâng cao (>200 rows) filtered by any status or field produces the same row set as the synchronous (<200 rows) path. — met by code inspection (field-by-field diff against `HoaDonAppService.GetDataFilterTable_New`/`XuatExcel`/`XuatExcelNangCao`); not yet verified end-to-end (requires triggering the >200-row path and inspecting the generated file, or running the worker locally).
- Verification: later passes built the worker successfully with 0 errors; live queue/database integration testing remains pending.
- Dependencies: Task 1, Task 2
- Likely touched files: `svinvoicesendemail/AppServiceExportBillHost/AppService/Models/DanhSachHoaDonNangCaoInput.cs`, `svinvoicesendemail/AppServiceExportBillHost/AppService/Repositories/HD_HoaDonRepository.cs`
- Estimated scope: L

## Open Items Before This Can Be Considered Fully Done

- BA confirmation on all Open Questions in `expect.md` (values `11`/`12`, keep-vs-remove aggregate option `8`, NULL/0 semantics, Chứng từ Đã ký split scope).
- `HDDT.Application.csproj` and the worker `AppService.csproj` have been built successfully; `npm run build` for `frontend_angular` remains pending.
- Manual functional verification in a running app.
- The advanced export detail-status wiring was implemented in a later pass; retain the existing BA/TechLead review item for scope and value confirmation.
- End-to-end verification of the `svinvoicesendemail/AppServiceExportBillHost` background export path (>200 rows) — code-inspected only, not run against a live queue/worker.

### Task 9 - Prevent duplicate invoice-extension rows in background export

- Status: completed
- Area/service: `svinvoicesendemail/AppServiceExportBillHost/`
- Description: Updated the plain export and all three advanced export repository methods so `vs_hd_tonghop_morong` is joined through a derived table selecting `MAX(id)` per `tonghop_id`. Added tenant filtering to invoice rows and POS-template subqueries, and fixed missing parentheses in the invoice type 6/7 predicate in advanced methods.
- Acceptance criteria: plain and advanced summary exports have at most one invoice-extension row per invoice; detail and tax-rate exports may still contain multiple rows per invoice for their intended detail/tax-rate rows.
- Verification: worker `AppService.csproj` built successfully with 0 errors using a temporary output directory. Live queue/database verification remains pending.
- Likely touched files: `svinvoicesendemail/AppServiceExportBillHost/AppService/Repositories/HD_HoaDonRepository.cs`
- Estimated scope: M
