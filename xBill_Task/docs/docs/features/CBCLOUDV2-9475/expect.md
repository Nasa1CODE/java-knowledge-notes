# CBCLOUDV2-9475 — Kỳ vọng

- Trạng thái: `testing`
- Gate 1: Đã được phê duyệt kế hoạch triển khai
- Phạm vi: `invoicecore`, `frontend_angular`, `docs`

## Mục tiêu

Cho phép người dùng có quyền cấu hình doanh nghiệp chọn phương thức thanh toán mặc định khi lập hóa đơn điện tử trong hệ thống BillCloud.

## Tiêu chí chấp nhận

1. **AC1 - Bật/tắt và chọn phương thức:** Người dùng có quyền sửa Cấu hình doanh nghiệp có thể bật/tắt chức năng "Cấu hình phương thức thanh toán mặc định cho hóa đơn" và chọn một phương thức thanh toán đang có hiệu lực trong danh mục hệ thống (`vs_dm_ncc_phuongthucthanhtoan`).
2. **AC2 - Áp dụng khi tạo mới:** Khi cấu hình BẬT và hợp lệ, hóa đơn mới tạo (hóa đơn GTGT thường, hóa đơn bán hàng, hóa đơn máy tính tiền POS/MTT, hóa đơn điều chỉnh) được tự động điền sẵn phương thức thanh toán đã chọn nếu trường thanh toán chưa có dữ liệu.
3. **AC3 - Cơ chế Fallback an toàn:** Khi cấu hình TẮT, chưa từng cấu hình (dữ liệu `NULL`), hoặc mã phương thức đã cấu hình bị ngừng hiệu lực/xóa trong danh mục, hệ thống tự động fallback về mã `1` — Tiền mặt.
4. **AC4 - Kế thừa hóa đơn thay thế & điều chỉnh:**
   - Hóa đơn thay thế (`Mau_HoaDon_Loai == 3` hoặc `7`): tiếp tục sao chép toàn bộ phương thức thanh toán (cả mã và tên tùy chỉnh) từ hóa đơn gốc; không áp dụng cấu hình mặc định.
   - Hóa đơn điều chỉnh (`Mau_HoaDon_Loai == 5`): không sao chép phương thức từ hóa đơn gốc mà lấy theo phương thức thanh toán mặc định đã cấu hình.
   - Không ghi đè phương thức thanh toán đã có trên hóa đơn đang sửa.
5. **AC5 - Bảo toàn phương thức tùy chỉnh:** Phương thức thanh toán tùy chỉnh (mã `0` kèm tên tùy chỉnh `thanhToan_PhuongThuc_Ten`) tuyệt đối không bị ghi đè hoặc chuyển thành mã `1` (Tiền mặt).
6. **AC6 - Tôn trọng lựa chọn của người dùng:** Nếu người dùng chủ động chọn hoặc sửa phương thức thanh toán khi lập/chỉnh sửa hóa đơn, giá trị người dùng chọn được lưu trữ và giữ nguyên khi mở lại.
7. **AC7 - Đồng bộ dữ liệu hiển thị và xuất:** Giá trị phương thức thanh toán đã lưu phải nhất quán trong XML, file ký, PDF, màn hình xem chi tiết hóa đơn và luồng gửi.
8. **AC8 - Kiểm tra tính hợp lệ phía Backend:** Backend từ chối lưu cấu hình nếu switch BẬT nhưng thiếu mã phương thức thanh toán, mã không tồn tại, hoặc mã đã bị xóa mềm/ngừng hiệu lực trong danh mục `vs_dm_ncc_phuongthucthanhtoan`.
9. **AC9 - Phân quyền và Multi-tenancy:** Áp dụng đúng quyền `HDDT_CauHinh_DoanhNghiep_CauHinhDoanhNghiep_Sua`. Đảm bảo cách ly đa khách hàng chặt chẽ theo `TenantId` và MST/CCCD; xóa cache cấu hình doanh nghiệp ngay khi cập nhật.

## Ngoài phạm vi

- Không thay đổi route, menu hệ thống, hoặc permission key.
- Không thay đổi cấu trúc bảng danh mục phương thức thanh toán `vs_dm_ncc_phuongthucthanhtoan`.
- Không sửa đổi dữ liệu phương thức thanh toán trên các hóa đơn lịch sử đã phát hành.
- Không sử dụng EF Core migration cho bảng nghiệp vụ `vs_*`.
