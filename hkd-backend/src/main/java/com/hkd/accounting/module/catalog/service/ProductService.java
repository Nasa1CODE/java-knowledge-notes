package com.hkd.accounting.module.catalog.service;

import com.hkd.accounting.module.catalog.dto.CreateProductRequest;
import com.hkd.accounting.module.catalog.dto.ProductDto;
import com.hkd.accounting.module.catalog.entity.Product;
import com.hkd.accounting.module.catalog.entity.TaxCategory;
import com.hkd.accounting.module.catalog.entity.Unit;
import com.hkd.accounting.module.catalog.repository.ProductRepository;
import com.hkd.accounting.module.catalog.repository.TaxCategoryRepository;
import com.hkd.accounting.module.catalog.repository.UnitRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductRepository productRepository;
    private final UnitRepository unitRepository;
    private final TaxCategoryRepository taxCategoryRepository;

    @Transactional(readOnly = true)
    public List<ProductDto> getAllProducts() {
        return productRepository.findAllByIsDeletedFalse()
                .stream()
                .map(ProductDto::fromEntity)
                .toList();
    }

    @Transactional
    public ProductDto createProduct(CreateProductRequest req) {
        if (productRepository.existsByCodeAndIsDeletedFalse(req.getCode())) {
            throw new IllegalArgumentException("Mã hàng hóa đã tồn tại: " + req.getCode());
        }

        Unit unit = unitRepository.findById(req.getUnitId())
                .orElseThrow(() -> new IllegalArgumentException("Đơn vị tính không tồn tại ID: " + req.getUnitId()));

        TaxCategory taxCat = taxCategoryRepository.findById(req.getTaxCategoryId())
                .orElseThrow(() -> new IllegalArgumentException("Nhóm biểu thuế không tồn tại ID: " + req.getTaxCategoryId()));

        Product product = Product.builder()
                .code(req.getCode().toUpperCase().trim())
                .name(req.getName().trim())
                .type(req.getType())
                .unit(unit)
                .taxCategory(taxCat)
                .defaultPurchasePrice(req.getDefaultPurchasePrice() != null ? req.getDefaultPurchasePrice() : BigDecimal.ZERO)
                .defaultSalePrice(req.getDefaultSalePrice() != null ? req.getDefaultSalePrice() : BigDecimal.ZERO)
                .trackInventory(req.getTrackInventory() != null ? req.getTrackInventory() : true)
                .build();

        Product saved = productRepository.save(product);
        log.info("Tạo mới hàng hóa/dịch vụ thành công: SKU={}", saved.getCode());
        return ProductDto.fromEntity(saved);
    }

    /**
     * 🧠 Minh họa cơ chế DIRTY CHECKING của Hibernate:
     * Trong @Transactional, ta chỉ cần gọi setter.
     * Khi phương thức kết thúc (commit transaction), Hibernate tự so sánh snapshot
     * và tự động phát sinh câu UPDATE mà KHÔNG CẦN gọi repository.save()!
     */
    @Transactional
    public ProductDto updatePrice(Long id, BigDecimal newSalePrice) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy hàng hóa ID: " + id));

        product.setDefaultSalePrice(newSalePrice); // Dirty checking tự phát hiện và sync xuống DB!
        return ProductDto.fromEntity(product);
    }
}
