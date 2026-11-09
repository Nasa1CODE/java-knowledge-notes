---
feature: CBCLOUDV2-9571
title: "Bo sung validate nguoi mua doi voi hang hoa dac trung 1"
plan-status: plan-review
service: api-cloud-service
service-repo: ./api-cloud-service
created_at: 2026-09-14
updated_at: 2026-09-14
---

# Plan - CBCLOUDV2-9571

## Muc tieu

Chot validation nguoi mua trong nhanh `ACTIVE_ND_254` hien tai cho hang hoa dac trung loai 1: bat buoc `<Ten>`, `<MST>` va khong bat buoc `<CCCDan>`.

## Hien trang source

- `GuiHoaDonAppService.ValidateNguoiMuaDacTrungXeValues` da bat buoc `dnmua_ten` va `dnmua_mst`.
- CCCD khong nam trong tham so cua shared validator nen hien khong co required check tai day; khi co gia tri van duoc kiem tra toi da 12 ky tu.
- Ba DTO goi chung helper cho hoa don goc, thay the va dieu chinh; can kiem tra cac validation duplicate de tranh mot luong van bat buoc CCCD.

## Cach thuc hien

1. Giu nguyen cach `HasHangHoaDacTrungXeMoi` ket hop `ACTIVE_ND_254` va subtype 1, dong thoi dung mot shared validator cho `GuiHDGoc`, `GuiHoaDonTT`, `GuiHoaDonDC`.
2. Bat buoc `dnmua_ten` va `dnmua_mst` bang `IsNullOrWhiteSpace`; chuan hoa message thanh `Ten don vi khong duoc de trong.` va `MST/CCCD chu ho khong duoc de trong.`.
3. Khong them required check cho `dnmua_cccd`; ra soat va go bo neu con validation duplicate o cac API/wrapper lien quan.
4. Giu maxlength va mapping DB/XML hien tai. CCCD co gia tri van map vao `<CCCDan>`; CCCD rong thi khong sinh the.
5. Bo sung unit test cho shared validator va regression ba loai hoa don.

## Kiem chung

- Chay `dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity quiet -m:1 -nr:false -p:BuildInParallel=false`.
- Build rieng `WS.Core`, `WS.Application`, `WS.EntityFrameworkCore`.
- Goi API goc/thay the/dieu chinh voi tung truong hop thieu Ten, thieu MST, thieu CCCD va khong co subtype 1.
- Kiem tra XML co `<Ten>`, `<MST>`; `<CCCDan>` chi xuat hien khi co du lieu.

## Thay doi ky thuat

| Hang muc | Thay doi |
|---|---|
| API contract | Khong |
| DB/migration | Khong |
| XML schema | Khong |
| Validation | Co, thay required/message |
| Redis/config | Khong |

`ACTIVE_ND_254`, checker, Redis/DB fallback va XML gate khong nam trong diff cua task nay.

## Phe duyet (Gate 1)

- [ ] DEV tu review: cho duyet
- [ ] TechLead approve: cho duyet
