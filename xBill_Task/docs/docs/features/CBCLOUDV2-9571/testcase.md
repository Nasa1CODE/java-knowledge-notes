---
feature: CBCLOUDV2-9571
updated_at: 2026-09-14
---

# Testcase - CBCLOUDV2-9571

TC-01 den TC-07 va TC-10 den TC-13 chay voi `ACTIVE_ND_254 = "1"`; task khong thay doi cach doc hoac danh gia co nay.

| ID | Du lieu / thao tac | Ket qua mong doi | Loai |
|---|---|---|---|
| TC-01 | Subtype 1, `dnmua_ten = null` | Bao `Ten don vi khong duoc de trong.` | auto |
| TC-02 | Subtype 1, `dnmua_ten` toan khoang trang | Bao loi nhu TC-01 | auto |
| TC-03 | Subtype 1, `dnmua_mst = null` | Bao `MST/CCCD chu ho khong duoc de trong.` | auto |
| TC-04 | Subtype 1, `dnmua_mst` toan khoang trang | Bao loi nhu TC-03 | auto |
| TC-05 | Subtype 1, Ten va MST hop le, CCCD null/khong gui | API thanh cong, khong bao thieu CCCD | auto + manual |
| TC-06 | Subtype 1, CCCD co gia tri | API thanh cong, DB giu gia tri va XML co `<CCCDan>` | manual |
| TC-07 | Subtype 1, CCCD rong | XML khong co `<CCCDan>` rong | auto + manual |
| TC-08 | Khong co subtype 1, Ten/MST rong | Khong phat sinh hai required cua task nay | auto |
| TC-09 | Subtype 2 hoac 3 | Khong ap dung rule subtype 1 | auto |
| TC-10 | Hoa don goc/thay the/dieu chinh cung payload thieu Ten | Ca ba tra cung rule validation | auto |
| TC-11 | Hoa don goc/thay the/dieu chinh cung payload thieu MST | Ca ba tra cung rule validation | auto |
| TC-12 | Wrapper HSM/Token/MTT/XML | Ke thua dung validation, khong bat buoc CCCD | manual |
| TC-13 | Ten va MST hop le | XML co `<Ten>` va `<MST>` dung gia tri | manual |
| TC-14 | Payload cu khong co subtype 1 | Hanh vi validation giu nguyen | regression |
| TC-15 | `ACTIVE_ND_254` tat, payload thieu Ten/MST | Hanh vi gate va validation giu nguyen nhu truoc task | auto |
