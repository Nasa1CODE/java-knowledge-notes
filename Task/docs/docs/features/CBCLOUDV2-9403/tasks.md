---
feature: CBCLOUDV2-9403
status: testing
updated_at: 2026-09-08
---

# Tasks - CBCLOUDV2-9403

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Bỏ field khỏi ba request DTO | api-cloud-service | completed | S | |
| 2 | Bỏ validation và mapping quality | api-cloud-service | completed | M | |
| 3 | Bỏ `CLTSan` khỏi XML loại 1 | api-cloud-service | completed | S | |
| 4 | Bổ sung/cập nhật automated test | api-cloud-service | completed | M | |
| 5 | Build và test ba API lưu | api-cloud-service | in-progress | M | |
| 6 | Regression HSM, MTT, XML và DB | api-cloud-service | pending | M | |
| 7 | Hoàn tất docs và bằng chứng | docs | completed | S | |

## Task 1 - Bỏ field khỏi ba request DTO

- **Status:** completed
- **Service:** `api-cloud-service`
- **Mô tả:** Xóa property `chatluongtaisan` và attribute converter tương ứng khỏi `ChiTietHDG`, `ChiTietTT`, `ChiTietDC`; không xóa converter dùng chung.
- **Tiêu chí chấp nhận:** AC1, AC3.
- **Kiểm chứng:** Reflection/Swagger schema không còn property; JSON payload cũ có property dư vẫn deserialize được.
- **Phụ thuộc:** Gate 1 xác nhận thay đổi contract.
- **File dự kiến chạm:** `GuiHDGoc.cs`, `GuiHoaDonTT.cs`, `GuiHoaDonDC.cs` dưới `DataTransferObjects/GuiHoaDon`.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 2 - Bỏ validation và mapping quality

- **Status:** completed
- **Service:** `api-cloud-service`
- **Mô tả:** Bỏ tham số quality khỏi ba overload validate/map và shared methods; xóa ba check required/type/precision và assignment `mr.cltsan`; giữ gate subtype 1, biển số và field khác.
- **Tiêu chí chấp nhận:** AC2, AC3, AC5-AC8.
- **Kiểm chứng:** Source review call chain và test helper; `rg` chỉ còn `cltsan` tại domain/XML ngoài scope.
- **Phụ thuộc:** Task 1.
- **File dự kiến chạm:** `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 3 - Bỏ `CLTSan` khỏi XML loại 1

- **Status:** completed
- **Service:** `api-cloud-service`
- **Mô tả:** Bỏ `cltsan.HasValue` khỏi nhận diện dữ liệu xe, bỏ dòng thêm `CLTSan` vào `TTinDacTrung`, xóa constant không còn dùng; giữ entity/cột DB.
- **Tiêu chí chấp nhận:** AC8, AC9.
- **Kiểm chứng:** XML loại 1 mới và lịch sử không có `CLTSan`; XML loại 2/3 không đổi; `rg` không còn `ConstantTTin.CLTSan`.
- **Phụ thuộc:** Task 2.
- **File dự kiến chạm:** `HoaDonTT3278Utility.cs`, `XmlHoaDonTT78/ThongTinKhac/TTin.cs`.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

## Task 4 - Bổ sung/cập nhật automated test

- **Status:** completed
- **Service:** `api-cloud-service`
- **Mô tả:** Test DTO contract, validator không còn quality, biển số vẫn required, negative gate, mapper để `cltsan` null, JSON compatibility; cập nhật reflection fixture maxlength hiện có theo signature mới.
- **Tiêu chí chấp nhận:** AC1-AC9.
- **Kiểm chứng:** `dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal` pass, 0 failed.
- **Phụ thuộc:** Task 1-3.
- **File dự kiến chạm:** Các file `*VehicleAsset*Tests.cs` dưới `test/WS.Application.Tests/HoaDon/`.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 5 - Build và test ba API lưu

- **Status:** in-progress
- **Service:** `api-cloud-service`
- **Mô tả:** Build project, gọi API gốc/thay thế/điều chỉnh với payload mới, payload cũ còn quality, thiếu biển số và negative gate.
- **Tiêu chí chấp nhận:** AC2, AC3, AC5-AC7.
- **Kiểm chứng:** Build 0 error; bằng chứng Postman/Newman và query tenant test.
- **Phụ thuộc:** Task 1-4.
- **File dự kiến chạm:** Không; chỉ kiểm chứng.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 6 - Regression HSM, MTT, XML và DB

- **Status:** pending
- **Service:** `api-cloud-service`
- **Mô tả:** Chạy 3 HSM, 2 MTT, 3 XML trên tenant test; xác nhận lỗi khác dừng trước side effect, XML cũ/mới không sinh `CLTSan` và dữ liệu `cltsan` trong DB không bị cập nhật.
- **Tiêu chí chấp nhận:** AC4, AC8, AC9.
- **Kiểm chứng:** Request/response hoặc transaction id test, DB read-back; không dùng production.
- **Phụ thuộc:** Task 4 và môi trường tích hợp.
- **File dự kiến chạm:** Không; chỉ kiểm chứng.
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

## Task 7 - Hoàn tất docs và bằng chứng

- **Status:** completed
- **Service:** `docs`
- **Mô tả:** Cập nhật trạng thái, impact thực tế, testcase và report; đề xuất diff `specs/system.md` qua Gate 2; cập nhật báo cáo token.
- **Tiêu chí chấp nhận:** Không đánh dấu pass khi thiếu bằng chứng; ghi rõ branch/worktree và phần chưa chạy.
- **Kiểm chứng:** Review diff `features/CBCLOUDV2-9403` và `Token/CBCLOUDV2-9403.md`.
- **Phụ thuộc:** Task 1-6.
- **File dự kiến chạm:** Feature docs, `report.md` sau implementation; đề xuất `specs/system.md`.
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>
