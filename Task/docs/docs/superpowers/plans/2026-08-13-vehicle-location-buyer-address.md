# Vehicle Location Buyer Address Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Show searchable header-level province and ward comboboxes directly below buyer address only for special vehicle invoices.

**Architecture:** Existing header fields and cascade methods remain the source of truth. The editable vehicle panel no longer contains location controls; the buyer-information form renders selectpicker controls bound to the same header values, preserving validation and original-invoice read-only name display.

**Tech Stack:** Angular 6, Bootstrap selectpicker, TypeScript, template-driven forms.

---

### Task 1: Move Location Comboboxes

**Files:**
- Modify: `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.html`

- [ ] **Step 1: Remove the two editable location fields from the vehicle panel**

Remove the `xe-field` blocks bound to `ma_Tinh` and `ma_Xa` from the editable vehicle panel. Keep the original-invoice read-only fields unchanged.

- [ ] **Step 2: Add searchable buyer-address controls after `dnMua_DiaChi`**

Render a `row` only when an invoice detail satisfies:

```html
item.hangHoa_Loai == 4 && item.hD_ChiTiet_MoRong && item.hD_ChiTiet_MoRong.loai_HangHoa_DacTrung == 1
```

Use selectpicker controls bound to header values:

```html
<select class="form-control m-input combobox no-border" jq-plugin="selectpicker"
    [attr.data-live-search]="true" [(ngModel)]="hoaDon.hD_HoaDon_MoRong.ma_Tinh"
    (ngModelChange)="onChangeTinh($event)" name="Ma_Tinh">
```

The ward combobox binds `ma_Xa`, shows `lstXa`, and is disabled until a province is selected.

- [ ] **Step 3: Verify markup and build**

Run: `$env:NODE_OPTIONS='--openssl-legacy-provider'; npm run build`

Expected: Angular build exits with code 0.
