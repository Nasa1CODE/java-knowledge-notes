---
feature: CBCLOUDV2-9373
updated_at: 2026-09-10
---

# Tasks — CBCLOUDV2-9373

| # | Task | Service | Status | Size | Notes |
|---|---|---|---|---|---|
| 1 | Bổ sung DTO input quốc tịch | api-cloud-service | done | S | `GuiHDGoc.cs`, `GuiHoaDonTT.cs`, `GuiHoaDonDC.cs` |
| 2 | Bổ sung entity DB mở rộng | api-cloud-service | done | S | `HD_HoaDon_MoRong.cs` |
| 3 | Map save/update và validate maxlength | api-cloud-service | done | M | `GuiHoaDonAppService.cs` |
| 4 | Map XML `QTNMua/MQTNMua` | api-cloud-service | done | S | `NMua.cs`, `HoaDonTT3278Utility.cs` |
| 5 | Bổ sung danh mục `DM_NCC_QuocTich/GetAllNoPage` | api-cloud-service | done | M | Theo pattern `DM_NCC_TinhThanhAppService` |
| 6 | Build và ghi report | api-cloud-service | done | S | Build riêng `WS.Core`, `WS.Application`, `WS.EntityFrameworkCore` pass; full solution còn fail do project `zero`/dependency nền |
| 7 | Bổ sung và chạy unit test | api-cloud-service | done | M | `BuyerNationalityTests.cs`; toàn bộ `WS.Application.Tests` pass 42/42 |

## Files To Review / Change
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\DataTransferObjects\GuiHoaDon\GuiHDGoc.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\DataTransferObjects\GuiHoaDon\GuiHoaDonTT.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\DataTransferObjects\GuiHoaDon\GuiHoaDonDC.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Core\Domains\HoaDon\QuanLyHoaDon\HD_HoaDon_MoRong.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\AppServices\HoaDon\GuiHoaDonAppService.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\Commons\HoaDon\XmlHoaDonTT78\DuLieuHoaDon\NoiDungHoaDon\NMua.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\Commons\HoaDon\HoaDonTT3278Utility.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\AppServices\DanhMuc\DMNhaCungCap\DM_NCC_QuocTichAppService.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\WS.Application.csproj`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Application\DataTransferObjects\DanhMuc\DMNhaCungCap\DMNCCQuocTich\*.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.Core\Domains\DanhMuc\DMNhaCungCap\DM_NCC_QuocTich.cs`
- `D:\XBill\Cloud\api-cloud-service\src\hddt\WS.EntityFrameworkCore\EntityFrameworkCore\HDDTDbContext.cs`
