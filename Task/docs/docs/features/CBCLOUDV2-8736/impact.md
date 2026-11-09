# CBCLOUDV2-8736 Impact

## Scope

Frontend-only client calculation/UI change for target sales-invoice route. No API, DTO, proxy, schema, migration, or contract change. Client-calculated invoice model values can change and persist on save.

## Affected components

| Component | Impact | Reason |
| --- | --- | --- |
| `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts` | High | Shared 406 context, grouped/ungrouped aggregate, tax/fallback, and persisted totals. |
| `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts` | Medium | Explicit context propagation from target component. |
| `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html` | Medium | Selector/detail calls and readonly/right-aligned total UI/tooltips. |
| API/DTO/schema/contract/workers/queue/config/deployment | None | No planned service or infrastructure change. |

## Pending and risks

- Other screens are pending verification until every caller is inventoried in `report.md`, defaults are preserved, and route/caller QA completes. Current source line/path mentions are candidate references can xac minh khi trien khai, not confirmed inventory.
- Invalid VAT rates, signed discount, rounding config, number-to-text, and persisted save behavior need actual fixture evidence.
- No implementation/build/QA evidence exists yet.

## Conclusion

Risk is medium-high because shared frontend logic can persist changed totals. Gate 1 requires caller inventory and equation review; release requires build and QA evidence.
