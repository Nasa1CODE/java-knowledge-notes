---
feature: CBCLOUDV2-9418
status: implemented
updated_at: 2026-09-09
---

# Report - CBCLOUDV2-9418

## Đã thực hiện

- Cập nhật import trực tiếp trong `invoicecore` cho mẫu Excel v8 của GTGT, Bán hàng, Vé xe.
- Cập nhật service nền `svinvoicesendemail/AppServiceImportBillHost` cho cùng mapping cột.
- Bổ sung 3 cột độc lập, không phụ thuộc `ACTIVE_ND_254`:
  - `MDVQHNS`: không bắt buộc, tối đa 7 ký tự.
  - `Mã quốc tịch` -> `ma_quoc_tich_nguoi_mua`.
  - `Quốc tịch` -> `quoc_tich_nguoi_mua`.
- Đồng bộ lưu DB `vs_hd_tonghop_morong` cho `MaDVQHNS`, `ma_quoc_tich_nguoi_mua`, `quoc_tich_nguoi_mua`, `ten_tinh`, `ten_xa`.
- Giữ gate `ACTIVE_ND_254` chỉ cho nhóm Hàng hóa đặc trưng 1/xe; các cột `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` vẫn được đọc/lưu độc lập.
- Sửa `GetActiveND254()` ưu tiên Redis hash `QLCAUHINH.ACTIVE_ND_254`, fallback DB `vs_dm_ncc_cauhinh` khi cache miss/lỗi.
- Sửa `VehicleAssetImportHelper` để `TenTinh/TenXa` optional cho caller/test cũ không truyền hai cột này.
- Sửa điều kiện nhận diện dòng trống và mốc `LastColumn` service nền theo mẫu mới:
  - GTGT: `LastColumn=77`, DL đặc thù hóa đơn `68-72`, DL đặc thù hàng hóa `73-77`.
  - Bán hàng: `LastColumn=68`.
  - Vé xe: `LastColumn=65`.

## File đã sửa

| Repo | File |
|---|---|
| invoicecore | `aspnet-core/src/hddt/HDDT.Application/AppServices/CauHinh/DoanhNghiep_ThongTinChungAppService.cs` |
| invoicecore | `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/ExcelAudience.cs` |
| invoicecore | `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs` |
| invoicecore | `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/HoaDon/QuanLyHoaDon/HD_HoaDon_MoRongDto.cs` |
| invoicecore | `aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_HoaDon_MoRong.cs` |
| invoicecore | `aspnet-core/src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_HoaDon_MoRongRepository.cs` |
| svinvoicesendemail | `AppServiceImportBillHost/AppService/Domain/HD_HoaDon_MoRong.cs` |
| svinvoicesendemail | `AppServiceImportBillHost/AppService/Models/HoaDonRow.cs` |
| svinvoicesendemail | `AppServiceImportBillHost/AppService/Models/VehicleAssetImportHelper.cs` |
| svinvoicesendemail | `AppServiceImportBillHost/AppService/Repositories/HD_HoaDon_MoRongRepository.cs` |
| svinvoicesendemail | `AppServiceImportBillHost/AppService/Service/NhapDSHoaDonExcelHelper.cs` |
| svinvoicesendemail | `AppServiceImportBillHost/AppService/Service/BanHang_ExcelHelper.cs` |
| svinvoicesendemail | `AppServiceImportBillHost/AppService/Service/ImportVeXeHelper.cs` |

## Bằng chứng kiểm chứng

| Lệnh | Kết quả |
|---|---|
| `dotnet build aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore --verbosity minimal` | Pass, `0 Error`, còn warning nền/cũ của solution |
| `dotnet build D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\AppService.csproj --no-restore --verbosity minimal` | Pass, `0 Error`, warning nền về `netcoreapp2.1`/package cũ |
| `dotnet test D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppServiceTest\AppServiceTest.csproj --no-restore --verbosity minimal` | Pass, `23/23`, `0 Failed` sau khi sửa `TenTinh/TenXa` optional |

## Ghi chú

- Có một lần test worker fail trung gian vì các test cũ tạo `VehicleAssetImportColumns` không truyền `TenTinh/TenXa`, khiến EPPlus đọc column `0`. Đã sửa helper để tương thích caller cũ và chạy lại pass.
- Chưa chạy manual import trên môi trường thật với Redis/tenant DB; cần QA import bằng ba file mẫu v8 đã cung cấp.

## Correction gate ND254 - 2026-09-09 16:06:21

- Đã bổ sung gate ACTIVE_ND_254 cho API import và service import nền.
- Phạm vi gate: chỉ nhóm field Hàng hóa đặc trưng 1/xe theo Nghị định 254 gồm Mã tỉnh, Tên tỉnh, Mã xã, Tên xã, Số khung, Số máy và các thông tin tài sản/xe.
- Khi ACTIVE_ND_254 = 1: validate/lưu nhóm field Hàng hóa đặc trưng 1 theo template import mới.
- Khi ACTIVE_ND_254 khác 1, thiếu key hoặc lỗi đọc cấu hình: bỏ validate/lưu nhóm field Hàng hóa đặc trưng 1 theo ND254, giữ rule cũ.
- MDVQHNS, Mã quốc tịch, Quốc tịch không thuộc gate ND254 và vẫn đọc/lưu theo template mới.
- API invoicecore: đọc Redis hash QLCAUHINH/ACTIVE_ND_254, không có/lỗi thì fallback s_dm_ncc_cauhinh host.
- Service nền svinvoicesendemail: đọc ACTIVE_ND_254 từ host DB s_dm_ncc_cauhinh trước khi xử lý tenant import, rồi truyền flag vào helper GTGT/Bán hàng/Vé xe.
- Verification: build API pass, build service nền pass, unit test service nền pass 23/23.

## Correction dòng bắt đầu đọc import - 2026-09-09 16:43:57

- Đã cập nhật dòng bắt đầu đọc dữ liệu theo file mẫu mới: row 4.
- Phạm vi API invoicecore: GTGT, Bán hàng, Vé xe.
- Phạm vi service nền svinvoicesendemail: GTGT, Bán hàng, Vé xe.
- Không đổi các luồng ngoài task như Tài sản công/Phiếu xuất kho/Nước.
- Căn cứ file mẫu: row 1 header nhóm, row 2 tên cột, row 3 STT cột, row 4 dữ liệu đầu tiên.
- Verification: build API pass, build service nền pass, unit test service nền pass 23/23.

## Cập nhật 2026-09-10 09:28:38 - Validate mã quốc tịch/nước sản xuất khi import
- BE import: bổ sung kiểm tra tồn tại Mã quốc tịch theo danh mục s_dm_ncc_quoctich, dùng Redis key VS_LIST_NATIONALITY trước và fallback DB tương tự DM_NCC_QuocTich/GetAllNoPage.
- BE import: bổ sung kiểm tra tồn tại Mã Nước sản xuất theo cùng danh mục quốc tịch/quốc gia khi trường có giá trị.
- Service nền import: bổ sung VehicleAssetNationalityCatalog, load danh mục từ s_dm_ncc_quoctich host DB một lần trước khi xử lý file, truyền vào luồng GTGT/Bán hàng/Vé xe.
- Verify: dotnet build HDDT.Application.csproj pass 0 error; dotnet build AppServiceImportBillHost/AppService.csproj pass 0 error; dotnet test AppServiceImportBillHost/AppServiceTest.csproj pass 23/23.
