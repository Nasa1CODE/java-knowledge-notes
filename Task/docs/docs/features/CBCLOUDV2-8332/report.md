# CBCLOUDV2-8332 Report

## Changed

- Frontend Cloud updated in `D:\XBill\Cloud\frontend_angular` only.
- `hoadon.service.ts` có helper preserve tổng import và preserve mode cho flow sửa summary.
- `hoadon-goc.component.html` chỉ gọi preserve mode cho các field bảng thuế bên trái.
- Dòng chiết khấu (`HangHoa_Loai = 3`) đóng góp giá trị âm vào left tax summary và totals khi FE edit.
- Sửa detail vẫn tính lại tổng bên phải bình thường.

## Verification

- `git diff --check` cho các file FE đã sửa: passed.
- Không chạy frontend build/package theo chỉ đạo.

## Out Of Scope

- Không sửa backend/import/API/DB/XML/ký số/báo cáo trong task này.
- Không backfill hóa đơn cũ.
## Cross-reference update 2026-07-30

- Related CLOUD regression from CBCLOUDV2-8393:
  - *_11: right-side TongHop_TienThue edit must update payment total and words without rebuilding dsThueSuat.
  - *_14: right-side TongHop_TongTien_ChuaVAT edit remains covered by suaTongThanhTien regression.
- This update is FE edit behavior only; backend import fallback remains tracked in CBCLOUDV2-8393.

## Update 2026-08-03 - Import Discount FE Documentation

- Rechecked docs against FE fix scope before syncing similar behavior to other services.
- Added explicit import-discount coverage: `mau_HinhThucNhap == 1` with `HangHoa_Loai = 3` uses negative contribution in left `dsThueSuat`.
- Positive discount amount/tax is treated as reduction; already-negative discount amount/tax is preserved and not subtracted twice.
- Left tax-summary edits preserve imported right-side `TongHop_*`; detail-row edits still recalculate right-side totals.
- Manual save/open verification remains required to confirm FE payload does not overwrite imported totals or normalize discount signs incorrectly.
