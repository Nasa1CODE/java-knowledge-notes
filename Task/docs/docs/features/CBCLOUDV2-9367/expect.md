---
feature: CBCLOUDV2-9367
title: "[API] Bổ sung Tên tỉnh, tên xã - Hàng hóa đặc trưng 1"
services-affected: [api-cloud-service]
created_at: 2026-09-10
updated_at: 2026-09-10
---

# Expect — CBCLOUDV2-9367

## Scope
- Chỉ API trong `D:\XBill\Cloud\api-cloud-service`.
- Không sửa FE, không sửa import Excel.

## Acceptance Criteria
- AC-1: API hóa đơn gốc/thay thế/điều chỉnh nhận optional `ten_tinh`, `ten_xa`; mỗi field tối đa 50 ký tự.
- AC-2: Dữ liệu được lưu vào `vs_hd_tonghop_morong.ten_tinh`, `vs_hd_tonghop_morong.ten_xa`.
- AC-3: API get/detail/list liên quan không làm mất 2 field này khi trả dữ liệu hoặc update.
- AC-4: XML buyer node map thêm `TTinh`, `TXa` từ dữ liệu mở rộng; `TTinh/TXa` là chuỗi ký tự tối đa 50, đồng thời giữ nguyên `MTinh`, `MXa`.
- AC-5: Payload cũ không có 2 field mới vẫn hoạt động bình thường.


