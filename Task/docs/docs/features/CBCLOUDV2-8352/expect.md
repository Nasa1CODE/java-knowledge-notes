# CBCLOUDV2-8352 Expect

## Feature Status

- Status: draft
- Class: Medium
- Source document: `[All] Danh sách hóa đơn, chức năng Filter tại Trạng thái cập nhật lại bổ sung trang thái TCT chấp nhận đã gửi email và TCT chấp nhận chưa gửi email-v8-20260708_105509.docx` (Epic `CBCLOUDV2-7217`, doc version 2.0, "in review")

## Business Goal

Split the current single "CQT chấp nhận" (`QuanLy_TrangThai = 8`) status into two detail statuses based on email-send state, so users can search, filter, export, and report invoices/documents by whether the tax-authority-accepted item has already been emailed:

- CQT chấp nhận đã gửi email.
- CQT chấp nhận chưa gửi email.

## Scope (per source document)

- Danh sách hóa đơn (thường và máy tính tiền / MTT).
- Danh sách chứng từ khấu trừ thuế.
- Bộ lọc trạng thái (Trạng thái dropdown/listbox) trên các màn trên.
- Xuất Excel, xuất Excel nâng cao.

## Expected Behavior

### Danh sách hóa đơn (`vs_hd_tonghop`, entity `HD_HoaDon`, field `QuanLy_GuiEmail` / `quanly_guiemail`)

- Trạng thái dropdown gets two new options in addition to existing ones:
  - `CQT chấp nhận và đã gửi mail`: `QuanLy_TrangThai == 8 (TCTDaChapNhan)` AND `QuanLy_GuiEmail != 0` (not null and not 0).
  - `CQT chấp nhận và chưa gửi mail`: `QuanLy_TrangThai == 8 (TCTDaChapNhan)` AND (`QuanLy_GuiEmail == 0` OR `QuanLy_GuiEmail IS NULL`).
- The existing plain "CQT đã chấp nhận" option (value `8`) is documented as to be removed/replaced by the two new options ("bỏ trạng thái" per source doc), but see Open Questions below before removing it.
- Behavior must be consistent across:
  - Main search/filter (`hoadon.component.ts` `loaiTrangThaiList` + backend `GetDataFilterTable_New`/`GetDataFilterTable` in `HoaDonAppService.cs`, field `input.Filter.TrangThai_HoaDon`).
  - `XuatExcel` (uses the same filter methods as the main search).
  - `XuatExcelNangCao` (`DanhSachHoaDonNangCaoInput.trangThai`, separate filter block in `HoaDonAppService.XuatExcelNangCao`).

### Danh sách hóa đơn máy tính tiền (HD MTT / POS)

- Source document scope includes "Danh sách hóa đơn (thường và máy tính tiền)" and the data-flow condition explicitly references `vs_hd_tonghop`.
- Actual source: `Mau_HoaDon_Loai == 6 || Mau_HoaDon_Loai == 7` rows for MTT invoices live inside `HD_HoaDon`/`vs_hd_tonghop`, the same table as regular invoices — there is a separate `HD_Pos`/`vs_hdpos` entity but it has no `QuanLy_GuiEmail`-equivalent column and is a summary/batch table, not the per-invoice status source.
- Decision: "Danh sách hóa đơn máy tính tiền" in scope means `HD_HoaDon` rows with `Mau_HoaDon_Loai` 6/7, filtered through the same `QuanLy_TrangThai`/`QuanLy_GuiEmail` condition as regular invoices. Apply the same two-status split to any invoice search screen filtering `Mau_HoaDon_Loai` for MTT.
- Out of scope: the separate `vs_hdpos` batch-status combobox (`quanlyhdpos.component.html`, values 0-9, `HDPosTrangThai` enum). This represents its own transmission-batch status (a batch/group of invoices sent together), not an individual invoice's CQT-accepted/email state, and has no `QuanLy_GuiEmail`-equivalent column — it is not touched by this ticket.

### Danh sách chứng từ khấu trừ thuế (`vs_chungtu_khautru`, entity `ChungTu_KhauTru`, field `QuanLy_GuiEmail` / `quanly_guiemail`)

- Trạng thái dropdown (`dschungtukhautruthue.component.html`, `filters.trangthai`) gets two new options:
  - `CQT chấp nhận và đã gửi mail`: `Ct_TrangThai == 8 (tctdachapnhan)` AND `QuanLy_GuiEmail != 0` (not null and not 0).
  - `CQT chấp nhận và chưa gửi mail`: `Ct_TrangThai == 8 (tctdachapnhan)` AND (`QuanLy_GuiEmail == 0` OR `QuanLy_GuiEmail IS NULL`).
- Per source document, the chứng từ dropdown also needs "Đã ký và đã gửi mail" / "Đã ký và chưa gửi mail" options (split of `Ct_TrangThai == 3`), mirroring the pattern invoices already have for trangThai values 2/3. This was requested in document version 2.0 (11 Jun 2026 history entry) and is included in scope for this ticket since the same dropdown/backend filter is being touched.
- Backend filter: `ChungTuKhauTruThueAppService.Filter(FilterChungTuInput)` and `ExportExcelCt(FilterChungTuInput)` both use `input.TrangThai != null, o => o.Ct_TrangThai == input.TrangThai` with no email split today — needs the same style of expansion applied to invoices.
- Note discrepancy in source doc: it states chứng từ "chưa gửi mail" condition as `quanly_guiemail = null` while hóa đơn's is `quanly_guiemail = 0`. Treat both `NULL` and `0` as "chưa gửi mail" for both entities unless BA confirms otherwise (see Open Questions).

## Out Of Scope

- Báo cáo hóa đơn (all report screens/AppServices, including `BaoCaoDoanhThuTheoSanPhamAppService`, `tinhhinhsudunghoadontheobenmua`, and any other screen filtering by `QuanLy_TrangThai == HoaDon_TrangThai.TCTDaChapNhan`). Not changed by this ticket; track as a separate ticket if needed.
- No database schema change; `quanly_guiemail` column already exists on both `vs_hd_tonghop` and `vs_chungtu_khautru`.
- No change to how/when `QuanLy_GuiEmail` is incremented (sending email logic itself is unchanged).
- `vs_hdpos` batch-status combobox/enum (`HD_Pos`, `HDPosTrangThai`) — this is a separate transmission-batch status with no `QuanLy_GuiEmail`-equivalent column, not touched by this ticket.
- No change to the underlying `QuanLy_TrangThai`/`Ct_TrangThai` value of `8` itself; the split is presentation/filter-level only (per "Chỉ thay đổi logic filter + hiển thị, Không thay đổi dữ liệu" in the source document's impact table).

## Open Questions (must be answered before Gate 1 approval)

1. **New dropdown value numbers**: what integer values should the frontend send for the two new options (hóa đơn and chứng từ), given existing values `0`-`10` are already used? Do these conflict with the existing `2`/`3` split pattern (Đã ký và đã/chưa gửi mail) already present for invoices?
2. **Removing plain "CQT đã chấp nhận" option**: source document says "(bỏ trạng thái)" for the old value `8` option — confirm whether to remove it entirely or keep it as an aggregate ("Tất cả CQT chấp nhận") alongside the two new detail options.
3. **Chứng từ "chưa gửi mail" condition**: confirm whether `quanly_guiemail IS NULL` and `quanly_guiemail = 0` should both count as "chưa gửi mail" for chứng từ (source doc states only `null`), and confirm the same for hóa đơn (source doc states `= 0`, existing code pattern for trangThai 2/3 uses `> 0` / `== 0`, not null-aware).
4. **Chứng từ "Đã ký và đã/chưa gửi mail" split**: confirm this is in scope for CBCLOUDV2-8352 (it was already requested in the source document's version 2.0 history) or should be tracked as a separate ticket.


## Acceptance Criteria

- Danh sách hóa đơn Trạng thái filter/search returns correct rows for both new detail statuses, without affecting any other existing status option's result set.
- Danh sách chứng từ khấu trừ thuế Trạng thái filter/search returns correct rows for both new detail statuses.
- `XuatExcel` and `XuatExcelNangCao` (Danh sách hóa đơn) produce Excel output consistent with the on-screen filtered result for the two new statuses.
- `ExportExcelCt` (Danh sách chứng từ) produces Excel output consistent with the on-screen filtered result for the two new statuses.
- No change to any other status's filter behavior or displayed label.
- Open Questions above are answered and reflected in `plan.md` before implementation starts.
