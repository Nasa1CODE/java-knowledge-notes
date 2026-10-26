# Java Collections: ArrayList vs LinkedList & Memory Internals

> Tag: #java #collections #performance #memory
> Ngày tạo: 2026-10-22
> Mức độ hiểu: [x] Hiểu cơ chế [x] Đã kiểm chứng qua benchmark [ ] Sẵn sàng phỏng vấn

---

## 1. Khái niệm & Bản chất cấu trúc
* **ArrayList:** Bọc quanh một mảng động thuần túy (`Object[] elementData`). Các phần tử nằm ở các ô nhớ liền kề nhau trên Heap.
* **LinkedList:** Danh sách liên kết đôi (`Doubly Linked List`). Mỗi phần tử là một `Node<E>` chứa dữ liệu và 2 con trỏ `prev`, `next`, nằm rải rác trên Heap.

---

## 2. So sánh thực tế: Tại sao ArrayList gần như luôn chiến thắng?

### A. CPU Cache Locality (Hiện tượng Cache Hit vs Cache Miss)
* **ArrayList (Spatial Locality cao):** Do nằm trên các ô nhớ liền kề, khi CPU đọc một phần tử, phần cứng tự động nạp cả khối 64 bytes (Cache Line) vào L1/L2 Cache. Việc duyệt mảng đạt tốc độ tối đa của phần cứng.
* **LinkedList (Cache Miss liên tục):** Các `Node` phân tán trên Heap. Khi duyệt qua con trỏ `node.next`, CPU liên tục bị trượt Cache (Cache Miss), phải dừng lại chờ nạp dữ liệu từ RAM (chậm hơn L1 Cache hàng trăm lần).
* Thao tác dịch chuyển mảng của `ArrayList` được tối ưu ở mức phần cứng bằng lệnh native `System.arraycopy()`, nhanh hơn rất nhiều so với chi phí duyệt tìm Node của `LinkedList`.

### B. Hao phí bộ nhớ (Memory Overhead)
* `ArrayList`: Chỉ tốn 1 mảng tham chiếu (4 - 8 bytes/phần tử).
* `LinkedList`: Mỗi phần tử tốn thêm 1 object `Node` (Object header + 3 references $\approx$ 40-48 bytes/node). Gây áp lực cực lớn lên Garbage Collector (GC).

---

## 3. Bảng tổng kết khi đi phỏng vấn

| Tiêu chí | `ArrayList` | `LinkedList` |
|---|---|---|
| Cấu trúc bộ nhớ | Mảng liên tục (Contiguous) | Node rời rạc nối bằng con trỏ |
| Truy cập ngẫu nhiên `get(i)` | $O(1)$ | $O(N)$ |
| Thêm/xóa ở cuối | $O(1)$ (amortized) | $O(1)$ |
| Thêm/xóa ở giữa | $O(N)$ (thực tế rất nhanh nhờ `arraycopy`) | $O(N)$ để tìm + $O(1)$ để đổi trỏ (thực tế rất chậm do Cache Miss) |
| Bộ nhớ phụ trội | Rất ít | Rất nhiều (Object header + con trỏ) |
| Khi nào dùng? | **Mặc định 99% mọi trường hợp** | Khi chỉ làm hàng đợi `Queue/Deque` thao tác ở 2 đầu |

---

## 4. Multi-threading: HashMap vs Hashtable vs ConcurrentHashMap

### A. Vấn đề của HashMap trong môi trường đa luồng
* **Race Condition (Mất dữ liệu):** Hai thread cùng ghi vào 1 bucket dẫn tới ghi đè con trỏ, mất dữ liệu âm thầm.
* **100% CPU Infinite Loop:** Quá trình concurrent resize có thể làm hỏng cấu trúc danh sách liên kết thành vòng tròn tròn (`A -> B -> A`). Bất kỳ lệnh `get()` nào duyệt qua sẽ rơi vào vòng lặp vô tận, làm sập CPU.
* **ConcurrentModificationException:** Khi một thread duyệt qua map trong khi thread khác đang thêm/sửa.

### B. So sánh cơ chế khóa (Lock Granularity)

| Tiêu chí | `Hashtable` / `synchronizedMap` | `ConcurrentHashMap` (Java 8+) |
|---|---|---|
| Phạm vi khóa | **Toàn bộ Map** (Table-level lock) | **Từng Bucket riêng lẻ** (Bucket-level lock) |
| Đọc (`get`) | Bị khóa, phải chờ thread khác ghi xong | **Lock-free** (dùng `volatile`), đọc song song cực nhanh |
| Ghi (`put`) | Đơn luồng (luồng này ghi, luồng khác đứng chờ) | Đa luồng: Ghi vào các bucket khác nhau chạy song song |
| Cơ chế kỹ thuật | `synchronized` trên mọi method | Kết hợp **CAS** (nếu bucket rỗng) + `synchronized` trên Node đầu thùng |
| Hiệu năng thực tế | Rất kém khi tải cao | Rất cao, chuẩn công nghiệp cho Backend |

---

## 5. Khái niệm liên quan
* [[Heap-Stack]] — Vị trí lưu trữ mảng và các Node trên Heap.
* [[Garbage-Collection]] — Rác từ các Node của LinkedList.
* [[Locks-and-Synchronized]] — So sánh từ khóa `synchronized` và cơ chế CAS (Compare-And-Swap).
