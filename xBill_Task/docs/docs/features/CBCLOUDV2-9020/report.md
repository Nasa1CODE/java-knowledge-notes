# CBCLOUDV2-9020 Report

## Result

- MSP FE has been aligned with Cloud CKTM behavior from `CBCLOUDV2-8919` and `CBCLOUDV2-9181` only for forms that already had the CKTM checkbox in MSP.
- GTGT/GTTT now set checkbox state from the current invoice after load, so editing an unchecked adjustment/replacement invoice stays unchecked.
- Ve may bay was left unchanged because MSP did not already have this checkbox.

## Notes

- `hoadon.service.ts` already copied `hoaDonGoc.quanLy_XacThuc_Loai` for new adjustment/replacement invoices.
- No BE change was needed for CKTM because the field is already part of the invoice DTO/save payload.

## Verification

- Static search/diff completed.
- `npm run build` failed on Node/OpenSSL with current Node runtime.
- Re-run with `NODE_OPTIONS=--openssl-legacy-provider` reached Angular build pipeline but failed because `node-sass@4.14.1` does not support current Node runtime 127.
- Manual browser QA pending.
