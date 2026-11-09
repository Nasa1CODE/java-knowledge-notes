# CBCLOUDV2-9016 Test Cases

| Case | Expected | Status |
| --- | --- | --- |
| User unchecks `Dinh kem bang ke` and saves | Reopen edit shows unchecked; bang ke fields are cleared | not run |
| User keeps `Dinh kem bang ke` checked without `soBangKe` or `ngayBangKe` | Validation blocks save/sign | not run |
| User checks `Dinh kem bang ke` and fills required fields | Save/sign works normally | not run |
| `/app/hddt/hoadon-hoadonbanhang-goc?loaiHoaDon=5...`: user unchecks bang ke then saves | `createOrEditInv` payload has `file_BangKe_Sua = true`, `soBangKe = null`, `ngayBangKe = null`, `file_BangKe = ''`, `file_BangKe_Data = ''` | not run |
| `/app/hddt/hoadon-hoadonbanhang-goc?loaiHoaDon=5...`: user does not change bang ke then saves | Original bang ke data remains in payload and DB | not run |
| Existing invoice with 150 or fewer detail lines, user clears bang ke in edit | BE `Update()` persists null/empty bang ke fields | not run |
| Existing invoice with more than 150 detail lines, user clears bang ke in edit | BE `UpdateDataInv()` persists null/empty bang ke fields | not run |
| User selects/uploads a new bang ke file | Upload logic still stores the new file path | not run |
