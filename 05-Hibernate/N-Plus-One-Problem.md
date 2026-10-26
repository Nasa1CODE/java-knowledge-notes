# N+1 Query Problem

> Tag: #hibernate #performance #database #n-plus-1
> Ngày tạo: 2026-10-21
> Mức độ hiểu: [x] Hiểu cơ chế [x] Đã xử lý trong dự án [ ] Sẵn sàng phỏng vấn

---

## 1. Khái niệm & Tại sao sinh ra?
* **Vấn đề:** Khi bạn query 1 danh sách gồm $N$ bản ghi cha (Parent), và ứng dụng duyệt qua từng bản ghi cha để lấy danh sách con (Children) có quan hệ `OneToMany` hoặc `ManyToOne` (đặc biệt khi đặt `FetchType.LAZY` hoặc dùng `findAll()`).
* **Hậu quả:** 
  * 1 câu query ban đầu để lấy $N$ records cha.
  * $N$ câu query tiếp theo để lấy con cho từng record cha.
  * Tổng cộng: $1 + N$ câu queries bắn về CSDL, làm sụp đổ hiệu năng hệ thống khi $N$ lớn!

---

## 2. Các giải pháp khắc phục triệt để
1. **`JOIN FETCH` trong JPQL:**
   ```java
   @Query("SELECT o FROM Order o JOIN FETCH o.orderItems WHERE o.status = :status")
   List<Order> findWithItems(@Param("status") String status);
   ```
2. **`@EntityGraph` (Spring Data JPA):**
   ```java
   @EntityGraph(attributePaths = {"orderItems"})
   List<Order> findByStatus(String status);
   ```
3. **Cấu hình Batch Size (Giải pháp an toàn cho toàn dự án):**
   Trong `application.yml`:
   ```yaml
   spring:
     jpa:
       properties:
         hibernate:
           default_batch_fetch_size: 50
   ```
   *Khi có batch size = 50, $N$ câu lệnh riêng lẻ sẽ được gộp thành câu `WHERE parent_id IN (?, ?, ...)` giúp giảm số queries từ $1 + N$ xuống $1 + \lceil N / 50 \rceil$.*

---

## 3. Khái niệm liên quan (Knowledge Graph)
* [[Hibernate-Session]] — Session thực thi các query con khi chạm vào proxy.
* [[LazyInitializationException]] — Xảy ra khi cố gắng load con mà Session đã đóng.
* [[Query-Optimization]] — Tối ưu hóa câu lệnh SQL và hạn chế round-trips.
