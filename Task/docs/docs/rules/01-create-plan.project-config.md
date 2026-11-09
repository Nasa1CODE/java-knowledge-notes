# Project Config — Rule 01 Create Plan (BillCloud)

> Companion file for `docs/rules/01-create-plan.md`. The rule is generic (ENGINE); **this file carries every project-specific fact the rule needs.**
> Canonical sources this file summarizes: **`docs/AGENTS.md` §4 service registry**, **`docs/project.md`** (stack/conventions), **`docs/conventions/`**, **`docs/databases/README.md`**. When this file and a canonical source disagree, the canonical source wins — fix this file.
> **Porting the workflow to a new project = rewriting this file only. Never edit the rule.**

```yaml
project: BillCloud (xBill/CyberBill HĐĐT — bản Cloud)
config_version: 1.0.0
updated_at: 2026-08-31
owner: TBD — TechLead
```

Keys marked **[REQUIRED]** must have a real value. Keys marked **[OPTIONAL]** may be `none` — but must stay present, so the agent knows they were considered. `TBD — owner: <name>` marks a fact still to be confirmed with the team; do not guess past it.

---

## 1. SERVICE_TAGS [REQUIRED]

The **canonical tag is the local folder name** (per `docs/AGENTS.md` naming rule, §3) — used in `plan.md` front matter and in the `Service` column of `tasks.md`. Never use the git repo name as the tag. Full mapping + naming-conflict rules live in `docs/AGENTS.md` §3–§4 Service registry.

| Tag (= local folder) | Git repo | Stack | Role |
|---|---|---|---|
| `frontend_angular` | `cloudinvoicesys/frontend_angular` | Angular / TS | Main frontend portal |
| `searchBill` | `cloudinvoicesys/searchbill` | Angular / TS | Public bill search frontend |
| `invoicecore` | `cloudinvoicesys/invoicecore` | ASP.NET Zero/ABP + Angular + TraCuu | Core backend + FE + lookup (`aspnet-core/`, `angular/`, `TraCuu/`) |
| `invoice-management` | `cloudinvoicesys/invoicemanagement` | ASP.NET Zero/ABP + Angular | Admin portal (`aspnet-core/` + `angular/`) |
| `api-cloud-service` | `xBill/api-cloud-service` | ASP.NET Zero/ABP | Cloud API service |
| `api-qldv-service` | `cloudinvoicesys/api-qldv-service` | ASP.NET Zero/ABP | QLDV API service |
| `etran-teanant-service` | `etran/etran-teanant-service` | Java Spring Boot / Kafka | Tax e-transaction (message) service |
| `export-zip-pdf-service` | `xBill/export-zip-pdf-service` | .NET worker | Export ZIP/PDF worker |
| `importbillhostservice` | `cloudinvoicesys/importbillhostservice` | .NET worker | Import worker (queue `ImportDatas(Cloud)`) |
| `exportbillhostservice` | `cloudinvoicesys/exportbillhostservice` | .NET worker | Export worker (queue `ExportData`) |
| `svinvoicesendemail` | `cloudinvoicesys/svinvoicesendemail` | .NET worker | Mail legacy + PrintBill + XML download (import/export đã tách sang 2 repo trên) |
| `invoice-sendmail-service` | `cloudinvoicesys/invoice-sendmail-service` | .NET worker / RabbitMQ | Invoice email sending worker |
| `docs` | `xBill/docs` | — | Documentation source of truth |

> Ports are not deployment-stable in this workspace (dev runs vary); resolve the actual port from the service's own launch config when needed, not from this table.

---

## 2. LAYER_READ_ORDER [REQUIRED]

The order in which the agent must trace source files, per stack. Details per group live in `docs/conventions/<group>.md`.

| Stack | Read order | Convention doc |
|---|---|---|
| Backend — ASP.NET Zero / ABP | `AppServices/<Module>/*AppService` → Manager/Domain → EF Core repository → Entity → business `DbContext` (`DbSet`) → SQL script (`vs_*` table) → `AppPermissions` | `docs/conventions/be-cloud.md` |
| Frontend — Angular | `*-routing.module.ts` → component → NSwag service proxy (`src/shared/service-proxies/`) → model → i18n → style | `docs/conventions/fe-cloud.md` |
| Java — Spring Boot | controller/listener → service → repository (tenant routing) → entity → request/response DTO → kafka producer/consumer → config | `docs/conventions/java-services.md` |
| .NET worker | consumer/handler → resolve tenant connection string (from master/default DB) → service → status/output-path write → queue/DTO contract → config | `docs/conventions/dotnet-workers.md` |

Cross-cutting rules the plan must respect (see `docs/project.md` §4–7):
- Multi-tenant: every query scoped to the correct tenant; never leak cross-tenant data. Public lookup endpoints (`searchBill`, `TraCuu`) get extra scrutiny.
- Entity name ≠ table name — real tables are `vs_*`. Resolve the mapping before writing SQL.
- Never edit NSwag-generated proxies by hand; change the backend contract and regenerate.

---

## 3. VERIFY_COMMANDS [REQUIRED]

The exact command the plan must cite in §11 and every task must cite in `Verify:`. The exact solution/csproj/project path is per-repo — resolve it from the locked repo, do not guess across repos.

| Stack / group | Compile / lint | Test | Build |
|---|---|---|---|
| ASP.NET Zero/ABP backend (`invoicecore`, `invoice-management`, `api-cloud-service`, `api-qldv-service`) | `dotnet build <solution.sln>` | `dotnet test <test.csproj>` (where a suite exists) | `dotnet build -c Release <solution.sln>` |
| Angular (`frontend_angular`, `searchBill`, `invoice-management/angular`, `invoicecore/angular`) | `tsc -p src/tsconfig.json --noEmit` | — (no unit suite by default; manual check) | `npm run build` |
| Java Spring Boot (`etran-teanant-service`, `hotfixlogin`, `invoice-java-service`, `createxml-service`, `validate-signature-service`) | `mvn -q compile` | `mvn -q test -Dtest=<Class>` | `mvn -q -DskipTests package` |
| .NET worker (`export-zip-pdf-service`, `svinvoicesendemail`, `importbillhostservice`, `exportbillhostservice`, `invoice-sendmail-service`) | `dotnet build <csproj/sln>` | `dotnet test <test.csproj>` (where a suite exists) | `dotnet build -c Release <csproj/sln>` |

> "Run the tests" is not a valid entry. Where a service has no automated suite, the plan/task must state the concrete **manual check** that proves the change works (and, for workers, the queue/message that triggers it).

---

## 4. DB_DOCS_PATH [REQUIRED]

| Item | Value |
|---|---|
| Current-state document | `docs/databases/README.md` (conventions) + per-table SQL under `docs/databases/` |
| Schema snapshot (do not read in full) | `docs/databases/databasehost.<table>.sql` and `docs/databases/databasetenant.<table>.sql` — grep only the tables the feature touches |
| Change script location | Feature `deploy.md` (the reviewed SQL + rollback) + update the table's file under `docs/databases/` |
| Change script naming | `databasehost.<table>.sql` (master/host DB) · `databasetenant.<table>.sql` (tenant DB) |
| Companion rule | No dedicated migration rule. DB policy = `docs/project.md` §7 + `docs/databases/README.md`; the reviewed SQL + rollback lives in the feature `deploy.md`. |
| Who applies changes | DBA / TechLead (reviewed). **Not** applied by the agent. |
| Database engine(s) | MySQL / MariaDB — **master/host DB** + **tenant DB** (routed per tenant) |

Rules:
- Every DB proposal must **start from the documented current state**, not from the code.
- ⚠ **Never run `dotnet ef migrations add` for business `vs_*` schema.** EF migrations do not manage the business schema. Schema changes go through a reviewed SQL script + rollback in `deploy.md`.
- Business data lives in the **tenant DB**; tenant metadata + connection strings live in the **master/host DB**. Workers/Java must resolve the tenant DB before touching tenant data.
- Soft delete via ABP `IsDeleted` — no physical DELETE except append-only log/history tables.
- Attachments (XML/PDF/ZIP) live on FTP/file storage; the DB stores only the path.
- Backup before any schema change is mandatory on staging/production.

---

## 5. IMPACT_TOOL [OPTIONAL — set to `none` if unused]

| Item | Value |
|---|---|
| Tool | `none` |

No code-index/impact tool is in use. Read the real code and `git diff` manually, and apply the severities in §8.

---

## 6. I18N_REQUIRED [REQUIRED]

`false` — with a caveat.

The product is Vietnamese-first (tax invoicing for Vietnamese enterprises); there is no company-wide multi-locale delivery requirement across these services. **However**, the ABP stack ships a localization mechanism and some UI already uses localization sources. Therefore:

- A feature is **not** required to add a second locale.
- When a feature touches a screen/module that **already** uses ABP/Angular localization, keep using that mechanism — do not hardcode strings into a module that localizes them.
- If a specific feature's `expect.md` demands multi-language output, treat i18n as in-scope for that feature and confirm the locale set with the TechLead.

`TBD — owner: TechLead` — confirm whether any customer requires en output; flip this to `true` and fill the locale table below if so.

---

## 7. INTEGRATION_SURFACES [REQUIRED]

Every contract that can break a client. The plan's §9 and §10 must give a compatibility verdict for each one the feature touches. Details in `docs/architecture.md` and `docs/project.md` §8.

### REST / public API
- ABP dynamic controllers. Endpoint prefixes to respect: `/api/services/app/*`, `/api/services/hddt/*`, `/api/services/hddtws/*`, and explicit endpoints like `/api/TokenAuth/*`.
- Angular calls go through **NSwag-generated proxies** — a backend contract change forces a proxy regenerate; never hand-edit the proxy.
- **Public lookup** (`searchBill`, `invoicecore/TraCuu`) must never leak tenant data — treat any change here as high scrutiny.
- Known external consumers: CQT (tax authority) integrations; enterprise API clients — `TBD — owner: TechLead` to enumerate.

### Messaging — Kafka / RabbitMQ
| Bus | Used for | Contract |
|---|---|---|
| RabbitMQ | MassTransit `EventBus.Messages` + direct-worker queues (email, import/export/print/XML, ZIP/PDF bảng kê) | Queue name + message DTO |
| Kafka | Tax / e-transaction messages, GATE CQT (`etran-teanant-service`) | Topic + message schema |

Rule: a queue-name or message-DTO change affects the producer **and every consumer/worker** — list them all. Workers must stay idempotent under retry.

### Third-party / external systems
| System | Used by | Protocol | Notes |
|---|---|---|---|
| HSM / digital signature | signing flow | HTTP endpoint (configured) | key/endpoint from config; never log payloads |
| CQT gateway (tax authority) | `etran-teanant-service` + GATE | Kafka | cannot be exercised locally |
| FTP / file storage | workers, export/import | FTP / file path | stores XML/PDF/ZIP; DB keeps only the path |

### Auth
- ABP multi-tenancy + JWT (`/api/TokenAuth/*`). A change to auth, roles, `AppPermissions`, or tenant scoping affects **all services** and data isolation — high severity.

### Templates / documents
- Tax **XML**, and **PDF/ZIP/Excel** exports / report templates consumed by workers. A template/schema change affects every producer/consumer of that document.

---

## 8. COMMON_IMPACT_ZONES [REQUIRED]

The project's known blast radii. The agent applies these severities in Step 4 of the rule.

| Change | Affected scope | Severity |
|---|---|---|
| Change a message contract (RabbitMQ queue / Kafka topic DTO) | producer + all consumers/workers | 🔴 HIGH |
| Change a shared tenant DB table (`vs_*`) | every service on that schema | 🔴 HIGH |
| Change auth / `AppPermissions` / tenant scoping | all services + data isolation | 🔴 HIGH |
| Change a public lookup endpoint (`searchBill` / `TraCuu`) | risk of tenant data leak | 🔴 HIGH |
| Change a backend API contract consumed via NSwag proxy | the Angular app(s) — must regenerate proxy | 🟡 MEDIUM |
| Change a tax XML / export template | every producer/consumer of that document | 🟡 MEDIUM |
| Change one leaf worker's internal logic only | that worker | 🟢 LOW |

---

## 9. STATUS_VOCABULARY [REQUIRED — this project overrides the rule defaults]

The single source of the feature lifecycle **status is `expect.md`** (see `docs/README.md` §3). `plan.md` keeps a separate `plan-status` for Gate 1. The agent never sets `approved` itself.

| Where | Allowed values |
|---|---|
| `expect.md` feature status | `draft` · `plan-review` · `approved` · `in-progress` · `testing` · `done` · `cancelled` |
| `plan.md` `plan-status` (Gate 1) | `draft` · `plan-review` · `approved` |
| `tasks.md` task status | `pending` · `in-progress` · `completed` · `blocked` · `cancelled` (word form, **not** `[ ]`/`[x]`) |

A `cancelled` task must record its reason.

---

## 10. TASK_FORMAT [REQUIRED]

> ⚠ **This project overrides the rule's default.** `01-create-plan.md` §7 states "Default is `checklist`" — that default does **not** apply here. Use **`block`** format exclusively.

`block` — per `docs/templates/tasks.md`: a "Tổng quan" summary table at the top, then one block per task (Status · Service · Mô tả · Tiêu chí chấp nhận · Kiểm chứng · Phụ thuộc · File dự kiến chạm · Ước lượng · Commit/PR).

Sizing convention: `XS` ≈ 1 file · `S` ≈ 1–2 · `M` ≈ 3–5 · `L` ≈ 6–8; split anything larger. Avoid `L`.

Task group order in `tasks.md`: backend by service → frontend → database/config → i18n (only if a feature needs it) → close-out.

---

## 11. BRANCH_RULE [REQUIRED]

| Item | Value |
|---|---|
| Feature branch pattern | `feature/<TICKET-ID>` — **the same name in every repo involved** (services + docs); no per-service suffix |
| Ticket prefix | `CBCLOUDV2` (e.g. `CBCLOUDV2-8963`) |
| docs repo working branch | `docs/hungtq_dev_cloud` (base `docs/xbill-cloud`) |
| Integration branch (services) | `TBD — owner: TechLead` (confirm per repo) |
| Deploy branch (services) | `TBD — owner: TechLead` (confirm per repo) |
| CI/CD | `TBD — owner: DevOps` |
| Pre-implementation check | If the current branch is not the feature branch, **ask** before creating or switching; **never** switch with a dirty working tree. If any related repo has uncommitted/unpushed work or sits on a different feature branch → STOP and report repo, branch, changed files, commit/push state. |

---

## 12. EXTRA_RULES [REQUIRED]

Companion rules/docs the agent must read when the trigger applies.

| Rule / doc | Trigger |
|---|---|
| `docs/rules/03-create-testcase.md` | after the plan, before code — generate `testcase.md` from `expect.md` |
| `docs/rules/04-create-impact.md` | draft `impact.md` during planning; finalize after implementation |
| `docs/rules/00-init-docs.md` | bootstrap / refresh the base docs (`architecture.md`, `specs/`, `databases/`, `design.md`) |
| `docs/databases/README.md` + `docs/project.md` §7 | any DB / schema / data change (no dedicated migration rule; SQL + rollback go in `deploy.md`) |
| `docs/design.md` + `docs/conventions/fe-cloud.md` | any UI change |
| `docs/conventions/<group>.md` | before planning code in a service of that group |

---

## 13. Project-specific planning constraints [OPTIONAL]

- **Multi-tenant isolation is a hard constraint.** Every plan touching data or queries must state how tenant scoping is preserved; public lookup endpoints must state how tenant data is kept private.
- **Name-conflict services:** `svinvoicesendemail` — the git repo name / README disagree with the actual source. Always trust the source; see `docs/architecture.md` §3.1.
- **Legacy Angular/TypeScript:** do not upgrade framework versions inside a business feature.
- **Cannot be tested locally:** HSM signing, the CQT gateway (Kafka), and FTP/file storage — the verification plan must say how each is checked instead (staging/UAT), and the feature must not depend on exercising them locally to be considered verified.
- **Secrets never enter docs/code/logs** — record only config **key names**, never values.

---

## Fill-in checklist

- [ ] §1 tags match the service registry in `docs/AGENTS.md` exactly.
- [ ] §3 commands confirmed against each repo's actual solution/csproj/project path.
- [ ] §4 current-state DB docs exist and are current.
- [ ] §7 lists every contract an outside party depends on (enumerate external consumers).
- [ ] §8 severities agreed with the TechLead.
- [ ] §11 integration/deploy branch names confirmed with TechLead/DevOps.
- [ ] §6 i18n requirement confirmed with the TechLead.
- [ ] One pilot feature planned end-to-end with this config before rollout.
