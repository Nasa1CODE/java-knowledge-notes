package com.hkd.accounting.module.catalog.enums;

public enum ProductType {
    GOODS("Hàng hóa bán ra"),
    SERVICE("Dịch vụ cung cấp"),
    MATERIAL("Nguyên vật liệu sản xuất");

    private final String description;

    ProductType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
