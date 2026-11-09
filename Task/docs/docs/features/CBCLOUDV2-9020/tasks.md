# CBCLOUDV2-9020 Tasks

## Scope

- [x] Read Cloud reference tasks `CBCLOUDV2-8919` and `CBCLOUDV2-9181`.
- [x] Review MSP FE checkbox "Hoa don chiet khau thuong mai" on GTGT and GTTT invoice forms.
- [x] Confirm persisted field for checkbox state is `quanLy_XacThuc_Loai`.
- [x] Keep existing checkbox visibility for GTGT/GTTT invoice types `1`, `3`, and `5`.
- [x] Skip forms that did not already have CKTM checkbox in MSP.
- [x] For new adjustment/replacement invoices, inherit CKTM state from `hoaDonGoc.quanLy_XacThuc_Loai`.
- [x] For edit adjustment/replacement invoices, keep saved current invoice value and do not overwrite from original invoice.

## Files Changed

- [x] `D:\XBill\MSP\fe-app-msp\src\app\hddt\hoadon\quanlyhoadon\hoadon-goc.component.ts`
- [x] `D:\XBill\MSP\fe-app-msp\src\app\hddt\hoadon\hoadonbanhang\hoadonbanhang.component.ts`

## Validation

- [x] Static review with `rg`.
- [ ] Frontend build blocked by current Node/node-sass toolchain.
- [ ] Manual check create adjustment invoice from original invoice with CKTM checked.
- [ ] Manual check create replacement invoice from original invoice with CKTM checked.
- [ ] Manual check edit saved adjustment/replacement invoice with CKTM unchecked.
