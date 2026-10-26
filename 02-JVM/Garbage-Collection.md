# JVM Garbage Collection (GC) & Memory Generations

> Tag: #jvm #memory #gc #performance
> Ngày tạo: 2026-10-22
> Mức độ hiểu: [x] Hiểu cơ chế [ ] Đã phân tích GC log [ ] Sẵn sàng phỏng vấn

---

## 1. Khái niệm & Tại sao phân chia thế hệ? (Weak Generational Hypothesis)
* **Quy luật thực tế:** Hơn 98% đối tượng trong ứng dụng Java chết ngay sau khi được tạo ra (các biến tạm thời, request DTOs, strings trong phương thức).
* **Mục đích chia thế hệ:** Thay vì quét toàn bộ vùng nhớ Heap khổng lồ (vốn cực kỳ tốn CPU), JVM phân vùng bộ nhớ để tập trung dọn rác ở vùng có tỷ lệ "chết" cao nhất trong thời gian cực ngắn.

---

## 2. Cấu trúc bộ nhớ Heap trong JVM

```text
               TỔNG THỂ BỘ NHỚ HEAP TRONG JVM
┌──────────────────────────────────────┬───────────────────────┐
│              Young Gen               │        Old Gen        │
│  ┌──────────┬──────────┬──────────┐  │                       │
│  │   Eden   │    S0    │    S1    │  │       (Tenured)       │
│  └──────────┴──────────┴──────────┘  │                       │
└──────────────────────────────────────┴───────────────────────┘
```

### A. Young Generation (Vùng sơ sinh)
* **Eden Space:** Nơi đón nhận mọi đối tượng mới được tạo ra bằng lệnh `new`. Khi Eden đầy, **Minor GC** được kích hoạt.
* **Survivor Spaces (S0 & S1):** Chứa các đối tượng sống sót sau Minor GC. Tại một thời điểm, luôn có một vùng Survivor để trống để luân chuyển dọn rác (`Copying algorithm`).
* **Tuổi của Object (Age / Tenuring Threshold):** Mỗi lần sống sót qua Minor GC, tuổi của object tăng lên 1. Mặc định khi đạt 15 tuổi, object được "thăng hạng" (promotion) chuyển sang **Old Gen**.

### B. Old Generation (Vùng người già / Tenured)
* Chứa các đối tượng có thời gian sống lâu dài: Spring Beans (Singleton), Database Connection Pool, static caches.
* Vùng này rất ít khi phải dọn. Khi Old Gen bị đầy, **Major GC / Full GC** sẽ kích hoạt để quét toàn bộ Heap.

---

## 3. Hiện tượng Stop-The-World (STW)
* **Bản chất:** Là khoảng thời gian JVM **tạm dừng hoàn toàn tất cả các thread ứng dụng** để Garbage Collector có thể kiểm đếm tham chiếu (Mark) và di dời vùng nhớ (Compact/Sweep) an toàn mà không bị tranh chấp dữ liệu.
* **Tác động trên Production:**
  * STW kéo dài gây đơ hệ thống, response time tăng vọt.
  * Health check (Liveness / Readiness probe trên K8s) bị timeout dẫn đến pod bị Restart oan.
* **Các bộ thu gom rác hiện đại:**
  * **Parallel GC (Java 8 cũ):** Tối ưu thông lượng (Throughput) nhưng STW dài.
  * **G1GC (Mặc định từ Java 9 đến Java 21):** Chia nhỏ heap thành hàng nghìn Region, cho phép đặt mục tiêu thời gian dừng tối đa (`-XX:MaxGCPauseMillis=200`).
  * **ZGC (Thế hệ mới trên Java 17/21+):** Thu gom rác đồng thời (Concurrent), ép thời gian STW xuống **dưới 1ms**, bất kể kích thước Heap từ vài GB đến vài TB!

---

## 4. Thực hành thực tế & Giám sát trên Production (Grafana + Prometheus)

### A. Thí nghiệm trực quan: GcDemo & MemoryTestController
* **Tạo rác ngắn hạn (Eden):** Rác chết ngay sau vòng lặp $\rightarrow$ Minor GC dọn sạch trong 1ms (Memory tụt từ 15MB về 0MB ngay lập tức).
* **Mô phỏng Memory Leak (List giữ tham chiếu):** 
  * Khi object không được giải phóng, nó sống sót qua nhiều đợt GC và bị đẩy dồn dập sang **Old Gen**.
  * Khi Old Gen đầy $\rightarrow$ Kích hoạt **Full GC (Stop-The-World kéo dài)**.
  * Nếu Full GC không dọn được gì $\rightarrow$ Ném ngoại lệ `java.lang.OutOfMemoryError: Java heap space`.

### B. Kiến trúc giám sát chuẩn Production
```text
[Spring Boot Backend] ──(/api/actuator/prometheus)──> [Prometheus :9090] ──> [Grafana :3000]
```
* **Metrics quan trọng trên Grafana (Dashboard 4701):**
  * `G1 Eden Space`: Đồ thị hình răng cưa nhấp nhô (rác sinh ra liên tục và bị Minor GC dọn).
  * `G1 Old Gen`: Thước đo sức khỏe sống còn của hệ thống. Nếu đường Old Gen chỉ tăng mà không giảm sau khi chạy GC $\rightarrow$ Ứng dụng chắc chắn đang bị **Memory Leak**!
  * `GC Pause Time`: Thời gian ứng dụng bị đóng băng (STW).

---

## 5. Khái niệm liên quan
* [[Heap-Stack]] — Phân biệt Stack (lưu frame & con trỏ) vs Heap (lưu Object thật cho GC quản lý).
* [[Memory-Leak-JVM]] — Khi object không còn dùng nhưng vẫn bị giữ tham chiếu khiến GC không thể dọn dẹp.
