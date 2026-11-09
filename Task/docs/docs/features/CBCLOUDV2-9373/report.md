---
feature: CBCLOUDV2-9373
status: implemented
updated_at: 2026-09-11
---

# Report — CBCLOUDV2-9373

## 2026-09-10
- Đã điều chỉnh docs để trỏ đúng source `D:\XBill\Cloud\api-cloud-service` thay vì `invoicecore`.
- Đã đọc source API và xác nhận hiện có `ma_tinh`, `ma_xa`, `MDVQHNS`; chưa có `quoc_tich_nguoi_mua`, `ma_quoc_tich_nguoi_mua`, chưa có XML `QTNMua/MQTNMua` trong `NMua.cs`.
- Đã xác nhận source chưa thấy `DM_NCC_QuocTichAppService`; Plan yêu cầu bổ sung endpoint `DM_NCC_QuocTich/GetAllNoPage` theo pattern danh mục nhà cung cấp.
- Chưa code trong `api-cloud-service`.

## 2026-09-10 - Correction version gate quốc tịch
- User chốt `CBCLOUDV2-9373` áp dụng quốc tịch theo `version` thôi, không chỉ Hàng hóa đặc trưng 1.
- Correction này đã được thay thế: API xử lý quốc tịch theo `ACTIVE_ND_254`, không yêu cầu `dschitiet[].loaihoadondactrung == 1` và không phụ thuộc request `version`.


## 2026-09-10 - Correction validate tồn tại quốc tịch
- Khi NĐ254 bật và có `ma_quoc_tich_nguoi_mua`, API phải check mã tồn tại trong danh mục quốc tịch dùng cùng nguồn với `DM_NCC_QuocTich/GetAllNoPage`.
- Nếu mã không tồn tại thì trả `Mã quốc tịch không tồn tại.`; `quoc_tich_nguoi_mua` chỉ validate maxlength 50.

## 2026-09-10 - Correction validate tồn tại mã nước sản xuất
- Bổ sung rule vào Plan/Expect/Testcase: `Mã nước sản xuất` là `dschitiet[].ma_nuocsx`, XML `<MNSXuat>`, DB `vs_hd_chitiet_morong.mnsxuat`.
- Khi NĐ254 bật và dòng chi tiết có `loaihoadondactrung = 1`, API phải check mã tồn tại trong danh mục quốc tịch/quốc gia dùng cùng nguồn với `DM_NCC_QuocTich/GetAllNoPage`.
- Nếu không tồn tại thì trả `Mã nước sản xuất không tồn tại.`


## 2026-09-10 - Correction message API mã nước sản xuất
- Đã sửa message validate mã nước sản xuất trong docs từ style dòng import `Dòng {stt}: Mã nước sản xuất không tồn tại.` sang message API: `Mã nước sản xuất không tồn tại.`

## 2026-09-10 - Implementation
- Đã bổ sung API input `ma_quoc_tich_nguoi_mua`, `quoc_tich_nguoi_mua` cho `GuiHDGoc`, `GuiHoaDonTT`, `GuiHoaDonDC`.
- Đã bổ sung entity `HD_HoaDon_MoRong.ma_quoc_tich_nguoi_mua`, `HD_HoaDon_MoRong.quoc_tich_nguoi_mua`.
- Đã map lưu quốc tịch người mua trong `GuiHoaDonAppService` khi `ACTIVE_ND_254 = "1"`, không phụ thuộc Hàng hóa đặc trưng 1 hoặc request `version`; đồng thời giữ dữ liệu này khi hóa đơn rơi vào nhánh mở rộng đặc thù.
- Đã validate maxlength `ma_quoc_tich_nguoi_mua` tối đa 2 ký tự, `quoc_tich_nguoi_mua` tối đa 50 ký tự.
- Đã validate tồn tại mã quốc tịch và mã nước sản xuất bằng danh mục quốc tịch, ưu tiên Redis key `VS_LIST_NATIONALITY`, fallback DB `vs_dm_ncc_quoctich`.
- Đã bổ sung API danh mục `DM_NCC_QuocTich/GetAllNoPage`, DTO, domain, AutoMapper và `HDDTDbContext.DSQuocTich`.
- Đã bổ sung XML buyer node `QTNMua`, `MQTNMua` và map từ `HD_HoaDon_MoRong`.
- Verification: `dotnet build D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Core\WS.Core.csproj --no-restore --verbosity quiet` pass; `WS.Application.csproj` pass; `WS.EntityFrameworkCore.csproj` pass.
- Full solution `VS.WS.sln` chưa pass do project nền `src\zero\VS.Migrator`/`VS.Web.Core` thiếu dependency/analyzer và lỗi target `netcoreapp2.2`, không trỏ trực tiếp vào file task.
- Unit test: đã bổ sung `BuyerNationalityTests.cs` cho version gate, boundary 2/50, catalog hợp lệ/không hợp lệ, mã nước sản xuất, entity mapping, XML `QTNMua/MQTNMua` và contract `GetAllNoPage`.
- Trong lúc chạy test đã phát hiện `DM_NCC_QuocTichAppService.cs` bị loại khỏi compile bởi `WS.Application.csproj`; đã thêm explicit compile include và bổ sung namespace `VS` cho `VSAppServiceBase`.
- Chạy `dotnet test D:\XBill\Cloud\api-cloud-service\test\WS.Application.Tests\WS.Application.Tests.csproj --no-restore --verbosity quiet` pass 42/42, fail 0, skip 0.

## 2026-09-11 - Gate XML ACTIVE_ND_254
- Tách checker dùng chung cho Redis `QLCAUHINH.ACTIVE_ND_254`, fallback host DB và cache theo vòng đời checker.
- XML TT78 chỉ sinh `QTNMua/MQTNMua` khi NĐ254 bật; khi tắt không sinh lại thẻ từ dữ liệu lịch sử.
- Bốn thẻ địa bàn chỉ sinh khi cờ bật và có chi tiết loại 1; 15 thẻ xe mới chỉ sinh cho chi tiết loại 1 khi cờ bật.
- `PBan` chỉ lên `2.1.1` khi cờ bật và có dữ liệu xe mới; còn lại giữ `2.1.0`.
- Giữ nguyên `SKhung`, `SMay`, `MDVQHNSach` và thẻ cũ; `CLTSan` tiếp tục không sinh.
- Trạng thái được chốt một lần tại đầu mỗi entry XML thường/custom/phân trang và truyền qua context; request `version` không còn điều khiển gate.
- `CBCLOUDV2-9418` quy định quốc tịch độc lập trong luồng Import; riêng `api-cloud-service` theo correction hiện tại của `CBCLOUDV2-9373`, `QTNMua/MQTNMua` vẫn chịu gate NĐ254 nhưng không phụ thuộc có xe.
- XML đã ký lưu trên FTP không bị thay đổi.
- Verification 2026-09-11: unit test pass 27/27, gồm mapping DB cho đủ ba DTO gốc/thay thế/điều chỉnh; build riêng `WS.Core`, `WS.Application`, `WS.EntityFrameworkCore` đều pass, 0 error. Còn cảnh báo nền của target/package .NET Core 2.2 cũ.
- Không tạo bản ghi `HD_HoaDon_MoRong` rỗng khi cờ bật nhưng request không gửi cả mã và tên quốc tịch.
