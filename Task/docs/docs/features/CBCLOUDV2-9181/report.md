# CBCLOUDV2-9181 Report

## Status

- Implementation complete, manual QA pending.

## Findings

- BE `CreateOrEditInv` va DB da luu dung `QuanLy_XacThuc_Loai` cho hoa don dieu chinh/thay the.
- Evidence thuc te:
  - Request save gui top-level `quanLy_XacThuc_Loai = 0`.
  - DB query `vs_hd_tonghop.Id = 2000372878` tra `QuanLy_XacThuc_Loai = 0`.
  - API `GetHoaDon?Id=2000372878&isView=false` tra top-level `quanLy_XacThuc_Loai = 0`.
- UI van tick vi frontend load xong copy `hoaDonGoc.quanLy_XacThuc_Loai = 1` de ghi de gia tri top-level cua hoa don hien tai.

## Planned Fix

- Chi copy CKTM tu `hoaDonGoc` khi tao moi hoa don thay the/dieu chinh.
- Khi edit hoa don da co `id`, giu nguyen top-level `hoaDon.quanLy_XacThuc_Loai`.
- Gan lai `tinhChatHoaDon` bang boolean truc tiep tu field hien tai de reset duoc ca true va false.

## Changes Applied

- `hoadon-goc.component.ts`: them guard `!this.hoaDon.id` khi copy CKTM tu `hoaDonGoc`; gan `tinhChatHoaDon` truc tiep tu top-level `quanLy_XacThuc_Loai`.
- `hoadonbanhang.component.ts`: ap dung cung logic.
- `vemaybay.component.ts`: ap dung cung logic.

## Files To Inspect/Update

- `D:/XBill/Cloud/frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts`
- `D:/XBill/Cloud/frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts`
- `D:/XBill/Cloud/frontend_angular/src/app/hddt/hoadon/vemaybay/vemaybay.component.ts`

## Verification

- Static diff checked: chi thay doi 3 block load CKTM theo plan.
- `npm run build`: failed on Node 22 with `ERR_OSSL_EVP_UNSUPPORTED`.
- `NODE_OPTIONS=--openssl-legacy-provider npm run build`: bypassed OpenSSL error but failed because `node-sass@5.0.0` does not support Windows 64-bit Node runtime 127.
- Manual QA theo `testcase.md`: pending.
