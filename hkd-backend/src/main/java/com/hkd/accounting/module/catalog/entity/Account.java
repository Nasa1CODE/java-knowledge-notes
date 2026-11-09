package com.hkd.accounting.module.catalog.entity;

import com.hkd.accounting.common.entity.BaseEntity;
import com.hkd.accounting.module.catalog.enums.AccountNature;
import com.hkd.accounting.module.catalog.enums.AccountType;
import jakarta.persistence.*;
import lombok.*;

/**
 * Danh mục Tài khoản kế toán theo Thông tư 88/2021/TT-BTC.
 * Ví dụ:
 * - 111: Tiền mặt
 * - 112: Tiền gửi ngân hàng
 * - 131: Phải thu của khách hàng
 * - 156: Hàng hóa
 * - 331: Phải trả cho người bán
 * - 511: Doanh thu bán hàng và cung cấp dịch vụ
 * - 642: Chi phí quản lý và bán hàng
 * - 911: Xác định kết quả kinh doanh
 */
@Entity
@Table(name = "cat_accounts", indexes = {
    @Index(name = "idx_account_code", columnList = "code", unique = true)
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Account extends BaseEntity {

    @Column(name = "code", nullable = false, length = 20, unique = true)
    private String code;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false, length = 50)
    private AccountType type;

    @Enumerated(EnumType.STRING)
    @Column(name = "nature", nullable = false, length = 20)
    private AccountNature nature;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Builder.Default
    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;
}
