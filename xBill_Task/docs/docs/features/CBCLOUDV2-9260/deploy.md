# Deploy - CBCLOUDV2-9260

status: prepared-not-applied

## Trigger

Task nới năm maxlength vượt capacity 200/300 của các cột tenant DB được khai báo trong migration cũ. Cần deploy DB trước code.

## Precheck bắt buộc

Chạy trên tenant test trước, sau đó từng tenant theo quy trình DBA:

```sql
SHOW COLUMNS FROM vs_hd_chitiet_morong;

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'vs_hd_chitiet_morong'
  AND COLUMN_NAME IN ('sgcnatkthuat', 'sspktclxxuong', 'sspktcclxxuong', 'tltsdky', 'ttmai', 'tnhieu');
```

DBA phải xác nhận cột `sspktclxxuong` tồn tại trước khi chạy forward SQL; migration cũ có typo `sspktcclxxuong`.

## Forward SQL dự kiến

```sql
ALTER TABLE vs_hd_chitiet_morong
    MODIFY COLUMN sgcnatkthuat VARCHAR(255) NULL COMMENT 'Số Giấy chứng nhận chất lượng an toàn kỹ thuật và bảo vệ môi trường (đối với xe nhập khẩu)',
    MODIFY COLUMN sspktclxxuong VARCHAR(255) NULL COMMENT 'Số seri Phiếu kiểm tra chất lượng xuất xưởng (xe sản xuất, lắp ráp trong nước)',
    MODIFY COLUMN tltsdky VARCHAR(255) NULL COMMENT 'Tên loại tài sản đăng ký',
    MODIFY COLUMN ttmai VARCHAR(400) NULL COMMENT 'Tên thương mại',
    MODIFY COLUMN tnhieu VARCHAR(255) NULL COMMENT 'Tên nhãn hiệu';
```

Không chạy SQL nếu precheck không trả cột `sspktclxxuong`. Giữ comment/collation/charset hiện tại khi chốt câu lệnh production.

## Thứ tự deploy

1. Backup/đảm bảo rollback theo quy trình DBA.
2. Chạy precheck và chốt tên/type/collation/comment.
3. Mở rộng schema tenant.
4. Verify `information_schema.COLUMNS`.
5. Deploy `invoicecore` và `svinvoicesendemail`.
6. Smoke import GTGT direct/background và đọc lại DB.

## Rollback

Ưu tiên rollback code về constants cũ và giữ schema mở rộng vì mở rộng `VARCHAR` tương thích ngược.

Chỉ thu hẹp schema nếu query dưới đây trả `0` cho mọi cột:

```sql
SELECT
    SUM(CHAR_LENGTH(sgcnatkthuat) > 200) AS sgcn_over,
    SUM(CHAR_LENGTH(sspktclxxuong) > 200) AS seri_over,
    SUM(CHAR_LENGTH(tltsdky) > 200) AS tltsdky_over,
    SUM(CHAR_LENGTH(ttmai) > 300) AS ttmai_over,
    SUM(CHAR_LENGTH(tnhieu) > 200) AS tnhieu_over
FROM vs_hd_chitiet_morong;
```

Rollback SQL chỉ được DBA hoàn thiện sau precheck; không tự động thu hẹp nếu đã có dữ liệu dài.
