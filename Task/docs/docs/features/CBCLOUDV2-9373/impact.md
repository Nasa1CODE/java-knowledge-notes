---
feature: CBCLOUDV2-9373
updated_at: 2026-09-11
---

# Impact — CBCLOUDV2-9373

API hóa đơn và XML trong `api-cloud-service`: `quoc_tich_nguoi_mua -> <QTNMua>` tối đa 50 ký tự, `ma_quoc_tich_nguoi_mua -> <MQTNMua>` tối đa 2 ký tự.

## Impacted APIs
- `GuiHoaDonAppService.SendInvoice`
- `GuiHoaDonAppService.GuiHoaDonGoc`
- `GuiHoaDonAppService.GuiHoaDonThayThe`
- `GuiHoaDonAppService.GuiHoaDonDieuChinh`
- Các API ký/gửi HSM, token, MTT dùng lại DTO/method trên.
- `DM_NCC_QuocTich/GetAllNoPage` cho danh mục quốc tịch.

## Not In Scope
- FE dropdown/search/disable.
- Import Excel.

## Feature Gate
- API hóa đơn xử lý quốc tịch khi Redis Hash `QLCAUHINH.ACTIVE_ND_254 = "1"`; cache miss/lỗi fallback host DB `vs_dm_ncc_cauhinh`.
- `GuiHoaDonAppService` và `HoaDonTT3278Utility` dùng chung checker transient; kết quả được cache trong vòng đời checker.
- Mỗi entry sinh XML chốt trạng thái một lần và truyền qua context nội bộ, không dùng request `version`.
- Khi tắt/thiếu/lỗi cấu hình, XML sinh lại ẩn `QTNMua/MQTNMua`, bốn thẻ địa bàn và 15 thẻ xe mới dù DB còn dữ liệu lịch sử.
- `SKhung`, `SMay`, `MDVQHNSach` và nhóm thẻ cũ không thuộc NĐ254 không bị ảnh hưởng; `CLTSan` tiếp tục không sinh.

## XML Flows
- HSM: `SignInv`, `SignHSMInvAsync`.
- Token/MTT chưa ký: `KyToken_TaiXMLChuaKyAsync`, `KyToken_TaiXMLMTTChuaKyAsync`.
- POS/MTT: `KyHoaDonMTT` và builder thông điệp.
- XML tạm cho PDF/HTML, chuyển đổi, in nhiều hóa đơn, custom layout và phân trang.
- API tải XML đã ký chỉ trả file bất biến đang lưu trên FTP.
