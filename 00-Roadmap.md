# 🗺️ Java & Spring Boot Mastery Roadmap

> Hệ thống ôn tập và đào sâu kiến thức từ thực tế dự án đến bản chất cốt lõi.
> Dành cho Backend Developer (Java 21+, Spring Boot 3+, Hibernate/JPA).

---

## 📌 Nguyên tắc học & ôn tập
1. **Không học vẹt định nghĩa:** Luôn trả lời câu hỏi: *Vấn đề gì đã sinh ra khái niệm/tính năng này?*
2. **Liên kết kiến thức (Zettelkasten / Knowledge Graph):** Mỗi khái niệm mới phải liên kết đến ít nhất 2 khái niệm liên quan bằng cú pháp `[[Tên file]]`.
3. **Mỗi ngày 1 khái niệm:** Áp dụng theo [[Concept-Template|Khuôn mẫu ghi chép chuẩn]].
4. **Gắn liền kinh nghiệm dự án:** Đưa ngay các lỗi thực tế (Production issues) vào ghi chú.

---

## 🧭 Lộ trình 8 Tuần

### Tuần 1 - 2: Java Core & Memory Model (Bản chất dưới máy ảo)
- [x] [[equals-hashcode]] — Hợp đồng (Contract) giữa `equals` và `hashCode`, ảnh hưởng trong `HashMap`/`HashSet`. Đã test cơ chế bucket & treeify.
- [x] [[01-Java-Core/Composition-Over-Inheritance|Composition-Over-Inheritance]] — Inheritance Explosion, Strategy Pattern, NotificationService & PayrollService thực tế với Spring Boot.
- [x] [[Collections]] — Cấu trúc dữ liệu bên trong `ArrayList`, `LinkedList`, CPU Cache Locality, `HashMap` vs `ConcurrentHashMap` đa luồng.
- [x] [[01-Java-Core/Generics|Generics]] — Type Erasure, Wildcards `<? extends T>` / `<? super T>`, PECS rule, Generic Base Classes.
- [x] [[Heap-Stack]] — Bộ nhớ Heap vs Stack, cơ chế truyền tham số (Pass-by-value 100%) trong Java.
- [x] [[Garbage-Collection]] — Vòng đời Object (Eden, Survivor, Old Gen), Stop-The-World, thực hành mô phỏng Memory Leak & giám sát bằng Grafana + Prometheus.

### Tuần 3: Concurrency & Java 21+ Modern Features
- [x] [[03-Concurrency/Virtual-Threads|Virtual-Threads]] — Project Loom, Platform Thread vs Virtual Thread, Race Condition, AtomicInteger, Stateless design.
- [ ] [[Locks-and-Synchronized]] — `synchronized`, `ReentrantLock`, CAS (Atomic variables), hiện tượng Race condition.
- [ ] [[CompletableFuture]] — Lập trình bất đồng bộ không chặn (Non-blocking).

### Tuần 4 - 5: Hibernate & Database Deep-dive (Trọng tâm Backend)
- [ ] [[Hibernate-Session]] — Phiên làm việc Hibernate, so sánh với `HttpSession`.
- [ ] [[Persistence-Context]] — Vòng đời Entity: *Transient*, *Managed*, *Detached*, *Removed*.
- [ ] [[First-Level-Cache]] — Bộ nhớ đệm cấp 1 hoạt động trong phạm vi Session ra sao?
- [ ] [[Dirty-Checking]] — Cơ chế tự động phát hiện thay đổi và snapshot.
- [ ] [[Transaction-ACID]] — 4 thuộc tính ACID, vai trò của Write-Ahead Logging (WAL).
- [ ] [[Isolation-Levels]] — Read Uncommitted, Read Committed, Repeatable Read, Serializable; các hiện tượng Dirty Read, Non-repeatable Read, Phantom Read.
- [ ] [[N-Plus-One-Problem]] — N+1 query là gì? Cách giải quyết: `JOIN FETCH`, `@EntityGraph`, Batch size.

### Tuần 6 - 7: Spring Boot Internals
- [ ] [[IoC-and-DI]] — Đảo ngược điều khiển (IoC) và Tiêm phụ thuộc (Dependency Injection), Spring ApplicationContext.
- [ ] [[Spring-Bean-Lifecycle]] — Khởi tạo bean, `@PostConstruct`, `BeanPostProcessor`, `@PreDestroy`.
- [ ] [[Spring-Transactional]] — `@Transactional` hoạt động dưới nền tảng AOP Proxy như thế nào? Self-invocation trap và Rollback rules.
- [ ] [[Spring-Security-Architecture]] — Filter Chain, SecurityContextHolder, Stateless Authentication với JWT.

### Tuần 8: Tối ưu hiệu năng & Sự cố thực tế (Production Readiness)
- [ ] [[LazyInitializationException]] — Nguyên nhân mất Hibernate Session, cách xử lý chuẩn kiến trúc (DTO / Projection).
- [ ] [[Memory-Leak-JVM]] — Memory leak trong Java từ ThreadLocal, static collections, unclosed resources.
- [ ] [[Query-Optimization]] — Indexing trong database (B-Tree), Slow queries, Connection Pool (HikariCP) tuning.

---

## 🔗 Liên kết nhanh các thư mục
- [[01-Java-Core/]]
- [[02-JVM/]]
- [[03-Concurrency/]]
- [[04-Database/]]
- [[05-Hibernate/]]
- [[06-Spring-Boot/]]
- [[07-Performance/]]
- [[08-Production-Issues/]]
