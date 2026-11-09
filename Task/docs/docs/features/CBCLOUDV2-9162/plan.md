# Plan — CBCLOUDV2-9162: Danh mục tỉnh thành mới / xã phường

> DEV sở hữu. Sinh cùng AI theo [rules/01-create-plan.md](../../rules/01-create-plan.md). **DEV bắt buộc tự review trước khi trình Gate 1.**
> Status vòng đời feature nằm ở `expect.md`. Ở đây chỉ là trạng thái của bản plan.

plan-status: draft

service: invoice-management
service-repo: `D:\BILL\invoicemanagement` — BE `D:\BILL\invoicemanagement\aspnet-core`, FE `D:\BILL\invoicemanagement\angular`

## Câu hỏi chặn (blocking)

> Phải trả lời xong mới được approve. Rỗng nếu không có.

- [x] B1: `expect.md` nằm trong folder `CBCLOUDV2-9162` nhưng dòng `jira:` đang ghi `CBCLOUDV2-8963`. Chốt ticket chính thức để tránh ghi nhầm branch/docs/commit/PR. → **Chốt:** đã cập nhật lại (hungtq)
- [x] B2: `expect.md` nói DB đã có bảng `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong`; code hiện có màn Tỉnh thành cũ dùng entity `DM_NCC_TinhThanh` map bảng `vs_dm_ncc_tinhthanh` và Quận huyện cũ. Cần chốt feature này tạo entity/AppService/screen mới trên `vs_danhmuc_*`, hay tái sử dụng/migrate từ bảng cũ. → **Chốt:** không động chạm hay map những bảng cũ (hungtq)
- [x] B3: AC trong `expect.md` mô tả đầy đủ CRUD/import/export cho tỉnh thành mới, nhưng tiêu đề/mong muốn có cả “xã phường” và Redis key ward. Cần chốt xã/phường có full CRUD/search/import/export/file mẫu/quyền riêng như tỉnh, hay chỉ seed dữ liệu + API/cache theo tỉnh. → **Chốt:** chốt xã/phường có full(hungtq)_
- [x] B4: Chốt schema thực tế của `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` trong DB demo/dev: tên cột mã, tên, tên tắt/loại đơn vị, hiệu lực, ngày bắt đầu/kết thúc, khóa map xã-phường → tỉnh, soft-delete/audit. Không tự chạy `dotnet ef migrations add` cho bảng `vs_*`. → **Chốt:** Chốt (hungtq)_
- [x] B5: Chốt cách ghi Redis key chính xác: dùng ABP `ICacheManager` với cache name/key hay dùng service Redis trực tiếp để bảo đảm key vật lý đúng `VS_LIST_PROVINCE` và `VS_LIST_WARD_[province_code]`. → **Chốt:** Theo như yêu cầu (hungtq)_
- [x] B6: Chốt nguồn dữ liệu import/seed chính thức từ file nhóm/attachment: file nào là nguồn cuối, format nào được phép commit, ai xác nhận các dòng lỗi OCR/parse như mã dạng `071.47`. → **Chốt:** Chốt (hungtq)_
- [x] B7: Chốt phạm vi dữ liệu Host/Tenant: theo pattern danh mục NCC hiện tại là Host-level (`MultiTenancySides.Host`), nhưng bảng mới cần xác nhận để tránh lộ/chia sẻ sai dữ liệu giữa tenant. → **Chốt:** Host (hungtq)_

## Mục tiêu

- Tạo danh mục admin mới cho **Tỉnh thành mới** theo `expect.md`:
  - Xem danh sách theo quyền `Admin.DanhMuc.TinhThanh` hoặc key mới được chốt.
  - Tìm kiếm theo mã/tên.
  - Thêm mới bắt buộc mã/tên, normalize mã trim/bỏ khoảng trắng/uppercase, chặn trùng mã active/chưa xóa mềm.
  - Sửa cho phép đổi thông tin mô tả/ngày/hiệu lực nhưng giữ ổn định mã theo pattern danh mục hiện có.
  - Xóa mềm, không hiện trong danh sách active.
  - Xuất Excel theo filter hiện tại.
  - Tải file mẫu và nhập Excel, validate header/dữ liệu/trùng mã và báo lỗi rõ.
- Tạo phần **Xã phường** theo phạm vi được chốt ở B3:
  - Xã/phường map bắt buộc với tỉnh.
  - Dữ liệu xã/phường lấy từ nguồn chính thức, đủ để chạy demo đúng.
  - Nếu có màn CRUD/import/export, thao tác phải kiểm tra tỉnh tồn tại/đang hiệu lực và chặn dữ liệu mồ côi.
- Cập nhật Redis sau khi thêm/sửa/xóa/import dữ liệu:
  - Danh sách tỉnh: `VS_LIST_PROVINCE`.
  - Danh sách xã/phường theo tỉnh: `VS_LIST_WARD_[province_code]`.
  - Khi tỉnh hoặc xã/phường thay đổi, cache liên quan phải được refresh/invalidate để dữ liệu đọc ra nhất quán.

## Bối cảnh

- Quy trình docs yêu cầu Rule 01 chỉ lập kế hoạch, chưa code; không đổi status trong `expect.md`; không tự điền Gate 1 approval.
- `docs/project.md` quy định invoice-management là ASP.NET Zero / ABP backend + Angular admin; DB MySQL/MariaDB host/tenant; Redis dùng qua ABP RedisCache; **EF Migration không quản lý schema nghiệp vụ, không chạy `dotnet ef migrations add` cho bảng `vs_*`**.
- `docs/conventions/be-cloud.md` quy ước:
  - AppService đặt trong `src/hddt/HDDT.Application/AppServices/<Module>/`.
  - Entity đặt trong `src/hddt/HDDT.Core/Domains/<Nhóm>/`.
  - DTO đặt trong `src/hddt/HDDT.Application/DataTransferObjects/...`.
  - DbSet đăng ký trong `src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs`.
  - Permission khai báo trong `AppPermissions.cs` và `AppAuthorizationProvider.cs`.
  - Cache Redis dùng config keys `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId`; không ghi secret vào docs/code/log.
- `docs/conventions/fe-cloud.md` quy ước:
  - Màn hình Cloud đặt dưới `angular/src/app/hddt/...` hoặc `angular/src/app/admin/...` theo nhóm hiện có.
  - Route trong `hddt-routing.module.ts`, menu trong `app-navigation.service.ts`.
  - Angular service proxy sinh bằng NSwag; không sửa tay `service-proxies.ts` trừ khi regenerate; provider cần thêm trong `service-proxy.module.ts`.
  - Search input và nút search nên đặt gần nhau, tránh pattern `col-11/col-1` cũ.
- Source hiện có cho màn tương tự:
  - Backend `DM_NCC_TinhThanhAppService` có CRUD, search, import/export Excel, soft-delete và validate mã/tên/ngày/hiệu lực cho bảng cũ `vs_dm_ncc_tinhthanh`.
  - Entity `DM_NCC_TinhThanh` đang `[Table("vs_dm_ncc_tinhthanh")]`, `[MultiTenancySide(MultiTenancySides.Host)]`, kế thừa `FullAuditedEntity`.
  - Permission hiện có là ASCII key `Admin.DanhMuc.TinhThanh`, `Create`, `Edit`, `Delete`, `Import`; text AC trong expect ghi có dấu `Admin.DanhMuc.TỉnhThành`, cần map về key thật hoặc chốt key mới.
  - FE hiện có menu `/app/hddt/danhmuc/dmnhacungcap-tinhthanh`, route và component PrimeNG table cho danh mục tỉnh thành cũ.
  - Redis đã bật trong `VSWebCoreModule` qua `Configuration.Caching.UseRedis(...)` với config key name, không ghi giá trị.

## Nguyên nhân gốc (nếu là bug)

Không phải bug vận hành hiện hữu. Đây là yêu cầu mở rộng danh mục admin để quản lý bộ dữ liệu hành chính mới theo tài liệu đính kèm và đồng bộ Redis phục vụ đọc nhanh.

Đối chiếu code thật cho nguyên nhân cần làm mới thay vì sửa mù màn cũ:

- Màn tỉnh thành cũ đang phục vụ nhóm `DMNhaCungCap` và bảng `vs_dm_ncc_tinhthanh`, không trùng bảng `vs_danhmuc_tinh_thanh` trong `expect.md`.
- Mối quan hệ cũ là Tỉnh thành → Quận huyện (`DM_NCC_QuanHuyen`), trong khi yêu cầu mới là Tỉnh thành → Xã phường theo danh mục hành chính mới.
- `GetAllNoPage` của tỉnh thành cũ chưa có Redis key theo yêu cầu `VS_LIST_PROVINCE`; cần thiết kế cache/refresh rõ thay vì chỉ copy pattern cũ.

## Giả định · Câu hỏi mở · Ngoài phạm vi

- **Giả định:**
  - Nếu B2 chốt dùng bảng mới `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong`, sẽ tạo entity/DTO/AppService/screen mới, không đổi hành vi màn `DM_NCC_TinhThanh` cũ ngoài phần dùng chung nếu được yêu cầu rõ.
  - Nếu B7 chốt Host-level, entity mới dùng `MultiTenancySides.Host` tương tự danh mục NCC hiện có.
  - Mã tỉnh giữ format 02 chữ số, mã xã/phường giữ format 05 chữ số theo attachment, không normalize bỏ số 0 đầu.
  - Import Excel dùng EPPlus helper theo pattern `DMNhaCungCap_THNTExcelHelper`, nhưng tách helper/section mới để tránh trộn với danh mục NCC cũ.
- **Câu hỏi mở:**
  - Key quyền cho “Tỉnh thành mới” có dùng lại `Admin.DanhMuc.TinhThanh` không, hay tạo key mới để không ảnh hưởng màn cũ?
  - Xã/phường có quyền riêng `Admin.DanhMuc.XaPhuong` và các quyền `Create/Edit/Delete/Import` không?
  - Có cần API public/internal cho module khác đọc province/ward từ Redis hay chỉ màn admin dùng AppService hiện tại?
  - Dữ liệu chính thức có cần script seed trong repo hay thao tác import Excel thủ công trên demo?
- **Ngoài phạm vi:**
  - Không thay đổi danh mục quận huyện cũ nếu B2 không yêu cầu migrate.
  - Không tự sửa `expect.md`, không tự đổi `status`, không điền Gate 1 approval.
  - Không commit secret Redis/DB; chỉ ghi tên khóa cấu hình.
  - Không chạy EF migration cho bảng nghiệp vụ `vs_*`.

## Cách làm

1. Chốt blocking B1–B7 trước khi approve Gate 1.
2. Khảo sát schema thật của `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` và nguồn dữ liệu chính thức; lập mapping cột DTO/entity/import/export.
3. Thiết kế backend:
   - Entity mới cho tỉnh/thành và xã/phường nếu dùng bảng mới.
   - DTO/input/output cho list/edit/import/export/cache.
   - AppService tỉnh thành mới: list/search, create/edit/delete/import/export/file mẫu, cache refresh `VS_LIST_PROVINCE`.
   - AppService xã/phường: list/search theo tỉnh/mã/tên, validate tỉnh, create/edit/delete/import/export/file mẫu theo B3, cache refresh `VS_LIST_WARD_[province_code]`.
   - Service/helper cache để gom logic build key, serialize danh sách, invalidate/refresh sau mutate.
   - Permission/localization mới hoặc map quyền cũ theo B3/B4.
4. Thiết kế dữ liệu demo:
   - Extract 34 tỉnh và toàn bộ xã/phường từ nguồn chính thức.
   - Validate mã tỉnh 02 chữ số, mã xã/phường 05 chữ số, xã/phường map tới tỉnh tồn tại, duplicate, dòng malformed/OCR.
   - Tạo Excel import hoặc SQL seed theo chốt triển khai; có rollback nếu seed bằng SQL.
5. Thiết kế frontend:
   - Thêm menu/route cho “Tỉnh thành mới” và “Xã phường”.
   - Component PrimeNG table/modal/import theo pattern danh mục hiện có.
   - Xã/phường có filter tỉnh và validate chọn tỉnh trước khi tạo/sửa/import nếu full CRUD.
   - Regenerate NSwag proxy sau backend, thêm provider vào `service-proxy.module.ts`, khai báo component/modal trong `hddt.module.ts`.
6. Kiểm chứng backend build, NSwag, TypeScript, permission/menu/UI/manual DB/Redis.

## Thay đổi kỹ thuật

| Hạng mục | Có/Không | Chi tiết |
|---|---|---|
| Entity / migration | Có entity; migration: Không tự chạy EF migration | Dự kiến entity mới map `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong`; đăng ký DbSet trong `HDDTDbContext`. Nếu thiếu schema/cột, tạo SQL/deploy.md theo quy trình DBA/TechLead, không dùng `dotnet ef migrations add`. |
| DTO / AppService | Có | DTO/input/output cho province/ward; AppService CRUD/search/import/export/file mẫu; validate duplicate/required/effective/soft-delete/map ward-province; cache refresh Redis sau mutate/import. |
| Màn hình / route | Có | FE menu/route/component/modal/import cho “Tỉnh thành mới”; xã/phường theo B3; NSwag proxy regenerate và provider module. |
| Hàng đợi / tích hợp | Không hàng đợi; Có Redis | Không message queue. Redis keys theo `expect.md`: `VS_LIST_PROVINCE`, `VS_LIST_WARD_[province_code]`; dùng config key names hiện có, không ghi secret. |
| Cấu hình (tên khóa) | Có sử dụng cấu hình hiện có | `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId`; không thêm giá trị cấu hình vào docs. |

## Thứ tự thực hiện & phụ thuộc

1. **Gate 1:** trả lời B1–B7 và DEV/TechLead approve plan.
2. **DB/schema/data mapping:** xác nhận bảng/cột và nguồn dữ liệu; đây là phụ thuộc bắt buộc cho entity, import, Redis payload.
3. **Backend domain + DTO + mapper + DbContext:** cần trước AppService và NSwag.
4. **Permission/localization backend:** cần trước route/menu FE để button/menu guard đúng.
5. **AppService + cache helper + Excel helper:** cần trước regenerate proxy; cache refresh phải được đặt ở mọi mutate path.
6. **NSwag regenerate:** cần backend compile/run metadata ổn để sinh proxy đúng.
7. **Frontend menu/route/components/modal/import:** cần proxy mới và permission key đã chốt.
8. **Data import/seed demo + Redis validation:** cần backend/FE thao tác được hoặc có script seed được review.
9. **Verification + impact finalize:** chạy lệnh, manual check DB/Redis/UI, cập nhật report/deploy nếu sang rule sau.

## Kế hoạch kiểm chứng

> Phải có **lệnh cụ thể** và kết quả kỳ vọng. Không viết "chạy test".

| # | Lệnh / bước kiểm | Kết quả kỳ vọng |
|---|---|---|
| 1 | `bash docs/scripts/check-layout.sh` tại `D:\BILL` | PASS; không phát sinh lỗi layout docs. |
| 2 | `git -C "D:\BILL\docs" pull` | `Already up to date.` hoặc pull sạch không conflict. |
| 3 | `git -C "D:\BILL\invoicemanagement" status -sb` | Đang ở branch làm việc dự kiến `hungtq_dev_cloud...origin/develop_cloud`; không có file ngoài scope trước khi code. |
| 4 | `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` | Build backend thành công, không có compiler error từ entity/DTO/AppService/permission/cache. |
| 5 | `cmd /c "cd /d D:\BILL\invoicemanagement\angular\nswag && refresh.bat"` | NSwag sinh lại `service-proxies.ts` có proxy AppService mới, không lỗi HTTP/metadata. |
| 6 | `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` | TypeScript compile không lỗi provider/import/component/template binding. |
| 7 | Manual — đăng nhập admin có quyền danh mục | Thấy menu “Tỉnh thành mới”; nếu B3 chốt full CRUD xã/phường thì thấy menu “Xã phường”; user thiếu quyền không thấy menu/nút tương ứng. |
| 8 | Manual — CRUD tỉnh thành mới | Search mã/tên đúng; create bắt mã/tên và normalize mã; duplicate active bị chặn; edit không đổi mã; delete soft-delete và dòng không hiện trong danh sách active. |
| 9 | Manual — import/export tỉnh thành | Tải file mẫu đúng header; import file hợp lệ thành công và báo số dòng; file sai header/data/duplicate báo lỗi rõ; export theo filter hiện tại. |
| 10 | Manual — xã/phường theo B3 | Xã/phường bắt buộc map tỉnh; filter theo tỉnh hoạt động; không cho map tỉnh không tồn tại/ngưng hiệu lực; import/export/CRUD đúng nếu thuộc scope. |
| 11 | Manual DB — query bảng `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` | Dữ liệu thêm/sửa/xóa mềm đúng bảng/cột đã chốt; không ghi nhầm sang `vs_dm_ncc_tinhthanh`/quận huyện cũ nếu B2 chốt bảng mới. |
| 12 | Manual Redis — kiểm tra keys `VS_LIST_PROVINCE`, `VS_LIST_WARD_[province_code]` bằng redis-cli/tool nội bộ được phép | Sau create/edit/delete/import, key province và ward liên quan được tạo/cập nhật/xóa/refreshed đúng payload; không cần restart service. |
| 13 | Manual data — đối soát attachment/file nhóm | Có 34 tỉnh/thành; mã tỉnh 02 chữ số; mã xã/phường 05 chữ số; không còn dòng malformed/OCR chưa xử lý; tổng số xã/phường theo từng tỉnh khớp tài liệu. |

Case không test được ở local (xem `project.md` §7): DB demo/Redis demo và file nhóm chính thức cần người nghiệm thu DEV/BA/TechLead xác nhận trong môi trường được cấp quyền, vì local không chứa secret DB/Redis.

## Ma trận rủi ro

| Rủi ro | Ảnh hưởng | Giảm thiểu | Rollback |
|---|---|---|---|
| Nhầm bảng mới `vs_danhmuc_*` với bảng cũ `vs_dm_ncc_*` | Ghi sai dữ liệu, ảnh hưởng màn tỉnh/quận huyện cũ | Chốt B2, đặt tên entity/AppService/route rõ “Moi/XaPhuong”, manual query đúng bảng trước release | Revert code; nếu đã seed sai bảng thì chạy rollback SQL được review. |
| Key quyền dùng lại `Admin.DanhMuc.TinhThanh` làm lộ màn mới cho user đang có quyền màn cũ | Rủi ro phân quyền/lộ dữ liệu master giữa nhóm user | Chốt key quyền riêng hoặc mapping có chủ đích; test user có/không quyền | Revert permission/menu; thu hồi quyền role nếu cấp nhầm. |
| Dữ liệu attachment bị lỗi OCR/parse hoặc thiếu dòng | Demo/sản phẩm trả sai danh mục hành chính | Validate count, format, duplicate, mapping; đối soát với file nhóm chính thức; log dòng lỗi trước import/seed | Re-import từ file đã sửa; rollback seed theo mã. |
| Redis không refresh đủ keys sau update/import | UI/API đọc dữ liệu cũ, sai map tỉnh-xã | Gom cache refresh vào service dùng chung; test mutate từng path; refresh province và ward liên quan | Clear keys `VS_LIST_PROVINCE`, `VS_LIST_WARD_*`; rebuild từ DB. |
| Không giữ số 0 đầu mã tỉnh/xã | Sai key `VS_LIST_WARD_[province_code]`, sai dữ liệu pháp lý | Dùng string cho code; validate length 02/05; không parse sang int | Sửa dữ liệu/code và refresh Redis. |
| Xóa/sửa tỉnh khi còn xã/phường active | Dữ liệu xã/phường mồ côi | Chặn delete/inactive tỉnh nếu còn xã/phường active hoặc chốt rule cascade rõ | Khôi phục tỉnh hoặc remap xã/phường bằng SQL/script có review. |
| Host/Tenant scope sai | Lộ dữ liệu hoặc tenant không thấy dữ liệu chung | Chốt B7; dùng `MultiTenancySides.Host` nếu là master data chung; test tenant/host | Revert entity/query filter; sửa dữ liệu tenant/host theo script. |
| Build/NSwag trên Angular 6 legacy lỗi do pattern mới | Không build được FE | Copy pattern màn hiện có, không nâng dependency; chạy `refresh.bat` và `tsc --noEmit` | Revert FE changes hoặc tách commit backend/frontend. |

## Ghi chú triển khai

- Có chạm DB/data/cache nên khi sang bước triển khai cần có `deploy.md` nếu có SQL seed/schema/rollback hoặc thao tác Redis thủ công.
- Không ghi giá trị connection string/password/token vào docs/code/log.
- Không chạy `dotnet ef migrations add` cho bảng nghiệp vụ `vs_*`; nếu phát hiện schema thiếu, tạo SQL theo `docs/databases/README.md` và cần DBA/TechLead review.
- Nếu dữ liệu official được nhập bằng Excel qua UI thay vì SQL seed, vẫn cần checklist thao tác demo và cách rollback/clear Redis trong `deploy.md`/report.

## Đề xuất cập nhật docs (Gate 2)

- `specs/system.md`: bổ sung danh mục hành chính mới, format mã tỉnh/xã, quan hệ province-ward, Redis key contract nếu đây là contract dùng chung.
- `databases/README.md`: nếu phát sinh SQL seed/schema cho `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong`, ghi tên file theo convention host DB.
- `conventions/be-cloud.md`: nếu chốt pattern Redis exact-key ngoài ABP `ICacheManager`, bổ sung guideline để các danh mục sau dùng nhất quán.

## Phê duyệt (Gate 1) — chỉ người điền, AI không tự điền

- [x] DEV tự review: hungtq — 18/08/2026
- [x] TechLead approve: Vũ Văn Tiến — 18/08/2026 —  

> Khi block này đủ chữ ký, cập nhật `expect.md` → `status: approved` rồi mới chạy rule 02.
