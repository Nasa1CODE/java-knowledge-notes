# CBCLOUDV2-8736 Plan

## Muc tieu

Implement scoped 406 total calculation cho `/app/hddt/hoadon-hoadonbanhang-goc` ma khong thay doi caller khac cua shared service.

## Implementation approach

1. Inventory every caller cua `tinhChiTietThue_406()` va `tinhTongChi_406()` truoc code change; record actual line, component/route, va old arguments trong `docs/features/CBCLOUDV2-8736/report.md`. Candidate references can xac minh khi trien khai: template selector around 550; detail bindings around 1170, 1475, 1484; TypeScript calls around 707, 938; indirect service call `tinhThanhTienCoThue_406` -> `tinhChiTietThue_406` around 3542-3558.
2. Add `apDungTongTienBanHang406: boolean = false`, propagate it through all target invocations, and pass true only from `HoaDonBanHangComponent` target route. All other callers retain old arguments/default false.
3. In `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts`, implement exact grouped and ungrouped equations in `expect.md`; keep promotion exclusion, current tax result, signed legacy contribution, existing fallback, and existing final-field rounding.
4. In `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html`, apply disabled/right-aligned controls, remove CKTM change handler, right-align payment text, retain two required tooltip texts, and set payment tooltip semantic text to `Tong tien thanh toan bang tong tien hang cong tong tien thue` with Vietnamese source rendering.

## Verification

- Run `yarn.cmd run build` in `D:\Source\billcloud\frontend_angular`.
- Execute self-contained DTO fixtures in `testcase.md`, including mixed and each invalid VAT rate, signed, rounding, negative payment, promotion exclusion, fallback, and route UI.
- Focused Jasmine/Karma test hoac direct service harness phai khoi tao `HoaDonService` voi `cauHinhDN` rounding configuration va dependencies `dsTienTe`/`dsThueSuat`, sau signature extension moi goi `tinhChiTietThue_406(hoaDon, true)` va assert model outputs. Browser form tests la test rieng.
- Record caller inventory, tenant rounding config, actual output, route QA, persisted save behavior, and unverified items in `report.md`. Other-screen scope remains pending until this evidence exists.

## Risks

| Risk | Mitigation |
| --- | --- |
| Shared caller gets true incorrectly | Inventory before change; default false; route QA. |
| Invalid rate amount disappears | Explicit ungrouped signed equation and four invalid-rate fixtures. |
| Double discount/sign error | Exact equations, signed fixture, no `Math.abs`. |
| Different tenant rounding | Existing policy only; log config/output. |

## Impact

No API/DTO/schema/contract change. Persisted client-calculated invoice values can change. Backend and other screens remain pending verification.
