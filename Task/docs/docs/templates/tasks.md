# Tasks — <TICKET-ID>

> Sinh theo [rules/01-create-plan.md](../rules/01-create-plan.md). Cập nhật status và link commit/PR trong lúc làm.
> **Service** phải là `service-key` đúng theo Service registry ([../AGENTS.md](../AGENTS.md)).

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | | | pending | S | |
| 2 | | | pending | | |

---

## Task 1 — <Tiêu đề ngắn, một việc duy nhất>

- **Status:** pending   <!-- pending · in-progress · completed · blocked · cancelled -->
- **Service:** `<service-key>`
- **Mô tả:** <kết quả cụ thể task này đạt được>
- **Tiêu chí chấp nhận:**
  - [ ] <điều kiện kiểm được khách quan, truy về AC trong expect.md>
- **Kiểm chứng:**
  - [ ] `<lệnh cụ thể>` → kỳ vọng: <kết quả>
- **Phụ thuộc:** Không
- **File dự kiến chạm:**
  - `<đường dẫn tương đối trong repo>`
- **Ước lượng:** S   <!-- XS: 1 file · S: 1–2 · M: 3–5 · L: 6–8 -->
- **Commit/PR:** <điền khi xong>

---

## Task 2 — <...>

<lặp cấu trúc trên>

---

> **Tách task** nếu: chạm hơn 8 file · đụng nhiều hệ thống con độc lập · tiêu chí chấp nhận mơ hồ · tiêu đề nối hai việc bằng chữ "và".
> Task `cancelled` phải ghi lý do.
