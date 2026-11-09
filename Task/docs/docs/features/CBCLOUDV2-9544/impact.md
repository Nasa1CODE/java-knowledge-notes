---
feature: CBCLOUDV2-9544
updated_at: 2026-09-11
---

# Impact — CBCLOUDV2-9544

## 1. Mục đích

Sửa định dạng số lượng và numeric trên XML view của hóa đơn nhập trong `invoicecore`, tránh `NaN` khi xem và lỗi CQT không chuyển đổi được `1,34554` sang số.

## 2. Phạm vi thay đổi

- Chỉ logic serialize XML: Có.
- Đụng dữ liệu: Không.
- Đổi schema / migration: Không.
- Đổi hợp đồng API / message: Không.
- Đổi Redis / cấu hình: Không.

## 3. Thành phần bị ảnh hưởng

### Backend

| Service | File / method | Mức | Lý do |
|---|---|---|---|
| invoicecore | `HoaDonTT3268Utility.GetDSHHDVuInfo` | Trung bình | Dựng chi tiết dùng chung cho XML view và XML ký |
| invoicecore | `HoaDonTT3268Utility.GetTToanInfo` | Thấp | Chỉ chuẩn hóa numeric/null trên Type 1 |
| invoicecore | `FormatXmlQuantity/FormatXmlDecimal` | Trung bình | Formatter dùng trong utility |
| invoicecore | `SaveAndSignInvoice` call chain | Thấp | Không sửa AppService; luồng ký dùng Type 2 |

### Frontend

Không sửa FE. HTML do XSLT render từ XML Type 1 sẽ không còn nhận chuỗi numeric không hợp lệ.

### Database

Không thay đổi bảng, cột hoặc dữ liệu đã lưu.

### Hàng đợi / tích hợp / cấu hình

| Thành phần | Thay đổi | Mức | Ghi chú |
|---|---|---|---|
| CQT | `<SLuong>` dùng dấu chấm thập phân | Trung bình | Giá trị số không đổi, chỉ sửa biểu diễn XML |
| HSM/token | Không đổi contract | Thấp | XML được định dạng trước khi ký |
| Redis/config | Không | Không | Không thêm khóa hoặc dependency |

## 4. Xác nhận KHÔNG bị ảnh hưởng

| Vùng | Vì sao không bị ảnh hưởng |
|---|---|
| Công thức tính hóa đơn | Không thay đổi phép tính hoặc dữ liệu DB |
| API request/response DTO | Không sửa DTO hay endpoint |
| XML đã ký trước triển khai | Không tạo lại hoặc cập nhật file lịch sử |
| Trường tiền Type 2 | Tiếp tục dùng logic cũ; ngoại lệ duy nhất là `<SLuong>` |
| Phân quyền và multi-tenant | Không sửa query, session hoặc tenant filter |

## 5. Rủi ro & hạn chế đã biết

| Rủi ro / hạn chế | Mức | Xử lý |
|---|---|---|
| `<SLuong>` đổi ở Type 1, Type 2 và call null | Trung bình | Test thêm mới/điều chỉnh/thay thế/POS/PXK |
| Hệ thống ngoài so sánh nguyên chuỗi XML | Thấp | Định dạng mới là số XML hợp lệ; regression tích hợp |
| Chưa test CQT end-to-end | Trung bình | QA chạy TC-07 đến TC-09 |
| Lộ dữ liệu tenant | Thấp | Không thay đổi truy vấn hoặc tenant scope |

## 6. Chưa được kiểm chứng

| Việc chưa làm | Vì sao |
|---|---|
| CQT tiếp nhận thực tế | Phụ thuộc môi trường ký và kết nối CQT |
| Đủ mẫu POS/PXK/đặc thù | Cần dữ liệu nghiệp vụ trên QA |

## 7. Kết luận

Rủi ro tổng thể trung bình do XML utility dùng chung; cần test end-to-end thêm mới, điều chỉnh và thay thế trước phát hành.

