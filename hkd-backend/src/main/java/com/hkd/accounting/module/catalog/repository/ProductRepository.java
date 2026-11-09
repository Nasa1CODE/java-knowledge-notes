package com.hkd.accounting.module.catalog.repository;

import com.hkd.accounting.module.catalog.entity.Product;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    Optional<Product> findByCodeAndIsDeletedFalse(String code);
    boolean existsByCodeAndIsDeletedFalse(String code);

    /**
     * Quy tắc Tech Lead: Dùng @EntityGraph để EAGER load Unit và TaxCategory trong đúng 1 query,
     * giải quyết triệt để lỗi N+1 Query khi load danh sách sản phẩm!
     */
    @EntityGraph(attributePaths = {"unit", "taxCategory"})
    List<Product> findAllByIsDeletedFalse();
}
