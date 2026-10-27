# Locks & Synchronized

**Tags:** #java #concurrency #thread-safety #lock  
**Related:** [[03-Concurrency/Virtual-Threads|Virtual-Threads]], [[03-Concurrency/CompletableFuture|CompletableFuture]]  
**Status:** ✅ Done

---

## 🧠 Vấn đề — Race Condition trong thực tế

```java
public class BankAccount {
    private double balance = 10_000_000;

    public void withdraw(double amount) {
        if (balance >= amount) {       // ← Thread A và B cùng thấy 10tr → cùng pass!
            Thread.sleep(10);
            balance -= amount;         // ← Cả 2 cùng trừ → balance âm!
        }
    }
}
```

### Timeline lỗi:

```
Balance = 10,000,000

Thread A: if (10tr >= 8tr) → TRUE ✅
Thread B: if (10tr >= 8tr) → TRUE ✅  (A chưa trừ, B vẫn thấy 10tr!)

Thread A: balance -= 8tr → balance = 2,000,000
Thread B: balance -= 8tr → balance = -6,000,000 💥
```

> **Vấn đề:** Khoảng thời gian giữa `if check` và `balance -= amount` bị thread khác chen vào.

---

## ✅ Giải pháp 1: `synchronized` method

```java
public class BankAccount {
    private double balance = 10_000_000;

    public synchronized void withdraw(double amount) {
        // Chỉ 1 thread vào được tại 1 thời điểm
        if (balance >= amount) {
            Thread.sleep(10);
            balance -= amount;
            System.out.println("Rút: " + amount + " | Còn lại: " + balance);
        } else {
            System.out.println("Không đủ tiền!");
        }
    }
}
```

### Timeline sau khi fix:

```
Thread A vào → khóa object 🔒
Thread B đến → chờ bên ngoài ⏳

Thread A: if(10tr >= 8tr)✅ → trừ → balance = 2tr → mở khóa 🔓
Thread B: if(2tr >= 8tr) ❌ → "Không đủ tiền!" ✅
```

---

## ✅ Giải pháp 2: `synchronized` block — khóa hẹp hơn

```java
public void withdraw(double amount) {
    // Phần không cần lock — chạy song song được
    logRequest(amount);

    synchronized (this) {           // ← chỉ lock phần quan trọng
        if (balance >= amount) {
            Thread.sleep(10);
            balance -= amount;
        } else {
            System.out.println("Không đủ tiền!");
        }
    }

    // Phần không cần lock — chạy song song được
    sendNotification();
}
```

> 💡 **Nguyên tắc:** Lock càng hẹp càng tốt → các thread khác không chờ vô ích.

---

## ✅ Giải pháp 3: `ReentrantLock` — linh hoạt nhất

```java
public class BankAccount {
    private double balance = 10_000_000;
    private final ReentrantLock lock = new ReentrantLock();

    public void withdraw(double amount) {
        lock.lock();
        try {
            if (balance >= amount) {
                Thread.sleep(10);
                balance -= amount;
                System.out.println("Rút: " + amount + " | Còn lại: " + balance);
            } else {
                System.out.println("Không đủ tiền!");
            }
        } finally {
            lock.unlock();  // LUÔN unlock dù có exception!
        }
    }
}
```

### Tính năng bổ sung của ReentrantLock:

```java
// 1. Timeout — không chờ mãi
if (lock.tryLock(500, TimeUnit.MILLISECONDS)) {
    try { ... }
    finally { lock.unlock(); }
} else {
    System.out.println("Timeout, thử lại sau!");  // synchronized không làm được
}

// 2. Có thể ngắt thread đang chờ
lock.lockInterruptibly();

// 3. ReadWriteLock — nhiều thread đọc cùng lúc, chỉ 1 thread ghi
ReadWriteLock rwLock = new ReentrantReadWriteLock();

// Nhiều thread đọc đồng thời ✅
rwLock.readLock().lock();
try { return balance; }
finally { rwLock.readLock().unlock(); }

// Chỉ 1 thread ghi, block tất cả ✅
rwLock.writeLock().lock();
try { balance -= amount; }
finally { rwLock.writeLock().unlock(); }
```

---

## ☠️ Deadlock — Bẫy nguy hiểm

```java
Object lock1 = new Object();
Object lock2 = new Object();

// Thread A: giữ lock1, chờ lock2
Thread A: synchronized(lock1) { synchronized(lock2) { ... } }

// Thread B: giữ lock2, chờ lock1
Thread B: synchronized(lock2) { synchronized(lock1) { ... } }

// → Cả 2 chờ nhau mãi mãi! 💀 DEADLOCK
```

### Cách phòng tránh:

```java
// ✅ Luôn lock theo cùng 1 thứ tự!
Thread A: synchronized(lock1) { synchronized(lock2) { ... } }
Thread B: synchronized(lock1) { synchronized(lock2) { ... } }  // ← cùng thứ tự
```

---

## 📊 So sánh các cách lock

| | `synchronized` | `ReentrantLock` | `AtomicInteger` |
|---|---|---|---|
| Cú pháp | Đơn giản | Phức tạp hơn | Đơn giản |
| Timeout khi lock | ❌ | ✅ `tryLock()` | ❌ |
| Ngắt thread chờ | ❌ | ✅ `lockInterruptibly()` | ❌ |
| Read/Write lock | ❌ | ✅ `ReadWriteLock` | ❌ |
| Dùng khi | Lock đơn giản | Cần kiểm soát cao | Counter/flag đơn giản |

---

## 🔑 Quy tắc thực tế

```
1. Ưu tiên Stateless → không cần lock gì cả
2. Counter/flag đơn giản → AtomicInteger, AtomicBoolean
3. Lock đơn giản → synchronized
4. Cần timeout / interruptible / read-write → ReentrantLock
5. Luôn lock theo 1 thứ tự cố định → tránh Deadlock
6. LUÔN unlock trong finally block với ReentrantLock
7. Lock càng hẹp càng tốt → synchronized block > synchronized method
```

---
*Last updated: 2026-10-27*
