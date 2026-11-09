# Deploy — HKD-001: Khởi tạo Kiến trúc Base & Phân hệ Danh mục Gốc

> Theo [templates/deploy.md](../../templates/deploy.md). Áp dụng cho môi trường Database PostgreSQL.

## 1. DDL Migration Scripts

```sql
-- 1. Bảng danh mục Tài khoản kế toán Thông tư 88
CREATE TABLE IF NOT EXISTS cat_accounts (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    nature VARCHAR(20) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    created_by VARCHAR(255),
    updated_by VARCHAR(255),
    version BIGINT DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_account_code ON cat_accounts(code);

-- 2. Bảng danh mục Biểu thuế tỷ lệ doanh thu Thông tư 40
CREATE TABLE IF NOT EXISTS cat_tax_categories (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    vat_rate NUMERIC(5, 2) NOT NULL,
    pit_rate NUMERIC(5, 2) NOT NULL,
    total_rate NUMERIC(5, 2) NOT NULL,
    note TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    created_by VARCHAR(255),
    updated_by VARCHAR(255),
    version BIGINT DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_tax_category_code ON cat_tax_categories(code);

-- 3. Bảng danh mục Đơn vị tính cơ sở
CREATE TABLE IF NOT EXISTS cat_units (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    created_by VARCHAR(255),
    updated_by VARCHAR(255),
    version BIGINT DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_unit_code ON cat_units(code);

-- 4. Bảng danh mục Khách hàng & Nhà cung cấp
CREATE TABLE IF NOT EXISTS cat_partners (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(20) NOT NULL,
    tax_code VARCHAR(50),
    address VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(100),
    default_debt_account_id BIGINT REFERENCES cat_accounts(id),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    created_by VARCHAR(255),
    updated_by VARCHAR(255),
    version BIGINT DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_partner_code ON cat_partners(code);
CREATE INDEX IF NOT EXISTS idx_partner_tax_code ON cat_partners(tax_code);

-- 5. Bảng danh mục Hàng hóa, Dịch vụ, Vật tư
CREATE TABLE IF NOT EXISTS cat_products (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(20) NOT NULL,
    unit_id BIGINT NOT NULL REFERENCES cat_units(id),
    tax_category_id BIGINT NOT NULL REFERENCES cat_tax_categories(id),
    default_purchase_price NUMERIC(15, 2) DEFAULT 0.00,
    default_sale_price NUMERIC(15, 2) DEFAULT 0.00,
    track_inventory BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    created_by VARCHAR(255),
    updated_by VARCHAR(255),
    version BIGINT DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_product_code ON cat_products(code);
```

## 2. Cấu hình Môi trường (Config)

- Tạo database mới trong PostgreSQL:
  ```sql
  CREATE DATABASE hkd_accounting_db;
  ```
- Biến môi trường chạy:
  - `SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/hkd_accounting_db`
  - `SPRING_DATASOURCE_USERNAME=hr_admin`
  - `SPRING_DATASOURCE_PASSWORD=hr_secret_password`
