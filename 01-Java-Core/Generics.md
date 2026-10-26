# Generics

**Tags:** #java #generics #type-safety #compile-time  
**Related:** [[01-Java-Core/Collections|Collections]], [[01-Java-Core/Composition-Over-Inheritance|Composition-Over-Inheritance]]  
**Status:** ✅ Done

---

## 🧠 Vấn đề Generics giải quyết

### Trước khi có Generics — dùng `Object`

```java
public class ApiResponse {
    private Object data;  // chứa bất kỳ kiểu nào
    public Object getData() { return data; }
}

// Dùng: phải cast thủ công
Employee emp = (Employee) response.getData();
// 💥 ClassCastException nếu cast sai kiểu — chỉ phát hiện lúc RUNTIME!
```

**2 vấn đề:**
1. **Runtime:** `ClassCastException` → app crash, người dùng thấy lỗi
2. **Compile time:** Compiler không bắt được lỗi cast sai kiểu

---

## ✅ Giải pháp: Generics

```java
public class ApiResponse<T> {       // T = type parameter
    private int status;
    private String message;
    private T data;                 // T thay cho Object

    public T getData() { return data; }
}

// Dùng:
ApiResponse<Employee>   empResponse  = new ApiResponse<>(200, "OK", employee);
ApiResponse<Department> deptResponse = new ApiResponse<>(200, "OK", department);

Employee   emp  = empResponse.getData();   // ✅ không cần cast
Department dept = deptResponse.getData();  // ✅

// Compiler bắt lỗi ngay:
Department wrong = empResponse.getData();  // 🔴 COMPILE ERROR!
```

> 💡 **Nguyên tắc:** Lỗi lúc **compile time** luôn tốt hơn lỗi lúc **runtime**.

---

## 🔬 Type Erasure — Bên dưới JVM

Generics **chỉ tồn tại lúc compile**. Lúc runtime → bị xóa hoàn toàn.

```java
// Code bạn viết:
ApiResponse<Employee> response = new ApiResponse<>(200, "OK", emp);
Employee result = response.getData();

// Bytecode JVM thực sự chạy (sau Type Erasure):
ApiResponse response = new ApiResponse(200, "OK", emp);
Employee result = (Employee) response.getData();  // compiler tự thêm cast
```

**Hệ quả — những thứ KHÔNG làm được vì Type Erasure:**

```java
// ❌ Không thể tạo instance của T
public <T> void create() {
    T obj = new T();  // COMPILE ERROR — JVM không biết T là class gì
}

// ❌ Không thể instanceof
if (data instanceof T) { }  // COMPILE ERROR

// ❌ Không thể tạo generic array
T[] arr = new T[10];  // COMPILE ERROR
```

---

## 🃏 Wildcards

### Tại sao cần Wildcard?

```java
public void print(List<Number> list) { ... }

List<Integer> ints = List.of(1, 2, 3);
print(ints);  // ❌ COMPILE ERROR!
// Dù Integer extends Number, List<Integer> KHÔNG phải List<Number>
// Vì: nếu được thì list.add(3.14) sẽ vỡ!
```

### `<? extends T>` — Upper Bound (Producer / Đọc)

```java
// Đọc từ list: bất kỳ subtype của Number đều OK
public void print(List<? extends Number> list) {
    for (Number n : list) { System.out.println(n); }  // ✅ đọc được
    list.add(1);  // ❌ COMPILE ERROR — không thêm được
}

List<Integer> ints    = List.of(1, 2, 3);
List<Double>  doubles = List.of(1.1, 2.2);
print(ints);    // ✅
print(doubles); // ✅
```

### `<? super T>` — Lower Bound (Consumer / Ghi)

```java
// Ghi vào list: list phải chứa được Integer (Integer hoặc parent của nó)
public void addNumbers(List<? super Integer> list) {
    list.add(1);   // ✅ thêm được
    list.add(2);   // ✅
    Number n = list.get(0);  // ❌ chỉ đọc ra được Object
}

List<Number> numbers = new ArrayList<>();
List<Object> objects = new ArrayList<>();
addNumbers(numbers); // ✅
addNumbers(objects); // ✅
```

### Mnemonic — PECS

```
Producer Extends → bạn ĐỌC dữ liệu RA từ list
Consumer Super   → bạn GHI dữ liệu VÀO list
```

---

## 🏭 Ứng dụng thực tế — Generic Base Classes (Spring Boot)

```java
// Generic Repository
public interface BaseRepository<T, ID> extends JpaRepository<T, ID> { }

public interface EmployeeRepository   extends BaseRepository<Employee, Long>   { }
public interface DepartmentRepository extends BaseRepository<Department, Long> { }

// Generic Service — viết 1 lần, dùng cho mọi Entity
public abstract class BaseService<T, ID, R extends JpaRepository<T, ID>> {
    protected final R repository;

    public BaseService(R repository) { this.repository = repository; }

    public Optional<T> findById(ID id) { return repository.findById(id); }
    public List<T>     findAll()       { return repository.findAll(); }
    public T           save(T entity)  { return repository.save(entity); }
}

// Dùng:
@Service
public class EmployeeService extends BaseService<Employee, Long, EmployeeRepository> {
    public EmployeeService(EmployeeRepository repo) { super(repo); }
    // findById, findAll, save → có sẵn, không cần viết lại!
}
```

---

## 📊 Tóm tắt

| | Không có Generics (`Object`) | Có Generics (`<T>`) |
|---|---|---|
| Type safety | ❌ Runtime crash | ✅ Compile-time error |
| Cast | Thủ công, nguy hiểm | Tự động, an toàn |
| Đọc code | Không biết data là kiểu gì | Rõ ràng `ApiResponse<Employee>` |
| Tái sử dụng | Viết lại cho từng kiểu | 1 class cho tất cả |

---
*Last updated: 2026-10-26*
