# Impact — CBCLOUDV2-9129: Bổ sung danh mục loại chứng từ điện tử

## Purpose

Đánh giá impact Gate 1 cho ticket CBCLOUDV2-9129: bổ sung danh mục **Loại chứng từ điện tử** trên admin Cloud trong service `invoice-management`, gồm UI quản trị, backend ABP AppService, bảng `vs_dm_ncc_loaictdt`, Redis cache, Export/Import Excel và seed dữ liệu tham chiếu.

## Phạm vi thay đổi / Change scope

| Loại impact | Mức | Ghi chú |
|---|---|---|
| Logic/API | Medium | Thêm AppService CRUD/search/export/import/cache mới trong `invoice-management/aspnet-core`; không sửa luồng lập/gửi chứng từ hiện hữu. |
| UI | Medium | Thêm menu/route/màn hình admin Angular theo pattern danh mục quốc tịch. |
| DB/schema | High | Thêm bảng nghiệp vụ `vs_dm_ncc_loaictdt` và seed 8 dòng; cần SQL + rollback, không dùng EF migration. |
| Cache Redis | Medium | Thêm cache name/key riêng và invalidate sau mutation/import; sai invalidation có thể trả dữ liệu cũ. |
| Permission | Medium | Thêm permission riêng dưới danh mục admin; sai permission có thể lộ menu/chức năng hoặc chặn user hợp lệ. |
| Contract/NSwag | Medium | Backend AppService mới sinh proxy Angular mới; cần generate và register provider. |
| Export/Import security | High | Import xử lý file/base64 và export dữ liệu; cần whitelist cột và không log/lộ dữ liệu nhạy cảm. |
| Queue/Kafka/RabbitMQ | None | Không thuộc scope. |
| XML/PDF/HSM/gửi thuế | None | Không thuộc scope. |

## Thành phần bị ảnh hưởng / Affected components

| Layer | Thành phần | Impact level | Cơ sở / lý do |
|---|---|---|---|
| Docs feature | [expect.md](expect.md), [plan.md](plan.md), [tasks.md](tasks.md), [deploy.md](deploy.md), [testcase.md](testcase.md) | Medium | AC/plan/test/deploy cần thống nhất trước Gate 1. |
| Service registry | `invoice-management` | Low | Dùng service-key canonical theo [AGENTS.md](../../AGENTS.md); physical workspace hiện là `D:\BILL\invoicemanagement`. |
| Backend domain | `HDDT.Core/Domains/DanhMuc/DMNhaCungCap` | Medium | Thêm entity `DM_NCC_LoaiCTDT`. |
| Backend data access | `HDDTDbContext`, repository ABP | Medium | Thêm `DbSet`; repository ABP dùng bảng mới. |
| Backend DTO/mapper | `DataTransferObjects/.../DMNCCLoaiCTDT`, `CustomDtoMapper` | Medium | Contract mới cho AppService/proxy. |
| Backend AppService | `AppServices/DanhMuc/DMNhaCungCap/DM_NCC_LoaiCTDTAppService.cs` | Medium | Thêm CRUD/search/cache/export/import mới; không sửa AppService khác. |
| Backend permissions | `AppPermissions.cs`, `AppAuthorizationProvider.cs` | Medium | Thêm permission tree `Admin.DanhMuc.LoaiCTDT*`. |
| Backend localization | `VS-vi.xml` | Low | Thêm text tiếng Việt menu/action/modal. |
| Backend Excel helper | `DMNhaCungCap_THNTExcelHelper.cs` | Medium/High | Thêm export/import/template; cần kiểm soát dữ liệu và logging. |
| Frontend routing/module | `hddt-routing.module.ts`, `hddt.module.ts` | Medium | Thêm route và declarations. |
| Frontend navigation | `app-navigation.service.ts` | Medium | Thêm menu item theo permission. |
| Frontend UI | `danhmuc/dmnhacungcap/loaictdt/*` | Medium | Thêm list/modal/import components. |
| Frontend proxy | `service-proxies.ts`, `service-proxy.module.ts` | Medium | Generate proxy mới và register provider. |
| Database | `vs_dm_ncc_loaictdt` | High | Bảng mới + seed, cần xác nhận host/tenant DB trước deploy. |
| Redis | ABP Redis/shared Redis của admin service | Medium | Cache name `DM_NCC_LoaiCTDT`, key `All`, invalidate sau thay đổi. |

## Không thuộc phạm vi / Confirmed unaffected

| Thành phần | Lý do không đổi |
|---|---|
| `searchBill` public lookup | Ticket chỉ yêu cầu admin Cloud danh mục. |
| Customer portal / portal chính ngoài admin `invoice-management` | Không có AC về người dùng tenant/customer portal ngoài màn hình admin. |
| Luồng lập/phát hành/gửi chứng từ hoặc hóa đơn | Out-of-scope trong [expect.md](expect.md). |
| XML/PDF/template chứng từ/hóa đơn | Không có yêu cầu thay đổi định dạng chứng từ/hóa đơn. |
| Ký số/HSM | Không có yêu cầu ký số hoặc chứng thư. |
| Java services | Không có yêu cầu thay đổi service Java hoặc tax integration. |
| .NET workers | Không có yêu cầu xử lý nền, mail, zip, PDF worker. |
| RabbitMQ/Kafka contracts | Không có queue/topic/message DTO trong scope. |
| Redis config secrets | Không thêm config/secret mới; chỉ dùng cơ chế ABP Redis hiện hữu nếu có. |
| EF migrations | Policy dự án không dùng EF migration cho bảng nghiệp vụ `vs_*`. |

## Rủi ro / Hạn chế đã biết / Known risks and limitations

| Rủi ro / hạn chế | Mức | Ghi chú / giảm thiểu |
|---|---|---|
| DB scope host-vs-tenant chưa hoàn toàn đồng nhất giữa source và DB docs snapshot | High | User chốt giống quốc tịch; source QuocTich là Host-side. Trước deploy SQL cần DBA/TechLead xác nhận DB thực tế. |
| Sai hành vi xóa | High | AC yêu cầu ngừng hiệu lực; AppService không được hard delete trong luồng UI. Testcase riêng cho delete/ngừng hiệu lực. |
| Cache Redis stale | Medium | Cache name/key riêng; clear sau Create/Update/Ngừng hiệu lực/Import. Manual test trước/sau mutation. |
| Permission sai | Medium/High | Dùng permission riêng tương tự quốc tịch; test role có/không quyền. |
| Export lộ dữ liệu ngoài scope | High | Helper export whitelist cột; không export audit/internal IDs/secrets/token/user info. |
| Import log/lỗi lộ raw file/base64 hoặc dữ liệu nhạy cảm | High | Không log `fileData`/raw Excel; sanitize/truncate file name and error messages. |
| Duplicate mã chỉ validate ở app nếu unique DB index không phù hợp legacy | Medium | Cần DBA quyết định unique index; AppService vẫn phải validate duplicate. |
| NSwag proxy lệch contract | Medium | Build backend trước generate, generate proxy theo quy trình repo, không sửa tay generated file. |
| Dòng seed pháp lý có dấu cách/format văn bản nghị định | Low/Medium | Dữ liệu seed lấy từ [expect.md](expect.md); nếu BA cập nhật câu chữ cần update SQL seed và testcase. |

## Đã kiểm chứng trong Rule 02 / Verified in Rule 02

- Layout check đã chạy từ workspace root: `cd /d/BILL && bash docs/scripts/check-layout.sh` → `== PASS — có thể bắt đầu phiên làm việc. ==`.
- Backend build đã chạy: `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln"` → `Build succeeded.`
- NSwag proxy đã generate theo quy trình repo: `angular/nswag/refresh.bat` → `Done.`
- Frontend type-check đã chạy: `.\node_modules\.bin\tsc -p src\tsconfig.json --noEmit` trong `D:\BILL\invoicemanagement\angular` → completed with no output.

## Chưa được kiểm chứng / Not verified

- Chưa verify DB thực tế host/tenant bằng connection thật; không được đưa connection string/secrets vào docs/logs.
- Chưa chạy SQL tạo bảng/seed trên DB dev/staging; cần TechLead/DBA xác nhận trước deploy.
- Chưa manual test UI/API trên môi trường có DB/Redis: mở menu, search/page/sort, thêm/sửa/ngừng hiệu lực, export/import, permission và cache invalidation.
- Chưa kiểm chứng rollback DB trên DB test.

## Kết luận / Conclusion

Impact tổng thể ở mức **High** chủ yếu do có bảng nghiệp vụ mới, seed/rollback, import/export file và cache Redis. Phạm vi thay đổi vẫn khu trú trong service `invoice-management`; không ảnh hưởng luồng lập/gửi chứng từ, XML/PDF, ký số, worker, queue hoặc Java service theo AC hiện tại. Sau Rule 02, code backend/frontend đã qua build/type-check cơ bản; điều kiện quan trọng trước deploy là DEV/TechLead/DBA xác nhận DB scope cho `vs_dm_ncc_loaictdt`, review SQL seed/rollback, và manual test hành vi ngừng hiệu lực/cache/import/export trên môi trường dev/staging.
