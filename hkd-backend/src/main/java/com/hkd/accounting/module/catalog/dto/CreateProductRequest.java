package com.hkd.accounting.module.catalog.dto;

import com.hkd.accounting.module.catalog.enums.ProductType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateProductRequest {

    @NotBlank(message = "Mã hàng hóa không được để trống")
    private String code;

    @NotBlank(message = "Tên hàng hóa không được để trống")
    private String name;

    @NotNull(message = "Loại sản phẩm không được để trống")
    private ProductType type;

    @NotNull(message = "Đơn vị tính không được để trống")
    private Long unitId;

    @NotNull(message = "Nhóm thuế suất Thông tư 40 không được để trống")
    private Long taxCategoryId;

    private BigDecimal defaultPurchasePrice;
    private BigDecimal defaultSalePrice;
    private Boolean trackInventory;
}
