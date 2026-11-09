# Test Cases — HKD-001: Khởi tạo Kiến trúc Base & Phân hệ Danh mục Gốc

> Sinh từ [expect.md](expect.md) theo [rules/03-create-testcase.md](../../rules/03-create-testcase.md).

## TC-01: Khởi tạo tự động dữ liệu pháp lý (AC-2)
- **Tiền điều kiện:** Database `hkd_accounting_db` trống dữ liệu.
- **Thực hiện:** Khởi động ứng dụng Spring Boot.
- **Kỳ vọng:**
  - Bảng `cat_accounts` được tự động nạp 12 tài khoản kế toán chuẩn Thông tư 88 (111, 112, 131, 152, 156, 211, 331, 333, 334, 511, 642, 911).
  - Bảng `cat_tax_categories` được nạp 4 nhóm biểu thuế chuẩn Thông tư 40 (`PP_HANG_HOA`, `DICH_VU`, `SAN_XUAT_VAN_TAI`, `HOAT_DONG_KHAC`) với đúng tỷ lệ % thuế GTGT + TNCN.
  - Bảng `cat_units` được nạp các đơn vị tính cơ sở (Cái, Hộp, Kg, Bộ...).

## TC-02: Tạo mới hàng hóa hợp lệ (AC-3)
- **Tiền điều kiện:** Server đang chạy, đã có Unit và TaxCategory.
- **Thực hiện:** Gửi `POST /api/catalog/products`:
  ```json
  {
    "code": "SP001",
    "name": "Nước ngọt Coca-Cola 330ml",
    "type": "GOODS",
    "unitId": 1,
    "taxCategoryId": 1,
    "defaultPurchasePrice": 8000,
    "defaultSalePrice": 10000,
    "trackInventory": true
  }
  ```
- **Kỳ vọng:** Trả về HTTP 200, JSON ApiResponse bọc ProductDto có đầy đủ tên ĐVT, tên biểu thuế và tỷ lệ thuế 1.5%.

## TC-03: Chống trùng mã SKU hàng hóa (AC-3)
- **Tiền điều kiện:** Đã tồn tại sản phẩm mã `SP001`.
- **Thực hiện:** Gửi lại request tạo sản phẩm với mã `SP001`.
- **Kỳ vọng:** Ném lỗi `IllegalArgumentException` ("Mã hàng hóa đã tồn tại: SP001"), không cho phép ghi vào DB.

## TC-04: Kiểm chứng Hibernate Dirty Checking khi cập nhật giá
- **Tiền điều kiện:** Đã có sản phẩm `SP001` (giá bán = 10,000).
- **Thực hiện:** Gọi `PATCH /api/catalog/products/1/price?newPrice=12000`.
- **Kỳ vọng:**
  - Trả về giá bán mới 12,000.
  - Kiểm tra log console xuất hiện đúng câu lệnh `UPDATE cat_products SET default_sale_price = 12000.00, version = 1 ...` mà không cần gọi lệnh `repository.save()`.

## TC-05: Kiểm chứng triệt tiêu N+1 Query (AC-4)
- **Thực hiện:** Gọi `GET /api/catalog/products` khi có 50 sản phẩm trong DB.
- **Kỳ vọng:** Log Hibernate chỉ in **đúng 1 câu lệnh SQL duy nhất** có `left outer join cat_units` và `left outer join cat_tax_categories`. Tuyệt đối không sinh thêm 50 câu query con!
