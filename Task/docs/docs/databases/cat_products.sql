-- Bảng Danh mục Hàng hóa, Dịch vụ, Vật tư
CREATE TABLE cat_products (
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
CREATE INDEX idx_product_code ON cat_products(code);
