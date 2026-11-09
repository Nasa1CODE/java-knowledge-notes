# Deploy — CBCLOUDV2-9038

## 1. Phạm vi deploy

Feature thêm **Danh mục lý do điều chỉnh/thay thế** trên admin service Cloud:

- System: Cloud
- Service-key canonical: `invoice-management`
- Git repo thực tế: `D:\BILL\invoicemanagement`
- Base branch: `origin/develop_cloud`
- Feature branch: `hungtq_dev_cloud_CBCLOUDV2-9038`
- BE `invoice-management/aspnet-core`: `D:\BILL\invoicemanagement\aspnet-core`
- FE `invoice-management/angular`: `D:\BILL\invoicemanagement\angular`
- DB: tạo bảng mới `vs_dm_ncc_lydo_dieuchinhthaythe`
- Redis: dùng cấu hình ABP hiện có, không thêm secret/config mới
- Permission sử dụng lại theo danh mục quốc tịch: `Admin.DanhMuc.QuocTich.*`

Không dùng EF migration cho bảng nghiệp vụ `vs_*`.

## 2. Thứ tự deploy đề xuất

1. Backup DB Cloud theo quy trình DBA trước khi đổi schema.
2. DBA/TechLead review và chạy script tạo bảng `vs_dm_ncc_lydo_dieuchinhthaythe` ở môi trường Cloud đích.
3. Seed dữ liệu tham chiếu nếu nguồn seed đã được BA/TechLead xác nhận; nếu chưa xác nhận thì bỏ qua seed và ghi blocker.
4. Deploy BE admin Cloud sau khi bảng đã tồn tại.
5. Deploy FE admin Cloud sau khi BE có Swagger/API `DM_NCC_LyDoDieuChinhThayThe` và proxy FE đã regenerate.
6. Kiểm tra role đang có quyền `Admin.DanhMuc.QuocTich.*`; danh mục lý do điều chỉnh/thay thế dùng chung nhóm quyền này để hiển thị/thao tác giống danh mục quốc tịch.
7. Kiểm tra quyền menu/API, CRUD/search/export/import và cache Redis.

## 3. SQL tạo bảng MariaDB

> Script dưới đây là đề xuất để DBA/TechLead review trước khi chạy trên Cloud. Không chạy qua EF migration.
> Không dùng generated column vì MariaDB môi trường hiện tại báo lỗi `1064` với cú pháp `GENERATED ALWAYS AS ... VIRTUAL`.
> Ràng buộc trùng mã bản ghi đang hiệu lực (`IsDeleted = 0`) được kiểm tra trong AppService khi tạo/import; DB đặt index thường để hỗ trợ tìm kiếm/kiểm tra mã.

```sql
CREATE TABLE IF NOT EXISTS `vs_dm_ncc_lydo_dieuchinhthaythe` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `LyDo_Ma` VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `LyDo_Ten` VARCHAR(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `LyDo_GhiChu` VARCHAR(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `LyDo_BatDau` DATETIME(6) NULL,
    `LyDo_KetThuc` DATETIME(6) NULL,
    `LyDo_HieuLuc` INT NULL,
    `CreationTime` DATETIME(6) NOT NULL,
    `CreatorUserId` BIGINT NULL,
    `LastModificationTime` DATETIME(6) NULL,
    `LastModifierUserId` BIGINT NULL,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    `DeleterUserId` BIGINT NULL,
    `DeletionTime` DATETIME(6) NULL,
    PRIMARY KEY (`Id`),
    KEY `IX_vs_dm_ncc_lydo_dctt_ma_isdeleted` (`LyDo_Ma`, `IsDeleted`),
    KEY `IX_vs_dm_ncc_lydo_dctt_isdeleted` (`IsDeleted`),
    KEY `IX_vs_dm_ncc_lydo_dctt_ten` (`LyDo_Ten`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Nếu DBA xác nhận MariaDB/MySQL đích hỗ trợ generated column/functional index và muốn enforce unique active code ở DB level, có thể bổ sung phương án riêng sau review. Với script mặc định ở trên, app vẫn validate không trùng mã active khi tạo/import; khi deploy nhiều instance cần tránh chạy đồng thời các thao tác tạo/import cùng mã trong thời điểm race-condition.

## 4. Seed dữ liệu tham chiếu

Nguồn tham chiếu trong `expect.md`: `C:\Users\hungtq\Downloads\Telegram Desktop\danhmuc.png`.

Chưa ghi SQL seed cụ thể trong file này vì Rule 02 chưa có dữ liệu seed đã transcribe/review từ nguồn ảnh. Không invent dữ liệu seed. Khi BA/TechLead xác nhận danh sách mã/tên lý do, bổ sung seed theo mẫu chống trùng dưới đây:

```sql
INSERT INTO `vs_dm_ncc_lydo_dieuchinhthaythe`
(`LyDo_Ma`, `LyDo_Ten`, `LyDo_GhiChu`, `LyDo_BatDau`, `LyDo_KetThuc`, `LyDo_HieuLuc`, `CreationTime`, `IsDeleted`)
SELECT '<MA>', '<TEN_LY_DO>', NULL, NULL, NULL, 1, UTC_TIMESTAMP(6), 0
WHERE NOT EXISTS (
    SELECT 1
    FROM `vs_dm_ncc_lydo_dieuchinhthaythe`
    WHERE `LyDo_Ma` = '<MA>' AND `IsDeleted` = 0
);
```

Seed có thể thực hiện bằng SQL đã review hoặc import Excel qua màn sau khi deploy, tùy quyết định của DBA/TechLead.

## 5. Rollback DB MariaDB

> Chỉ chạy rollback sau khi xác nhận không còn code Cloud nào đang dùng bảng, và đã backup dữ liệu cần giữ.

Rollback toàn feature:

```sql
DROP TABLE IF EXISTS `vs_dm_ncc_lydo_dieuchinhthaythe`;
```

Nếu đã import/seed dữ liệu thật và chỉ cần rollback dữ liệu, DBA có thể ưu tiên backup/export rồi soft-delete danh sách mã seed đã xác nhận thay vì drop bảng:

```sql
UPDATE `vs_dm_ncc_lydo_dieuchinhthaythe`
SET `IsDeleted` = 1,
    `DeletionTime` = UTC_TIMESTAMP(6)
WHERE `LyDo_Ma` IN ('<MA_1>', '<MA_2>')
  AND `IsDeleted` = 0;
```

## 6. Redis/cache

- Cache name trong code: `DM_NCC_LyDoDieuChinhThayThe`.
- Cache key danh sách: `All`.
- Dùng ABP `ICacheManager`; Redis lấy từ cấu hình hiện có `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId`.
- Không thêm khóa cấu hình mới và không ghi giá trị connection string vào tài liệu.
- AppService clear cache sau Create/Update/Delete/Import.
- Khi rollback ứng dụng, có thể clear cache name `DM_NCC_LyDoDieuChinhThayThe` theo công cụ vận hành Redis/ABP hiện có.

## 7. Permission

Danh mục lý do điều chỉnh/thay thế dùng chung permission với danh mục quốc tịch để hiển thị/thao tác giống Quốc tịch:

- Xem menu/danh sách/export: `Admin.DanhMuc.QuocTich`
- Thêm mới: `Admin.DanhMuc.QuocTich.Create`
- Chỉnh sửa: `Admin.DanhMuc.QuocTich.Edit`
- Xóa: `Admin.DanhMuc.QuocTich.Delete`
- Import/tải mẫu: `Admin.DanhMuc.QuocTich.Import`

Không cần SQL grant permission mới `LyDoDieuChinhThayThe.*`.

## 8. Cấu hình / dependencies / hàng đợi

- Cấu hình mới: Không.
- Dependency mới: Không.
- Queue/topic/worker/job mới: Không.
- HSM/CQT/XML/PDF/public lookup: Không thay đổi.

## 9. Smoke test sau deploy

1. Đăng nhập Cloud user có quyền `Admin.DanhMuc.QuocTich`.
2. Mở `/app/hddt/danhmuc/dmnhacungcap-lydodctt`.
3. Kiểm tra menu `DanhMuc` có item `Lý do điều chỉnh/thay thế` hiển thị giống user đang thấy menu `QuocTich`.
4. Kiểm tra user thiếu quyền `Admin.DanhMuc.QuocTich.*` không thấy menu/nút tương ứng và không gọi được API tương ứng.
5. Tạo bản ghi sample hợp lệ, tìm kiếm theo mã/tên lý do, sửa tên/ghi chú/date/hiệu lực, xóa.
6. Kiểm tra validate: thiếu mã, thiếu tên lý do, quá maxlength, trùng mã, ngày bắt đầu lớn hơn ngày kết thúc.
7. Tải file mẫu, import Excel hợp lệ, import sai header/duplicate/invalid date/length.
8. Xuất Excel theo filter/sorting hiện tại; file không có audit/user identity/secret/config/token.
9. Gọi danh sách không phân trang/cache, thay đổi dữ liệu, đọc lại danh sách và xác nhận dữ liệu mới hiển thị không cần restart.

## 10. Rollback ứng dụng

1. Revert/deploy lại FE Cloud trước đó để gỡ route/menu/component lý do điều chỉnh/thay thế.
2. Revert/deploy lại BE Cloud trước đó để gỡ AppService/entity/permission/helper.
3. DBA xử lý rollback DB theo mục 5 nếu cần.
4. Clear Redis cache name `DM_NCC_LyDoDieuChinhThayThe` nếu môi trường còn key cũ.
