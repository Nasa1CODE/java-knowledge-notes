# Impact — CBCLOUDV2-9162

> Theo [rules/04-create-impact.md](../../rules/04-create-impact.md). Đã finalize theo thay đổi code thật ở Rule 02; các mục chưa kiểm chứng manual được ghi rõ, không bịa kết quả.

## 1. Mục đích

CBCLOUDV2-9162 bổ sung danh mục admin mới cho **Tỉnh thành mới** và **Xã phường** trong service `invoice-management`, dùng bảng có sẵn `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong`, map xã/phường với tỉnh và đồng bộ Redis exact keys `VS_LIST_PROVINCE`, `VS_LIST_WARD_[province_code]` sau khi dữ liệu thay đổi.

## 2. Phạm vi thay đổi

- Chỉ logic: **Không** — có backend, frontend, import/export Excel, NSwag proxy và Redis cache.
- Đụng dữ liệu: **Có** — CRUD/import/export danh mục tỉnh/xã-phường trên bảng hiện có; chưa seed/import dữ liệu chính thức.
- Đổi schema / migration: **Không** — không tạo/chạy EF migration; code map vào 2 bảng đã có theo `expect.md`.
- Đổi hợp đồng (API / message hàng đợi): **Có API AppService mới** cho tỉnh thành mới và xã phường; **không có message queue**.

## 3. Thành phần bị ảnh hưởng

### Backend

| Service | File / method | Mức | Lý do |
|---|---|---|---|
| invoice-management | `aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/HanhChinh/DanhMucTinhThanh.cs` | TB | Entity Host-level map bảng `vs_danhmuc_tinh_thanh`, dùng mã tỉnh dạng `string`. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/HanhChinh/DanhMucXaPhuong.cs` | TB | Entity Host-level map bảng `vs_danhmuc_xa_phuong`, có `TinhThanh_Ma` để map tỉnh. |
| invoice-management | `aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs` | TB | Thêm DbSet `DSDanhMucTinhThanh`, `DSDanhMucXaPhuong` cho ABP repository. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/CustomDtoMapper.cs` | Thấp | Thêm mapping entity ↔ DTO cho tỉnh/xã-phường. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/HanhChinh/DanhMucTinhThanh/DanhMucTinhThanhDto.cs` | TB | DTO tỉnh thành mới có audit fields và mã/tên/ngày/hiệu lực. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/HanhChinh/DanhMucTinhThanh/GetAllDanhMucTinhThanhInput.cs` | Thấp | Input filter/sort/page cho tỉnh. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/HanhChinh/DanhMucXaPhuong/DanhMucXaPhuongDto.cs` | TB | DTO xã/phường có mã xã, mã/tên tỉnh, audit fields. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/HanhChinh/DanhMucXaPhuong/GetAllDanhMucXaPhuongInput.cs` | Thấp | Input filter/sort/page theo tỉnh/mã/tên. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/HanhChinh/DanhMucHanhChinhCacheService.cs` | Cao | Service refresh Redis exact keys `VS_LIST_PROVINCE`, `VS_LIST_WARD_[province_code]` bằng StackExchange.Redis, không log secret. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/HanhChinh/DanhMucTinhThanhAppService.cs` | Cao | CRUD/search/import/export/file mẫu tỉnh; validate duplicate/format; refresh Redis sau mutate/import. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/HanhChinh/DanhMucXaPhuongAppService.cs` | Cao | CRUD/search/import/export/file mẫu xã/phường; validate tỉnh tồn tại/active; refresh ward key sau mutate/import. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/Commons/DanhMuc/HanhChinh/DanhMucHanhChinhExcelHelper.cs` | TB | Import/export/file mẫu Excel, validate mã tỉnh 02 ký tự, mã xã 05 ký tự, ngày, hiệu lực, duplicate. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Core/Authorization/AppPermissions.cs` | TB | Thêm permission riêng cho `TinhThanhMoi` và `XaPhuong`. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Core/Authorization/AppAuthorizationProvider.cs` | TB | Gắn permission mới dưới nhóm danh mục admin theo pattern các danh mục hiện có để role/admin grant được quyền menu/action mới. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml` | Thấp | Thêm label/menu/message tiếng Việt cho màn mới. |

### Frontend

| Màn hình / route | File | Mức | Lý do |
|---|---|---|---|
| Menu danh mục admin | `angular/src/app/shared/layout/nav/app-navigation.service.ts` | TB | Thêm menu `TinhThanhMoi`, `XaPhuong` theo permission mới; không đổi menu tỉnh/quận huyện cũ. |
| Route hddt | `angular/src/app/hddt/hddt-routing.module.ts` | TB | Thêm route `/app/hddt/danhmuc/tinhthanhmoi` và `/app/hddt/danhmuc/xaphuong`. |
| Module declarations | `angular/src/app/hddt/hddt.module.ts` | TB | Khai báo component/modal mới. |
| Tỉnh thành mới | `angular/src/app/hddt/danhmuc/hanhchinh/tinhthanhmoi/danhmuc-tinhthanhmoi.component.ts` | Cao | List/search/export/import/create/edit/delete tỉnh. |
| Tỉnh thành mới template | `angular/src/app/hddt/danhmuc/hanhchinh/tinhthanhmoi/danhmuc-tinhthanhmoi.component.html` | Cao | Table/filter/buttons theo permission và layout search mới. |
| Modal tỉnh | `angular/src/app/hddt/danhmuc/hanhchinh/tinhthanhmoi/thongtin-danhmuc-tinhthanhmoi-modal.component.ts`, `.html` | TB | Modal create/edit, khóa mã khi edit, validate required/max length. |
| Import tỉnh | `angular/src/app/hddt/danhmuc/hanhchinh/tinhthanhmoi/nhap-file-danhmuc-tinhthanhmoi-modal.component.ts`, `.html` | TB | Tải file mẫu và import Excel tỉnh. |
| Xã phường | `angular/src/app/hddt/danhmuc/hanhchinh/xaphuong/danhmuc-xaphuong.component.ts` | Cao | List/search/filter theo tỉnh/export/import/create/edit/delete xã/phường. |
| Xã phường template | `angular/src/app/hddt/danhmuc/hanhchinh/xaphuong/danhmuc-xaphuong.component.html` | Cao | Table/filter tỉnh/buttons theo permission. |
| Modal xã phường | `angular/src/app/hddt/danhmuc/hanhchinh/xaphuong/thongtin-danhmuc-xaphuong-modal.component.ts`, `.html` | TB | Modal create/edit, chọn tỉnh bắt buộc, khóa mã khi edit. |
| Import xã phường | `angular/src/app/hddt/danhmuc/hanhchinh/xaphuong/nhap-file-danhmuc-xaphuong-modal.component.ts`, `.html` | TB | Tải file mẫu và import Excel xã/phường. |
| Service proxies | `angular/src/shared/service-proxies/service-proxies.ts` | TB | Regenerate bằng NSwag để có `DanhMucTinhThanhServiceProxy`, `DanhMucXaPhuongServiceProxy`, DTO/proxy mới. |
| Proxy providers | `angular/src/shared/service-proxies/service-proxy.module.ts` | TB | Thêm provider proxy mới để tránh thiếu DI. |

### Database

| Bảng / cột | Thay đổi | Mức | Migration |
|---|---|---|---|
| `vs_danhmuc_tinh_thanh` | Code đọc/ghi/import/export/soft-delete dữ liệu tỉnh thành mới. | Cao | Không migration; giả định bảng đã có theo `expect.md`. |
| `vs_danhmuc_xa_phuong` | Code đọc/ghi/import/export/soft-delete dữ liệu xã/phường, map tỉnh bằng mã tỉnh. | Cao | Không migration; giả định bảng đã có theo `expect.md`. |
| `vs_dm_ncc_tinhthanh` | Không đổi. | Thấp | Không migration. |
| Bảng quận huyện cũ | Không đổi. | Thấp | Không migration. |

### Hàng đợi / tích hợp / cấu hình

| Thành phần | Thay đổi | Mức | Ghi chú |
|---|---|---|---|
| Redis key `VS_LIST_PROVINCE` | Được ghi lại sau create/update/delete/import tỉnh. | Cao | Ghi bằng direct Redis để giữ exact physical key. |
| Redis key `VS_LIST_WARD_[province_code]` | Được ghi lại sau create/update/delete/import xã/phường; refresh cả tỉnh cũ và mới nếu đổi tỉnh. | Cao | Province code được normalize trước khi tạo key. |
| Config `Abp:RedisCache:ConnectionString` | Sử dụng cấu hình hiện có. | TB | Chỉ ghi tên khóa, không ghi giá trị. |
| Config `Abp:RedisCache:DatabaseId` | Sử dụng cấu hình hiện có. | TB | Chỉ ghi tên khóa, không ghi giá trị. |
| NSwag metadata/proxy | Regenerate proxy cho AppService mới. | TB | Khi chạy NSwag đã start backend tạm ở port local khác do port mặc định bị chặn. |
| Message queue/background job | Không đổi. | Thấp | Không có yêu cầu hàng đợi. |

> Cấu hình chỉ ghi **tên khóa**, không ghi giá trị.

## 4. Xác nhận KHÔNG bị ảnh hưởng

| Vùng | Vì sao không bị ảnh hưởng |
|---|---|
| Luồng phát hành/tra cứu hóa đơn | Feature chỉ thêm danh mục admin tỉnh/xã-phường và Redis danh mục; không thay đổi nghiệp vụ lập/phát hành/tra cứu hóa đơn. |
| Cấu hình JWT/authentication | Không đổi cấu hình auth; chỉ thêm permission constants/tree. |
| Redis connection settings | Không đổi tên/giá trị cấu hình Redis hiện có; chỉ dùng các khóa cấu hình sẵn có. |
| Danh mục ngân hàng/tiền tệ/thuế suất/NCC khác | Không sửa logic các danh mục này. |
| Danh mục tỉnh thành cũ `DM_NCC_TinhThanh` / `vs_dm_ncc_tinhthanh` | Không sửa AppService/entity/UI của màn cũ; màn mới dùng bảng/route/permission riêng. |
| Danh mục quận huyện cũ | Không migrate/quy đổi quận huyện; xã/phường là màn/bảng mới. |
| Tenant settings/billing/package services | Không thay đổi cấu hình gói dịch vụ/tenant billing. |
| Public web app | Chỉ thêm màn admin Cloud trong `angular/src/app/hddt`; public site không đổi. |

## 5. Rủi ro & hạn chế đã biết

| Rủi ro / hạn chế | Mức | Xử lý |
|---|---|---|
| Dữ liệu official parse sai từ attachment/OCR | Cao | Task 7 vẫn pending; cần đối soát file nhóm chính thức trước import/seed. |
| Chưa test manual DB/Redis/UI | Cao | Report ghi rõ chưa chạy; cần môi trường DB/Redis/user quyền trước release. |
| Redis stale nếu môi trường Redis không sẵn sàng hoặc sai DB id | Cao | Code không log secret; cần kiểm tra key thật trên môi trường deploy. |
| Mất số 0 đầu mã tỉnh/xã | Cao | Code dùng `string`, normalize trim/uppercase, validate mã tỉnh 02 ký tự, xã/phường 05 ký tự. |
| Schema bảng có sẵn khác kỳ vọng | TB | Không tạo migration; cần DBA/TechLead xác nhận schema thật trên DB đích. |
| Permission/Host scope sai có thể lộ dữ liệu master hoặc làm admin không thấy menu | Cao | Entity vẫn Host-level như bảng master data; permission provider đặt theo pattern danh mục admin hiện có. Bắt buộc test user có/không quyền và cấp quyền đúng role. |
| NSwag config phải giữ URL mặc định sau khi regenerate | TB | Đã tạm đổi sang local port để regenerate rồi trả config về URL mặc định. |

> Chạm phân quyền, đa tenant và master data dùng chung nên có rủi ro lộ dữ liệu nếu permission/scope sai. Bắt buộc test user có/không quyền và xác nhận Host/Tenant scope trước release.

## 6. Chưa được kiểm chứng

| Việc chưa làm | Vì sao |
|---|---|
| Manual UI tỉnh thành mới/xã phường | Chưa có phiên nghiệm thu/manual test trong trình duyệt. |
| Manual DB query `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` | Chưa chạy query trên DB đích; không ghi/lộ connection secret. |
| Manual Redis check `VS_LIST_PROVINCE`, `VS_LIST_WARD_[province_code]` | Chưa có Redis/key verification trên môi trường đích; không ghi/lộ secret Redis. |
| Đối soát/import dữ liệu chính thức 34 tỉnh và xã/phường | Task 7 pending; attachment có rủi ro OCR/malformed, cần file nhóm chính thức. |
| Test user có/không quyền | Cần tài khoản và môi trường chạy UI. |

## 7. Kết luận

Rủi ro tổng thể sau code ở mức **Trung bình-Cao**: build/NSwag/TypeScript đã PASS, nhưng dữ liệu chính thức, manual UI/DB/Redis và permission smoke test vẫn phải hoàn tất trước khi phát hành demo/release.
