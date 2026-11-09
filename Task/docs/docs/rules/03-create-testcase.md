# Rule 03 - Create Testcase

Use this rule after `expect.md` exists and before implementation starts. `plan.md` may be referenced, but test cases must come from the expected behavior, not from implementation assumptions.

## Required Input

- `docs/features/<TICKET-ID>/expect.md`
- `docs/features/<TICKET-ID>/plan.md` when available
- Relevant `docs/specs/*.md` files

## Required Output

- `docs/features/<TICKET-ID>/testcase.md`

## Workflow

1. Run `git pull` inside `docs/` before reading or writing docs.
2. Read `expect.md` and extract acceptance criteria, out-of-scope items, and open questions.
3. Read `plan.md` only to understand affected services and verification commands.
4. Create `testcase.md` with positive, negative, regression, permission, integration, and edge-case scenarios where applicable.
5. Include expected results and status for each scenario.
6. Mark scenarios as not run until real verification evidence exists.

## Rule

Do not derive expected behavior from implementation code. Expected behavior must trace back to `expect.md` and approved product requirements.
