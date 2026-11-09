package com.hkd.accounting.common.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * BaseEntity cung cấp các trường nền tảng bắt buộc:
 * 1. Khóa chính (Primary Key).
 * 2. Dấu vết kiểm toán (Audit Trail: createdAt, updatedAt, createdBy, updatedBy).
 * 3. Xóa mềm (Soft Delete: isDeleted).
 * 4. Khóa lạc quan (Optimistic Locking: version) chống ghi đè dữ liệu đồng thời.
 * 5. Chuẩn an toàn hợp đồng equals() / hashCode() cho JPA.
 */
@MappedSuperclass
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @CreatedBy
    @Column(name = "created_by", updatable = false)
    private String createdBy;

    @LastModifiedBy
    @Column(name = "updated_by")
    private String updatedBy;

    @Column(name = "is_deleted", nullable = false)
    private boolean isDeleted = false;

    @Version
    @Column(name = "version")
    private Long version;

    /**
     * Hợp đồng equals() chuẩn cho JPA:
     * - Nếu cùng reference memory -> true.
     * - Nếu id == null (chưa lưu vào DB) -> so sánh theo identity (chỉ bằng chính nó).
     * - Nếu id != null -> so sánh theo id.
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BaseEntity that = (BaseEntity) o;
        return id != null && Objects.equals(id, that.id);
    }

    /**
     * hashCode() bất biến:
     * - Trả về hằng số cố định theo class để đảm bảo khi id thay đổi (sau persist),
     *   object không bị nhảy sang bucket khác trong HashSet/HashMap!
     */
    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
