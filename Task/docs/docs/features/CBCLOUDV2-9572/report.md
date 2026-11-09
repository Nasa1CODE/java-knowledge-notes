---
feature: CBCLOUDV2-9572
status: implemented
updated_at: 2026-09-14
---

# Report - CBCLOUDV2-9572

## Trạng Thái

Đã tạo bộ tài liệu task trong `D:\XBill\Cloud\docs\features\CBCLOUDV2-9572`.

Đã triển khai code trong `invoicecore` và `svinvoicesendemail`.

Đã rà thêm service nền `D:\XBill\Cloud\svinvoicesendemail`; service này đã được đưa vào Plan vì có helper import riêng.

## Yêu Cầu Đã Ghi Nhận

- Bổ sung validate import cho hàng hóa đặc trưng `1`.
- Kiểm tra đủ import Bán hàng, GTGT, Vé xe.
- Bắt buộc tên đơn vị để map/sinh `<Ten>`.
- Bắt buộc MST/CCCD chủ hộ để map/sinh `<MST>`.
- Bỏ bắt buộc CCCD để map/sinh `<CCCDan>`.
- Rule import vẫn giữ gate qua `ACTIVE_ND_254`/`IsActiveND254()`.

## Kết Quả Triển Khai

- `invoicecore`: đã thêm required `data.tendonvi` và `data.mst` trong `ValidateVehicleAssetImportBuyerFields`.
- `svinvoicesendemail`: đã thêm required `data.tendonvi` và `data.mst` trong `VehicleAssetImportHelper.ValidateBuyerFields`.
- Không thêm required cho `data.cccd`; `<CCCDan>` vẫn optional.
- Không đổi gate `ACTIVE_ND_254`/`IsActiveND254()`.
- Không đổi DB schema, XML schema, mapping, layout file mẫu.

## Kết Quả Rà Service Nền

- `Process.cs` đã đọc `ACTIVE_ND_254` bằng `IsActiveND254()` và truyền `activeND254` vào import GTGT, Bán hàng, Vé xe; không cần sửa gate.
- `Models\VehicleAssetImportHelper.cs`, method `ValidateBuyerFields`, đang là điểm cần sửa chính cho service nền.
- Trước khi sửa, validator nền required `nguoimuahang`, `diachi`, `sdt`; chưa required `tendonvi` và `mst`.
- `<Ten>` đang map từ `tendonvi`, `<MST>` map từ `mst`; đã thêm required hai field này khi có hàng hóa đặc trưng `1`.
- `cccd` hiện không required, chỉ validate độ dài nếu có dữ liệu; giữ nguyên hướng này.

## Verification

- `dotnet build D:\XBill\Cloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\HDDT.Application.csproj`: pass, có warning cũ của solution/package.
- `dotnet test D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppServiceTest\AppServiceTest.csproj`: pass 26/26, có warning target framework/package cũ.

## Việc Cần Làm Tiếp

- Tester chạy manual import theo `testcase.md` trên môi trường có dữ liệu thực tế: Bán hàng, GTGT, Vé xe; import trực tiếp và import nền.
