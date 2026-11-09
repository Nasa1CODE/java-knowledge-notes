---
feature: CBCLOUDV2-9260
status: testing
owner: DEV + AI
updated_at: 2026-09-08
---

# Tasks - CBCLOUDV2-9260

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Review đơn vị maxlength và schema precheck | docs | in-progress | XS | |
| 2 | Mở rộng năm cột tenant DB | invoicecore | in-progress | S | |
| 3 | Điều chỉnh bảy maxlength import trực tiếp | invoicecore | completed | XS | |
| 4 | Điều chỉnh bảy maxlength import nền | svinvoicesendemail | completed | XS | |
| 5 | Bổ sung automated test boundary và gate | svinvoicesendemail | completed | S | |
| 6 | Build và manual regression sáu luồng import | invoicecore | in-progress | M | |
| 7 | Hoàn tất docs và báo cáo thực thi | docs | completed | XS | |

## Task 1 - Review đơn vị maxlength và schema precheck

- **Status:** in-progress
- **Service:** `docs`
- **Mô tả:** Gate 1 duyệt cách tính theo ký tự và DBA xác nhận tên/type cột `sspktclxxuong` trước deploy.
- **Tiêu chí chấp nhận:** AC3, AC6.
- **Kiểm chứng:** Gate 1 có chữ ký; lưu output `SHOW COLUMNS FROM vs_hd_chitiet_morong` không chứa dữ liệu nhạy cảm.
- **Phụ thuộc:** Không.
- **File dự kiến chạm:** `features/CBCLOUDV2-9260/plan.md`, `deploy.md`.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>

## Task 2 - Mở rộng năm cột tenant DB (*)

- **Status:** in-progress (SQL đã tạo, chưa apply/precheck runtime)
- **Service:** `invoicecore`
- **Mô tả:** Mở rộng cột chứng nhận, seri, tên loại tài sản, tên thương mại và nhãn hiệu lên 255/400; không thu hẹp cột mã tỉnh/xã.
- **Tiêu chí chấp nhận:** AC6, AC7.
- **Kiểm chứng:** Query `information_schema.COLUMNS` trả đúng `CHARACTER_MAXIMUM_LENGTH`; import/read-back boundary không truncate.
- **Phụ thuộc:** Task 1.
- **File dự kiến chạm:** `aspnet-core/database/<CBCLOUDV2-9260>.sql`, `features/CBCLOUDV2-9260/deploy.md`, `databases/databasetenant.vs_hd_chitiet_morong.sql`.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 3 - Điều chỉnh bảy maxlength import trực tiếp

- **Status:** completed (2026-09-08)
- **Service:** `invoicecore`
- **Mô tả:** Đổi năm ngưỡng trong `ValidateVehicleAssetImportDetailFields(...)` và hai ngưỡng trong `ValidateVehicleAssetImportLocationFields(...)`; dùng helper ký tự phạm vi hẹp cho bảy field, giữ nguyên gate, required, parser và mapping.
- **Tiêu chí chấp nhận:** AC1, AC3, AC4, AC5, AC7.
- **Kiểm chứng:** `dotnet build aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore --verbosity minimal` -> 0 error.
- **Phụ thuộc:** Task 1, Task 2.
- **File dự kiến chạm:** `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>

## Task 4 - Điều chỉnh bảy maxlength import nền

- **Status:** completed (2026-09-08)
- **Service:** `svinvoicesendemail`
- **Mô tả:** Đổi cùng bảy ngưỡng trong `VehicleAssetImportHelper.ValidateDetailFields(...)` và `ValidateLocationFields(...)`; không sửa router/queue/mapping.
- **Tiêu chí chấp nhận:** AC2, AC3, AC4, AC5, AC7.
- **Kiểm chứng:** `dotnet build AppServiceImportBillHost/AppService.sln --no-restore --verbosity minimal` -> 0 error.
- **Phụ thuộc:** Task 1, Task 2.
- **File dự kiến chạm:** `AppServiceImportBillHost/AppService/Models/VehicleAssetImportHelper.cs`.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>

## Task 5 - Bổ sung automated test boundary và gate

- **Status:** completed (2026-09-08)
- **Service:** `svinvoicesendemail`
- **Mô tả:** Parameterized test bảy field tại N/N+1, gate template/subtype, required regression và Unicode để khóa đơn vị ký tự.
- **Tiêu chí chấp nhận:** AC2, AC3, AC4, AC5.
- **Kiểm chứng:** Filter CBCLOUDV2-9260 pass 16/16; không chạy test tích hợp `UnitTest1.TestImportFile` có kết nối DB cứng.
- **Phụ thuộc:** Task 4.
- **File dự kiến chạm:** `AppServiceImportBillHost/AppServiceTest/VehicleAssetImportHelperTests.cs`, chỉ sửa `.csproj` nếu file test chưa được include.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 6 - Build và manual regression sáu luồng import

- **Status:** in-progress (build pass, manual chưa chạy)
- **Service:** `invoicecore`
- **Mô tả:** Build hai service; import GTGT/Bán hàng/Vé xe với file `<= 50` và `> 50` dòng, boundary N/N+1, negative gate và đọc lại DB.
- **Tiêu chí chấp nhận:** AC1-AC7.
- **Kiểm chứng:** Hai build 0 error; manual import và DB read-back chưa chạy.
- **Phụ thuộc:** Task 2-5.
- **File dự kiến chạm:** Không; chỉ kiểm chứng.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 7 - Hoàn tất docs và báo cáo thực thi

- **Status:** completed (2026-09-08)
- **Service:** `docs`
- **Mô tả:** Cập nhật status/testcase/impact/DB snapshot và tạo report từ output thật; không đánh dấu pass case chưa chạy.
- **Tiêu chí chấp nhận:** AC1-AC7; Definition of Done của docs.
- **Kiểm chứng:** Review diff `features/CBCLOUDV2-9260` và DB docs; `report.md` có command/output thật.
- **Phụ thuộc:** Task 1-6.
- **File dự kiến chạm:** `expect.md`, `plan.md`, `tasks.md`, `testcase.md`, `impact.md`, `deploy.md`, `report.md`, DB current-state doc.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>
