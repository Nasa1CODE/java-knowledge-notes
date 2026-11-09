---
feature: CBCLOUDV2-9386
status: testing
owner: DEV + AI
updated_at: 2026-09-08
---

# Tasks - CBCLOUDV2-9386

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Bỏ required Email trong import trực tiếp | invoicecore | completed | XS | |
| 2 | Bỏ required Email trong import nền | svinvoicesendemail | completed | XS | |
| 3 | Cập nhật automated test worker | svinvoicesendemail | completed | S | |
| 4 | Build và manual regression import trực tiếp | invoicecore | in-progress | S | |
| 5 | Test/build và manual regression import nền | svinvoicesendemail | in-progress | S | |
| 6 | Hoàn tất feature docs theo kết quả thật | docs | pending | XS | |

## Task 1 - Bỏ required Email trong import trực tiếp

- **Status:** completed (2026-09-08)
- **Service:** `invoicecore`
- **Mô tả:** Xóa duy nhất check `Địa chỉ thư điện tử không được để trống.` trong `ValidateVehicleAssetImportBuyerFields(...)`.
- **Tiêu chí chấp nhận:** AC1, AC2, AC3, AC5, AC6, AC7.
- **Kiểm chứng:** `dotnet build aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore` -> 0 error.
- **Phụ thuộc:** Không.
- **File dự kiến chạm:** `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>

## Task 2 - Bỏ required Email trong import nền

- **Status:** completed (2026-09-08)
- **Service:** `svinvoicesendemail`
- **Mô tả:** Xóa duy nhất `Require(...)` cho `data.email` trong `VehicleAssetImportHelper.ValidateBuyerFields(...)`.
- **Tiêu chí chấp nhận:** AC1, AC2, AC3, AC5, AC6, AC7.
- **Kiểm chứng:** `dotnet build AppServiceImportBillHost/AppService.sln --no-restore` -> 0 error.
- **Phụ thuộc:** Task 1 để đối chiếu rule hai service.
- **File dự kiến chạm:** `AppServiceImportBillHost/AppService/Models/VehicleAssetImportHelper.cs`.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>

## Task 3 - Cập nhật automated test worker

- **Status:** completed (2026-09-08)
- **Service:** `svinvoicesendemail`
- **Mô tả:** Đổi expected Email từ required sang optional; thêm/giữ case Email invalid, maxlength và các buyer field còn lại.
- **Tiêu chí chấp nhận:** AC1-AC7 ở mức helper dùng chung.
- **Kiểm chứng:** `dotnet test AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj --no-restore` -> tất cả test pass.
- **Phụ thuộc:** Task 2.
- **File dự kiến chạm:** `AppServiceImportBillHost/AppServiceTest/VehicleAssetImportHelperTests.cs`.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 4 - Build và manual regression import trực tiếp

- **Status:** in-progress
- **Service:** `invoicecore`
- **Mô tả:** Build BE và kiểm tra GTGT/Bán hàng/Vé xe trên import trực tiếp `<= 50` dòng, gồm Email trống, invalid, maxlength và cấu trúc dòng cha/con.
- **Tiêu chí chấp nhận:** AC1-AC7.
- **Kiểm chứng:** Build `invoicecore` đã thành công, 0 error; manual ba loại hóa đơn ở đường `<= 50` dòng chưa chạy.
- **Phụ thuộc:** Task 1.
- **File dự kiến chạm:** Không; chỉ build/test và tạo bằng chứng.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 5 - Test/build và manual regression import nền

- **Status:** in-progress
- **Service:** `svinvoicesendemail`
- **Mô tả:** Test/build service nền và kiểm tra GTGT/Bán hàng/Vé xe trên import `> 50` dòng, gồm Email trống, invalid, maxlength và cấu trúc dòng cha/con.
- **Tiêu chí chấp nhận:** AC1-AC7.
- **Kiểm chứng:** Worker test 35/35 pass và build 0 error; manual ba loại hóa đơn ở đường `> 50` dòng chưa chạy.
- **Phụ thuộc:** Task 2, Task 3.
- **File dự kiến chạm:** Không; chỉ build/test và tạo bằng chứng.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 6 - Hoàn tất feature docs

- **Status:** pending
- **Service:** `docs`
- **Mô tả:** Cập nhật task status, testcase status, impact thật và report từ output thực tế.
- **Tiêu chí chấp nhận:** Không đánh dấu pass cho case chưa chạy; không tạo `deploy.md` nếu không phát sinh trigger.
- **Kiểm chứng:** Review diff `features/CBCLOUDV2-9386`.
- **Phụ thuộc:** Task 4, Task 5.
- **File dự kiến chạm:** `tasks.md`, `testcase.md`, `impact.md`, `report.md`.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>
