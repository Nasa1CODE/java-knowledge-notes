# LazyInitializationException

> Tag: #hibernate #troubleshooting #exception #production
> Ngày tạo: 2026-10-21
> Mức độ hiểu: [x] Hiểu cơ chế [x] Đã xử lý trong dự án [ ] Sẵn sàng phỏng vấn

---

## 1. Khái niệm & Bản chất lỗi
Thông báo lỗi kinh điển:
`org.hibernate.LazyInitializationException: could not initialize proxy [com.example.Order#1] - no Session`

* **Nguyên nhân:**
  1. Trong Entity, quan hệ được khai báo `FetchType.LAZY` (ví dụ `@ManyToOne(fetch = FetchType.LAZY)` hoặc `@OneToMany`).
  2. Tại tầng Service, phương thức có `@Transactional` kết thúc $\longrightarrow$ Transaction hoàn tất $\longrightarrow$ [[Hibernate-Session]] tương ứng **bị đóng lại**.
  3. Khi dữ liệu ra đến Controller hoặc mapper DTO/JSON serializer (Jackson), ứng dụng mới gọi `order.getItems()` hoặc `order.getCustomer().getName()`.
  4. Lúc này Hibernate Proxy cần bắn query xuống DB để nạp dữ liệu thật, nhưng phát hiện Session đã bị đóng (Entity đang ở trạng thái *Detached* trong [[Persistence-Context]]) $\longrightarrow$ Ném ra `LazyInitializationException`.

---

## 2. Cách giải quyết chuẩn trong dự án thực tế
1. ✅ **Chuẩn nhất: Tải trước dữ liệu cần thiết tại Repository (Fetch Join / EntityGraph):**
   * Nếu Controller cần cả Items, viết query `JOIN FETCH` hoặc dùng `@EntityGraph` ngay tại repository layer.
2. ✅ **Sử dụng DTO Mapping trong phạm vi Transaction:**
   * Map Entity sang DTO ngay bên trong Service layer (nơi Session vẫn đang mở) trước khi trả về Controller.
3. ❌ **Không nên lạm dụng:**
   * Không đổi toàn bộ sang `FetchType.EAGER` (gây chậm hệ thống và bùng nổ query thừa).
   * Cân nhắc kỹ trước khi bật `Open Session In View (OSIV)` vì nó giữ connection pool của CSDL quá lâu.

---

## 3. Khái niệm liên quan (Knowledge Graph)
* [[Hibernate-Session]] — Phiên làm việc bị đóng là nguồn cơn gây ra lỗi.
* [[Persistence-Context]] — Trạng thái Detached của Entity.
* [[N-Plus-One-Problem]] — Mối liên hệ chặt chẽ giữa Lazy loading và số lượng câu query.
