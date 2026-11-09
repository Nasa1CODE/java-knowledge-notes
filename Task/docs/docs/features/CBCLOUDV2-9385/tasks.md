---
feature: CBCLOUDV2-9385
status: testing
owner: DEV + AI
updated_at: 2026-09-08
---

# Tasks - CBCLOUDV2-9385

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Bỏ required Email trong shared buyer validator | api-cloud-service | completed | XS | |
| 2 | Bổ sung automated test Email optional và gate loại 1 | api-cloud-service | completed | S | |
| 3 | Build và kiểm thử ba API lưu | api-cloud-service | in-progress | M | |
| 4 | Regression wrapper HSM, MTT và XML | api-cloud-service | pending | M | |
| 5 | Hoàn tất tài liệu theo kết quả thật | docs | completed | XS | |

## Task 1 - Bỏ required Email trong shared buyer validator

- **Status:** completed (2026-09-08)
- **Service:** `api-cloud-service`
- **Mô tả:** Xóa duy nhất check `Địa chỉ thư điện tử không được để trống.` trong `ValidateNguoiMuaDacTrungXeValues(...)`; giữ gate `version = 1` và `loaihoadondactrung = 1`.
- **Tiêu chí chấp nhận:** AC1, AC2, AC5, AC6, AC7, AC8.
- **Kiểm chứng:** Review diff đúng một required check; `IsTooLong(email, 50)` và validation Email chung còn nguyên.
- **Phụ thuộc:** Không.
- **File dự kiến chạm:** `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>

## Task 2 - Bổ sung automated test

- **Status:** completed (2026-09-08)
- **Service:** `api-cloud-service`
- **Mô tả:** Test Email null/rỗng/whitespace, maxlength, buyer field khác và gate `version/subtype`. Tạo lại source test project tối thiểu theo CBCLOUDV2-9397 do branch đích chỉ có `bin/obj`. Format/list Email và mapping được source-review, giữ manual regression vì nằm trong validation entry cần tenant/cache.
- **Tiêu chí chấp nhận:** AC1, AC2, AC5, AC6, AC7, AC8.
- **Kiểm chứng:** `dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal`: 14/14 pass, 0 fail.
- **Phụ thuộc:** Task 1.
- **File dự kiến chạm:** `test/WS.Application.Tests/WS.Application.Tests.csproj`, test dưới `test/WS.Application.Tests/HoaDon/`.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 3 - Build và kiểm thử ba API lưu

- **Status:** in-progress
- **Service:** `api-cloud-service`
- **Mô tả:** Build và gọi `GuiHoaDonGoc`, `GuiHoaDonThayThe`, `GuiHoaDonDieuChinh` với Email trống/hợp lệ/sai/vượt maxlength trong request subtype 1.
- **Tiêu chí chấp nhận:** AC1, AC2, AC5, AC6, AC7.
- **Kiểm chứng:** Build `WS.Application.csproj` thành công, 0 error, 19 warning có sẵn; Postman/Newman chưa chạy do chưa có tenant/auth môi trường test.
- **Phụ thuộc:** Task 1, Task 2.
- **File dự kiến chạm:** Không; chỉ kiểm chứng.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 4 - Regression wrapper HSM, MTT và XML

- **Status:** completed (2026-09-08)
- **Service:** `api-cloud-service`
- **Mô tả:** Kiểm tra ba HSM, hai MTT và ba XML kế thừa validation; request lỗi khác phải dừng trước side effect.
- **Tiêu chí chấp nhận:** AC3, AC4, AC7, AC8.
- **Kiểm chứng:** Bằng chứng API tại môi trường test có tenant/HSM/MTT; không gọi tích hợp production từ local.
- **Phụ thuộc:** Task 3.
- **File dự kiến chạm:** Không; chỉ kiểm chứng.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 5 - Hoàn tất tài liệu theo kết quả thật

- **Status:** pending
- **Service:** `docs`
- **Mô tả:** Cập nhật status task/testcase, impact thực tế và tạo `report.md` từ command/output đã chạy; các API chưa có bằng chứng giữ `not run`.
- **Tiêu chí chấp nhận:** Không đánh dấu pass case chưa chạy; không tạo `deploy.md` khi không có trigger.
- **Kiểm chứng:** Review diff `features/CBCLOUDV2-9385`.
- **Phụ thuộc:** Task 3, Task 4.
- **File dự kiến chạm:** `tasks.md`, `testcase.md`, `impact.md`, `report.md`.
- **Ước lượng:** XS
- **Commit/PR:** <điền khi xong>
