# Deploy — <TICKET-ID>

> **Chỉ tạo file này khi có thay đổi DB / cấu hình / môi trường / hàng đợi.** Không có thì bỏ qua.
> **Không ghi giá trị secret** — chỉ ghi tên khóa và người/nơi giữ giá trị.

## 1. Loại thay đổi

- [ ] Migration DB
- [ ] Thêm/đổi khóa cấu hình
- [ ] Thay đổi hàng đợi / topic
- [ ] Thay đổi môi trường / hạ tầng
- [ ] Khác: <ghi rõ>

## 2. Thứ tự triển khai

> Ghi rõ cái gì chạy trước, service nào deploy trước để hệ thống không gãy giữa chừng.

1. 
2. 

## 3. Migration DB

| Migration | Service | Bảng ảnh hưởng | Thời gian ước tính |
|---|---|---|---|
| | | | |

- [ ] Đã **backup DB** trước khi chạy (bắt buộc với staging/production)
- [ ] Đã review SQL sinh ra

## 4. Khóa cấu hình cần thêm/đổi

| Khóa | Service | Bắt buộc? | Ai cấp giá trị |
|---|---|---|---|
| | | | |

> Chỉ tên khóa. Giá trị trao đổi qua kênh bảo mật, không đưa vào tài liệu hay commit.

## 5. Hàng đợi / topic

| Queue / Topic | Thay đổi | Bên gửi | Bên nhận |
|---|---|---|---|
| | | | |

> Đổi hợp đồng message phải deploy đồng bộ hai phía, nếu không message cũ sẽ kẹt.

## 6. Kiểm tra sau khi deploy

| # | Kiểm gì | Kết quả kỳ vọng |
|---|---|---|
| 1 | | |

## 7. Rollback

<Các bước quay lui. Nếu có migration không thể rollback tự động → nói rõ và mô tả cách khôi phục từ backup.>

## 8. Ảnh hưởng người dùng

<Có downtime không? Có cần báo trước cho khách hàng không?>
