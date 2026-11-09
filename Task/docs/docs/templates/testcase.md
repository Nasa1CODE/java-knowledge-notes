# Testcase — <TICKET-ID>

> Sinh từ `expect.md` theo [rules/03-create-testcase.md](../rules/03-create-testcase.md) — **KHÔNG sinh từ `plan.md`**.
> Không dùng dữ liệu thật của khách hàng.

## Truy vết AC → case

| AC | Case |
|---|---|
| AC1 | TC-01, TC-02 |
| AC2 | TC-03 |

---

## TC-01 — <Tiêu đề>

- **AC liên quan:** AC1
- **Loại:** luồng chính   <!-- luồng chính · biên · lỗi · hồi quy · phân quyền -->
- **auto/manual:** auto
- **Điều kiện tiền đề:** <trạng thái dữ liệu / tài khoản cần có>
- **Các bước:**
  1. 
  2. 
- **Kết quả mong đợi:** <quan sát được, cụ thể>

## TC-02 — <Tiêu đề>

- **AC liên quan:** AC1
- **Loại:** biên
- **auto/manual:** manual — <lý do: phụ thuộc tích hợp không chạy local, xem `project.md` §7> — **người nghiệm thu:** <tên>
- **Điều kiện tiền đề:**
- **Các bước:**
- **Kết quả mong đợi:**

---

## Case bắt buộc có

- [ ] Luồng chính cho mọi AC
- [ ] Case biên trên field đặc thù (`project.md` §9)
- [ ] Case lỗi / dữ liệu sai / thiếu quyền
- [ ] Case hồi quy cho vùng "xác nhận không bị ảnh hưởng" trong `impact.md`
- [ ] Case phân quyền: người dùng doanh nghiệp khác **không** thấy dữ liệu
