---
description: Thực hiện task đã duyệt và sinh report.md, deploy.md
---

Feature: `$ARGUMENTS`

Thực hiện đúng theo `docs/rules/02-implement-task.md`.

Kiểm điều kiện tiên quyết trước, thiếu bất kỳ mục nào → **DỪNG và HỎI**:

1. `bash docs/scripts/check-layout.sh` PASS; đã `git pull` trong `docs/`.
2. `docs/features/$ARGUMENTS/expect.md` đang ở `status: approved`.
3. `docs/features/$ARGUMENTS/plan.md` có đủ chữ ký Gate 1 (DEV review + TechLead approve).
4. Task cần làm ghi rõ **service-key**; tra ra repo path qua `docs/AGENTS.md`.

Sau đó:

5. Đọc `docs/rules/02-implement-task.project-config.md` (approval-evidence, implement-order, forbidden-changes, report-evidence, commit-rule…). Không tồn tại → **DỪNG**, đề nghị sinh từ `docs/rules/02-implement-task.project-config.template.md`.
6. Đọc `docs/conventions/<service>.md` của service đích trước khi viết code.
7. **Chỉ thao tác trong đúng repo path** của service đó.
8. Làm từng task một; đổi status `in-progress` → `completed` trong `tasks.md`, ghi link commit/PR.
9. Chạy đúng bước kiểm chứng đã khai trong task, **giữ lại output thật**.
10. Cập nhật `impact.md` nếu phát hiện ảnh hưởng ngoài dự kiến.
11. Sinh `report.md` từ `docs/templates/report.md` — **chỉ ghi kết quả thật**.
12. Sinh `deploy.md` từ `docs/templates/deploy.md` **nếu** chạm DB / cấu hình / môi trường / hàng đợi.
13. Đề xuất diff cho docs gốc (Gate 2), không tự merge.

Cấm tuyệt đối:

- Bịa kết quả test hoặc output lệnh. Không chạy được thì ghi rõ cái gì không chạy và vì sao.
- Làm ngoài phạm vi `expect.md` / `plan.md` / `tasks.md` đã duyệt.
- Tự đổi `status` sang `done`.
- Log hoặc chép secret, token, credential.
