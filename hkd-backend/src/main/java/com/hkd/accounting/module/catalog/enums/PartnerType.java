package com.hkd.accounting.module.catalog.enums;

public enum PartnerType {
    CUSTOMER("Khách hàng"),
    SUPPLIER("Nhà cung cấp"),
    BOTH("Vừa là khách hàng vừa là nhà cung cấp");

    private final String description;

    PartnerType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
