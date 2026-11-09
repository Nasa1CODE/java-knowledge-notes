# Project Documentation Kit

Khung tài liệu theo hướng spec-driven cho một dự án phần mềm. Repo này không chứa source code nghiệp vụ; nó giúp BA, DEV, QA, TechLead và AI cùng làm việc theo một nguồn tài liệu kiểm chứng được.

## Bắt đầu dự án mới

1. Sao chép toàn bộ thư mục này thành repo `docs` của dự án.
2. Điền `AGENTS.md`, `project.md`, hai file `rules/*.project-config.md` từ các file `.template.md` tương ứng.
3. Khai báo convention theo từng service/nhóm service trong `conventions/`.
4. Khảo sát source thật bằng Rule 00 và tạo `architecture.md`, `specs/`, `databases/`, `design.md`.
5. Mỗi ticket dùng một thư mục `features/<TICKET-ID>/`.

## Phân lớp

| Lớp | Thư mục/tệp | Xử lý khi dùng cho dự án khác |
|---|---|---|
| ENGINE | `rules/`, `templates/`, `commands/`, `scripts/` | Giữ nguyên, chỉ sửa nếu quy trình chung thay đổi. |
| PROFILE | `AGENTS.md`, `project.md`, `conventions/`, `*.project-config.md` | Điền lại theo source và cách làm việc của dự án. |
| CONTENT | `architecture.md`, `specs/`, `databases/`, `design.md`, `features/` | Sinh từ source thật, không sao chép từ dự án cũ. |

## Vòng đời feature

`expect → plan/tasks/impact/testcase → Gate 1 → implementation → report/deploy → Gate 2`

- `expect.md` giữ trạng thái feature.
- Chỉ TechLead phê duyệt Gate 1 (cho phép code) và Gate 2 (cập nhật tài liệu nền).
- Báo cáo chỉ được ghi kết quả kiểm chứng thật.
