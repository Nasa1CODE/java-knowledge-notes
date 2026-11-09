# CBCLOUDV2-8736 Invoice Sales Totals Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Calculate and display the sales-invoice totals using the approved discount and resolution tax-rate formulas.

**Architecture:** Keep total calculation centralized in `HoaDonService.tinhTongChi_406`, which is reached from all sales-invoice line update paths through `tinhChiTietThue_406`. Add a focused helper that groups goods and discount lines by `vat_Rate`; use its result only for resolution invoices, while preserving the existing aggregation for all other invoices. Make the computed total fields read-only in the sales invoice template.

**Tech Stack:** Angular 6, TypeScript 2.x, RxJS, lodash, PrimeNG, existing `input-number` component.

---

## File Structure

- Modify `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts`: add a small 406 sales-total aggregation helper and use it from `tinhTongChi_406`.
- Modify `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html`: expose the computed values as right-aligned read-only controls and keep the required explanatory text.
- Create `docs/features/CBCLOUDV2-8736/expect.md`: record approved behavior and acceptance criteria.
- Create `docs/features/CBCLOUDV2-8736/plan.md`: record service scope, calculation behavior, risks, and deployment impact.
- Create `docs/features/CBCLOUDV2-8736/tasks.md`: track implementation tasks and verification.
- Create `docs/features/CBCLOUDV2-8736/testcase.md`: record positive, negative, regression, UI, and edge-case scenarios.
- Create `docs/features/CBCLOUDV2-8736/impact.md`: record the confirmed blast radius and unaffected components.

### Task 1: Define the feature documentation

**Files:**
- Create: `docs/features/CBCLOUDV2-8736/expect.md`
- Create: `docs/features/CBCLOUDV2-8736/plan.md`
- Create: `docs/features/CBCLOUDV2-8736/tasks.md`
- Create: `docs/features/CBCLOUDV2-8736/testcase.md`
- Create: `docs/features/CBCLOUDV2-8736/impact.md`

- [ ] **Step 1: Write expected behavior and scope**

Create `expect.md` with the route, `HoaDonBanHangComponent`, formula definitions, the TH1/TH2/TH3 expected results, read-only UI requirements, negative payment-text requirement, and out-of-scope API/database/proxy changes.

- [ ] **Step 2: Write the implementation plan and impact assessment**

Document that `tinhTongChi_406` is the calculation boundary, that a helper groups `hangHoa_Loai == 3` discount lines and goods/service lines by `vat_Rate`, and that only invoices with `loaiHoaDon406 > 0` and positive `vat_Rate` use the new total formula.

- [ ] **Step 3: Write executable acceptance scenarios**

Include these expected inputs and outputs in `testcase.md`:

```text
TH1: goods 100000 @ 5%, discount 10000 @ 5% => total goods 89100
TH2: goods 100000 @ 5%, discount 10000 @ 3% => total goods 89060
TH3: goods 100000 @ 5%, discount 10000 @ 3%, goods 50000 @ 3% => total goods 138760
```

Also include no-resolution regression, no-goods rate group, no-discount rate group, zero commercial discount, negative payment amount, and read-only field scenarios.

- [ ] **Step 4: Confirm docs have no implementation claims**

Run: `git diff -- docs/features/CBCLOUDV2-8736`

Expected: documents describe pending work only; no build or test is reported as passed.

- [ ] **Step 5: Commit**

```bash
git add docs/features/CBCLOUDV2-8736
```

### Task 2: Add a rate-grouped 406 sales-total calculator

**Files:**
- Modify: `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts:4051-4307`

- [ ] **Step 1: Write the failing calculation test or reproducible harness**

If the project has an existing unit-test target for `HoaDonService`, add a test suite that instantiates the service with rounding disabled and asserts the three required examples. If no runnable Angular unit-test seam exists, add the three cases to `docs/features/CBCLOUDV2-8736/testcase.md` as manual scenarios and use the browser screen to capture the expected values.

- [ ] **Step 2: Execute the test or harness before implementation**

Run: `npm test -- --watch=false`

Expected: the new assertions fail before the grouped calculation is implemented, or record that the legacy test runner cannot execute without a browser/dependency environment.

- [ ] **Step 3: Add a focused grouped-total helper**

In `HoaDonService`, add a private helper with this behavior:

```typescript
private tinhTongTienHang406TheoTyLe(hoaDon: HD_HoaDonDto, lines: HD_ChiTietDto[]) {
    // Return undefined unless loaiHoaDon406 > 0 and at least one line has vat_Rate > 0.
    // Group non-discount lines and hangHoa_Loai == 3 discount lines by vat_Rate.
    // Calculate each reduction as (goods - discount) * rate * 20 / 100.
    // Return total goods, total discount lines, total per-line discounts, and total reduction.
}
```

Use `Number(value) || 0` for amounts/rates. Preserve discount values as deductions, including when a source amount is negative. Do not mutate line amounts inside the helper.

- [ ] **Step 4: Use the helper from `tinhTongChi_406`**

After existing line classification and before assigning `hoaDon.tongHop_TienHang`, use the helper result only when it is defined:

```typescript
const computed = this.tinhTongTienHang406TheoTyLe(hoaDon, dsTinhChiTiet);
if (computed) {
    tongTienHang = computed.totalGoods;
    tongTienGiam406 = computed.totalReduction;
    tongTienHangCK = computed.totalDiscountLines;
    tongTienChietKhau = computed.totalLineDiscounts;
}
```

Calculate payment total from `tongTienHang + tongTienThue`, retain the existing enterprise rounding policy, and continue invoking `tinhTongTienBangChu` after assigning the totals.

- [ ] **Step 5: Verify the calculation examples**

Run: `npm test -- --watch=false`

Expected: TH1 gives `89100`, TH2 gives `89060`, and TH3 gives `138760`; no-resolution regression tests retain their existing result.

- [ ] **Step 6: Commit**

```bash
git add frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts docs/features/CBCLOUDV2-8736
```

### Task 3: Lock calculated sales-invoice total fields

**Files:**
- Modify: `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html:1525-1631`

- [ ] **Step 1: Make commercial discount total read-only**

Replace its editable `input-number` binding with a disabled `input-number` bound to `hoaDon.tongHop_TongTien_ChietKhau_ThuongMai`, using `inputClass="form-control number-format text-lg-right"`. Remove its `inputModelChange` callback.

- [ ] **Step 2: Keep all calculated totals consistently right-aligned and read-only**

For `tongHop_TienHang` and `tongHop_TongTien_CoVAT`, use the same right-aligned disabled input class. Keep their existing `disabled` attributes and remove callbacks that imply user editing when present.

- [ ] **Step 3: Render payment text as calculated-only**

Retain display binding `{{ hoaDon.tongHop_TongTien_CoVAT_Chu }}` instead of an editable `<input>`. Confirm that the existing `tinhTongTienBangChu` output is the only source for this field.

- [ ] **Step 4: Verify browser behavior manually**

Run: `npm start`

Expected: navigate to `/app/hddt/hoadon-hoadonbanhang-goc`, enter the TH1/TH2/TH3 data, observe the documented totals, verify the three numeric total fields cannot receive edits, and verify a negative payment result begins with `Âm`.

- [ ] **Step 5: Commit**

```bash
git add frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html docs/features/CBCLOUDV2-8736
```

### Task 4: Run production verification and finalize feature records

**Files:**
- Modify: `docs/features/CBCLOUDV2-8736/tasks.md`
- Modify: `docs/features/CBCLOUDV2-8736/testcase.md`
- Modify: `docs/features/CBCLOUDV2-8736/impact.md`
- Create: `docs/features/CBCLOUDV2-8736/report.md`

- [ ] **Step 1: Run the production build**

Run: `npm run build`

Expected: Angular production build exits with code `0` and reports no TypeScript template or compilation errors.

- [ ] **Step 2: Record real verification evidence**

Mark only executed test cases as passed in `testcase.md`; put the exact build/test command and result in `report.md`. Mark unexecuted browser scenarios as `not run` with their environment dependency.

- [ ] **Step 3: Finalize impact assessment**

List `frontend_angular/` service calculation and the sales invoice template as affected. Confirm API services, generated proxy `service-proxies.ts`, database schema, workers, queues, configs, and other invoice-type components remain unchanged.

- [ ] **Step 4: Commit**

```bash
git add docs/features/CBCLOUDV2-8736
```
