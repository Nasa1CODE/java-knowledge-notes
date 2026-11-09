---
feature: CBCLOUDV2-9572
title: "[Import] [CLOUD] [xBill] Bổ sung validate của hàng hóa đặc trưng 1"
status: draft
services-affected: [invoicecore]
created_at: 2026-09-14
updated_at: 2026-09-14
---

# Expect - CBCLOUDV2-9572

## Mục tiêu

Bổ sung validate import Excel cho hàng hóa đặc trưng loại `1` trong `invoicecore`, áp dụng cho các luồng import:

- Bán hàng.
- GTGT.
- Vé xe.

Khi dòng import thuộc hàng hóa đặc trưng `1`, thông tin người mua để sinh XML phải bắt buộc:

- Tên đơn vị: `<Ten>`.
- MST/CCCD chủ hộ: `<MST>`.

Đồng thời bỏ bắt buộc:

- CCCD: `<CCCDan>`.

## Acceptance Criteria

- **AC1:** Import Bán hàng, GTGT và Vé xe đều áp dụng cùng rule validate cho hàng hóa đặc trưng `1`.
- **AC2:** Khi có hàng hóa đặc trưng `1`, trường tên đơn vị người mua phải có dữ liệu sau khi trim; nếu thiếu thì import trả lỗi validate.
- **AC3:** Khi có hàng hóa đặc trưng `1`, trường MST/CCCD chủ hộ phải có dữ liệu sau khi trim; nếu thiếu thì import trả lỗi validate.
- **AC4:** Trường CCCD người mua không còn là required trong rule hàng hóa đặc trưng `1`; để trống/null/không nhập không được báo lỗi bắt buộc.
- **AC5:** Nếu CCCD có dữ liệu thì vẫn giữ các validate hiện có như maxlength/format nếu source đang có; task này chỉ bỏ required, không xóa field.
- **AC6:** Lỗi validate phải chỉ rõ dòng/cột hoặc dòng dữ liệu import để tester/user biết bản ghi lỗi.
- **AC7:** Các rule validate import hiện tại ngoài ba trường trên giữ nguyên.
- **AC8:** Không thay đổi DB schema, route API import, cấu trúc response hoặc XML schema.

## Ngoài Phạm Vi

- Không sửa `api-cloud-service`; phần API đã được xử lý ở task khác.
- Không đổi file mẫu nếu không cần thêm/xóa cột.
- Không đổi mapping XML ngoài việc đảm bảo dữ liệu required trước khi lưu/sinh XML.
- Không thay đổi rule cho hàng hóa đặc trưng loại `2/3`.
