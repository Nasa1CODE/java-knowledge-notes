# Vehicle Location Buyer Address Design

## Scope

Move the province and ward selectors from the per-line vehicle panel to the buyer-information form, directly after the buyer address field. The values remain invoice-header fields: `hoaDon.hD_HoaDon_MoRong.ma_Tinh` and `ma_Xa`.

## UI Behavior

The two selectors use the existing Bootstrap selectpicker convention used by the currency selector, including live search. They are visible only when the invoice contains a special-goods vehicle line: `hangHoa_Loai == 4`, a non-null extended detail, and `loai_HangHoa_DacTrung == 1`.

Selecting a province clears the selected ward and loads wards for that province. The existing header-level validation remains unchanged: it blocks save/sign only when a vehicle line exists and either province or ward is missing. The original-invoice vehicle panel continues to display the resolved province and ward names.

## Implementation Boundaries

Only `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts` and `.html` change. Generated proxy contracts, backend APIs, database schema, and existing cascade helpers are not changed.

## Verification

Confirm the two inputs are removed from the editable vehicle panel and inserted immediately after the buyer address field. Run the Angular build using `NODE_OPTIONS=--openssl-legacy-provider` for the legacy Webpack toolchain.
