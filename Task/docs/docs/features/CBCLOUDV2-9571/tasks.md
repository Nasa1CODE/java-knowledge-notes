---
feature: CBCLOUDV2-9571
updated_at: 2026-09-14
---

# Tasks - CBCLOUDV2-9571

## Tong quan

| # | Task | Service | Status | Uoc luong | Commit/PR |
|---|---|---|---|---|---|
| 1 | Ra soat validation nguoi mua cua hang hoa dac trung 1 | api-cloud-service | completed | S | Chua co |
| 2 | Bat buoc Ten don vi va MST/CCCD chu ho | api-cloud-service | completed | S | Chua co |
| 3 | Bao dam CCCD nguoi mua khong bat buoc | api-cloud-service | completed | S | Chua co |
| 4 | Bo sung unit test ba luong hoa don | api-cloud-service | completed | S | Chua co |
| 5 | Kiem thu API va XML | api-cloud-service | pending | S | Chua co |
| 6 | Cap nhat tai lieu task | docs | completed | S | Chua co |
| 7 | Ghi tai lieu ket qua response API | docs | completed | S | Chua co |

## Ket qua ra soat ban dau

- Shared validator hien da kiem tra rong `dnmua_ten` va `dnmua_mst` khi co chi tiet `loaihoadondactrung = 1`.
- CCCD nguoi mua khong duoc truyen vao shared validator, do do source API hien tai khong bat buoc CCCD tai nhanh nay.
- Can chuan hoa message theo nghiep vu moi, kiem tra tat ca luong goi va bo sung test de ngan hoi quy.

## Ket qua thuc hien

- Da chuan hoa required/max-length message cho Ten don vi va MST/CCCD chu ho.
- Khong them required cho CCCD; giu kiem tra toi da 12 ky tu khi co gia tri.
- Giu nguyen toan bo logic `ACTIVE_ND_254` hien tai.
- Unit test pass 12/12; build rieng Core, Application va EntityFrameworkCore deu pass, 0 error.
- Da bo sung `api-response.md`, doi chieu response code cua direct API, XML, HSM, Token va MTT voi source hien tai.
