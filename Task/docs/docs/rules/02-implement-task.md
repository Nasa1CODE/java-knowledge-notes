# Rule 02 — Implement Task

> **Audience:** AI agent. Follow the steps in order. Do not skip a step and do not invent a step.
> **Goal:** implement the approved tasks in `tasks.md`, produce `report.md` from **real** command output, produce `deploy.md` when required, and propose the docs diff for Gate 2.
> **Scope of this file:** this rule is **project-agnostic (ENGINE)**. It must work unchanged for every project. Every project-specific fact is resolved from the project config declared in §0 — never hardcode a project fact into this file.
> **Predecessor:** `docs/rules/01-create-plan.md`. This rule may only run on a plan that passed Gate 1.

---

## 0. Project configuration contract [READ THIS FIRST]

This rule contains **no project-specific facts**. The agent MUST read these together with this rule:

| File | What it provides |
|---|---|
| `docs/AGENTS.md` | Agent guide + **service registry** (canonical local-folder name → git repo → role), agent rules, git rules |
| `docs/project.md` | Project profile: stack, conventions summary, integrations, DB rules, glossary |
| `docs/conventions/<group>.md` | Detailed code conventions per service group (`be-cloud`, `fe-cloud`, `java-services`, `dotnet-workers`) |
| `docs/rules/01-create-plan.project-config.md` | Keys already declared for planning — **reused here, never duplicated** |
| `docs/rules/02-implement-task.project-config.md` | Keys specific to implementation — see below |

**If `docs/rules/02-implement-task.project-config.md` does not exist → STOP.** Report it and offer to generate it from `docs/rules/02-implement-task.project-config.template.md`. Do not substitute assumptions for it.

> A project may merge both config files into a single `docs/rules/project-config.md`. The rules require the **keys**, not the filenames — if a merged file exists and declares every key, read that instead.

### Keys reused from the Rule 01 config

`{{SERVICE_TAGS}}` · `{{LAYER_READ_ORDER}}` · `{{VERIFY_COMMANDS}}` · `{{DB_DOCS_PATH}}` · `{{IMPACT_TOOL}}` · `{{I18N_REQUIRED}}` · `{{INTEGRATION_SURFACES}}` · `{{COMMON_IMPACT_ZONES}}` · `{{STATUS_VOCABULARY}}` · `{{TASK_FORMAT}}` · `{{BRANCH_RULE}}` · `{{EXTRA_RULES}}`

### Keys defined in the Rule 02 config

| Key | Used in | Meaning |
|---|---|---|
| `{{APPROVAL_EVIDENCE}}` | Step 1 | What counts as proof that Gate 1 passed, and where it is recorded |
| `{{IMPLEMENT_ORDER}}` | Step 6 | Per stack, the order in which files are created/changed within one task |
| `{{CODE_STYLE_RULES}}` | Step 6 | Logging, transactions, error handling, response wrappers, naming, comment language |
| `{{FORBIDDEN_CHANGES}}` | Step 6, 7 | Change types that require re-approval before being made (contracts, entities, schema, permissions) |
| `{{MOCKABLE_INTEGRATIONS}}` | Step 6, 8 | Integrations that cannot be exercised locally, and the policy for them |
| `{{DEPENDENCY_POLICY}}` | Step 6 | Whether new libraries may be added, and who approves |
| `{{REPORT_EVIDENCE}}` | Step 8, 9 | Which command outputs must be pasted into `report.md`, and in what form |
| `{{DEPLOY_TRIGGERS}}` | Step 11 | The change types that force a `deploy.md` |
| `{{DEPLOY_COMMANDS}}` | Step 11 | Migration/SQL, build, rollout and rollback commands |
| `{{DOCS_UPDATE_MAP}}` | Step 12 | Change type → the doc file that must be updated |
| `{{COMMIT_RULE}}` | Step 6, 13 | Commit message format, PR/MR linking, push/merge authority |

> **Porting to a new project = writing a new project config. Never edit this rule file.**

---

## 1. When to run

- `plan.md` has passed Gate 1 (`status: approved` in `expect.md`) and `tasks.md` is ready.
- A developer asks: *"Read `docs/rules/02-implement-task.md` and implement task N of `<TICKET-ID>`"*, or asks for the whole task list.

## 2. Stop conditions — check before touching any code

STOP and ask the user if any of these is true:

1. `plan.md` is not approved, or the approval evidence required by `{{APPROVAL_EVIDENCE}}` is missing. **The agent never sets `approved` itself.**
2. `tasks.md` is missing, or the requested task does not exist in it.
3. The target service cannot be resolved from the plan front matter through the `docs/AGENTS.md` registry (Step 2).
4. The working tree of an affected repo is dirty, or sits on a branch other than the feature branch required by `{{BRANCH_RULE}}`.
5. The task requires a change listed in `{{FORBIDDEN_CHANGES}}` that the approved plan does not cover.
6. The impact analysis returns HIGH/CRITICAL risk that the plan did not anticipate (Step 5).
7. Implementation would have to deviate from the approved plan (Step 7) — stop, update the plan, get it re-approved.
8. The task is marked `blocked`, or its dependencies are not yet done.
9. `bash docs/scripts/check-layout.sh` does not PASS.

---

## 3. Inputs and outputs

### Inputs

| Input | Source | Required |
|---|---|---|
| `docs/features/<TICKET-ID>/tasks.md` | Rule 01 | **Yes** — the approved scope |
| `docs/features/<TICKET-ID>/plan.md` | Rule 01 | **Yes** — the approved design |
| `docs/features/<TICKET-ID>/expect.md` | BA | **Yes** — the requirement of record |
| `docs/AGENTS.md` + `docs/project.md` + both project configs | docs | **Yes** |
| `docs/architecture.md`, `docs/specs/<domain>.md` | docs | **Yes** for the domains touched |
| `docs/design.md` | docs | When the task changes UI |
| `docs/conventions/<group>.md` | docs | For the locked service's group |
| `{{DB_DOCS_PATH}}` | docs | When the task touches data |
| Source code of the locked service | service repo | **Yes** |

### Outputs

| Output | Description |
|---|---|
| Code changes | Only inside the locked repo(s), only within approved scope |
| `docs/features/<TICKET-ID>/tasks.md` | Kept current, task by task, as work progresses |
| `docs/features/<TICKET-ID>/report.md` | Real changed files, real verification output, real problems |
| `docs/features/<TICKET-ID>/impact.md` | Finalized to the real blast radius (see `docs/rules/04-create-impact.md`) |
| `docs/features/<TICKET-ID>/deploy.md` | Only when a trigger in `{{DEPLOY_TRIGGERS}}` fires |
| Proposed docs diff | For Gate 2, per `{{DOCS_UPDATE_MAP}}` |

> All feature documents are written inside `docs/features/<TICKET-ID>/` in the docs repo. Scratch files generated by the tooling elsewhere are drafts only. If write permission is missing for that path, **ask for it** — do not write somewhere else.

---

## 4. Procedure

### Step 1 — Verify Gate 1 (hard gate)

1. Open `plan.md` and confirm the approval evidence required by `{{APPROVAL_EVIDENCE}}`.
2. Confirm `tasks.md` matches that plan (same feature, same services).
3. If any of it is missing → **STOP** and report that Gate 1 is not satisfied. Do not code "while waiting".

### Step 2 — Lock the target service (mandatory)

1. Read `service:` and `service-repo:` from the `plan.md` front matter, plus the `Service` column of the specific task.
2. Map the canonical **local-folder name** to its repo path through the **service registry in `docs/AGENTS.md`**.
3. **Never** locate the service by grep, glob or folder-name similarity — service and folder names collide across repos and a search will match the wrong one. When a git repo name / README disagrees with the actual source, the source code wins.
4. Open and edit files **only** inside the locked repo path. A multi-service task is executed **one repo at a time**, each through its own registry path.
5. If `service:` is missing, the name is not in the registry, or the task spans repos without saying so → **STOP and ask.**

### Step 3 — Refresh and check the branch

```bash
bash docs/scripts/check-layout.sh          # must PASS
cd <project-root>/docs && git pull
cd <project-root>/<locked-service> && git status && git pull
```

- Check `git status` **before** any checkout. If the tree is dirty → stop and ask.
- The branch must follow `{{BRANCH_RULE}}`. If the current branch is wrong, **ask before creating or switching** — never do it silently.
- Never merge or push unless explicitly asked (Step 13).

### Step 4 — Read context

1. `expect.md`, `plan.md`, the task row in `tasks.md`.
2. `docs/AGENTS.md` agent rules and `docs/conventions/<group>.md` for the locked service.
3. `docs/architecture.md`, and the `docs/specs/<domain>.md` named by the plan.
4. `docs/design.md` — if the task changes UI.
5. The i18n section of the plan and the existing locale files — if `{{I18N_REQUIRED}}` is true and the task produces user-visible text.
6. `{{DB_DOCS_PATH}}` — if the task touches data.
7. The real source files named in the plan, following `{{LAYER_READ_ORDER}}`.

### Step 5 — Impact gate

If `{{IMPACT_TOOL}}` is not `none` and covers the locked service:

1. Run the tool's impact command **before changing any symbol** that is used outside its own file.
2. Read the blast radius; record the affected modules, APIs, models and components.
3. **HIGH/CRITICAL risk → stop, report to the developer, and wait for confirmation.** Do not continue on your own judgement.
4. If the tool is not set up or not indexed, follow the setup rule in `{{EXTRA_RULES}}`.

Regardless of the tool: read the real code, check `git diff`, and apply the severities in `{{COMMON_IMPACT_ZONES}}`. The tool assists analysis; it does not replace it. Keep `impact.md` current (see `docs/rules/04-create-impact.md`).

### Step 6 — Implement, one task at a time

Loop over the tasks in `tasks.md` in order. For each task:

1. Set the task status to in-progress per `{{STATUS_VOCABULARY}}`, in `tasks.md`, **before** editing code.
2. Change files in the order given by `{{IMPLEMENT_ORDER}}` for that stack.
3. Follow `{{CODE_STYLE_RULES}}` — match the surrounding code, do not introduce a new pattern.
4. Respect the scope discipline in §5 of this rule.
5. Run the task's own verification command from `{{VERIFY_COMMANDS}}` (Step 8).
6. Mark the task done **only** when its DoD in `tasks.md` is objectively met, and record the date.
7. Record the commit/PR reference against the task if `{{COMMIT_RULE}}` requires it.

Special handling:

- **Data changes:** follow the DB rules in `{{DB_DOCS_PATH}}` / `docs/project.md`. Business `vs_*` schema is changed via a reviewed **SQL script + rollback in `deploy.md`**, never by hand and never via `dotnet ef migrations add`. Update `{{DB_DOCS_PATH}}` in the same feature.
- **User-visible text:** when `{{I18N_REQUIRED}}` is true, add the translation keys per the plan. Never hardcode UI text, validation and error messages, empty states, buttons, tooltips, emails, notifications or exported documents. If the namespace or key is unclear → ask.
- **Unavailable integrations:** for anything in `{{MOCKABLE_INTEGRATIONS}}`, mock or skip it locally per the declared policy, and say so in `report.md`. Never enable a production integration from a development environment.
- **New dependencies:** only per `{{DEPENDENCY_POLICY}}`. Default is: not without approval.

### Step 7 — Deviation protocol

If reality does not match the approved plan — a file that does not exist, a contract that differs, a hidden dependency, an approach that cannot work:

1. **Stop implementing that task.**
2. Record the finding in `plan.md` §17 "Deviations found during implementation".
3. If the deviation changes design, scope, a contract, the schema, permissions, or anything in `{{FORBIDDEN_CHANGES}}` → **it needs re-approval before coding continues** (back to Gate 1 for that part).
4. If it is a minor, scope-preserving detail, record it in `plan.md` §17 and in `report.md`, then continue. A deviation qualifies as minor and scope-preserving only when **all three** of the following are true:
   - (a) it affects only files inside the locked repo and within the current task's declared scope;
   - (b) it does not touch any item in `{{FORBIDDEN_CHANGES}}` — no contract, entity, schema, permission, or auth change;
   - (c) the approved acceptance criteria in `tasks.md` are still fully met by the adjusted approach — no AC is dropped or weakened.
   When any condition is in doubt → treat as requiring re-approval.
5. Update `impact.md` whenever a newly affected file or service is discovered.

Never silently "fix" the plan by writing different code from what was approved.

### Step 8 — Verify with real output

1. Run the exact commands from `{{VERIFY_COMMANDS}}` for every service touched.
2. Run the broader checks required by `{{REPORT_EVIDENCE}}` (build, test suite, lint, regression flows).
3. If `{{IMPACT_TOOL}}` supports it, run its change-detection command to confirm nothing outside scope moved.
4. Review `git diff` file by file. Anything outside the task scope must be reverted or explained.

> **Test and validator output pasted into `report.md` must be the real output of a command that actually ran.** Narrating "tests pass" is a rejected output. If a check could not be run, write `N/A` with a verifiable reason.

### Step 9 — Write `report.md`

Use `docs/templates/report.md` when present; it must carry at least:

````markdown
---
feature: <TICKET-ID>
status: <in_progress | testing | done>
services: [<service-key>, ...]
updated_at: <YYYY-MM-DD>
---

# Report — <TICKET-ID>: <feature name>

## 1. Tasks completed
- [x] Task 1 — <what was actually done>
- [x] Task 2 — <what was actually done>
- [ ] Task 3 — <not done: reason>

## 2. Files changed
| Service | File | Change |
|---|---|---|
| `<service-key>` | `<repo-relative path>` | <one line> |

## 3. Verification results
<!-- Paste the REAL output of each command. No narration. -->
```
$ <command from {{VERIFY_COMMANDS}}>
<real output>
```
| Check | Result | Note |
|---|---|---|
| `<lint/compile command>` | ✅ / ❌ / N/A | |
| `<test command>` | ✅ / ❌ / N/A | tests run: X, failures: 0, errors: 0, skipped: Y |
| `<build command>` | ✅ / ❌ / N/A | |
| i18n — no hardcoded text, locales complete | ✅ / ❌ / N/A | <required when {{I18N_REQUIRED}} = true> |
| Impact/change detection | ✅ / ❌ / N/A | |
| Regression flows re-run | ✅ / ❌ / N/A | |

## 4. Deviations from the plan
<What differed from the approved plan, and how it was resolved. "None" if none.>

## 5. Problems and limitations
<Errors hit, workarounds applied, anything mocked or skipped per {{MOCKABLE_INTEGRATIONS}}, known limitations. "None" if none.>

## 6. Found outside scope — not fixed
<Problems noticed but deliberately not touched, with enough detail to file a ticket. "None" if none.>

## 7. Docs / specs status
- Related spec: `docs/specs/<domain>.md` / N/A
- Status: `updated` / `N/A (verifiable reason)` / `pending review (diff below)`

## 8. Proposed docs diff (Gate 2)
- [ ] `docs/specs/<domain>.md` — <what changes>
- [ ] `docs/architecture.md` — <what changes>
- [ ] `docs/design.md` — <what changes>
- [ ] `{{DB_DOCS_PATH}}` — <what changes>

## 9. Commits / PRs
| Service | Branch | Commit / PR | Note |
|---|---|---|---|
````

### Step 10 — Finalize `impact.md`

Update `impact.md` so it reflects reality after implementation: the files and services actually changed, the areas **confirmed** unaffected, the risks that materialized, and anything left unverified. Follow `docs/rules/04-create-impact.md`.

### Step 11 — Write `deploy.md` when triggered

Create `deploy.md` (from `docs/templates/deploy.md`) **only** when a trigger in `{{DEPLOY_TRIGGERS}}` fires. Default triggers: schema/SQL change, config or environment variables, new dependency, new or changed job/cron/queue, message contract change, auth realm/role/permission change, storage bucket/path/policy change, infrastructure or rollout change.

````markdown
# Deploy — <TICKET-ID>

## 1. Summary
<What operations must do, in one paragraph.>

## 2. Database
- SQL / migration script: `<name per {{DB_DOCS_PATH}}>`
- Command: `<from {{DEPLOY_COMMANDS}}>`
- Manual SQL (if any):
```sql
-- what it changes and why
```
- Effect on existing data:
- Who runs it: <DBA / DEV / CI>
- Backup taken before schema change: <yes/no — mandatory for staging/prod>

## 3. Configuration
| Key (name only, no secret) | Old | New | Service | Note |
|---|---|---|---|---|

## 4. Dependencies
- `<install command>`

## 5. Jobs / queues / scheduled work
<New or changed, plus what must be restarted (Kafka/RabbitMQ workers).>

## 6. Integrations
<Message topics/queues, auth config, storage, HSM — per {{INTEGRATION_SURFACES}}.>

## 7. Deployment order
1. <step>
2. <step>

## 8. Verification after deploy
- <check> → <expected result>

## 9. Rollback
- <exact steps to undo, per {{DEPLOY_COMMANDS}}>
````

> `deploy.md` describes **this feature's** rollout. Environment-level operating detail belongs in the service-local deployment doc named by `{{DOCS_UPDATE_MAP}}`, not in the shared docs repo.

### Step 12 — Propose the docs diff (Gate 2)

Map each change to its document using `{{DOCS_UPDATE_MAP}}`. The default mapping:

| Change | Document to update |
|---|---|
| Business logic, input/output, state, permissions | `docs/specs/<domain>.md` |
| Architecture, integrations, queues, storage, auth | `docs/architecture.md` |
| UI pattern, layout, component, theme | `docs/design.md` |
| Schema, entity, data | `{{DB_DOCS_PATH}}` |
| Service-specific coding convention | `docs/conventions/<group>.md` |
| Environment deployment steps | The service-local deployment doc |
| A new error and its resolution | The service-local troubleshooting doc |

Rules:

- The agent **proposes** a diff/MR on the docs repo. **The TechLead approves before merge (Gate 2).** Wrong docs poison every later plan.
- If no spec update is needed, `report.md` must state `Docs/specs: N/A` with a verifiable reason.
- A feature must not be marked `done` while the docs/specs status is missing.

### Step 13 — Close out

Per-task close-out:
- [ ] The task's DoD in `tasks.md` is objectively met.
- [ ] Its verification command was run and the real output is in `report.md`.
- [ ] `tasks.md` status updated, with the date.
- [ ] Commit/PR reference recorded if `{{COMMIT_RULE}}` requires it.

Feature close-out (Definition of Done):
- [ ] Every task in `tasks.md` is `done`/`cancelled` (with reason) — none left in progress or blocked.
- [ ] `report.md` contains real verification output for every affected service.
- [ ] `impact.md` finalized.
- [ ] `deploy.md` exists if any `{{DEPLOY_TRIGGERS}}` fired.
- [ ] `{{DB_DOCS_PATH}}` updated, or the reason for waiting on the DBA is recorded.
- [ ] i18n complete with no hardcoded text, if `{{I18N_REQUIRED}}` is true.
- [ ] Docs/specs status recorded and the Gate 2 diff proposed.
- [ ] `plan.md` marked complete, or the remaining scope stated explicitly.
- [ ] `git diff` contains nothing outside the approved scope.

Commit, push, merge and deploy follow `{{COMMIT_RULE}}` and the git rules in `docs/AGENTS.md`. **The agent never commits, pushes, merges or deploys unless explicitly asked**, and stops to ask if the diff contains files outside the task scope or anything resembling a secret or runtime config.

If work is stopped unfinished, the agent reports: current status, remaining tasks, blockers, and every repo/branch/file left dirty.

---

## 5. Scope discipline

1. **Implement only what `tasks.md` approves.** Nothing else.
2. **No opportunistic refactoring.** Improvements outside the task go to `report.md` §6, not into the diff.
3. **No unapproved contract changes** — API shape, message payload, queue/topic, schema, permissions, config. See `{{FORBIDDEN_CHANGES}}`.
4. **No new dependencies** outside `{{DEPENDENCY_POLICY}}`.
5. **Match the existing code style** — naming, layering, error handling, logging, comment language, per `{{CODE_STYLE_RULES}}` and `docs/conventions/`.
6. **Never touch** the do-not-touch paths (generated proxies like `service-proxies.ts`, `bin/`, `obj/`, `target/`, `build/`, `dist/`, secrets, runtime config, legacy copies) — see `docs/AGENTS.md`.
7. **Problems found outside the task are reported, not fixed.**
8. **Ask when blocked.** Never guess business rules, data shapes or permissions in the middle of implementation.

---

## 6. Rejected outputs

The work is sent back if any of these is present:

| Anti-pattern | Why it fails |
|---|---|
| `report.md` claims "tests pass" with no pasted output | Unverifiable; the report is the evidence |
| Code written before Gate 1 approval | The gate exists to prevent exactly this |
| The service was found by grep instead of the registry | Wrong repo edited; registry exists to prevent it |
| The diff contains unrelated refactoring | Reviewer cannot separate the feature from the noise |
| `vs_*` schema changed directly or via EF migration instead of a reviewed SQL script | Environments drift and cannot be reproduced |
| Hardcoded user-visible text in a multi-language project | Breaks localization silently |
| Plan deviated from without updating `plan.md` | The approved design and the code no longer match |
| `deploy.md` missing while a deploy trigger fired | Production breaks at rollout |
| Feature marked `done` with tasks still open, or docs status missing | The definition of done was not met |
| Committed, pushed or merged without being asked | Removes the human decision point |
| A secret/token/credential copied into code, log or docs | Security incident |

---

## 7. Project customization

The generic part ends here. Everything that varies per project lives in:

👉 **`docs/rules/02-implement-task.project-config.md`** (create it from `02-implement-task.project-config.template.md`)
👉 **`docs/rules/01-create-plan.project-config.md`** (the reused keys)
👉 **`docs/AGENTS.md`** + **`docs/project.md`** + **`docs/conventions/`** (service registry, stack, git rules, do-not-touch list)

The agent **must read all of them together with this rule** and follow them wherever they declare a value.
