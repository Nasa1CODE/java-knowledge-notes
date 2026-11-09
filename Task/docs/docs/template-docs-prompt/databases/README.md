# Database Documentation

> CONTENT. Ghi schema quan sát được từ source/database review; không ghi credential hoặc dump dữ liệu thật.

## Quy ước

- Mỗi bảng/view quan trọng có một file mô tả hoặc SQL schema đã được review.
- Mọi thay đổi schema phải ghi rollout và rollback trong `features/<TICKET-ID>/deploy.md`.
- Chính sách migration cụ thể nằm ở `project.md`.
