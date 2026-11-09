---
feature: CBCLOUDV2-9571
updated_at: 2026-09-14
---

# Impact - CBCLOUDV2-9571

## Pham vi anh huong

| Thanh phan | Muc | Anh huong |
|---|---|---|
| `GuiHoaDonAppService` | Trung binh | Shared validation duoc dung boi hoa don goc, thay the va dieu chinh |
| Wrapper HSM/Token/MTT/XML | Thap | Ke thua ket qua validation, khong them logic rieng |
| XML nguoi mua | Thap | Khong doi mapping; chi thay dieu kien request duoc chap nhan |
| Database | Khong | Khong doi bang, cot hoac du lieu lich su |
| Redis/cau hinh | Khong | Giu nguyen checker, fallback va dieu kien `ACTIVE_ND_254` |

## Tuong thich nguoc

- Khi gate hien tai bat, payload hang hoa dac trung 1 thieu `dnmua_ten` hoac `dnmua_mst` se bi tu choi voi message nghiep vu moi.
- Payload thieu CCCD se duoc chap nhan neu cac field bat buoc khac hop le.
- Payload khong co hang hoa dac trung loai 1 khong bi anh huong.
- Khi `ACTIVE_ND_254` tat, hanh vi validation giu nguyen nhu truoc task.
- CCCD da luu va XML da ky khong bi xoa hay sua.

## Rui ro

- Co the con validation CCCD duplicate ngoai shared helper; can tim tren toan service va test tung entry API.
- Message validation thay doi co the anh huong client dang so khop nguyen chuoi; can regression response API.
- Neu mot wrapper bo qua shared validator, rule co the khong dong nhat; can kiem tra call chain thay vi sua duplicate.
