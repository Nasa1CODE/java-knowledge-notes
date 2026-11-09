---
feature: CBCLOUDV2-9038
status: completed
owner: AI
updated_at: 2026-09-24
service: invoice-management
---

# Report — CBCLOUDV2-9038

## 1. Tóm tắt

Đã implement Rule 02 cho **Danh mục lý do điều chỉnh/thay thế** trên service canonical `invoice-management`, checkout code thực tế `D:\BILL\invoicemanagement`.

Phạm vi đã làm:

- Backend ASP.NET Zero/ABP: entity, DTO/input, DbSet, AutoMapper, permission/localization, AppService CRUD/search/export/import/cache.
- Frontend Angular admin: route/menu/module/provider, màn danh sách, modal thêm/sửa, modal import/template/export/delete.
- NSwag: regenerate `service-proxies.ts` từ Swagger BE local.
- Deploy docs: SQL create/rollback/cache/smoke test trong `deploy.md`; không dùng EF migration.
- Impact docs: finalized `impact.md` theo blast radius thực tế.

Chưa commit/push/merge/deploy theo đúng rule dự án.

## 2. File thay đổi thật

### Docs repo `D:\BILL\.docs-worktrees\docs__xbill-futa`

| File | Trạng thái | Nội dung |
|---|---|---|
| `features/CBCLOUDV2-9038/expect.md` | untracked từ feature folder | Input feature/acceptance source hiện có. |
| `features/CBCLOUDV2-9038/plan.md` | untracked từ feature folder | Plan đã được dùng cho Rule 02. |
| `features/CBCLOUDV2-9038/tasks.md` | modified/untracked từ feature folder | Cập nhật task status trong quá trình implement. |
| `features/CBCLOUDV2-9038/deploy.md` | untracked từ feature folder | SQL create/rollback, cache, deploy order, smoke test, seed blocker. |
| `features/CBCLOUDV2-9038/impact.md` | modified/untracked từ feature folder | Finalized impact sau code. |
| `features/CBCLOUDV2-9038/report.md` | new | Báo cáo Rule 02 này. |
| `features/CBCLOUDV2-9038/image.png` | untracked từ feature folder | Ảnh nguồn tham chiếu seed trong feature folder. |

### Code repo `D:\BILL\invoicemanagement`

#### Backend

| File | Trạng thái | Nội dung |
|---|---|---|
| `aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_LyDoDieuChinhThayThe.cs` | new | Entity `DM_NCC_LyDoDieuChinhThayThe`, map bảng `vs_dm_ncc_lydo_dieuchinhthaythe`, host-side, audit/soft-delete. |
| `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLyDoDieuChinhThayThe/DMNCCLyDoDieuChinhThayTheDto.cs` | new | DTO field mã, tên lý do, ghi chú, ngày bắt đầu/kết thúc, hiệu lực. |
| `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLyDoDieuChinhThayThe/GetAllDSLyDoDieuChinhThayTheInput.cs` | new | Input paging/sorting/filter cho danh sách. |
| `aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs` | modified | Thêm `DbSet<DM_NCC_LyDoDieuChinhThayThe>`. |
| `aspnet-core/src/hddt/HDDT.Application/CustomDtoMapper.cs` | modified | Thêm map entity ↔ DTO. |
| `aspnet-core/src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml` | modified | Thêm label tiếng Việt cho menu/message/màn hình. |
| `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/DMNhaCungCap/DM_NCC_LyDoDieuChinhThayTheAppService.cs` | new | CRUD/search/export/import/template/cache, validation, permission, logging an toàn. |
| `aspnet-core/src/hddt/HDDT.Application/Commons/DanhMuc/DMNhaCungCap/DMNhaCungCap_THNTExcelHelper.cs` | modified | Thêm export/import/template/validate riêng cho lý do điều chỉnh/thay thế. |

#### Frontend

| File | Trạng thái | Nội dung |
|---|---|---|
| `angular/src/shared/service-proxies/service-proxies.ts` | modified/generated | Regenerate NSwag; thêm `DM_NCC_LyDoDieuChinhThayTheServiceProxy`, DTO và API methods. |
| `angular/src/shared/service-proxies/service-proxy.module.ts` | modified | Đăng ký provider proxy mới. |
| `angular/src/app/hddt/hddt-routing.module.ts` | modified | Thêm route `/app/hddt/danhmuc/dmnhacungcap-lydodctt`. |
| `angular/src/app/hddt/hddt.module.ts` | modified | Declare các component/modal mới. |
| `angular/src/app/shared/layout/nav/app-navigation.service.ts` | modified | Thêm menu item `LyDoDieuChinhThayThe` dùng chung permission `Admin.DanhMuc.QuocTich` để hiển thị giống danh mục quốc tịch. |
| `angular/src/app/hddt/danhmuc/dmnhacungcap/lydodctt/dmnhacungcap-lydodctt.component.ts` | new | Component list/search/sort/page/export/import/create/edit/delete. |
| `angular/src/app/hddt/danhmuc/dmnhacungcap/lydodctt/dmnhacungcap-lydodctt.component.html` | new | Template danh sách, filter, table, paginator, buttons theo permission. |
| `angular/src/app/hddt/danhmuc/dmnhacungcap/lydodctt/thongtin-dmncclydodctt-modal.component.ts` | new | Modal thêm/sửa, default hiệu lực, edit không đổi mã. |
| `angular/src/app/hddt/danhmuc/dmnhacungcap/lydodctt/thongtin-dmncclydodctt-modal.component.html` | new | Form mã/tên/ghi chú/ngày/hiệu lực, required/maxlength cơ bản. |
| `angular/src/app/hddt/danhmuc/dmnhacungcap/lydodctt/nhap-file-dmncclydodctt-modal.component.ts` | new | Modal import Excel và tải file mẫu. |
| `angular/src/app/hddt/danhmuc/dmnhacungcap/lydodctt/nhap-file-dmncclydodctt-modal.component.html` | new | Template import file `.xlsx`. |

> Build output `aspnet-core/.tmp-build` từng xuất hiện trong working tree sau verification và đã được restore khỏi diff nguồn; không đưa vào commit.

## 3. Verification thật

| Check | Kết quả | Output / ghi chú |
|---|---|---|
| Backend build | PASS | `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln" -clp:ErrorsOnly -p:OutDir="D:\BILL\invoicemanagement\aspnet-core\.tmp-build\"` → `Build succeeded. 375 Warning(s), 0 Error(s). Time Elapsed 00:00:11.34`. |
| Swagger AppService | PASS | BE host local chạy với `ASPNETCORE_ENVIRONMENT=Development`, `ASPNETCORE_URLS=http://localhost:22742`; `swagger/v1/swagger.json` có `DM_NCC_LyDoDieuChinhThayThe`. |
| NSwag regenerate | PASS | Chạy `D:\BILL\invoicemanagement\angular\nswag\refresh.bat`; `service-proxies.ts` có proxy/DTO/methods cho danh mục mới. |
| Frontend TypeScript check | PASS | `D:\BILL\invoicemanagement\angular\node_modules\.bin\tsc.cmd -p "D:\BILL\invoicemanagement\angular\src\tsconfig.json" --noEmit` → exit code 0, không có output lỗi. |
| SQL create/rollback trên MariaDB Cloud | NOT RUN | AI không tự chạy DB deploy; SQL trong `deploy.md` cần DBA/TechLead review và chạy trên môi trường đích. |
| Seed dữ liệu tham chiếu | NOT RUN / BLOCKED | Chưa có danh sách mã/tên lý do đã transcribe và review từ ảnh nguồn; không invent dữ liệu seed. |
| Manual CRUD/search/export/import/template/delete | NOT RUN | Chưa có môi trường runtime/DB Cloud được cấp để thao tác end-to-end; đã ghi smoke test trong `deploy.md`. |
| Manual permission/menu/API role | PASS (code-level) / MANUAL PENDING | Đã đổi menu/nút/API sang dùng chung `Admin.DanhMuc.QuocTich.*`; user đang thấy danh mục Quốc tịch sẽ thấy/thao tác được danh mục lý do điều chỉnh/thay thế sau khi deploy/reload. Manual E2E vẫn cần kiểm tra trên môi trường runtime. |
| Manual Redis cache refresh | NOT RUN | Cần môi trường runtime + Redis; code đã clear cache sau create/update/delete/import. |

## 4. Ghi chú bảo mật / vận hành

- Không copy secret, token, password, connection string hoặc giá trị runtime config vào tài liệu/report.
- Import Excel backend không log raw Excel/base64/file content; log chỉ dùng tên file đã truncate/trạng thái có dữ liệu và exception message.
- Export Excel danh mục không chứa audit/user identity/secret/config/token.
- Không đổi message queue/Kafka/RabbitMQ, HSM/CQT/XML/PDF/public lookup.
- Không dùng EF migration cho bảng nghiệp vụ `vs_*`.
- Không sửa code ngoài service canonical `invoice-management`.
- Không commit/push/merge/deploy.

## 5. Deploy / seed

`deploy.md` đã có:

- Thứ tự deploy đề xuất.
- SQL tạo bảng `vs_dm_ncc_lydo_dieuchinhthaythe` không dùng generated column do MariaDB môi trường hiện tại báo lỗi `1064` với cú pháp `GENERATED ALWAYS AS ... VIRTUAL`.
- DB đặt index thường theo `LyDo_Ma`, `IsDeleted`; AppService validate không trùng mã active/not-deleted khi tạo/import. Nếu cần unique DB-level, DBA/TechLead cần review phương án riêng tương thích MariaDB đích.
- Rollback DB toàn feature và rollback dữ liệu seed.
- Cache name/key và cách clear cache vận hành.
- Smoke test sau deploy.
- Không cần SQL grant permission mới; danh mục dùng chung `Admin.DanhMuc.QuocTich.*`.

Seed cụ thể chưa được ghi vì Rule 02 chưa có dữ liệu seed đã transcribe/review từ nguồn ảnh. Cần BA/TechLead xác nhận danh sách mã/tên trước khi bổ sung SQL seed hoặc import Excel.

## 6. Gate 2 docs diff

Không sửa trực tiếp `docs/specs/`, `docs/architecture.md`, `docs/databases/` hoặc `docs/design.md` trong lần implement này.

Đề xuất nếu TechLead yêu cầu docs nền:

- `docs/databases/`: thêm mô tả/table file cho `vs_dm_ncc_lydo_dieuchinhthaythe` sau khi SQL được DBA review.
- `docs/specs/system.md`: bổ sung danh mục lý do điều chỉnh/thay thế vào phần danh mục admin nếu cần chuẩn hóa spec chung.
- `docs/architecture.md`: không bắt buộc vì không thêm service/integration/queue/config mới.
- `docs/design.md`: không bắt buộc vì UI bám pattern danh mục hiện hữu, không thêm design pattern mới.

Các cập nhật docs nền trên cần Gate 2 review/MR riêng trước khi merge.

## 7. Trạng thái bàn giao

- Task 1–5: completed.
- Task 6: completed về mặt docs/report/impact/deploy proposal.
- Chưa deploy DB/app; chưa seed dữ liệu thật; chưa chạy manual E2E do thiếu môi trường/runtime/seed review.
- Working tree code còn thay đổi source trong scope ticket; build output `.tmp-build` đã restore khỏi diff.
