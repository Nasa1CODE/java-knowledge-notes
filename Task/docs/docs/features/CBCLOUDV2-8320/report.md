# CBCLOUDV2-8320 Report

## Summary

Updated the Chi cục thuế selectbox on the enterprise information Thông tin chung tab so each tax department option shows both name and code, with `Mã:` before the code for clarity.

## Files Changed

- `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html`
- `docs/features/CBCLOUDV2-8320/expect.md`
- `docs/features/CBCLOUDV2-8320/plan.md`
- `docs/features/CBCLOUDV2-8320/tasks.md`
- `docs/features/CBCLOUDV2-8320/testcase.md`
- `docs/features/CBCLOUDV2-8320/report.md`
- `docs/features/CBCLOUDV2-8320/deploy.md`

## Implementation Details

- Changed the display text for each Chi cục thuế option from `{{ chicucthue.ccT_Ten }}` to `{{ chicucthue.ccT_Ten }} - Mã: {{ chicucthue.ccT_Ma }}`.
- Kept `[value]="chicucthue.ccT_Ma"` unchanged so save behavior continues to use the tax department code.
- Kept the blank option unchanged.

## Verification

### Red Check

Before implementation, the source verification failed because the expected label was missing:

```text
AssertionError: missing expected option label: {{ chicucthue.ccT_Ten }} - Mã: {{ chicucthue.ccT_Ma }}
```

### Green Check

After implementation, the source verification passed:

```text
PASS: clear label, value, and blank option are correct
```

### Build Check

Frontend production build completed successfully:

```text
npm run build
```

The build command regenerated files under `frontend_angular/build/`. Those generated files were restored afterward per user confirmation, leaving only the source template change in the frontend_angular working tree.

## Deployment

- No database change.
- No configuration change.
- No environment change.
