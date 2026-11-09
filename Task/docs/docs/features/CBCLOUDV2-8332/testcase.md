# CBCLOUDV2-8332 Test Cases

| Case | Expected | Actual | Status |
| --- | --- | --- | --- |
| Edit normal invoice: product 500.000 VAT 10%, discount 200.000 VAT 5% | Left summary shows 10% `500.000 / 50.000`, 5% `-200.000 / -10.000`; right totals `300.000 / 40.000 / 340.000` | Checked by screenshot review | passed |
| Edit invoice with one discount row and three product rows, same VAT 10%, CKTM 100 | Totals: taxable `19.900`, tax `1.990`, total CKTM `10.100`, payable `21.890` | Checked by screenshot review | passed |
| Edit invoice with discount VAT 8% and product VAT 10% | Left summary keeps discount group negative and product group positive; payable equals taxable + tax | Checked by screenshot review | passed |
| Imported invoice: edit left tax summary | Right-side imported `TongHop_*` totals are not overwritten | Needs tester verification | not run |
| Imported invoice: edit detail quantity/unit price/amount/tax | Right-side totals recalculate normally | Needs tester verification | not run |
| Invoice without discount rows | Existing behavior remains unchanged | Needs tester regression | not run |
| Adjustment invoice `mau_HoaDon_Loai == 5` | Existing adjustment sign behavior remains unchanged | Needs tester regression | not run |
| MTT/VE_XE/NUOC/DIEN/custom rounding | No unexpected total regression | Needs tester regression | not run |
## Cross-reference update 2026-07-30

- Related CLOUD regression from CBCLOUDV2-8393:
  - *_11: right-side TongHop_TienThue edit must update payment total and words without rebuilding dsThueSuat.
  - *_14: right-side TongHop_TongTien_ChuaVAT edit remains covered by suaTongThanhTien regression.
- This update is FE edit behavior only; backend import fallback remains tracked in CBCLOUDV2-8393.

## Update 2026-08-03 - Import Discount FE Cases

| Case | Expected | Actual | Status |
| --- | --- | --- | --- |
| Imported invoice with discount amount/tax positive | Left `dsThueSuat` treats discount amount/tax as negative contribution; right `TongHop_*` totals remain imported values until detail-row edit | Needs tester verification | not run |
| Imported invoice with discount amount/tax already negative | Left `dsThueSuat` keeps the negative sign and does not subtract twice; right `TongHop_*` totals remain imported values until detail-row edit | Needs tester verification | not run |
| Imported invoice with discount: edit left tax summary | Left summary changes; right `TongHop_*` totals are not overwritten from `dsThueSuat` | Needs tester verification | not run |
| Imported invoice with discount: edit detail quantity/unit price/amount/tax | Right-side totals recalculate from current UI detail data | Needs tester verification | not run |
| Imported invoice with discount: save and reopen | Saved payload keeps discount sign and preserved `TongHop_*` totals; reopening invoice shows same left summary/right totals | Needs tester verification | not run |
| Legacy import discount mapping (`KhuyenMai = true`, `HangHoa_Loai = 0`) | Existing behavior remains unchanged unless separately migrated to `HangHoa_Loai = 3` | Needs tester regression | not run |
