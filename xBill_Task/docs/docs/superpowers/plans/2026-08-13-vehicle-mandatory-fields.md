# Vehicle Mandatory Fields Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enforce the supplied mandatory vehicle-detail rules in the invoice form without changing database precision.

**Architecture:** A single component validator produces per-line messages for special vehicle details. The UI derives warning rows and button disabled state from that validator, while save/sign guards reuse it. Input rules and enum options match the business contract.

**Tech Stack:** Angular 6, TypeScript, template-driven forms.

---

### Task 1: Validate Vehicle Details

**Files:**
- Modify: `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts`

- [ ] **Step 1: Add one validator returning all missing-field messages per vehicle row**

Require base fields, imported/assembled conditional certificates, used-vehicle `CLTSan`/`SBKSoat`, and `TTai` with at most 9 integer and 2 fractional digits.

- [ ] **Step 2: Use the validator for button disabled state and click guards**

Keep location validation as part of the same overall special-vehicle invalid state.

### Task 2: Align Vehicle UI Rules

**Files:**
- Modify: `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.html`

- [ ] **Step 1: Correct `TTTSan` and `XXu` option values**

Use `0/1` values specified by the contract.

- [ ] **Step 2: Add field lengths and number constraints**

Apply text `maxlength` values and UI-only decimal constraint to `TTai`.

- [ ] **Step 3: Show each vehicle validation message and disable action buttons**

Render `m--font-danger` list items from the shared validator; retain current location warning.

### Task 3: Update Feature Docs

**Files:**
- Modify: `docs/features/CBCLOUDV2-9170/expect.md`
- Modify: `docs/features/CBCLOUDV2-9170/testcase.md`
- Modify: `docs/features/CBCLOUDV2-9170/impact.md`

- [ ] **Step 1: Record mandatory rules, enum values, UI-only `TTai` constraint, and pending QA**
