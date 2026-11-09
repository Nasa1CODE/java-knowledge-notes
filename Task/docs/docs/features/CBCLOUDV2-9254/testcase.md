# CBCLOUDV2-9254 Test Cases

## Preconditions

- Co quyen vao man `/app/hddt/hoadon/vanbanthoathuan`.
- Co du lieu hoa don co `QuanLy_VanBanThoaThuan` khac null/rong.
- Co it nhat mot record `vs_hd_bienbanthoathuan.TongHop_Id IS NULL` lien quan den VBTT can kiem tra.

SQL ho tro tim du lieu:

```sql
SELECT *
FROM vs_hd_bienbanthoathuan
WHERE TongHop_Id IS NULL
ORDER BY CreationTime DESC;
```

## Test Cases

| ID | Scenario | Steps | Expected |
| --- | --- | --- | --- |
| TC01 | Hien thi VBTT co bien ban thieu `TongHop_Id` | Mo man Van ban thoa thuan, load danh sach mac dinh | Hoa don co `QuanLy_VanBanThoaThuan` hien tren danh sach |
| TC02 | Filter rong | Goi `GetDSHoaDon?filter=&SkipCount=0&MaxResultCount=10` | API tra ve cac VBTT hop le, khong bi loai chi vi `TongHop_Id IS NULL` |
| TC03 | Tim theo ten nguoi mua | Nhap keyword theo `DNMua_Ten` cua hoa don can test | Ban ghi VBTT hien dung theo filter |
| TC04 | Tim theo so bien ban/ten van ban | Nhap keyword theo `Mau_HopDong_So` | Ban ghi VBTT hien dung theo filter |
| TC05 | Loc hoa don dieu chinh | Chon loai hoa don Dieu chinh | Chi hien hoa don dieu chinh va hoa don goc co VBTT theo rule cu |
| TC06 | Loc hoa don thay the | Chon loai hoa don Thay the | Chi hien hoa don thay the |
| TC07 | Loc hoa don xoa bo | Chon loai hoa don Xoa bo | Chi hien hoa don xoa bo |
| TC08 | Tai file VBTT | Bam nut tai file tren dong du lieu moi hien lai | File duoc tai neu file storage ton tai |
| TC09 | Xem file VBTT | Bam nut xem tren dong du lieu moi hien lai | Modal xem file hien noi dung neu file storage ton tai |
| TC10 | Loai tru van ban chung tu match theo `TongHop_Id` | Tao/kiem tra record co `KieuBienBan = 1` va co `TongHop_Id` hop le | Record khong hien trong danh sach VBTT |
| TC11 | Loai tru van ban chung tu match theo `QuanLy_VanBan_Id` | Tao/kiem tra hoa don co `QuanLy_VanBan_Id` tro den bien ban `KieuBienBan = 1` nhung bien ban thieu `TongHop_Id` | Record khong hien trong danh sach VBTT |

## Regression

- Danh sach VBTT co bien ban day du `TongHop_Id` van hien nhu truoc.
- Paging/sorting khong thay doi.
- API `GetBienBanByTongHopId` khong doi behavior.
- Luong tao/sua VBTT khong doi.
