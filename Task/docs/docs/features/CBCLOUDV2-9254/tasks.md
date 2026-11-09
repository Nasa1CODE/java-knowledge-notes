# CBCLOUDV2-9254 Tasks

## Task 1 - Xac dinh root cause danh sach VBTT thieu du lieu

- Status: complete
- Area/service: `invoicecore`
- Description: Kiem tra endpoint `VanBanThoaThuan/GetDSHoaDon` va mapping EF.
- Findings:
  - `GetDSHoaDon` bat buoc `e.HD_BienBanThoaThuan != null`.
  - EF map `HD_BienBanThoaThuan` bang FK `HD_BienBanThoaThuan.TongHop_Id`.
  - Du lieu bien ban thieu `TongHop_Id` lam navigation null, nen hoa don bi loai khoi danh sach.

## Task 2 - Sua query backend

- Status: complete
- Area/service: `invoicecore`
- File:
  - `aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/VanBanThoaThuanAppService.cs`
- Description: Cho phep hien thi hoa don co `QuanLy_VanBanThoaThuan` ngay ca khi navigation bien ban khong join duoc.
- Acceptance criteria:
  - [x] Khong bat buoc `HD_BienBanThoaThuan != null`.
  - [x] Tach dieu kien hien thi VBTT va dieu kien loai tru `KieuBienBan = 1`.
  - [x] Hoa don van phai co `QuanLy_VanBanThoaThuan`.
  - [x] Loai `KieuBienBan = 1` khi match bien ban qua `TongHop_Id` hoac `QuanLy_VanBan_Id`.
  - [x] Filter `loaihd`, `filter`, paging, sorting giu nguyen.

## Task 3 - Cap nhat docs

- Status: complete
- Area/service: `docs`
- Files:
  - `docs/features/CBCLOUDV2-9254/expect.md`
  - `docs/features/CBCLOUDV2-9254/plan.md`
  - `docs/features/CBCLOUDV2-9254/tasks.md`
  - `docs/features/CBCLOUDV2-9254/testcase.md`
  - `docs/features/CBCLOUDV2-9254/impact.md`
  - `docs/features/CBCLOUDV2-9254/report.md`

## Verification

- [x] `dotnet build invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj`
- [ ] Manual QA tren moi truong co du lieu VBTT thieu `TongHop_Id`.
