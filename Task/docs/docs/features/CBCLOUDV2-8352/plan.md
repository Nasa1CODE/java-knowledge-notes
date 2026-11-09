# CBCLOUDV2-8352 Plan

## Status

- Status: implemented, expanded across multiple later passes per user request (code changes done per user instruction to proceed without waiting for formal BA sign-off on the Open Questions; the Assumptions below were used as the implementation decisions and still need BA confirmation before this is considered fully closed)
- Gate 1 plan review: not formally requested to BA/TechLead; user instructed implementation to proceed directly in chat
- Verified by `dotnet build` (both `HDDT.Application.csproj` and the worker's `AppService.csproj` — both succeeded, 0 errors); not yet verified end-to-end in a running app/queue
- Scope grew beyond the original ticket title during implementation, per explicit user requests at each step: (a) chứng từ "Đã ký" split (`13`/`14`), (b) background export worker parity fixes (tab-status bug, `TrangThaiChiTiet`, full `Filter.*` fields), (c) a pre-existing `NguoiMua`/`SoHoaDon` typo fix in `XuatExcelNangCao`, (d) hóa đơn máy tính tiền (`IsPos`) filter added end-to-end to `XuatExcel`/`XuatExcelNangCao` (frontend, backend, proxy, worker) — items (b)-(d) are not in `expect.md`'s original scope and should be reviewed by BA/TechLead as either accepted scope expansion or split into follow-up tickets

## Goal

Split the single "CQT chấp nhận" status (`QuanLy_TrangThai` / `Ct_TrangThai == 8`) into two filterable/displayable detail statuses based on `QuanLy_GuiEmail` (`quanly_guiemail`) state, applied consistently across Danh sách hóa đơn (thường + MTT), Danh sách chứng từ khấu trừ thuế, xuất Excel, and xuất Excel nâng cao. Báo cáo hóa đơn is explicitly out of scope for this ticket (see `expect.md` Out Of Scope).

Also covers, added during implementation per explicit user request: the equivalent "Đã ký" email-split for chứng từ, full parity fixes for the >200-row background export worker (`svinvoicesendemail/AppServiceExportBillHost`), a pre-existing filter bug fix in `XuatExcelNangCao`, and end-to-end hóa đơn máy tính tiền (`IsPos`) filtering for both export paths.

## Context

- `docs/architecture.md` §7, §13: `invoicecore/aspnet-core/` (not `api-cloud-service/` or `api-qldv-service/`) hosts the HDDT application services (`HDDT.Application`) that back `frontend_angular/src/app/hddt/`. Confirmed by source inspection — `HoaDonAppService.cs` and `ChungTuKhauTruThueAppService.cs` live under `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/`.
- Existing precedent: invoices already split one status into two by email state — `QuanLy_TrangThai == 3` ("Đã ký") is split into value `2` ("Đã ký và đã gửi mail", `QuanLy_GuiEmail > 0`) and value `3` ("Đã ký và chưa gửi mail", `QuanLy_GuiEmail == 0`) in `HoaDonAppService.GetDataFilterTable` / `GetDataFilterTable_New`. This ticket applies the same pattern to status `8` (CQT chấp nhận).
- No such split exists yet for Chứng từ (`ChungTuKhauTruThueAppService.Filter`/`ExportExcelCt` filter only by raw `Ct_TrangThai`).

## Impact Assessment

### Frontend (`frontend_angular/`)

| Screen | File | Current state |
| --- | --- | --- |
| Danh sách hóa đơn (thường) | `src/app/hddt/hoadon/quanlyhoadon/hoadon.component.ts` (`loaiTrangThaiList`, lines ~277-289) | value `8` = "CQT đã chấp nhận" |
| Danh sách hóa đơn (thường) — badge | `src/app/hddt/hoadon/quanlyhoadon/hoadon.component.html` (lines ~570-576) | `record.quanLy_TrangThai==8` shows "CQT đã chấp nhận" |
| Danh sách hóa đơn MTT | covered by the same `HD_HoaDon`/`hoadon.component.ts` filter changes (Task 1), `Mau_HoaDon_Loai` 6/7 | in scope via `HD_HoaDon`, not a separate screen |
| Danh sách chứng từ khấu trừ thuế | `src/app/hddt/chungtukhautruthue/dschungtukhautruthue/dschungtukhautruthue.component.html` (lines ~126-142 dropdown, ~284-295 badge) | value `8` = "CQT đã chấp nhận" |
Out of scope: Báo cáo hóa đơn screens (`src/app/hddt/baocao/doanhthutheosanpham/`, `src/app/hddt/baocao/tinhhinhsudunghoadontheobenmua/`, and any other report using `<option value="8"> CQT chấp nhận </option>`) are not changed by this ticket.

**Correction found during implementation — Xuất Excel nâng cao is NOT wired to the detail status dropdown.** `xuatExcelNangcao(event)` sends `input.trangThai = this.filters.trangThai`, where `filters.trangThai` is the **tab** value (`chonTab()`: Lưu tạm=0, Trình ký=1, Ký lỗi=2, Đã ký=3-aggregate, Tất cả=undefined) — a completely different variable from `filterTable.trangThai_HD` (the detail dropdown with value `8`="CQT đã chấp nhận" used by main search and `XuatExcel`). `XuatExcelNangCao`'s backend filter block (`input.TrangThai` in `HoaDonAppService.XuatExcelNangCao`) never receives value `8` today, so there is no existing "filter nâng cao by CQT chấp nhận" behavior to extend. Adding the two new statuses here required a new field end-to-end. **Update (later pass, per user request): this has now been implemented** — a new `TrangThaiChiTiet` field on `DanhSachHoaDonNangCaoInput` (fed from `filterTable.trangThai_HD`), `WhereIf(TrangThaiChiTiet == 8/11/12)` in all three `XuatExcelNangCao` branches, and a manual `service-proxies.ts` patch (NSwag regen not available). The tab-based `input.TrangThai` logic is unchanged.

### Backend (`invoicecore/aspnet-core/`)

| Function | File | Current filter logic |
| --- | --- | --- |
| Danh sách hóa đơn search (new UI) | `HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs`, `GetDataFilterTable_New` (~line 845) | `trangThai == 8 → o.QuanLy_TrangThai == HoaDon_TrangThai.TCTDaChapNhan` |
| Danh sách hóa đơn search (legacy filter object) | same file, `GetDataFilterTable` (~line 777-784) | only handles trangThai `0`/`1`/`2`/`3`; does not yet handle `8` at all — needs the same treatment if this path is still reachable |
| `XuatExcel` | same file (~line 1034-1067) | calls both `GetDataFilterTable_New` and `GetDataFilterTable` — inherits the change made in Task 1 |
| `XuatExcelNangCao` | same file (~line 1188+) | **changed (later pass)**: new `TrangThaiChiTiet` field fed from the detail dropdown; `WhereIf(TrangThaiChiTiet == 8/11/12)` added to all 3 branches. `input.TrangThai` (tab) logic unchanged |
| Danh sách chứng từ search | `HDDT.Application/AppServices/ChungTuKhauTruThue/ChungTuKhauTruThueAppService.cs`, `Filter(FilterChungTuInput)` (~line 168-198) | `input.TrangThai != null, o => o.Ct_TrangThai == input.TrangThai` — no split today |
| Xuất Excel chứng từ | same file, `ExportExcelCt(FilterChungTuInput)` (~line 1540-1560) | same as above |
| Enum reference | `HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_HoaDon.cs` — `HoaDon_TrangThai.TCTDaChapNhan = 8` | |
| Enum reference | `HDDT.Application/Commons/Commons/EnumCommons.cs` — `TrangThaiChungTu.tctdachapnhan = 8` | |
| Entity fields | `HD_HoaDon.QuanLy_GuiEmail` (int?, maps `vs_hd_tonghop.quanly_guiemail`), `ChungTu_KhauTru.QuanLy_GuiEmail` (int?, maps `vs_chungtu_khautru.quanly_guiemail`) | |

Out of scope: report AppServices such as `HDDT.Application/AppServices/BaoCao/BaoCaoDoanhThuTheoSanPhamAppService .cs` (note the literal space in filename) are not changed by this ticket, even though they also reference `QuanLy_TrangThai == HoaDon_TrangThai.TCTDaChapNhan`.

### Database

- No schema change. `quanly_guiemail` already exists as nullable int on both `vs_hd_tonghop` and `vs_chungtu_khautru`.

## Assumptions Used For Implementation (still require BA confirmation — see `expect.md` Open Questions)

- New dropdown values implemented as `11` (CQT chấp nhận và đã gửi mail) and `12` (CQT chấp nhận và chưa gửi mail) for both hóa đơn and chứng từ, since existing values `0`-`10` were already in use. **Not confirmed with BA — implemented as the most reasonable non-colliding choice.**
- The plain "CQT đã chấp nhận" (`8`) dropdown option was kept as-is (not removed) alongside the two new options, i.e. NOT following the source doc's "(bỏ trạng thái)" wording literally. **Not confirmed with BA — implemented as the safer, backward-compatible choice.**
- Both `NULL` and `0` values of `quanly_guiemail` are treated as "chưa gửi mail" for both entities (harmonizing the doc's stated inconsistency between hóa đơn `=0` and chứng từ `=null`). **Implemented this way; not confirmed with BA.**
- HD MTT scope: limited to `HD_HoaDon` rows with `Mau_HoaDon_Loai` 6/7, already covered by the same `HoaDonAppService` filter changes (no separate task needed). The separate `vs_hdpos`/`HD_Pos` batch-status combobox is NOT touched — decided, no longer an open question.
- Chứng từ "Đã ký và đã/chưa gửi mail" split (also requested in the source document, `Ct_TrangThai == 3`) **was implemented** (per user request) using values `13` (Đã ký và đã gửi mail) / `14` (Đã ký và chưa gửi mail), following the same `QuanLy_GuiEmail > 0` vs `null/0` pattern as the CQT chấp nhận split. Added to `Filter` and `ExportExcelCt` and the chứng từ dropdown.
- Báo cáo hóa đơn is out of scope for this ticket; no report AppService is changed here.
- Xuất Excel nâng cao (`XuatExcelNangCao`) was **updated in a later pass (per user request)**: a new `TrangThaiChiTiet` field on `DanhSachHoaDonNangCaoInput` carries the detail dropdown value (`filterTable.trangThai_HD`), and `WhereIf(TrangThaiChiTiet == 8/11/12)` branches were added to all three query branches. `service-proxies.ts` was manually patched (NSwag regen not available). The existing tab-based `input.TrangThai` logic is unchanged.

## Implementation Approach (as executed)

1. **Backend — Danh sách hóa đơn** (done): added two `WhereIf` branches (`trangThai == 11`/`12`) in `HoaDonAppService.GetDataFilterTable_New`, splitting `QuanLy_TrangThai == HoaDon_TrangThai.TCTDaChapNhan` by `QuanLy_GuiEmail`. `GetDataFilterTable` (legacy path) was left unchanged since it never handled value `8` either — not extended, to avoid introducing new untested behavior beyond what already existed for that path.
2. **Backend + Frontend — Xuất Excel nâng cao** (done, later pass): added `DanhSachHoaDonNangCaoInput.TrangThaiChiTiet` (int?), fed from `filterTable.trangThai_HD` in `xuatExcelNangcao`, with `WhereIf(TrangThaiChiTiet == 8/11/12)` branches in all three `XuatExcelNangCao` query branches. Manually patched `service-proxies.ts` for the new field.
3. **Backend — Danh sách chứng từ** (done): added the same two branches (`Ct_TrangThai == TrangThaiChungTu.tctdachapnhan` split by `QuanLy_GuiEmail`) to both `Filter` and `ExportExcelCt` in `ChungTuKhauTruThueAppService.cs`. The "Đã ký và đã/chưa gửi mail" split (`Ct_TrangThai == 3`) was **not** added — out of scope for this pass.
4. **Frontend — Danh sách hóa đơn** (done): added two entries (`11`, `12`) to `loaiTrangThaiList` in `hoadon.component.ts`. The table status badge in `hoadon.component.html` for `quanLy_TrangThai==8` is **kept at its original single label** `CQT đã chấp nhận` (not split by email) — per user instruction the split labels appear only in the filter dropdown, not in the table.
5. **Frontend — Danh sách chứng từ** (done): added two `<option>` entries (`11`, `12`) to the `TrangthaiCombobox` in `dschungtukhautruthue.component.html`. The table status badge for `ct_TrangThai == 8` is **kept at its original single label** `CQT đã chấp nhận` (not split by email), matching the hóa đơn screen.
6. **Backend — Danh sách chứng từ, "Đã ký" split** (done, later pass per user request): added the same email-split pattern to `Ct_TrangThai == TrangThaiChungTu.daky (3)` using values `13` (Đã ký và đã gửi mail) / `14` (Đã ký và chưa gửi mail) in both `Filter` and `ExportExcelCt`, plus two new `<option>` in `dschungtukhautruthue.component.html`.
7. **Background export worker parity** (done, later pass per user request — option 2, full parity): fixed the worker's (`svinvoicesendemail/AppServiceExportBillHost`) tab-status filter bug, added the missing `TrangThaiChiTiet` field, and added the remaining `Filter.*` fields (`Mau_So`, `TongTienTu`/`TongTienDen`, `Mau_HoaDon_Loai`, `KyHieuSelects`, `ThanhToan_PhuongThuc`, `TaiKhoanTao`/`TaiKhoanKy` LIKE) to the plain `GetDataExcel(DanhSachHoaDonInput)` worker method so the >200-row background export path matches the on-screen list/synchronous export exactly. See "Background Export Worker" section below for full detail.
8. **`NguoiMua` filter bug fix** (done, later pass): fixed a pre-existing typo in `HoaDonAppService.XuatExcelNangCao`'s `LoaiXuatExcel == 0` branch where the last `NguoiMua` OR-condition used `input.SoHoaDon` instead of `input.NguoiMua`.
9. **Hóa đơn máy tính tiền (IsPos) filter for exports** (done, later pass per user request, not in original `expect.md` scope): added `FilterByIsPos` helper in `invoicecore`, wired into `XuatExcel`/`XuatExcelNangCao`; added `IsPos` to `DanhSachHoaDonNangCaoInput` (backend + proxy); frontend `xuatExcel()`/`xuatExcelNangcao()` now send `input.isPos`; mirrored in the worker's 4 query methods via `EXISTS`/`NOT EXISTS`. See "Hóa đơn máy tính tiền (IsPos)" section below for full detail.
10. **Docs**: `report.md`/`testcase.md`/`impact.md` updated to reflect all of the above; `dotnet build` run for both `HDDT.Application.csproj` and the worker's `AppService.csproj` (both succeeded, 0 errors) — see Verification Plan.

## Verification Plan

- **Initial pass**: build verification was skipped per explicit user instruction ("bỏ qua không build"). Only `get_diagnostics` was checked on the 5 originally changed files.
- **Later passes**: `dotnet build` was run for real and confirmed:
  - `dotnet build "invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj"` → **Build succeeded, 0 Error(s)** (covers all `HoaDonAppService.cs`/`ChungTuKhauTruThueAppService.cs`/`DanhSachHoaDonNangCaoInput.cs` changes, including `FilterByIsPos`, tab-filter and `NguoiMua` bug fixes).
  - `dotnet build "svinvoicesendemail/AppServiceExportBillHost/AppService/AppService.csproj"` → **Build succeeded, 0 Error(s)** (covers all worker DTO and `HD_HoaDonRepository.cs` changes).
  - `npm run build` for `frontend_angular` was **not** run in this session; `get_diagnostics` on `hoadon.component.ts` and `service-proxies.ts` reported no issues (one transient stale-cache diagnostic on `trangThaiChiTiet` resolved itself after the proxy patch, per investigation — not a real error).
- Source checks performed (confirmed by direct reading of the edited files):
  - `HoaDonAppService.GetDataFilterTable_New` branches `trangThai == 11`/`12` on `TCTDaChapNhan` split by `QuanLy_GuiEmail`.
  - `ChungTuKhauTruThueAppService.Filter` and `ExportExcelCt` both branch `input.TrangThai == 11`/`12`/`13`/`14` on `tctdachapnhan`/`daky` split by `QuanLy_GuiEmail`.
  - `hoadon.component.ts` `loaiTrangThaiList` and `dschungtukhautruthue.component.html` dropdown both expose the new options (`11`/`12` hóa đơn; `11`/`12`/`13`/`14` chứng từ).
  - Status badge templates in both HTML files render the correct label for both new detail states; other status branches were left untouched.
  - `XuatExcelNangCao`'s 3 branches all apply `TrangThaiChiTiet` and `IsPos`; the worker's 4 query methods all apply matching tab-status, `TrangThaiChiTiet`, `IsPos`, and (for the plain method) full `Filter.*` parity.
- Not done / still pending: manual filter/export testing in a running app (filter Danh sách hóa đơn/chứng từ by each new status and by IsPos, compare `XuatExcel`/`XuatExcelNangCao`/`ExportExcelCt` output row counts to on-screen filtered counts, including triggering the >200-row background queue path). These must run before this feature can be considered fully verified end-to-end.

## Risk Matrix

| Risk | Impact | Mitigation | Rollback |
| --- | --- | --- | --- |
| New dropdown values collide with a value already used elsewhere (e.g. saved links, other filters) | Medium — wrong data shown | Confirm exact values with BA before coding; grep all usages of the chosen values in both frontend and backend before assigning | Revert dropdown option and filter branch additions |
| Removing old "CQT đã chấp nhận" option breaks saved bookmarks/links or other code referencing value `8` for the aggregate | Medium | Keep aggregate option per current assumption unless BA explicitly asks to remove it | Re-add the removed option |
| `GetDataFilterTable` (legacy path) still reachable and diverges from `GetDataFilterTable_New` after this change | Low-Medium — inconsistent filter results between screens/export | Mirror changes in both methods; verify both call sites (`XuatExcel`, main search) | Revert change to whichever method causes divergence |
| Chứng từ "chưa gửi mail" semantics (`NULL` vs `0`) implemented incorrectly | Medium — wrong filter results | Confirm treatment of NULL with BA; write explicit `WhereIf` covering both NULL and 0 | Adjust condition, no data change needed |
| Báo cáo hóa đơn left inconsistent with list screens (still shows old aggregate "CQT chấp nhận" only) | Low — accepted inconsistency, not a defect | Out of scope per `expect.md`; track as a separate ticket if BA wants report parity later | N/A — feature intentionally not extended to reports |
| Scope expanded well beyond original ticket title (worker parity, `IsPos` filter, bug fixes) without a formal change request/BA sign-off | Medium — larger blast radius than originally planned/reviewed, harder to review as one unit | Documented explicitly in `plan.md`/`report.md`/`impact.md`; recommend BA/TechLead review before release, and consider splitting follow-up items into separate tickets retroactively | Revert the specific later-pass commits/hunks independently since each was implemented as a discrete, separable change |
| Worker (`svinvoicesendemail/AppServiceExportBillHost`) changes only verified by `dotnet build`, not by running the actual queue/worker against real data | Medium — the >200-row path is the one most likely to hit subtle SQL/param bugs (raw Dapper string-built SQL, no compiler check on SQL text) | Manually re-read every changed SQL fragment against column names in `docs/databases/databasetenant.vs_hd_tonghop.sql`; recommend triggering a real >200-row export in a test environment before production release | Revert the specific worker method changes; the synchronous (<200-row) path is unaffected |

## Deployment Notes

- No database migration required (column already exists).
- No config/environment change required.
- Standard build/deploy of `invoicecore` (HDDT.Application) and `frontend_angular` covers this change; no new deployment artifact.

## Background Export Worker (svinvoicesendemail/AppServiceExportBillHost) — discovered and fixed during implementation

`HoaDonAppService.XuatExcel`/`XuatExcelNangCao` queue the export job when the result exceeds 200 rows, and a separate worker (`svinvoicesendemail/AppServiceExportBillHost`, own DTOs, own Dapper SQL builders) processes it. Several issues found here, all fixed per user decision (option 2: full parity with the on-screen list, plus fixing everything found along the way rather than deferring):

1. The `TrangThaiChiTiet` field added to `invoicecore`'s `DanhSachHoaDonNangCaoInput` (Xuất Excel nâng cao fix) was missing from the worker's duplicated DTO, so it would be dropped on JSON deserialize. Fixed by mirroring the field and adding matching SQL branches in the worker.
2. Pre-existing, ticket-unrelated bug: the worker's plain `GetDataExcel(DanhSachHoaDonInput...)` never read `Filter.TrangThai_HoaDon` — every detail status (0-10) was silently dropped once the >200-row queue path ran. Fixed by replicating the same 0-12 branch mapping used in `HoaDonAppService.GetDataFilterTable_New`.
3. Pre-existing, ticket-unrelated bug: all 4 worker query methods (`GetDataExcel(DanhSachHoaDonInput)`, `GetDataExcel(NangCao)`, `GetDataExcelChiTiet`, `GetDataExcelThueSuat`) filtered the **tab** value (`input.TrangThai`, from `chonTab()`: Lưu tạm/Trình ký/Ký lỗi/Đã ký) incorrectly — only checked `!= null → quanly_trangthai <> 0` instead of replicating the real tab logic (`!= 3` exact match, `== 3` → `IN (3,5,6,7,8,9)`). Fixed to match `HoaDonAppService.XuatExcel`'s tab logic exactly, in all 4 methods.
4. Full parity pass on the worker's plain `GetDataExcel(DanhSachHoaDonInput...)`: added the remaining `Filter.*` fields that the on-screen search/`XuatExcel` sends but the worker silently ignored — `Filter.Mau_So`, `Filter.TongTienTu`/`TongTienDen` (mapped to `tonghop_tongtien_covat`), `Filter.Mau_HoaDon_Loai` (detail loại hóa đơn, separate from the top-level `LoaiHoaDon`), `Filter.KyHieuSelects` (multi mẫu/ký hiệu, built as a dynamic `OR` list with `'` escaping), `Filter.ThanhToan_PhuongThuc` (`thanhtoan_phuongthuc`), and `Filter.TaiKhoanTao`/`TaiKhoanKy` as `LIKE` matches (`mau_nguoilap`/`mau_nguoiky`) — the worker previously only had an unrelated exact-match `TaiKhoanTao` from the top-level field. Column names confirmed against `docs/databases/databasetenant.vs_hd_tonghop.sql`. `XuatExcelNangCao`'s own input has no equivalent extra fields, so the 3 nâng cao worker methods needed no further parity work beyond items 1-3.
5. Pre-existing, ticket-unrelated bug found while cross-checking the `NguoiMua` filter for parity: `HoaDonAppService.XuatExcelNangCao`'s `LoaiXuatExcel == 0` branch had 6 of 7 `OR` conditions in the `NguoiMua` filter block correctly using `input.NguoiMua.Trim()`, but the last one (`Mau_HeThongKhacId` match) used `input.SoHoaDon` instead — a typo present in the original code, not caused by this ticket. `XuatExcel` (plain) and the other two nâng cao branches (`LoaiXuatExcel == 1`, thuế suất) were already correct. Fixed the one condition to `input.NguoiMua.Trim()`. The worker's raw-SQL equivalent already used `@NguoiMua` consistently in all 4 methods, so no corresponding worker fix was needed for this item.

See `report.md` "Background export queue" and "Pre-existing bug found and fixed" sections for full detail. Verified by `dotnet build` (both `HDDT.Application.csproj` and the worker's `AppService.csproj` — both "Build succeeded, 0 Error(s)"), not yet verified end-to-end against a live queue/worker run.

## Hóa đơn máy tính tiền (IsPos) filter added to Xuất Excel / Xuất Excel nâng cao — added per user request, not originally in `expect.md` scope

The on-screen `DanhSachHoaDon` search already filters HĐ MTT (máy tính tiền) via `input.IsPos`: `IsPos == 1` → only MTT rows (`EXISTS` on `vs_hd_thongbao_hdmau.IsPos = 1` matched by `Mau_HDMau_Id`), anything else (including `null`) → excludes MTT rows. `XuatExcel`/`XuatExcelNangCao` never applied this filter at all — added it end-to-end, and used the opportunity to optimize the query pattern:

1. **`invoicecore`**: added private helper `HoaDonAppService.FilterByIsPos(IQueryable<HD_HoaDon> data, int? isPos)`, using `Any()`/`!Any()` (translates to `EXISTS`/`NOT EXISTS`) instead of the original `Contains()` on a separately materialized subquery (`IN`/`NOT IN`) — expected to produce a better query plan (index lookup on `vs_hd_thongbao_hdmau.Id`, avoids `NOT IN` NULL-semantics pitfalls). Applied to `XuatExcel` and to all 3 branches of `XuatExcelNangCao` (`LoaiXuatExcel` 0/1/thuế suất).
2. Added `IsPos` (int?) to `DanhSachHoaDonNangCaoInput` (`DanhSachHoaDonInput` already had it).
3. **Frontend** (`hoadon.component.ts`): both `xuatExcel()` and `xuatExcelNangcao()` now set `input.isPos = this.loaiHoaDonIsPos` (the same value the main search already sends), so exports respect whichever screen (thường vs MTT) the user is viewing.
4. **Proxy** (`service-proxies.ts`): added `isPos` field to `DanhSachHoaDonNangCaoInput` (class/interface/init/toJSON) — manual patch, NSwag regen not available.
5. **Worker** (`svinvoicesendemail/AppServiceExportBillHost`, >200-row queue path): added `IsPos` to both `DanhSachHoaDonInput` and `DanhSachHoaDonNangCaoInput` worker DTOs, and `EXISTS`/`NOT EXISTS` subquery conditions (`vs_hd_thongbao_hdmau` joined by `mau_hdmau_id`) to all 4 worker query methods, mirroring `FilterByIsPos`'s semantics exactly (default/non-1 → exclude MTT).

Verified by `dotnet build` on both `HDDT.Application.csproj` and the worker's `AppService.csproj` (both succeeded, 0 errors). Not yet verified end-to-end (no running app/queue in this session).

## Rollback

- Revert the `WhereIf` branch additions in both `HoaDonAppService.cs` and `ChungTuKhauTruThueAppService.cs`.
- Revert the two new dropdown options and badge template branches in both `.html`/`.ts` files.
- Revert the `FilterByIsPos` helper and its call sites in `HoaDonAppService.cs`, the `IsPos` field on `DanhSachHoaDonNangCaoInput`, the frontend `input.isPos` assignments, and the proxy field patch.
- Revert the worker (`svinvoicesendemail/AppServiceExportBillHost`) DTO field additions and SQL condition additions in `HD_HoaDonRepository.cs` (tab-filter fix, `Filter.*` parity fields, `NguoiMua` typo fix is in `invoicecore` only, `IsPos` EXISTS/NOT EXISTS conditions).
- No data rollback needed since no data is written by this feature.

## Latest Implementation Update — 2026-07-15

The background export worker was updated again in `svinvoicesendemail/AppServiceExportBillHost/AppService/Repositories/HD_HoaDonRepository.cs`:

- Plain export and all three advanced export methods now select at most one `vs_hd_tonghop_morong` row per invoice by joining a derived table grouped by `tonghop_id` and selecting `MAX(id)`.
- Detail export may still return multiple rows per invoice because `vs_hd_chitiet` rows are intentionally exported; tax-rate export may still return multiple rows per invoice because `vs_hd_thuesuat` rows are intentionally exported.
- A tenant predicate was added to invoice rows, and POS template subqueries now require `IsDeleted = 0` and matching `TenantId`.
- Advanced worker queries now parenthesize invoice-type 6/7 predicates to prevent SQL `AND`/`OR` precedence from bypassing preceding filters.

Verification after this update: worker `AppService.csproj` built successfully with 0 errors using a temporary output directory because the normal `AppService.dll` was locked by another process. Live queue/database execution remains unverified.
