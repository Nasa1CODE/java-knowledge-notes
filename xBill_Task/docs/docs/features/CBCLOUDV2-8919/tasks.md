# CBCLOUDV2-8919 Tasks

## Scope

- [x] Review FE checkbox "Hoa don chiet khau thuong mai" on invoice forms.
- [x] Confirm checkbox visibility condition for invoice types.
- [x] Confirm persisted field for checkbox state is `QuanLy_XacThuc_Loai` on `vs_hd_tonghop`.
- [x] Fix VE_MAYBAY checkbox visibility for invoice types `1`, `3`, and `5`.
- [x] Fix GTGT/hoadon-goc checkbox visibility for invoice types `1`, `3`, and `5`.
- [x] Fix GTTT/hoadonbanhang checkbox visibility for invoice types `1`, `3`, and `5`.
- [x] Map CKTM checkbox state from `hoaDonGoc.quanLy_XacThuc_Loai` into current invoice for replacement/adjustment forms.

## Files Changed

- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\vemaybay\vemaybay.component.html`
- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\vemaybay\vemaybay.component.ts`
- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\hoadonbanhang\hoadonbanhang.component.html`
- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\hoadonbanhang\hoadonbanhang.component.ts`
- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\quanlyhoadon\hoadon-goc.component.html`
- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\quanlyhoadon\hoadon-goc.component.ts`

## Validation

- [ ] Frontend build.
- [ ] Manual check VE_MAYBAY adjustment URL with `loaiHoaDon=5`.
- [ ] Manual check replacement invoice with `loaiHoaDon=3`.
- [ ] Manual check copy/new invoice with `loaiHoaDon=1`.
