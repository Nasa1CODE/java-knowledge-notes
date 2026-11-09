# Plan — CBCLOUDV2-8963: [Cloud][ND254][Admin] Danh mục quốc tịch

> DEV sở hữu. Sinh cùng AI theo [rules/01-create-plan.md](../../rules/01-create-plan.md). **DEV bắt buộc tự review trước khi trình Gate 1.**
> Status vòng đời feature nằm ở `expect.md`. Ở đây chỉ là trạng thái của bản plan.

plan-status: approved   # draft → plan-review → approved  (CHỈ cho bản plan)

service: invoice-management/aspnet-core, invoice-management/angular
service-repo:
  - invoice-management/aspnet-core → `D:\BILL\invoicemanagement\aspnet-core` *(repo git Cloud: `D:\BILL\invoicemanagement`, base `origin/develop_cloud`, branch `hungtq_dev_cloud`)*
  - invoice-management/angular → `D:\BILL\invoicemanagement\angular` *(repo git Cloud: `D:\BILL\invoicemanagement`, base `origin/develop_cloud`, branch `hungtq_dev_cloud`)*

## Câu hỏi chặn (blocking)

> Phải trả lời xong mới được approve. CBCLOUDV2-8963 là feature Cloud, nghiệp vụ giống CBCLOUDV2-8988 Liên Sơn nhưng hệ thống/branch khác.

- [x] **B0 — Acceptance Criteria Cloud:** BA/DEV/TechLead xác nhận AC trong `expect.md` đủ cho CRUD/search/export/import/file mẫu/cache Redis/phân quyền trên Cloud. → **Chốt:** hungtq - 26/08/2026
- [x] **B1 — Nhánh git Cloud:** xác nhận base branch là `origin/develop_cloud` và nhánh phát triển là `hungtq_dev_cloud`; không port trực tiếp bằng cherry-pick từ nhánh LS vì Cloud/LS đã diverge. → **Chốt:** hungtq - 26/08/2026
- [x] **B2 — Quy trình tạo bảng `vs_dm_ncc_quoctich` trên Cloud:** schema nghiệp vụ không do EF migration quản lý. DBA/TechLead chốt script MariaDB, môi trường chạy, backup và rollback. Không chạy `dotnet ef migrations add`. → **Chốt:** hungtq - 26/08/2026 viết câu lệnh SQL để tôi tự làm tạo bảng
- [x] **B3 — Bộ cột & ràng buộc dữ liệu:** dùng bộ cột giống CBCLOUDV2-8988: `QuocTich_Ma`, `QuocTich_Ten`, `QuocTich_BatDau`, `QuocTich_KetThuc`, `QuocTich_HieuLuc` + audit/soft-delete. Chốt độ dài/ràng buộc unique active code cho Cloud. → **Chốt:** hungtq - 26/08/2026
- [x] **B4 — Phạm vi dữ liệu host/tenant Cloud:** đề xuất host-level theo pattern `DM_NCC_NganHang` Cloud và permission `Admin.DanhMuc.QuocTich`; cần xác nhận không scope tenant riêng. → **Chốt:** hungtq - 26/08/2026
- [x] **B5 — Cache Redis Cloud:** dùng ABP `ICacheManager`, cache danh sách quốc tịch `DM_NCC_QuocTich/All`, clear cache sau Create/Update/Delete/Import; không thêm config/secret mới. → **Chốt:** hungtq - 26/08/2026

## Mục tiêu

Tạo mới màn **Danh mục quốc tịch** trong admin Cloud để quản trị dữ liệu quốc tịch theo ND254: thêm, sửa, xóa, tìm kiếm, xuất Excel, nhập Excel/file mẫu; dữ liệu lưu bảng mới `vs_dm_ncc_quoctich`; danh sách quốc tịch được cache trên Redis và cache được cập nhật/xóa khi dữ liệu thay đổi.

Truy vết từ [expect.md](expect.md):

- Mong muốn 1: tạo màn đầy đủ thêm/sửa/xóa/tìm kiếm/xuất Excel danh mục quốc tịch cho Cloud.
- Mong muốn 2: tạo bảng mới `vs_dm_ncc_quoctich` trên Cloud.
- Mong muốn 3: cache danh mục lên Redis và có cơ chế cập nhật Redis khi dữ liệu thay đổi.
- Mong muốn 4: phát triển trong repo `invoicemanagement` từ `origin/develop_cloud` sang `hungtq_dev_cloud`.

## Bối cảnh

- Service đích: `invoicemanagement` admin Cloud. Trong workspace, `D:\BILL\invoicemanagement` là một git repo chung chứa cả `aspnet-core/` và `angular/`.
- Nhánh hiện đã chuẩn bị: `hungtq_dev_cloud` tracking `origin/develop_cloud`.
- CBCLOUDV2-8988 là bản Liên Sơn cùng nghiệp vụ. Cloud và LS đã diverge ở nhiều file nền, nên cần port thủ công vào file Cloud hiện tại, không merge/cherry-pick mù.
- Pattern gần nhất trong code Cloud là danh mục NCC như `DM_NCC_NganHang`:
  - Entity `[Table("vs_dm_ncc_nganhang")]`, `[MultiTenancySide(MultiTenancySides.Host)]`, kế thừa `FullAuditedEntity`.
  - AppService CRUD + Excel trong nhóm `AppServices/DanhMuc/DMNhaCungCap`.
  - `DbSet` trong `HDDTDbContext.cs` cạnh các `DS*` danh mục NCC.
  - Permission `Admin.DanhMuc.*` trong `AppPermissions.cs` và `AppAuthorizationProvider.cs`.
  - FE route/menu/component ở `angular/src/app/hddt/danhmuc/dmnhacungcap/`.
- Redis dùng cấu hình ABP hiện có `Abp:RedisCache:ConnectionString` và `Abp:RedisCache:DatabaseId`; chỉ ghi tên khóa, không ghi giá trị.
- Quy ước DB hiện tại: schema nghiệp vụ quản lý ngoài repo, không dùng EF migration; thêm bảng phải có script DB và rollback trong `deploy.md`.

## Nguyên nhân gốc

Không phải bug. Hệ thống Cloud chưa có danh mục quốc tịch theo ND254 trong admin service. Cần tạo mới entity/API/màn hình/cache và bảng DB tương tự CBCLOUDV2-8988 nhưng port trên codebase Cloud.

## Giả định · Câu hỏi mở · Ngoài phạm vi

- **Giả định:**
  - Tên entity: `DM_NCC_QuocTich`; tên bảng: `vs_dm_ncc_quoctich`.
  - Dữ liệu host-level nếu B4 được chốt.
  - Mã quốc tịch trim, bỏ khoảng trắng, uppercase.
  - Route FE: `/app/hddt/danhmuc/dmnhacungcap-quoctich`.
  - Cache chỉ cho danh sách không phân trang (`GetAllNoPage`), không cache kết quả phân trang/filter.
- **Câu hỏi mở:**
  - MariaDB Cloud có hỗ trợ generated column cho unique active code không?
  - Có seed/import dữ liệu ND254 chính thức trong scope CBCLOUDV2-8963 không?
  - Docs Cloud có cần nằm trên branch docs `docs/xbill-cloud` trước khi merge không?
- **Ngoài phạm vi:**
  - Không sửa lại feature CBCLOUDV2-8988 Liên Sơn.
  - Không đổi danh mục NCC hiện có ngoài việc thêm danh mục quốc tịch mới.
  - Không đổi cache/session ABP chung.
  - Không chạy `dotnet ef migrations add`.
  - Không đưa secrets Redis/DB vào docs/code/logs.

## Cách làm

Chia bước nhỏ; sau mỗi bước hệ thống vẫn build được. **Chỉ bắt đầu code sau khi B0–B5 chốt và Gate 1 duyệt.**

1. **Chốt phạm vi & nhánh DB/cache (B0–B5)**: AC, nhánh Cloud, bộ cột, cách tạo bảng, chiến lược Redis, phạm vi host-level.
2. **Backend domain/contract nền**: tạo entity `DM_NCC_QuocTich`, DTO/input, `DbSet`, AutoMapper, permissions/localization. Chưa có UI vẫn build được.
3. **Backend AppService + Excel + cache**: tạo `DM_NCC_QuocTichAppService` theo pattern `DM_NCC_NganHangAppService`; thêm export/import/file mẫu vào `DMNhaCungCap_THNTExcelHelper`; inject `ICacheManager`; cache danh sách quốc tịch và clear cache sau Create/Update/Delete/Import; thêm try/catch/logging an toàn.
4. **Regenerate service proxy**: chạy backend admin Cloud local để refresh NSwag, cập nhật `service-proxies.ts` từ swagger mới. Không sửa tay file sinh.
5. **Frontend màn danh mục**: tạo folder component quốc tịch theo pattern `nganhang`: list, modal thêm/sửa, modal nhập Excel; thêm route, module declarations/imports, menu item với permission `Admin.DanhMuc.QuocTich`; thêm provider proxy.
6. **Deploy/docs**: hoàn thiện `deploy.md` với script tạo bảng `vs_dm_ncc_quoctich`, seed/import dữ liệu nếu có, thứ tự deploy, rollback, kiểm Redis.
7. **Kiểm chứng**: build BE, refresh Swagger/NSwag, type-check FE, manual CRUD/search/export/import/cache trên môi trường Cloud.

## Thay đổi kỹ thuật

| Hạng mục | Có/Không | Chi tiết |
|---|---|---|
| Entity / migration | Có entity + bảng mới; **không EF migration** | `DM_NCC_QuocTich` map `[Table("vs_dm_ncc_quoctich")]`; thêm `DbSet`; bảng tạo bằng SQL ngoài repo. |
| DTO / AppService | Có | DTO folder `DMNCCQuocTich`; `DM_NCC_QuocTichAppService` CRUD/search/export/import/file mẫu/cache/logging. |
| Màn hình / route | Có | FE folder `danhmuc/dmnhacungcap/quoctich`; route `danhmuc/dmnhacungcap-quoctich`; menu `DanhMuc` với permission `Admin.DanhMuc.QuocTich`. |
| Hàng đợi / tích hợp | Không | Không thêm queue/message/API ngoài dynamic ABP AppService. |
| Cache Redis | Có | Dùng ABP `ICacheManager`; cache name `DM_NCC_QuocTich`, key `All`; clear sau create/update/delete/import. |
| Cấu hình | Không thêm khóa mới | Chỉ dùng cấu hình Redis hiện có `Abp:RedisCache:*`; không ghi giá trị. |

## Thứ tự thực hiện & phụ thuộc

1. **B0–B5 / Gate 1** → chốt scope trước code.
2. **DB script + backend domain/DTO/permission** → nền cho AppService và FE proxy.
3. **Backend AppService/Excel/cache** → Swagger có endpoint mới.
4. **Regenerate service proxy** → FE compile được với `DM_NCC_QuocTichServiceProxy`.
5. **FE components/route/menu/provider** → dùng proxy mới.
6. **Build/test/manual** → cập nhật `report.md`, `impact.md`, `deploy.md` khi làm rule 02.

## Kế hoạch kiểm chứng

| # | Lệnh / bước kiểm | Kết quả kỳ vọng |
|---|---|---|
| 1 | `git -C "D:\BILL\invoicemanagement" status -sb` | Đang ở `hungtq_dev_cloud`, tree sạch trước khi code. |
| 2 | `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` | Build succeeded, 0 error. |
| 3 | Chạy BE admin Cloud local | Host lên được, Swagger có `DM_NCC_QuocTich` AppService. |
| 4 | `cd "D:\BILL\invoicemanagement\angular\nswag" && refresh.bat` | `service-proxies.ts` có `DM_NCC_QuocTichServiceProxy`. |
| 5 | `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` | TypeScript check 0 error. |
| 6 | **[manual]** Mở menu Danh mục → Quốc tịch; tạo quốc tịch mã `AD`, tên `Andorran`; tìm kiếm theo mã/tên | Bản ghi tạo được, tìm thấy đúng, không lỗi quyền. |
| 7 | **[manual]** Sửa tên, xóa bản ghi vừa tạo | Sửa lưu đúng; xóa soft-delete, bản ghi không còn trong danh sách. |
| 8 | **[manual]** Xuất Excel danh sách quốc tịch | File Excel tải về có cột đúng và dữ liệu đúng filter. |
| 9 | **[manual]** Tải file mẫu → nhập Excel sample `AD/AE/AF` | Import thành công; duplicate/thiếu mã/tên trả lỗi rõ. |
| 10 | **[manual/Redis]** Sau khi gọi API lấy danh sách/cache, tạo/sửa/xóa/import dữ liệu rồi đọc lại danh sách | Cache được clear/cập nhật; dữ liệu mới hiển thị ngay, không phải restart service. |

Không báo pass nếu chưa chạy thật.

## Ma trận rủi ro

| Rủi ro | Ảnh hưởng | Giảm thiểu | Rollback |
|---|---|---|---|
| Trộn thay đổi Liên Sơn vào Cloud | Cao | Chỉ code khi ở `hungtq_dev_cloud` từ `origin/develop_cloud`; kiểm `git status` trước/sau | Revert branch Cloud hoặc reset nếu chưa push |
| Cloud và LS diverged nhiều | Cao | Port thủ công vào file Cloud hiện tại, không cherry-pick mù | Revert từng file/commit |
| Tạo bảng mới không qua EF migration | Cao | DBA/TechLead chốt SQL + backup + rollback; không chạy EF migration | Drop/rename bảng theo rollback DBA; revert code |
| Cache stale sau import/sửa/xóa | Cao | Centralize `ClearCache`; manual Redis test | Clear Redis cache thủ công + hotfix |
| Phân quyền/menu sai làm lộ danh mục host | Trung bình | Quyền riêng `Admin.DanhMuc.QuocTich.*`, kiểm menu/API | Revert permission/menu/AppService |
| Import Excel duplicate/sai header ghi dữ liệu bẩn | Trung bình | Validate header/data/duplicate; normalize mã | Soft-delete dữ liệu import sai, revert import code |
| NSwag proxy conflict lớn | Thấp | Regenerate một lần sau BE ổn; không sửa tay logic file sinh | Regenerate lại từ Swagger đúng version |

## Ghi chú triển khai

**Cần `deploy.md`** vì feature tạo bảng mới và dùng Redis:

- Script tạo bảng `vs_dm_ncc_quoctich` phải do DBA/TechLead chốt; không dùng EF migration.
- Nếu cần dữ liệu ND254 ban đầu, deploy ghi rõ import Excel hay seed SQL, nguồn dữ liệu và rollback.
- Redis dùng cấu hình hiện có `Abp:RedisCache:*`; không thêm secret/config mới.
- Thứ tự đề xuất: (1) backup DB → (2) tạo bảng → (3) deploy BE → (4) refresh/deploy FE → (5) import/seed dữ liệu → (6) kiểm cache/CRUD.
- Rollback: gỡ menu/FE/BE bằng revert; nếu đã tạo bảng/seed dữ liệu thì DBA xử lý rollback theo script đã duyệt.

## Đề xuất cập nhật docs (Gate 2)

- `specs/danh-muc-cau-hinh.md`: thêm `DM_NCC_QuocTich` vào nhóm danh mục NCC Cloud.
- `databases/README.md`: thêm bảng `vs_dm_ncc_quoctich` vào nhóm `DM_NCC_*` sau khi schema được DBA chốt.
- `architecture.md`: nếu cache danh mục admin trở thành pattern chung, bổ sung ghi chú Redis cache/invalidation cho danh mục.
- `conventions/`: cân nhắc bổ sung convention riêng cho admin service Cloud vì hiện thiếu convention admin service.

## Phê duyệt (Gate 1) — chỉ người điền, AI không tự điền

- [ ] DEV tự review: ______ — ngày ______ — link commit/PR ______
- [ ] TechLead approve: ______ — ngày ______ — link commit/PR ______

> Khi block này đủ chữ ký và `expect.md` được human đổi sang `status: approved`, mới chạy rule 02/code.
