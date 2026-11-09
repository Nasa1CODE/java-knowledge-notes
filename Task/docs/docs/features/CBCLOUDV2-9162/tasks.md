# Tasks — CBCLOUDV2-9162

> Sinh theo [rules/01-create-plan.md](../../rules/01-create-plan.md). Cập nhật status và link commit/PR trong lúc làm.
> **Service** phải là `service-key` đúng theo Service registry ([../../AGENTS.md](../../AGENTS.md)).

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Chốt contract DB / quyền / Redis / dữ liệu | invoice-management | completed | S | |
| 2 | Tạo backend model cho bảng danh mục mới | invoice-management | completed | M | |
| 3 | Tạo service Redis cache danh mục hành chính | invoice-management | completed | M | |
| 4 | Tạo AppService Tỉnh thành mới | invoice-management | completed | M | |
| 5 | Tạo AppService Xã phường | invoice-management | completed | M | |
| 6 | Khai báo permission và localization | invoice-management | completed | S | |
| 7 | Chuẩn bị dữ liệu chính thức cho demo | invoice-management | pending | M | |
| 8 | Tạo màn hình FE Tỉnh thành mới | invoice-management | completed | M | |
| 9 | Tạo màn hình FE Xã phường | invoice-management | completed | M | |
| 10 | Kiểm chứng, deploy notes và self-review Gate 1/2 | invoice-management | in_progress | S | |

---

## Task 1 — Chốt contract DB / quyền / Redis / dữ liệu

- **Status:** completed
- **Service:** `invoice-management`
- **Mô tả:** Chốt các blocking questions trong `plan.md` trước khi bắt đầu code: ticket ID, bảng/cột thực tế, quyền, Redis exact-key, nguồn dữ liệu, Host/Tenant scope.
- **Tiêu chí chấp nhận:**
  - [x] B1–B7 trong `plan.md` có câu trả lời rõ và người/ngày chốt.
  - [x] Xác định chính thức feature dùng bảng mới `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` hay tái sử dụng bảng cũ.
  - [x] Có mapping cột DB ↔ entity/DTO/import/export cho tỉnh và xã/phường.
  - [x] Có quyết định quyền: dùng lại `Admin.DanhMuc.TinhThanh` hay tạo key riêng cho “Tỉnh thành mới” và “Xã phường”.
  - [x] Có quyết định Redis: cách ghi key vật lý `VS_LIST_PROVINCE`, `VS_LIST_WARD_[province_code]`.
- **Kiểm chứng:**
  - [x] `git -C "D:\BILL\invoicemanagement" status -sb` → kỳ vọng: repo đúng branch `hungtq_dev_cloud...origin/develop_cloud`, chưa có code ngoài scope.
  - [x] Manual review `docs/features/CBCLOUDV2-9162/plan.md` → kỳ vọng: các blocking questions đã được người có thẩm quyền điền trước Gate 1 approval.
- **Phụ thuộc:** Không.
- **File dự kiến chạm:**
  - `docs/features/CBCLOUDV2-9162/plan.md`
  - `docs/features/CBCLOUDV2-9162/tasks.md`
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

---

## Task 2 — Tạo backend model cho bảng danh mục mới

- **Status:** completed
- **Service:** `invoice-management`
- **Mô tả:** Tạo entity/DTO/input/output/mapper/DbSet cho tỉnh thành mới và xã/phường theo schema đã chốt, không dùng EF migration cho bảng `vs_*`.
- **Tiêu chí chấp nhận:**
  - [x] Entity tỉnh map đúng bảng/cột đã chốt, dự kiến `vs_danhmuc_tinh_thanh` nếu B2 chọn bảng mới.
  - [x] Entity xã/phường map đúng bảng/cột đã chốt, dự kiến `vs_danhmuc_xa_phuong` nếu B2 chọn bảng mới.
  - [x] Mã tỉnh và mã xã/phường dùng `string`, giữ được số 0 đầu; validate length theo dữ liệu official nếu được chốt.
  - [x] Xã/phường có trường map tỉnh bắt buộc và query được theo mã tỉnh.
  - [x] DTO kế thừa đúng base DTO có audit/soft-delete theo pattern hiện có.
  - [x] `CustomDtoMapper` có map entity ↔ DTO.
  - [x] `HDDTDbContext` có DbSet mới nếu cần repository ABP.
  - [x] Không tạo/chạy `dotnet ef migrations add` cho các bảng nghiệp vụ `vs_*`.
- **Kiểm chứng:**
  - [x] `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` → kỳ vọng: build không lỗi entity/DTO/mapper/DbContext.
  - [x] Manual code review → kỳ vọng: không có migration EF mới cho `vs_*`; table name không trỏ nhầm sang `vs_dm_ncc_tinhthanh`/quận huyện cũ nếu B2 chọn bảng mới.
- **Phụ thuộc:** Task 1.
- **File dự kiến chạm:**
  - `aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/.../<ProvinceEntity>.cs`
  - `aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/.../<WardEntity>.cs`
  - `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/.../<ProvinceDto>.cs`
  - `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/.../<WardDto>.cs`
  - `aspnet-core/src/hddt/HDDT.Application/CustomDtoMapper.cs`
  - `aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 3 — Tạo service Redis cache danh mục hành chính

- **Status:** completed
- **Service:** `invoice-management`
- **Mô tả:** Tạo logic cache dùng chung để build/refresh/invalidate Redis keys cho danh sách tỉnh và xã/phường theo tỉnh.
- **Tiêu chí chấp nhận:**
  - [x] Có hằng số hoặc helper cho key `VS_LIST_PROVINCE` và `VS_LIST_WARD_[province_code]`, tránh hard-code lặp lại ở nhiều AppService.
  - [x] Refresh province list lấy dữ liệu active/chưa xóa mềm theo thứ tự đã chốt.
  - [x] Refresh ward list theo từng province_code lấy xã/phường active/chưa xóa mềm đúng tỉnh.
  - [x] Create/update/delete/import tỉnh gọi refresh/invalidate `VS_LIST_PROVINCE` và các ward keys bị ảnh hưởng nếu mã/tình trạng tỉnh ảnh hưởng dữ liệu con.
  - [x] Create/update/delete/import xã/phường gọi refresh/invalidate `VS_LIST_WARD_[province_code]` của tỉnh liên quan.
  - [x] Không ghi giá trị `Abp:RedisCache:ConnectionString` hoặc secret Redis vào code/docs/log.
- **Kiểm chứng:**
  - [x] `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` → kỳ vọng: build không lỗi cache service/dependency injection.
  - [ ] Manual Redis check sau thao tác CRUD/import → kỳ vọng: `VS_LIST_PROVINCE` và `VS_LIST_WARD_[province_code]` được tạo/cập nhật đúng, không cần restart service.
- **Phụ thuộc:** Task 1, Task 2.
- **File dự kiến chạm:**
  - `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/.../<AdministrativeUnitCacheService>.cs`
  - `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/.../<ProvinceAppService>.cs`
  - `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/.../<WardAppService>.cs`
  - `aspnet-core/src/zero/VS.Web.Core/VSWebCoreModule.cs` (chỉ nếu cần xác nhận module/cache config, không ghi secret)
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 4 — Tạo AppService Tỉnh thành mới

- **Status:** completed
- **Service:** `invoice-management`
- **Mô tả:** Tạo AppService cho “Tỉnh thành mới” với list/search/create/edit/delete/import/export/file mẫu theo AC trong `expect.md`.
- **Tiêu chí chấp nhận:**
  - [x] List phân trang/sort/filter theo mã hoặc tên tỉnh thành.
  - [x] Xem/edit lấy đúng bản ghi chưa xóa mềm.
  - [x] Create bắt buộc mã/tên, normalize mã trim/bỏ khoảng trắng/uppercase nhưng vẫn giữ số 0 đầu.
  - [x] Create chặn trùng mã active/chưa xóa mềm.
  - [x] Update cho sửa tên/tên tắt/ngày/hiệu lực theo schema chốt; giữ ổn định mã theo pattern danh mục hiện có.
  - [x] Delete là soft-delete; dòng deleted không hiện ở danh sách active.
  - [x] Nếu tỉnh còn xã/phường active, delete/inactive xử lý theo rule đã chốt (chặn hoặc cascade có kiểm soát).
  - [x] Export Excel theo filter hiện tại.
  - [x] File mẫu và import Excel validate header, mã/tên/ngày/hiệu lực/duplicate; lỗi báo rõ dòng/cột.
  - [x] Sau create/update/delete/import refresh Redis `VS_LIST_PROVINCE`.
- **Kiểm chứng:**
  - [x] `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` → kỳ vọng: build backend thành công.
  - [ ] Manual API/UI CRUD tỉnh → kỳ vọng: đúng validate, soft-delete, export/import và Redis refresh.
- **Phụ thuộc:** Task 2, Task 3, Task 6.
- **File dự kiến chạm:**
  - `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/.../<ProvinceAppService>.cs`
  - `aspnet-core/src/hddt/HDDT.Application/Commons/DanhMuc/.../<ProvinceExcelHelper>.cs`
  - `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/.../<Province*>.cs`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 5 — Tạo AppService Xã phường

- **Status:** completed
- **Service:** `invoice-management`
- **Mô tả:** Tạo AppService xã/phường theo phạm vi chốt ở B3, tối thiểu đảm bảo xã/phường map tỉnh và cache theo tỉnh; nếu full CRUD thì có đủ search/create/edit/delete/import/export/file mẫu.
- **Tiêu chí chấp nhận:**
  - [x] List xã/phường filter được theo tỉnh, mã, tên.
  - [x] Create/update/import bắt buộc `province_code`/mã tỉnh và chặn map tới tỉnh không tồn tại/không hiệu lực nếu rule chốt như vậy.
  - [x] Mã xã/phường dùng string, giữ số 0 đầu, validate duplicate active/chưa xóa mềm.
  - [x] Không tạo xã/phường mồ côi; khi tỉnh bị delete/inactive, behavior theo rule đã chốt.
  - [x] Nếu B3 chốt full CRUD: có create/edit/delete/import/export/file mẫu và permission button tương ứng.
  - [x] Sau create/update/delete/import refresh Redis `VS_LIST_WARD_[province_code]`; nếu chuyển tỉnh thì refresh cả tỉnh cũ và mới.
- **Kiểm chứng:**
  - [x] `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` → kỳ vọng: build backend thành công.
  - [ ] Manual API/UI xã-phường → kỳ vọng: filter theo tỉnh đúng; validate mã/tên/tỉnh/duplicate đúng; Redis ward key được refresh.
- **Phụ thuộc:** Task 2, Task 3, Task 4, Task 6.
- **File dự kiến chạm:**
  - `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/.../<WardAppService>.cs`
  - `aspnet-core/src/hddt/HDDT.Application/Commons/DanhMuc/.../<WardExcelHelper>.cs`
  - `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/.../<Ward*>.cs`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 6 — Khai báo permission và localization

- **Status:** completed
- **Service:** `invoice-management`
- **Mô tả:** Thêm permission tree và text localization cho màn tỉnh thành mới/xã phường theo key đã chốt.
- **Tiêu chí chấp nhận:**
  - [x] Permission cha và các permission con view/create/edit/delete/import được khai báo ở backend theo B1/B3.
  - [x] `AppAuthorizationProvider` tạo permission dưới đúng nhóm menu admin/danh mục.
  - [x] Localization tiếng Việt có label menu, tiêu đề, nút, modal, thông báo validate cơ bản.
  - [x] FE dùng đúng key permission thật, không dùng key có dấu nếu codebase chỉ dùng ASCII.
  - [x] Không làm thay đổi ngoài ý muốn quyền của màn tỉnh thành/quận huyện cũ.
- **Kiểm chứng:**
  - [x] `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` → kỳ vọng: build không lỗi permission/localization constants.
  - [ ] Manual login user có/không quyền → kỳ vọng: menu/nút hiển thị đúng theo quyền.
- **Phụ thuộc:** Task 1.
- **File dự kiến chạm:**
  - `aspnet-core/src/hddt/HDDT.Core/Authorization/AppPermissions.cs`
  - `aspnet-core/src/hddt/HDDT.Core/Authorization/AppAuthorizationProvider.cs`
  - `aspnet-core/src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml`
  - `angular/src/app/shared/layout/nav/app-navigation.service.ts`
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

---

## Task 7 — Chuẩn bị dữ liệu chính thức cho demo

- **Status:** pending
- **Service:** `invoice-management`
- **Mô tả:** Tách dữ liệu tỉnh/xã-phường từ attachment/file nhóm thành dữ liệu import/seed được validate và có thể chạy trên demo.
- **Tiêu chí chấp nhận:**
  - [ ] Có 34 tỉnh/thành theo Appendix I của tài liệu.
  - [ ] Mã tỉnh đúng format 02 chữ số và không duplicate.
  - [ ] Xã/phường map tới tỉnh tồn tại, mã xã/phường đúng format 05 chữ số và không duplicate theo rule đã chốt.
  - [ ] Tổng số xã/phường theo từng tỉnh khớp tài liệu hoặc có biên bản/chú thích dòng lệch.
  - [ ] Các dòng malformed/OCR như mã dạng `071.47` được xác minh/sửa theo nguồn chính thức trước khi import/seed.
  - [ ] Nếu seed bằng SQL, có file rollback và hướng dẫn deploy; nếu import bằng Excel, có file mẫu/dữ liệu import và checklist thao tác demo.
  - [ ] Sau import/seed, Redis được refresh cho province và ward keys.
- **Kiểm chứng:**
  - [ ] Manual đối soát dữ liệu với `docs/features/CBCLOUDV2-9162/attachment.md` và file nhóm chính thức → kỳ vọng: count/format/mapping khớp, không còn dòng lỗi chưa xử lý.
  - [ ] Manual DB query `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` → kỳ vọng: dữ liệu demo tồn tại đúng bảng, không duplicate active.
  - [ ] Manual Redis check `VS_LIST_PROVINCE`, `VS_LIST_WARD_[province_code]` → kỳ vọng: payload phản ánh đúng dữ liệu sau import/seed.
- **Phụ thuộc:** Task 1, Task 2, Task 3, Task 4, Task 5.
- **File dự kiến chạm:**
  - `docs/features/CBCLOUDV2-9162/deploy.md` (nếu có seed SQL/Redis thao tác thủ công)
  - `docs/features/CBCLOUDV2-9162/data/...` hoặc vị trí dữ liệu được TechLead chốt
  - `aspnet-core/...` file mẫu/import helper nếu file mẫu sinh từ code
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 8 — Tạo màn hình FE Tỉnh thành mới

- **Status:** completed
- **Service:** `invoice-management`
- **Mô tả:** Tạo route/menu/component/modal/import cho “Tỉnh thành mới” theo pattern Angular/PrimeNG hiện có, dùng proxy NSwag mới.
- **Tiêu chí chấp nhận:**
  - [x] Có menu “Tỉnh thành mới” dưới nhóm danh mục/admin theo quyền đã chốt.
  - [x] Có route riêng, không đè route màn tỉnh thành cũ nếu B2 chốt tạo màn mới.
  - [x] Table hiển thị mã/tên/tên tắt/ngày/hiệu lực theo schema chốt.
  - [x] Search input và nút search đặt gần nhau, tránh pattern `col-11/col-1` cũ.
  - [x] Buttons create/edit/delete/import/export hiển thị đúng permission.
  - [x] Modal create/edit validate required mã/tên và hiển thị lỗi từ backend.
  - [x] Import modal gọi tải file mẫu/import đúng AppService mới.
  - [x] `service-proxies.ts` được regenerate bằng NSwag; proxy mới có provider trong `service-proxy.module.ts`.
- **Kiểm chứng:**
  - [x] `cmd /c "cd /d D:\BILL\invoicemanagement\angular\nswag && refresh.bat"` → kỳ vọng: proxy mới sinh không lỗi.
  - [x] `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` → kỳ vọng: TypeScript không lỗi.
  - [ ] Manual UI tỉnh thành mới → kỳ vọng: list/search/CRUD/import/export hoạt động và quyền guard đúng.
- **Phụ thuộc:** Task 4, Task 6.
- **File dự kiến chạm:**
  - `angular/src/app/shared/layout/nav/app-navigation.service.ts`
  - `angular/src/app/hddt/hddt-routing.module.ts`
  - `angular/src/app/hddt/hddt.module.ts`
  - `angular/src/app/hddt/danhmuc/.../<province-new>/*.ts`
  - `angular/src/app/hddt/danhmuc/.../<province-new>/*.html`
  - `angular/src/shared/service-proxies/service-proxies.ts`
  - `angular/src/shared/service-proxies/service-proxy.module.ts`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 9 — Tạo màn hình FE Xã phường

- **Status:** completed
- **Service:** `invoice-management`
- **Mô tả:** Tạo màn hình xã/phường theo scope B3; nếu full CRUD, có route/menu/table/modal/import/export và filter tỉnh.
- **Tiêu chí chấp nhận:**
  - [x] Có route/menu xã/phường nếu B3 chốt có màn hình admin.
  - [x] Danh sách filter được theo tỉnh, mã, tên; tỉnh là combo/dropdown lấy từ danh mục tỉnh mới.
  - [x] Create/edit bắt buộc chọn tỉnh và nhập mã/tên; hiển thị lỗi backend khi tỉnh không hợp lệ hoặc duplicate.
  - [x] Buttons create/edit/delete/import/export hiển thị đúng permission xã/phường nếu có quyền riêng.
  - [x] Import xã/phường validate mã tỉnh/mã xã và báo lỗi rõ dòng/cột.
  - [x] UI không phụ thuộc danh mục quận huyện cũ nếu B2 chọn bảng mới.
- **Kiểm chứng:**
  - [x] `cmd /c "cd /d D:\BILL\invoicemanagement\angular\nswag && refresh.bat"` → kỳ vọng: proxy xã/phường sinh không lỗi.
  - [x] `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` → kỳ vọng: TypeScript không lỗi.
  - [ ] Manual UI xã/phường → kỳ vọng: filter tỉnh, CRUD/import/export theo B3 hoạt động; Redis ward key refresh sau mutate.
- **Phụ thuộc:** Task 5, Task 6, Task 8.
- **File dự kiến chạm:**
  - `angular/src/app/shared/layout/nav/app-navigation.service.ts`
  - `angular/src/app/hddt/hddt-routing.module.ts`
  - `angular/src/app/hddt/hddt.module.ts`
  - `angular/src/app/hddt/danhmuc/.../<ward>/*.ts`
  - `angular/src/app/hddt/danhmuc/.../<ward>/*.html`
  - `angular/src/shared/service-proxies/service-proxies.ts`
  - `angular/src/shared/service-proxies/service-proxy.module.ts`
- **Ước lượng:** M
- **Commit/PR:** <điền khi xong>

---

## Task 10 — Kiểm chứng, deploy notes và self-review Gate 1/2

- **Status:** in_progress
- **Service:** `invoice-management`
- **Mô tả:** Chạy verification, ghi kết quả, cập nhật deploy/impact/report ở rule phù hợp sau khi code; bảo đảm checklist Gate không bị AI tự ký.
- **Tiêu chí chấp nhận:**
  - [x] Layout docs PASS.
  - [x] Backend build PASS hoặc ghi rõ lỗi/blocker.
  - [x] NSwag refresh PASS nếu backend thay đổi AppService.
  - [x] TypeScript `tsc --noEmit` PASS.
  - [ ] Manual UI/DB/Redis/data checks có bằng chứng/kết quả.
  - [x] Nếu có SQL seed/schema/Redis thao tác thủ công, `deploy.md` có forward/rollback/checklist.
  - [x] `impact.md` được finalize theo ảnh hưởng thật sau code.
  - [x] Gate 1 approval block vẫn để người điền, AI không tự tick/approve.
- **Kiểm chứng:**
  - [x] `bash docs/scripts/check-layout.sh` → kỳ vọng: PASS.
  - [x] `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` → kỳ vọng: PASS.
  - [x] `cmd /c "cd /d D:\BILL\invoicemanagement\angular\nswag && refresh.bat"` → kỳ vọng: PASS, proxy updated.
  - [x] `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` → kỳ vọng: PASS.
  - [ ] Manual smoke test → kỳ vọng: tỉnh thành mới và xã/phường theo scope hoạt động, Redis keys đúng.
- **Phụ thuộc:** Task 1–9.
- **File dự kiến chạm:**
  - `docs/features/CBCLOUDV2-9162/impact.md`
  - `docs/features/CBCLOUDV2-9162/deploy.md` (nếu cần)
  - `docs/features/CBCLOUDV2-9162/report.md` (ở rule sau)
- **Ước lượng:** S
- **Commit/PR:** <điền khi xong>

---

> **Tách task** nếu: chạm hơn 8 file · đụng nhiều hệ thống con độc lập · tiêu chí chấp nhận mơ hồ · tiêu đề nối hai việc bằng chữ "và".
> Task `cancelled` phải ghi lý do.
