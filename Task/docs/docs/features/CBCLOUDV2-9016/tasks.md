# CBCLOUDV2-9016 Tasks

## Scope

- [x] Review `Dinh kem bang ke` behavior on `hoadon-goc`.
- [x] Trace the actual failing route `/app/hddt/hoadon-hoadonbanhang-goc?loaiHoaDon=5...`.
- [x] Review `Dinh kem bang ke` behavior on `hoadonbanhang`.
- [x] Fix unchecked state so attached bang ke fields are cleared before save.
- [x] Guard adjustment/replacement mapping so original bang ke is copied only when user did not change bang ke.
- [x] Reuse the same preparation for save/sign/submit flows.
- [x] Update BE update paths for both small and large invoice detail counts.
- [x] Update docs for impact and test cases.

## Files Changed

- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\quanlyhoadon\hoadon-goc.component.html`
- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\quanlyhoadon\hoadon-goc.component.ts`
- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\hoadonbanhang\hoadonbanhang.component.html`
- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\hoadonbanhang\hoadonbanhang.component.ts`
- [x] `D:\XBill\Cloud\frontend_angular\src\app\hddt\hoadon\quanlyhoadon\hoadon.service.ts`
- [x] `D:\XBill\Cloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\AppServices\HoaDon\HoaDonAppService.cs`

## Validation

- [ ] Frontend build.
- [ ] Manual check `hddt/hoadon-hoadon-goc?id=2000365338`.
- [ ] Manual check `/app/hddt/hoadon-hoadonbanhang-goc?loaiHoaDon=5&hdMauId=1000002854&hdGocId=2000365358&mausoHD=2`.
