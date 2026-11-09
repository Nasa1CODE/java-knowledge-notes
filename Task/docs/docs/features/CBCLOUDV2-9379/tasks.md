---
feature: CBCLOUDV2-9379
status: testing
owner: DEV + AI
updated_at: 2026-09-08
---

# Tasks - CBCLOUDV2-9379

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Kiểm tra dependency DB CBCLOUDV2-9260 | api-cloud-service | pending | XS | |
| 2 | Điều chỉnh bảy maxlength trong shared validators | api-cloud-service | completed | S | |
| 3 | Bổ sung automated test boundary/gate | api-cloud-service | completed | S | |
| 4 | Build và kiểm thử ba API lưu | api-cloud-service | in-progress | M | |
| 5 | Regression HSM, MTT và XML | api-cloud-service | pending | M | |
| 6 | Hoàn tất feature docs | docs | completed | XS | |

## Task 1 - Kiểm tra dependency DB CBCLOUDV2-9260

- **Status:** pending
- **Service:** `api-cloud-service`
- **Mô tả:** Xác nhận năm cột tenant DB đã được mở rộng 255/400 trước deploy API.
- **Tiêu chí chấp nhận:** AC7.
- **Kiểm chứng:** Output `information_schema.COLUMNS` theo `features/CBCLOUDV2-9260/deploy.md`.
- **Phụ thuộc:** CBCLOUDV2-9260.
- **File dự kiến chạm:** Không.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>

## Task 2 - Điều chỉnh bảy maxlength trong shared validators

- **Status:** completed
- **Service:** `api-cloud-service`
- **Mô tả:** Thêm helper đếm ký tự phạm vi hẹp; đổi Mã tỉnh 2, Mã xã 5, bốn field 255 và Tên thương mại 400 tại buyer/detail validator.
- **Tiêu chí chấp nhận:** AC1-AC5, AC8.
- **Kiểm chứng:** Diff chỉ có bảy call-site và helper; `git diff --check` sạch.
- **Phụ thuộc:** Không.
- **File dự kiến chạm:** `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 3 - Bổ sung automated test boundary/gate

- **Status:** completed
- **Service:** `api-cloud-service`
- **Mô tả:** Test reflection shared buyer/detail validator cho bảy field N/N+1, Unicode, version/subtype negative và regression field ngoài scope.
- **Tiêu chí chấp nhận:** AC1-AC5.
- **Kiểm chứng:** `dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal` -> toàn bộ test pass.
- **Phụ thuộc:** Task 2.
- **File dự kiến chạm:** `test/WS.Application.Tests/HoaDon/VehicleAssetMaxLengthRuleTests.cs`; giữ file test task trước.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 4 - Build và kiểm thử ba API lưu

- **Status:** in-progress
- **Service:** `api-cloud-service`
- **Mô tả:** Build và gọi gốc/thay thế/điều chỉnh với bảy boundary, gate true/false và DB read-back.
- **Tiêu chí chấp nhận:** AC1-AC5, AC7, AC8.
- **Kiểm chứng:** Build 0 error; Postman/Newman hoặc log/mã giao dịch tenant test.
- **Phụ thuộc:** Task 1-3.
- **File dự kiến chạm:** Không.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 5 - Regression HSM, MTT và XML

- **Status:** pending
- **Service:** `api-cloud-service`
- **Mô tả:** Kiểm tra 3 HSM, 2 MTT, 3 XML kế thừa validation; lỗi phải dừng trước side effect.
- **Tiêu chí chấp nhận:** AC6-AC8.
- **Kiểm chứng:** Bằng chứng môi trường test; không gọi HSM/CQT production từ local.
- **Phụ thuộc:** Task 4.
- **File dự kiến chạm:** Không.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 6 - Hoàn tất feature docs

- **Status:** completed
- **Service:** `docs`
- **Mô tả:** Cập nhật status/testcase/impact/report từ output thật và dependency deploy.
- **Tiêu chí chấp nhận:** Không đánh dấu pass case chưa chạy; Definition of Done docs.
- **Kiểm chứng:** Review diff `features/CBCLOUDV2-9379`.
- **Phụ thuộc:** Task 1-5.
- **File dự kiến chạm:** Toàn bộ feature docs, thêm `report.md` khi implementation.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>
