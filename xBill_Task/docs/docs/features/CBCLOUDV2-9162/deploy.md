# Deploy — CBCLOUDV2-9162

> **Không ghi giá trị secret** — chỉ ghi tên khóa và người/nơi giữ giá trị.

## 1. Loại thay đổi

- [ ] Migration DB
- [ ] Thêm/đổi khóa cấu hình
- [ ] Thay đổi hàng đợi / topic
- [x] Thay đổi môi trường / hạ tầng: cần môi trường có DB chứa bảng `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` và Redis sẵn sàng để refresh exact keys.
- [x] Khác: deploy code backend/frontend và regenerate NSwag proxy cho AppService mới.

## 2. Thứ tự triển khai

1. Backup DB môi trường đích trước khi import/seed dữ liệu danh mục hành chính nếu có thao tác dữ liệu.
2. Xác nhận DB đích đã có bảng `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` đúng schema code đang map; ticket này **không** kèm migration EF.
3. Deploy backend `invoice-management/aspnet-core` chứa entity/DTO/AppService/permission/localization/cache service mới.
4. Regenerate/build frontend đã có proxy mới, deploy frontend `invoice-management/angular`.
5. Cấp quyền cho menu/action `Admin.DanhMuc.TinhThanhMoi*` và `Admin.DanhMuc.XaPhuong*` cho role/admin phù hợp; sau khi cấp quyền cần restart backend nếu vừa deploy code permission mới và logout/login lại frontend để refresh session permission.
6. Import/seed dữ liệu tỉnh/xã-phường chính thức sau khi dữ liệu được đối soát; thao tác import sẽ refresh Redis qua AppService.
7. Kiểm tra Redis exact keys `VS_LIST_PROVINCE` và `VS_LIST_WARD_[province_code]` sau import/CRUD.

## 3. Migration DB

| Migration | Service | Bảng ảnh hưởng | Thời gian ước tính |
|---|---|---|---|
| Không có migration EF trong ticket này | invoice-management | `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` | Không áp dụng |

- [ ] Đã **backup DB** trước khi chạy import/seed dữ liệu trên staging/production.
- [ ] Đã review schema bảng có sẵn khớp entity trước deploy.

## 4. Khóa cấu hình cần thêm/đổi

| Khóa | Service | Bắt buộc? | Ai cấp giá trị |
|---|---|---|---|
| `Abp:RedisCache:ConnectionString` | invoice-management | Có, dùng cấu hình hiện có | DevOps/owner môi trường |
| `Abp:RedisCache:DatabaseId` | invoice-management | Có, dùng cấu hình hiện có | DevOps/owner môi trường |

> Không thêm khóa mới và không đổi giá trị trong ticket này. Chỉ tên khóa được ghi trong tài liệu; giá trị trao đổi qua kênh bảo mật, không đưa vào tài liệu hay commit.

## 5. Hàng đợi / topic

| Queue / Topic | Thay đổi | Bên gửi | Bên nhận |
|---|---|---|---|
| Không có | Không đổi | Không áp dụng | Không áp dụng |

## 6. Kiểm tra sau khi deploy

| # | Kiểm gì | Kết quả kỳ vọng |
|---|---|---|
| 1 | Mở menu bằng user/role có quyền `Admin.DanhMuc.TinhThanhMoi` | Thấy menu “Tỉnh thành mới”; user không có quyền không thấy menu/nút. |
| 2 | Mở menu bằng user/role có quyền `Admin.DanhMuc.XaPhuong` | Thấy menu “Xã phường”; user không có quyền không thấy menu/nút. |
| 3 | CRUD tỉnh thành mới | Create/edit/delete/import/export hoạt động; không ghi bảng tỉnh cũ `vs_dm_ncc_tinhthanh`. |
| 4 | CRUD xã phường | Xã/phường bắt buộc chọn tỉnh; filter theo tỉnh đúng; không tạo xã mồ côi. |
| 5 | Redis key `VS_LIST_PROVINCE` | Key được tạo/cập nhật sau create/update/delete/import tỉnh. |
| 6 | Redis key `VS_LIST_WARD_[province_code]` | Key theo tỉnh được tạo/cập nhật sau create/update/delete/import xã/phường. |
| 7 | Dữ liệu import chính thức | Mã tỉnh giữ 02 ký tự; mã xã/phường giữ 05 ký tự; không duplicate active; count/mapping khớp file chính thức. |

## 7. Rollback

1. Rollback code backend/frontend về version trước ticket nếu phát sinh lỗi chức năng.
2. Thu hồi các quyền mới khỏi role nếu cần ẩn màn hình ngay.
3. Nếu đã import/seed dữ liệu sai: restore từ DB backup hoặc soft-delete dữ liệu đã import theo danh sách mã đã đưa vào; sau đó refresh lại Redis keys `VS_LIST_PROVINCE` và `VS_LIST_WARD_[province_code]`.
4. Không có migration EF để rollback tự động trong ticket này.

## 8. Ảnh hưởng người dùng

- Không yêu cầu downtime riêng nếu deploy theo quy trình rolling/maintenance hiện có của `invoice-management`.
- Người dùng/role được cấp quyền mới sẽ thấy 2 menu mới sau khi deploy, restart backend nếu cần và logout/login lại frontend.
- User không được cấp quyền không nên thấy menu/nút mới; cần kiểm tra lại phân quyền sau deploy.
