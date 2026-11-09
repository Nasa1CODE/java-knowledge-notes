# CBCLOUDV2-9021 Tasks

## Scope

- [x] Read Cloud reference task `CBCLOUDV2-9016`.
- [x] Review MSP FE "Dinh kem bang ke" behavior on GTGT and GTTT adjustment/replacement invoices.
- [x] Confirm unchecked state clears bang ke fields before save.
- [x] Confirm FE service does not copy original bang ke back when user changed/cleared bang ke.
- [x] Review MSP BE update handling for `File_BangKe_Sua`.
- [x] Avoid BE changes because existing MSP BE already handles `File_BangKe_Sua == true`.

## Files Reviewed

- [x] `D:\XBill\MSP\fe-app-msp\src\app\hddt\hoadon\quanlyhoadon\hoadon-goc.component.ts`
- [x] `D:\XBill\MSP\fe-app-msp\src\app\hddt\hoadon\hoadonbanhang\hoadonbanhang.component.ts`
- [x] `D:\XBill\MSP\fe-app-msp\src\app\hddt\hoadon\quanlyhoadon\hoadon.service.ts`
- [x] `D:\XBill\MSP\backend-msp\src\hddt\HDDT.Application\AppServices\HoaDon\HoaDonAppService.cs`

## Validation

- [x] Static review with `rg`.
- [ ] Manual check create/edit adjustment invoice with bang ke unchecked.
- [ ] Manual check create/edit replacement invoice with bang ke unchecked.
- [ ] Backend build.
- [ ] Frontend/manual browser QA pending.
