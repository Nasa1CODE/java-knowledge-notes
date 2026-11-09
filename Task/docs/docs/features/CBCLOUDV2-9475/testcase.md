# CBCLOUDV2-9475 — Test case

Dữ liệu kiểm thử sử dụng dữ liệu giả định trên môi trường QA/Dev, không dùng dữ liệu nhạy cảm của khách hàng thật.

| ID | Tình huống | Dữ liệu đầu vào | Kỳ vọng | Trạng thái |
|---|---|---|---|---|
| TC01 | Doanh nghiệp chưa cấu hình / dữ liệu DB `NULL` | Doanh nghiệp mới hoặc record `vs_doanhnghiep_cauhinh` có 2 cột `NULL` | API trả `isPhuongThucThanhToan = false`, `cauhinh_PhuongThucThanhToan = null`; hóa đơn mới mặc định mã `1` (Tiền mặt). | Not run |
| TC02 | Tắt cấu hình phương thức thanh toán mặc định | Switch = Tắt, bấm Lưu | DB lưu `isphuongthucthanhtoan = 0`, `cauhinh_phuongthucthanhtoan = NULL`; hóa đơn mới mặc định mã `1`. | Not run |
| TC03 | Bật cấu hình và chọn phương thức thanh toán active | Switch = Bật, chọn mã `2` (Chuyển khoản), bấm Lưu | Lưu thành công; cache bị xóa; tạo hóa đơn mới tự động điền mã `2`. | Not run |
| TC04 | Bật cấu hình nhưng không chọn phương thức | Switch = Bật, Dropdown rỗng, bấm Lưu | Frontend hiển thị toast cảnh báo; Backend từ chối lưu và trả thông báo lỗi hợp lệ. | Not run |
| TC05 | Mã phương thức cấu hình không tồn tại hoặc bị ngừng hiệu lực | DB có `cauhinh_phuongthucthanhtoan` trỏ tới mã có `PhuongThuc_HieuLuc = 0` | Backend từ chối khi cập nhật; khi tạo hóa đơn runtime tự động fallback về mã `1`. | Not run |
| TC06 | Tạo mới hóa đơn GTGT / bán hàng thường | Đã cấu hình mặc định mã `2` (Chuyển khoản) | Form tạo mới điền sẵn phương thức `2` (Chuyển khoản) nếu trường PTTT chưa có giá trị. | Not run |
| TC07 | Tạo mới hóa đơn máy tính tiền (POS/MTT) | Đã cấu hình mặc định mã `2` (Chuyển khoản) | Hóa đơn POS mới tạo điền sẵn phương thức `2` (Chuyển khoản). | Not run |
| TC08 | Tạo hóa đơn thay thế (`Mau_HoaDon_Loai == 3` hoặc `7`) | Hóa đơn gốc có PTTT `0` + tên "Ví MoMo" | Hóa đơn thay thế sao chép cả mã `0` và tên "Ví MoMo" từ hóa đơn gốc; không áp dụng cấu hình mặc định. | Not run |
| TC09 | Tạo hóa đơn điều chỉnh (`Mau_HoaDon_Loai == 5`) | Hóa đơn gốc có PTTT mã `1`, cấu hình mặc định là `2` | Hóa đơn điều chỉnh KHÔNG sao chép từ hóa đơn gốc; áp dụng PTTT mặc định theo cấu hình (mã `2`). | Not run |
| TC10 | Mở sửa hóa đơn đã lưu trước đó | Hóa đơn đã lưu có PTTT mã `3` (Tiền mặt/CK) | Khi mở sửa form, giữ nguyên mã `3`, không bị cấu hình mặc định ghi đè. | Not run |
| TC11 | Người dùng chủ động đổi phương thức thanh toán | Người dùng đổi từ mã `2` sang mã `1` trên hóa đơn | Giá trị người dùng chọn được lưu thành công vào DB và mở lại đúng mã `1`. | Not run |
| TC12 | Phương thức thanh toán tùy chỉnh mã `0` | Nhập tên phương thức "Thẻ tín dụng quốc tế" | Lưu đúng mã `0` và tên tùy chỉnh; không bị ép thành mã `1` (Tiền mặt). | Not run |
| TC13 | Kiểm tra XML, PDF, xem hóa đơn | Hóa đơn lưu phương thức đã cấu hình | Nội dung thẻ thanh toán trong XML, văn bản hiển thị trên PDF và bản xem trước đồng nhất. | Not run |
| TC14 | Người dùng không có quyền sửa cấu hình | Tài khoản không có quyền `HDDT_CauHinh_DoanhNghiep_CauHinhDoanhNghiep_Sua` | UI ẩn nút hoặc vô hiệu hóa thao tác lưu; Backend chặn request Update với lỗi 403 Forbidden. | Not run |
| TC15 | Cách ly dữ liệu đa khách hàng (Multi-tenancy) | Tenant A cấu hình mã `2`, Tenant B chưa cấu hình | Tenant A tạo hóa đơn ra mã `2`, Tenant B tạo hóa đơn ra mã `1`; cache độc lập theo `${TenantId}_${MST}`. | Not run |
