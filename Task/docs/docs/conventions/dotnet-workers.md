# Conventions — .NET worker service (BillCloud)

> Quy ước chung mọi service ở [../project.md](../project.md) §4–8. File này ghi phần riêng của **các .NET worker** trên Cloud.
> Áp dụng cho: `export-zip-pdf-service/`, `importbillhostservice/`, `exportbillhostservice/`, `svinvoicesendemail/`, `invoice-sendmail-service/`. Tra repo path ở [../AGENTS.md](../AGENTS.md).

## Nhận dạng

- **Vai trò:** worker bất đồng bộ — export ZIP/PDF, gửi mail hóa đơn, import/export/print/XML, ZIP/PDF bảng kê.
- **Stack:** .NET worker/console; RabbitMQ (MassTransit `EventBus.Messages` hoặc RabbitMQ trực tiếp); FTP; tenant DB.

## ⚠ Tên repo/README lệch source

- `svinvoicesendemail/`: tên nói "email sending" nhưng source thật là **import/export/print/XML** — import/export đã tách sang `importbillhostservice/`, `exportbillhostservice/` (2026-10-09); còn lại mail legacy, PrintBill, tải XML.

→ **Tin source code**, không tin tên repo/README. Chi tiết: [../architecture.md](../architecture.md) §3.1.

## Quy ước kiến trúc

- **Resolve tenant connection string từ master/default DB trước** khi truy cập dữ liệu tenant.
- **Giữ tương thích hợp đồng message:** đổi queue name / DTO phải đổi cả producer lẫn consumer cùng lúc. MassTransit: hợp đồng dưới `EventBus.Messages`. RabbitMQ trực tiếp: giữ queue name + DTO.
- **Ghi status/output path** sau xử lý (phục vụ download/mail/lookup/retry).
- **Idempotent** khi có retry; xử lý lỗi tạm thời (queue/DB/FTP/HSM/API ngoài) mà không mất message.
- File sinh (PDF/XML/ZIP/Excel) lưu FTP/file storage; DB chỉ giữ path.

## Kiểm chứng

```bash
dotnet build <csproj/sln>
# chạy thật cần RabbitMQ/tenant DB/FTP → phần lớn testcase là manual
```

## Pitfall

- Không giả định 1 DB cho mọi tenant — luôn resolve tenant DB.
- Không log secret / base64 nội dung file / XML nhạy cảm.
- Đổi contract message mà quên phía còn lại → message dồn hàng đợi hoặc rơi âm thầm.

## Không được đụng

`bin/`, `obj/`, artifact build, file cấu hình chứa secret.
