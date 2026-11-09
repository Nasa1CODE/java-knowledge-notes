---
feature: CBCLOUDV2-9379
status: testing
services: [api-cloud-service]
updated_at: 2026-09-08
---

# Report - CBCLOUDV2-9379

## 1. Kết quả triển khai

- Bỏ qua Gate 1 theo xác nhận trực tiếp của user ngày 2026-09-08; không tự điền DEV/TechLead approval.
- Repo không có `manh/dev_2`; triển khai trên nhánh khớp hiện có `manh/dev_v2`.
- Điều chỉnh đúng bảy maxlength cho rule Hàng hóa đặc trưng loại 1 và dùng số ký tự sau `Trim()`.
- Giữ nguyên global byte-length helper và mọi field ngoài danh sách.

## 2. File thay đổi

| Service | File | Thay đổi |
|---|---|---|
| `api-cloud-service` | `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs` | Đổi 7 giới hạn/message; thêm helper ký tự phạm vi hẹp |
| `api-cloud-service` | `test/WS.Application.Tests/HoaDon/VehicleAssetMaxLengthRuleTests.cs` | Test N/N+1, Unicode, gate và regression |

Thư mục test vốn đã untracked từ task trước; file `VehicleAssetBuyerEmailRuleTests.cs` được giữ nguyên và không tính là thay đổi của CBCLOUDV2-9379.

## 3. Verification thực tế

```text
$ dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal
Passed! - Failed: 0, Passed: 25, Skipped: 0, Total: 25, Duration: 49 ms
```

```text
$ dotnet build src/hddt/WS.Application/WS.Application.csproj --no-restore --verbosity minimal
Build succeeded.
19 Warning(s)
0 Error(s)
Time Elapsed 00:00:05.20
```

```text
$ git diff --check
exit code 0
```

## 4. Chưa kiểm chứng

- Chưa có tenant/auth để gọi trực tiếp 3 API lưu, 3 HSM, 2 MTT và 3 XML.
- Chưa truy vấn `information_schema` để xác nhận migration CBCLOUDV2-9260 đã apply trên tenant đích.
- Không gọi HSM/CQT production từ local.

## 5. Cảnh báo ngoài scope

- Build có 19 warning legacy, gồm vulnerability advisory của `Microsoft.NETCore.App 2.2.0` và duplicate `PackageReference`; task này không thay dependency.

## 6. Deploy

Không có SQL riêng. Phải verify/apply DB dependency CBCLOUDV2-9260 trước khi deploy API.

## 7. Git

- Branch: `manh/dev_v2`.
- Chưa commit/push.
