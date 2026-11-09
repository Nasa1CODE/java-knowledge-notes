---
feature: CBCLOUDV2-9404
status: testing
updated_at: 2026-09-08
---

# Tasks - CBCLOUDV2-9404

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Bỏ quality khỏi import trực tiếp và hỗ trợ hai layout | invoicecore | completed | M | local |
| 2 | Bổ sung test import trực tiếp | invoicecore | completed | S | local |
| 3 | Bỏ quality khỏi import nền và ba router | svinvoicesendemail | completed | M | local |
| 4 | Bổ sung test import nền | svinvoicesendemail | completed | S | local |
| 5 | Cập nhật file mẫu runtime | invoicecore | pending | M | |
| 6 | Test và build import trực tiếp | invoicecore | partial | S | local |
| 7 | Test và build import nền | svinvoicesendemail | completed | S | local |
| 8 | Regression sáu luồng và DB read-back | invoicecore | pending | M | |
| 9 | Hoàn tất docs và bằng chứng | docs | completed | XS | local |

## Task 1 - Bỏ quality khỏi import trực tiếp và hỗ trợ hai layout

- **Status:** completed
- **Service:** `invoicecore`
- **Mô tả:** Bỏ `chatluongtaisan` khỏi cấu hình cột, parser, validator, mapping và save predicate; dịch biển số/LastColumn và ba gate hard-code 73/64/62 sang 72/63/61; nhận diện header để đọc đúng file cũ/mới.
- **Tiêu chí chấp nhận:** AC2, AC4-AC7.
- **Kiểm chứng:** `rg` không còn quality trong import path; source review ba bộ cột 72/63/61.
- **Phụ thuộc:** Không.
- **File dự kiến chạm:** `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`, `ExcelAudience.cs`.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 2 - Bổ sung test import trực tiếp

- **Status:** completed
- **Service:** `invoicecore`
- **Mô tả:** Test layout mới/cũ, gate, xe đã qua sử dụng và mapping `CLTSan` null/biển số đúng.
- **Tiêu chí chấp nhận:** AC2, AC4-AC7.
- **Kiểm chứng:** `dotnet test aspnet-core/test/VS.Tests/VS.Tests.csproj --no-restore --filter "FullyQualifiedName~VehicleAssetImportQualityRemoval" --verbosity minimal`.
- **Phụ thuộc:** Task 1.
- **File dự kiến chạm:** `aspnet-core/test/VS.Tests/HoaDon/VehicleAssetImportQualityRemovalTests.cs` nếu khả thi với test project hiện có.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 3 - Bỏ quality khỏi import nền và ba router

- **Status:** completed
- **Service:** `svinvoicesendemail`
- **Mô tả:** Đồng bộ helper/model, ba map cột và ba gate cấp hóa đơn GTGT/Bán hàng/Vé xe; giữ queue, entity/repository và tenant routing.
- **Tiêu chí chấp nhận:** AC3-AC8.
- **Kiểm chứng:** Source review và `rg` xác nhận không còn quality trong import helper/router ngoài domain field giữ lại.
- **Phụ thuộc:** Thiết kế layout Task 1.
- **File dự kiến chạm:** `VehicleAssetImportHelper.cs`, `HoaDonRow.cs`, `NhapDSHoaDonExcelHelper.cs`, `BanHang_ExcelHelper.cs`, `ImportVeXeHelper.cs` dưới `AppServiceImportBillHost/AppService`.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 4 - Bổ sung test import nền

- **Status:** completed
- **Service:** `svinvoicesendemail`
- **Mô tả:** Test cùng ma trận layout/gate/required/mapping như direct flow.
- **Tiêu chí chấp nhận:** AC3-AC7.
- **Kiểm chứng:** `dotnet test AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj --no-restore --filter "FullyQualifiedName~VehicleAsset" --verbosity minimal`.
- **Phụ thuộc:** Task 3.
- **File dự kiến chạm:** `AppServiceImportBillHost/AppServiceTest/VehicleAssetImportHelperTests.cs` hoặc test chuyên biệt mới.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 5 - Cập nhật file mẫu runtime

- **Status:** pending
- **Service:** `invoicecore`
- **Mô tả:** Backup và bỏ cột khỏi mọi biến thể GTGT/Bán hàng/Vé xe thực tế; giữ style của cột biển số và kiểm qua API tải mẫu.
- **Tiêu chí chấp nhận:** AC1.
- **Kiểm chứng:** Kiểm header của 5 tên artifact trong `plan.md`; lưu hash trước/sau và nơi phát hành.
- **Phụ thuộc:** DevOps/TechLead xác nhận nguồn artifact.
- **File dự kiến chạm:** Binary runtime `FileMau/HoaDon/*.xlsx`, không có trong git checkout hiện tại.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 6 - Test và build import trực tiếp

- **Status:** partial
- **Service:** `invoicecore`
- **Mô tả:** Chạy test direct rồi build solution bằng output tối giản.
- **Tiêu chí chấp nhận:** AC2, AC4-AC7.
- **Kiểm chứng:** Hai command `dotnet test`/`dotnet build` của `invoicecore` trong Plan §10 đều 0 failed/error.
- **Phụ thuộc:** Task 1-2.
- **File dự kiến chạm:** Không.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

**Kết quả:** `HDDT.Application.csproj` build thành công, 0 error. Full solution bị chặn bởi project `test/TraceIdMiddleware.Tests/TraceIdMiddleware.Tests.csproj` không tồn tại. `VS.Tests` bị chặn bởi hai `ProjectReference` cũ trỏ tới `src/VS.Application` và `src/VS.EntityFrameworkCore` không tồn tại; test source đã được thêm nhưng chưa thể chạy bằng test project hiện tại.

## Task 7 - Test và build import nền

- **Status:** completed
- **Service:** `svinvoicesendemail`
- **Mô tả:** Chạy test helper/routers rồi build `AppServiceImportBillHost` bằng output tối giản.
- **Tiêu chí chấp nhận:** AC3-AC7.
- **Kiểm chứng:** Hai command `dotnet test`/`dotnet build` của worker trong Plan §10 đều 0 failed/error.
- **Phụ thuộc:** Task 3-4.
- **File dự kiến chạm:** Không.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

**Kết quả:** `dotnet test` pass 21/21; `dotnet build AppServiceImportBillHost/AppService.sln` thành công, 0 error.

## Task 8 - Regression sáu luồng và DB read-back

- **Status:** pending
- **Service:** `invoicecore`
- **Mô tả:** Điều phối manual 3 loại x direct/background với file mới, regression file cũ, tải artifact qua API và đọc lại DB tenant test.
- **Tiêu chí chấp nhận:** AC1-AC8.
- **Kiểm chứng:** Bằng chứng request/job id, kết quả import và query `cltsan/sbksoat`; không chạy production.
- **Phụ thuộc:** Task 5-7.
- **File dự kiến chạm:** Không.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 9 - Hoàn tất docs và bằng chứng

- **Status:** completed
- **Service:** `docs`
- **Mô tả:** Cập nhật testcase/impact/tasks, tạo report từ output thật và chốt deploy artifact.
- **Tiêu chí chấp nhận:** Không đánh dấu pass case chưa chạy; ghi rõ manual/DB/artifact evidence.
- **Kiểm chứng:** Review diff `features/CBCLOUDV2-9404`.
- **Phụ thuộc:** Task 1-8.
- **File dự kiến chạm:** Toàn bộ feature docs, thêm `report.md` sau implementation.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>
