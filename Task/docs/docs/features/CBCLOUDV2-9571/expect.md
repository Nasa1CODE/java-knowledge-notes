---
feature: CBCLOUDV2-9571
title: "Bo sung validate nguoi mua doi voi hang hoa dac trung 1"
status: implemented-awaiting-manual-test
services-affected: [api-cloud-service]
created_at: 2026-09-14
updated_at: 2026-09-14
---

# Expect - CBCLOUDV2-9571

## Boi canh

Can dieu chinh quy tac validation thong tin nguoi mua trong nhanh NĐ254 hien tai, khi `ACTIVE_ND_254 = "1"` va hoa don co it nhat mot chi tiet hang hoa dac trung loai 1. Ten don vi va MST/CCCD chu ho la du lieu bat buoc de sinh cac the XML `<Ten>` va `<MST>`; the `<CCCDan>` khong con la dieu kien bat buoc.

## Acceptance Criteria

- **AC1:** Khi gate NĐ254 hien tai bat va co chi tiet `loaihoadondactrung = 1`, `dnmua_ten` bat buoc co gia tri sau khi loai khoang trang; gia tri duoc map vao `<NMua><Ten>`.
- **AC2:** Khi gate NĐ254 hien tai bat va co chi tiet `loaihoadondactrung = 1`, `dnmua_mst` bat buoc co gia tri sau khi loai khoang trang; field nay nhan MST hoac CCCD chu ho va map vao `<NMua><MST>`.
- **AC3:** `dnmua_cccd`/`<CCCDan>` la optional; de null, rong hoac khong gui khong bi bao loi required.
- **AC4:** Neu CCCD co gia tri thi van kiem tra toi da 12 ky tu, luu va sinh `<CCCDan>` theo mapping hien tai; chi bo required, khong xoa field.
- **AC5:** Rule ap dung dong nhat cho hoa don goc, thay the, dieu chinh va cac wrapper ky/gui dung lai ba luong nay.
- **AC6:** Khi `ACTIVE_ND_254` tat hoac hoa don khong co hang hoa dac trung loai 1, hanh vi validation hien tai giu nguyen.

## Ngoai pham vi

- Khong thay doi schema DB, XML schema, route hoac DTO.
- Khong thay doi cac rule bat buoc khac cua nguoi mua va chi tiet xe.
- Khong thay doi noi dung XML da ky luu tren FTP.
- Khong sua checker, Redis/DB fallback, cach cache hay bat ky dieu kien nao cua gate `ACTIVE_ND_254`.
