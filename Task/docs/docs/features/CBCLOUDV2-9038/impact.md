---
feature: CBCLOUDV2-9038
status: final
owner: AI + DEV
updated_at: 2026-09-24
---

# Impact — CBCLOUDV2-9038

> Theo [rules/04-create-impact.md](../../rules/04-create-impact.md). Đã finalize sau Rule 02 theo thay đổi code thực tế.

## 1. Mục đích

Tạo mới **Danh mục lý do điều chỉnh/thay thế** cho ticket CBCLOUDV2-9038 trên admin service Cloud (`invoice-management`): backend `aspnet-core`, frontend `angular`, bảng mới `vs_dm_ncc_lydo_dieuchinhthaythe`, màn CRUD/search/export/import/template và Redis cache/invalidation riêng cho danh mục.

## 2. Phạm vi thay đổi thực tế

- Chỉ logic: **Không** — có UI, API, DB schema proposal, deploy doc và cache.
- Đụng dữ liệu: **Có** — thêm bảng danh mục mới; seed dữ liệu tham chiếu **chưa ghi cụ thể** vì nguồn ảnh chưa được transcribe/review chắc chắn.
- Đổi schema / migration: **Có đổi schema** — tạo bảng `vs_dm_ncc_lydo_dieuchinhthaythe`; **không dùng EF migration**, SQL script + rollback nằm trong `deploy.md`.
- Đổi hợp đồng API: **Có thêm API động ABP mới** (`DM_NCC_LyDoDieuChinhThayTheAppService`) và regenerate NSwag proxy cho Angular.
- Đổi message queue/Kafka/RabbitMQ/hợp đồng thuế/XML/PDF: **Không**.

## 3. Thành phần bị ảnh hưởng

### Backend

| Service | File / method | Mức | Lý do |
|---|---|---:|---|
| invoice-management | `aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_LyDoDieuChinhThayThe.cs` | Cao | Entity mới map bảng nghiệp vụ mới `vs_dm_ncc_lydo_dieuchinhthaythe`; sai mapping gây lỗi runtime/data. |
| invoice-management | `aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs` | Trung bình | Thêm `DbSet`; ảnh hưởng build/runtime EF context. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLyDoDieuChinhThayThe/*` | Trung bình | DTO/input cho dynamic API và NSwag proxy. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/CustomDtoMapper.cs` | Trung bình | Mapping entity ↔ DTO; sai mapping làm API trả/lưu thiếu dữ liệu. |
| invoice-management | Permission `Admin.DanhMuc.QuocTich.*` | Trung bình | Danh mục lý do điều chỉnh/thay thế dùng chung permission quốc tịch để admin/role đã có quyền quốc tịch nhìn thấy và thao tác được như yêu cầu. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml` | Thấp | Label menu/API message/màn hình tiếng Việt. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/DMNhaCungCap/DM_NCC_LyDoDieuChinhThayTheAppService.cs` | Cao | API CRUD/search/export/import/cache; lỗi có thể tạo dữ liệu bẩn, lộ log import, cache stale. |
| invoice-management | `aspnet-core/src/hddt/HDDT.Application/Commons/DanhMuc/DMNhaCungCap/DMNhaCungCap_THNTExcelHelper.cs` | Cao | Import/export Excel dùng chung helper danh mục NCC; sai header/validate có thể ảnh hưởng import/export danh mục khác nếu sửa nhầm. |

### Frontend

| Màn hình / route | File | Mức | Lý do |
|---|---|---:|---|
| Danh mục lý do điều chỉnh/thay thế `/app/hddt/danhmuc/dmnhacungcap-lydodctt` | `angular/src/app/hddt/danhmuc/dmnhacungcap/lydodctt/*` | Cao | Màn mới gồm list/modal/import/export/delete; cần đúng permission và validation. |
| Route admin HĐĐT | `angular/src/app/hddt/hddt-routing.module.ts` | Trung bình | Thêm route mới; sai route làm không mở được màn hoặc route conflict. |
| Angular module declaration | `angular/src/app/hddt/hddt.module.ts` | Trung bình | Thiếu declaration/import gây compile/runtime error. |
| Menu admin | `angular/src/app/shared/layout/nav/app-navigation.service.ts` | Cao | Menu dùng chung permission `Admin.DanhMuc.QuocTich` để hiển thị giống danh mục quốc tịch theo yêu cầu. |
| Service proxy provider | `angular/src/shared/service-proxies/service-proxy.module.ts` | Trung bình | Thiếu provider gây `NullInjector: No provider`. |
| Generated NSwag proxy | `angular/src/shared/service-proxies/service-proxies.ts` | Trung bình | File generated được regenerate từ Swagger; không sửa tay logic. |

### Database

| Bảng / cột | Thay đổi | Mức | Migration |
|---|---|---:|---|
| `vs_dm_ncc_lydo_dieuchinhthaythe` | Tạo bảng mới với mã, tên lý do, ghi chú, ngày bắt đầu/kết thúc, hiệu lực, audit/soft-delete | Cao | SQL script trong `deploy.md`; **không EF migration**. |
| `LyDo_Ma` / active code | DB đặt index thường theo mã + `IsDeleted`; AppService validate không trùng mã active/not-deleted khi tạo/import | Cao | MariaDB môi trường hiện tại lỗi `1064` với generated column; nếu muốn enforce unique DB-level cần DBA review phương án riêng. |
| Seed dữ liệu tham chiếu | Chưa ghi seed cụ thể vì nguồn ảnh chưa được transcribe/review chắc chắn | Cao | Không invent row; cần BA/TechLead xác nhận trước deploy/import. |

### Hàng đợi / tích hợp / cấu hình

| Thành phần | Thay đổi | Mức | Ghi chú |
|---|---|---:|---|
| Redis / ABP cache | Thêm cache name `DM_NCC_LyDoDieuChinhThayThe`, key `All`; clear sau create/update/delete/import | Trung bình | Dùng config hiện có `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId`; không ghi giá trị. |
| RabbitMQ/Kafka/workers | Không thay đổi | Không | Out-of-scope theo `expect.md`. |
| XML/PDF/HSM/CQT/tax message | Không thay đổi | Không | Out-of-scope theo `expect.md`. |
| Public lookup/searchBill/customer portal | Không thay đổi | Không | Out-of-scope theo `expect.md`. |

> Cấu hình chỉ ghi **tên khóa**, không ghi giá trị.

## 4. Xác nhận KHÔNG bị ảnh hưởng

| Vùng | Vì sao không bị ảnh hưởng |
|---|---|
| `searchBill` public lookup | Ticket chỉ thêm màn admin Cloud trong `invoice-management`; không đổi tra cứu công khai/captcha/public endpoint. |
| `frontend_angular` portal nghiệp vụ | Không thêm route/menu/component ở portal nghiệp vụ; chỉ admin portal `invoice-management/angular`. |
| `invoicecore` invoice lifecycle/sign/issue | Không thay đổi lập/ký/phát hành/điều chỉnh/thay thế hóa đơn runtime; chỉ danh mục admin mới. |
| `api-cloud-service`, `api-qldv-service` | Không đổi API nghiệp vụ hóa đơn hoặc QLDV. |
| Java services `bangke-dctt-java-service`, `etran-teanant-service` | Không đổi bảng kê/DCTT, e-transaction/Kafka/GATE CQT. |
| .NET workers `invoice-sendmail-service`, `export-zip-pdf-service`, `svinvoicesendemail`, `invoice-senddata2tct-service` | Không đổi queue/worker/export background. |
| XML/PDF/template ký số/HSM/CQT | Out-of-scope rõ trong `expect.md`; danh mục mới không tham gia render/gửi thuế trong ticket này. |
| Existing danh mục quốc tịch | Chỉ dùng làm pattern; không sửa logic/bảng/cache/key quốc tịch. |

## 5. Rủi ro & hạn chế đã biết

| Rủi ro / hạn chế | Mức | Xử lý |
|---|---:|---|
| Lộ dữ liệu/log nhạy cảm khi import Excel | Cao | AppService không log raw Excel/base64/file content; chỉ log tên file truncate/trạng thái có dữ liệu/message lỗi. |
| Permission không khớp danh mục quốc tịch | Trung bình | Đã đổi menu/nút/API sang dùng chung `Admin.DanhMuc.QuocTich.*`; không còn permission riêng `LyDoDieuChinhThayThe.*`, không cần SQL grant quyền mới. |
| Sai schema/active code trên MariaDB | Cao | `deploy.md` đã đổi sang SQL không dùng generated column sau lỗi `1064`; DB có index thường, app validate trùng mã active; nếu cần unique DB-level phải DBA/TechLead review phương án riêng. |
| Seed từ ảnh bị đọc sai hoặc invent dữ liệu | Cao | Không invent seed; deploy doc/report ghi blocker cần BA/TechLead xác nhận danh sách mã/tên trước khi seed/import. |
| Cache stale sau create/edit/delete/import | Trung bình | AppService có `ClearCache()` sau mutation/import; manual Redis/cache test chưa chạy do chưa có môi trường runtime đầy đủ. |
| Sửa chung Excel helper làm ảnh hưởng danh mục khác | Trung bình | Thêm method riêng cho lý do điều chỉnh/thay thế, không đổi luồng import/export hiện hữu của quốc tịch. |
| NSwag proxy generated diff/conflict | Trung bình | Đã regenerate từ Swagger BE local; không sửa tay logic generated proxy. |
| Nhầm repo `invoice-management` canonical với checkout thực tế `D:\BILL\invoicemanagement` hoặc FUTA/Liên Sơn | Trung bình | Chỉ sửa repo code thực tế `D:\BILL\invoicemanagement` cho service-key `invoice-management`; không sửa FUTA/Liên Sơn/other services. |

> Chạm phân quyền, dữ liệu danh mục host-level và import file nên bắt buộc kiểm rủi ro lộ dữ liệu: ticket phải đảm bảo không cross-tenant/host leak qua API/menu/log/export/import; export không chứa audit/user identity/secret/config.

## 6. Kết quả kiểm chứng

| Việc kiểm chứng | Kết quả |
|---|---|
| Backend build `VS.Web.sln` | PASS — `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` → `Build succeeded`, `0 Error(s)`, `375 Warning(s)`, elapsed `00:00:11.34`. Build output `.tmp-build` đã restore khỏi diff nguồn. |
| Swagger + NSwag proxy | PASS — chạy BE local với `ASPNETCORE_URLS=http://localhost:22742`, Swagger có `DM_NCC_LyDoDieuChinhThayThe`, chạy `angular/nswag/refresh.bat` sinh `DM_NCC_LyDoDieuChinhThayTheServiceProxy` và DTO mới. |
| Frontend TypeScript check | PASS — `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` → exit code 0, không có output lỗi. |
| SQL create/rollback chạy trên MariaDB Cloud | NOT RUN — cần DBA/TechLead review SQL trong `deploy.md` và môi trường DB Cloud; AI không tự chạy deploy/DB. |
| Seed data từ ảnh nguồn | NOT RUN / BLOCKED — chưa có danh sách mã/tên đã transcribe và review; không invent dữ liệu seed. |
| Manual CRUD/search/export/import/cache | NOT RUN — chưa có môi trường runtime/DB/Redis Cloud được cấp cho manual end-to-end; ghi smoke test trong `deploy.md`. |
| Redis cache runtime | NOT RUN — chưa chạy môi trường Redis Cloud; code dùng ABP `ICacheManager` và clear cache sau create/update/delete/import. |

## 7. Gate 2 docs diff

Không đề xuất sửa trực tiếp `docs/specs/`, `docs/architecture.md`, `docs/databases/` hoặc `docs/design.md` trong Rule 02 này. Thay đổi schema/deploy đã được ghi trong feature-level `deploy.md`; nếu TechLead muốn đưa bảng `vs_dm_ncc_lydo_dieuchinhthaythe` vào docs nền, cần Gate 2 review/MR riêng.

## 8. Kết luận

Rủi ro tổng thể **Cao** vì feature thêm bảng nghiệp vụ, permission admin, import/export Excel và Redis cache. Phần code đã build/type-check pass và nằm trong scope service `invoice-management`; phần DB/seed/manual runtime còn cần DBA/TechLead/BA xác nhận và kiểm chứng theo `deploy.md` trước khi deploy thật.
