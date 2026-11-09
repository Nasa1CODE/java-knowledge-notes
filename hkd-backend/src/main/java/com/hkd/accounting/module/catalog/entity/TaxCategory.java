package com.hkd.accounting.module.catalog.entity;

import com.hkd.accounting.common.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

/**
 * Danh mục Nhóm ngành nghề kinh doanh và Biểu thuế theo Thông tư 40/2021/TT-BTC.
 * Gồm 4 nhóm chính:
 * 1. Phân phối, cung cấp hàng hóa: 1% GTGT + 0.5% TNCN = 1.5%
 * 2. Dịch vụ, xây dựng không bao thầu NVL: 5% GTGT + 2% TNCN = 7.0%
 * 3. Sản xuất, vận tải, dịch vụ có gắn với hàng hóa: 3% GTGT + 1.5% TNCN = 4.5%
 * 4. Hoạt động kinh doanh khác: 2% GTGT + 1% TNCN = 3.0%
 */
@Entity
@Table(name = "cat_tax_categories", indexes = {
    @Index(name = "idx_tax_category_code", columnList = "code", unique = true)
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TaxCategory extends BaseEntity {

    @Column(name = "code", nullable = false, length = 50, unique = true)
    private String code;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "vat_rate", nullable = false, precision = 5, scale = 2)
    private BigDecimal vatRate;

    @Column(name = "pit_rate", nullable = false, precision = 5, scale = 2)
    private BigDecimal pitRate;

    @Column(name = "total_rate", nullable = false, precision = 5, scale = 2)
    private BigDecimal totalRate;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

    @Builder.Default
    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;
}
