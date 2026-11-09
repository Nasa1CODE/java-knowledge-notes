# Project Profile — bản BillCloud (xBill/CyberBill HĐĐT)

> **File này là lớp PROFILE — phần swappable của kit.**
> `rules/`, `templates/`, `commands/`, `scripts/` là ENGINE generic, KHÔNG chứa fact dự án — chúng chỉ trỏ về file này + agent guide canonical + [conventions/](conventions/).
> Agent guide canonical (Service registry canonical, 17 mục theo template) là [AGENTS.md](AGENTS.md) trong docs branch hiện tại. Không dùng workspace-root `d:/BILL/AGENTS.md` vì `d:/BILL/` chứa nhiều hệ thống song song.
> Khi mâu thuẫn: [AGENTS.md](AGENTS.md) §4 (Service registry) và [specs/system.md](specs/system.md) là canonical; file này gom quy ước code/hạ tầng dùng chung.

## 1. Dự án

- **Tên:** bản triển khai Cloud (BillCloud) của hệ thống hóa đơn điện tử (HĐĐT) xBill/CyberBill.
- **Mục tiêu:** nền tảng HĐĐT **đa tenant**: doanh nghiệp lập → ký số → phát hành → gửi CQT → gửi khách hàng (mail/SMS) → tra cứu/xác thực → báo cáo; xử lý bất đồng bộ qua worker; sinh PDF/ZIP/XML/Excel.
- **Đặc thù Cloud:** nhiều dịch vụ độc lập (ASP.NET Zero/ABP + Java Spring Boot + .NET worker), định tuyến **master/tenant DB**, hàng đợi Kafka + RabbitMQ.

## 2. Service registry

Nguồn ánh xạ **local folder name → git repo → vai trò** là **[AGENTS.md](AGENTS.md) §4 Service registry** (chi tiết tên lệch ở [architecture.md](architecture.md) §3.1). Nguyên tắc:

- Luôn gọi service bằng **tên folder local** (vd `svinvoicesendemail/`, `invoice-management/`), KHÔNG dùng tên git repo.
- Khi tên repo/README lệch source thật (`svinvoicesendemail/`) → tin source code, ghi chú lệch vào docs.

## 3. Tech stack

| Tầng | Công nghệ |
|---|---|
| Edge Gateway | Java 8 · Spring Cloud Netflix Zuul · Dynamic routing by MST (`gateway-api-xbill`) |
| Auth Gateway | Java 21 · Spring Boot 3.2.4 · JJWT · Fast `/GetExternalToken` (`hotfixlogin`) |
| Identity & User | Java 8 · Spring Boot 2.7.5 · Keycloak 21 · MongoDB · TOTP OTP (`cyberidapiextenal`) |
| Backend ABP | C# · ASP.NET Zero (ABP) · .NET Core · EF Core (`api-cloud-service`, `api-qldv-service`, `bill-mobile-api`, `invoicemanagement`, `invoicecore`) |
| Java Microservices | Java 8 / 17 · Spring Boot · Spring Kafka · Spring Data JPA (`invoice-java-service`, `createxml-service`, `validate-signature-service`, `etran-teanant-service`, `hotfixlogin`, `cyberidapiextenal`); ký số bất đồng bộ qua CyberHSM (ngoài xBill, Kafka) |
| .NET Worker | C# · .NET Core Worker / Console · RabbitMQ MassTransit (`export-zip-pdf-service`, `invoice-sendmail-service`) |
| Frontend | Angular 6.x · TypeScript · ABP zero template · Metronic · PrimeNG · Bootstrap · NSwag proxy (`frontend_angular`, `searchbill`, `invoicemanagement`, `invoicecore`) |
| Mobile API | C# · ASP.NET Core API (`bill-mobile-api`) |
| Test Automation | Java 17 · Microsoft Playwright for Java · JUnit 5 · AssertJ (`xbillautotest`) |
| DB | MariaDB / MySQL — **master/host DB** (`invoicesys`) + **tenant DB** (dynamic routing theo tenant) |
| Cache | Redis (ABP RedisCache; captcha tra cứu công khai; CRL/OCSP cache) |
| Queue | RabbitMQ (MassTransit `EventBus.Messages` + worker RabbitMQ trực tiếp) |
| Stream | Kafka (message thuế/e-transaction CQT; sự kiện ký số; thông điệp hóa đơn) |
| Ký số | Cloud HSM / CyberHSM qua REST API (HMAC-SHA256 authenticated) |
| File | FTP / SFTP storage cấu hình (XML/PDF/ZIP lưu path, không lưu binary vào DB) |

> Stack legacy: Angular/TypeScript và .NET Core 2.1 trên một số service cũ. Không tự nâng version trong một feature nghiệp vụ.

## 4. Quy ước code — Backend ABP (ASP.NET Zero)

Chi tiết → [conventions/be-cloud.md](conventions/be-cloud.md). Tóm tắt:

- **Hai tầng project:** tầng nền ASP.NET Zero (`zero/` — user, role, tenant, setting, audit) và tầng nghiệp vụ (`hddt/`, `qlbh/`, `qlht/`, `dmkhachhang/` …).
- **DbContext nghiệp vụ:** thêm entity nghiệp vụ → đăng ký `DbSet` trong DbContext nghiệp vụ (vd `HDDTDbContext`).
- **Entity** đặt theo nhóm domain; tiền tố phổ biến: `HD_` (hóa đơn), `DM_NCC_` (danh mục do nhà cung cấp quản), `DMDoanhNghiep_` (danh mục doanh nghiệp), `DoanhNghiep_` (cấu hình DN), `Bangke_`/`Bc26ac_` (bảng kê/báo cáo), `ChungTu_`, `Service_` (bản ghi job).
- **AppService:** đặt ở `AppServices/<Module>/`, tên `*AppService`; endpoint sinh tự động qua ABP dynamic controller.
- **Endpoint prefix** cần tôn trọng: `/api/services/app/*`, `/api/services/hddt/*`, `/api/services/hddtws/*`, và endpoint tường minh như `/api/TokenAuth/*`.
- **Phân quyền:** kiểm qua `AppPermissions` (`*.Core/Authorization/`).
- **Đa tenant:** ABP multi-tenancy; query phải scope đúng tenant, không lộ dữ liệu chéo doanh nghiệp.

## 5. Quy ước code — Frontend (Angular)

Chi tiết → [conventions/fe-cloud.md](conventions/fe-cloud.md). Tóm tắt:

- **Module nghiệp vụ** ở `src/app/hddt/<nhóm>/`; route khai trong `*-routing.module.ts`.
- **Gọi API:** dùng service proxy sinh bởi NSwag (`src/shared/service-proxies/`). **Không sửa tay file sinh** — đổi contract ở backend rồi regenerate; đăng ký provider proxy trong `service-proxy.module.ts`.
- **Không hardcode URL backend** — lấy từ runtime config (`AppConsts` / `AppPreBootstrap`) để một bundle chạy nhiều môi trường; HDDV/GDDT dùng base URL riêng.
- Route có metadata permission → thêm/sửa màn hình phải kiểm cả route guard lẫn menu.

## 6. Quy ước — Java service & .NET worker

Chi tiết → [conventions/java-services.md](conventions/java-services.md), [conventions/dotnet-workers.md](conventions/dotnet-workers.md). Tóm tắt:

- **Java (Spring Boot):** giữ pattern controller/listener → service → repository → tenant-routing; **clear tenant context** sau khi thao tác master/tenant; parse XML thuế an toàn.
- **.NET worker:** resolve connection string tenant từ master/default DB trước khi truy cập dữ liệu tenant; ghi status/output path sau xử lý; giữ tương thích hợp đồng message (queue name, DTO); xử lý idempotent khi có retry.

## 7. Quy ước DB (MySQL/MariaDB master + tenant)

Chi tiết → [databases/README.md](databases/README.md). Tóm tắt:

- ⚠ **EF Migration KHÔNG quản lý schema nghiệp vụ.** **Đừng chạy `dotnet ef migrations add`** cho bảng `vs_*`. Thêm/đổi bảng phải có script SQL + rollback trong `deploy.md` của feature, do DBA/TechLead review.
- **Master/host DB vs tenant DB:** dữ liệu nghiệp vụ ở tenant DB; metadata tenant + connection string ở master/host DB. Worker/Java phải resolve tenant DB trước khi xử lý.
- **Soft delete:** ABP dùng cờ `IsDeleted`, không DELETE vật lý (trừ bảng log/lịch sử chỉ INSERT).
- **Tên entity ≠ tên bảng** — bảng thật là `vs_*`. Tra bảng ánh xạ trước khi viết SQL thuần.
- **File đính kèm (XML/PDF/ZIP) lưu FTP/file storage**, DB chỉ giữ path.
- **Backup trước khi đổi schema** — bắt buộc với staging/production.
- 1 file SQL / 1 bảng dưới [databases/](databases/): `databasehost.<table>.sql` hoặc `databasetenant.<table>.sql`.
- **Thêm cột mới:** mặc định cho phép `NULL`, trừ cột index (PK/unique/FK) phải `NOT NULL` — chi tiết [databases/README.md](databases/README.md).

## 8. Tích hợp ngoài & bảo mật

| Tích hợp | Nguồn cấu hình (chỉ ghi TÊN KHÓA) |
|---|---|
| Redis | `Abp:RedisCache:ConnectionString`, `Abp:RedisCache:DatabaseId` |
| Kafka | bootstrap servers / topic / group / SASL (theo config service) |
| RabbitMQ | host / exchange / queue / user / password (theo config service) |
| FTP / file storage | host / credential / path (theo config service) |
| Ký số/HSM | endpoint / key (theo config service) |
| Tham số hệ thống & endpoint tích hợp | bảng master `vs_dm_ncc_cauhinh` (theo `daily_id`) + Redis hash `QLCAUHINH` — quản trị tại `invoicemanagement` |

Kết nối ra ngoài chia 2 nhóm (chi tiết [architecture.md §5.4–5.5](architecture.md)):

- **Nội bộ hệ sinh thái xCyber / CyberLotus:** CyberID/Keycloak, xCyber UP/GDDT, BillStore (HĐ đầu vào), HDSD, CyberHSM, CBSign SignCenter (`KYXML_WS`/`KYPDF_WS`), QLBH/QLDV, tra cứu MST, apicheckbill, Odoo Helpdesk, SMTP relay CyberLotus, Gotenberg, XAdES verify.
- **Ngoài CyberLotus:** TCT/CQT qua T-VAN GATE, VPBank (vay thấu chi), MB Bank, Zalo OA, CA (CRL/OCSP), SMTP riêng của DN, T-VAN đối tác (đang tắt), link công khai (YouTube, eTax, reCAPTCHA).

- **Secrets KHÔNG bao giờ vào docs/code/log.** Config files hiện có phải coi là nhạy cảm.
- Không log JWT/token/password/XML nhạy cảm/dữ liệu khách hàng-thuế.
- Endpoint công khai (tra cứu) phải rà kỹ tránh lộ dữ liệu tenant.

## 9. Glossary nhanh

- **HĐĐT** — hóa đơn điện tử. **CQT** — cơ quan thuế. **DCTT** — dữ liệu chuyển thẳng. **Bảng kê** — bang ke.
- **NCC** — nhà cung cấp (Cyber). **DM** — danh mục. **Tenant/DN** — doanh nghiệp/khách thuê.
- **GATE** — cổng gửi CQT qua Kafka. **e-transaction / etran** — luồng message thuế (`etran-teanant-service`).
