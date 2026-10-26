# Composition Over Inheritance

**Tags:** #oop #design-principle #solid #java  
**Related:** [[01-Java-Core/Strategy-Pattern|Strategy-Pattern]], [[SOLID-Principles]]  
**Status:** ✅ Done

---

## 🧠 Core Idea

> "Favor object composition over class inheritance" — Gang of Four

- **Inheritance (IS-A):** Manager IS-A Employee → cứng nhắc, dễ vỡ khi business thay đổi
- **Composition (HAS-A):** Manager HAS-A role, HAS-A paymentType → linh hoạt, dễ mở rộng

---

## ❌ Vấn đề của Inheritance

### 1. Inheritance Explosion
```
Employee
├── Manager
│   ├── ContractorManager   ← class mới
│   └── FullTimeManager     ← class mới
└── Developer
    └── SeniorDev           ← vừa manage vừa code? Java không hỗ trợ!
```

### 2. Vi phạm Liskov Substitution Principle
```java
class Employee {
    void generateReport() { /* TEXT */ }
}
class Manager extends Employee {
    @Override
    void generateReport() { /* PDF - hành vi thay đổi ngầm! */ }
}
// Employee e = new Manager() → hành vi bất ngờ
```

### 3. Tight Coupling với Parent
- Subclass phụ thuộc vào **implementation** của parent, không chỉ interface
- Parent thay đổi → tất cả subclass có thể bị ảnh hưởng

---

## ✅ Composition — Giải pháp

### Nguyên tắc: Tách behavior ra interface, inject vào object

```java
// 1. Interface cho behavior
interface ReportGenerator {
    void generateReport();
}

// 2. Implementations
class TextReport implements ReportGenerator { ... }
class PdfReport  implements ReportGenerator { ... }

// 3. Compose vào object
class Manager {
    private Employee        employeeInfo;       // HAS-A employee data
    private ReportGenerator reportGenerator;    // HAS-A report behavior (injectable)

    public void generateReport() {
        reportGenerator.generateReport();       // delegate
    }
}

// 4. Swap behavior tại runtime
Manager mgr = new Manager(employeeData, new PdfReport());  // PDF
Manager mgr = new Manager(employeeData, new TextReport()); // TEXT — không sửa class!
```

---

## 🏭 Ví dụ thực tế: NotificationService (Spring Boot)

### Vấn đề
Cần gửi thông báo qua Email / SMS / Push / Slack — và kết hợp nhiều kênh cùng lúc.

### Interface
```java
public interface NotificationChannel {
    void send(String recipient, String message);
    String getChannelName();
}
```

### Implementations
```java
@Component public class EmailChannel implements NotificationChannel { ... }
@Component public class SmsChannel   implements NotificationChannel { ... }
@Component public class PushChannel  implements NotificationChannel { ... }
// Thêm Slack? Chỉ cần thêm @Component class mới → Spring tự wire!
```

### Service (Composition)
```java
@Service
public class NotificationService {

    private final Map<String, NotificationChannel> channels;

    // Spring inject tất cả beans implement NotificationChannel
    public NotificationService(List<NotificationChannel> channelList) {
        this.channels = channelList.stream()
            .collect(Collectors.toMap(NotificationChannel::getChannelName, Function.identity()));
    }

    public void send(String channelName, String recipient, String message) {
        channels.get(channelName.toUpperCase()).send(recipient, message);
    }

    public void sendMulti(List<String> channelNames, String recipient, String message) {
        channelNames.stream()
            .map(name -> channels.get(name.toUpperCase()))
            .filter(Objects::nonNull)
            .forEach(ch -> ch.send(recipient, message));
    }
}
```

> 💡 **Open/Closed Principle**: Thêm kênh mới = thêm class mới, không sửa `NotificationService`!

---

## 🎯 Strategy Pattern — Composition có tên

**Strategy = tách algorithm ra khỏi context, cho phép swap tại runtime**

### Khi nào dùng?
| Dấu hiệu | Giải pháp |
|---|---|
| Code có nhiều `if-else` / `switch` theo type | Strategy Pattern |
| Muốn swap algorithm lúc runtime | Strategy Pattern |
| Unit test khó vì logic rối trong 1 class | Strategy Pattern |

### Ví dụ: Tính lương (PayrollService)

```java
// Strategy Interface
public interface SalaryStrategy {
    double calculate(Employee employee);
}

// Concrete Strategies
@Component("fullTimeSalary")
class FullTimeSalaryStrategy implements SalaryStrategy {
    public double calculate(Employee e) { return e.getBaseSalary(); }
}

@Component("partTimeSalary")
class PartTimeSalaryStrategy implements SalaryStrategy {
    public double calculate(Employee e) { return e.getHourlyRate() * e.getHoursWorked(); }
}

@Component("contractorSalary")
class ContractorSalaryStrategy implements SalaryStrategy {
    public double calculate(Employee e) { return e.getMilestoneValue() * e.getCompletedMilestones(); }
}

// Context
@Service
public class PayrollService {
    private final Map<String, SalaryStrategy> strategies;

    public PayrollService(Map<String, SalaryStrategy> strategies) {
        this.strategies = strategies;
    }

    public double calculateSalary(Employee employee) {
        String key = employee.getEmploymentType().toLowerCase() + "Salary";
        return strategies.get(key).calculate(employee);
    }
}
```

### ❌ Anti-pattern (if-else)
```java
// Vi phạm Open/Closed — mỗi lần thêm loại nhân viên phải sửa method này
public double calculateSalary(Employee emp) {
    if (emp.getType().equals("FULL_TIME")) { ... }
    else if (emp.getType().equals("PART_TIME")) { ... }
    else if (emp.getType().equals("CONTRACTOR")) { ... }
    // Thêm loại mới → sửa vào đây
}
```

---

## 📊 So sánh tổng hợp

| | Inheritance | Composition |
|---|---|---|
| Thêm behavior mới | Phải tạo subclass | Thêm implementation mới |
| Test | Khó (phụ thuộc parent) | Dễ (mock interface) |
| Linh hoạt | Thấp (compile time) | Cao (runtime swap) |
| Java limit | Chỉ 1 parent class | Nhiều interface |
| Vi phạm SOLID | Dễ vi phạm LSP, OCP | Tự nhiên tuân thủ |

---

## 🔑 Rule of Thumb

- Dùng `extends` khi quan hệ **IS-A thật sự** không thể thay đổi  
  → Ví dụ: `ArrayList extends AbstractList` (ArrayList luôn là một List)
- Mọi trường hợp còn lại → **Composition + Interface**

---

## 🔗 Liên kết trong project thực tế

- `NotificationService` → `E:\MMS\backend\src\main\java\com\hr\performance\`
- `PayrollService` → tương tự, áp dụng Strategy cho tính lương

---
*Last updated: 2026-10-26*
