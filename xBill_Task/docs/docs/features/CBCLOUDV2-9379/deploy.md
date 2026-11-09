# Deploy - CBCLOUDV2-9379

status: dependency-only

## Dependency

Không có SQL riêng. Trước deploy `api-cloud-service`, DBA phải hoàn tất migration trong `features/CBCLOUDV2-9260/deploy.md` và xác nhận:

- `sgcnatkthuat`: 255.
- `sspktclxxuong`: 255.
- `tltsdky`: 255.
- `ttmai`: 400.
- `tnhieu`: 255.

## Thứ tự deploy

1. Apply/verify tenant DB theo CBCLOUDV2-9260.
2. Deploy `api-cloud-service` chứa CBCLOUDV2-9379.
3. Smoke `GuiHoaDonGoc` với subtype 1 và boundary hợp lệ.
4. Đọc lại DB/XML; sau đó regression thay thế/điều chỉnh.

## Rollback

Rollback code API về bảy constants cũ. Giữ schema mở rộng vì tương thích ngược; không thu hẹp DB trong rollback task này.
