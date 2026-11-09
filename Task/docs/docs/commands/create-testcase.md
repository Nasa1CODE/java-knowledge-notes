---
description: Sinh testcase.md từ expect.md
---

Feature: `$ARGUMENTS`

Thực hiện đúng theo `docs/rules/03-create-testcase.md`.

1. `bash docs/scripts/check-layout.sh` PASS → `git pull` trong `docs/`.
2. Đọc `docs/features/$ARGUMENTS/expect.md` — **đây là nguồn sinh testcase**.
3. Đọc `docs/specs/` domain liên quan (ràng buộc nghiệp vụ, rule bảo mật), `docs/project.md` §7 (tích hợp test được ở local) và §9 (field đặc thù).
4. Tham chiếu `plan.md` và `impact.md` **chỉ để** biết vùng ảnh hưởng và vùng cần hồi quy.
5. Sinh `docs/features/$ARGUMENTS/testcase.md` từ `docs/templates/testcase.md`.

Yêu cầu bắt buộc:

- **Sinh từ `expect.md`, KHÔNG từ `plan.md`.**
- Mỗi Acceptance Criteria có ít nhất một case; có bảng truy vết AC → case.
- Có đủ: luồng chính · biên · lỗi/phủ định · hồi quy · phân quyền & cách ly dữ liệu giữa doanh nghiệp.
- Case phụ thuộc tích hợp không chạy được ở local → đánh `manual` + ghi người nghiệm thu.
- Kết quả mong đợi phải quan sát được; không viết "hoạt động đúng".
- Không dùng dữ liệu thật của khách hàng.
