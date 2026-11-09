---
feature: CBCLOUDV2-9367
status: implemented
updated_at: 2026-09-11
---

# Report — CBCLOUDV2-9367

## 2026-09-10
- Đã điều chỉnh docs để trỏ đúng source `D:\XBill\Cloud\api-cloud-service` thay vì `invoicecore`.
- Đã đọc source API và xác nhận hiện có `ma_tinh`, `ma_xa`, `MDVQHNS`; chưa có `ten_tinh`, `ten_xa` trong entity mở rộng/API input/XML buyer node.
- Chưa code trong `api-cloud-service`.

## 2026-09-10 - Correction maxlength TTinh/TXa
- User cung cấp bảng XML: Tên tỉnh <TTinh> chuỗi ký tự tối đa 50, Tên xã <TXa> chuỗi ký tự tối đa 50.
- Đã cập nhật Plan/Expect/Deploy/Testcase để validate API và DB script đề xuất theo max 50 thay vì 255.

## 2026-09-10 - Implementation
- Đã bổ sung API input `ten_tinh`, `ten_xa` cho `GuiHDGoc`, `GuiHoaDonTT`, `GuiHoaDonDC`.
- Đã bổ sung entity `HD_HoaDon_MoRong.ten_tinh`, `HD_HoaDon_MoRong.ten_xa`.
- Đã map lưu `ten_tinh`, `ten_xa` trong `GuiHoaDonAppService` khi `ACTIVE_ND_254 = "1"` và có dòng Hàng hóa đặc trưng 1; đồng thời giữ dữ liệu này khi hóa đơn rơi vào nhánh mở rộng đặc thù.
- Đã validate maxlength: `Tên tỉnh không được vượt quá 50 ký tự.`, `Tên xã không được vượt quá 50 ký tự.`
- Đã bổ sung XML buyer node `TTinh`, `TXa` và map từ `HD_HoaDon_MoRong`.
- Verification: `dotnet build D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Core\WS.Core.csproj --no-restore --verbosity quiet` pass; `WS.Application.csproj` pass; `WS.EntityFrameworkCore.csproj` pass.
- Full solution `VS.WS.sln` chưa pass do project nền `src\zero\VS.Migrator`/`VS.Web.Core` thiếu dependency/analyzer và lỗi target `netcoreapp2.2`, không trỏ trực tiếp vào file task.
- Unit test: đã bổ sung `BuyerLocationNameTests.cs` cho boundary 50/51, feature gate, entity mapping và XML `TTinh/TXa`; đồng thời cập nhật các test hóa đơn đặc trưng hiện có theo chữ ký mới. Chạy `dotnet test D:\XBill\Cloud\api-cloud-service\test\WS.Application.Tests\WS.Application.Tests.csproj --no-restore --verbosity quiet` pass 42/42, fail 0, skip 0.

## 2026-09-10 - Correction gate ACTIVE_ND_254
- Theo yêu cầu mới, đã thay toàn bộ gate request `version = "1"` trong `GuiHoaDonAppService` bằng cấu hình global `ACTIVE_ND_254`.
- `IsActiveND254()` ưu tiên Redis Hash `QLCAUHINH.ACTIVE_ND_254`, fallback host DB `vs_dm_ncc_cauhinh`; thiếu/lỗi trả `false`.
- DTO `version` được giữ lại để tương thích API nhưng không còn điều khiển nhóm Hàng hóa đặc trưng 1.
- Unit test gate ND254 pass 10/10.

## 2026-09-11 - Gate XML ACTIVE_ND_254
- Đã dùng cùng checker `ACTIVE_ND_254` cho tầng nhận/lưu API và utility sinh XML TT78.
- Khi cờ tắt/thiếu/lỗi, XML sinh lại không còn `MTinh/MXa/TTinh/TXa` và 15 trường xe NĐ254 dù DB còn dữ liệu lịch sử; vẫn giữ các thẻ cũ như `SKhung`, `SMay`.
- XML đã ký lưu trên FTP không bị sửa.
- Verification: unit test pass 27/27; build riêng `WS.Core`, `WS.Application`, `WS.EntityFrameworkCore` đều pass, 0 error.


