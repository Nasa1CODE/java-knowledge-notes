---
feature: CBCLOUDV2-9385
status: testing
service: api-cloud-service
branch: develop_v3
executed_at: 2026-09-08
---

# Report - CBCLOUDV2-9385

## Kết quả triển khai

- Xóa duy nhất required `dnmua_email` trong `ValidateNguoiMuaDacTrungXeValues(...)`.
- Giữ nguyên gate `version = 1` và có ít nhất một chi tiết `loaihoadondactrung = 1`.
- Giữ maxlength Email 50, validation định dạng/danh sách Email, mapping DB/XML, required của các buyer field khác và rule Email riêng theo tenant.
- Không đổi API contract, DTO, database, XML schema, config hoặc dependency production.

## File thay đổi

- `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.
- `test/WS.Application.Tests/WS.Application.Tests.csproj`.
- `test/WS.Application.Tests/HoaDon/VehicleAssetBuyerEmailRuleTests.cs`.

## Automated test

Command:

```powershell
dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal
```

Kết quả cuối: `Passed: 14, Failed: 0, Skipped: 0`, thời gian test 26 ms.

Phạm vi: Email null/rỗng/whitespace, maxlength 51, required các buyer field còn lại, gate version/subtype và danh sách chi tiết null/rỗng.

## Build

Command:

```powershell
dotnet build src/hddt/WS.Application/WS.Application.csproj --no-restore --verbosity minimal
```

Kết quả cuối: `Build succeeded`, 19 warning, 0 error, thời gian 3.59 giây. Warning là cảnh báo dependency .NET Core 2.2 và duplicate `System.ComponentModel.Annotations` đã tồn tại, không phát sinh từ thay đổi task.

## Sự cố khi chạy

- Build đầu tiên chạy song song với test gặp `CS2012` do file `VS.Core.Shared.dll` đang bị tiến trình kia khóa. Chạy lại tuần tự thành công.
- Test đầu tiên lỗi một case do fixture truyền thiếu `hoTenNguoiMua`. Đã sửa dữ liệu test; production code không đổi thêm. Chạy lại 14/14 pass.

## Chưa chạy

- Ba API lưu gốc/thay thế/điều chỉnh.
- Ba wrapper HSM, hai API MTT và ba wrapper XML.
- Regression rule Email riêng trên tenant thực tế.

Lý do: local chưa có tenant/authentication và môi trường tích hợp an toàn cho HSM/MTT/CQT. Các testcase này giữ `not run`; cần QA chạy trên môi trường test trước phát hành.

## Git

- Branch: `develop_v3`.
- Chưa commit, chưa push.
- Không tạo `deploy.md` vì task không có thay đổi triển khai đặc biệt.
