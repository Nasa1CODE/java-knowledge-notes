# Virtual Threads (Project Loom — Java 21)

**Tags:** #java #concurrency #java21 #virtual-threads #performance  
**Related:** [[03-Concurrency/Locks-and-Synchronized|Locks-and-Synchronized]], [[03-Concurrency/CompletableFuture|CompletableFuture]]  
**Status:** ✅ Done

---

## 🧠 Vấn đề Platform Thread giải quyết

### Platform Thread = OS Thread

Mỗi request vào Spring Boot → tạo 1 **Platform Thread** (= 1 OS Thread thật):

```
Request 1  →  Thread 1  →  [query DB... chờ 200ms]  →  response
Request 2  →  Thread 2  →  [query DB... chờ 200ms]  →  response
```

### Timeline thực tế của 1 request:

```
|-- 1ms: parse --|------ 200ms: chờ DB ------|-- 1ms: response --|

CPU làm việc thật:  2ms  (1%)
Thread "ngủ chờ": 200ms  (99%)  ← BLOCKED, nhưng vẫn chiếm RAM!
```

### Hậu quả khi có 10,000 users:

```
Thread Pool Tomcat mặc định: 200 threads
User 1-200   → có thread xử lý ✅
User 201+    → xếp hàng chờ → TIMEOUT ❌

CPU usage:  5%    ← rảnh tênh
RAM usage:  200MB (200 threads × ~1MB/thread)
```

> Bottleneck không phải CPU — mà là **số lượng thread bị giới hạn**!

---

## ✅ Virtual Threads — Giải pháp Java 21

### Tách Java Thread khỏi OS Thread

```
Platform Thread  =  OS Thread   (~1MB RAM, OS quản lý)
Virtual Thread   =  JVM Thread  (~vài KB RAM, JVM quản lý)
```

### Cơ chế hoạt động:

```
10,000 requests → 10,000 Virtual Threads   ← tạo thoải mái, nhẹ
                        ↓
              Chỉ ~10 OS Thread thật sự chạy

Virtual Thread 1 đang chờ DB
  → JVM: "Mày ngủ đi, tao mount OS Thread sang thằng khác"
Virtual Thread 2 có việc cần làm
  → JVM: "OK, tao gắn OS Thread vào mày"
```

### Kết quả:

```
CPU usage:  80%   ← đang làm việc thật sự
RAM usage:  ~50MB (10,000 virtual threads × vài KB)
Queue:      Không còn! 10,000 users được phục vụ bình thường
```

---

## 🔧 Bật Virtual Threads trong Spring Boot 3.2+

### Cách 1: application.yml (Recommended)

```yaml
spring:
  threads:
    virtual:
      enabled: true   # Tomcat tự dùng Virtual Thread cho mọi request
```

### Cách 2: Config thủ công

```java
@Configuration
public class ThreadConfig {

    @Bean
    public TomcatProtocolHandlerCustomizer<?> virtualThreadsCustomizer() {
        return protocolHandler ->
            protocolHandler.setExecutor(Executors.newVirtualThreadPerTaskExecutor());
    }
}
```

---

## ⚠️ Race Condition — Bẫy khi dùng Virtual Threads

### Vấn đề: Shared Mutable State

```java
@Service
public class PayrollService {
    private int totalProcessed = 0;  // ← biến dùng chung!

    public void processPayroll(Employee emp) {
        Thread.sleep(100);
        totalProcessed++;  // ← 10,000 threads cùng cộng vào đây
    }
}
```

### Tại sao sai? — `totalProcessed++` thực ra là 3 bước:

```
Bước 1: ĐỌC  → lấy giá trị từ RAM vào CPU
Bước 2: TÍNH → cộng thêm 1
Bước 3: GHI  → lưu lại RAM

Thread A: ĐỌC(100) → TÍNH(101) →              GHI(101)
Thread B: ĐỌC(100) →             TÍNH(101) → GHI(101)
                                              ↑ mất 1 lần đếm!
```

Kết quả: **Race Condition** → 10,000 threads nhưng `totalProcessed` có thể là 8,000, 9,500... ngẫu nhiên!

---

## ✅ 3 Cách sửa Race Condition

### Cách 1: `synchronized` — Lock cả method

```java
public synchronized void processPayroll(Employee emp) {
    Thread.sleep(100);
    totalProcessed++;  // chỉ 1 thread vào được tại 1 thời điểm
}
// ❌ Nhược điểm: 10,000 threads xếp hàng → chậm, mất lợi ích Virtual Thread
```

### Cách 2: `AtomicInteger` — Không cần lock (Recommended)

```java
private AtomicInteger totalProcessed = new AtomicInteger(0);

public void processPayroll(Employee emp) {
    Thread.sleep(100);
    totalProcessed.incrementAndGet();  // đọc-tính-ghi trong 1 thao tác CPU (CAS)
}

public int getTotal() { return totalProcessed.get(); }
```

**CAS (Compare-And-Swap):**  
"Nếu giá trị vẫn là X → đổi thành X+1. Nếu ai đổi rồi → thử lại."  
→ Không lock, không xếp hàng → **nhanh hơn synchronized nhiều!**

### Cách 3: Stateless — Tốt nhất, tránh shared state

```java
@Service
public class PayrollService {
    // Không có biến instance nào!

    public PayrollResult processPayroll(Employee emp) {
        Thread.sleep(100);
        double salary = calculateSalary(emp);
        return new PayrollResult(emp.getId(), salary);  // local object, không share
    }
}

// Gom kết quả bên ngoài:
List<PayrollResult> results = employees.parallelStream()
    .map(payrollService::processPayroll)
    .toList();
```

---

## 📊 So sánh

| | `synchronized` | `AtomicInteger` | Stateless |
|---|---|---|---|
| Thread-safe | ✅ | ✅ | ✅ |
| Hiệu năng | 🐢 Chậm | 🚀 Nhanh | 🚀🚀 Nhanh nhất |
| Dùng khi | Lock nhiều biến cùng lúc | Counter/flag đơn giản | Thiết kế đúng từ đầu |

## ⚡ Khi nào dùng / không dùng Virtual Threads

| | Virtual Thread |
|---|---|
| ✅ IO-bound: chờ DB, API, file | Tuyệt vời — thread nhường CPU khi chờ |
| ❌ CPU-bound: tính toán nặng | Không giúp được — thread không bị block |
| ⚠️ `synchronized` block lớn | Bị "pin" vào OS Thread → mất lợi ích |

---

## 🔑 Quy tắc vàng

```
1. Tránh shared mutable state → stateless service
2. Nếu cần share → dùng Atomic types (AtomicInteger, AtomicLong, AtomicReference...)
3. Phức tạp hơn → synchronized hoặc ReentrantLock
4. Spring Bean Singleton mặc định thread-safe — chỉ vỡ khi thêm mutable instance field!
```

---
*Last updated: 2026-10-26*
