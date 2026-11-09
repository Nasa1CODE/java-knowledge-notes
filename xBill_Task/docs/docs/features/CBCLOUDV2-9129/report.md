# Report — CBCLOUDV2-9129

## Trạng thái Rule 02

implemented — backend/frontend đã code xong theo plan và đã qua kiểm chứng build/type-check cơ bản. Chưa commit/push/deploy. Chưa chạy SQL hoặc manual test trên DB/Redis thật.

## Phạm vi đã thực hiện

### Backend `invoice-management/aspnet-core`

- Thêm entity host-side `DM_NCC_LoaiCTDT` map bảng `vs_dm_ncc_loaictdt`.
- Thêm DTO/input DTO `DMNCCLoaiCTDTDto`, `GetAllDSLoaiCTDTInput`.
- Đăng ký `DbSet<DM_NCC_LoaiCTDT> DSLoaiCTDT` trong `HDDTDbContext`.
- Đăng ký AutoMapper entity ↔ DTO trong `CustomDtoMapper`.
- Thêm `DM_NCC_LoaiCTDTAppService`:
  - `GetAll`, `GetAllNoPage`, `GetLoaiCTDTForEdit`, `CreateOrEdit`, `Delete`, `TaiFileDSLoaiCTDT`, `NhapFileExcel`, `TaiFileMau`.
  - Validate required/max length/duplicate/date range.
  - Cache ABP `ICacheManager`, cache name `DM_NCC_LoaiCTDT`, key `All`.
  - Clear cache sau Create/Update/Ngừng hiệu lực/Import.
  - `Delete` là ngừng hiệu lực (`LoaiCTDT_HieuLuc = 0`), không hard delete.
  - Logging không ghi raw Excel/base64/file content/secrets/token/JWT.
- Thêm permission constants và permission tree:
  - `Admin.DanhMuc.LoaiCTDT`
  - `Admin.DanhMuc.LoaiCTDT.Create`
  - `Admin.DanhMuc.LoaiCTDT.Edit`
  - `Admin.DanhMuc.LoaiCTDT.Delete`
  - `Admin.DanhMuc.LoaiCTDT.Import`
- Thêm localization keys tiếng Việt cho LoaiCTDT.
- Bổ sung Excel helper export/import/template:
  - File/sheet/header whitelist: STT/Mã/Mô tả/Bắt đầu/Kết thúc/Hiệu lực.
  - Import `.xlsx`, validate header/data/duplicate/date.

### Frontend `invoice-management/angular`

- Generate lại `service-proxies.ts` bằng NSwag từ swagger backend local.
- Đăng ký provider `ApiServiceProxies.DM_NCC_LoaiCTDTServiceProxy`.
- Thêm route `/app/hddt/danhmuc/dmnhacungcap-loaictdt`.
- Thêm menu `LoaiChungTuDienTu` với permission `Admin.DanhMuc.LoaiCTDT`.
- Thêm component danh sách và modal thêm/sửa/import theo pattern Quốc tịch:
  - List: filter, PrimeNG table, paginator, sorting, export/import/add/action buttons.
  - Modal thêm/sửa: mã, mô tả, ngày bắt đầu, ngày kết thúc, hiệu lực; mã disabled khi edit.
  - Import modal: chọn `.xlsx`, tải file mẫu, gọi proxy import.
  - Action delete UI dùng wording ngừng hiệu lực.

### Docs/DB

- Thêm SQL deploy tham khảo: `databases/databasehost.vs_dm_ncc_loaictdt.sql`.
- SQL có create table, seed 8 dòng chống insert trùng mã, rollback seed/drop table có điều kiện.
- Cập nhật `tasks.md`, `deploy.md`, `impact.md` theo trạng thái implement và verification.

## File đã thay đổi/thêm

### Source repo `D:\BILL\invoicemanagement`

- `aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_LoaiCTDT.cs`
- `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLoaiCTDT/DMNCCLoaiCTDTDto.cs`
- `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLoaiCTDT/GetAllDSLoaiCTDTInput.cs`
- `aspnet-core/src/hddt/HDDT.Application/AppServices/DanhMuc/DMNhaCungCap/DM_NCC_LoaiCTDTAppService.cs`
- `aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs`
- `aspnet-core/src/hddt/HDDT.Application/CustomDtoMapper.cs`
- `aspnet-core/src/hddt/HDDT.Core/Authorization/AppPermissions.cs`
- `aspnet-core/src/hddt/HDDT.Core/Authorization/AppAuthorizationProvider.cs`
- `aspnet-core/src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml`
- `aspnet-core/src/hddt/HDDT.Application/Commons/DanhMuc/DMNhaCungCap/DMNhaCungCap_THNTExcelHelper.cs`
- `angular/src/shared/service-proxies/service-proxies.ts`
- `angular/src/shared/service-proxies/service-proxy.module.ts`
- `angular/src/app/hddt/hddt-routing.module.ts`
- `angular/src/app/hddt/hddt.module.ts`
- `angular/src/app/shared/layout/nav/app-navigation.service.ts`
- `angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/dmnhacungcap-loaictdt.component.ts`
- `angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/dmnhacungcap-loaictdt.component.html`
- `angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/thongtin-dmnccloaictdt-modal.component.ts`
- `angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/thongtin-dmnccloaictdt-modal.component.html`
- `angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/nhap-file-dmnccloaictdt-modal.component.ts`
- `angular/src/app/hddt/danhmuc/dmnhacungcap/loaictdt/nhap-file-dmnccloaictdt-modal.component.html`

### Docs repo `D:\BILL\docs`

- `databases/databasehost.vs_dm_ncc_loaictdt.sql`
- `features/CBCLOUDV2-9129/expect.md`
- `features/CBCLOUDV2-9129/plan.md`
- `features/CBCLOUDV2-9129/tasks.md`
- `features/CBCLOUDV2-9129/deploy.md`
- `features/CBCLOUDV2-9129/impact.md`
- `features/CBCLOUDV2-9129/testcase.md`
- `features/CBCLOUDV2-9129/report.md`

## Verification đã chạy

### Layout check

Command:

```bash
cd /d/BILL && bash docs/scripts/check-layout.sh
```

Output chính:

```text
== PASS — có thể bắt đầu phiên làm việc. ==
```

Layout check cuối Rule 02 cũng pass:

```text
== PASS — có thể bắt đầu phiên làm việc. ==
```

Ghi chú: layout check có cảnh báo `invoice-management` không tìm thấy dưới `/d/BILL` do service registry dùng tên canonical, trong khi physical source theo expect/plan là `D:\BILL\invoicemanagement`.

### Backend build

Command:

```powershell
dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln"
```

Output chính:

```text
Build succeeded.
```

Ghi chú: build output có warnings legacy/out-of-support/vulnerability package từ project hiện hữu; không có compile error từ thay đổi CBCLOUDV2-9129.

### Swagger/NSwag

Backend host command dùng để mở swagger local:

```powershell
$env:ASPNETCORE_URLS = "http://localhost:22742"; Push-Location "D:\BILL\invoicemanagement\aspnet-core\src\zero\VS.Web.Host"; try { dotnet run --no-build } finally { Pop-Location }
```

Swagger endpoint đã ready:

```text
http://localhost:22742/swagger/v1/swagger.json
```

NSwag command:

```powershell
Push-Location "D:\BILL\invoicemanagement\angular\nswag"; try { .\refresh.bat } finally { Pop-Location }
```

Output chính:

```text
Executing file 'D:\BILL\invoicemanagement\angular\nswag\service.config.nswag'...
Done.
```

Ghi chú: một lần chạy host sau đó báo port bind lỗi do port đã được dùng bởi instance trước đó; proxy đã generate thành công trước đó. Host nền đã được dừng khi không cần nữa.

### Angular type-check

Command:

```powershell
Push-Location "D:\BILL\invoicemanagement\angular"; try { .\node_modules\.bin\tsc -p src\tsconfig.json --noEmit } finally { Pop-Location }
```

Output chính:

```text
PowerShell completed with no output
```

Kết quả: pass.

## Chưa thực hiện / cần người có quyền kiểm chứng

- Chưa chạy SQL create/seed/rollback trên DB thật.
- Chưa xác nhận cuối cùng host DB vs tenant DB bằng DBA/TechLead trước deploy.
- Chưa manual test trên UI/API với DB/Redis thật:
  - mở menu/route;
  - search/page/sort;
  - thêm/sửa/ngừng hiệu lực;
  - export/import file mẫu/sai header/trùng mã/date sai;
  - permission theo role;
  - cache invalidation trước/sau mutation/import.
- Chưa commit/push/merge/deploy.

## Security notes

- Không thêm secrets/connection string thật vào docs/code/report.
- Không log raw Excel/base64/file content ở phần import LoaiCTDT.
- Export chỉ gồm whitelist cột danh mục: STT, Mã, Mô tả, Bắt đầu, Kết thúc, Hiệu lực.
- Delete nghiệp vụ là ngừng hiệu lực, không hard delete.
