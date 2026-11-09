# CBCLOUDV2-9170 Feature Documentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bring CBCLOUDV2-9170 feature documentation in line with the completed province/ward backend and frontend implementation.

**Architecture:** The feature documents distinguish vehicle line-level fields from invoice-header `ma_Tinh` and `ma_Xa`, record host catalog versus tenant invoice schema ownership, and report real verification evidence without inventing manual QA results.

**Tech Stack:** Markdown, ASP.NET Zero/ABP, Angular 6, NSwag, MariaDB.

---

### Task 1: Update Feature Specification and Plan

**Files:**
- Modify: `docs/features/CBCLOUDV2-9170/expect.md`
- Modify: `docs/features/CBCLOUDV2-9170/plan.md`

- [ ] **Step 1: Replace the frontend-only scope with the header-level province/ward requirement**

Document `ma_Tinh` and `ma_Xa` on `HD_HoaDon_MoRong`, host catalogs, province-to-ward cascade, required condition for vehicle subtype 1, searchable combobox placement below buyer address, and original-invoice name display.

- [ ] **Step 2: Record actual backend and frontend implementation choices**

Document host entities, DTOs, services, DbSets, Dapper persistence, explicit invoice projections, the `/api/services/hddt/` route prefix, temporary NSwag contract update, and selectpicker refresh behavior.

### Task 2: Update Task, Test, and Impact Records

**Files:**
- Modify: `docs/features/CBCLOUDV2-9170/tasks.md`
- Modify: `docs/features/CBCLOUDV2-9170/testcase.md`
- Modify: `docs/features/CBCLOUDV2-9170/impact.md`

- [ ] **Step 1: Mark implemented backend/frontend tasks and retain unrun QA checks**

Add completed implementation tasks; leave database execution and manual QA as user-confirmed or not run where evidence is unavailable.

- [ ] **Step 2: Add location cascade, validation, persistence, route, and selectpicker scenarios**

Test cases cover null province returning all wards, selected province filtering wards, required validation only for vehicle subtype 1, reload persistence, original display names, and authorized API response.

- [ ] **Step 3: Finalize impact with actual files, dependencies, and known limitations**

Record backend/DB/contract/frontend scope, the existing dirty generated-proxy risk, proxy regeneration requirement, full solution limitation, and pending manual integration QA.

### Task 3: Create Actual Implementation and Deployment Records

**Files:**
- Create: `docs/features/CBCLOUDV2-9170/report.md`
- Create: `docs/features/CBCLOUDV2-9170/deploy.md`

- [ ] **Step 1: Write report from observed implementation and builds**

List exact source areas changed, targeted backend builds, frontend build evidence where available, direct endpoint routing result (`401` after route correction), and unverified manual flows.

- [ ] **Step 2: Write deploy notes for already-applied schema and contract regeneration**

Specify host catalog tables, tenant invoice columns, data import dependency, backend rollout, endpoint route prefix, `nswag/refresh.bat`, and frontend rollout/QA order.

- [ ] **Step 3: Verify documentation consistency**

Run: `git diff --check`

Expected: No whitespace errors in feature documentation files.
