# CompletableFuture

**Tags:** #java #concurrency #async #non-blocking #performance  
**Related:** [[03-Concurrency/Virtual-Threads|Virtual-Threads]], [[03-Concurrency/Locks-and-Synchronized|Locks-and-Synchronized]]  
**Status:** ✅ Done

---

## 🧠 Vấn đề — Tác vụ độc lập nhưng chạy tuần tự

```java
// 3 queries hoàn toàn độc lập nhau → nhưng đang chờ nhau!
List<EmployeeKpi> kpis = employeeKpiRepository.findByPeriodId(id); // 100ms
long totalEmployees     = userRepository.count();                   // 100ms
List<Department> depts  = departmentRepository.findAll();           // 50ms
// Tổng: 250ms ← lãng phí!
```

**Giải pháp:** Chạy song song → tổng thời gian = `max(100, 100, 50)` = **100ms**

---

## ✅ CompletableFuture cơ bản

```java
// supplyAsync — chạy async, có kết quả trả về
CompletableFuture<List<EmployeeKpi>> kpiFuture = CompletableFuture
    .supplyAsync(() -> employeeKpiRepository.findByPeriodId(id));

// runAsync — chạy async, không có kết quả
CompletableFuture<Void> logFuture = CompletableFuture
    .runAsync(() -> auditService.log("dashboard viewed"));

// join() — block chờ kết quả
List<EmployeeKpi> kpis = kpiFuture.join();
```

---

## 🔗 Chờ nhiều task song song — `allOf` / `anyOf`

```java
CompletableFuture<List<EmployeeKpi>> kpiFuture = CompletableFuture
    .supplyAsync(() -> employeeKpiRepository.findByPeriodId(id), executor);

CompletableFuture<Long> countFuture = CompletableFuture
    .supplyAsync(() -> userRepository.count(), executor);

// allOf: chờ TẤT CẢ hoàn thành
CompletableFuture.allOf(kpiFuture, countFuture)
    .thenApply(v -> buildStats(kpiFuture.join(), countFuture.join()))
    .join();

// anyOf: chờ 1 cái NHANH NHẤT hoàn thành
CompletableFuture.anyOf(source1, source2, source3)
    .thenAccept(result -> System.out.println("Kết quả nhanh nhất: " + result));
```

---

## 🔗 Chuỗi xử lý — `thenApply`, `thenCompose`, `thenAccept`

```java
CompletableFuture
    .supplyAsync(() -> employeeService.findById(id))   // 1. Lấy Employee
    .thenApply(emp -> emp.getDepartmentId())            // 2. Transform (sync)
    .thenCompose(deptId ->                             // 3. Chain async task
        CompletableFuture.supplyAsync(() -> deptService.findById(deptId)))
    .thenAccept(dept ->                                // 4. Consume kết quả
        System.out.println("Dept: " + dept.getName()));
```

| Method | Dùng khi |
|---|---|
| `thenApply(fn)` | Transform kết quả — như `map()` |
| `thenCompose(fn)` | Chain 2 async task — như `flatMap()` |
| `thenAccept(fn)` | Dùng kết quả, không trả về gì |
| `thenRun(fn)` | Chạy sau khi xong, không cần kết quả |

---

## ⚠️ Xử lý lỗi — `exceptionally`, `handle`

```java
// exceptionally: bắt lỗi, trả về fallback
CompletableFuture
    .supplyAsync(() -> externalApiClient.call())  // có thể throw Exception
    .exceptionally(ex -> {
        log.warn("API lỗi: {}", ex.getMessage());
        return DefaultValue.empty();              // fallback, không crash
    });

// handle: xử lý cả thành công lẫn thất bại
CompletableFuture
    .supplyAsync(() -> employeeService.findById(id))
    .handle((result, ex) -> {
        if (ex != null) return Employee.empty();  // lỗi → trả default
        return result;                            // thành công → trả kết quả
    });
```

---

## 🏭 Custom ThreadPool — Quan trọng trong Production!

```java
// ❌ Mặc định: dùng ForkJoinPool.commonPool() — dùng chung toàn app!
CompletableFuture.supplyAsync(() -> heavyTask());

// ✅ Tạo pool riêng cho từng loại task
ExecutorService dashboardExecutor = Executors.newFixedThreadPool(5, r -> {
    Thread t = new Thread(r);
    t.setName("dashboard-async-" + t.getId());  // đặt tên để debug dễ
    return t;
});

CompletableFuture.supplyAsync(() -> employeeKpiRepository.findByPeriodId(id), dashboardExecutor);
```

---

## 🏭 Ví dụ thực tế — DashboardService trong project MMS

```java
@Service
public class DashboardService {

    private final ExecutorService dashboardExecutor =
        Executors.newFixedThreadPool(5);

    public DashboardStatsDto getDashboardStatsAsync(Long periodId) {

        // 2 queries chạy SONG SONG
        CompletableFuture<List<EmployeeKpi>> kpiFuture = CompletableFuture
            .supplyAsync(() -> employeeKpiRepository.findByPeriodId(periodId), dashboardExecutor)
            .exceptionally(ex -> List.of());  // lỗi → list rỗng

        CompletableFuture<Long> countFuture = CompletableFuture
            .supplyAsync(() -> userRepository.count(), dashboardExecutor)
            .exceptionally(ex -> 0L);         // lỗi → 0

        // Gom kết quả sau khi cả 2 xong
        return CompletableFuture.allOf(kpiFuture, countFuture)
            .thenApply(v -> buildStats(period, kpiFuture.join(), countFuture.join()))
            .join();
    }

    // Nhiều departments song song
    public List<DepartmentPerformanceDto> getDepartmentPerformance(Long periodId) {
        List<CompletableFuture<DepartmentPerformanceDto>> futures = departments.stream()
            .map(dept -> CompletableFuture.supplyAsync(
                () -> processDept(dept, periodId), dashboardExecutor))
            .toList();

        return CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]))
            .thenApply(v -> futures.stream().map(CompletableFuture::join).toList())
            .join();
    }
}
```

**Endpoints để test:**

```
GET /dashboard/stats        ← sequential (cũ)
GET /dashboard/stats/async  ← CompletableFuture song song (mới)
```

**Log khi chạy async:**

```
[dashboard-async-1] Bắt đầu query KPIs...
[dashboard-async-2] Bắt đầu count employees...  ← cùng lúc!
getDashboardStatsAsync hoàn thành trong 45ms    ← thay vì 100ms
```

---

## 📊 Tóm tắt API

| Method | Mô tả |
|---|---|
| `supplyAsync(fn, executor)` | Chạy async, có kết quả |
| `runAsync(fn, executor)` | Chạy async, không có kết quả |
| `allOf(f1, f2...)` | Chờ **tất cả** xong |
| `anyOf(f1, f2...)` | Chờ **1 cái nhanh nhất** |
| `thenApply(fn)` | Transform kết quả (sync) |
| `thenCompose(fn)` | Chain async task |
| `thenAccept(fn)` | Consume kết quả |
| `exceptionally(fn)` | Bắt lỗi, trả fallback |
| `handle(fn)` | Xử lý cả thành công lẫn lỗi |
| `join()` | Block chờ kết quả |

---

## 🔑 Quy tắc thực tế

```
1. Luôn dùng custom ExecutorService — không dùng ForkJoinPool.commonPool()
2. Luôn thêm exceptionally() — tránh 1 task lỗi làm crash cả luồng
3. allOf() để chờ tất cả, anyOf() để lấy kết quả nhanh nhất
4. thenCompose thay vì thenApply khi fn trả về CompletableFuture
5. join() chỉ gọi ở cuối cùng — gọi sớm = block thread = mất lợi ích async
```

---
*Last updated: 2026-11-09*
