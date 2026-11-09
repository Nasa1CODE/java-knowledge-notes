---
description: Sinh hoặc finalize impact.md (đánh giá blast-radius) cho một feature
---

Feature: `$ARGUMENTS`

Thực hiện đúng theo `docs/rules/04-create-impact.md`.

1. `bash docs/scripts/check-layout.sh` PASS → `git pull` trong `docs/`.
2. Đọc `docs/features/$ARGUMENTS/expect.md` (phạm vi + ngoài phạm vi) và `plan.md` nếu có.
3. Đọc `docs/architecture.md`, `docs/specs/` liên quan, `docs/databases/README.md`.
4. Nếu đã bắt đầu code: đọc **source thật bị chạm** để xác nhận bán kính ảnh hưởng — không đoán.
5. Sinh/cập nhật `docs/features/$ARGUMENTS/impact.md` từ `docs/templates/impact.md`.

Yêu cầu bắt buộc:

- Mức ảnh hưởng (`Thấp`/`Trung bình`/`Cao`) phải giải thích được bằng **file thật bị chạm**.
- Mục **"Xác nhận KHÔNG bị ảnh hưởng"** phải liệt kê cụ thể từng vùng kèm lý do. "Mọi thứ còn lại không ảnh hưởng" là **không chấp nhận được**.
- Nói thẳng nếu **không** có thay đổi DB/schema/migration.
- Chạm luồng công khai, phân quyền, đa tenant, hoặc dữ liệu thuế → **bắt buộc** có dòng rủi ro lộ dữ liệu.
- Ghi rõ phần **chưa được kiểm chứng**.
- Cấu hình chỉ ghi tên khóa, không ghi giá trị.
- Giữ nhất quán với `plan.md` và `report.md`; mâu thuẫn thì sửa cho khớp, không để nguyên cả ba.
