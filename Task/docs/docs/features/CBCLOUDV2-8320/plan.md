# CBCLOUDV2-8320 Plan

## Goal

Show both tax department name and code in the Chi cục thuế selectbox on the Thông tin chung enterprise information tab, with a clear `Mã:` prefix before the code.

## Context

- UI route: `/app/hddt/cauhinh/thongtindoanhnghiep/thongtinchung`
- Component template: `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html`
- Current option value already uses `chicucthue.ccT_Ma`.
- Current option label only uses `chicucthue.ccT_Ten`.

## Impact Assessment

- Frontend only.
- No API, database, service proxy, or deployment change.
- Save behavior should not change because `[value]` remains `chicucthue.ccT_Ma`.

## Implementation Steps

1. Add a verification check that fails while the template still renders only `ccT_Ten`.
2. Update the Chi cục thuế option label to render `ccT_Ten - Mã: ccT_Ma`.
3. Run the verification check again and confirm it passes.
4. Run a lightweight source search to confirm the target template contains the expected display format.

## Verification Steps

- Check `doanhnghiep-thongtinchung-tab.component.html` contains `{{ chicucthue.ccT_Ten }} - Mã: {{ chicucthue.ccT_Ma }}`.
- Confirm `[value]="chicucthue.ccT_Ma"` remains unchanged.

## Rollback

Revert the option label in `doanhnghiep-thongtinchung-tab.component.html` back to `{{ chicucthue.ccT_Ten }}`.
