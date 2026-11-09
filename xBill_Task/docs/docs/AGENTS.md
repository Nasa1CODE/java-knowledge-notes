# AGENTS.md — BillCloud (Docs-Canonical Project Agent Guide)

> Instantiated from `template-docs-prompt/AGENTS-TEMPLATE.md`. This is the **canonical agent guide inside the docs repo** for the BillCloud workspace/branch. Do not create a full-content workspace-root `AGENTS.md`; a short navigation stub (≤ 15 lines) that redirects to this file is acceptable. Do not create per-service `AGENTS.md` files. When a fact is unknown it is written `TBD — owner: <name>` instead of guessed.
>
> **Pattern A:** `docs/AGENTS.md` is canonical per docs branch/system. The workspace root (`bill_cloud/`) may contain a navigation stub that points here, but all workflow instructions live in this file only. If the parent folder hosts multiple systems side by side, a root-level full-content AGENTS.md would be ambiguous — keep only this canonical file.

---

## 0. File metadata [REQUIRED]

```yaml
project: BillCloud (xBill/CyberBill HĐĐT — bản Cloud)
doc_version: 1.0.0
updated_at: 2026-08-31
owner: TBD — TechLead
docs_repo: http://10.30.1.17/xBill/docs.git
ticket_prefix: CBCLOUDV2
docs_branch: docs/hungtq_dev_cloud
language_for_ai_replies: Vietnamese
canonical_agent_guide: docs/AGENTS.md
```

---

## 1. Project overview [REQUIRED]

**BillCloud** is the multi-tenant Cloud deployment of the xBill/CyberBill electronic-invoice (HĐĐT) platform.

**Business goal:** let an enterprise create → digitally sign → issue → send to the tax authority (CQT) → deliver to the customer (mail/SMS) → look up/verify → report an invoice, with asynchronous processing via workers and PDF/ZIP/XML/Excel generation.

**Main capabilities:**
- Invoice lifecycle (create/sign/issue/adjust/replace/cancel) across ASP.NET Zero/ABP services.
- Tax e-transaction & GATE CQT messaging (Kafka), bảng kê / DCTT (Java service).
- Public bill lookup/verification (`searchBill`, `invoicecore/TraCuu`) and async workers (email, export ZIP/PDF, import/print/XML).

**Customer / stakeholders:** Vietnamese enterprises issuing e-invoices; internal owner team `TBD — owner: TechLead`.

**Out of scope for this workspace:** MSP, Liên Sơn, FUTA, and any other xBill docs branch unless a feature explicitly states a cross-port.

---

## 2. Session start protocol [REQUIRED]

Read in this exact order **before** planning, coding, testing, or reviewing:

1. Run `bash docs/scripts/check-layout.sh` (fail-fast on missing base docs), then `git pull` inside `docs/`.
2. `docs/AGENTS.md` (this file) — canonical agent guide for the current docs branch/system.
3. `docs/README.md` — the spec-driven workflow and the ENGINE/PROFILE/CONTENT layering.
4. `docs/architecture.md` — services, integrations, queues, storage, auth.
5. `docs/specs/system.md` (index `docs/specs/README.md`) — the business domain(s) touched by the task.
6. The rule matching the work + its project-config companion (see §9). Missing project-config → **STOP**, offer to generate from `*.project-config.template.md`.
7. `docs/design.md` — **only if** the task changes UI.
8. `docs/features/<TICKET-ID>/` — if the task belongs to a ticket.

**Do not start writing code before steps 1–6 are done.**

> **Scope:** these steps apply **once per working session** (or after a long
> pause, a branch switch, or a `git pull` that changed base docs). If all
> steps were completed earlier in the same session and no branch or file
> changes occurred since, re-reading is recommended but not required before
> each individual task.

---

## 3. Workspace layout [REQUIRED]

Each row is an independently cloned git repository sitting beside `docs/`. The workspace root (`bill_cloud/`) is **not** a git repo and may contain multiple systems side by side, so the canonical agent guide must live in each docs branch at `docs/AGENTS.md`.

```text
bill_cloud/                         ← workspace root (NOT a git repo)
├── AGENTS.md                       ← navigation stub only → see docs/AGENTS.md
├── docs/                           ← docs repo (branch docs/hungtq_dev_cloud) — source of truth
│   ├── AGENTS.md                   ← this file (canonical for BillCloud)
│   ├── README.md                   ← spec-driven workflow
│   ├── architecture.md             ← overall architecture
│   ├── design.md                   ← UI/UX + design system
│   ├── project.md                  ← project profile (stack, conventions summary)
│   ├── specs/                      ← business flows (system.md + index)
│   ├── rules/                      ← AI operating rules (00 → 04) + *.project-config.md
│   ├── conventions/                ← per service-group coding conventions
│   ├── commands/                   ← slash-command catalog
│   ├── databases/                  ← schema, one SQL file per table
│   ├── features/                   ← one folder per ticket
│   └── reference/                  ← reference material, NOT read by default
├── frontend_angular/               ← main web portal
├── invoicemanagement/              ← Admin Cloud / MSP portal (+ tham số hệ thống vs_dm_ncc_cauhinh)
├── invoicecore/                    ← aspnet-core/ + angular/ + TraCuu/
├── api-cloud-service/              ← core cloud invoice ABP backend
├── api-qldv-service/               ← service provider management backend
├── bill-mobile-api/                ← mobile backend API
├── gateway-api-xbill/              ← Zuul API Gateway (port 8099)
├── hotfixlogin/                    ← auth service GetExternalToken → JWT ABP (:8609, sau gateway)
├── cyberidapiextenal/              ← CyberID / Keycloak / OTP integration (port 8089)
├── invoice-java-service/           ← high-throughput Java invoice creation engine
├── createxml-service/              ← Circular 78 XML generator service
├── validate-signature-service/     ← signature & certificate validation service
├── etran-teanant-service/          ← tax e-transaction Kafka message processor
├── export-zip-pdf-service/         ← .NET worker for PDF/ZIP export
├── invoice-sendmail-service/       ← .NET worker for invoice email delivery
├── importbillhostservice/          ← .NET worker import (queue ImportDatas(Cloud))
├── exportbillhostservice/          ← .NET worker export (queue ExportData)
├── svinvoicesendemail/             ← mail legacy (SendMail/SendMailCRM) + PrintBill + tải XML
├── searchbill/                     ← public bill search & lookup frontend
├── (xbillautotest/)                ← Playwright E2E suite — NOT in workspace
└── docs/                           ← documentation source of truth
```

**Naming rule [REQUIRED]:** the **local folder name is the canonical name** used everywhere in docs, plans, tasks and reports. Never refer to a service by its git repository name or its README title. When the repo name / README disagrees with the actual source code, **the source code wins** — and the discrepancy is recorded in `docs/architecture.md` §3.1.

---

## 4. Service registry [REQUIRED]

> This table is the **only** source for mapping a service to a path. Never guess a service from folder names, grep, or name similarity. Canonical detail lives in this file and branch-specific architecture docs.

| service-key (= local folder) | Repo path | Git repository | Role | Runtime / port | Datastore |
|---|---|---|---|---|---|
| `gateway-api-xbill` | `./gateway-api-xbill` | `xBill/gateway-api-xbill` | Zuul API Gateway, dynamic routing by MST | Spring Cloud Zuul · port `8099` | MariaDB (HT2 `vs_checkhethong`, `vs_nguoidung`) |
| `hotfixlogin` | `./hotfixlogin` | `xBill/hotfixlogin` | Fast `/GetExternalToken` and ABP JWT issuance | Spring Boot 3 / Java 21 · port `8609` | MariaDB master (`vs_nguoidung`, `abptenants`) |
| `cyberidapiextenal` | `./cyberidapiextenal` | `cyberid/cyberidapiextenal` | CyberID / Keycloak user & password validation | Spring Boot 2.7 / Java 8 · port `8089` | MongoDB + Keycloak IDP |
| `api-cloud-service` | `./api-cloud-service` | `xBill/api-cloud-service` | Core cloud invoice API backend | ASP.NET Zero / ABP · port `5002` | MariaDB master + tenant DB |
| `api-qldv-service` | `./api-qldv-service` | `cloudinvoicesys/api-qldv-service` | QLDV service management backend | ASP.NET Zero / ABP · port `5002` | MariaDB master + tenant DB |
| `bill-mobile-api` | `./bill-mobile-api` | `xBill/bill-mobile-api` | Mobile backend API (`aspnet-core/`) | ASP.NET Core · port `5000` | MariaDB master + tenant DB |
| `invoice-java-service` | `./invoice-java-service` | `xBill/invoice-java-service` | Public-asset invoices, copy, draft signing | Spring Boot / Java 17 · HTTP `6782`, gRPC `6783` | MariaDB tenant DB (routed) |
| `createxml-service` | `./createxml-service` | `xBill/createxml-service` | Circular 78 XML generator | Spring Boot / Java 17 · HTTP `8760`, gRPC `8761` | MariaDB tenant DB (routed) |
| `validate-signature-service` | `./validate-signature-service` | `xBill/validate-signature-service` | Signature and certificate validator | Spring Boot / Java 17 · port `8085` (NodePort `30086`) | CRL/OCSP cache |
| `etran-teanant-service` | `./etran-teanant-service` | `etran/etran-teanant-service` | Tax e-transaction Kafka message processor | Spring Boot / Java 8 · port `8600` | MariaDB tenant DB (routed) + Kafka |
| `export-zip-pdf-service` | `./export-zip-pdf-service` | `xBill/export-zip-pdf-service` | Asynchronous PDF/ZIP invoice worker | .NET Core Worker / RabbitMQ | MariaDB tenant DB + FTP |
| `invoice-sendmail-service` | `./invoice-sendmail-service` | `cloudinvoicesys/invoice-sendmail-service` | Invoice email delivery worker | .NET Core Worker / RabbitMQ | MariaDB tenant DB + SMTP |
| `importbillhostservice` | `./importbillhostservice` | `cloudinvoicesys/importbillhostservice` | Import worker — queue `ImportDatas(Cloud)` (tách từ svinvoicesendemail 2026-10-09) | .NET Console / `RabbitMQ.Client` | MariaDB master + tenant DB, FTP |
| `exportbillhostservice` | `./exportbillhostservice` | `cloudinvoicesys/exportbillhostservice` | Export worker — queue `ExportData` (tách từ svinvoicesendemail 2026-10-09) | .NET Console / `RabbitMQ.Client` | MariaDB master + tenant DB, FTP |
| `svinvoicesendemail` | `./svinvoicesendemail` | `cloudinvoicesys/svinvoicesendemail` | Phần còn lại: mail legacy (`SendMail`, `SendMailCRM`), PrintBill (`PrintPDFData`), tải XML | .NET Console / `RabbitMQ.Client` | FTP + SMTP + MariaDB |
| `frontend_angular` | `./frontend_angular` | `cloudinvoicesys/frontend_angular` | Main enterprise invoicing web portal | Angular 6 / TS · Nginx static 80/443 | — |
| `invoicemanagement` | `./invoicemanagement` | `cloudinvoicesys/invoicemanagement` | Admin Cloud / MSP portal, system parameters (`vs_dm_ncc_cauhinh` → Redis `QLCAUHINH`) | ASP.NET Zero + Angular | MariaDB master + tenant DB |
| `invoicecore` | `./invoicecore` | `cloudinvoicesys/invoicecore` | Integrated legacy code base | ASP.NET Zero + Angular + TraCuu | MariaDB master + tenant DB |
| `searchbill` | `./searchbill` | `cloudinvoicesys/searchbill` | Public bill lookup & verification portal | Angular / TS · port `8600` | — |
| `xbillautotest` | *not in workspace* | `xBill/xbillautotest` | Automated E2E testing suite (Playwright) | Java 17 + Playwright · CLI | Chromium / WebKit |
| `docs` | `./docs` | `xBill/docs` | Documentation source of truth | Markdown / Mermaid | — |

**Shared infrastructure:** MySQL/MariaDB (master/host DB + per-tenant DB, routed); Redis (ABP RedisCache, public-lookup captcha); RabbitMQ (MassTransit `EventBus.Messages` + direct worker queues); Kafka (tax/e-transaction, GATE CQT); Cloud HSM/digital-signature HTTP endpoint; FTP/SFTP storage (XML/PDF/ZIP; DB stores only the path).

> Ký số XML bất đồng bộ (Kafka `xbill-signing-in`) do **CyberHSM** thuộc hệ sinh thái CyberLotus xử lý — không phải service xBill. `bangke-dctt-java-service` và `invoice-senddata2tct-service` đã ngừng sử dụng (2026-10-09). Phân tầng mạng (tầng 1 public / tầng 2 nội bộ) xem `docs/architecture.md` §5.0.
>
> Ports above are from DEV/DEMO config in each repo (see `docs/architecture.md` §5.1 and `docs/deploy/`); PROD ports come from systemd/Nginx/K8s and must be confirmed. Rows marked *not in workspace* are referenced by runtime flows but their source is not cloned here.

### Service resolution rules [REQUIRED]

1. The target service is always **explicitly declared**, in this priority order: `plan.md` front-matter `service:` → the `Service` column of the row in `tasks.md` → the user stating it in the session.
2. **Never** discover or guess the target service by grep / glob / folder-name similarity.
3. Only touch files inside the `Repo path` mapped from the `service-key` above.
4. "Undeclared" means: not present in `plan.md` front-matter `service:`, **and** not present in the `Service` column of `tasks.md`, **and** not stated by the user in this session. If the service is undeclared by all three sources, the resolved key does not match the registry, or one task spans more than one repo without saying so → **STOP and ASK**.
5. When a task legitimately spans several services, handle each repo separately using its own path.

---

## 5. Tech stack [REQUIRED]

| Group | Framework / stack | Language | Auth | Build & run |
|---|---|---|---|---|
| Edge Gateway (`gateway-api-xbill`) | Spring Cloud Netflix Zuul | Java 8 | MST lookup in DB (`vs_checkhethong`) | `mvn clean package` |
| Auth Gateway (`hotfixlogin`) | Spring Boot 3.2.4 · JJWT | Java 21 | Keycloak via CyberID + Master DB | `mvn clean package` |
| Identity (`cyberidapiextenal`) | Spring Boot 2.7.5 · Keycloak Admin | Java 8 | Keycloak OIDC + MongoDB | `mvn clean package` |
| Backend ABP (`api-cloud-service`, `api-qldv-service`, `bill-mobile-api`, `invoicemanagement`, `invoicecore`) | ASP.NET Zero (ABP) · .NET Core · EF Core | C# | ABP multi-tenancy + JWT (`/api/TokenAuth/*`) | `dotnet build <sln>` / `dotnet run` |
| Frontend (`frontend_angular`, `searchbill`, `invoicemanagement/angular`, `invoicecore/angular`) | Angular · ABP zero template · Metronic · PrimeNG · Bootstrap · NSwag proxy | TypeScript | JWT via proxy | `npm install` / `npm run build` |
| Java Microservices (`invoice-java-service`, `createxml-service`, `validate-signature-service`, `etran-teanant-service`) | Spring Boot · Spring Kafka · Spring Data JPA | Java 8 / 17 | Dynamic tenant routing (`TenantContext`) | `mvn -q -DskipTests package` |
| .NET Workers (`export-zip-pdf-service`, `invoice-sendmail-service`, `importbillhostservice`, `exportbillhostservice`, `svinvoicesendemail`) | .NET Core Worker / Console · RabbitMQ | C# | Tenant connection resolved from master DB | `dotnet build <csproj/sln>` |
| Test Automation (`xbillautotest`) | Playwright for Java · JUnit 5 · AssertJ | Java 17 | Headless browser context | `mvn test` |

### Cross-cutting technology
- **Database:** MySQL / MariaDB — master/host DB + per-tenant DB (routed); ORM EF Core (ABP), JPA (Java). **No EF migration for business `vs_*` schema.**
- **Cache:** Redis (ABP RedisCache; public-lookup captcha).
- **Queue / messaging:** RabbitMQ (MassTransit `EventBus.Messages` + direct worker queues) and Kafka (tax/e-transaction, GATE CQT) — contracts listed in `docs/architecture.md`.
- **Object/file storage:** FTP / file storage (XML/PDF/ZIP; DB keeps only the path).
- **Signing:** HSM / digital signature over a configured HTTP endpoint.
- **CI/CD:** `TBD — owner: DevOps`.

> Legacy Angular/TypeScript — do not upgrade framework/library versions inside a business feature.

---

## 6. Source-of-truth map [REQUIRED]

| Question to answer / thing to change | Read this first |
|---|---|
| Architecture, services, external integrations, queues, storage, auth | `docs/architecture.md` |
| Business logic, input/output, state machine, permissions | `docs/specs/system.md` (index `docs/specs/README.md`) |
| UI/UX, layout, component, theme | `docs/design.md` |
| DB schema / table / data (`vs_*`) | `docs/databases/README.md` + the table's `docs/databases/*.sql` |
| Service-group coding convention | `docs/conventions/<group>.md` (`be-cloud`, `fe-cloud`, `java-services`, `dotnet-workers`) |
| A specific ticket | `docs/features/<TICKET-ID>/` |
| How the AI must operate | `docs/rules/*.md` + `docs/rules/*.project-config.md` |
| Reference / legacy material | `docs/reference/` — **not read by default** |

**Reading budget rules:**
- Do **not** read `docs/databases/databasehost.*.sql` / `databasetenant.*.sql` in full — grep only the tables the feature touches.
- Do **not** read `docs/reference/` by default.
- Do **not** read generated/build output (NSwag proxies, `bin/`, `obj/`, `target/`, `dist/`).

---

## 7. Business domain map [OPTIONAL but recommended]

| # | Domain | Backend module / service | Frontend feature | Spec |
|---|---|---|---|---|
| 1 | Hóa đơn điện tử (HĐĐT) — lập/ký/phát hành/điều chỉnh | `invoicecore/aspnet-core` (`hddt/`), `api-cloud-service` | `frontend_angular` `src/app/hddt/` | `docs/specs/system.md` |
| 2 | Tra cứu / xác thực công khai | `invoicecore/TraCuu` | `searchBill` | `docs/specs/system.md` |
| 4 | E-transaction thuế / GATE CQT | `etran-teanant-service` (Kafka) | — | `docs/specs/system.md` |
| 5 | Quản trị dịch vụ (admin) | `invoice-management/aspnet-core` | `invoice-management/angular` | `docs/specs/system.md` |
| 6 | Async workers (email, export ZIP/PDF, import/print/XML) | `invoice-sendmail-service`, `export-zip-pdf-service`, `importbillhostservice`, `exportbillhostservice`, `svinvoicesendemail` | — | `docs/specs/system.md` |

> `docs/specs/` is currently a single `system.md`; split per domain when it grows (see `docs/rules/00-init-docs.md`).

---

## 8. Feature workflow [REQUIRED]

### 8.1 Feature folder model

Every unit of work lives under `docs/features/<TICKET-ID>/` (folder name = ticket, e.g. `CBCLOUDV2-8963`) using lowercase file names.

| File | Owner | Content |
|---|---|---|
| `expect.md` | BA | Expected behavior, actors, measurable acceptance criteria, out-of-scope, open questions. **Owns the feature lifecycle status.** |
| `plan.md` | DEV + AI | Implementation design; requires Gate 1 approval before any code; keeps its own `plan-status`. |
| `tasks.md` | DEV + AI | Tasks split by service (block format + overview table), each with a `Service` column and word-form status. |
| `testcase.md` | AI | Test scenarios generated **from `expect.md`**, not from `plan.md`. |
| `impact.md` | AI + DEV | Affected components, confirmed-unaffected areas, risks, unverified items. |
| `report.md` | AI | Real changed files, real verification output, follow-ups — never a narrated guess. |
| `deploy.md` | DEV | Created **only** when DB / config / environment / queue changes exist. |

### 8.2 Lifecycle and gates

```text
draft ──► plan-review ──► approved ──► in-progress ──► testing ──► done
                                              │
                                              └──► cancelled
```

- **Gate 1 — Plan review:** `plan.md` must be self-reviewed by DEV and approved by TechLead (name + date + commit/PR link in the "Approval (Gate 1)" block) before implementation. Only then does `expect.md` status become `approved`. **The AI never sets `approved` itself.**
- **Gate 2 — Docs update review:** the AI may only **propose** a diff to `docs/specs/`, `docs/architecture.md`, `docs/databases/`, `docs/design.md`. TechLead approves the MR before merge. Reason: wrong docs poison every later plan.

### 8.3 Status values [REQUIRED — word form, not `[ ]`/`[x]`]

| Where | Allowed values |
|---|---|
| `expect.md` feature status (single source) | `draft` · `plan-review` · `approved` · `in-progress` · `testing` · `done` · `cancelled` |
| `plan.md` `plan-status` (Gate 1) | `draft` · `plan-review` · `approved` |
| `tasks.md` task status | `pending` · `in-progress` · `completed` · `blocked` · `cancelled` (a `cancelled` task records its reason) |

`tasks.md` uses **block format** per `docs/templates/tasks.md` (overview table + one block per task), not checklist markers.

### 8.4 Definition of Done [REQUIRED]

A feature must **not** be `done` while any of these is true:
- `expect.md` lacks clear acceptance criteria.
- `plan.md` lacks the two Gate 1 signatures.
- A task in `tasks.md` is not `completed`/`cancelled` (with reason).
- `impact.md` is not finalized against the real blast radius.
- `report.md` has no real verification output.
- Business logic / schema changed but the Gate 2 docs diff is not proposed/approved.
- A DB / config / queue change exists but there is no `deploy.md`.

### 8.5 Definition of Ready — before writing a plan [REQUIRED]

Before creating `plan.md`, verify `expect.md` has measurable acceptance criteria, out-of-scope, actors, inputs, outputs, and state transitions. If anything is missing or a blocking business/architecture/data/permission question exists → **STOP, ask DEV/BA.** Write only a blocking draft (`status: draft` + `Blocking questions`), not detailed design.

### 8.6 If work is left unfinished

Report: current status, remaining tasks, blockers, and any repo/branch/file with an unclean working tree.

---

## 9. Rule index [REQUIRED]

| Rule file | When to run | Input | Output |
|---|---|---|---|
| `docs/rules/00-init-docs.md` | Bootstrap or refresh base docs | Source of all services | `architecture.md`, `specs/*`, `databases/*`, `design.md` |
| `docs/rules/01-create-plan.md` (+ `01-create-plan.project-config.md`) | `expect.md` exists | `expect.md` + base docs | `plan.md`, `tasks.md`, `impact.md` (draft) |
| `docs/rules/02-implement-task.md` (+ `02-implement-task.project-config.md`) | Plan approved (Gate 1) | `tasks.md` | Code + `report.md` + `deploy.md` + docs diff |
| `docs/rules/03-create-testcase.md` | After plan, before code | `expect.md` | `testcase.md` |
| `docs/rules/04-create-impact.md` | Draft during planning; finalize after code | `expect.md`, `plan.md`, source | `impact.md` |

**Config contract:** rules 01 & 02 are generic ENGINE — they resolve every project fact via `{{KEY}}` from their `*.project-config.md` companion. Missing companion → **STOP**, offer to generate from `*.project-config.template.md`. There is **no** dedicated DB-migration rule: DB policy = `docs/project.md` §7 + `docs/databases/README.md`, and the reviewed SQL + rollback go in the feature `deploy.md`. Docs-update is Gate 2 inside rule 02.

How to invoke (Claude Code): register slash commands in `docs/commands/` — e.g. `/create-plan CBCLOUDV2-1234`.

---

## 10. Service quick rules [REQUIRED]

| Group | Read the source in this order | Verification command | Constraints |
|---|---|---|---|
| Backend ABP | `AppServices/<Module>/*AppService` → Manager/Domain → EF repository → Entity → business `DbContext` (`DbSet`) → SQL (`vs_*`) → `AppPermissions` | `dotnet build <sln>` (+ `dotnet test` where a suite exists) | ABP layering; no business logic in controllers; scope every query to the tenant; entity name ≠ table (`vs_*`) |
| Angular | `*-routing.module.ts` → component → NSwag proxy (`src/shared/service-proxies/`) → model → i18n → style | `tsc -p src/tsconfig.json --noEmit` and/or `npm run build` | Never hand-edit generated proxies; no hardcoded backend URL (use `AppConsts`/`AppPreBootstrap`); route guard + menu must match permissions |
| Java Spring Boot | controller/listener → service → repository (tenant routing) → entity → request/response DTO → kafka producer/consumer → config | `mvn -q compile` (+ `mvn -q test -Dtest=<Class>`) | Clear tenant context after master/tenant work; parse tax XML safely |
| .NET worker | consumer/handler → resolve tenant connection string (from master/default DB) → service → status/output-path write → queue/DTO contract → config | `dotnet build <csproj/sln>` + the manual message/queue check that triggers it | Keep message contract (queue/topic + DTO) stable; idempotent under retry |

Encoding: **UTF-8 without BOM**. Comments/messages in **Vietnamese** (matching surrounding code). After editing code, run the group's verification command; a check that cannot be run is reported `N/A` with a verifiable reason.

---

## 11. Agent working rules [REQUIRED]

### Scope and safety
- Never implement anything outside the approved `expect.md` / `plan.md` / `tasks.md` scope.
- Keep `plan.md` and `tasks.md` current while work progresses.
- Draft `impact.md` during planning; finalize after implementation to reflect the real blast radius.
- `report.md` must contain **real** changed files and **real** verification output — never a narrated guess.
- Never copy secrets, keys, tokens, or connection strings from config into documentation, code samples, or logs — record only config **key names**. Never log JWT/token/password/sensitive XML/customer-tax data.
- **Multi-tenant isolation is a hard constraint:** verify no cross-tenant leak on every data-touching change; public lookup (`searchBill`, `invoicecore/TraCuu`) gets extra scrutiny.
- Never edit generated / build output unless explicitly requested.
- When the AI lacks write permission for a required path, **ask for write access to that exact path**; do not silently substitute another location.

### Code conventions
- Respect existing layering: `AppService → Manager/Domain → repository` (backend), `component → proxy → model` (frontend), `controller/listener → service → repository` (Java), `consumer → tenant-resolve → service` (.NET worker).
- Never put business logic in controllers or UI components.
- Preserve existing conventions of each framework (ABP/Angular/Spring Boot/.NET worker); details in `docs/conventions/<group>.md`.
- Write files as UTF-8 without BOM; answers and comments in Vietnamese.
- After editing code, run the group's verification command from §10.

### i18n
The product is Vietnamese-first; there is no company-wide multi-locale requirement. A feature is **not** required to add a second locale — but when it touches a screen/module that **already** uses ABP/Angular localization, keep using that mechanism (do not hardcode strings into a module that localizes them). If a feature's `expect.md` demands multi-language output, treat i18n as in-scope and confirm the locale set with the TechLead. `TBD — owner: TechLead` — confirm whether any customer requires `en` output.

### UI layout contract
UI changes follow `docs/design.md` and `docs/conventions/fe-cloud.md`; prefer existing Metronic/PrimeNG components and custom classes over writing new styles. Deviate only when the existing component of that flow requires it.

---

## 12. Code-impact tooling [OPTIONAL]

**None in use** (`IMPACT_TOOL = none`). Read the real code and `git diff` manually and apply the severities in `docs/rules/01-create-plan.project-config.md` §8. Known blast radii: message-contract change (producer + all consumers) 🔴; shared `vs_*` table 🔴; auth/`AppPermissions`/tenant scoping 🔴; public lookup endpoint 🔴; NSwag-consumed API contract 🟡; tax XML/export template 🟡; one leaf worker's internal logic 🟢.

---

## 13. Project skills [OPTIONAL]

`TBD — owner: TechLead`. Domain skills, if any, live under `docs/superpowers/`; invoke the matching skill instead of improvising when one applies.

---

## 14. Command shorthand [OPTIONAL]

Slash commands live in `docs/commands/` (not a single `commands.md`). When the user types `/<name> [args]`, execute the mapped command.

| Shorthand | Command in `docs/commands/` |
|---|---|
| `/init-docs` | `init-docs.md` |
| `/create-plan <FEATURE>` | `create-plan.md` |
| `/create-testcase <FEATURE>` | `create-testcase.md` |
| `/create-impact <FEATURE>` | `create-impact.md` |
| `/implement-task <FEATURE>` | `implement-task.md` |

`<FEATURE>` defaults to `docs/features/<FEATURE>/`. If a shorthand is ambiguous, ask before running.

---

## 15. Git rules [REQUIRED]

### Branch convention
- Branch name: `feature/<TICKET-ID>` — **the same name in every repo** involved (services + docs); no per-service suffix. Ticket prefix `CBCLOUDV2`. docs working branch: `docs/hungtq_dev_cloud` (base `docs/xbill-cloud`).
- Check the current branch before starting a ticket; if it is wrong, **ask before creating or switching**.
- Never create/switch branches while there are uncommitted or unstashed changes.
- Only create branches in repos actually in scope of the approved plan.
- Before planning, moving to implementation, or coding: check every repo listed in `services-affected` of the current `plan.md` (or every repo the user named in this session if no plan exists yet). If any of those repos has uncommitted/unpushed work or sits on a different feature branch → **STOP and report** repo name, current branch, changed files, commit/push state. Repos outside the plan's `services-affected` scope are not checked unless the user explicitly asks.

### Commit / push
1. `git status` in the affected repo; review `git diff` and `git diff --staged`.
2. Commit message format: `<TICKET-ID>: short description` (e.g. `CBCLOUDV2-8963: add nationality catalog`). Ticket ID in every commit.
3. Record the commit/PR link in `tasks.md` / `report.md`.
4. The agent **may not** commit, push, merge, or deploy on its own — only when explicitly asked.

### Merge / deploy
- Integration branch, deploy branch, environments, and who may deploy to each: `TBD — owner: TechLead / DevOps`.
- CI/CD: `TBD — owner: DevOps`. Do not deploy manually unless explicitly asked.

**Hard stop:** if the diff contains files outside the task scope, or anything that looks like a secret or runtime config, stop and ask before committing, pushing, merging, or deploying.

---

## 16. Do not modify unless explicitly requested [REQUIRED]

- Generated NSwag proxies (`service-proxies.ts`), EF-generated files, other generated clients.
- `bin/`, `obj/`, `target/`, `build/`, `dist/`, `node_modules/`.
- `.env*`, secrets, keys, tokens, certificates, runtime config.
- Lock files (unless the task is a dependency change).
- Legacy copy folders (`* - Copy/`, `*-old/`) and imported legacy docs.
- The `zero/` ASP.NET Zero platform layer — preserve the pattern; do not refactor or bump versions inside a business feature.
- Business `vs_*` schema via `dotnet ef migrations add` — **never**. Schema changes go through a reviewed SQL script + rollback in `deploy.md`.

---

## 17. Quick links [REQUIRED]

- [README.md](README.md) — spec-driven workflow
- [architecture.md](architecture.md) — architecture & integrations
- [design.md](design.md) — UI/UX design system
- [project.md](project.md) — project profile (stack/conventions)
- [specs/system.md](specs/system.md) — business specs (index [specs/README.md](specs/README.md))
- [rules/](rules/) — AI operating rules + project-config
- [conventions/](conventions/) — per-group coding conventions
- [databases/README.md](databases/README.md) — schema (one SQL file per table)
- [features/](features/) — ticket folders
- [commands/](commands/) — slash-command catalog
- Docs repo: `http://10.30.1.17/xBill/docs.git`
