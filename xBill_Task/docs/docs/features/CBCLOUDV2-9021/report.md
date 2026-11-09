# CBCLOUDV2-9021 Report

## Result

- MSP already contains the key FE/BE behavior from Cloud `CBCLOUDV2-9016`.
- FE components clear bang ke fields and set `file_BangKe_Sua = true` when unchecked.
- FE service guards original invoice bang ke mapping with `file_BangKe_Sua !== true`.
- BE `HoaDonAppService.Update` writes bang ke fields when `File_BangKe_Sua == true`.

## Notes

- Existing BE file has pre-existing local modifications; no BE patch was applied for this task.
- Manual QA is still needed to confirm database state after save.
- FE build is blocked by the current Node/node-sass toolchain, same as noted in `CBCLOUDV2-9020`.
