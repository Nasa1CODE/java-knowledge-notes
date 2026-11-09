# CBCLOUDV2-9021 Plan

1. Use Cloud task `CBCLOUDV2-9016` as the reference.
2. Verify MSP FE clears bang ke fields when the user unchecks "Dinh kem bang ke":
   - `soBangKe = null`
   - `ngayBangKe = null`
   - `file_BangKe = ''`
   - `file_BangKe_Data = ''`
   - `file_BangKe_Sua = true`
3. Verify `prepareDinhKemBangKe()` is used before save/sign/submit flows.
4. Verify `hoadon.service.ts` only copies original bang ke fields when `file_BangKe_Sua !== true`.
5. Verify BE update path accepts `File_BangKe_Sua == true` and writes cleared values.
6. Make no code changes if MSP already contains the Cloud behavior.
