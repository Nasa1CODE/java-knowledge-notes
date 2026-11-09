---
description: Sinh plan.md, tasks.md, impact.md cho một feature từ expect.md
---

Feature: `$ARGUMENTS`

Thực hiện đúng theo `docs/rules/01-create-plan.md`.

Các bước bắt buộc, theo thứ tự:

1. Chạy `bash docs/scripts/check-layout.sh`. Không PASS → **dừng**, báo lỗi, không làm tiếp.
2. `git pull` trong `docs/`.
3. Đọc `docs/features/$ARGUMENTS/expect.md`. Không tồn tại → **dừng và hỏi**.
4. Đọc `docs/rules/01-create-plan.project-config.md` (mọi fact dự án mà rule cần). Không tồn tại → **DỪNG**, đề nghị sinh từ `docs/rules/01-create-plan.project-config.template.md`.
5. Đọc `docs/AGENTS.md` (Service registry + ràng buộc service), `docs/project.md`, `docs/architecture.md`, `docs/specs/` liên quan, `docs/conventions/<service>.md`, `docs/databases/README.md`.
6. Xác định **service đích** qua Service registry. Chưa rõ, hoặc một task đụng nhiều repo mà không nói rõ → **DỪNG và HỎI**, không tự chọn.
7. Đọc source vùng bị ảnh hưởng vừa đủ để xác định phạm vi và rủi ro.
8. Sinh `docs/features/$ARGUMENTS/plan.md` từ `docs/templates/plan.md`.
9. Sinh `docs/features/$ARGUMENTS/tasks.md` từ `docs/templates/tasks.md`.
10. Sinh `docs/features/$ARGUMENTS/impact.md` từ `docs/templates/impact.md` theo `docs/rules/04-create-impact.md`.
11. Chạy checklist tự review Gate 1 trong rule 01 và báo lại kết quả.

Ràng buộc:

- **Không viết code.**
- Không tự điền block "Phê duyệt (Gate 1)".
- Không đổi `status` trong `expect.md`.
- Không đưa secret/credential vào tài liệu — chỉ ghi tên khóa cấu hình.
- Kế hoạch kiểm chứng phải có **lệnh cụ thể** và kết quả kỳ vọng.
