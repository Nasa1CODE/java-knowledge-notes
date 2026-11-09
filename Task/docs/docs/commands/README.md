# Slash commands (Claude Code)

5 lệnh ánh xạ 5 rule để chạy nhanh. Đăng ký bằng cách copy các file `.md` trong thư mục này vào `.claude/commands/` của folder cha (`D:\BILL`), rồi gọi:

| Lệnh | Chạy rule |
|---|---|
| `/init-docs` | [rules/00-init-docs.md](../rules/00-init-docs.md) |
| `/create-plan <TICKET-ID>` | [rules/01-create-plan.md](../rules/01-create-plan.md) |
| `/implement-task <TICKET-ID>` | [rules/02-implement-task.md](../rules/02-implement-task.md) |
| `/create-testcase <TICKET-ID>` | [rules/03-create-testcase.md](../rules/03-create-testcase.md) |
| `/create-impact <TICKET-ID>` | [rules/04-create-impact.md](../rules/04-create-impact.md) |

**Mọi lệnh đều bắt đầu bằng:** `bash docs/scripts/check-layout.sh` (phải PASS) → `git pull` trong `docs/`.

**AI thiếu context → HỎI.** Không tự quyết, không tự approve, không tự đổi status feature.
