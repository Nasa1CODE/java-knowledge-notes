package com.hkd.accounting.module.catalog.repository;

import com.hkd.accounting.module.catalog.entity.Partner;
import com.hkd.accounting.module.catalog.enums.PartnerType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PartnerRepository extends JpaRepository<Partner, Long> {
    Optional<Partner> findByCodeAndIsDeletedFalse(String code);
    boolean existsByCodeAndIsDeletedFalse(String code);
    List<Partner> findByTypeAndIsDeletedFalse(PartnerType type);
}
