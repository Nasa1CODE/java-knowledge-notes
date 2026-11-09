# Plan — CBCLOUDV2-9129: Bổ sung danh mục loại chứng từ điện tử

> DEV sở hữu. Sinh cùng AI theo [rules/01-create-plan.md](../../rules/01-create-plan.md). **DEV bắt buộc tự review trước khi trình Gate 1.**
> Status vòng đời feature nằm ở `expect.md`. Ở đây chỉ là trạng thái của bản plan.

plan-status: approved

service: invoice-management
service-repo: ./invoice-management
services-affected: [invoice-management]
owner: AI
created_at: 2026-09-07
updated_at: 2026-09-08

## Câu hỏi chặn (blocking)

Không còn câu hỏi blocking cho Rule 01. Các câu hỏi trước đó đã được user trả lời trong bản nháp ngày 2026-09-07:

- Scope nghiệp vụ: **danh mục loại chứng từ điện tử**, không phải quốc tịch.
- Service source thực tế: `D:\BILL\invoicemanagement`; trong docs vẫn ghi service-key canonical `invoice-management` theo [AGENTS.md](../../AGENTS.md).
- Pattern chức năng/permission/DB scope: giống **danh mục quốc tịch**.
- Trường nghiệp vụ bổ sung: ngày bắt đầu, ngày kết thúc, hiệu lực.
- Xóa nghiệp vụ: **cho ngừng hiệu lực**, không hard delete.
- Redis key/cache: DEV chọn tên hợp lý theo pattern hiện có.
- Export/Import: có trong scope, cần chú ý an toàn thông tin.
- Branch: `hungtq_dev_cloud_CBCLOUDV2-9129` từ `origin/develop_cloud`.

## Mục tiêu

Bổ sung danh mục **Loại chứng từ điện tử** trên admin Cloud trong service `invoice-management`, gồm:

1. Bảng nghiệp vụ `vs_dm_ncc_loaictdt` lưu dữ liệu danh mục và 8 dòng seed theo [expect.md](expect.md).
2. Backend ABP AppService/DTO/entity/mapper/permission/cache/export/import theo pattern danh mục quốc tịch.
3. Frontend Angular route/menu/list/modal/import/export theo pattern danh mục quốc tịch.
4. Redis cache riêng cho danh mục, invalidate sau mọi mutation/import.
5. Deploy/rollback DB bằng SQL script; **không dùng EF migration cho bảng `vs_*`**.
6. Bộ testcase manual/build đủ để DEV self-review trước Gate 1.

## Bối cảnh

- Service registry trong [AGENTS.md](../../AGENTS.md) định danh canonical service là `invoice-management`, repo path `./invoice-management`, git repo `cloudinvoicesys/invoicemanagement`.
- Workspace thực tế đang có source ở `D:\BILL\invoicemanagement` thay vì `D:\BILL\invoice-management`; plan dùng đường dẫn vật lý này cho verification local nhưng vẫn dùng service-key canonical `invoice-management` trong docs.
- Pattern nghiệp vụ đã trace từ danh mục quốc tịch:
  - BE: `DM_NCC_QuocTichAppService`, DTO/entity/mapper, permission, localization, Excel helper.
  - FE: route/menu/component/modal/import modal/provider/proxy theo `dmnhacungcap-quoctich`.
  - Cache: `ICacheManager`, cache name `DM_NCC_QuocTich`, key `All`, clear cache sau Create/Update/Delete/Import.
- Pattern DB source QuocTich entity là `[MultiTenancySide(MultiTenancySides.Host)]`. Tuy nhiên DB docs snapshot đang có một số file DM_NCC như [databasetenant.vs_dm_ncc_loaihoadon.sql](../../databases/databasetenant.vs_dm_ncc_loaihoadon.sql) dưới tenant. Vì user chốt “giống danh mục quốc tịch”, thiết kế chọn hướng **Host-side theo source QuocTich**, nhưng deploy phải verify DB thực tế trước khi chạy SQL.

## Nguyên nhân gốc (nếu là bug)

Không áp dụng. Đây là yêu cầu bổ sung chức năng mới theo ND254.

## Giả định · Câu hỏi mở · Ngoài phạm vi

### Giả định kỹ thuật để lập plan

- Danh mục loại chứng từ điện tử thuộc nhóm danh mục NCC/admin giống quốc tịch.
- Bảng `vs_dm_ncc_loaictdt` dùng audit/soft-delete base fields tương tự `FullAuditedEntity` và dữ liệu nghiệp vụ gồm:
  - `LoaiCTDT_Ma`
  - `LoaiCTDT_MoTa`
  - `LoaiCTDT_BatDau`
  - `LoaiCTDT_KetThuc`
  - `LoaiCTDT_HieuLuc`
- Độ dài validate theo QuocTich: mã tối đa 200 ký tự; mô tả tối đa 1500 ký tự.
- Mã không sửa sau khi tạo, giống QuocTich.
- Delete UI gọi nghiệp vụ ngừng hiệu lực: set `LoaiCTDT_HieuLuc = 0`, không hard delete.
- Import Excel nằm trong scope vì user nhấn mạnh an toàn thông tin Export và Import.
- Redis dùng ABP cache hiện hữu; không thêm config key mới ngoài các key ABP Redis đã có.

### Câu hỏi mở không blocking — cần review Gate 1

- TechLead/DBA xác nhận DB thực tế của `vs_dm_ncc_loaictdt` là host hay tenant trước deploy. Plan chọn host-side theo source QuocTich, nhưng docs DB snapshot có dấu hiệu chưa đồng nhất.
- TechLead xác nhận tên field `LoaiCTDT_MoTa` hay `LoaiCTDT_Ten`. Plan chọn `MoTa` vì [expect.md](expect.md) dùng cột “Mô tả”; nếu muốn UI label là “Tên” thì mapping cần chốt lại trước Rule 02.
- TechLead xác nhận có cần dùng danh mục này trong luồng lập chứng từ/hóa đơn ở ticket khác hay không. Ticket này chỉ tạo màn hình quản trị danh mục.

### Ngoài phạm vi

Theo [expect.md](expect.md): không thay đổi luồng phát hành/lập/gửi chứng từ/hóa đơn, XML/PDF/template, ký số/HSM, public lookup, worker, queue/topic/message contract, Java service, phân quyền nâng cao ngoài pattern quốc tịch, migrate dữ liệu lịch sử ngoài 8 dòng seed, EF migration cho `vs_*`, hoặc ghi secrets/dữ liệu nhạy cảm vào docs/code/logs/export.

## Thiết kế nghiệp vụ

### Dữ liệu danh mục

| Field UI | Field BE/DB đề xuất | Rule |
|---|---|---|
| Mã | `LoaiCTDT_Ma` | Bắt buộc, trim, tối đa 200 ký tự, unique trên dữ liệu chưa xóa logic |
| Mô tả | `LoaiCTDT_MoTa` | Bắt buộc, trim, tối đa 1500 ký tự |
| Ngày bắt đầu | `LoaiCTDT_BatDau` | Nullable; nếu có ngày kết thúc thì không được lớn hơn ngày kết thúc |
| Ngày kết thúc | `LoaiCTDT_KetThuc` | Nullable |
| Hiệu lực | `LoaiCTDT_HieuLuc` | `1` hiệu lực, `0` không hiệu lực; tạo mới mặc định `1` |

Seed 8 mã/mô tả từ [expect.md](expect.md), dòng STT 7 đã sửa thành: `Chứng từ khấu trừ thuế TNCN theo Nghị định 123/2020/NĐ-CP`.

### Luồng chức năng

1. **Danh sách/tìm kiếm**
   - User mở menu danh mục loại chứng từ điện tử.
   - FE gọi AppService `GetAll(Filter, Sorting, SkipCount, MaxResultCount)`.
   - BE filter theo mã/mô tả, exclude `IsDeleted == true`, sort/page theo input.
   - FE hiển thị mã, mô tả, ngày bắt đầu, ngày kết thúc, hiệu lực và action theo permission.

2. **Thêm mới**
   - FE mở modal với hiệu lực mặc định bật.
   - BE normalize + validate required/length/date/duplicate.
   - Insert repository, clear cache, trả `BaseResponseDto` hoặc response pattern hiện hữu.

3. **Chỉnh sửa**
   - FE gọi `GetLoaiCTDTForEdit(id)`.
   - Mã disabled trên modal khi edit.
   - BE update mô tả/ngày/hiệu lực, clear cache.

4. **Ngừng hiệu lực**
   - FE hiển thị confirm theo wording “ngừng hiệu lực”.
   - BE method `Delete(EntityDto<int> input)` hoặc tên method tương thích proxy hiện hữu sẽ load entity, set `LoaiCTDT_HieuLuc = 0`, update, clear cache.
   - Không gọi repository `DeleteAsync` cho luồng này.

5. **Export Excel**
   - FE gọi `TaiFileDSLoaiCTDT(Filter, Sorting)`.
   - BE áp dụng cùng filter/sorting với danh sách, export các cột: STT, Mã, Mô tả, Bắt đầu, Kết thúc, Hiệu lực.
   - Không export secrets/config/token/JWT/audit/internal IDs/user info.

6. **Import Excel**
   - FE có modal chọn file `.xlsx`, tải file mẫu.
   - BE validate file/header/data, duplicate trong file/DB, date range.
   - Không log raw file/base64/content; lỗi trả theo pattern hiện hữu.
   - Import thành công clear cache.

7. **GetAllNoPage/cache**
   - BE cung cấp `GetAllNoPage()` nếu có nơi cần dropdown/lookup.
   - Cache all danh mục bằng cache name/key riêng, clear sau mutation/import.

## Thiết kế kỹ thuật

### Backend — `invoice-management/aspnet-core`

#### File mới dự kiến

| File | Mục đích |
|---|---|
| `src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_LoaiCTDT.cs` | Entity map bảng `vs_dm_ncc_loaictdt` |
| `src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLoaiCTDT/DMNCCLoaiCTDTDto.cs` | DTO cho list/create/edit/export/import |
| `src/hddt/HDDT.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/DMNCCLoaiCTDT/GetAllDSLoaiCTDTInput.cs` | Input search/page nếu cần theo pattern |
| `src/hddt/HDDT.Application/AppServices/DanhMuc/DMNhaCungCap/DM_NCC_LoaiCTDTAppService.cs` | AppService CRUD/search/cache/export/import |

#### File sửa dự kiến

| File | Thay đổi |
|---|---|
| `src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs` | Thêm `DbSet<DM_NCC_LoaiCTDT>` |
| `src/hddt/HDDT.Application/CustomDtoMapper.cs` | Map entity ↔ DTO |
| `src/hddt/HDDT.Core/Authorization/AppPermissions.cs` | Thêm permission `Admin.DanhMuc.LoaiCTDT*` |
| `src/hddt/HDDT.Core/Authorization/AppAuthorizationProvider.cs` | Register permission tree dưới danh mục admin |
| `src/hddt/HDDT.Core/Localization/HDDT/VS-vi.xml` | Thêm localization keys menu/action/modal |
| `src/hddt/HDDT.Application/Commons/DanhMuc/DMNhaCungCap/DMNhaCungCap_THNTExcelHelper.cs` | Thêm export/import/template cho LoaiCTDT |

#### Entity đề xuất

```csharp
[Table("vs_dm_ncc_loaictdt")]
[MultiTenancySide(MultiTenancySides.Host)]
public class DM_NCC_LoaiCTDT : FullAuditedEntity
{
    public string LoaiCTDT_Ma { get; set; }
    public string LoaiCTDT_MoTa { get; set; }
    public DateTime? LoaiCTDT_BatDau { get; set; }
    public DateTime? LoaiCTDT_KetThuc { get; set; }
    public int? LoaiCTDT_HieuLuc { get; set; }
}
```

> Lưu ý Gate 1: nếu DBA/TechLead xác nhận bảng phải ở tenant DB theo docs snapshot, cần đổi `MultiTenancySide`/SQL scope và cache-scope tương ứng trước Rule 02.

#### DTO đề xuất

```csharp
public class DMNCCLoaiCTDTDto : FullAuditedEntityDto<int?>
{
    public string LoaiCTDT_Ma { get; set; }
    public string LoaiCTDT_MoTa { get; set; }
    public DateTime? LoaiCTDT_BatDau { get; set; }
    public DateTime? LoaiCTDT_KetThuc { get; set; }
    public int? LoaiCTDT_HieuLuc { get; set; }
}
```

#### AppService contract đề xuất

| Method | Permission | Ghi chú |
|---|---|---|
| `GetAll(string Filter, string Sorting, int SkipCount, int MaxResultCount)` | `Admin.DanhMuc.LoaiCTDT` | Filter mã/mô tả, sort/page |
| `GetAllNoPage()` | `Admin.DanhMuc.LoaiCTDT` | Dùng cache `DM_NCC_LoaiCTDT`/`All` |
| `GetLoaiCTDTForEdit(EntityDto<int> input)` | `Admin.DanhMuc.LoaiCTDT.Edit` hoặc view permission | Load modal edit |
| `CreateOrEdit(DMNCCLoaiCTDTDto input)` | create/edit child permission theo id | Dispatch create/update |
| `Delete(EntityDto<int> input)` | `Admin.DanhMuc.LoaiCTDT.Delete` | Implement ngừng hiệu lực, không hard delete |
| `TaiFileDSLoaiCTDT(string Filter, string Sorting)` | `Admin.DanhMuc.LoaiCTDT` | Export theo filter/sorting |
| `NhapFileExcel(FileDataDto file)` | `Admin.DanhMuc.LoaiCTDT.Import` | Import `.xlsx`, validate an toàn |
| `TaiFileMau()` | `Admin.DanhMuc.LoaiCTDT.Import` | Download template |

#### Permission/localization đề xuất

Permission constants:

```csharp
public const string Admin_DanhMuc_LoaiCTDT = "Admin.DanhMuc.LoaiCTDT";
public const string Admin_DanhMuc_LoaiCTDT_Create = "Admin.DanhMuc.LoaiCTDT.Create";
public const string Admin_DanhMuc_LoaiCTDT_Edit = "Admin.DanhMuc.LoaiCTDT.Edit";
public const string Admin_DanhMuc_LoaiCTDT_Delete = "Admin.DanhMuc.LoaiCTDT.Delete";
public const string Admin_DanhMuc_LoaiCTDT_Import = "Admin.DanhMuc.LoaiCTDT.Import";
```

Localization keys:

| Key | Text đề xuất |
|---|---|
| `LoaiChungTuDienTu` | Loại chứng từ điện tử |
| `TaoMoiLoaiChungTuDienTu` | Tạo mới loại chứng từ điện tử |
| `ChinhSuaLoaiChungTuDienTu` | Chỉnh sửa loại chứng từ điện tử |
| `NgungHieuLucLoaiChungTuDienTu` | Ngừng hiệu lực loại chứng từ điện tử |
| `NhapDanhSachLoaiChungTuDienTu` | Nhập danh sách loại chứng từ điện tử |
| `ThongTinLoaiChungTuDienTu` | Thông tin loại chứng từ điện tử |

### Frontend — `invoice-management/angular`

#### File mới dự kiến

| File | Mục đích |
|---|---|
| `src/app/hddt/danhmuc/dmnhacungcap/loaictdt/dmnhacungcap-loaictdt.component.ts` | Component danh sách/search/export/import/action |
| `src/app/hddt/danhmuc/dmnhacungcap/loaictdt/dmnhacungcap-loaictdt.component.html` | Template PrimeNG table/filter/buttons |
| `src/app/hddt/danhmuc/dmnhacungcap/loaictdt/thongtin-dmnccloaictdt-modal.component.ts` | Modal thêm/sửa |
| `src/app/hddt/danhmuc/dmnhacungcap/loaictdt/thongtin-dmnccloaictdt-modal.component.html` | Template modal thêm/sửa |
| `src/app/hddt/danhmuc/dmnhacungcap/loaictdt/nhap-file-dmnccloaictdt-modal.component.ts` | Modal import file |
| `src/app/hddt/danhmuc/dmnhacungcap/loaictdt/nhap-file-dmnccloaictdt-modal.component.html` | Template import + tải file mẫu |

#### File sửa dự kiến

| File | Thay đổi |
|---|---|
| `src/app/hddt/hddt-routing.module.ts` | Import component và route `danhmuc/dmnhacungcap-loaictdt` |
| `src/app/hddt/hddt.module.ts` | Declare 3 component/modal mới |
| `src/app/shared/layout/nav/app-navigation.service.ts` | Thêm menu item `LoaiChungTuDienTu` dưới danh mục, permission `Admin.DanhMuc.LoaiCTDT` |
| `src/shared/service-proxies/service-proxy.module.ts` | Register service proxy sau khi generate |
| `src/shared/service-proxies/service-proxies.ts` | Generate bằng NSwag từ backend contract; không sửa tay nếu không bắt buộc |

#### UI behavior đề xuất

- Route: `/app/hddt/danhmuc/dmnhacungcap-loaictdt`.
- Component class: `DMNhaCungCap_LoaiCTDTComponent`.
- Service proxy: `DM_NCC_LoaiCTDTServiceProxy` sau generate.
- Filter field FE: `tenLoaiCTDT` hoặc `filter`.
- Buttons:
  - Export Excel: hiện nếu có view permission.
  - Import Excel: hiện nếu có `Admin.DanhMuc.LoaiCTDT.Import`.
  - Thêm mới: hiện nếu có `Admin.DanhMuc.LoaiCTDT.Create`.
- Action row:
  - Sửa: `Admin.DanhMuc.LoaiCTDT.Edit`.
  - Ngừng hiệu lực: `Admin.DanhMuc.LoaiCTDT.Delete`; wording confirm không dùng “xóa” nếu có thể.

### DB / SQL deploy

Bảng đề xuất: `vs_dm_ncc_loaictdt`.

Scope đề xuất: **host DB theo source QuocTich**.

File SQL docs/deploy đề xuất sau Gate 1:

- `docs/databases/databasehost.vs_dm_ncc_loaictdt.sql` nếu TechLead/DBA xác nhận host DB.
- Nếu xác nhận tenant DB, đổi thành `docs/databases/databasetenant.vs_dm_ncc_loaictdt.sql` và cập nhật entity/cache scope tương ứng.

Cột đề xuất:

| Cột | Kiểu đề xuất | Ghi chú |
|---|---|---|
| `Id` | `int` | PK, auto increment theo schema thực tế |
| audit columns | theo `FullAuditedEntity` | `CreationTime`, `CreatorUserId`, `LastModificationTime`, `LastModifierUserId`, `IsDeleted`, `DeleterUserId`, `DeletionTime` |
| `LoaiCTDT_Ma` | `varchar(200)` | required ở app, unique theo dữ liệu chưa xóa |
| `LoaiCTDT_MoTa` | `varchar(1500)` | required ở app |
| `LoaiCTDT_BatDau` | `datetime null` | nullable |
| `LoaiCTDT_KetThuc` | `datetime null` | nullable |
| `LoaiCTDT_HieuLuc` | `int null/default 1` | `1`/`0` |

SQL cần có:

- `CREATE TABLE IF NOT EXISTS` hoặc kiểm tra tồn tại theo convention DB hiện hành.
- Unique index cho mã nếu DB hỗ trợ phù hợp với soft delete; nếu không dùng unique DB do legacy constraint thì AppService vẫn phải validate duplicate.
- Seed 8 dòng bằng upsert/insert-if-not-exists theo `LoaiCTDT_Ma`.
- Rollback: xóa seed theo mã và drop table nếu table do ticket tạo mới và chưa có dữ liệu ngoài seed; không drop nếu đã phát sinh dữ liệu thật.

### Redis cache

- Cache API: ABP `ICacheManager`.
- Cache name đề xuất: `DM_NCC_LoaiCTDT`.
- Cache key đề xuất: `All`.
- TTL: theo pattern QuocTich hiện hữu — không set TTL riêng trong code nếu cache hiện có cũng không set.
- Invalidate:
  - sau Create;
  - sau Update;
  - sau ngừng hiệu lực;
  - sau Import thành công.
- Không ghi Redis connection string thật vào docs/code/logs; chỉ ghi tên config nếu cần: `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId`.

### An toàn thông tin Export/Import

- Export chỉ xuất field danh mục cần thiết, không xuất audit/user/internal IDs/secrets/config/token/JWT.
- Import validate extension `.xlsx`, header, số dòng/cột, required, max length, duplicate, date range.
- Không log raw `fileData`, base64, nội dung Excel, token/JWT, password, connection string hoặc dữ liệu khách hàng ngoài phạm vi danh mục.
- `GetInputLog`/logging chỉ ghi thông tin rút gọn: file name đã sanitize/truncate, số dòng, loại lỗi validate.
- Thông báo lỗi trả user không chứa stack trace, đường dẫn nội bộ nhạy cảm hoặc secrets.

## Thay đổi kỹ thuật

| Hạng mục | Có/Không | Chi tiết |
|---|---|---|
| Entity / SQL schema | Có | Thêm entity `DM_NCC_LoaiCTDT`, DbSet, bảng `vs_dm_ncc_loaictdt`; SQL script + rollback, không EF migration. |
| DTO / AppService | Có | CRUD/search/export/import/cache theo pattern QuocTich. |
| Màn hình / route | Có | Thêm route/menu/component/modal/import cho admin Cloud. |
| Permission / i18n | Có | Permission riêng `Admin.DanhMuc.LoaiCTDT*`, localization text tiếng Việt. |
| Redis cache | Có | `DM_NCC_LoaiCTDT`/`All`, clear sau mutation/import. |
| NSwag contract | Có | Generate service proxy sau khi backend contract build. |
| Queue/Kafka/RabbitMQ | Không | Ngoài scope. |
| XML/PDF/HSM/gửi thuế | Không | Ngoài scope. |
| Config secrets | Không | Không thêm/ghi secrets; chỉ dùng Redis config hiện hữu nếu cần. |

## Thứ tự thực hiện & phụ thuộc

1. **Branch/workspace**
   - Cập nhật repo service từ `origin/develop_cloud`.
   - Tạo/switch branch `hungtq_dev_cloud_CBCLOUDV2-9129` nếu chưa có.
   - Không commit/push nếu chưa được yêu cầu.

2. **DB schema + seed**
   - DBA/TechLead xác nhận host/tenant scope.
   - Viết SQL create table + seed + rollback tương ứng.
   - Không chạy EF migration cho `vs_*`.

3. **Backend domain/DTO/AppService**
   - Thêm entity, DbSet, DTO, mapper.
   - Thêm AppService với validate/cache/export/import.
   - Thêm permission/localization.
   - Build backend.

4. **Frontend contract/proxy**
   - Chạy NSwag/generate proxy theo quy trình dự án.
   - Register provider trong `service-proxy.module.ts`.

5. **Frontend UI**
   - Thêm route/menu/component/modal/import.
   - Bind permission/action/notify/download.
   - Type-check/build frontend.

6. **Manual verification**
   - CRUD/search/export/import/security/cache test theo [testcase.md](testcase.md).
   - DEV self-review và cập nhật Gate 1 checklist.

## Kế hoạch kiểm chứng

> Lệnh dùng đường dẫn vật lý workspace `D:\BILL\invoicemanagement`. Nếu repo được checkout ở path canonical khác, điều chỉnh path trước khi chạy.

| # | Lệnh / bước kiểm | Kết quả kỳ vọng |
|---|---|---|
| 1 | `git status` trong `D:\BILL\docs` và `D:\BILL\invoicemanagement` | Nắm rõ file docs/source thay đổi, không đè thay đổi người khác. |
| 2 | `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln"` | Backend build thành công, không lỗi compile. |
| 3 | Generate NSwag proxy theo script/quy trình hiện hành của repo Angular | Có `DM_NCC_LoaiCTDTServiceProxy` và DTO trong `service-proxies.ts`. |
| 4 | `npm run`/type-check phù hợp repo Angular hoặc `tsc -p src/tsconfig.json --noEmit` trong `D:\BILL\invoicemanagement\angular` | Frontend type-check/build tối thiểu không lỗi. |
| 5 | Manual: mở menu danh mục loại chứng từ điện tử | Màn hình load đúng, permission/menu đúng. |
| 6 | Manual: tìm kiếm, phân trang, sort | Kết quả đúng theo mã/mô tả và sorting. |
| 7 | Manual: thêm mới/sửa/ngừng hiệu lực | Validate đúng, refresh danh sách, cache được clear. |
| 8 | Manual: export | File Excel đúng cột/filter/sorting, không chứa dữ liệu nhạy cảm ngoài scope. |
| 9 | Manual: import file mẫu + import lỗi | File hợp lệ import thành công; file lỗi trả thông báo/file lỗi an toàn. |
| 10 | Manual/cache: gọi `GetAllNoPage` trước/sau mutation | Sau mutation/import, lần đọc sau không trả dữ liệu cache cũ. |

## Ma trận rủi ro

| Rủi ro | Ảnh hưởng | Giảm thiểu | Rollback |
|---|---|---|---|
| Nhầm host/tenant DB do source và docs snapshot chưa đồng nhất | Cao | Gate 1 yêu cầu TechLead/DBA xác nhận DB scope trước khi chạy SQL; plan đang chọn theo source QuocTich | Dừng deploy SQL; nếu đã chạy sai môi trường thì rollback SQL theo script và clear cache |
| Tên field `MoTa`/`Ten` không thống nhất | Trung bình | Chốt trong Gate 1; plan chọn `MoTa` theo expect | Rename/mapping trước khi release; chưa release thì sửa code/SQL |
| Hard delete nhầm dữ liệu danh mục | Cao | AppService delete phải implement ngừng hiệu lực, testcase riêng | Restore DB backup nếu hard delete xảy ra; rollback code; clear cache |
| Cache Redis trả dữ liệu cũ | Trung bình | Cache name/key riêng, clear sau Create/Update/Ngừng hiệu lực/Import | Xóa cache `DM_NCC_LoaiCTDT`/`All`, rollback cache code nếu cần |
| Import log lộ raw Excel/base64/dữ liệu nhạy cảm | Cao | Không log `fileData`; truncate/sanitize log; testcase security | Xóa log nếu quy trình cho phép, rotate log, fix code logging |
| Export lộ dữ liệu ngoài scope | Cao | Export whitelist cột danh mục, không audit/user/internal IDs | Gỡ file export bị lộ khỏi kênh chia sẻ, fix helper, retest |
| Permission thiếu/sai khiến user không được phép thao tác hoặc lộ menu | Trung bình/Cao | Permission riêng theo QuocTich, test role có/không quyền | Revoke permission/menu, hotfix constants/provider/menu |
| NSwag proxy bị sửa tay sai contract | Trung bình | Generate proxy từ backend contract; không sửa tay file generated | Re-generate proxy, rollback thay đổi generated sai |

## Ghi chú triển khai

- Rule 01 chỉ lập plan/docs, không viết code source.
- Không chạy `dotnet ef migrations add` cho bảng `vs_dm_ncc_loaictdt`.
- Không đưa secrets vào docs/code/logs. Nếu cần nhắc Redis config, chỉ ghi tên key config.
- Trước Rule 02 cần DEV tự review bản plan này và TechLead approve Gate 1.

## Đề xuất cập nhật docs (Gate 2)

- [databases/](../../databases/): bổ sung file SQL cho `vs_dm_ncc_loaictdt` sau khi xác nhận host/tenant scope.
- [specs/system.md](../../specs/system.md) hoặc domain spec danh mục nếu được tách: bổ sung danh mục loại chứng từ điện tử.
- [design.md](../../design.md): chỉ cập nhật nếu màn hình phát sinh pattern UI khác pattern danh mục hiện hữu.
- [architecture.md](../../architecture.md): chỉ cập nhật nếu danh mục được dùng bởi integration/contract ngoài `invoice-management`.

## Phê duyệt (Gate 1) — chỉ người điền, AI không tự điền

- [x] DEV tự review: [Trần Quốc Hùng](https://jira.cybertech.vn/browse/CBCLOUDV2-9129) — [2026-09-08]
- [x] TechLead approve: tienvv — [2026-09-08] — <[link commit/PR](https://jira.cybertech.vn/browse/CBCLOUDV2-8924)>

> Khi block này đủ chữ ký và `expect.md` đã đủ Ready, cập nhật lifecycle theo quy trình rồi mới chạy Rule 02.
