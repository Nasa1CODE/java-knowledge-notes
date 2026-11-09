# CBCLOUDV2-8352 Report

## Summary

Split the single "CQT chấp nhận" status (`QuanLy_TrangThai` / `Ct_TrangThai == 8`) into two detail statuses based on email-send state (`QuanLy_GuiEmail`), for Danh sách hóa đơn (including HD MTT via `Mau_HoaDon_Loai` 6/7) and Danh sách chứng từ khấu trừ thuế. New values `11` (CQT chấp nhận và đã gửi mail) and `12` (CQT chấp nhận và chưa gửi mail) were added to both the search/filter dropdown and the underlying backend filter logic. The old aggregate "CQT đã chấp nhận" (`8`) option was kept, not removed.

**Scope expanded across several later passes, all per explicit user request** (see `plan.md` Status section for the full breakdown): (1) the same email-split pattern was also applied to chứng từ "Đã ký" (`Ct_TrangThai == 3` → `13`/`14`); (2) Xuất Excel nâng cao, initially found out of scope (not wired to the detail dropdown), was wired end-to-end via a new `TrangThaiChiTiet` field; (3) the background export worker (`svinvoicesendemail/AppServiceExportBillHost`, used when the row count exceeds 200) was brought into full parity with the on-screen list/synchronous export — including two pre-existing, ticket-unrelated bugs found and fixed (a tab-status filter bug in the worker, and a `NguoiMua`/`SoHoaDon` typo in `HoaDonAppService.XuatExcelNangCao`); (4) hóa đơn máy tính tiền (`IsPos`) filtering, not present in `expect.md`'s original scope, was added end-to-end to both export paths (frontend, backend, proxy, worker). See the dedicated sections below for each.

## Files Changed

### invoicecore

- `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs`
- `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/ChungTuKhauTruThue/ChungTuKhauTruThueAppService.cs`
- `invoicecore/aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/HoaDon/QuanLyHoaDon/DanhSachHoaDonNangCaoInput.cs` (new `TrangThaiChiTiet` field)

### frontend_angular

- `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.component.ts`
- `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.component.html`
- `frontend_angular/src/app/hddt/chungtukhautruthue/dschungtukhautruthue/dschungtukhautruthue.component.html`
- `frontend_angular/src/shared/service-proxies/service-proxies.ts` (manual patch: `TrangThaiChiTiet` on `DanhSachHoaDonNangCaoInput`)

### svinvoicesendemail (background export worker, >200-row queue path)

- `svinvoicesendemail/AppServiceExportBillHost/AppService/Models/DanhSachHoaDonInput.cs` (new `IsPos` field)
- `svinvoicesendemail/AppServiceExportBillHost/AppService/Models/DanhSachHoaDonNangCaoInput.cs` (new `TrangThaiChiTiet` field, then `IsPos` field)
- `svinvoicesendemail/AppServiceExportBillHost/AppService/Repositories/HD_HoaDonRepository.cs` (`GetDataExcel(DanhSachHoaDonInput)` rewired to use `Filter.TrangThai_HoaDon` with full 0-12 mapping, tab-status filter fixed, full `Filter.*` parity added, `IsPos` condition added; `GetDataExcel(NangCao)`, `GetDataExcelChiTiet`, `GetDataExcelThueSuat` got `TrangThaiChiTiet == 8/11/12`, tab-status fix, and `IsPos` conditions)

### docs

- `docs/features/CBCLOUDV2-8352/expect.md`
- `docs/features/CBCLOUDV2-8352/plan.md`
- `docs/features/CBCLOUDV2-8352/tasks.md`
- `docs/features/CBCLOUDV2-8352/report.md` (this file)
- `docs/features/CBCLOUDV2-8352/testcase.md`
- `docs/features/CBCLOUDV2-8352/impact.md`

## Implementation Details

### Danh sách hóa đơn (`HoaDonAppService.cs`)

- `GetDataFilterTable_New` (used by the main search/filter and by `XuatExcel`, since `XuatExcel` calls this method) now has two new `WhereIf` branches:
  - `trangThai == 11` → `QuanLy_TrangThai == HoaDon_TrangThai.TCTDaChapNhan && QuanLy_GuiEmail > 0`
  - `trangThai == 12` → `QuanLy_TrangThai == HoaDon_TrangThai.TCTDaChapNhan && (QuanLy_GuiEmail == null || QuanLy_GuiEmail == 0)`
- `HD_HoaDon`/`vs_hd_tonghop` stores both regular invoices and HD MTT (`Mau_HoaDon_Loai` 6/7) in the same table, so this single change covers both without a separate MTT-specific change.
- Legacy `GetDataFilterTable` (a second, older filter method also referenced from `XuatExcel`) was left unchanged — it never handled value `8` (CQT chấp nhận) before this change either, so no new gap was introduced.
- `XuatExcelNangCao` was **updated in a later pass (per user request)** — see the dedicated section below.

### Xuất Excel nâng cao (`HoaDonAppService.XuatExcelNangCao` + `DanhSachHoaDonNangCaoInput`)

- Root cause: `XuatExcelNangCao`'s `input.TrangThai` is the **tab** value (`filters.trangThai`), not the detail status dropdown (`filterTable.trangThai_HD`), and the DTO had no `Filter` object, so the detail statuses (`8/11/12`) never reached this export.
- Fix: added a new field `TrangThaiChiTiet` (int?) to `DanhSachHoaDonNangCaoInput`, populated on the frontend from `filterTable.trangThai_HD`. Added `WhereIf(TrangThaiChiTiet == 8/11/12)` branches to all three query branches of `XuatExcelNangCao` (`LoaiXuatExcel == 0`, `== 1`, and the `else`/thuế suất branch):
  - `8` → `QuanLy_TrangThai == TCTDaChapNhan`
  - `11` → `TCTDaChapNhan && QuanLy_GuiEmail > 0`
  - `12` → `TCTDaChapNhan && (QuanLy_GuiEmail == null || == 0)`
- The existing tab-based `input.TrangThai` branches were left unchanged; `TrangThaiChiTiet` is applied in addition (AND).
- `service-proxies.ts` (frontend_angular) was manually patched to add the field (class field, `init`, `toJSON`, interface) because NSwag regeneration is not available in this environment.

### Danh sách chứng từ khấu trừ thuế (`ChungTuKhauTruThueAppService.cs`)

- `Filter(FilterChungTuInput)` and `ExportExcelCt(FilterChungTuInput)` both got the same two new branches:
  - `input.TrangThai == 11` → `Ct_TrangThai == (int)TrangThaiChungTu.tctdachapnhan && QuanLy_GuiEmail > 0`
  - `input.TrangThai == 12` → `Ct_TrangThai == (int)TrangThaiChungTu.tctdachapnhan && (QuanLy_GuiEmail == null || QuanLy_GuiEmail == 0)`
- The existing raw `input.TrangThai != null` branch was narrowed to exclude `11`/`12`/`13`/`14` so it does not also try to match `Ct_TrangThai == 11`/`12`/`13`/`14` (which do not exist as real status codes).
- The "Đã ký và đã/chưa gửi mail" split (`Ct_TrangThai == 3`, `TrangThaiChungTu.daky`) requested in the source document's version-2.0 history was **implemented per user request**:
  - `input.TrangThai == 13` → `Ct_TrangThai == (int)TrangThaiChungTu.daky && QuanLy_GuiEmail > 0` (Đã ký và đã gửi mail)
  - `input.TrangThai == 14` → `Ct_TrangThai == (int)TrangThaiChungTu.daky && (QuanLy_GuiEmail == null || QuanLy_GuiEmail == 0)` (Đã ký và chưa gửi mail)
  - Added to both `Filter` and `ExportExcelCt`; the chứng từ dropdown got two new `<option>` (`13`/`14`).

### Frontend — Danh sách hóa đơn (`hoadon.component.ts` / `.html`)

- Added two entries to `loaiTrangThaiList`: `{ label: 'CQT chấp nhận và đã gửi mail', value: '11' }` and `{ label: 'CQT chấp nhận và chưa gửi mail', value: '12' }`.
- The existing `{ label: 'CQT đã chấp nhận', value: '8' }` entry was kept as-is (not removed).
- The status badge span for `quanLy_TrangThai==8` in the table was **kept at its original single label** `{{'CQT đã chấp nhận'}}` (not split by email state). The two new detail statuses only appear in the filter dropdown, not in the table badge, per user instruction ("sửa label ở filter, giữ nguyên label trong bảng").

### Frontend — Danh sách chứng từ (`dschungtukhautruthue.component.html`)

- Added two `<option>` entries (`value="11"`, `value="12"`) to `TrangthaiCombobox`, after the existing `value="10"` option.
- The status badge span for `ct_TrangThai == 8` in the table was **kept at its original single label** `CQT đã chấp nhận` (not split by email state), matching the hóa đơn screen. The two new detail statuses only appear in the filter dropdown, not in the table badge, per user instruction.

## Design Decisions Not Confirmed By BA

The following implementation choices were made by the agent, based on the safest/most consistent option with existing code patterns, because the user instructed to proceed with implementation without waiting for formal BA sign-off. They are recorded in `expect.md`/`plan.md` as still-open questions:

- New dropdown values are `11`/`12` (arbitrary choice avoiding collision with existing `0`-`10`).
- The old aggregate "CQT đã chấp nhận" (`8`) option was kept rather than removed, despite the source document saying "(bỏ trạng thái)".
- Both `NULL` and `0` values of `quanly_guiemail` are treated as "chưa gửi mail" for both hóa đơn and chứng từ (the source document states hóa đơn uses `=0` and chứng từ uses `=null`; this implementation harmonizes both to be safe for either representation).
- Chứng từ "Đã ký và đã/chưa gửi mail" split was implemented (per user request) with values `13`/`14`, using the same NULL/0 = "chưa gửi mail" harmonization.

## Verification

**Initial pass**: build and manual testing were explicitly skipped per user instruction ("bỏ qua không build"). Only `get_diagnostics` was checked on the 5 originally changed files.

**Later passes** (worker parity, `IsPos` filter, bug fixes): `dotnet build` was run for real:

```text
dotnet build "D:\Source\billcloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\HDDT.Application.csproj" --nologo -v:minimal
→ Build succeeded. 0 Error(s).
```

```text
dotnet build "D:\Source\billcloud\svinvoicesendemail\AppServiceExportBillHost\AppService\AppService.csproj" --nologo -v:minimal
→ Build succeeded. 0 Error(s).
```

- `get_diagnostics` was also run on all changed files across both passes — no errors reported (one transient stale-cache diagnostic on `trangThaiChiTiet` in `hoadon.component.ts` was investigated and confirmed to be an IDE cache issue, not a real error — the field exists correctly in the patched proxy).
- Each change was verified by direct re-reading of the edited file sections to confirm the new branches/options/labels/conditions are syntactically consistent with surrounding code and reference existing enum members (`HoaDon_TrangThai.TCTDaChapNhan`, `TrangThaiChungTu.tctdachapnhan`) rather than magic numbers, and that SQL column names used in the worker (`tonghop_tongtien_covat`, `thanhtoan_phuongthuc`, `mau_nguoiky`, `vs_hd_thongbao_hdmau.IsPos`) were confirmed against `docs/databases/databasetenant.vs_hd_tonghop.sql` and `databasetenant.vs_hd_thongbao_hdmau.sql`.

Not done:

```text
npm run build   (inside frontend_angular/)
```

- Manual functional testing in a running app (filtering each screen by the new statuses and by IsPos, comparing exported Excel row counts to on-screen filtered counts, triggering the >200-row background queue path) was not performed.

## Follow-up Notes

### Background export queue (>200 rows) — worker had its own duplicated DTO/SQL, out of sync with `invoicecore`

`HoaDonAppService.XuatExcel`/`XuatExcelNangCao` push work to a queue (`_queueHeler.SendExportBill`) when the result set exceeds 200 rows, storing `JsonConvert.SerializeObject(input)` in `vs_service_exportbill.XuatFile_ThamSo`. A separate worker, `svinvoicesendemail/AppServiceExportBillHost`, consumes this via `Process.cs` → `NhapDSHoaDonExcelHelper.XuatExcel` → `HD_HoaDonRepository.GetDataExcel*`. This worker has **its own copies** of `DanhSachHoaDonInput`/`DanhSachHoaDonNangCaoInput` (in `AppService.Models`) and its own raw-SQL (Dapper) query builders — it does not share code with `invoicecore`.

Two issues found and fixed here (per user request, option 1):

1. **Gap introduced by this ticket's earlier change**: the worker's `DanhSachHoaDonNangCaoInput` had no `TrangThaiChiTiet` field, so it would be silently dropped on `JsonConvert.DeserializeObject`, and the new `11`/`12` filter would not apply when the >200-row nâng cao export ran through the queue.
   - Fix: added `TrangThaiChiTiet` to `svinvoicesendemail/AppServiceExportBillHost/AppService/Models/DanhSachHoaDonNangCaoInput.cs`, and `AND quanly_trangthai = 8 [AND quanly_guiemail ...]` branches to all three worker query builders (`GetDataExcel(NangCao)`, `GetDataExcelChiTiet`, `GetDataExcelThueSuat`) in `HD_HoaDonRepository.cs`.
2. **Pre-existing bug, not caused by this ticket**: the worker's `GetDataExcel(DanhSachHoaDonInput...)` (used by the plain, non-nâng-cao `XuatExcel` when >200 rows) never read `input.Filter.TrangThai_HoaDon` (the detail status dropdown) at all — only a dead top-level `input.TrangThai` check (`quanly_trangthai <> 0`), which the hóa đơn screen never populates. This means **every** detail status value (0,1,2,3,4,5,6,7,8,9,10, and now 11/12) was silently ignored by this export path once the row count exceeded 200, well before this ticket started.
   - Fix (per user decision to fix now rather than defer): rewired this method to read `input.Filter.TrangThai_HoaDon.value` and replicate the exact same branch mapping as `HoaDonAppService.GetDataFilterTable_New` (0/1 exact match, 2 = đã ký + gửi mail, 3 = đã ký + chưa gửi mail, 4 = đã ký hoặc đã cấp số, 5-10 exact match, 11/12 = CQT chấp nhận + email split). The tab-based `input.TrangThai` filter (`chonTab()`: Lưu tạm/Trình ký/Ký lỗi/Đã ký) was also fixed the same way — was previously `!= null → quanly_trangthai <> 0`, now replicates `HoaDonAppService.XuatExcel`'s `!= 3 → exact match` / `== 3 → IN (3,5,6,7,8,9)` logic. Applied identically to all 4 worker query methods (`GetDataExcel(DanhSachHoaDonInput)`, `GetDataExcel(NangCao)`, `GetDataExcelChiTiet`, `GetDataExcelThueSuat`).
3. **Full parity pass (per user decision, option 2)**: after fixing status filters, audited every other field `getFilterTables_New` sends for Xuất Excel (thường) against the worker's `GetDataExcel(DanhSachHoaDonInput...)` and found several `Filter.*` fields silently ignored: `Mau_So` (extra number-like filter), `TongTienTu`/`TongTienDen` (total amount range), `Mau_HoaDon_Loai` (detail loại hóa đơn filter, separate from top-level `LoaiHoaDon`), `KyHieuSelects` (multi-select mẫu/ký hiệu), `ThanhToan_PhuongThuc`, and `TaiKhoanTao`/`TaiKhoanKy` as LIKE-matches (worker only had an exact-match `TaiKhoanTao` from the unrelated top-level field). All were added to `GetDataExcel(DanhSachHoaDonInput...)`, using `tonghop_tongtien_covat`, `thanhtoan_phuongthuc`, `mau_nguoiky` columns confirmed against `docs/databases/databasetenant.vs_hd_tonghop.sql`. Note: `xuatExcelNangcao()` does not send any of these `Filter.*` fields (Xuất Excel nâng cao has no such advanced-filter UI), so the 3 nâng cao worker methods did not need this extra parity work — they already covered every field `DanhSachHoaDonNangCaoInput` carries.

Not touched: `svinvoicesendemail/AppServicePrintBill/AppService/Repositories/HD_HoaDonRepository.cs` has similarly-named `GetDataExcel*` methods, but that project's `Process.cs`/queue consumer (`PrintPdfProcess.cs`) only processes the `PrintPDFData` queue (PDF printing), not `ServiceExportBill`/Excel export — those methods appear to be dead/duplicated code for this flow and are out of scope.

Chứng từ khấu trừ thuế (`ChungTuKhauTruThueAppService`) has no equivalent >200-row background queue path (`Filter`/`ExportExcelCt` are synchronous), so no equivalent worker gap exists there.

### Pre-existing bug found and fixed: `XuatExcelNangCao` NguoiMua filter used `SoHoaDon` instead of `NguoiMua` in one OR branch

While verifying the worker's `NguoiMua` filter matched `invoicecore` exactly (per user request to confirm parity), found that `HoaDonAppService.XuatExcelNangCao`'s `LoaiXuatExcel == 0` branch had a pre-existing typo: 6 of 7 `OR` conditions in the `NguoiMua` filter block used `input.NguoiMua.Trim()`, but the last one (`Mau_HeThongKhacId` match) used `input.SoHoaDon` instead — not caused by this ticket, present in the original code. `XuatExcel` (plain) and the other two nâng cao branches (`LoaiXuatExcel == 1`, thuế suất) were already correct. Fixed by changing that one condition to `input.NguoiMua.Trim()`, matching the other 6 and matching the worker's already-correct raw-SQL equivalent (`svinvoicesendemail`'s 4 query methods all use `@NguoiMua` consistently — no corresponding fix needed there).

### Xuất Excel nâng cao — historical wiring investigation

During implementation, investigation of `HoaDonAppService.XuatExcelNangCao` and the frontend `xuatExcelNangcao(event)` handler found that this export path's `input.TrangThai` is populated from `this.filters.trangThai` — the **tab** value set by `chonTab()` (Lưu tạm=0, Trình ký=1, Ký lỗi=2, Đã ký=3-aggregate, Tất cả=undefined) — not from `filterTable.trangThai_HD`, the detail dropdown that carries value `8` (CQT đã chấp nhận) and the new `11`/`12` values.

This means:
- Xuất Excel nâng cao never had a way to filter specifically by "CQT chấp nhận" before this ticket, so there was no existing behavior to extend.
- Adding the two new statuses to this export path would require a new field end-to-end: a new property on `DanhSachHoaDonNangCaoInput`, new UI wiring in the "chọn trường xuất excel" modal flow, and a new backend filter branch. This is materially larger than the original "add two `WhereIf` lines" estimate.
- This was treated as out of scope during the initial pass. It was implemented in a later pass per user request; see the `Xuất Excel nâng cao` implementation section above and the worker sections below. **Xuất Excel** (the regular, non-nâng-cao export) reuses `GetDataFilterTable_New`.

Recommendation: raise with BA/TechLead whether Xuất Excel nâng cao needs the same capability as a follow-up ticket.

### Báo cáo hóa đơn was never in scope

Per `expect.md`, all Báo cáo hóa đơn screens/AppServices (e.g. `BaoCaoDoanhThuTheoSanPhamAppService`, `tinhhinhsudunghoadontheobenmua`) were explicitly placed out of scope and were not touched.

### Hóa đơn máy tính tiền (IsPos) filter added to Xuất Excel / Xuất Excel nâng cao (added per user request, not in original `expect.md` scope)

The on-screen `DanhSachHoaDon` search already filters HĐ MTT (máy tính tiền) via `input.IsPos`: `IsPos == 1` → only MTT rows, anything else (including `null`) → excludes MTT rows, resolved through a subquery on `vs_hd_thongbao_hdmau.IsPos` matched by `Mau_HDMau_Id`. `XuatExcel`/`XuatExcelNangCao` never applied this filter — added end-to-end, also used as an opportunity to optimize the query pattern:

- **`HoaDonAppService.cs`**: added a private helper `FilterByIsPos(IQueryable<HD_HoaDon> data, int? isPos)` using `Any()`/`!Any()` (translates to `EXISTS`/`NOT EXISTS`) instead of the original `DanhSachHoaDon` pattern's `Contains()` on a separately materialized subquery (`IN`/`NOT IN`). `EXISTS`/`NOT EXISTS` is expected to produce a better query plan (index lookup on `vs_hd_thongbao_hdmau.Id`, avoids `NOT IN` NULL-semantics pitfalls) and avoids materializing the full matching-Id list before the outer query runs. Applied to `XuatExcel` and all 3 branches of `XuatExcelNangCao`.
- **`DanhSachHoaDonNangCaoInput.cs`**: added `IsPos` (int?) field. `DanhSachHoaDonInput` already had this field (used by the main search).
- **`hoadon.component.ts`**: both `xuatExcel()` and `xuatExcelNangcao()` now set `input.isPos = this.loaiHoaDonIsPos` — the same value the main search (`timKiemHoaDon()`) already sends, so exports respect whichever screen (hóa đơn thường vs HĐ MTT) the user is currently viewing.
- **`service-proxies.ts`**: manually patched `isPos` onto `DanhSachHoaDonNangCaoInput` (class field, `init`, `toJSON`, interface) — NSwag regen not available.
- **Worker (`svinvoicesendemail/AppServiceExportBillHost`)**: added `IsPos` to both `DanhSachHoaDonInput` and `DanhSachHoaDonNangCaoInput` worker DTOs, and matching `EXISTS`/`NOT EXISTS` SQL conditions (`vs_hd_thongbao_hdmau` joined via `mau_hdmau_id`) to all 4 worker query methods, mirroring `FilterByIsPos`'s exact semantics.

Verification: `dotnet build` on both `HDDT.Application.csproj` and the worker's `AppService.csproj` — both **Build succeeded, 0 Error(s)**. `get_diagnostics` clean on `hoadon.component.ts` and `service-proxies.ts`. Not verified end-to-end (no running app/queue exercised in this session); `npm run build` for `frontend_angular` was not run.

### Latest worker update: de-duplicate invoice extension rows

The worker's direct `LEFT JOIN vs_hd_tonghop_morong` could return duplicate parent invoices when multiple extension rows shared one `tonghop_id`. The following methods were updated in `svinvoicesendemail/AppServiceExportBillHost/AppService/Repositories/HD_HoaDonRepository.cs`:

- `GetDataExcel(DanhSachHoaDonInput, ...)`
- `GetDataExcel(DanhSachHoaDonNangCaoInput, ...)`
- `GetDataExcelChiTiet(...)`
- `GetDataExcelThueSuat(...)`

When extension fields are requested, the join now uses a derived table selecting `MAX(id)` for each `tonghop_id`. This limits the invoice-extension side to one row per parent invoice. It does not collapse intentional multiple rows from `vs_hd_chitiet` in detail export or `vs_hd_thuesuat` in tax-rate export.

The same update added `TenantId` to invoice predicates and `IsDeleted = 0` plus matching `TenantId` to POS template subqueries. The missing parentheses around the type 6/7 predicate were fixed in advanced methods.

Verification: `dotnet build "D:\Source\billcloud\svinvoicesendemail\AppServiceExportBillHost\AppService\AppService.csproj" --no-restore -p:OutDir="C:\Users\luanlm\AppData\Local\Temp\opencode\export-build-advanced\"` succeeded with 0 errors. Live RabbitMQ/tenant-database execution remains pending.
