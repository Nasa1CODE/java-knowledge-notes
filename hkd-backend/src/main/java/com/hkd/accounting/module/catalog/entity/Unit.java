package com.hkd.accounting.module.catalog.entity;

import com.hkd.accounting.common.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

/**
 * Danh mục Đơn vị tính cơ sở: Cái, Hộp, Bộ, Thùng, Kg, Mét...
 */
@Entity
@Table(name = "cat_units", indexes = {
    @Index(name = "idx_unit_code", columnList = "code", unique = true)
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Unit extends BaseEntity {

    @Column(name = "code", nullable = false, length = 50, unique = true)
    private String code;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Builder.Default
    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;
}
