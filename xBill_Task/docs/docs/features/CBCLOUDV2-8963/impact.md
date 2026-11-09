# Impact — CBCLOUDV2-8963

> Theo [rules/04-create-impact.md](../../rules/04-create-impact.md). Dựng nháp khi lập plan; **finalize sau khi code xong** theo ảnh hưởng thật.
> Trạng thái: **nháp trước code**. CBCLOUDV2-8963 là bản Cloud của nghiệp vụ giống CBCLOUDV2-8988 Liên Sơn.

## 1. Mục đích

Tạo mới **Danh mục quốc tịch** cho ticket CBCLOUDV2-8963 trên admin service Cloud: backend `invoice-management/aspnet-core`, frontend `invoice-management/angular`, bảng mới `vs_dm_ncc_quoctich`, màn CRUD/search/export/import, và cache Redis cho danh sách quốc tịch với cơ chế clear/cập nhật cache khi dữ liệu thay đổi.

## 2. Phạm vi thay đổi

- Chỉ logic: **Không** — có thêm entity/API/màn hình/cache và bảng DB mới.
- Đụng dữ liệu: **Có** — thêm dữ liệu danh mục quốc tịch Cloud.
- Đổi schema / migration: **Có đổi schema** — tạo bảng `vs_dm_ncc_quoctich`; **không dùng EF migration**, cần script/quy trình DB ngoài repo.
- Đổi hợp đồng (API / message hàng đợi): **Có API động ABP mới** (`DM_NCC_QuocTichAppService`); **không** đổi message queue/hợp đồng tích hợp ngoài.
- Đổi nhánh/codebase: **Có** — phát triển trên `D:\BILL\invoicemanagement` nhánh `hungtq_dev_cloud` từ `origin/develop_cloud`.

## 3. Thành phần dự kiến bị ảnh hưởng

### Backend

| Service | File / method | Mức | Lý do |
|---|---|---|---|
| invoice-management/aspnet-core | `HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_QuocTich.cs` | Cao | Entity mới map bảng mới `vs_dm_ncc_quoctich`. |
| invoice-management/aspnet-core | `HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs` | Trung bình | Thêm `DbSet` để EF/repository truy cập bảng mới. |
| invoice-management/aspnet-core | `HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCQuocTich/*` | Trung bình | DTO/input mới cho API và proxy FE. |
| invoice-management/aspnet-core | `HDDT.Application/CustomDtoMapper.cs` | Thấp | Thêm mapping entity ↔ DTO. |
| invoice-management/aspnet-core | `HDDT.Core/Authorization/AppPermissions.cs`, `AppAuthorizationProvider.cs`, `VS-vi.xml` | Trung bình | Thêm quyền/label `Admin.DanhMuc.QuocTich.*`. Sai quyền có thể lộ/ẩn chức năng. |
| invoice-management/aspnet-core | `HDDT.Application/AppServices/DanhMuc/DMNhaCungCap/DM_NCC_QuocTichAppService.cs` | Cao | CRUD/search/export/import/cache/invalidate/logging cho danh mục mới. |
| invoice-management/aspnet-core | `HDDT.Application/Commons/DanhMuc/DMNhaCungCap/DMNhaCungCap_THNTExcelHelper.cs` | Trung bình | Mở rộng helper Excel lớn đang dùng chung nhiều danh mục; cần tránh ảnh hưởng vùng cũ. |

### Frontend

| Màn hình / route | File | Mức | Lý do |
|---|---|---|---|
| Danh mục quốc tịch `/app/hddt/danhmuc/dmnhacungcap-quoctich` | `src/app/hddt/danhmuc/dmnhacungcap/quoctich/*` | Cao | Màn mới: list, modal thêm/sửa, modal nhập Excel. |
| Route admin | `src/app/hddt/hddt-routing.module.ts` | Trung bình | Thêm route mới, tránh ảnh hưởng route danh mục hiện có. |
| Module declarations/imports | `src/app/hddt/hddt.module.ts` | Trung bình | Khai báo component mới; thiếu/sai làm build fail. |
| Menu | `src/app/shared/layout/nav/app-navigation.service.ts` | Trung bình | Thêm item menu quyền `Admin.DanhMuc.QuocTich`. |
| Service proxy/provider | `src/shared/service-proxies/service-proxies.ts`, `service-proxy.module.ts` | Trung bình | NSwag sinh proxy mới; provider thiếu sẽ gây `No provider`. |

### Database

| Bảng / cột | Thay đổi | Mức | Migration |
|---|---|---|---|
| `vs_dm_ncc_quoctich` | Tạo bảng danh mục quốc tịch Cloud, soft-delete/audit theo `FullAuditedEntity`; cột nghiệp vụ: `QuocTich_Ma`, `QuocTich_Ten`, `QuocTich_BatDau`, `QuocTich_KetThuc`, `QuocTich_HieuLuc` + audit/soft-delete. | Cao | **Không EF migration.** Script SQL/rollback ghi trong `deploy.md`, cần DBA/TechLead review và chạy theo quy trình môi trường. |

### Hàng đợi / tích hợp / cấu hình

| Thành phần | Thay đổi | Mức | Ghi chú |
|---|---|---|---|
| Redis / ABP cache | Thêm cache danh sách quốc tịch và clear cache sau Create/Update/Delete/Import | Trung bình | Dùng cấu hình hiện có `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId`; chỉ ghi tên khóa, không ghi giá trị. |
| Queue/RabbitMQ/Kafka/FTP/HSM | Không đổi | Thấp | Không liên quan feature này. |
| NSwag | Regenerate proxy FE | Trung bình | Cần BE local/Swagger chạy được. |

> Cấu hình chỉ ghi **tên khóa**, không ghi giá trị.

## 4. Xác nhận KHÔNG bị ảnh hưởng

| Vùng | Vì sao không bị ảnh hưởng |
|---|---|
| CBCLOUDV2-8988 Liên Sơn | CBCLOUDV2-8963 port trên nhánh Cloud `hungtq_dev_cloud`; không chỉnh lại nhánh LS. |
| Các repo ngoài `D:\BILL\invoicemanagement` | Scope code chỉ là admin service `invoicemanagement`. |
| Các danh mục NCC hiện có (`Ngân hàng`, `Tỉnh thành`, `Tiền tệ`, `Thuế suất`, ...) | Chỉ thêm entity/màn mới; không đổi schema/logic danh mục cũ. Cần cẩn thận khi sửa helper Excel dùng chung. |
| Hóa đơn, phát hành, gửi CQT, ký số | Danh mục quốc tịch chưa nối vào luồng hóa đơn trong scope plan; không đổi entity/API hóa đơn. |
| Queue import/export/PDF | Không thêm message queue hoặc worker. Export Excel ở đây là tải file danh mục qua AppService hiện tại. |
| ABP session/cache nền | Không đổi cấu hình Redis chung; chỉ thêm cache key/list riêng cho quốc tịch. |
| File sinh/build output ngoài proxy | Không sửa `bin/`, `obj/`, `node_modules/`, `build/`, `dist/`. `service-proxies.ts` là file sinh bắt buộc phải regenerate. |

## 5. Rủi ro & hạn chế đã biết

| Rủi ro / hạn chế | Mức | Xử lý |
|---|---|---|
| Cloud/LS diverged nhiều | Cao | Port thủ công vào file Cloud hiện tại; không cherry-pick mù từ 8988. |
| Tạo bảng mới trong hệ thống không dùng EF migration | Cao | B2 bắt DBA/TechLead chốt script, backup, rollback; ghi `deploy.md`; không chạy `dotnet ef migrations add`. |
| Cache stale sau create/update/delete/import | Cao | Gọi clear cache tập trung sau mọi thay đổi; có bước kiểm Redis/manual trong plan. |
| Sai phân quyền làm người không đúng vai trò thấy/sửa danh mục host | Trung bình | Quyền riêng `Admin.DanhMuc.QuocTich.*`; kiểm menu và endpoint `[AbpAuthorize]`. |
| Import Excel sai header/duplicate ghi dữ liệu bẩn | Trung bình | Copy pattern validate header/data; normalize mã; chặn trùng mã chưa xóa; manual test file sai header/duplicate. |
| Helper Excel dùng chung lớn | Trung bình | Thêm vùng riêng quốc tịch; không sửa code danh mục khác; build + test export/import nếu có thời gian. |
| Dữ liệu danh mục host dùng chung nhiều tenant Cloud | Trung bình | Xác nhận host-level B4; xóa dùng soft-delete; không scope tenant nếu chưa chốt. |
| FE production build có thể bị Node/Angular cũ chặn | Trung bình | TypeScript check là gate tối thiểu; production build chỉ báo pass khi môi trường tương thích chạy thật. |

## 6. Chưa được kiểm chứng

| Việc chưa làm | Vì sao |
|---|---|
| Gate 1 approve | `expect.md` đang `draft`, `plan.md` chưa có chữ ký DEV/TechLead. |
| Backend/Frontend code Cloud | Chưa code theo rule 02 vì còn chờ Gate 1. |
| Tạo bảng thật `vs_dm_ncc_quoctich` | Mới có script trong `deploy.md`, chưa DBA apply trên Cloud. |
| Redis cache/invalidation manual | Chưa có code/manual test Cloud. |
| CRUD/search/export/import màn quốc tịch | Chưa thao tác manual Cloud. |
| Gán quyền role thực tế | Permission sẽ khai báo khi code, nhưng chưa gán quyền cho role test. |

## 7. Kết luận

Rủi ro tổng thể trước code ở mức **trung bình-cao** do có bảng mới, cache Redis, phân quyền host-level và port giữa hai nhánh Cloud/LS đã diverge. Cần Gate 1 đầy đủ trước khi code; sau code phải build, regenerate proxy, type-check FE và manual test Cloud/DB/Redis thật trước Gate 2/nghiệm thu.
