# CBCLOUDV2-8736 Design

## Goal

Update the invoice sales screen at `/app/hddt/hoadon-hoadonbanhang-goc` so its calculated totals follow the approved discount and resolution tax-rate formulas.

## Scope

- Application: `frontend_angular/`.
- Route: `/app/hddt/hoadon-hoadonbanhang-goc`.
- Component: `HoaDonBanHangComponent`.
- Central calculation service: `HoaDonService.tinhChiTietThue_406` and `HoaDonService.tinhTongChi_406`.
- No API, DTO, database, generated proxy, deployment, or configuration change.

## Calculation Rules

### Line Classification

- A discount product line is a line with `hangHoa_Loai == 3`.
- A goods/service line is a non-discount product line.
- Each line uses its `vat_Rate` as the tax rate on revenue when present.
- A discount product line stores a positive input amount and its calculated line amount is treated as a deduction. A manually entered negative amount must not be converted to a positive value by the total calculation.

### Total Goods Amount

When the invoice does not apply a resolution or no line has a positive `vat_Rate`, retain the existing calculation.

When `loaiHoaDon406 > 0` and at least one applicable line has `vat_Rate > 0`, group goods/service and discount lines by `vat_Rate`.

For each rate group:

```text
resolutionReduction = (goodsAmountForRate - discountAmountForRate) * vatRate * 20%
```

Missing goods/service or discount values for a rate group are zero. The result applies equally to one rate, a discount with the same rate, a discount with a different rate, and multiple rates.

```text
totalGoods = totalGoodsServiceAmount
            - sum(resolutionReduction for each rate)
            - totalDiscountLineAmount
            - commercialDiscountAmount
```

`totalGoods` is assigned to `hoaDon.tongHop_TienHang` after the existing rounding policy is applied.

### Commercial Discount Total

```text
commercialDiscountTotal = discountProductLineAmount
                          + perLineDiscountAmount
                          + commercialDiscountAmount
```

Assign this value to `hoaDon.tongHop_TongTien_ChietKhau_ThuongMai`. Store `null` when the computed total is zero.

### Payment Totals

```text
paymentTotal = totalGoods + totalTax
```

Assign this to `hoaDon.tongHop_TongTien_CoVAT`; it is not editable. `hoaDon.tongHop_TongTien_CoVAT_Chu` is recalculated from that value. For a negative value, the displayed text starts with `Am` (rendered as `Âm` by the existing Vietnamese money-reader output convention).

## UI Behavior

- `Tổng tiền hàng`, `Tổng tiền chiết khấu thương mại`, and `Tổng tiền thanh toán bằng số` are right-aligned and non-editable.
- Keep the approved tooltips:
  - `Tổng tiền hàng là tổng cộng thành tiền chưa có thuế giá trị gia tăng`.
  - `Tổng tiền chiết khấu thương mại là tổng tiền của các loại hàng hóa chiết khấu và tổng thành tiền chiết khấu cho từng hàng hóa/dịch vụ và chiết khấu thương mại`.
- `Tổng tiền thanh toán bằng chữ` is rendered from the calculated numeric payment total and cannot be edited.

## Data Flow

1. Editing a line, importing product lines, deleting a line, or changing the applied resolution calls `tinhChiTietThue_406`.
2. The method builds tax summaries and calls `tinhTongChi_406`.
3. `tinhTongChi_406` groups applicable lines by `vat_Rate`, calculates the approved totals, applies the current enterprise rounding policy, and calls `tinhTongTienBangChu`.
4. Bound screen fields update from the `hoaDon` model.

## Error Handling And Compatibility

- Treat absent numeric amounts and missing rate-side groups as zero; do not emit `NaN`.
- Preserve the current calculation path for invoices that do not meet the resolution condition.
- Preserve current line tax calculations and tax-summary behavior; this change only replaces the 406 total aggregation for the sales invoice flow.

## Verification

- Verify one-rate matching discount: goods `100000`, discount `10000`, rate `5` gives total goods `89100` before any additional commercial discount.
- Verify different-rate discount: goods `100000` at `5`, discount `10000` at `3` gives total goods `89060`.
- Verify multi-rate example: goods `100000` at `5`, discount `10000` at `3`, goods `50000` at `3` gives total goods `138760`.
- Verify no-resolution invoices retain their current total calculation.
- Verify calculated total fields cannot be edited and payment text begins with `Âm` for a negative payment total.
