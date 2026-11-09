# Rule 01 — Create Plan

> **Audience:** AI agent. Follow the steps in order. Do not skip a step and do not invent a step.
> **Goal:** turn `expect.md` (written by BA) plus the project's base docs into a `plan.md` and `tasks.md` that another developer could implement without asking further questions.
> **Scope of this file:** this rule is **project-agnostic (ENGINE)**. It must work unchanged for every project. Every project-specific fact is resolved from the project config declared in §0 — never hardcode a project fact into this file.

---

## 0. Project configuration contract [READ THIS FIRST]

This rule contains **no project-specific facts**. Everything project-specific lives in the files below, which the agent MUST read together with this rule:

| File | What it provides |
|---|---|
| `docs/AGENTS.md` | Agent guide + **service registry** (canonical local-folder name → git repo → role), reading order, agent rules |
| `docs/project.md` | Project profile: tech stack, code/DB conventions summary, integrations, glossary |
| `docs/conventions/<group>.md` | Detailed code conventions per service group (`be-cloud`, `fe-cloud`, `java-services`, `dotnet-workers`) |
| `docs/rules/01-create-plan.project-config.md` | Everything this rule needs that varies per project — see the required keys below |

**If `docs/rules/01-create-plan.project-config.md` does not exist → STOP.** Report it, and offer to generate it from `docs/rules/01-create-plan.project-config.template.md`. Do not substitute assumptions for it.

### Required keys in `01-create-plan.project-config.md`

The rule references these by name. Each `{{key}}` used later in this file resolves from the project config.

| Key | Used in | Meaning |
|---|---|---|
| `{{SERVICE_TAGS}}` | Step 4, 6, 7 | Canonical service tag list used in `plan.md` front matter and in the `Service` column of `tasks.md` |
| `{{LAYER_READ_ORDER}}` | Step 4 | Per stack, the order in which source files must be traced (e.g. AppService → Manager → repository → entity → migration) |
| `{{VERIFY_COMMANDS}}` | Step 6 §Verification, Step 7 | The exact lint/compile/test command per service |
| `{{DB_DOCS_PATH}}` | Step 3, 4, 6 §DB | Where the current DB state of truth lives, and the migration file naming rule |
| `{{IMPACT_TOOL}}` | Step 4 | Code-index / impact tool, the services it indexes, and its commands. `none` if unused |
| `{{I18N_REQUIRED}}` | Step 6, 7 | `true` / `false`. When `true`, the i18n plan section and the i18n task group are mandatory |
| `{{INTEGRATION_SURFACES}}` | Step 4, 6 | External and inter-service contracts that can break clients (REST contract, message topics/queues, XML/report templates, auth realm, third-party APIs) |
| `{{COMMON_IMPACT_ZONES}}` | Step 4 | Known "change X → affects Y at severity Z" table for this project |
| `{{STATUS_VOCABULARY}}` | Step 6, 7 | Allowed status values, if the project overrides the defaults in this rule |
| `{{TASK_FORMAT}}` | Step 7 | `checklist` or `table` or `block` — which `tasks.md` layout this project uses |
| `{{BRANCH_RULE}}` | Step 8 | Branch naming and the pre-implementation branch check |
| `{{EXTRA_RULES}}` | Step 3, 4 | Companion rules to read when relevant (testcase rule, impact rule, DB conventions, design rule, ...) |

> **Porting to a new project = write a new `01-create-plan.project-config.md`. Never edit this rule file.**

---

## 1. When to run

- BA has finished `docs/features/<TICKET-ID>/expect.md`.
- A developer asks: *"Read `docs/rules/01-create-plan.md` and execute it for `<TICKET-ID>`"*.

## 2. Stop conditions — check before doing anything

STOP and ask the user if any of these is true:

1. `docs/features/<TICKET-ID>/expect.md` does not exist.
2. `docs/` is not present beside the service repos (wrong workspace layout — see `docs/AGENTS.md` and `docs/README.md` §1). `bash docs/scripts/check-layout.sh` does not PASS.
3. `docs/rules/01-create-plan.project-config.md` does not exist.
4. The feature already has a `plan.md` with `status: approved` or later, and the user did not explicitly ask to redo it. **Never overwrite an approved plan.**
5. `expect.md` fails the Definition of Ready check in Step 2.
6. The base docs contradict the real source code in the area being changed, and there is no basis to decide which one is right.
7. The target service cannot be resolved unambiguously (Step 3).

---

## 3. Inputs and outputs

### Inputs

| Input | Source | Required |
|---|---|---|
| `docs/features/<TICKET-ID>/expect.md` | BA | **Yes** — source of truth for requirements |
| `docs/features/<TICKET-ID>/extract/` | BA / customer | If present — attached supporting documents |
| `docs/AGENTS.md` | docs | **Yes** — service registry, agent rules |
| `docs/project.md` | docs | **Yes** — stack, conventions summary, integrations |
| `docs/rules/01-create-plan.project-config.md` | docs | **Yes** |
| `docs/architecture.md` | docs | **Yes** |
| `docs/specs/<domain>.md` (index: `docs/specs/README.md`) | docs | **Yes** for every domain the feature touches |
| `{{DB_DOCS_PATH}}` | docs | **Yes** when the feature touches data |
| `docs/design.md` | docs | When the feature has UI |
| `docs/conventions/<group>.md` | docs | For each affected service group |
| `{{EXTRA_RULES}}` | docs | When the trigger condition of that rule applies |
| Source code of the affected services | service repos | **Yes** — read only enough to establish scope, files and risk |

### Outputs

| Output | Description |
|---|---|
| `docs/features/<TICKET-ID>/plan.md` | Implementation design, using the template in Step 6 / `docs/templates/plan.md` |
| `docs/features/<TICKET-ID>/tasks.md` | Task checklist split by service, using the template in Step 7 / `docs/templates/tasks.md` |
| `docs/features/<TICKET-ID>/impact.md` | First draft of the impact assessment, following `docs/rules/04-create-impact.md` |
| Feature status | Set to `plan-review` in `expect.md`, with the affected services recorded |

> **Output location is mandatory.** All feature files must be written inside `docs/features/<TICKET-ID>/` in the docs repo. Any scratch plan the tooling generates elsewhere (for example a harness-internal plan file) is a draft only and must never be used as the deliverable. If the agent lacks write permission for that path, it must **ask for write access to that exact path** — it must not silently write somewhere else.

---

## 4. Procedure

### Step 1 — Refresh context

```bash
bash docs/scripts/check-layout.sh   # must PASS
cd docs && git pull
```

Then read, in this order:

1. `expect.md` in full — what to build, what is explicitly **out of scope**, and the acceptance criteria.
2. Anything in `extract/`.
3. `docs/AGENTS.md` — service registry, agent rules; `docs/project.md` — stack, conventions summary, integrations.
4. `docs/rules/01-create-plan.project-config.md`.
5. `docs/architecture.md`.
6. The `docs/specs/<domain>.md` of every domain touched (index at `docs/specs/README.md`).
7. `{{DB_DOCS_PATH}}` if data is involved; `docs/design.md` if UI is involved; `docs/conventions/<group>.md` for each affected service group.
8. Real source code of the affected services — **only enough** to determine scope, files and risk. Do not browse the repository at large.

If the spec and the real code disagree, record it under **Open questions**. Do not silently pick a side. When a git repo name / README disagrees with the actual source, **the source code wins** (see `docs/AGENTS.md`).

### Step 2 — Definition of Ready check (mandatory)

Check `expect.md` against this list:

- [ ] Acceptance criteria are measurable and unambiguous.
- [ ] Out-of-scope is stated explicitly.
- [ ] Actors, roles and permissions are clear.
- [ ] Main inputs, outputs and state transitions are clear.
- [ ] Edge cases, error states and existing/legacy data are addressed where relevant.
- [ ] The BA's own "open questions" have been answered, or are carried into blocking questions.

**Any ambiguity about business rules, architecture, data or permissions → STOP.** List the questions and ask the user before writing a detailed plan.

In that case, write only a blocking draft: `status: draft`, the `Blocking questions` section filled in, and a note that planning cannot proceed. Do **not** write detailed design or implementation tasks yet.

Small assumptions that genuinely cannot be avoided go into the **Assumptions** section, one line each, so the reviewer can confirm them individually.

### Step 3 — Resolve the target service (mandatory)

1. The target service comes from, in priority order: the user's explicit statement in this session → `plan.md` front matter (when revising an existing plan) → the `Service` column of `tasks.md`.
2. Map it to a repo path through the **service registry in `docs/AGENTS.md`**. Use the canonical **local folder name**, never the git repo name and never a folder name guessed by similarity.
3. **Never discover the target service by grep, glob or name similarity.**
4. If the service is undeclared, the name is not in the registry, or one task would span more than one repo without being stated → **STOP and ask.**
5. Record the resolved `service` and `service-repo` in the `plan.md` front matter.

### Step 4 — Impact analysis

Do this **per acceptance criterion**, not for the feature as a whole.

For each AC:

1. Identify the affected services using `{{SERVICE_TAGS}}`.
2. Trace the file chain in each affected service following `{{LAYER_READ_ORDER}}` for that stack. Name concrete files, classes and methods — not layers in the abstract.
3. **Data:** compare against the current state in `{{DB_DOCS_PATH}}` **before** proposing any change. Record tables/columns added or modified, data types, nullability, defaults, indexes, and the effect on existing rows. Never propose a migration that contradicts the documented current state (duplicate column, broken relation, wrong type). If the documented state disagrees with the real schema, raise it under Open questions. Remember: entity name ≠ real table name (tables are `vs_*`); resolve the mapping before writing SQL.
4. **UI:** identify page/component, API/proxy module, state/route and styles, per `docs/design.md` and `docs/conventions/fe-cloud.md`.
5. **Contracts:** for each surface listed in `{{INTEGRATION_SURFACES}}`, state whether the change is backward compatible, and name the clients at risk if it is not.
6. **Cross-service:** anything sharing a schema, a domain or a contract with another service must be listed and split into per-service tasks.
7. Consult `{{COMMON_IMPACT_ZONES}}` and apply the severity it assigns.
8. If `{{IMPACT_TOOL}}` is not `none` and covers the affected service → **run it before proposing any change to a symbol.** The tool assists; reading the real code and the real diff is still mandatory.

### Step 5 — Choose the approach

- Prefer the approach that fits the existing architecture over the one that is cheapest to type.
- Split the work into phases or vertical slices that leave the system working after each phase.
- Build foundations first; state explicitly what must be sequential and why.
- If there is a genuine design choice, document the alternatives and why they were rejected. **Any significant architectural decision must be surfaced in the plan for the TechLead to decide at Gate 1** — the agent does not decide it alone.

### Step 6 — Write `plan.md`

Use `docs/templates/plan.md` when present; it must carry at least these sections:

````markdown
---
feature: <TICKET-ID>
title: <feature name>
status: draft            # draft → plan-review → approved   (or {{STATUS_VOCABULARY}})
service: <canonical local-folder name from the docs/AGENTS.md registry>
service-repo: <repo path matching the registry>
services-affected: [<key>, <key>]
owner: <DEV name / AI>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
---

# Plan — <TICKET-ID>: <feature name>

## 1. Blocking questions
<Must be resolved before approval. Write "None" if there are none.>

## 2. Approach summary
<3–5 lines: how this satisfies expect.md, and which services it touches.>

## 3. Requirement trace
| AC in `expect.md` | Covered by section |
|---|---|
| AC-1 | §5.1 |
<Every AC must appear. Any AC not covered must be explained here.>

## 4. Affected services
| Service | Severity | Main change |
|---|---|---|

## 5. Detailed design, per acceptance criterion
### 5.1 AC-1 — <name>
- **Approach:** <logic, algorithm, state transitions>
- **API:** <method + path + request + response + error cases>, or "None"
- **Backend:** <files / classes / methods, following {{LAYER_READ_ORDER}}>
- **Frontend:** <page / component / proxy module / state / route / style>, or "None"
- **Data:** <tables (vs_*), columns, queries>, or "None"
- **i18n:** <keys, locale namespace/file, fallback, no hardcoded text>   <!-- required when {{I18N_REQUIRED}} = true -->
- **Docs to update:** <spec / architecture / design / databases>

### 5.2 AC-2 — <name>
...

## 6. Implementation order
<Dependencies between parts: what goes first and why.>

## 7. Database changes
<"None", or: table/column, type, nullable, default, index, migration/SQL script name per {{DB_DOCS_PATH}}, effect on existing data, rollback. Any change here requires a corresponding task in tasks.md marked (*) and an entry in deploy.md.>

## 8. Configuration changes
<"None", or: config keys (names only, no secrets), permissions, auth, storage, queues.>

## 9. External and inter-service integrations
<"None", or one line per surface in {{INTEGRATION_SURFACES}} with the compatibility verdict.>

## 10. Backward compatibility
<Which existing clients/consumers could break, and the mitigation: versioning, dual-write, feature flag, staged rollout. "None" if not applicable.>

## 11. Verification plan
<Per affected service: the exact command from {{VERIFY_COMMANDS}}, plus what result proves the AC. Generic entries such as "run tests" are not acceptable. Include the regression flows that must be re-run.>

## 12. Risks and rollback
| Risk | Severity | Mitigation / rollback |
|---|---|---|

## 13. Alternatives considered
<Significant options and why they were rejected. "None" if there was no real choice.>

## 14. Assumptions
<One line per assumption the reviewer must confirm.>

## 15. Open questions
- [ ] <question> → Answer:

## 16. Proposed docs updates (Gate 2)
<What will change in specs/, architecture.md, design.md, {{DB_DOCS_PATH}}.>

## 17. Deviations found during implementation
<Leave empty. Filled in by Rule 02 while implementing.>

## 18. Approval (Gate 1)
<Left empty by the agent. DEV self-review + TechLead approver name + date + commit/PR link.>
````

**Quality bar:** §5 must be detailed enough that a different developer can implement it without asking questions. Sentences like "adjust service X accordingly" are rejected.

Sections that evaluate to "None" are kept with the word `None` — never deleted, so the reviewer can see they were considered.

### Step 7 — Write `tasks.md`

Use the layout named by `{{TASK_FORMAT}}` (and `docs/templates/tasks.md`). Default is `checklist`.

**Format A — checklist (default)**

````markdown
---
feature: <TICKET-ID>
status: plan-review
owner: <AI / DEV>
updated_at: <YYYY-MM-DD>
---

# Tasks — <TICKET-ID>

## <service-tag-1>
- [ ] [<service-tag>] <specific task> (M) — DoD: <objectively checkable result> — Verify: `<command from {{VERIFY_COMMANDS}}>` — Depends on: —
- [ ] [<service-tag>] <specific task> (S) — DoD: ... — Verify: ... — Depends on: task 1

## <service-tag-2>
- [ ] [<service-tag>] ...

## database / config          <!-- only if §7 or §8 of the plan is not "None" -->
- [ ] [db] <SQL script + docs update> (*) (S) — DoD: script written + {{DB_DOCS_PATH}} updated — Depends on: ...

## i18n                        <!-- required when {{I18N_REQUIRED}} = true -->
- [ ] [i18n] <translation keys for UI / API messages / email / notifications / exports> (S) — DoD: no hardcoded strings; all locales present

## Feature close-out           <!-- always present -->
- [ ] Run the verification commands for every affected service and write `report.md` from the **real** output
- [ ] Complete `deploy.md` if there is any DB / config / dependency / job / queue change
- [ ] Produce the proposed docs diff for Gate 2: specs/, architecture.md, design.md, {{DB_DOCS_PATH}}
````

**Format B — block (use when tasks need more structure)**

````markdown
## Task N — <short descriptive title>

- Status: pending
- Service: `<canonical local-folder name>`
- Description: <one paragraph: the exact outcome>
- Acceptance criteria:
  - [ ] <specific, testable condition traced to an AC in expect.md>
- Verification:
  - [ ] `<exact command>` → <expected result>
- Dependencies: None
- Likely touched files:
  - `<repo>/<path>`
- Estimated scope: S
````

**Task rules (apply to every format)**

- Every task carries a service tag from `{{SERVICE_TAGS}}`, a size, a DoD and its dependencies.
- Size: `XS` ≈ 1 file · `S` ≈ 1–2 files · `M` ≈ 3–5 files · `L` ≈ 6–8 files. A task should fit in one working day.
- **Split** any task that touches more than 8 files, spans independent subsystems, has vague acceptance criteria, or joins unrelated work with "and" in its title. Avoid `L`.
- Status markers: `[ ]` not started · `[/]` in progress · `[x]` done (with date) · `[blocked]` (with reason). Or `{{STATUS_VOCABULARY}}` if the project overrides them.
- Mark `(*)` any task involving DB, config, dependency, job or queue changes — each `(*)` task must have a matching entry in `deploy.md`.
- The "Feature close-out" group is always present.
- Every task must trace back to an AC in `expect.md`. A task that traces to nothing is out of scope — move it to Open questions instead.

### Step 8 — Gate 1

Self-review checklist before submitting:

- [ ] `check-layout.sh` PASSed and `git pull` was run in `docs/`.
- [ ] `plan.md` has `service:` + `service-repo:` matching the `docs/AGENTS.md` registry, and the `Service` column of `tasks.md` uses the same keys.
- [ ] Every blocking question is answered, or the plan is explicitly a blocking draft.
- [ ] Every AC in `expect.md` appears in the requirement trace (§3).
- [ ] The design does not contradict `specs/`, `architecture.md`, `design.md` or `{{DB_DOCS_PATH}}`.
- [ ] Every DB proposal was checked against the documented current state, and uses a SQL script (not EF migration for `vs_*` schema).
- [ ] Backward compatibility was assessed for every surface in `{{INTEGRATION_SURFACES}}`.
- [ ] Every task has a service tag, a size, a DoD, dependencies and a concrete verification command.
- [ ] No task is oversized or mixes unrelated subsystems.
- [ ] Risks, mitigation, rollback and deployment implications are documented.
- [ ] i18n is covered, if `{{I18N_REQUIRED}}` is true.
- [ ] The "Proposed docs updates (Gate 2)" section is filled in.
- [ ] `plan.md` and `tasks.md` are written inside `docs/features/<TICKET-ID>/`.
- [ ] **No code has been written.**

Then:

1. Write `plan.md` and `tasks.md` into `docs/features/<TICKET-ID>/`.
2. Draft `impact.md` following `docs/rules/04-create-impact.md`.
3. Set the feature status to `plan-review` in `expect.md` and record the affected services. **The agent never sets `approved` itself.**
4. Summarize for the user: the main design decisions, the assumptions awaiting confirmation, and the remaining open questions.

> **Gate 1 is hard.** `plan.md` must be reviewed by DEV and approved by the TechLead (`status: approved` in `expect.md`, approver + date + link in `plan.md` §18) before Rule 02 (implementation) may run. If it is not approved, revise from Step 5 and repeat.

> **Before implementation starts:** check out the correct branch per `{{BRANCH_RULE}}`. If the current branch is not the feature branch, ask the user before creating or switching — and never switch while the working tree is dirty.

---

## 5. Principles

1. **Ask when context is missing.** Never invent business rules, logic, data shapes or permissions.
2. **`expect.md` is the source of truth for requirements.** A plan that contradicts it is wrong by definition.
3. **The documented DB state is the source of truth for the schema.** Every DB proposal starts from it.
4. **Respect out-of-scope.** Good ideas outside `expect.md` go into Open questions for the BA to decide — not into the plan.
5. **No code in this rule.** This rule only analyses and plans.
6. **Follow project conventions** as declared in `docs/AGENTS.md`, `docs/project.md`, `docs/conventions/` and `01-create-plan.project-config.md`.
7. **Never overwrite an approved plan.**
8. **Name things concretely.** Real files, real endpoints, real columns (`vs_*`), real commands.
9. **This rule file stays generic.** Anything project-specific belongs in the project config, never here.

---

## 6. Rejected outputs

A plan is sent back if it contains any of these:

| Anti-pattern | Why it fails |
|---|---|
| "Modify service X accordingly" | Not implementable without asking |
| "Run tests" as the verification plan | No command, no expected result |
| A task with no DoD | Cannot be objectively closed |
| A migration written without reading the documented schema | Risks conflicting with the real database |
| An EF migration for a `vs_*` business table | Business schema is managed by SQL script + DBA review, not EF |
| A target service inferred from a folder name | The registry exists precisely to prevent this |
| Sections deleted instead of marked "None" | The reviewer cannot tell if it was considered |
| Features present in the plan but absent from `expect.md` | Scope creep past the BA's decision |
| A plan written while blocking questions are open | Guesswork dressed as design |

---

## 7. Project customization

The generic part ends here. Everything that varies per project lives in:

👉 **`docs/rules/01-create-plan.project-config.md`** (create it from `01-create-plan.project-config.template.md`)
👉 **`docs/AGENTS.md`** (service registry, agent rules) + **`docs/project.md`** (stack, conventions summary) + **`docs/conventions/`**

The agent **must read all of them together with this rule** and follow them wherever they declare a value.
