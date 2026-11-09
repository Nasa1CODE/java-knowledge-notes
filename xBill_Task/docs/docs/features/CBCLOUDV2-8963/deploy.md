# Deploy — CBCLOUDV2-8963

## 1. Phạm vi deploy

Feature thêm danh mục quốc tịch trên admin service Cloud:

- System: Cloud
- Git repo: `D:\BILL\invoicemanagement`
- Base branch: `origin/develop_cloud`
- Feature branch: `hungtq_dev_cloud`
- BE `invoice-management/aspnet-core`: `D:\BILL\invoicemanagement\aspnet-core`
- FE `invoice-management/angular`: `D:\BILL\invoicemanagement\angular`
- DB: tạo bảng mới `vs_dm_ncc_quoctich`
- Redis: dùng cấu hình ABP hiện có, không thêm secret/config mới

Không dùng EF migration cho bảng này.

## 2. Thứ tự deploy đề xuất

1. Backup DB Cloud theo quy trình DBA trước khi đổi schema.
2. DBA/TechLead review và chạy script tạo bảng `vs_dm_ncc_quoctich` ở môi trường Cloud đích.
3. Deploy BE admin Cloud sau khi bảng đã tồn tại.
4. Deploy FE admin Cloud sau khi BE có Swagger/API `DM_NCC_QuocTich` và proxy FE đã regenerate.
5. Import/seed dữ liệu quốc tịch nếu có nguồn dữ liệu ND254 chính thức.
6. Kiểm tra quyền menu/API, CRUD/search/export/import và cache Redis.

## 3. SQL tạo bảng MariaDB

> Script dưới đây là đề xuất để DBA/TechLead review trước khi chạy trên Cloud. Không chạy qua EF migration.
> Cột generated `QuocTich_Ma_Active` dùng để enforce unique mã quốc tịch chỉ với bản ghi chưa xóa mềm (`IsDeleted = 0`).

```sql
CREATE TABLE IF NOT EXISTS `vs_dm_ncc_quoctich` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `QuocTich_Ma` VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `QuocTich_Ten` VARCHAR(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `QuocTich_BatDau` DATETIME(6) NULL,
    `QuocTich_KetThuc` DATETIME(6) NULL,
    `QuocTich_HieuLuc` INT NULL,
    `CreationTime` DATETIME(6) NOT NULL,
    `CreatorUserId` BIGINT NULL,
    `LastModificationTime` DATETIME(6) NULL,
    `LastModifierUserId` BIGINT NULL,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    `DeleterUserId` BIGINT NULL,
    `DeletionTime` DATETIME(6) NULL,
    `QuocTich_Ma_Active` VARCHAR(200)
        CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
        GENERATED ALWAYS AS (CASE WHEN `IsDeleted` = 0 THEN `QuocTich_Ma` ELSE NULL END) VIRTUAL,
    PRIMARY KEY (`Id`),
    UNIQUE KEY `UX_vs_dm_ncc_quoctich_ma_active` (`QuocTich_Ma_Active`),
    KEY `IX_vs_dm_ncc_quoctich_isdeleted` (`IsDeleted`),
    KEY `IX_vs_dm_ncc_quoctich_ten` (`QuocTich_Ten`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Nếu MariaDB version Cloud không hỗ trợ generated column, dùng fallback dưới đây. Lưu ý fallback này chỉ cho phép một bản ghi đã xóa mềm cho mỗi mã; nếu cần xóa/tạo lại cùng mã nhiều lần thì nên dùng generated column ở script chính.

```sql
CREATE TABLE IF NOT EXISTS `vs_dm_ncc_quoctich` (
    `Id` INT NOT NULL AUTO_INCREMENT,
    `QuocTich_Ma` VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `QuocTich_Ten` VARCHAR(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `QuocTich_BatDau` DATETIME(6) NULL,
    `QuocTich_KetThuc` DATETIME(6) NULL,
    `QuocTich_HieuLuc` INT NULL,
    `CreationTime` DATETIME(6) NOT NULL,
    `CreatorUserId` BIGINT NULL,
    `LastModificationTime` DATETIME(6) NULL,
    `LastModifierUserId` BIGINT NULL,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    `DeleterUserId` BIGINT NULL,
    `DeletionTime` DATETIME(6) NULL,
    PRIMARY KEY (`Id`),
    UNIQUE KEY `UX_vs_dm_ncc_quoctich_ma_isdeleted` (`QuocTich_Ma`, `IsDeleted`),
    KEY `IX_vs_dm_ncc_quoctich_ten` (`QuocTich_Ten`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## 4. Rollback DB MariaDB

> Chỉ chạy rollback sau khi xác nhận không còn code Cloud nào đang dùng bảng, và đã backup dữ liệu cần giữ.

```sql
DROP TABLE IF EXISTS `vs_dm_ncc_quoctich`;
```

Nếu đã import dữ liệu thật và chỉ cần rollback dữ liệu, DBA có thể ưu tiên backup/export rồi soft-delete dữ liệu thay vì drop bảng.

## 5. Redis/cache

- Cache name trong code: `DM_NCC_QuocTich`.
- Cache key danh sách: `All`.
- Dùng ABP `ICacheManager`; Redis lấy từ cấu hình hiện có `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId`.
- Không thêm khóa cấu hình mới và không ghi giá trị connection string vào tài liệu.
- AppService clear cache sau Create/Update/Delete/Import.

## 6. Seed/import dữ liệu

Chưa có nguồn seed chính thức trong ticket. Đề xuất:

- Nếu có file dữ liệu ND254 chính thức: dùng màn Quốc tịch → tải file mẫu → nhập Excel.
- Sample kiểm thử tối thiểu: `AD`, `AE`, `AF` với tên quốc tịch tương ứng do BA/DEV cung cấp.
- Không hardcode seed dài vào code nếu chưa có nguồn nghiệp vụ đã duyệt.

## 7. Smoke test sau deploy

1. Đăng nhập Cloud user có quyền `Admin.DanhMuc.QuocTich`.
2. Mở `/app/hddt/danhmuc/dmnhacungcap-quoctich`.
3. Kiểm tra menu `DanhMuc` có item `QuocTich`.
4. Tạo quốc tịch sample, tìm kiếm theo mã/tên, sửa tên, xóa.
5. Tải file mẫu, nhập Excel, xuất Excel.
6. Gọi danh sách không phân trang/cache, thay đổi dữ liệu, đọc lại danh sách và xác nhận dữ liệu mới hiển thị không cần restart.

## 8. Rollback ứng dụng

1. Revert/deploy lại FE Cloud trước đó để gỡ route/menu Quốc tịch.
2. Revert/deploy lại BE Cloud trước đó để gỡ AppService/entity/permission.
3. DBA xử lý rollback DB theo mục 4 nếu cần.
4. Clear Redis cache name `DM_NCC_QuocTich` nếu môi trường còn key cũ.
