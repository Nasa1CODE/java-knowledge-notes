# Impact — HKD-001: Khởi tạo Kiến trúc Base & Phân hệ Danh mục Gốc

> Theo [rules/04-create-impact.md](../../rules/04-create-impact.md). Finalize sau khi code xong.

## 1. Mục đích

Khởi tạo hạ tầng backend Spring Boot và tập CSDL Danh mục gốc (Master Data) cho hệ thống Quản lý Kế toán Hộ Kinh Doanh (HKD). Service phụ trách: `hkd-backend-service`.

## 2. Phạm vi thay đổi

- Chỉ logic: Không (tạo mới service và entities)
- Đụng dữ liệu: Có (tạo các bảng danh mục mới và nạp seed data mặc định)
- Đổi schema / migration: Có (sinh 5 bảng mới trong PostgreSQL)
- Đổi hợp đồng (API / message hàng đợi): Có (công bố tập REST API `/api/catalog/*`)

## 3. Thành phần bị ảnh hưởng

### Backend

| Service | File / method | Mức | Lý do |
|---|---|---|---|
| `hkd-backend` | `com.hkd.accounting.common.entity.BaseEntity` | Cao | Cung cấp ID, Audit, Version cho toàn bộ Entity tương lai |
| `hkd-backend` | `module.catalog.entity.*` | Cao | Định nghĩa model CSDL cho Account, TaxCategory, Unit, Partner, Product |
| `hkd-backend` | `module.catalog.service.ProductService` | TB | Xử lý logic nghiệp vụ và Dirty Checking cập nhật giá |
| `hkd-backend` | `module.catalog.controller.CatalogController` | TB | Cung cấp các endpoint REST API cho Swagger & Frontend |

### Database

| Bảng / cột | Thay đổi | Mức | Migration / DDL |
|---|---|---|---|
| `cat_accounts` | Tạo mới bảng | Cao | Lưu 12 tài khoản kế toán Thông tư 88 |
| `cat_tax_categories` | Tạo mới bảng | Cao | Lưu 4 nhóm ngành nghề và tỷ lệ thuế Thông tư 40 |
| `cat_units` | Tạo mới bảng | TB | Lưu danh mục Đơn vị tính cơ sở |
| `cat_partners` | Tạo mới bảng | Cao | Lưu Khách hàng & Nhà cung cấp, trỏ FK `default_debt_account_id` |
| `cat_products` | Tạo mới bảng | Cao | Lưu Hàng hóa/Dịch vụ, trỏ FK `unit_id`, `tax_category_id` |

### Hàng đợi / tích hợp / cấu hình

| Thành phần | Thay đổi | Mức | Ghi chú |
|---|---|---|---|
| `application.yml` | Cấu hình port 8081, datasource PostgreSQL, JPA show-sql | TB | Không hardcode secret production |

## 4. Xác nhận KHÔNG bị ảnh hưởng

| Vùng | Vì sao không bị ảnh hưởng |
|---|---|
| Service `hr-performance-backend` | Chạy trên port 8080 độc lập, database độc lập, không dùng chung class |
| Phân hệ Hóa đơn & Kho của HKD | Chưa triển khai, chưa có ràng buộc khóa ngoại phụ thuộc vào `cat_products` |
| Sổ sách kế toán & Báo cáo | Chưa phát sinh bút toán kế toán, chỉ mới thiết lập danh mục tài khoản rỗng |

## 5. Rủi ro & Hạn chế đã biết

| Rủi ro / hạn chế | Mức | Xử lý |
|---|---|---|
| Trùng mã SKU hàng hóa hoặc mã tài khoản | TB | Đã đặt ràng buộc `UNIQUE` trên cột `code` và kiểm tra `existsByCode` ở Service |
| Bẫy N+1 Query khi load danh sách sản phẩm | Cao | Đã cấu hình `@EntityGraph(attributePaths = {"unit", "taxCategory"})` trong Repository |
| Xung đột ghi đè dữ liệu đồng thời khi sửa giá | TB | Đã kích hoạt `@Version` Optimistic Locking trên `BaseEntity` |

## 6. Chưa được kiểm chứng

- Cần chạy kiểm thử tải (Load Test) khi danh mục hàng hóa vượt quá 100,000 SKU để đánh giá hiệu quả của Index cột `code`.
