# Conventions — Backend ABP (BillCloud)

> Quy ước chung mọi service ở [../project.md](../project.md) §4–8. File này ghi phần riêng của **các backend ASP.NET Zero / ABP** trên Cloud.
> Áp dụng cho: `api-cloud-service/`, `api-qldv-service/`, `invoicecore/aspnet-core/`, `invoice-management/aspnet-core/` (tra repo path ở [../AGENTS.md](../AGENTS.md)).

## Nhận dạng

- **Vai trò:** API nghiệp vụ HĐĐT + admin ABP (user/role/tenant/setting/audit) + module hóa đơn/danh mục/quản lý.
- **Stack:** C# · ASP.NET Zero (ABP) · .NET Core · EF Core · MySQL/MariaDB (master + tenant).

## Layer map (theo pattern ASP.NET Zero)

| Việc cần làm | Đặt ở (tương đối trong `aspnet-core/src/`) |
|---|---|
| Tầng nền (user/role/tenant/setting/audit) | `zero/` (platform ABP) |
| Module nghiệp vụ | `hddt/`, `qlbh/`, `qlht/`, `dmkhachhang/` … |
| Entity nghiệp vụ | `hddt/*.Core/Domains/<Nhóm>/` |
| Quyền | `*.Core/Authorization/AppPermissions.cs` + `AppAuthorizationProvider.cs` |
| DTO / Input / Output | `*.Application/DataTransferObjects/…` |
| App service nghiệp vụ | `*.Application/AppServices/<Module>/` |
| AutoMapper | `*.Application/CustomDtoMapper.cs` |
| DbContext nghiệp vụ | `*.EntityFrameworkCore/EntityFrameworkCore/<...>DbContext.cs` |
| Localization | `*.Core/Localization/…` |

> Cấu trúc chi tiết từng repo (tên solution, tên DbContext, danh sách module) cần **drift-check bằng [rule 00](../../rules/00-init-docs.md)** rồi bổ sung — không suy đoán.

## Quy ước đặt tên

- App service: `<Nghiệp vụ>AppService`, đặt trong thư mục module tương ứng; endpoint sinh tự động qua ABP dynamic controller.
- Entity: theo tiền tố nhóm (`HD_`, `DM_NCC_`, `DMDoanhNghiep_`, `DoanhNghiep_`, `Bangke_`/`Bc26ac_`, `ChungTu_`, `Service_`). Bảng thật là `vs_*` — tra [../databases/README.md](../databases/README.md).
- Endpoint prefix tôn trọng: `/api/services/app/*`, `/api/services/hddt/*`, `/api/services/hddtws/*`, `/api/TokenAuth/*`.
- Kiểu trả về: theo mẫu DTO sẵn có của repo (`PagedResultDto<T>`, `FileDataDto`, `TaiFile`, …), đừng tự chế kiểu mới.

## Cache Redis

- Dùng ABP `ICacheManager`; connection lấy từ config hiện có `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId` (chỉ ghi tên khóa).
- Danh sách danh mục có thể cache (vd cache name `DM_NCC_<Nhóm>`, key `All`); **clear cache sau Create/Update/Delete/Import**.

## Đa tenant & DB

- Query nghiệp vụ phải scope đúng tenant; không lộ dữ liệu chéo doanh nghiệp.
- **Không chạy `dotnet ef migrations add`** cho bảng nghiệp vụ `vs_*`. Thêm/đổi bảng → script SQL + rollback trong `deploy.md`, DBA/TechLead review.
- Soft delete bằng cờ `IsDeleted`; không DELETE vật lý (trừ bảng log/lịch sử chỉ INSERT).

## Lệnh thường dùng

```bash
# build (dùng OutDir tạm để tránh lock host/Visual Studio)
dotnet build <repo>/aspnet-core/<solution>.sln -clp:ErrorsOnly -p:OutDir=<repo>/aspnet-core/.tmp-build/

# chạy host để refresh Swagger cho NSwag
dotnet run --project <repo>/aspnet-core/src/.../*.Host.csproj
```

## Pitfall

- **Nhiều backend cùng pattern** (`api-cloud-service`, `api-qldv-service`, `invoicecore`, `invoice-management`) → tên class có thể trùng nhau. Search theo tên class dễ khớp nhầm repo — **luôn bám local folder name/repo path**.
- `invoice-management/` (git repo `invoicemanagement`) là admin portal, **repo riêng** dù cùng pattern layout với `invoicecore/`.
- Feature port từ Liên Sơn (vd `CBCLOUDV2-8963` Danh mục quốc tịch ↔ `CBCLOUDV2-8988`) phải port **thủ công** vào file Cloud; Cloud và LS đã diverge, **không cherry-pick mù**.
- `appsettings.json` có thể chứa **credential thật** — không copy giá trị vào docs/log; không xóa comment môi trường khác.
- Tích hợp HSM/ký số, Kafka GATE **không chạy được ở local** — testcase liên quan đánh dấu `manual`.

## Không được đụng

`bin/`, `obj/`, `build/`, `.tmp-build/`, file proxy sinh bởi NSwag.
