# Report - CBCLOUDV2-9397

## 1. Đã làm gì

- Sửa shared validator để 9 field chỉ required khi `tinhTrangTaiSan = 1`.
- Không thêm điều kiện theo `loaiTaiSan`.
- Giữ nguyên invalid sentinel, numeric format, maxlength và các rule nền.
- Tạo test project HDDT tối thiểu và 20 automated test.

## 2. File đã thay đổi

| File | Thay đổi |
|---|---|
| `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs` | Sửa required condition trong `ValidateHangHoaDacTrungXeValues(...)` |
| `test/WS.Application.Tests/WS.Application.Tests.csproj` | Tạo test project xUnit target `netcoreapp3.1` |
| `test/WS.Application.Tests/HoaDon/VehicleAssetRequiredRuleTests.cs` | Test 9 field, hai loại tài sản, invalid/format/maxlength và regression |

## 3. Kết quả kiểm chứng

### Tự động

| # | Lệnh đã chạy | Kết quả |
|---|---|---|
| 1 | `dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal` | Passed 20, failed 0, skipped 0 |
| 2 | `dotnet build src/hddt/WS.Application/WS.Application.csproj --no-restore --verbosity minimal` | Build succeeded; 19 warnings, 0 errors |
| 3 | `git diff --check` | Không có whitespace error; chỉ có cảnh báo LF/CRLF của Git |

Warning build là warning có sẵn của runtime/package .NET Core 2.2 và duplicate `System.ComponentModel.Annotations`; không phát sinh từ logic CBCLOUDV2-9397.

### Thủ công

Chưa chạy API thật.

### Chưa chạy được

| Việc | Vì sao |
|---|---|
| 3 API lưu | Chưa có cấu hình tenant/auth và dữ liệu API test trong phiên local |
| 3 wrapper HSM | HSM không khả dụng local |
| 2 API MTT | Có side effect cấp số, ký và gửi CQT; không gọi từ dev local |
| 3 wrapper XML | Cần môi trường API và payload XML tích hợp |
| Cách ly hai tenant | Chưa có hai tenant test local |

## 4. Sai khác so với plan

| Điểm khác | Lý do |
|---|---|
| Code trực tiếp trên `manh/dev_v2` | Người dùng chỉ định, không tạo feature branch |
| Bỏ qua Gate 1 | Người dùng chỉ định trực tiếp ngày 2026-09-07 |
| Tạo lại `test/WS.Application.Tests` | Source test project không tồn tại trên branch; chỉ có dấu vết trong commit tạm |

## 5. Việc còn lại

- QA/DEV chạy TC-07, TC-08, TC-09, TC-13, TC-15 và TC-16 trên môi trường test.
- Chưa commit/push.

## 6. Đề xuất cập nhật docs (Gate 2)

- Docs/specs: N/A; không đổi API shape, schema, XML hoặc kiến trúc, chỉ điều chỉnh required validation của feature đã có.
- Feature docs đã cập nhật theo kết quả thật tại `features/CBCLOUDV2-9397`.

## 7. Link commit / PR

| Service | Commit / PR |
|---|---|
| api-cloud-service | Chưa tạo |
| docs | Chưa tạo |
