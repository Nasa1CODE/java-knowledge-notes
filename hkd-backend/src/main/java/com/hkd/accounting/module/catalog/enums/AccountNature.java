package com.hkd.accounting.module.catalog.enums;

/**
 * Tính chất số dư tài khoản kế toán:
 * - DEBIT: Số dư Nợ (Tài sản, Chi phí)
 * - CREDIT: Số dư Có (Nợ phải trả, Doanh thu, Vốn)
 * - DUAL: Tài khoản lưỡng tính (131, 331) - vừa có thể dư Nợ vừa có thể dư Có
 */
public enum AccountNature {
    DEBIT("Dư Nợ"),
    CREDIT("Dư Có"),
    DUAL("Lưỡng tính (Có thể dư Nợ hoặc dư Có)");

    private final String description;

    AccountNature(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
