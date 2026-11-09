package com.hkd.accounting.module.catalog.controller;

import com.hkd.accounting.common.dto.ApiResponse;
import com.hkd.accounting.module.catalog.dto.CreateProductRequest;
import com.hkd.accounting.module.catalog.dto.ProductDto;
import com.hkd.accounting.module.catalog.entity.Account;
import com.hkd.accounting.module.catalog.entity.TaxCategory;
import com.hkd.accounting.module.catalog.entity.Unit;
import com.hkd.accounting.module.catalog.repository.AccountRepository;
import com.hkd.accounting.module.catalog.repository.TaxCategoryRepository;
import com.hkd.accounting.module.catalog.repository.UnitRepository;
import com.hkd.accounting.module.catalog.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/catalog")
@RequiredArgsConstructor
@Tag(name = "Phân Hệ Danh Mục Gốc (Master Data)", description = "APIs quản lý Tài khoản TT88, Biểu thuế TT40, ĐVT, Hàng hóa, Khách hàng")
public class CatalogController {

    private final AccountRepository accountRepository;
    private final TaxCategoryRepository taxCategoryRepository;
    private final UnitRepository unitRepository;
    private final ProductService productService;

    @GetMapping("/accounts")
    @Operation(summary = "Lấy danh mục Tài khoản kế toán chuẩn Thông tư 88/2021/TT-BTC")
    public ResponseEntity<ApiResponse<List<Account>>> getAccounts() {
        return ResponseEntity.ok(ApiResponse.success(accountRepository.findAll()));
    }

    @GetMapping("/tax-categories")
    @Operation(summary = "Lấy danh mục 4 nhóm biểu thuế ngành nghề theo Thông tư 40/2021/TT-BTC")
    public ResponseEntity<ApiResponse<List<TaxCategory>>> getTaxCategories() {
        return ResponseEntity.ok(ApiResponse.success(taxCategoryRepository.findAll()));
    }

    @GetMapping("/units")
    @Operation(summary = "Lấy danh mục đơn vị tính cơ sở")
    public ResponseEntity<ApiResponse<List<Unit>>> getUnits() {
        return ResponseEntity.ok(ApiResponse.success(unitRepository.findAll()));
    }

    @GetMapping("/products")
    @Operation(summary = "Lấy danh sách hàng hóa/dịch vụ (dùng @EntityGraph chống N+1)")
    public ResponseEntity<ApiResponse<List<ProductDto>>> getProducts() {
        return ResponseEntity.ok(ApiResponse.success(productService.getAllProducts()));
    }

    @PostMapping("/products")
    @Operation(summary = "Tạo mới hàng hóa/dịch vụ")
    public ResponseEntity<ApiResponse<ProductDto>> createProduct(@Valid @RequestBody CreateProductRequest req) {
        return ResponseEntity.ok(ApiResponse.success("Tạo hàng hóa thành công", productService.createProduct(req)));
    }

    @PatchMapping("/products/{id}/price")
    @Operation(summary = "Cập nhật giá bán (Minh họa Hibernate Dirty Checking)")
    public ResponseEntity<ApiResponse<ProductDto>> updatePrice(
            @PathVariable Long id,
            @RequestParam BigDecimal newPrice) {
        return ResponseEntity.ok(ApiResponse.success("Cập nhật giá thành công", productService.updatePrice(id, newPrice)));
    }
}
