# CBCLOUDV2-8736 Tasks

## Task 1 - Inventory callers

- Status: pending
- Area/service: `frontend_angular/`
- Description: Inventory every direct/indirect 406 caller before code change and record it in `report.md`.
- Acceptance criteria:
  - [ ] Capture no-resolution baseline before edits and record exact pre-change `tinhTongChi_406` result in `report.md`.
  - [ ] Verify candidate selector 550, detail bindings 1170/1475/1484, TypeScript 707/938, and service indirect 3542-3558; record actual current lines/arguments.
  - [ ] Only target `HoaDonBanHangComponent` invocations pass `apDungTongTienBanHang406=true`; every other caller keeps old behavior/default false.
- Verification: [ ] Search all TypeScript/template call sites and update `report.md`.
- Dependencies: None
- Likely touched files: `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts`, `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html`, `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts`, `docs/features/CBCLOUDV2-8736/report.md`
- Estimated scope: S

## Task 2 - Implement aggregate

- Status: pending
- Area/service: `frontend_angular/`
- Description: Implement context propagation, promotion exclusion, exact grouped/ungrouped equation, existing tax/fallback, and rounding.
- Acceptance criteria:
  - [ ] Positive finite rates group; null/NaN/0/-1 rates use explicit ungrouped signed contribution and are not dropped.
  - [ ] TH1-TH3, mixed invalid, four invalid, signed, rounding, negative, and promotion fixtures meet `testcase.md`.
  - [ ] Focused Jasmine/Karma or direct service harness initializes `cauHinhDN`, `dsTienTe`, and `dsThueSuat`, then calls planned `tinhChiTietThue_406(hoaDon, true)`.
- Verification: [ ] Execute source-level fixtures and record results.
- Dependencies: Task 1
- Likely touched files: `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts`, `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts`
- Estimated scope: S

## Task 3 - Update UI

- Status: pending
- Area/service: `frontend_angular/`
- Description: Make total controls readonly/right-aligned and correct tooltip behavior.
- Acceptance criteria:
  - [ ] Three numeric controls disabled/right-aligned; CKTM has no `inputModelChange`; payment text right-aligned.
  - [ ] Two required tooltip texts remain exact; payment tooltip says required semantic text.
- Verification: [ ] Route QA verifies controls and tooltips.
- Dependencies: Task 2
- Likely touched files: `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html`
- Estimated scope: XS

## Task 4 - Verify and report

- Status: pending
- Area/service: `frontend_angular/`, `docs/`
- Description: Build, QA, save verification, and evidence report.
- Acceptance criteria: [ ] Build/result/config/caller inventory/route QA/persisted values/not-run cases accurately recorded.
- Verification: [ ] `yarn.cmd run build`; execute `testcase.md`; update `report.md` and `impact.md`.
- Dependencies: Task 2, Task 3
- Likely touched files: `docs/features/CBCLOUDV2-8736/testcase.md`, `docs/features/CBCLOUDV2-8736/impact.md`, `docs/features/CBCLOUDV2-8736/report.md`
- Estimated scope: S
