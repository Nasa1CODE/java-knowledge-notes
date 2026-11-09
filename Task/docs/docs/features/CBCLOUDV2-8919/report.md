# CBCLOUDV2-8919 Report

## Summary

Updated CKTM checkbox behavior so it is available on normal, replacement, and adjustment invoice forms.

## Root Cause

The checkbox was only visible when:

```html
hoaDon.mau_HoaDon_Loai == 1
```

For adjustment/replacement flows, `GetHoaDonBiDieuChinh`/original invoice data can return `QuanLy_XacThuc_Loai = 1`, but that value is placed under `hoaDon.hoaDonGoc`. The checkbox reads `hoaDon.quanLy_XacThuc_Loai`, so the checked state was not propagated.

## Fix

- Changed checkbox visibility to support invoice types `1`, `3`, and `5`.
- Copied `hoaDon.hoaDonGoc.quanLy_XacThuc_Loai` into `hoaDon.quanLy_XacThuc_Loai` for replacement/adjustment forms.
- Existing checkbox save logic remains unchanged:

```ts
this.hoaDon.quanLy_XacThuc_Loai = +this.tinhChatHoaDon;
```

## Persistence

Backend stores the checkbox state in:

```sql
vs_hd_tonghop.QuanLy_XacThuc_Loai
```

Entity/DTO field:

```csharp
QuanLy_XacThuc_Loai
```

## Notes

Frontend build and manual regression were not run in this session.
