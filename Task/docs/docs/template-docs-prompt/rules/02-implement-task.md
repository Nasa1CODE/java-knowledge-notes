# Rule 02 — Implement approved task

Điều kiện: feature `approved`, plan có Gate 1, task có service-key, và đã đọc `02-implement-task.project-config.md`.

1. Chỉ sửa repo service trong scope đã duyệt.
2. Làm từng task, cập nhật trạng thái task bằng kết quả thật.
3. Chạy kiểm chứng khai trong task; ghi output thật vào `report.md`.
4. Tạo `deploy.md` nếu chạm DB/config/queue/hạ tầng.
5. Đề xuất docs nền cho Gate 2; không tự merge/deploy/commit nếu chưa được yêu cầu.
