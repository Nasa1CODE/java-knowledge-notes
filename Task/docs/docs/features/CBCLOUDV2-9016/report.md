# CBCLOUDV2-9016 Report

## Summary

Fixed `Dinh kem bang ke` on invoice create/edit screens so unchecking the box clears bang ke data and the state persists after reopen.

## Root Cause

The checkbox only changed the UI boolean. Old `soBangKe` / `ngayBangKe` / file data stayed in the main invoice model, so edit reload could set the checkbox back to checked.

For adjustment/replacement create flows, `hoadon.service.ts` also copied bang ke data from `hoaDonGoc.hD_HoaDon_MoRong` back into `hd.hD_HoaDon_MoRong`. That made the payload still contain bang ke values even after the UI clear ran.

The concrete failing route later traced by DEV was `hoadon-hoadonbanhang-goc?loaiHoaDon=5&hdMauId=1000002854&hdGocId=2000365358&mausoHD=2`, which uses `hoadonbanhang.component.*`, not only `hoadon-goc.component.*`.

Adjustment route:

1. Component reads query params `loaiHoaDon=5`, `hdGocId`.
2. Component calls `hoaDonService.getHoaDonGoc(...)`.
3. Service calls `getHoaDonBiDieuChinh(hdGocId)` for `mau_HoaDon_Loai == 5`.
4. Service maps original invoice extended fields from `hoaDonGoc.hD_HoaDon_MoRong` into `hd.hD_HoaDon_MoRong`.
5. Component sets `dinhKemBangKe = true` when `soBangKe` or `ngayBangKe` exists.
6. Save/trinh ky/ky sends `this.hoaDon` to `createOrEditInv`.

## Fix

- Added FE handlers to clear bang ke fields when unchecked and set `file_BangKe_Sua = true`.
- Kept `hoaDonGoc` data unchanged, and guarded the copy-from-original-invoice mapping so it only runs when `file_BangKe_Sua !== true`.
- Reused the same preparation before save/sign/submit flows.
- Applied the same checkbox clear behavior to `hoadonbanhang.component.*`, which owns `/app/hddt/hoadon-hoadonbanhang-goc`.
- BE update paths now honor `File_BangKe_Sua == true`:
  - `Update()` for invoices with 150 or fewer detail lines.
  - `UpdateDataInv()` for invoices with more than 150 detail lines.

## Reuse Pattern For Other Invoice Screens

When another invoice screen has `Dinh kem bang ke`, use the same narrow pattern:

1. Checkbox change handler sets the UI boolean and calls clear when unchecked.
2. Arrow/collapse toggle must call the same handler, not only flip the boolean.
3. Clear only the active invoice object, not `hoaDonGoc`:
   - `soBangKe = null`
   - `ngayBangKe = null`
   - `file_BangKe = ''`
   - `file_BangKe_Data = ''`
   - `file_BangKe_Sua = true`
4. Before save/trinh ky/ky, call a prepare method. If checkbox is false, clear again before submit.
5. Keep copy-from-original logic guarded by `file_BangKe_Sua !== true` so unchanged flows still preserve original bang ke.
6. BE should update the three bang ke fields when `File_BangKe_Sua == true`, even when values are null/empty.

## Notes

Frontend build and manual regression were not run in this session.
