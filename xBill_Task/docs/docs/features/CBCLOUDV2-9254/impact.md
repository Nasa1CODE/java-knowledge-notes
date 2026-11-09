# CBCLOUDV2-9254 Impact

## Summary

Ticket chi thay doi dieu kien lay danh sach VBTT trong `invoicecore`. Muc tieu la hien thi lai cac hoa don da co file/ten VBTT nhung du lieu bien ban cu thieu `TongHop_Id`.

## Affected Components

- Backend:
  - `VanBanThoaThuanAppService.GetDSHoaDon`
- Frontend affected indirectly:
  - Man `/app/hddt/hoadon/vanbanthoathuan` se nhan them cac dong du lieu truoc day bi loai.

## Not Affected

- DB schema.
- File storage path VBTT.
- Luong tao/sua/ky VBTT.
- Endpoint xem/tai file VBTT.
- Public search/tracuu VBTT.
- Cac service worker gui mail/export/pdf.

## Data Impact

- Khong update du lieu cu.
- Du lieu cu thieu `TongHop_Id` co the hien tren danh sach neu hoa don co `QuanLy_VanBanThoaThuan`.

## Risk

- Query loai `KieuBienBan = 1` qua `TongHop_Id` hoac `QuanLy_VanBan_Id`. Neu du lieu mat ca hai khoa lien ket nay, backend khong co du khoa de xac dinh do la bien ban cua hoa don nao.

## Rollback

Rollback code change trong `VanBanThoaThuanAppService.GetDSHoaDon` ve dieu kien cu:

```csharp
e.HD_BienBanThoaThuan != null && e.HD_BienBanThoaThuan.KieuBienBan != 1
```
