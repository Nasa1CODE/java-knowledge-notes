---
feature: CBCLOUDV2-9367
updated_at: 2026-09-10
---

# Impact — CBCLOUDV2-9367

API hóa đơn trong `api-cloud-service` bổ sung 2 field tên địa bàn người mua Hàng hóa đặc trưng 1: `ten_tinh`, `ten_xa`.

## Impacted APIs
- `GuiHoaDonAppService.SendInvoice`
- `GuiHoaDonAppService.GuiHoaDonGoc`
- `GuiHoaDonAppService.GuiHoaDonThayThe`
- `GuiHoaDonAppService.GuiHoaDonDieuChinh`
- Các API ký/gửi HSM, token, MTT dùng lại DTO/method trên.

## Not In Scope
- FE dropdown/display.
- Import Excel.
- Quốc tịch người mua, đã tách sang `CBCLOUDV2-9373`.

