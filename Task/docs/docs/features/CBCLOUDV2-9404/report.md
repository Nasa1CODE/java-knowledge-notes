---
feature: CBCLOUDV2-9404
status: testing
updated_at: 2026-09-08
---

# Report - CBCLOUDV2-9404

## Đã thực hiện

- Bỏ cột, parser, validation và mapping `Chất lượng tài sản` khỏi import Hàng hóa đặc trưng loại 1.
- Giữ gate nghiệp vụ `loaihanghoa == 4 && loaidactrung == 1`.
- Dịch `Số biển kiểm soát` và `LastColumn`: GTGT 72, Bán hàng 63, Vé xe 61 ở cả direct/background.
- Nhận diện header để hỗ trợ đồng thời file mới và file cũ; quality trong file cũ bị bỏ qua.
- Giữ entity, DB `cltsan`, repository, API/XML và dữ liệu cũ.

## File code

- `invoicecore`: `NhapDSHoaDonExcelHelper.cs`, `ExcelAudience.cs`, `VehicleAssetImportSource_Tests.cs`.
- `svinvoicesendemail`: `VehicleAssetImportHelper.cs`, `HoaDonRow.cs`, ba helper GTGT/Bán hàng/Vé xe, `VehicleAssetQualityRemovalTests.cs`; fixture maxlength hiện có được dịch theo layout mới.

## Bằng chứng

| Kiểm tra | Kết quả |
|---|---|
| Worker unit test | Pass 21/21, 0 failed |
| Worker solution build | Thành công, 0 error |
| `HDDT.Application` build | Thành công, 0 error |
| Full `invoicecore` solution | Không hoàn tất: thiếu project `TraceIdMiddleware.Tests` trong solution |
| `invoicecore` test project | Không chạy được: hai `ProjectReference` hiện hữu trỏ tới project không tồn tại |
| `git diff --check` | Sạch ở cả hai repo |

## Còn chờ

- Cập nhật và phát hành 5 file mẫu Excel runtime theo `deploy.md`.
- Chạy manual sáu luồng direct/background trên tenant test và DB read-back.
- Không commit hoặc push vì người dùng chưa yêu cầu.
