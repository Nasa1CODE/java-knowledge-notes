# Project Config — Rule 02 Implement Task (BillCloud)

> Companion file for `docs/rules/02-implement-task.md`. The rule is generic (ENGINE); **this file carries every project-specific fact the implementation step needs.**
> Canonical sources: **`docs/AGENTS.md`** (registry §4, git rules §15, do-not-touch §16), **`docs/project.md`**, **`docs/conventions/`**, **`docs/databases/README.md`**. Canonical source wins on conflict — fix this file.
> **Porting the workflow to a new project = rewriting this file only. Never edit the rule.**

```yaml
project: BillCloud (xBill/CyberBill HĐĐT — bản Cloud)
config_version: 1.0.0
updated_at: 2026-08-31
owner: TBD — TechLead
extends: docs/rules/01-create-plan.project-config.md
```

**Do not duplicate the Rule 01 keys here.** These are read from `01-create-plan.project-config.md`:
`SERVICE_TAGS` · `LAYER_READ_ORDER` · `VERIFY_COMMANDS` · `DB_DOCS_PATH` · `IMPACT_TOOL` · `I18N_REQUIRED` · `INTEGRATION_SURFACES` · `COMMON_IMPACT_ZONES` · `STATUS_VOCABULARY` · `TASK_FORMAT` · `BRANCH_RULE` · `EXTRA_RULES`.

---

## 1. APPROVAL_EVIDENCE [REQUIRED]

What proves Gate 1 passed. The agent checks **all** applicable rows before writing code, and **never sets any of them itself**.

| Evidence | Where | Value that means approved |
|---|---|---|
| Feature status | `docs/features/<TICKET-ID>/expect.md` (status is owned here) | `status: approved` |
| Plan approval block | `plan.md` §"Approval (Gate 1)" | TechLead name + date + commit/PR link |
| Plan status | `plan.md` front matter `plan-status` | `approved` |
| Ticket state | Jira (`CBCLOUDV2-…`) | `TBD — owner: TechLead` (e.g. "Ready for Dev") |

Rule: the source of feature status is `expect.md` only. A plan without the §"Approval (Gate 1)" block filled in is **not** approved, whatever any other file says.

---

## 2. IMPLEMENT_ORDER [REQUIRED]

The order in which files are created or changed **inside one task**, per stack.

| Stack | Implementation order |
|---|---|
| Backend — ASP.NET Zero / ABP | Entity → business `DbContext` `DbSet` → SQL script (`vs_*`) → DTO → `AppService` → `AppPermissions` → dynamic controller/MVC as needed |
| Frontend — Angular | (regenerate NSwag proxy after backend contract lands) → service/proxy provider → model → component → template → `*-routing.module.ts` (+ permission metadata) → style |
| Java — Spring Boot | entity → repository (tenant routing) → request/response DTO → service → controller/listener → kafka producer/consumer → config |
| .NET worker | consumer/handler → resolve tenant connection string → service logic → status/output-path write → queue/DTO contract → config |

Rule: backend contract first, then regenerate the Angular proxy, then frontend, then DB/config — unless the plan states otherwise. Never hand-edit generated proxies.

---

## 3. CODE_STYLE_RULES [REQUIRED]

What "match the existing style" means here. Details in `docs/conventions/<group>.md`.

| Aspect | Rule |
|---|---|
| Layering | ABP: `AppService → Manager/Domain → repository`; never business logic in controllers or Angular components |
| Multi-tenancy | Always scope queries to the tenant; resolve tenant DB in workers/Java before touching tenant data; never leak cross-tenant data |
| Entity / table naming | Entity name ≠ table name; real tables are `vs_*`. Common entity prefixes: `HD_`, `DM_NCC_`, `DMDoanhNghiep_`, `DoanhNghiep_`, `Bangke_`/`Bc26ac_`, `ChungTu_`, `Service_` |
| AppService placement | `AppServices/<Module>/*AppService`; endpoints auto-exposed via ABP dynamic controller; respect endpoint prefixes (`/api/services/app|hddt|hddtws/*`, `/api/TokenAuth/*`) |
| Permissions | Check via `AppPermissions` (`*.Core/Authorization/`); route guards + menu must match |
| Frontend API access | NSwag service proxies only (`src/shared/service-proxies/`); register providers in `service-proxy.module.ts`; **never edit generated proxy files** |
| No hardcoded backend URL | Read from runtime config (`AppConsts` / `AppPreBootstrap`) so one bundle runs many environments |
| Java conventions | controller/listener → service → repository; **clear tenant context** after master/tenant work; parse tax XML safely |
| .NET worker conventions | resolve tenant connection from master/default DB first; write status/output path after processing; keep message contract (queue name, DTO) stable; idempotent under retry |
| Encoding | UTF-8 without BOM |
| Comment & message language | Vietnamese (matching surrounding code) |
| Secrets | Never copy secrets/tokens/connection strings into code samples, logs, or docs; never log JWT/token/password/sensitive XML/customer-tax data |

---

## 4. FORBIDDEN_CHANGES [REQUIRED]

Change types that must **not** be made unless the approved plan states them explicitly. Hitting one is a stop condition.

| Change | Requires |
|---|---|
| Entity / DTO field added, removed or retyped | stated in `plan.md` and re-approved |
| Public / ABP API contract (path, payload, status codes) consumed via NSwag | stated in `plan.md`; Angular proxy regenerate planned; consumers noted |
| Message payload / queue name / Kafka topic | TechLead approval; producer **and** all consumers/workers listed |
| Business DB schema (`vs_*`) | reviewed SQL script + rollback in `deploy.md`; **never** direct SQL on a shared env; **never** `dotnet ef migrations add` for `vs_*` |
| Permissions / roles / `AppPermissions` / tenant scoping / auth realm | TechLead approval (affects all services + data isolation) |
| Tax XML / export (PDF/ZIP/Excel) template | TechLead approval; all producing/consuming services listed |
| Shared utility / base class / `zero/` platform layer | impact analysis + TechLead approval |
| Build / CI / infrastructure config | DevOps approval |

Do-not-touch paths (also in `docs/AGENTS.md`): generated proxies (`service-proxies.ts`), `bin/`, `obj/`, `target/`, `build/`, `dist/`, `node_modules/`, secrets / `.env` / runtime config, legacy `* - Copy/` or `*-old/` folders.

---

## 5. MOCKABLE_INTEGRATIONS [REQUIRED]

Integrations that cannot be exercised from a dev environment. Anything mocked/skipped must be listed in `report.md` §5.

| Integration | Available locally | Policy while implementing | Verified instead by |
|---|---|---|---|
| HSM / digital signature | No | mock the client; never point at production HSM | staging test after deploy |
| CQT gateway (tax authority) | No | skip / guard behind config; never send from dev | UAT run by QA/DEV |
| FTP / file storage | `TBD — owner: DevOps` | use a configured dev target if available, else mock the path write | check output path recorded |
| Kafka / RabbitMQ | `TBD — owner: DevOps` (local docker?) | use the local/dev instance if available; otherwise assert on the produced message/DTO | consumer/worker integration check |

---

## 6. DEPENDENCY_POLICY [REQUIRED]

| Item | Value |
|---|---|
| May the agent add a library? | No — requires TechLead approval |
| Package managers | NuGet (.NET), npm (Angular), Maven (Java) — use what the repo already uses; do not switch tools |
| Lock file policy | Commit lock/restore files; never regenerate wholesale as part of a feature |
| Version pinning | Keep existing versions; do not bump framework/library versions inside a business feature |
| Where a new dependency is recorded | `deploy.md` §Dependencies + `plan.md` |

---

## 7. REPORT_EVIDENCE [REQUIRED]

What must be pasted into `report.md` §3 for the report to be accepted.

| Stack | Commands whose real output must be pasted | Expected evidence |
|---|---|---|
| ABP backend | `dotnet build <sln>` (+ `dotnet test` where a suite exists) | build succeeded/failed summary; test counts if run |
| Angular | `tsc -p src/tsconfig.json --noEmit` and/or `npm run build` | tsc/build exit + summary |
| Java | `mvn -q -DskipTests package` (+ `mvn test -Dtest=X` where relevant) | Maven BUILD SUCCESS; Surefire Tests run / Failures / Errors / Skipped |
| .NET worker | `dotnet build <csproj/sln>` | build summary; plus the manual message/queue check that triggered it |

Additional required evidence:
- UI tasks: a manual-check description (steps + expected result) or screenshot reference.
- Worker/messaging tasks: the queue/topic + message used to trigger, and the observed status/output path.
- Regression flows named in the plan that were re-run.

Rule: a check that could not be run is reported as `N/A` **with a verifiable reason**. Narrated results ("tests pass") are rejected.

---

## 8. DEPLOY_TRIGGERS [REQUIRED]

`deploy.md` is mandatory when any of these is true:

- [ ] Business DB schema change or data migration (`vs_*` SQL script)
- [ ] Config or environment variable change (key names only in docs)
- [ ] New or upgraded dependency
- [ ] New or changed worker / scheduled job / queue consumer
- [ ] RabbitMQ queue or Kafka topic / message contract change
- [ ] Auth realm / role / `AppPermissions` change
- [ ] FTP / file-storage path or policy change
- [ ] HSM / signing endpoint change
- [ ] Infrastructure / container / orchestration change

---

## 9. DEPLOY_COMMANDS [REQUIRED]

| Purpose | Command / mechanism |
|---|---|
| Apply schema change | Reviewed SQL script run by **DBA/TechLead** (master/host or tenant DB). **Not** EF migration for `vs_*`. |
| Roll back schema | The rollback SQL recorded in `deploy.md` §9 |
| Build backend artifact | `dotnet build -c Release <sln>` |
| Build Angular artifact | `npm run build` |
| Build Java artifact | `mvn -q -DskipTests package` |
| Deploy mechanism | `TBD — owner: DevOps` (CI/CD pipeline / manual) |
| Restart worker/service | `TBD — owner: DevOps` |
| Post-deploy smoke check | Per-feature: a concrete check + expected result recorded in `deploy.md` §8 |

Environments: dev / staging / UAT / prod — who may deploy to each: `TBD — owner: DevOps`. Backup before schema change is mandatory on staging/prod.

---

## 10. DOCS_UPDATE_MAP [REQUIRED]

Where each kind of change is reflected for the Gate 2 diff.

| Change | Document |
|---|---|
| Business logic, input/output, state, permissions | `docs/specs/<domain>.md` (index `docs/specs/README.md`) |
| Architecture, integrations, queues, storage, auth | `docs/architecture.md` |
| UI pattern, layout, component, theme | `docs/design.md` |
| Schema, entity, data (`vs_*`) | `docs/databases/README.md` + the table's `docs/databases/*.sql` |
| Service-group coding convention | `docs/conventions/<group>.md` |
| Feature-level rollout notes | `docs/features/<TICKET-ID>/deploy.md` |
| Environment deployment steps | Service-local deployment doc — **not** the shared docs repo |

Gate 2 approver: TechLead. Merge mechanism: MR on the docs repo (`http://10.30.1.17/xBill/docs.git`). The agent **proposes** the diff; it never merges docs source-of-truth.

---

## 11. COMMIT_RULE [REQUIRED]

| Item | Value |
|---|---|
| Commit message format | `<TICKET-ID>: short description` (e.g. `CBCLOUDV2-8963: add nationality catalog`) |
| Branch | `feature/<TICKET-ID>` — same name in every repo involved |
| Ticket ID in every commit? | Yes |
| PR/MR target | `TBD — owner: TechLead` (integration branch per repo) |
| Record commit/PR link in `tasks.md` / `report.md`? | Yes |
| May the agent commit on its own? | No — only when explicitly asked |
| May the agent push / merge / deploy on its own? | No — only when explicitly asked |
| Hard stop | diff contains files outside task scope, a secret, or runtime config → stop and ask before commit/push/merge/deploy |

---

## 12. Project-specific implementation constraints [OPTIONAL]

- **Tenant isolation** is non-negotiable: verify no cross-tenant leak on every data-touching change; extra scrutiny on public lookup (`searchBill`, `TraCuu`).
- **Name-conflict services** (`svinvoicesendemail`): trust the source, not the repo name/README; note any observed discrepancy.
- **Legacy modules / `zero/` platform layer**: preserve the existing pattern; do not refactor or bump versions inside a business feature.
- **Generated code** (NSwag proxies, EF-generated files, build output) is never hand-edited.
- **Idempotency**: worker changes must remain safe under message redelivery/retry.

---

## Fill-in checklist

- [ ] §1 approval evidence matches how this team actually approves (confirm the Jira state).
- [ ] §2 implementation order agreed with the leads for each stack.
- [ ] §3 style rules match what code review enforces.
- [ ] §4 forbidden changes cover every external-facing contract.
- [ ] §7 commands run once and their real output format recorded per repo.
- [ ] §8/§9 verified with whoever operates deployments (fill the DevOps TBDs).
- [ ] §10 target documents all exist.
- [ ] §11 matches the git rules in `docs/AGENTS.md` — no contradiction.
- [ ] One pilot feature implemented end-to-end with this config before rollout.
