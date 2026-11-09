package com.hkd.accounting.module.catalog.entity;

import com.hkd.accounting.common.entity.BaseEntity;
import com.hkd.accounting.module.catalog.enums.PartnerType;
import jakarta.persistence.*;
import lombok.*;

/**
 * Danh mục Khách hàng & Nhà cung cấp.
 * Liên kết tài khoản công nợ mặc định:
 * - Khách hàng mặc định TK 131 (Phải thu khách hàng)
 * - Nhà cung cấp mặc định TK 331 (Phải trả nhà cung cấp)
 */
@Entity
@Table(name = "cat_partners", indexes = {
    @Index(name = "idx_partner_code", columnList = "code", unique = true),
    @Index(name = "idx_partner_tax_code", columnList = "tax_code")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Partner extends BaseEntity {

    @Column(name = "code", nullable = false, length = 50, unique = true)
    private String code;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false, length = 20)
    private PartnerType type;

    @Column(name = "tax_code", length = 50)
    private String taxCode; // Mã số thuế hoặc CCCD chủ thể

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "phone", length = 50)
    private String phone;

    @Column(name = "email", length = 100)
    private String email;

    /**
     * Quy tắc Tech Lead: Luôn dùng FetchType.LAZY cho quan hệ @ManyToOne / @OneToOne
     * Tránh việc Hibernate mặc định EAGER gây bẫy N+1 Query!
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "default_debt_account_id")
    private Account defaultDebtAccount;

    @Builder.Default
    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;
}
