# CBCLOUDV2-9181 Plan

## Goal

Sua loi checkbox "Hoa don chiet khau thuong mai" van hien tick khi edit hoa don dieu chinh/thay the, du API va DB cua hoa don hien tai da la `QuanLy_XacThuc_Loai = 0`.

## Context

- Task `CBCLOUDV2-8919` da mo checkbox CKTM cho hoa don loai `1`, `3`, `5` va cho phep hoa don thay the/dieu chinh ke thua trang thai tu hoa don goc.
- Follow-up nay xu ly case edit hoa don da luu: neu nguoi dung bo tick va luu, DB da cap nhat `QuanLy_XacThuc_Loai = 0`, nhung UI van tick lai.
- Evidence:
  - Request `CreateOrEditInv` gui top-level `quanLy_XacThuc_Loai = 0`.
  - DB `vs_hd_tonghop.Id = 2000372878` co `QuanLy_XacThuc_Loai = 0`.
  - API `GetHoaDon?Id=2000372878&isView=false` tra top-level `quanLy_XacThuc_Loai = 0`, trong khi `hoaDonGoc.quanLy_XacThuc_Loai = 1`.

## Root Cause

Frontend load hoa don xong dang copy gia tri CKTM tu hoa don goc cho loai `3/5`:

```ts
this.hoaDon.quanLy_XacThuc_Loai = this.hoaDon.hoaDonGoc.quanLy_XacThuc_Loai;
```

Do do khi edit hoa don da co `id`, gia tri da luu cua hoa don hien tai bi ghi de boi gia tri hoa don goc.

Ngoai ra code chi set `tinhChatHoaDon = true` khi value bang `1`, khong reset ve `false` khi value bang `0`.

## Design

1. Phan biet tao moi va edit bang `hoaDon.id`.
2. Chi copy `hoaDonGoc.quanLy_XacThuc_Loai` sang `hoaDon.quanLy_XacThuc_Loai` khi tao moi hoa don thay the/dieu chinh.
3. Khi edit hoa don da co `id`, giu nguyen `hoaDon.quanLy_XacThuc_Loai` top-level tu API.
4. Sau khi xac dinh gia tri `hoaDon.quanLy_XacThuc_Loai`, set checkbox state theo bieu thuc boolean mot chieu:

```ts
this.tinhChatHoaDon = this.hoaDon.quanLy_XacThuc_Loai == 1;
```

## Implementation Steps

1. Sua `hoadon-goc.component.ts`:
   - Them dieu kien `!this.hoaDon.id` vao block copy tu `hoaDonGoc`.
   - Doi block set checkbox sang gan boolean truc tiep.
2. Ra soat va ap dung tuong tu cho `hoadonbanhang.component.ts`.
3. Ra soat va ap dung tuong tu cho `vemaybay.component.ts`.
4. Khong sua BE, DB schema, service proxy, hoac logic tinh tien.
5. Chay test/build phu hop sau khi cap nhat docs va code.

## Compatibility

- Luong tao moi van giu hanh vi cu: hoa don thay the/dieu chinh ban dau ke thua CKTM tu hoa don goc.
- Luong edit duoc sua dung nghiep vu: checkbox phai theo chinh hoa don dang edit.
- Hoa don goc loai `1` khong bi anh huong.
- Luong save/sign khong doi; field tiep tuc luu bang top-level `quanLy_XacThuc_Loai`.

## Verification Plan

1. Tao moi hoa don dieu chinh tu hoa don goc co `QuanLy_XacThuc_Loai = 1`: checkbox tick mac dinh.
2. Bo tick va luu: request gui top-level `quanLy_XacThuc_Loai = 0`.
3. DB row hoa don dieu chinh co `QuanLy_XacThuc_Loai = 0`.
4. Goi `GetHoaDon?Id=...&isView=false`: top-level tra `0`.
5. Mo lai man edit: checkbox khong tick, du `hoaDonGoc.quanLy_XacThuc_Loai = 1`.
6. Tick lai va luu: request/DB len `1`.
7. Lap lai cho hoa don thay the.
