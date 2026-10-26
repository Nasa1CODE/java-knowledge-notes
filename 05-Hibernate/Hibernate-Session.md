# Hibernate Session

> Tag: #hibernate #jpa #database #session
> Ngày tạo: 2026-10-21
> Mức độ hiểu: [x] Hiểu cơ chế [x] Đã kiểm chứng qua code [ ] Sẵn sàng phỏng vấn

---

## 1. Khái niệm & Tại sao sinh ra? (Problem & Solution)
* **Vấn đề thực tế:** Khi thao tác với CSDL qua JDBC thuần, ta phải viết thủ công từng câu `SELECT`, `UPDATE`, quản lý connection, mapping dữ liệu cột sang đối tượng Java rất nhàm chán và dễ lỗi. Đồng thời, nếu gọi nhiều câu `UPDATE` cùng lúc, ứng dụng sẽ gửi nhiều request xuống DB gây giảm hiệu năng (network round-trips).
* **Định nghĩa ngắn gọn:** Hibernate `Session` là cầu nối chính giữa ứng dụng Java và CSDL. Nó đại diện cho một **đơn vị làm việc (Unit of Work)**, bọc quanh một JDBC Connection và chứa một [[Persistence-Context]] để quản lý vòng đời của các Entity.
* ⚠️ **Phân biệt quan trọng:** Hibernate `Session` **HOÀN TOÀN KHÁC** với `HttpSession` (phiên đăng nhập web của người dùng).

---

## 2. Cơ chế hoạt động bên dưới (Under the Hood)
1. **Quản lý Persistence Context (First-Level Cache):** Mỗi khi gọi `session.find()` hoặc `session.get()`, Hibernate kiểm tra xem Entity đã nằm trong bộ nhớ đệm cấp 1 của Session chưa. Nếu có rồi thì trả về ngay lập tức mà không bắn thêm câu SQL nào.
2. **Theo dõi thay đổi ([[Dirty-Checking]]):** Khi tải một entity vào Session, Hibernate lưu một bản chụp trạng thái (Snapshot). Trước khi transaction commit hoặc khi gọi `flush()`, Hibernate so sánh trạng thái hiện tại với Snapshot. Nếu có thuộc tính thay đổi, nó sẽ tự động sinh câu lệnh `UPDATE`.
3. **Đồng bộ xuống DB (Flush vs Commit):**
   * `flush()`: Đẩy các câu lệnh SQL đã tích lũy trong Session xuống DB nhưng chưa chốt dữ liệu (transaction chưa commit).
   * `commit()`: Thực hiện commit transaction của DB (lúc này dữ liệu mới chính thức được ghi vĩnh viễn).

---

## 3. Code ví dụ tối giản (Minimal Reproducible Example)

```java
// Cách hoạt động cổ điển qua SessionFactory:
Session session = sessionFactory.openSession();
Transaction tx = null;
try {
    tx = session.beginTransaction();
    
    // 1. Tải Entity (Persistent state)
    Product product = session.get(Product.class, 1L);
    
    // 2. Thay đổi giá trị - Không cần gọi session.update() hay repository.save()!
    product.setPrice(new BigDecimal("150000"));
    
    // 3. Commit - Hibernate tự động Dirty Check và bắn UPDATE trước khi commit
    tx.commit(); 
} catch (Exception e) {
    if (tx != null) tx.rollback();
    throw e;
} finally {
    session.close(); // Giải phóng connection về pool
}
```

Trong **Spring Boot / Spring Data JPA**, Hibernate `Session` được ẩn bên dưới `EntityManager`. Mỗi phương thức có `@Transactional` sẽ gắn liền với một `EntityManager` (và Hibernate Session) trong suốt vòng đời của method đó thông qua `TransactionSynchronizationManager`.

---

## 4. Lỗi thực tế dự án hay gặp (Production Gotchas & Anti-patterns)
* ⚠️ **Lỗi 1: Session quá dài (Open Session In View - OSIV):** 
  * Spring Boot mặc định bật `spring.jpa.open-in-view=true`. Session kéo dài đến tận View/Controller khiến connection bị giữ lâu trong HikariCP pool, dễ gây cạn kiệt connection khi tải cao.
  * *Khắc phục:* Cân nhắc tắt OSIV (`spring.jpa.open-in-view=false`) và dùng DTO Projection.
* ⚠️ **Lỗi 2: Lầm tưởng phải gọi `repository.save()` khi update:**
  * Trong method có `@Transactional`, entity lấy từ DB đã ở trạng thái *Managed*. Chỉ cần `entity.setName("X")` là xong. Gọi `save()` thừa thãi và có thể gây hiểu sai về cơ chế Dirty Checking.

---

## 5. Khái niệm liên quan (Knowledge Graph)
* [[Persistence-Context]] — Không gian lưu trữ và quản lý các entity đang active trong Session.
* [[Dirty-Checking]] — Cơ chế tự động so sánh snapshot để sinh SQL update.
* [[First-Level-Cache]] — Cache nội bộ của Session, sống cùng vòng đời Session.
* [[Spring-Transactional]] — Cách Spring quản lý phạm vi Session/EntityManager tự động.
* [[LazyInitializationException]] — Ngoại lệ xảy ra khi truy cập quan hệ Lazy mà Session đã đóng.

---

## 6. Câu hỏi tự kiểm tra / Phỏng vấn
- [ ] Phân biệt sự khác nhau giữa `session.get()` và `session.load()`?
- [ ] Flush khác Commit ở điểm nào? Khi nào Hibernate tự động kích hoạt Flush?
- [ ] Tại sao không nên mở Hibernate Session quá lâu?
- [ ] So sánh `Hibernate Session` và `HttpSession`?
