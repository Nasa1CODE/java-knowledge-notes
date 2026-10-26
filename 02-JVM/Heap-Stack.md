# Bộ nhớ Heap vs Stack & Cơ chế Pass-by-Value trong Java

> Tag: #jvm #memory #heap #stack #pass-by-value
> Ngày tạo: 2026-10-22
> Mức độ hiểu: [x] Hiểu cơ chế [x] Đã giải thích & kiểm chứng qua code [ ] Sẵn sàng phỏng vấn

---

## 1. Khái niệm & Bản chất phân chia bộ nhớ
Trong máy ảo Java (JVM Runtime Data Area), bộ nhớ được phân chia rõ rệt thành hai vùng chính:

```text
       STACK (Từng Thread riêng)                    HEAP (Dùng chung cho toàn JVM)
┌──────────────────────────────────────┐        ┌────────────────────────────────────┐
│ [Stack Frame của hàm modify()]       │        │                                    │
│   u: 0x100 ────────┐                 │        │  Object User A                     │
└────────────────────┼─────────────────┘        │  Địa chỉ: 0x100                    │
                     │                          │  { name: "Bob", id: 1 }            │
┌────────────────────┼─────────────────┐        │       ▲                            │
│ [Stack Frame của hàm main()]         │        │       │                            │
│   user: 0x100 ─────┴─────────────────┼────────┘                                    │
└──────────────────────────────────────┘        └────────────────────────────────────┘
```

* **Stack Memory:** 
  * Mỗi Thread khi sinh ra có một vùng Stack riêng (kích thước mặc định ~1MB, chỉnh bằng `-Xss`).
  * Lưu trữ các biến nguyên thủy (`int`, `boolean`, `double`...) và **địa chỉ tham chiếu (con trỏ)** trỏ tới đối tượng trên Heap.
  * Tự động giải phóng cực nhanh khi kết thúc phạm vi hàm (`Stack Frame` bị hủy) mà không cần Garbage Collector can thiệp.
* **Heap Memory:**
  * Dùng chung cho toàn bộ các Thread trong ứng dụng JVM (chỉnh bằng `-Xms`, `-Xmx`).
  * Lưu trữ **đối tượng thật (Object instance)** được tạo ra bằng từ khóa `new`.
  * Được quản lý và dọn dẹp bởi [[Garbage-Collection]].

---

## 2. Bản chất: Java là Pass-by-Value 100%

Một câu hỏi phỏng vấn kinh điển: *"Java là Pass-by-reference hay Pass-by-value?"*  
👉 **Câu trả lời tuyệt đối: Java LUÔN LUÔN là Pass-by-Value (truyền tham trị).**

### Phân tích 2 trường hợp:

#### Trường hợp 1: Gán lại đối tượng (`= new`) $\longrightarrow$ Bên ngoài KHÔNG đổi
```java
public void modify(User u) {
    u = new User("Other"); // Chỉ làm biến copy 'u' trên Stack của modify trỏ sang object mới
}
// Ngoài main(): biến 'user' ban đầu vẫn trỏ về đối tượng cũ!
```

#### Trường hợp 2: Thay đổi trạng thái (`setter`) $\longrightarrow$ Bên ngoài BỊ đổi
```java
public void modify(User u) {
    u.setName("Bob"); // Tác động thẳng vào vùng nhớ Heap chung mà cả 2 con trỏ đang trỏ tới!
}
// Ngoài main(): user.getName() sẽ trở thành "Bob"!
```

---

## 3. Lỗi thực tế dự án hay gặp (Production Gotchas)
* ⚠️ **`StackOverflowError`:** Xảy ra khi đệ quy vô hạn hoặc vòng lặp gọi hàm quá sâu làm tràn Stack Frame của thread.
* ⚠️ **`OutOfMemoryError: Java heap space`:** Xảy ra khi nhồi quá nhiều object lên Heap mà không giải phóng, hoặc do Memory Leak.

---

## 4. Khái niệm liên quan
* [[Garbage-Collection]] — Bộ dọn rác quản lý các object trên Heap.
* [[equals-hashcode]] — So sánh địa chỉ ô nhớ (`==`) vs so sánh giá trị logic trên Heap.
* [[Collections]] — Cách `ArrayList` và `LinkedList` lưu các node và mảng trên Heap.
