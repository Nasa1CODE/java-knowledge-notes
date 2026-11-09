package com.hkd.accounting.module.catalog.dto;

import com.hkd.accounting.module.catalog.entity.Product;
import com.hkd.accounting.module.catalog.enums.ProductType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO đại diện cho dữ liệu Hàng hóa/Dịch vụ trả về API.
 * Quy tắc Tech Lead: Luôn dùng DTO để trả về Frontend,
 * KHÔNG bao giờ serialize trực tiếp JPA Entity để tránh LazyInitializationException!
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductDto {
    private Long id;
    private String code;
    private String name;
    private ProductType type;
    private String unitName;
    private String taxCategoryName;
    private BigDecimal vatRate;
    private BigDecimal pitRate;
    private BigDecimal totalTaxRate;
    private BigDecimal defaultPurchasePrice;
    private BigDecimal defaultSalePrice;
    private boolean trackInventory;

    public static ProductDto fromEntity(Product p) {
        return ProductDto.builder()
                .id(p.getId())
                .code(p.getCode())
                .name(p.getName())
                .type(p.getType())
                .unitName(p.getUnit() != null ? p.getUnit().getName() : null)
                .taxCategoryName(p.getTaxCategory() != null ? p.getTaxCategory().getName() : null)
                .vatRate(p.getTaxCategory() != null ? p.getTaxCategory().getVatRate() : null)
                .pitRate(p.getTaxCategory() != null ? p.getTaxCategory().getPitRate() : null)
                .totalTaxRate(p.getTaxCategory() != null ? p.getTaxCategory().getTotalRate() : null)
                .defaultPurchasePrice(p.getDefaultPurchasePrice())
                .defaultSalePrice(p.getDefaultSalePrice())
                .trackInventory(p.isTrackInventory())
                .build();
    }
}
