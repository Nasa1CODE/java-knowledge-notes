# Tasks - CBCLOUDV2-9397

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Sửa required condition của 9 field trong shared validator | api-cloud-service | completed | S | |
| 2 | Bổ sung unit test cho xe mới, xe đã dùng và regression | api-cloud-service | completed | M | |
| 3 | Build và kiểm thử các API tích hợp | api-cloud-service | in-progress | M | |
| 4 | Hoàn tất report và impact theo kết quả thật | docs | completed | XS | |

---

## Task 1 - Sửa shared validator

- **Status:** completed - 2026-09-07
- **Service:** `api-cloud-service`
- **Mô tả:** Chỉ bắt buộc 9 field của CBCLOUDV2-9397 khi `tinhTrangTaiSan = 1`, không phân biệt `loaiTaiSan`.
- **Tiêu chí chấp nhận:** AC1, AC2, AC3, AC5, AC6 trong `expect.md`.
- **Kiểm chứng:** `dotnet build src/hddt/WS.Application/WS.Application.csproj --no-restore` -> 0 error.
- **Phụ thuộc:** Gate 1 được người dùng yêu cầu bỏ qua; branch `manh/dev_v2` được chỉ định trực tiếp.
- **File dự kiến chạm:** `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

---

## Task 2 - Bổ sung unit test

- **Status:** completed - 2026-09-07
- **Service:** `api-cloud-service`
- **Mô tả:** Bao phủ required, invalid value, format, maxlength và trường hợp không phân biệt loại tài sản.
- **Tiêu chí chấp nhận:** AC1-AC6.
- **Kiểm chứng:** `dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal` -> passed 20/20.
- **Phụ thuộc:** Chốt B1 trong `plan.md`; Task 1.
- **File đã chạm:** `test/WS.Application.Tests/WS.Application.Tests.csproj`, `test/WS.Application.Tests/HoaDon/VehicleAssetRequiredRuleTests.cs`.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 3 - Build và kiểm thử API

- **Status:** in-progress - 2026-09-07
- **Service:** `api-cloud-service`
- **Mô tả:** Kiểm tra 3 API lưu, 5 wrapper HSM/MTT và regression 3 wrapper XML.
- **Tiêu chí chấp nhận:** AC4-AC6.
- **Kiểm chứng:** Build 0 error; Postman/Newman cho HSM/MTT/XML chưa chạy do cần tenant DB và tích hợp ký/CQT.
- **Phụ thuộc:** Task 1, Task 2.
- **File dự kiến chạm:** Không; chỉ tạo dữ liệu/bằng chứng test.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 4 - Hoàn tất tài liệu

- **Status:** completed - 2026-09-07
- **Service:** `docs`
- **Mô tả:** Cập nhật trạng thái testcase, impact thật và report có command/output thực tế.
- **Tiêu chí chấp nhận:** Không đánh dấu pass cho case chưa chạy; ghi rõ warning/blocker.
- **Kiểm chứng:** Review diff thư mục `features/CBCLOUDV2-9397`.
- **Phụ thuộc:** Task 3.
- **File dự kiến chạm:** `features/CBCLOUDV2-9397/impact.md`, `testcase.md`, `report.md`.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>
