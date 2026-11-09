---
feature: CBCLOUDV2-9367
updated_at: 2026-09-10
---

# Tasks — CBCLOUDV2-9367

| # | Task | Service | Status | Size | Notes |
|---|---|---|---|---|---|
| 1 | Bổ sung DTO input `ten_tinh`, `ten_xa` | api-cloud-service | done | S | `GuiHDGoc.cs`, `GuiHoaDonTT.cs`, `GuiHoaDonDC.cs` |
| 2 | Bổ sung entity DB mở rộng | api-cloud-service | done | S | `HD_HoaDon_MoRong.cs` |
| 3 | Map save/update địa bàn đặc trưng | api-cloud-service | done | M | `GuiHoaDonAppService.MapDiaBanDacTrung` và call site |
| 4 | Map XML buyer node | api-cloud-service | done | S | `NMua.cs`, `HoaDonTT3278Utility.cs` |
| 5 | Build và ghi report | api-cloud-service | done | S | Build riêng `WS.Core`, `WS.Application`, `WS.EntityFrameworkCore` pass; full solution còn fail do project `zero`/dependency nền |
| 6 | Bổ sung và chạy unit test | api-cloud-service | done | S | `BuyerLocationNameTests.cs`; toàn bộ `WS.Application.Tests` pass 42/42 |

## Files To Review / Change
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\DataTransferObjects\GuiHoaDon\GuiHDGoc.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\DataTransferObjects\GuiHoaDon\GuiHoaDonTT.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\DataTransferObjects\GuiHoaDon\GuiHoaDonDC.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Core\Domains\HoaDon\QuanLyHoaDon\HD_HoaDon_MoRong.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\AppServices\HoaDon\GuiHoaDonAppService.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\Commons\HoaDon\XmlHoaDonTT78\DuLieuHoaDon\NoiDungHoaDon\NMua.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\Commons\HoaDon\HoaDonTT3278Utility.cs`

