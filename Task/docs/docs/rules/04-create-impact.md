# Rule 04 - Create Impact

Use this rule to create `impact.md` for a feature: a focused impact assessment of what a change touches, what it does not, and what risk it carries. Create or update it during planning and keep it current through implementation.

## Purpose

Give DEV, TechLead, QA, and BA a single place to see the blast radius of a change before and after implementation:

- Which services, files, APIs, queues, configs, database objects, and UI areas are affected.
- Which related areas were deliberately left unchanged and why.
- What risks, limitations, and unverified items remain.

`impact.md` complements the other feature files. It does not replace `plan.md` (how to build), `report.md` (what was actually built), or `testcase.md` (how to verify).

## Required Input

- `docs/features/<TICKET-ID>/expect.md`
- `docs/features/<TICKET-ID>/plan.md` when available
- `docs/architecture.md`, `docs/design.md`, and relevant `docs/specs/*.md`
- Actual affected source when implementation has started (to keep the impact accurate)

## Required Output

- `docs/features/<TICKET-ID>/impact.md`

## When To Create And Update

- Create a first draft during planning (Rule 01), based on the plan's impact assessment.
- Update it whenever scope changes, a new affected file/service is discovered, or an out-of-scope decision is made during implementation (Rule 02).
- Finalize it after implementation so it reflects the real changed files and real known limitations.

## Workflow

1. Run `git pull` inside `docs/` before reading or writing docs.
2. Read `expect.md` to understand intended scope and out-of-scope items.
3. Read `plan.md` (if present) for the planned impact assessment and affected files.
4. Inspect affected source only enough to confirm the real blast radius; do not guess.
5. Write `impact.md` with the required sections below.
6. Keep it in sync with `plan.md`, `tasks.md`, and `report.md` as work progresses.

## `impact.md` Requirements

`impact.md` must include:

- **Purpose**: one short paragraph naming the change and the ticket.
- **Phạm vi thay đổi / Change scope**: whether this is logic-only, data-affecting, schema-affecting, contract-affecting; explicitly state if there is no DB/schema/migration change.
- **Thành phần bị ảnh hưởng / Affected components**: a table per layer (backend service/file/method, frontend screen/file, database object, queue/config), each with an impact level (`Thấp`/`Trung bình`/`Cao` or `Low`/`Medium`/`High`).
- **Không thuộc phạm vi / Confirmed unaffected**: related areas that could look affected but are deliberately not changed, each with a one-line reason. This prevents QA from raising false defects.
- **Rủi ro / Hạn chế đã biết / Known risks and limitations**: incomplete behavior, unconfirmed design decisions, backward-compatibility concerns, and anything that needs BA/TechLead confirmation.
- **Chưa được kiểm chứng / Not verified**: builds, tests, or manual checks that were skipped or not yet done.
- **Kết luận / Conclusion**: a short overall risk statement and recommendation before release.

## Output Rules

- Impact levels must be justified by real affected files, not guessed.
- List confirmed-unaffected areas explicitly; "everything else is unaffected" is not acceptable.
- Record unconfirmed design decisions and open questions instead of presenting them as final.
- Do not copy secrets, credentials, tokens, or production-only values into `impact.md`.
- Keep `impact.md` consistent with `plan.md` and `report.md`; if they disagree, fix the inconsistency rather than leaving both.

## Relationship To Gates

- `impact.md` is an input to Gate 1 review: TechLead uses it to judge blast radius before approving implementation.
- If the impact assessment reveals changes to `docs/specs/` or `docs/architecture.md`, those still require Gate 2 TechLead approval before merging.
