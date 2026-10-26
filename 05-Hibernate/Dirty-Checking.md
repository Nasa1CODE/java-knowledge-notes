# Dirty Checking trong Hibernate

> Tag: #hibernate #jpa #dirty-checking
> Ngày tạo: 2026-10-21
> Mức độ hiểu: [x] Hiểu cơ chế [ ] Đã kiểm chứng qua code [ ] Sẵn sàng phỏng vấn

---

## 1. Khái niệm & Tại sao sinh ra? (Problem & Solution)
* **Vấn đề thực tế:** Nếu lập trình viên phải nhớ gọi lệnh `UPDATE` cho từng object bị sửa đổi thì rất dễ quên hoặc cập nhật thừa thãi những trường không đổi.
* **Định nghĩa ngắn gọn:** Dirty Checking là khả năng của Hibernate tự động phát hiện xem một Entity ở trạng thái *Managed* có bị thay đổi dữ liệu hay không, và tự động tạo ra câu lệnh SQL `UPDATE` tương ứng khi Session thực hiện `flush()`.

---

## 2. Cơ chế hoạt động bên dưới
1. **Lưu Snapshot:** Khi một entity được load vào [[Persistence-Context]], Hibernate tạo một bản sao lưu (snapshot) các giá trị của các thuộc tính tại thời điểm đó.
2. **So sánh lúc Flush:** Trước khi commit transaction, Hibernate duyệt qua tất cả các entity trong Persistence Context và so sánh từng thuộc tính hiện tại với snapshot ban đầu.
3. **Sinh SQL Update:** Nếu phát hiện sự khác biệt ("dirty"), câu lệnh `UPDATE` sẽ được thêm vào hàng đợi thực thi. Mặc định Hibernate sẽ update tất cả các cột của table, trừ khi dùng annotation `@DynamicUpdate`.

---

## 3. Khái niệm liên quan (Knowledge Graph)
* [[Hibernate-Session]] — Nơi lưu trữ snapshot và kích hoạt dirty checking lúc flush.
* [[Persistence-Context]] — Vòng đời của Entity Managed.
* [[Spring-Transactional]] — Tự động flush dirty checking khi transaction kết thúc thành công.
