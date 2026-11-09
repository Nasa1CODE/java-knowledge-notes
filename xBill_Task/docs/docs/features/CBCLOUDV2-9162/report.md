# Report — CBCLOUDV2-9162

> Theo [rules/02-implement-task.md](../../rules/02-implement-task.md). **Chỉ ghi kết quả THẬT.**
> Không chạy được thì ghi rõ cái gì không chạy và vì sao — tuyệt đối không báo "đã test" khi chưa test.

## 1. Đã làm gì

- Task 2: Tạo entity/DTO/input/mapper/DbSet cho danh mục tỉnh thành mới và xã/phường, map bảng `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong`; mã tỉnh/xã dùng `string` để giữ số 0 đầu.
- Task 3: Tạo `DanhMucHanhChinhCacheService` refresh Redis exact keys `VS_LIST_PROVINCE`, `VS_LIST_WARD_[province_code]` bằng StackExchange.Redis, không ghi secret vào code/docs.
- Task 4: Tạo `DanhMucTinhThanhAppService` có list/search/create/edit/delete/import/export/file mẫu và refresh Redis sau mutate/import.
- Task 5: Tạo `DanhMucXaPhuongAppService` có list/search/filter tỉnh/create/edit/delete/import/export/file mẫu, validate tỉnh tồn tại/active và refresh ward key.
- Task 6: Thêm permission riêng và localization tiếng Việt cho `TinhThanhMoi`, `XaPhuong`; permission provider đặt cùng pattern với các danh mục admin hiện có để menu hiển thị theo quyền được grant.
- Task 8: Tạo màn hình FE “Tỉnh thành mới”, modal create/edit/import, menu/route/module/provider/proxy.
- Task 9: Tạo màn hình FE “Xã phường”, filter tỉnh, modal create/edit/import, menu/route/module/provider/proxy.
- Task 10: Chạy verification tự động; cập nhật `tasks.md`, finalize `impact.md`, tạo `deploy.md` do có DB/Redis/runtime notes.

## 2. File đã thay đổi (thật)

| File | Thay đổi |
|---|---|
| `aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/HanhChinh/DanhMucTinhThanh.cs` | Entity tỉnh thành mới, Host-level, table `vs_danhmuc_tinh_thanh`. |
| `aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/HanhChinh/DanhMucXaPhuong.cs` | Entity xã/phường, Host-level, table `vs_danhmuc_xa_phuong`. |
| `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/HanhChinh/DanhMucTinhThanh/DanhMucTinhThanhDto.cs` | DTO tỉnh. |
| `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/HanhChinh/DanhMucTinhThanh/GetAllDanhMucTinhThanhInput.cs` | Input list tỉnh. |
| `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/HanhChinh/DanhMucXaPhuong/DanhMucXaPhuongDto.cs` | DTO xã/phường. |
| `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/HanhChinh/DanhMucXaPhuong/GetAllDanhMucXaPhuongInput.cs` | Input list xã/phường. |
| `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/HanhChinh/DanhMucHanhChinhCacheService.cs` | Redis exact-key refresh service. |
| `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/HanhChinh/DanhMucTinhThanhAppService.cs` | CRUD/import/export tỉnh và cache refresh. |
| `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/HanhChinh/DanhMucXaPhuongAppService.cs` | CRUD/import/export xã/phường và cache refresh. |
| `aspnet-core/src/hddt/HDDT.Application/Commons/DanhMuc/HanhChinh/DanhMucHanhChinhExcelHelper.cs` | Excel export/import/file mẫu, validation. |
| `aspnet-core/src/hddt/HDDT.Application/CustomDtoMapper.cs` | Mapping entity ↔ DTO mới. |
| `aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs` | DbSet cho 2 entity mới. |
| `aspnet-core/src/hddt/HDDT.Core/Authorization/AppPermissions.cs` | Permission constants mới. |
| `aspnet-core/src/hddt/HDDT.Core/Authorization/AppAuthorizationProvider.cs` | Permission tree dưới danh mục admin, cùng pattern permission với các danh mục hiện có để role/admin grant được quyền menu/action mới. |
| `aspnet-core/src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml` | Localization tiếng Việt cho màn/quyền mới. |
| `angular/src/app/shared/layout/nav/app-navigation.service.ts` | Menu “Tỉnh thành mới”, “Xã phường”. |
| `angular/src/app/hddt/hddt-routing.module.ts` | Route 2 màn mới. |
| `angular/src/app/hddt/hddt.module.ts` | Declare component/modal mới. |
| `angular/src/app/hddt/danhmuc/hanhchinh/tinhthanhmoi/*.ts`, `*.html` | FE list/modal/import tỉnh thành mới. |
| `angular/src/app/hddt/danhmuc/hanhchinh/xaphuong/*.ts`, `*.html` | FE list/filter/modal/import xã phường. |
| `angular/src/shared/service-proxies/service-proxies.ts` | NSwag generated proxy/DTO mới. |
| `angular/src/shared/service-proxies/service-proxy.module.ts` | Provider cho proxy mới. |
| `docs/features/CBCLOUDV2-9162/tasks.md` | Cập nhật status task theo Rule 02. |
| `docs/features/CBCLOUDV2-9162/impact.md` | Finalize impact theo file/code thật. |
| `docs/features/CBCLOUDV2-9162/deploy.md` | Deploy notes do có DB/Redis/runtime/manual checks. |
| `docs/features/CBCLOUDV2-9162/report.md` | Báo cáo Rule 02. |

## 3. Kết quả kiểm chứng

### Tự động

| # | Lệnh đã chạy | Kết quả |
|---|---|---|
| 1 | `git -C "D:\BILL\docs" pull` | PASS — `Already up to date.` |
| 2 | `bash docs/scripts/check-layout.sh` | PASS — output kết thúc `== PASS — có thể bắt đầu phiên làm việc. ==`; có WARN các service repo khác chưa clone và `invoice-management` do tên folder local là `invoicemanagement`. |
| 3 | `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` | PASS — `Build succeeded. 374 Warning(s), 0 Error(s).` |
| 4 | `cmd.exe /c "cd /d D:\BILL\invoicemanagement\angular\nswag && .\refresh.bat"` | PASS — NSwag output `Done. Duration: 00:00:25.2619511`. |
| 5 | `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` | PASS — command completed with no output. |
| 6 | `git -C "D:\BILL\invoicemanagement" status -sb` | PASS scope check — branch `hungtq_dev_cloud...origin/develop_cloud`, changed files nằm trong backend/frontend `invoice-management` đúng scope; đã xóa thư mục `.tmp-build`. |

### Thủ công

| Case | Người nghiệm thu | Ngày | Bằng chứng |
|---|---|---|---|
| Chưa chạy manual UI/DB/Redis | Chưa có | Chưa có | Chưa có ảnh/log/manual evidence trong phiên này. |

### Chưa chạy được

| Việc | Vì sao |
|---|---|
| Manual UI tỉnh thành mới/xã phường | Chưa có phiên chạy trình duyệt/QA với tài khoản quyền Host trong phiên này. |
| Manual DB query bảng `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` | Chưa chạy query trên DB đích; không ghi/lộ connection secret. |
| Manual Redis check `VS_LIST_PROVINCE`, `VS_LIST_WARD_[province_code]` | Chưa kiểm tra Redis thật trên môi trường đích; không ghi/lộ secret Redis. |
| Import/seed dữ liệu official | Task 7 vẫn pending vì cần đối soát file nhóm chính thức; attachment có rủi ro OCR/malformed. |
| Permission smoke test user có/không quyền | Cần môi trường UI và tài khoản/role phù hợp. |

## 4. Sai khác so với plan

| Điểm khác | Lý do |
|---|---|
| Thêm `deploy.md` dù không có migration | Có thay đổi đọc/ghi DB bảng có sẵn, Redis exact-key và checklist môi trường/manual import nên Rule 02 yêu cầu deploy notes khi có DB/config/runtime. |
| NSwag phải chạy qua backend tạm ở `127.0.0.1:5010` | Endpoint mặc định `localhost:22742` ban đầu trả 502/bind bị chặn; đã tạm đổi URL trong NSwag config để regenerate rồi trả lại URL mặc định. |
| Đổi model trả file export mới thành `TaiFileHanhChinh` | Tránh Swagger schema conflict với class `TaiFile` cũ trong module DMNhaCungCap. |
| Task 7 để pending | Chưa có dữ liệu chính thức đã đối soát; không tự seed/import từ attachment OCR. |

## 5. Việc còn lại / hạn chế đã biết

- Đối soát dữ liệu official 34 tỉnh và xã/phường từ file nhóm chính thức; xử lý các dòng OCR/malformed trước khi import/seed.
- Manual test UI/permission/DB/Redis trên môi trường dev/staging.
- Xác nhận schema thật của `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` trên DB đích khớp entity.
- Cấp quyền `Admin.DanhMuc.TinhThanhMoi*` và `Admin.DanhMuc.XaPhuong*` cho role/admin phù hợp sau deploy; cần logout/login hoặc refresh session để client nhận permission mới.
- Kiểm tra Redis exact keys sau CRUD/import thật.

## 6. Đề xuất cập nhật docs (Gate 2)

- `docs/specs/danh-muc-hanh-chinh.md` hoặc spec tương đương: bổ sung behavior danh mục tỉnh thành mới/xã phường, mã tỉnh 02 ký tự, mã xã 05 ký tự, exact Redis keys.
- `docs/databases/README.md`: ghi chú 2 bảng master data `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` nếu docs DB hiện chưa có.
- `docs/architecture.md`: không cần cập nhật nếu kiến trúc Redis/AppService danh mục đã được mô tả chung; chỉ đề xuất nếu TechLead muốn ghi exact-key convention.

## 7. Link commit / PR

| Service | Commit / PR |
|---|---|
| invoice-management | Chưa commit/PR trong phiên này. |
| docs | Chưa commit/PR trong phiên này. |
