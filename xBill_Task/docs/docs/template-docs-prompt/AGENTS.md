# Agent Guide — <PROJECT_NAME>

## Metadata

```yaml
project: <PROJECT_NAME>
owner: TBD — owner: <ROLE>
docs_repo: <REPOSITORY_URL>
ticket_prefix: <TICKET_PREFIX>
docs_branch: <DOCS_BRANCH>
language_for_ai_replies: Vietnamese
```

## Session start

Trước khi plan, code, test hoặc review:

1. Chạy `scripts/check-layout.sh`, sau đó `git pull` nếu remote khả dụng.
2. Đọc file này, `README.md`, `project.md`, `architecture.md`, và spec liên quan.
3. Đọc rule phù hợp cùng `*.project-config.md` của rule đó.
4. Với feature cụ thể, đọc `features/<TICKET-ID>/`.

## Service registry

| service-key | Repo path | Role | Stack | Datastore |
|---|---|---|---|---|
| `<service-key>` | `../<repo-folder>` | `<role>` | `<stack>` | `<datastore>` |

Không suy đoán service từ tên thư mục. Service phải được khai trong plan, tasks hoặc yêu cầu người dùng.

## Feature workflow

Mỗi feature ở `features/<TICKET-ID>/`: `expect.md`, `plan.md`, `tasks.md`, `impact.md`, `testcase.md`, `report.md`; chỉ tạo `deploy.md` nếu chạm DB, config, queue hoặc hạ tầng.

Trạng thái feature hợp lệ: `draft`, `plan-review`, `approved`, `in-progress`, `testing`, `done`, `cancelled`.

Không code trước Gate 1. Không tự phê duyệt Gate 1/Gate 2. Không đưa secret, token, dữ liệu khách hàng vào docs hoặc log.

## Git

- Kiểm tra branch và working tree trước khi thay đổi.
- Không commit, push, merge hay deploy nếu chưa được yêu cầu rõ.
- Quy ước branch/commit/PR được khai trong `project.md`.
