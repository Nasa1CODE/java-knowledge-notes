# Deploy — CBCLOUDV2-9129

> Deploy note cho Gate 1. Chỉ dùng để triển khai sau khi [plan.md](plan.md) được DEV self-review và TechLead/DBA approve. Không chứa secrets/connection string thật.

## Trạng thái

implemented — code backend/frontend đã build/type-check cơ bản; vẫn cần TechLead/DBA xác nhận DB scope trước khi chạy SQL và cần manual test trên môi trường có DB/Redis.

## Phạm vi deploy

| Hạng mục | Có deploy không | Ghi chú |
|---|---:|---|
| Backend `invoice-management/aspnet-core` | Có | AppService/entity/DTO/permission/localization/Excel helper. |
| Frontend `invoice-management/angular` | Có | Route/menu/component/modal/import/proxy. |
| DB schema | Có | Tạo bảng `vs_dm_ncc_loaictdt`; SQL script, không EF migration. |
| Seed data | Có | Seed 8 dòng loại chứng từ điện tử từ [expect.md](expect.md). |
| Redis cache | Có | Cache `DM_NCC_LoaiCTDT`/`All`; clear sau deploy nếu dữ liệu thay đổi. |
| Config secrets | Không | Không thêm secrets; không ghi connection string vào docs/logs. |
| Queue/worker/XML/PDF | Không | Ngoài scope. |

## Điều kiện trước deploy

- [ ] [plan.md](plan.md) đã được DEV self-review và TechLead approve Gate 1.
- [ ] Repo service đã ở branch `hungtq_dev_cloud_CBCLOUDV2-9129` từ `origin/develop_cloud` hoặc branch thực tế được ghi rõ trong PR.
- [ ] TechLead/DBA xác nhận `vs_dm_ncc_loaictdt` thuộc **host DB hay tenant DB**.
  - Plan đang chọn **host DB** theo source `DM_NCC_QuocTich` có `[MultiTenancySide(MultiTenancySides.Host)]`.
  - Cần lưu ý DB docs snapshot hiện có một số bảng DM_NCC dưới tenant; không chạy SQL khi chưa xác nhận môi trường thật.
- [ ] Xác nhận tên cột mô tả là `LoaiCTDT_MoTa` theo [expect.md](expect.md). Nếu muốn dùng `LoaiCTDT_Ten`, phải sửa đồng bộ entity/DTO/UI/SQL/testcase trước deploy.
- [ ] Có backup/snapshot DB dev/staging trước khi chạy SQL.
- [ ] Không dùng `dotnet ef migrations add` cho bảng `vs_*`.

## DB changes

### Bảng mới

- Tên bảng: `vs_dm_ncc_loaictdt`
- Scope đề xuất: host DB theo pattern danh mục quốc tịch.
- File docs/deploy đề xuất sau khi xác nhận host DB: [databasehost.vs_dm_ncc_loaictdt.sql](../../databases/databasehost.vs_dm_ncc_loaictdt.sql)
- Nếu DBA xác nhận tenant DB, đổi thành `databases/databasetenant.vs_dm_ncc_loaictdt.sql` và cập nhật plan/source tương ứng.

### Schema đề xuất

| Cột | Kiểu đề xuất | Null | Ghi chú |
|---|---|---:|---|
| `Id` | `int` | No | PK, auto increment theo convention DB thực tế. |
| `CreationTime` | `datetime` | No | Audit từ `FullAuditedEntity`. |
| `CreatorUserId` | `bigint` | Yes | Audit. |
| `LastModificationTime` | `datetime` | Yes | Audit. |
| `LastModifierUserId` | `bigint` | Yes | Audit. |
| `IsDeleted` | `bit` | No | Soft delete inherited; delete nghiệp vụ vẫn là ngừng hiệu lực. |
| `DeleterUserId` | `bigint` | Yes | Audit. |
| `DeletionTime` | `datetime` | Yes | Audit. |
| `LoaiCTDT_Ma` | `varchar(200)` | No | Mã loại chứng từ điện tử. |
| `LoaiCTDT_MoTa` | `varchar(1500)` | No | Mô tả loại chứng từ điện tử. |
| `LoaiCTDT_BatDau` | `datetime` | Yes | Ngày bắt đầu. |
| `LoaiCTDT_KetThuc` | `datetime` | Yes | Ngày kết thúc. |
| `LoaiCTDT_HieuLuc` | `int` | Yes | `1` hiệu lực, `0` không hiệu lực; default `1`. |

### Index/constraint đề xuất

- Primary key: `Id`.
- Unique/check trùng mã:
  - Ưu tiên unique index theo `LoaiCTDT_Ma` + dữ liệu chưa xóa logic nếu DB/version hỗ trợ phù hợp.
  - Nếu legacy schema không hỗ trợ unique filtered index, AppService vẫn bắt buộc validate duplicate `LoaiCTDT_Ma` với `IsDeleted == false`.
- Không lưu secrets/config/token/JWT trong bảng này.

### SQL create table tham khảo

> Cần DBA chỉnh lại kiểu `bit`/`tinyint`, auto increment, charset/collation, engine và syntax `IF NOT EXISTS` theo MySQL/MariaDB version thực tế trước khi chạy.

```sql
CREATE TABLE IF NOT EXISTS `vs_dm_ncc_loaictdt` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL DEFAULT b'0',
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `LoaiCTDT_Ma` varchar(200) NOT NULL,
    `LoaiCTDT_MoTa` varchar(1500) NOT NULL,
    `LoaiCTDT_BatDau` datetime NULL,
    `LoaiCTDT_KetThuc` datetime NULL,
    `LoaiCTDT_HieuLuc` int NULL DEFAULT 1,
    PRIMARY KEY (`Id`),
    KEY `IX_vs_dm_ncc_loaictdt_IsDeleted` (`IsDeleted`),
    KEY `IX_vs_dm_ncc_loaictdt_Ma` (`LoaiCTDT_Ma`)
);
```

### Seed data

Seed 8 dòng dưới đây. Seed phải chống insert trùng mã khi deploy lại.

| Mã | Mô tả |
|---|---|
| `1` | Chứng từ điện tử khấu trừ thuế TNCN theo Nghị định 70/2025/NĐ-CP |
| `2` | Biên lai thu thuế, phí, lệ phí theo Nghị định 254/2026/NĐ-CP, Nghị định 347/2025/NĐ-CP |
| `3` | Biên lai thu thuế, phí, lệ phí không in sẵn mệnh giá theo Nghị định 70/2025/NĐ-CP |
| `4` | Biên lai thu thuế, phí, lệ phí in sẵn mệnh giá theo Nghị định 70/2025/NĐ-CP |
| `CTT50` | Biên lai thu thuế, phí, lệ phí của cơ quan thuế sử dụng khi thu thuế, phí, lệ phí của cá nhân |
| `6` | Biên lai thu thuế, phí, lệ phí đặt in, tự in, điện tử theo Thông tư 303/2016/TT-BTC, Nghị định 51/2010/NĐ- CP |
| `7` | Chứng từ khấu trừ thuế TNCN theo Nghị định 123/2020/NĐ-CP |
| `8` | Chứng từ khấu trừ thuế TNCN theo Nghị định 254/2026/NĐ-CP |

SQL seed tham khảo:

```sql
INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '1', 'Chứng từ điện tử khấu trừ thuế TNCN theo Nghị định 70/2025/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '1' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '2', 'Biên lai thu thuế, phí, lệ phí theo Nghị định 254/2026/NĐ-CP, Nghị định 347/2025/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '2' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '3', 'Biên lai thu thuế, phí, lệ phí không in sẵn mệnh giá theo Nghị định 70/2025/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '3' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '4', 'Biên lai thu thuế, phí, lệ phí in sẵn mệnh giá theo Nghị định 70/2025/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '4' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', 'CTT50', 'Biên lai thu thuế, phí, lệ phí của cơ quan thuế sử dụng khi thu thuế, phí, lệ phí của cá nhân', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = 'CTT50' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '6', 'Biên lai thu thuế, phí, lệ phí đặt in, tự in, điện tử theo Thông tư 303/2016/TT-BTC, Nghị định 51/2010/NĐ- CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '6' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '7', 'Chứng từ khấu trừ thuế TNCN theo Nghị định 123/2020/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '7' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '8', 'Chứng từ khấu trừ thuế TNCN theo Nghị định 254/2026/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '8' AND `IsDeleted` = b'0');
```

## Config / Redis

Không thêm config mới trong scope plan.

- Redis mechanism: ABP `ICacheManager`.
- Cache name đề xuất: `DM_NCC_LoaiCTDT`.
- Cache key đề xuất: `All`.
- TTL: theo default/pattern hiện hữu, không set TTL riêng nếu QuocTich không set.
- Config key names tham khảo, không ghi giá trị thật:
  - `Abp:RedisCache:ConnectionString`
  - `Abp:RedisCache:DatabaseId`

Sau deploy code hoặc sau seed thủ công, cần clear cache nếu cache cũ đã tồn tại:

- Xóa cache `DM_NCC_LoaiCTDT` key `All` bằng cơ chế app/Redis admin được phép.
- Không ghi Redis password/endpoint/token vào log hoặc docs.

## Backend deploy order

1. Merge/release code backend đã build pass.
2. Đảm bảo permission/localization được include trong artifact deploy.
3. Deploy backend lên environment mục tiêu.
4. Verify API metadata/swagger có AppService mới để frontend generate/consume proxy.
5. Theo dõi log lỗi startup; log không được in secrets/config values.

## Frontend deploy order

1. Generate NSwag proxy từ backend contract đã build.
2. Build Angular artifact.
3. Deploy frontend admin Cloud.
4. Verify menu route `/app/hddt/danhmuc/dmnhacungcap-loaictdt`.
5. Verify role/permission hiển thị đúng chức năng.

## Rollback

### Rollback frontend/backend code

- Rollback artifact/version frontend và backend về version trước release.
- Nếu đã generate proxy nhưng rollback backend, rollback frontend cùng lúc để tránh proxy gọi API không tồn tại.

### Rollback Redis

- Clear cache `DM_NCC_LoaiCTDT`/`All` sau rollback code hoặc rollback DB.
- Không dùng lệnh/log chứa connection string thật trong docs.

### Rollback DB

Chỉ rollback DB sau khi xác nhận không có dữ liệu thật ngoài seed hoặc có phương án backup/restore được approve.

Rollback seed tham khảo:

```sql
DELETE FROM `vs_dm_ncc_loaictdt`
WHERE `LoaiCTDT_Ma` IN ('1', '2', '3', '4', 'CTT50', '6', '7', '8')
  AND `IsDeleted` = b'0';
```

Rollback drop table tham khảo nếu bảng do ticket tạo mới và chưa phát sinh dữ liệu thật:

```sql
DROP TABLE IF EXISTS `vs_dm_ncc_loaictdt`;
```

Nếu bảng đã phát sinh dữ liệu người dùng/import sau release:

- Không drop table trực tiếp.
- Ưu tiên rollback code và giữ DB, hoặc restore từ backup theo quy trình DBA.
- Nếu cần vô hiệu hóa seed, cập nhật `LoaiCTDT_HieuLuc = 0` thay vì xóa vật lý khi phù hợp nghiệp vụ.

## Kiểm chứng sau deploy

- [ ] Mở màn hình danh mục loại chứng từ điện tử thành công.
- [ ] Danh sách hiển thị 8 dòng seed.
- [ ] User không có permission không thấy menu/nút chức năng.
- [ ] Thêm mới/sửa/ngừng hiệu lực hoạt động và clear cache.
- [ ] Export Excel đúng filter/sorting và chỉ có cột whitelist.
- [ ] Import file mẫu thành công; import sai header/trùng mã/date sai trả lỗi an toàn.
- [ ] Log không chứa secrets, raw Excel/base64, token/JWT, connection string hoặc dữ liệu nhạy cảm ngoài scope.
