# CBCLOUDV2-9016 Impact

## Additional Impact: Dinh kem bang ke

| Layer | File / Component | Impact level | Note |
| --- | --- | --- | --- |
| Frontend | `src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.html` | Low | Adds explicit checkbox change/click handlers. |
| Frontend | `src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts` | Medium | Clears bang ke fields when unchecked and prepares payload before save/sign/submit. |
| Frontend | `src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html` | Low | Adds explicit checkbox change/click handlers for `/app/hddt/hoadon-hoadonbanhang-goc`. |
| Frontend | `src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts` | Medium | Clears bang ke fields when unchecked and prepares payload before save/trinh ky/ky. |
| Frontend | `src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts` | Medium | Prevents adjustment/replacement create mapping from copying bang ke data from `hoaDonGoc` after user cleared it. |
| Backend | `aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs` | Medium | `Update()` and `UpdateDataInv()` persist null/empty bang ke fields when `File_BangKe_Sua == true`. |
| Database | Existing invoice extended fields | Low | No schema change; current payload clears fields. |

## Risk

- If FE does not set `file_BangKe_Sua = true` when the user clears bang ke, adjustment/replacement create can still preserve original bang ke data by design.
- Checked state still depends on persisted `soBangKe` and `ngayBangKe`.
- Screens that have their own copy of the bang ke checkbox must apply the same handler/prepare pattern; fixing one component does not automatically fix all invoice screens.
