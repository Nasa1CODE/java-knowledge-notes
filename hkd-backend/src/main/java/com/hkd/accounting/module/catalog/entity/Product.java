package com.hkd.accounting.module.catalog.entity;

import com.hkd.accounting.common.entity.BaseEntity;
import com.hkd.accounting.module.catalog.enums.ProductType;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

/**
 * Danh mục Hàng hóa, Dịch vụ, Nguyên vật liệu.
 * Bắt buộc liên kết:
 * 1. Đơn vị tính (Unit).
 * 2. Biểu thuế ngành nghề (TaxCategory) để tự động tính thuế khi lập hóa đơn.
 */
@Entity
@Table(name = "cat_products", indexes = {
    @Index(name = "idx_product_code", columnList = "code", unique = true)
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Product extends BaseEntity {

    @Column(name = "code", nullable = false, length = 50, unique = true)
    private String code; // Mã hàng / SKU

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false, length = 20)
    private ProductType type;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "unit_id", nullable = false)
    private Unit unit;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tax_category_id", nullable = false)
    private TaxCategory taxCategory;

    @Builder.Default
    @Column(name = "default_purchase_price", precision = 15, scale = 2)
    private BigDecimal defaultPurchasePrice = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "default_sale_price", precision = 15, scale = 2)
    private BigDecimal defaultSalePrice = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "track_inventory", nullable = false)
    private boolean trackInventory = true; // Dịch vụ thì = false, Hàng hóa/Vật tư thì = true

    @Builder.Default
    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;
}
