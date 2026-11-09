# VPBank Frontend Runtime Toggle Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Hide the VPBank lending navigation entry unless the runtime application configuration explicitly enables it.

**Architecture:** `AppPreBootstrap` reads the JSON runtime configuration before Angular bootstraps and stores a boolean in `AppConsts`. `AppNavigationService` conditionally appends the existing VPBank item to its menu list, leaving route and API behavior unchanged.

**Tech Stack:** Angular 6, TypeScript 2.9, runtime JSON configuration.

---

### Task 1: Add Runtime-Gated VPBank Navigation

**Files:**
- Modify: `frontend_angular/src/assets/appconfig.json`
- Modify: `frontend_angular/src/assets/appconfig.production.json`
- Modify: `frontend_angular/src/shared/AppConsts.ts`
- Modify: `frontend_angular/src/AppPreBootstrap.ts`
- Modify: `frontend_angular/src/app/shared/layout/nav/app-navigation.service.ts`

- [ ] **Step 1: Add `enableVPBankLending: false` to both runtime configuration files.**
- [ ] **Step 2: Add `static enableVPBankLending = false` to `AppConsts` and assign it only when runtime JSON contains the boolean value `true`.**
- [ ] **Step 3: Replace the unconditional VPBank `AppMenuItem` with a conditional append when `AppConsts.enableVPBankLending` is true.**
- [ ] **Step 4: Run the configured frontend verification command and inspect the diff; leave all changes uncommitted.**
