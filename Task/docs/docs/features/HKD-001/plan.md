---
feature: HKD-001
title: Kế hoạch Kỹ thuật — Khởi tạo Kiến trúc Base & Phân hệ Danh mục Gốc (Master Data)
status: plan-review
gate-1-approval:
  techlead: Pending Review
  date: 2026-11-09
---

# Technical Implementation Plan — HKD-001

## 1. Kiến Trúc & Cấu Trúc Gói (Package Structure)

Áp dụng mô hình **Modular Architecture** (tách rõ Domain):

```
com.hkd.accounting
├── common
│   ├── entity
│   │   └── BaseEntity.java             # ID, Auditing (createdAt, updatedAt), Version
│   ├── dto
│   │   └── ApiResponse.java            # Standard generic response wrapper
│   └── exception
│       ├── AppException.java
│       └── GlobalExceptionHandler.java
└── module
    └── catalog
        ├── entity
        │   ├── Account.java            # Tài khoản kế toán TT88 (111, 112, 131...)
        │   ├── TaxCategory.java        # Nhóm ngành nghề & tỷ lệ thuế TT40
        │   ├── Partner.java            # Khách hàng & Nhà cung cấp
        │   ├── Unit.java               # Đơn vị tính (Cái, Hộp, Kg...)
        │   └── Product.java            # Hàng hóa, Dịch vụ, Vật tư
        ├── enums
        │   ├── AccountType.java        # ASSET, LIABILITY, REVENUE, EXPENSE...
        │   ├── PartnerType.java        # CUSTOMER, SUPPLIER, BOTH
        │   └── ProductType.java        # GOODS, SERVICE, MATERIAL
        ├── repository
        │   ├── AccountRepository.java
        │   ├── TaxCategoryRepository.java
        │   ├── PartnerRepository.java
        │   ├── UnitRepository.java
        │   └── ProductRepository.java
        └── bootstrap
            └── MasterDataInitializer.java # Seed data chuẩn TT88 & TT40 khi app start
```

---

## 2. Quyết Định Kỹ Thuật Cốt Lõi (Architecture & Design Decisions)

### 📌 Quyết định 1: Thiết kế `BaseEntity` & Concurrency Control
```java
@MappedSuperclass
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {

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

    // ⚡ Optimistic Locking: Chống ghi đè dữ liệu đồng thời mà không khóa DB!
    @Version
    @Column(name = "version")
    private Long version;
}
```
* **Bản chất kỹ thuật:** `@Version` giúp Hibernate tự động kiểm tra `WHERE id = ? AND version = ?`. Nếu 2 user cùng mở 1 sản phẩm để sửa giá, người sửa sau sẽ nhận ngay `OptimisticLockException` thay vì ghi đè mất dữ liệu của người trước.

---

### 📌 Quyết định 2: Hợp đồng `equals()` và `hashCode()` an toàn cho JPA Entity
* **Anti-Pattern kinh điển:** Dùng `@Data` hoặc `@EqualsAndHashCode` của Lombok trên Entity.
  * *Hậu quả:* Lombok mặc định lấy toàn bộ fields (kể cả `id`). Khi entity mới tạo (`new Product()`), `id = null` → hash code là A. Sau khi `save()` vào DB, DB sinh `id = 1` → hash code đổi thành B!
  * Nếu entity này đang nằm trong 1 `HashSet` hoặc `HashMap`, việc đổi hash code làm mất dấu object trong Bucket → **Memory leak hoặc không bao giờ tìm lại được object!**
* **Chuẩn xử lý (Tech Lead Rule):**
```java
@Override
public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    BaseEntity that = (BaseEntity) o;
    // Entity chưa persist (id == null) thì so sánh tham chiếu (identity)
    return id != null && id.equals(that.id);
}

@Override
public int hashCode() {
    // Trả về hằng số cố định để đảm bảo không bao giờ đổi hashcode trong cùng 1 vòng đời Session
    return getClass().hashCode();
}
```

---

### 📌 Quyết định 3: Thiết kế Mô hình Quan hệ (ERD)

```
┌─────────────────┐             ┌─────────────────────┐
│   TaxCategory   │             │       Unit          │
│   (Biểu thuế)   │             │   (Đơn vị tính)     │
└────────┬────────┘             └──────────┬──────────┘
         │ 1                               │ 1
         │ N                               │ N
┌────────┴─────────────────────────────────┴──────────┐
│                      Product                        │
│                (Hàng hóa / Dịch vụ)                 │
└─────────────────────────────────────────────────────┘

┌─────────────────┐             ┌─────────────────────┐
│     Account     │             │       Partner       │
│  (Tài khoản Kế  │             │   (Khách hàng/NCC)  │
│    toán TT88)   │             │   (TK công nợ 131)  │
└─────────────────┘             └─────────────────────┘
```

---

## 3. Phân Rã Công Việc Cụ Thể (Task Breakdown)

- [ ] **Task 1:** Tạo module và class `BaseEntity`, `ApiResponse<T>`.
- [ ] **Task 2:** Định nghĩa các Enum: `AccountType`, `PartnerType`, `ProductType`.
- [ ] **Task 3:** Tạo Entity & Repository cho `Account` và `TaxCategory`.
- [ ] **Task 4:** Tạo Entity & Repository cho `Unit`, `Partner`, `Product`.
- [ ] **Task 5:** Viết `MasterDataInitializer` để nạp sẵn dữ liệu chuẩn Thông tư 88 và Thông tư 40 khi app khởi động.
- [ ] **Task 6:** Kiểm thử persistence trên PostgreSQL, kiểm chứng cơ chế First-Level Cache & Dirty Checking.
