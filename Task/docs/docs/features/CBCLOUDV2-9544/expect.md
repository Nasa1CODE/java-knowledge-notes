---
feature: CBCLOUDV2-9544
title: "Lỗi Thêm mới/điều chỉnh/thay thế hóa đơn nhập"
status: testing
services-affected: [invoicecore]
created_at: 2026-09-11
updated_at: 2026-09-11
---

# Expect — CBCLOUDV2-9544

## Bối cảnh

Khi thêm mới, điều chỉnh hoặc thay thế hóa đơn nhập có dòng hàng hóa ghi chú với số lượng thập phân, XML có thể sinh số lượng dạng `1,34554`. CQT không chuyển đổi được chuỗi này sang số. XML dùng để xem hóa đơn còn có thể làm XSLT hiển thị `NaN` tại số lượng hoặc tổng tiền chiết khấu thương mại khi dữ liệu rỗng hay dùng dấu phẩy thập phân.

## Mong muốn

- XML biểu diễn giá trị số bằng dấu chấm thập phân.
- Hóa đơn thêm mới, điều chỉnh và thay thế xem được, ký được và không bị CQT từ chối vì `<SLuong>`.
- Trường tiền trên XML view không hiển thị `NaN` khi không có dữ liệu.

## Acceptance Criteria

- **AC1:** XML view (`Type = 1`) sinh `<SLuong>1.34554</SLuong>` từ số lượng `1,34554`; HTML không hiển thị `NaN`.
- **AC2:** XML ký/gửi CQT (`Type = 2`) sinh `<SLuong>1.34554</SLuong>` cho hóa đơn thêm mới, điều chỉnh và thay thế.
- **AC3:** Tổng tiền chiết khấu thương mại trên XML view lấy đúng trường nghiệp vụ; nếu không có dữ liệu thì sinh `0`.
- **AC4:** Khi bật làm tròn số lượng, kết quả đúng số chữ số cấu hình và vẫn dùng dấu chấm thập phân.
- **AC5:** Các trường tiền của XML ký/gửi (`Type = 2`) giữ nguyên nghiệp vụ và nguồn dữ liệu trước thay đổi.

## Ngoài phạm vi (Out-of-scope)

- Không thay đổi giao diện nhập hóa đơn, công thức tính hoặc dữ liệu database.
- Không đổi schema, Redis, hàng đợi hay cấu hình môi trường.
- Không sửa XML utility ngoài `HoaDonTT3268Utility`.

## Câu hỏi mở

Không có.

## Ảnh hưởng người dùng / dữ liệu

Người dùng không cần sửa dữ liệu đã nhập. XML đã ký trước đây không bị thay đổi; XML tạo mới sau triển khai sẽ dùng định dạng số lượng hợp lệ.

## Tài liệu liên quan

- `docs/specs/system.md`: nghiệp vụ lập, ký, điều chỉnh và thay thế hóa đơn.
