# OOP — Lập trình Hướng đối tượng

**Tags:** #java #oop #core  
**Related:** [[01-Java-Core/Composition-Over-Inheritance|Composition-Over-Inheritance]], [[01-Java-Core/Strategy-Pattern|Strategy-Pattern]]  
**Status:** ✅ Done

---

## 🧠 Tại sao OOP ra đời?

**Vấn đề:** Code theo kiểu thủ tục (procedural) → mọi thứ là function + data rời rạc → khó mở rộng, khó bảo trì, không tái sử dụng được.

**Giải pháp:** Gom **data + behavior** vào cùng 1 đơn vị gọi là **Object** → dễ mô hình hóa thế giới thực.

---

## 4 Tính chất OOP

### 1. 🔒 Encapsulation (Đóng gói)

> Ẩn data bên trong, chỉ lộ ra những gì cần thiết qua method.

```java
public class Employee {
    private double salary;  // ← ẩn, không ai truy cập trực tiếp được

    // Chỉ cho phép đọc
    public double getSalary() { return salary; }

    // Kiểm soát logic khi set
    public void setSalary(double salary) {
        if (salary < 0) throw new IllegalArgumentException("Lương không âm!");
        this.salary = salary;
    }
}

// Bên ngoài:
emp.salary = -1000;       // ❌ COMPILE ERROR — private
emp.setSalary(-1000);     // ❌ IllegalArgumentException — có validation
emp.setSalary(5_000_000); // ✅
```

**Lợi ích:** Thay đổi internal logic mà không ảnh hưởng code bên ngoài.

---

### 2. 🧬 Inheritance (Kế thừa)

> Subclass tái sử dụng code của parent class.

```java
public class Person {
    protected String name;
    protected String email;

    public void introduce() {
        System.out.println("Tôi là " + name);
    }
}

public class Employee extends Person {
    private String department;

    // Kế thừa name, email, introduce() từ Person
    // Thêm thuộc tính và hành vi riêng
    public void work() {
        System.out.println(name + " đang làm việc ở " + department);
    }
}
```

> ⚠️ **Khi nào dùng Inheritance?**  
> Chỉ khi quan hệ là **IS-A thật sự** và không thay đổi.  
> Còn lại → dùng **Composition**.  
> Xem: [[01-Java-Core/Composition-Over-Inheritance|Composition-Over-Inheritance]]

---

### 3. 🎭 Polymorphism (Đa hình)

> Cùng 1 interface, hành vi khác nhau tùy implementation.

#### Compile-time Polymorphism — Method Overloading

```java
public class Calculator {
    public int    add(int a, int b)       { return a + b; }
    public double add(double a, double b) { return a + b; }  // cùng tên, khác tham số
    public int    add(int a, int b, int c){ return a + b + c; }
}
```

#### Runtime Polymorphism — Method Overriding

```java
public class NotificationChannel {
    public void send(String msg) {
        System.out.println("Gửi: " + msg);
    }
}

public class EmailChannel extends NotificationChannel {
    @Override
    public void send(String msg) {
        System.out.println("[EMAIL] " + msg);  // hành vi khác
    }
}

public class SmsChannel extends NotificationChannel {
    @Override
    public void send(String msg) {
        System.out.println("[SMS] " + msg);  // hành vi khác
    }
}

// Sức mạnh của Polymorphism:
List<NotificationChannel> channels = List.of(new EmailChannel(), new SmsChannel());
for (NotificationChannel ch : channels) {
    ch.send("Lương tháng đã được xử lý");  // mỗi object tự biết gửi kiểu gì
}
// Output:
// [EMAIL] Lương tháng đã được xử lý
// [SMS] Lương tháng đã được xử lý
```

---

### 4. 🫙 Abstraction (Trừu tượng hóa)

> Ẩn chi tiết cài đặt, chỉ lộ ra "làm được gì" — không cần biết "làm thế nào".

```java
// Abstract class — có thể có method thường lẫn abstract
public abstract class ReportGenerator {
    // Abstract: subclass BẮT BUỘC phải implement
    public abstract void generate(List<Employee> employees);

    // Concrete: dùng chung
    public void printHeader() {
        System.out.println("=== HR Performance Report ===");
    }
}

// Interface — pure abstraction
public interface Exportable {
    void exportTo(String path);  // chỉ khai báo, không implement
}

// Implementation
public class PdfReportGenerator extends ReportGenerator implements Exportable {
    @Override
    public void generate(List<Employee> employees) {
        printHeader();  // dùng method của parent
        // ... generate PDF logic
    }

    @Override
    public void exportTo(String path) {
        // ... save PDF to path
    }
}
```

**Abstract class vs Interface:**

| | Abstract Class | Interface |
|---|---|---|
| Kế thừa | `extends` (chỉ 1) | `implements` (nhiều) |
| Constructor | Có | Không |
| Field | Có (mọi loại) | Chỉ `public static final` |
| Method | Abstract + Concrete | Abstract + `default` + `static` |
| Dùng khi | Chia sẻ code chung giữa related classes | Định nghĩa contract cho unrelated classes |

---

## 🔗 Liên kết với SOLID

| OOP Tính chất | SOLID Nguyên tắc                                   |
| ------------- | -------------------------------------------------- |
| Encapsulation | Single Responsibility (mỗi class 1 việc)           |
| Inheritance   | Open/Closed (mở rộng không sửa đổi)                |
| Polymorphism  | Liskov Substitution (subtype thay thế được parent) |
| Abstraction   | Interface Segregation, Dependency Inversion        |

---

## ❓ Câu hỏi phỏng vấn thường gặp

**Q: Khác nhau giữa Abstract class và Interface?**  
→ Abstract class dùng khi muốn chia sẻ code (có state, constructor). Interface dùng để định nghĩa contract (capability). Java 8+ interface có `default` method nhưng không có constructor/state.

**Q: Overloading vs Overriding?**  
→ Overloading: cùng tên method, khác tham số, giải quyết lúc **compile time**. Overriding: subclass cài đè method của parent, giải quyết lúc **runtime** (dynamic dispatch).

**Q: Tại sao không nên lạm dụng Inheritance?**  
→ Dẫn đến Inheritance Explosion, vi phạm LSP, tight coupling với parent. Dùng Composition thay thế.  
→ Xem chi tiết: [[01-Java-Core/Composition-Over-Inheritance|Composition-Over-Inheritance]]

---
*Last updated: 2026-10-26*
