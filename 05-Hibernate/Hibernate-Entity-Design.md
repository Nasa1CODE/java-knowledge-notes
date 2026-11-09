# Thiết kế JPA Entity & Cơ chế Hibernate (Thực chiến HKD)

**Tags:** #hibernate #jpa #database #concurrency #optimistic-locking  
**Related:** [[05-Hibernate/Dirty-Checking|Dirty-Checking]], [[05-Hibernate/First-Level-Cache|First-Level-Cache]], [[05-Hibernate/N-Plus-One-Problem|N-Plus-One-Problem]]  
**Status:** ✅ Done (Áp dụng tại `features/HKD-001`)

---

## 🧠 1. Vấn đề thực tế từ dự án HKD

Trong phân hệ Danh mục gốc (Master Data), nhiều người dùng (kế toán, chủ hộ, thu ngân) cùng đọc và chỉnh sửa dữ liệu hàng hóa, giá bán, biểu thuế. Nếu thiết kế Entity cẩu thả, hệ thống sẽ gặp 3 lỗi nghiêm trọng:
1. **Lỗi Memory Leak / HashSet hư hỏng** do `equals()` và `hashCode()` sai quy cách.
2. **Lỗi Ghi đè dữ liệu (Lost Update)** khi 2 người cùng sửa 1 bản ghi cùng lúc.
3. **Bẫy N+1 Query** làm nghẽn Database khi tải danh sách sản phẩm kèm Đơn vị tính và Biểu thuế.

---

## 🚫 2. Anti-Pattern: Tại sao KHÔNG ĐƯỢC dùng `@Data` của Lombok trên Entity?

```java
// ❌ CỰC KỲ NGUY HIỂM:
@Entity
@Data // Lombok tự sinh equals() và hashCode() bằng TOÀN BỘ fields (kể cả id)
public class Product {
    @Id @GeneratedValue
    private Long id;
    private String name;
}
```

### Kịch bản lỗi trong JVM:
1. Bạn tạo mới: `Product p = new Product();` → Lúc này `p.getId() == null`.
2. Bạn thêm vào Set: `Set<Product> set = new HashSet<>(); set.add(p);`  
   → `hashCode()` được tính với `id = null` → Object rơi vào **Bucket số 3**.
3. Bạn lưu vào DB: `productRepository.save(p);`  
   → Hibernate gán `id = 100` từ DB sequence trả về.
4. Bạn kiểm tra: `set.contains(p);`  
   → Java tính lại `hashCode()` với `id = 100` → Object trỏ sang **Bucket số 8**!  
   👉 **Kết quả:** `set.contains(p)` trả về **`false`** dù object vẫn đang nằm trong Set!

### ✅ Giải pháp chuẩn Tech Lead:
```java
@Override
public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    BaseEntity that = (BaseEntity) o;
    return id != null && Objects.equals(id, that.id);
}

@Override
public int hashCode() {
    // Trả về hằng số cố định theo Class -> hash code KHÔNG BAO GIỜ bị thay đổi!
    return getClass().hashCode();
}
```

---

## ⚡ 3. Khóa Lạc Quan (`@Version` Optimistic Locking)

```java
@Version
@Column(name = "version")
private Long version;
```

### Cơ chế hoạt động:
* Khi đọc bản ghi: `SELECT id, name, price, version FROM cat_products WHERE id = 1` (ví dụ `version = 1`).
* Khi cập nhật, Hibernate tự động thêm điều kiện:
  ```sql
  UPDATE cat_products 
  SET default_sale_price = 150000, version = 2 
  WHERE id = 1 AND version = 1;
  ```
* Nếu một transaction khác đã update trước đó (khiến `version` trong DB tăng lên 2), câu `UPDATE` trên sẽ cập nhật được **0 dòng**.
* Hibernate phát hiện số dòng bị ảnh hưởng = 0 → ném ngay **`OptimisticLockException`** → bảo vệ dữ liệu không bị ghi đè ngầm mà không cần lock table/row ở DB!

---

## 🔄 4. Cơ chế Dirty Checking của Hibernate

Trong một `@Transactional`, bạn **không cần gọi `repository.save(entity)`** khi cập nhật dữ liệu:

```java
@Transactional
public ProductDto updatePrice(Long id, BigDecimal newSalePrice) {
    // 1. Hibernate load entity vào Persistence Context (Snapshot được tạo)
    Product product = productRepository.findById(id).orElseThrow();

    // 2. Chỉ cần gọi setter thay đổi trạng thái
    product.setDefaultSalePrice(newSalePrice);

    // 3. Khi method kết thúc, Transaction COMMIT:
    // Hibernate tự so sánh trạng thái hiện tại với Snapshot ban đầu.
    // Nếu có sự khác biệt (DIRTY), Hibernate tự sinh câu lệnh UPDATE!
    return ProductDto.fromEntity(product);
}
```

---

## 🚀 5. Chống N+1 Query bằng `@EntityGraph`

Khi một Entity có quan hệ `@ManyToOne(fetch = FetchType.LAZY)` (ví dụ: `Product` liên kết `Unit` và `TaxCategory`):
* Gọi `productRepository.findAll()` thông thường sẽ sinh ra: 1 query lấy N sản phẩm + N query lấy Unit + N query lấy TaxCategory = **2N + 1 Queries**!
* Giải pháp:
  ```java
  @EntityGraph(attributePaths = {"unit", "taxCategory"})
  List<Product> findAllByIsDeletedFalse();
  ```
* Hibernate sẽ tự động sinh câu lệnh **`LEFT OUTER JOIN`** để lấy sạch dữ liệu trong **đúng 1 query duy nhất**!

---
*Tài liệu thuộc phân hệ HKD-001 — Last updated: 2026-11-09*
