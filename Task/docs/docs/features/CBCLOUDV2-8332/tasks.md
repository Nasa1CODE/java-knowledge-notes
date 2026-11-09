# CBCLOUDV2-8332 Tasks

## Task 1 - FE Discount Edit Calculation

- [x] Apply FE discount-row edit rule to all rows with `HangHoa_Loai = 3` on Cloud `hoadon-goc` edit screen.
- [x] FE: discount rows reduce left-side taxable amount and tax amount instead of being normalized to positive values.
- [x] FE: if discount detail tax is positive, tax summary treats it as a reduction; if already negative, it keeps the negative sign and does not subtract twice.
- [x] FE: imported invoices (`mau_HinhThucNhap == 1`) preserve right-side imported `TongHop_*` totals only when the user edits the left tax-summary table.
- [x] FE: detail-row edits still recalculate right-side totals normally.
- [x] FE: only left tax-summary handlers were changed to preserve mode: `tongTien_ChiuThue`, summary `dieuChinh_TangGiam`, summary `tongTien_Thue`.
- [x] Docs: impact/testcase/report updated for FE edit-only discount fix.
- [ ] Tester: regression old invoices with legacy discount mapping (`KhuyenMai = true`, `HangHoa_Loai = 0`) remains required.
- [ ] Tester: regression special invoice types that reuse `hoadon.service.ts` remains required.
## Cross-reference update 2026-07-30

- Related CLOUD regression from CBCLOUDV2-8393:
  - *_11: right-side TongHop_TienThue edit must update payment total and words without rebuilding dsThueSuat.
  - *_14: right-side TongHop_TongTien_ChuaVAT edit remains covered by suaTongThanhTien regression.
- This update is FE edit behavior only; backend import fallback remains tracked in CBCLOUDV2-8393.

## Update 2026-08-03 - Import Discount FE Coverage

- [x] Docs: bổ sung rõ scope hóa đơn import có dòng chiết khấu trước khi fix tương tự ở service khác.
- [x] FE: imported invoices with discount rows apply the same sign rule in left `dsThueSuat`: positive discount amount/tax reduces summary, already negative amount/tax is not subtracted twice.
- [x] FE: left tax-summary edits preserve imported right-side `TongHop_*` totals.
- [x] FE: detail-row edits still recalculate right-side totals normally.
- [ ] Tester: save and reopen imported invoice with discount row to verify FE payload does not normalize the discount sign or overwrite preserved `TongHop_*` totals.
- [ ] Tester: regression legacy import discount mapping (`KhuyenMai = true`, `HangHoa_Loai = 0`).
