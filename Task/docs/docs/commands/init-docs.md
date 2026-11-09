---
description: Khởi tạo / refresh tài liệu nền từ source (architecture, specs, database, design)
---

Thực hiện đúng theo `docs/rules/00-init-docs.md`.

1. `bash docs/scripts/check-layout.sh` PASS → `git pull` trong `docs/`.
2. Đọc `docs/AGENTS.md` (Service registry), `docs/project.md`, `docs/conventions/<service>.md`.
3. Quét source **từng service theo repo path trong registry** — không suy đoán service từ tên thư mục.
4. Sinh/cập nhật, ở dạng **diff đề xuất**:
   - `docs/architecture.md`
   - `docs/specs/<domain>.md` (1 domain = 1 file) + cập nhật `docs/specs/README.md`
   - `docs/databases/README.md`
   - `docs/design.md`

Nguyên tắc bắt buộc:

- **Không bịa.** Chỉ ghi cái đọc được từ code/config.
- Mọi luồng phải trỏ tới class/method/entity **CÓ THẬT**, và ghi rõ thuộc service-key nào.
- Chỗ chưa chắc → mục **"Câu hỏi mở"** cuối file, không đoán.
- Cấu hình chỉ ghi **tên khóa**, không ghi giá trị (file cấu hình trong repo có credential thật).
- **Đề xuất, không tự merge** — mọi thay đổi docs nền phải qua Gate 2.

Nếu phát hiện tài liệu hiện tại lệch với code, báo rõ chỗ lệch thay vì âm thầm ghi đè.
