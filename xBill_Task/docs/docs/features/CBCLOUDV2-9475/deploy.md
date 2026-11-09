# CBCLOUDV2-9475 — Triển khai và Rollback

## 1. Điều kiện tiên quyết

- DBA/TechLead review và phê duyệt script SQL bên dưới.
- Tiến hành backup bảng `vs_doanhnghiep_cauhinh` trên các database tenant trước khi chạy script trên Staging / Production.
- **Tuyệt đối không chạy EF migration** (`dotnet ef migrations add`).

## 2. Script SQL cập nhật (Forward SQL)

Chạy script sau trên tất cả database tenant:

```sql
ALTER TABLE `vs_doanhnghiep_cauhinh`
    ADD COLUMN `cauhinh_phuongthucthanhtoan` INT NULL
        COMMENT 'Mã phương thức thanh toán mặc định',
    ADD COLUMN `isphuongthucthanhtoan` TINYINT(1) NULL DEFAULT 0
        COMMENT 'Bật cấu hình phương thức thanh toán mặc định: 1=bật, 0=tắt';
```

*Lưu ý:* Tên cột và quy ước hoa/thường tuân theo cấu hình MySQL `lower_case_table_names` của môi trường.

## 3. Thứ tự triển khai (Deployment Sequence)

1. **Bước 1 (DBA):** Backup bảng `vs_doanhnghiep_cauhinh` và thực thi script SQL Forward ở trên.
2. **Bước 2 (Kiểm tra DB):** Kiểm tra cấu trúc bảng `vs_doanhnghiep_cauhinh`, xác nhận 2 cột mới đã được tạo với giá trị mặc định `NULL` / `0`.
3. **Bước 3 (Backend):** Deploy service `invoicecore` (`VS.Web.Host`). Khởi động lại service và kiểm tra log không có lỗi.
4. **Bước 4 (Frontend):** Deploy ứng dụng `frontend_angular`.
5. **Bước 5 (Smoke test):**
   - Đăng nhập vào trang quản trị với quyền cấu hình doanh nghiệp.
   - Mở màn hình *Cấu hình doanh nghiệp*, kiểm tra mục *6. Cấu hình phương thức thanh toán mặc định cho hóa đơn*.
   - Bật cấu hình, chọn phương thức *Chuyển khoản*, bấm Lưu và kiểm tra thông báo thành công.
   - Thử tạo mới 1 hóa đơn GTGT, xác nhận phương thức thanh toán được điền sẵn là *Chuyển khoản*.
   - Thử tạo hóa đơn thay thế từ 1 hóa đơn gốc có phương thức thanh toán khác, xác nhận hóa đơn thay thế giữ nguyên phương thức của hóa đơn gốc.

## 4. Kế hoạch hoàn nguyên (Rollback)

Nếu phát sinh sự cố trong quá trình triển khai:

1. **Rollback ứng dụng:**
   - Rollback `frontend_angular` về phiên bản ổn định trước đó.
   - Rollback `invoicecore` về phiên bản ổn định trước đó.
2. **Rollback cơ sở dữ liệu (nếu cần thiết):**
   - Chỉ thực hiện sau khi code backend đã được rollback hoàn tất (đảm bảo không còn binary nào truy vấn 2 cột mới).
   - Chạy script sau trên database tenant:

```sql
ALTER TABLE `vs_doanhnghiep_cauhinh`
    DROP COLUMN `isphuongthucthanhtoan`,
    DROP COLUMN `cauhinh_phuongthucthanhtoan`;
```
