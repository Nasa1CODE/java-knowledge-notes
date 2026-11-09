# Plan — <TICKET-ID>: <Tiêu đề ngắn>

> DEV sở hữu. Sinh cùng AI theo [rules/01-create-plan.md](../rules/01-create-plan.md). **DEV bắt buộc tự review trước khi trình Gate 1.**
> Status vòng đời feature nằm ở `expect.md`. Ở đây chỉ là trạng thái của bản plan.

plan-status: draft   # draft → plan-review → approved  (CHỈ cho bản plan)

service: <service-key theo Service registry>
service-repo: <repo path — AI CHỈ thao tác trong đây>

## Câu hỏi chặn (blocking)

> Phải trả lời xong mới được approve. Rỗng nếu không có.

- [ ] B1: <câu hỏi> → **Chốt:** <câu trả lời> (<ngày>)

## Mục tiêu

<Truy vết ngược về expect.md: AC nào được giải quyết.>

## Bối cảnh

<Trích từ architecture.md / specs/ / conventions/ — chỉ phần liên quan.>

## Nguyên nhân gốc (nếu là bug)

<Đối chiếu code thật: file, hàm, dòng. Không suy đoán.>

## Giả định · Câu hỏi mở · Ngoài phạm vi

- **Giả định:**
- **Câu hỏi mở:**
- **Ngoài phạm vi:**

## Cách làm

<Chia bước nhỏ; sau mỗi bước hệ thống vẫn chạy được.>

## Thay đổi kỹ thuật

| Hạng mục | Có/Không | Chi tiết |
|---|---|---|
| Entity / migration | | |
| DTO / AppService | | |
| Màn hình / route | | |
| Hàng đợi / tích hợp | | |
| Cấu hình (tên khóa) | | |

## Thứ tự thực hiện & phụ thuộc

<Cái gì phải làm trước, vì sao.>

## Kế hoạch kiểm chứng

> Phải có **lệnh cụ thể** và kết quả kỳ vọng. Không viết "chạy test".

| # | Lệnh / bước kiểm | Kết quả kỳ vọng |
|---|---|---|
| 1 | | |

Case không test được ở local (xem `project.md` §7) → đánh dấu `manual` và ghi người nghiệm thu.

## Ma trận rủi ro

| Rủi ro | Ảnh hưởng | Giảm thiểu | Rollback |
|---|---|---|---|
| | | | |

## Ghi chú triển khai

<Chạm DB / cấu hình / môi trường / hàng đợi thì ghi ở đây và tạo `deploy.md`. Không thì ghi "không cần".>

## Đề xuất cập nhật docs (Gate 2)

- `specs/<domain>.md`: <sửa gì>
- `architecture.md` / `databases/README.md`: <sửa gì>

## Phê duyệt (Gate 1) — chỉ người điền, AI không tự điền

- [ ] DEV tự review: <tên> — <ngày>
- [ ] TechLead approve: <tên> — <ngày> — <link commit/PR>

> Khi block này đủ chữ ký, cập nhật `expect.md` → `status: approved` rồi mới chạy rule 02.
