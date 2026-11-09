---
feature: CBCLOUDV2-9466
status: in-progress
owner: TBD — owner: DEV / TechLead
updated_at: 2026-09-16
---

# Impact Assessment — CBCLOUDV2-9466: Xử lý thông điệp 112 trên BillCloud

## 1. Phạm vi tác động kỹ thuật

| Dịch vụ / Hệ thống | Mức độ tác động | Chi tiết tác động |
| :--- | :---: | :--- |
| `etran-teanant-service` | Trung bình (M) | Bổ sung service `ThongDiep112Service.java` và định tuyến trong `ProcessService.java`. Không làm thay đổi các luồng xử lý thông điệp hiện hữu (102, 103, 104, 301,...). |
| Database Schema | Không (None) | Tận dụng hoàn toàn cấu trúc bảng hiện tại (`vs_service_tax`, `vs_dn_register_tax`, `vs_transaction_log`), không cần migration. |
| External APIs / Contracts | Không (None) | Không thay đổi contract API bên ngoài. Tự động hỗ trợ gọi callback API TK01 nếu tenant có đăng ký. |

## 2. Rủi ro & Giải pháp phòng ngừa

1. **Rủi ro CQT gửi thông điệp 112 trước khi có bản ghi `VsServiceTax`**:
   - **Giải pháp:** Áp dụng cơ chế lưu vào `vs_thongdiep_dangxuly` tương tự như thông điệp 102 để `ScheduleService` tự động retry xử lý lại khi có dữ liệu.
