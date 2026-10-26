# Strategy Pattern

**Tags:** #design-pattern #oop #composition #behavioral  
**Related:** [[01-Java-Core/Composition-Over-Inheritance|Composition-Over-Inheritance]], [[SOLID-Principles]]  
**Status:** ✅ Done

---

## 🧠 Định nghĩa

> **Strategy Pattern** = tách một *algorithm/behavior* ra khỏi class sử dụng nó,  
> đóng gói thành interface, và cho phép **swap tại runtime**.

Đây là ứng dụng thực tế nhất của **Composition over Inheritance**.

---

## 🏗 Cấu trúc

```
┌──────────────────┐        ┌─────────────────────┐
│    Context       │───────▶│  <<interface>>       │
│  (PayrollService)│        │  Strategy            │
│                  │        │  + execute()         │
│  - strategy      │        └─────────────────────┘
│  + doWork()      │                  ▲
└──────────────────┘         ┌────────┴────────┐
                             │                 │
                    ┌────────────────┐  ┌──────────────────┐
                    │ ConcreteStrat1 │  │ ConcreteStrat2   │
                    │ + execute()    │  │ + execute()      │
                    └────────────────┘  └──────────────────┘
```

---

## 💡 Ví dụ: SalaryStrategy

```java
// Strategy Interface
public interface SalaryStrategy {
    double calculate(Employee employee);
}

// Strategies
@Component("fullTimeSalary")
public class FullTimeSalaryStrategy implements SalaryStrategy {
    public double calculate(Employee e) {
        return e.getBaseSalary();
    }
}

@Component("partTimeSalary")
public class PartTimeSalaryStrategy implements SalaryStrategy {
    public double calculate(Employee e) {
        return e.getHourlyRate() * e.getHoursWorked();
    }
}

@Component("contractorSalary")
public class ContractorSalaryStrategy implements SalaryStrategy {
    public double calculate(Employee e) {
        return e.getMilestoneValue() * e.getCompletedMilestones();
    }
}

// Context — dùng Map để lookup strategy
@Service
public class PayrollService {
    private final Map<String, SalaryStrategy> strategies;

    public PayrollService(Map<String, SalaryStrategy> strategies) {
        this.strategies = strategies;
    }

    public double calculateSalary(Employee employee) {
        String key = employee.getEmploymentType().toLowerCase() + "Salary";
        SalaryStrategy strategy = strategies.get(key);
        if (strategy == null) throw new IllegalStateException("No strategy for: " + key);
        return strategy.calculate(employee);
    }
}
```

---

## 🆚 Strategy vs if-else

```java
// ❌ Không dùng Strategy — vi phạm OCP
public double calculate(Employee e) {
    switch (e.getType()) {
        case "FULL_TIME":   return e.getBaseSalary();
        case "PART_TIME":   return e.getHourlyRate() * e.getHoursWorked();
        case "CONTRACTOR":  return e.getMilestoneValue() * e.getCompletedMilestones();
        // Thêm loại → sửa method này!
    }
}

// ✅ Dùng Strategy — thêm loại = thêm class mới, không sửa gì cũ
```

---

## 🔗 Strategy trong Spring Boot

Spring Boot cực kỳ thân thiện với Strategy Pattern:

```java
// Spring tự inject tất cả bean implement interface vào Map
@Service
public class MyService {
    private final Map<String, MyStrategy> strategies;

    // Spring inject: key = bean name (@Component("key")), value = bean
    public MyService(Map<String, MyStrategy> strategies) {
        this.strategies = strategies;
    }
}
```

Chỉ cần thêm `@Component("newKey")` cho class mới → tự động available!

---

## 📦 Các ứng dụng thực tế

| Use Case | Strategy |
|---|---|
| Tính lương nhiều loại nhân viên | `SalaryStrategy` |
| Gửi thông báo nhiều kênh | `NotificationChannel` |
| Export report nhiều format | `ReportExporter` |
| Thanh toán nhiều phương thức | `PaymentStrategy` |
| Sorting/filtering động | `SortStrategy` |
| Authentication nhiều provider | `AuthStrategy` |

---
*Last updated: 2026-10-26*
