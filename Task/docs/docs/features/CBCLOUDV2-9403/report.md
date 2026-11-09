---
feature: CBCLOUDV2-9403
status: testing
services: [api-cloud-service]
updated_at: 2026-09-08
---

# Report - CBCLOUDV2-9403

## 1. Kết quả triển khai

- Bỏ qua Gate 1 theo xác nhận trực tiếp của user ngày 2026-09-08; triển khai trên nhánh hiện tại `manh/dev_v2`.
- Xóa `chatluongtaisan` khỏi ba request detail DTO của API gốc, thay thế và điều chỉnh.
- Bỏ toàn bộ validation và mapping `chatluongtaisan` cho Hàng hóa đặc trưng loại 1; giữ nguyên gate `version = "1"`, `loaihoadondactrung = 1`, biển số và các rule khác.
- XML mới và XML sinh lại từ dữ liệu lịch sử không còn xuất `TTin` có `TTruong = "CLTSan"`.
- Giữ entity/cột DB `cltsan` và dữ liệu cũ; không có migration.

## 2. File production thay đổi

| Nhóm | File | Thay đổi |
|---|---|---|
| DTO | `GuiHDGoc.cs`, `GuiHoaDonTT.cs`, `GuiHoaDonDC.cs` | Bỏ property và converter quality |
| Nghiệp vụ | `AppServices/HoaDon/GuiHoaDonAppService.cs` | Bỏ tham số, validation và assignment `cltsan` |
| XML | `Commons/HoaDon/HoaDonTT3278Utility.cs` | Bỏ nhận diện và sinh node `CLTSan` |
| XML constant | `XmlHoaDonTT78/ThongTinKhac/TTin.cs` | Bỏ constant `CLTSan` |

## 3. Test thay đổi

- Thêm `VehicleAssetQualityRemovalTests.cs` kiểm tra DTO, JSON cũ, validator, mapper, biển số và XML source contract.
- Cập nhật fixture reflection trong `VehicleAssetMaxLengthRuleTests.cs` theo chữ ký validator mới.
- Thư mục `test/WS.Application.Tests/` đã untracked từ các task trước; giữ nguyên các test CBCLOUDV2-9379/9385 đang có.

## 4. Verification thực tế

```text
dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal
Passed: 33, Failed: 0, Skipped: 0
```

```text
dotnet build src/hddt/WS.Application/WS.Application.csproj --no-restore --verbosity minimal
Build succeeded. 19 Warning(s), 0 Error(s)
```

```text
git diff --check
exit code 0
```

Targeted source scan không còn `chatluongtaisan`, `chatLuongTaiSan`, `ConstantTTin.CLTSan` hoặc `cltsan.HasValue` trong sáu file production đã sửa.

## 5. Chưa kiểm chứng

- Chưa có tenant/auth để gọi trực tiếp ba API lưu, ba wrapper HSM, hai API MTT và ba API XML.
- Chưa đọc lại DB tenant test để xác nhận bản ghi mới có `cltsan = null` và dữ liệu lịch sử không đổi.
- Chưa sinh XML runtime từ hóa đơn lịch sử; automated test đã khóa source renderer không còn tham chiếu `CLTSan`.
- Không gọi HSM/CQT production từ local.

## 6. Cảnh báo ngoài scope

- Build có 19 warning legacy, gồm advisory của `Microsoft.NETCore.App 2.2.0` và duplicate `PackageReference`; task không thay dependency.

## 7. Git

- Branch: `manh/dev_v2`.
- Chưa commit/push.
