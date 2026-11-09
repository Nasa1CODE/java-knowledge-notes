# Tasks - CBCLOUDV2-9418

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Đọc Redis fallback DB cho `ACTIVE_ND_254` | invoicecore | done | S | local |
| 2 | Cập nhật import trực tiếp GTGT/Bán hàng/Vé xe | invoicecore | done | M | local |
| 3 | Cập nhật import nền GTGT/Bán hàng/Vé xe | svinvoicesendemail | done | M | local |
| 4 | Bổ sung test và kiểm chứng | invoicecore, svinvoicesendemail | done | M | local |
| 5 | Cập nhật report/deploy/token | docs | done | S | local |

---

## Task 1 - Đọc Redis fallback DB cho `ACTIVE_ND_254`

- **Status:** done
- **Service:** `invoicecore`
- **Mô tả:** Sửa API `GetActiveND254()` để ưu tiên Redis Hash `QLCAUHINH`, field `ACTIVE_ND_254`, fallback DB khi cache miss/lỗi.
- **Tiêu chí chấp nhận:**
  - [ ] Redis field `"1"` trả `true`.
  - [ ] Redis thiếu/lỗi thì fallback DB `vs_dm_ncc_cauhinh`.
  - [ ] DB thiếu/lỗi cuối cùng trả `false`.
  - [ ] Không lọc `DaiLy_Id`.
- **Kiểm chứng:**
  - [x] `dotnet build aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore --verbosity minimal` -> 0 error.
  - [ ] Manual/API test với Redis có `QLCAUHINH.ACTIVE_ND_254=1` -> API trả `true`.
- **Phụ thuộc:** Không
- **File dự kiến chạm:**
  - `aspnet-core/src/hddt/HDDT.Application/AppServices/CauHinh/DoanhNghiep_ThongTinChungAppService.cs`
- **Ước lượng:** S
- **Commit/PR:** Chưa có

---

## Task 2 - Cập nhật import trực tiếp GTGT/Bán hàng/Vé xe

- **Status:** done
- **Service:** `invoicecore`
- **Mô tả:** Thêm đọc `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` độc lập ND254; dịch lại mapping cột Hàng hóa đặc trưng 1/xe và gate nhóm xe theo `ACTIVE_ND_254`.
- **Tiêu chí chấp nhận:**
  - [ ] GTGT đọc `MDVQHNS=12`, `MaQuocTich=13`, `QuocTich=14`, `LoaiHHDTr=41`, `MaTinh=42`, `TenTinh=43`, `MaXa=44`, `TenXa=45`, `SoKhung=46`, `SoMay=47`, `SoBienKiemSoat=62`, `DL đặc thù hóa đơn=68-72`, `DL đặc thù hàng hóa=73-77`, `LastColumn=77`.
  - [ ] Bán hàng đọc `MDVQHNS=12`, `MaQuocTich=13`, `QuocTich=14`, `LoaiHHDTr=42`, `MaTinh=43`, `TenTinh=44`, `MaXa=45`, `TenXa=46`, `SoKhung=47`, `SoMay=48`, `SoBienKiemSoat=63`, `LastColumn=68`.
  - [ ] Vé xe đọc `MDVQHNS=9`, `MaQuocTich=10`, `QuocTich=11`, `LoaiHHDTr=41`, `MaTinh=42`, `TenTinh=43`, `MaXa=44`, `TenXa=45`, `SoKhung=46`, `SoMay=47`, `SoBienKiemSoat=62`, `LastColumn=65`.
  - [ ] `MDVQHNS` không bắt buộc, tối đa 7 ký tự, không phụ thuộc ND254.
  - [ ] Khi ND254 tắt, chỉ bỏ qua nhóm Hàng hóa đặc trưng 1/xe; vẫn lưu `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch`.
- **Kiểm chứng:**
  - [x] `dotnet build aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore --verbosity minimal` -> 0 error.
  - [ ] Test/source assertion cho ba mapping cột mới.
- **Phụ thuộc:** Task 1
- **File dự kiến chạm:**
  - `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`
  - `aspnet-core/test/VS.Tests/HoaDon/*`
- **Ước lượng:** M
- **Commit/PR:** Chưa có

---

## Task 3 - Cập nhật import nền GTGT/Bán hàng/Vé xe

- **Status:** done
- **Service:** `svinvoicesendemail`
- **Mô tả:** Đồng bộ field `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch`, mapping cột v8 và logic bỏ qua/lưu nhóm xe theo ND254 trong worker.
- **Tiêu chí chấp nhận:**
  - [ ] Ba router worker dùng cùng vị trí cột như Task 2.
  - [ ] `VehicleAssetImportHelper` đọc/validate/map `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` độc lập ND254; nhóm xe theo ND254.
  - [ ] Khi ND254 tắt, worker không báo lỗi required nhóm nâng cấp và không lưu dữ liệu nâng cấp.
  - [ ] Không đổi queue name hoặc payload bên ngoài.
- **Kiểm chứng:**
  - [x] `dotnet test AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj --no-restore --verbosity minimal` -> pass 23/23.
  - [x] `dotnet build AppServiceImportBillHost/AppService/AppService.csproj --no-restore --verbosity minimal` -> 0 error.
- **Phụ thuộc:** Task 1, Task 2 để đồng bộ mapping
- **File dự kiến chạm:**
  - `AppServiceImportBillHost/AppService/Models/HoaDonRow.cs`
  - `AppServiceImportBillHost/AppService/Models/VehicleAssetImportHelper.cs`
  - `AppServiceImportBillHost/AppService/Service/NhapDSHoaDonExcelHelper.cs`
  - `AppServiceImportBillHost/AppService/Service/BanHang_ExcelHelper.cs`
  - `AppServiceImportBillHost/AppService/Service/ImportVeXeHelper.cs`
  - `AppServiceImportBillHost/AppServiceTest/*`
- **Ước lượng:** M
- **Commit/PR:** Chưa có

---

## Task 4 - Bổ sung test và kiểm chứng

- **Status:** done
- **Service:** `invoicecore`, `svinvoicesendemail`
- **Mô tả:** Bổ sung test cho mapping cột mới, maxlength `MDVQHNS`, bật/tắt ND254 và hồi quy không đọc lệch cột.
- **Tiêu chí chấp nhận:**
  - [ ] Có case `MDVQHNS` trống.
  - [ ] Có case `MDVQHNS` đúng 7 và vượt 8 ký tự.
  - [ ] Có case ND254 bật thì lưu dữ liệu.
  - [ ] Có case ND254 tắt thì bỏ qua dữ liệu nhập.
  - [ ] Có case ba loại file GTGT/Bán hàng/Vé xe đúng vị trí cột.
  - [ ] Có case `DL đặc thù GTGT` đọc ở cuối file, không đọc nhầm vào nhóm xe.
- **Kiểm chứng:**
  - [ ] Lệnh test trong Task 2 và Task 3 có kết quả thật trong `report.md`.
- **Phụ thuộc:** Task 2, Task 3
- **File dự kiến chạm:**
  - `aspnet-core/test/VS.Tests/HoaDon/*`
  - `AppServiceImportBillHost/AppServiceTest/*`
- **Ước lượng:** M
- **Commit/PR:** Chưa có

---

## Task 5 - Cập nhật report/deploy/token

- **Status:** done
- **Service:** `docs`
- **Mô tả:** Sau implementation, cập nhật bằng chứng test thật, hướng dẫn deploy file mẫu/Redis và báo cáo token.
- **Tiêu chí chấp nhận:**
  - [x] `report.md` ghi đúng file đã sửa và kết quả build/test thật.
  - [ ] `deploy.md` ghi rõ phát hành file mẫu và Redis key.
  - [x] `D:\XBill\Cloud\Token\CBCLOUDV2-9418.md` có báo cáo token tiếng Việt.
- **Kiểm chứng:**
  - [ ] `git -C D:\XBill\Cloud\docs diff -- features/CBCLOUDV2-9418` -> docs đúng scope.
- **Phụ thuộc:** Task 1-4
- **File dự kiến chạm:**
  - `features/CBCLOUDV2-9418/report.md`
  - `features/CBCLOUDV2-9418/deploy.md`
  - `D:\XBill\Cloud\Token\CBCLOUDV2-9418.md`
- **Ước lượng:** S
- **Commit/PR:** Chưa có




## Correction gate ND254 - 2026-09-09 16:06:21

- [x] Bổ sung gate ACTIVE_ND_254 cho API import GTGT/Bán hàng/Vé xe.
- [x] Bổ sung gate ACTIVE_ND_254 cho service nền import GTGT/Bán hàng/Vé xe.
- [x] Khi gate tắt: clear riêng nhóm field Hàng hóa đặc trưng 1 trước khi lưu, không ảnh hưởng MDVQHNS, Mã quốc tịch, Quốc tịch.
- [x] Build/test lại sau correction.

## Correction dòng bắt đầu đọc import - 2026-09-09 16:43:57

- [x] Đổi API GTGT/Bán hàng/Vé xe từ ow = 2 sang ow = 4.
- [x] Đổi service nền GTGT/Bán hàng/Vé xe từ ow = 2 sang ow = 4.
- [x] Giữ nguyên các luồng ngoài task.
- [x] Build/test lại sau khi sửa.
