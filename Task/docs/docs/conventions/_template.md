# Conventions — `<nhóm hoặc local-folder-name>`

> Quy ước code riêng của một service/nhóm service (kiểu "skill"). Copy file này thành `conventions/<tên>.md` và điền theo source thật.
> Quy ước **dùng chung mọi service** nằm ở [../project.md](../project.md) §4–8 — đừng chép lại ở đây.

## Nhận dạng

- **service / nhóm:** `<theo Service registry ở ../AGENTS.md>`
- **Vai trò:** `<một câu>`
- **Stack:** `<ngôn ngữ / framework / version>`

## Layer map — đặt code ở đâu

| Việc cần làm | Đặt ở |
|---|---|
| Entity | |
| DTO | |
| Business logic | |
| Truy vấn phức tạp | |
| Cấu hình | |
| Màn hình / route (nếu FE) | |

## Quy ước đặt tên

`<Tiền tố bảng, hậu tố class, quy ước file/thư mục — chỉ ghi cái khác với quy ước chung.>`

## Lệnh thường dùng

```bash
# build
# run
# test
```

## Pitfall của service này

`<Những chỗ dễ sai mà chỉ người từng làm mới biết: thư mục trùng tên, phần legacy, thứ tự khởi động, file sinh tự động, quirk cấu hình, tên repo/README lệch source.>`

## Không được đụng

`<File/thư mục sinh tự động hoặc build output.>`
