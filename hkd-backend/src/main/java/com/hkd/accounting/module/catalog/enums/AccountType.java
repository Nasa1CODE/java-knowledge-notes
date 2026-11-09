package com.hkd.accounting.module.catalog.enums;

public enum AccountType {
    ASSET("Tài sản (Loại 1, 2)"),
    LIABILITY("Nợ phải trả (Loại 3)"),
    EQUITY("Nguồn vốn (Loại 4)"),
    REVENUE("Doanh thu (Loại 5)"),
    EXPENSE("Chi phí (Loại 6)"),
    RESULT("Xác định kết quả kinh doanh (Loại 9)");

    private final String description;

    AccountType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
