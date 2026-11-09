# CBCLOUDV2-8320 Testcase

## Source

- Based on `expect.md`.

## Test Cases

| ID | Scenario | Steps | Expected Result | Status |
| --- | --- | --- | --- | --- |
| TC-01 | Chi cục thuế option shows name and code | Inspect `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html`. | Each non-empty option displays `ccT_Ten - Mã: ccT_Ma`. | passed by source verification |
| TC-02 | Selected value remains tax department code | Inspect the same select option binding. | The option value remains `chicucthue.ccT_Ma`; only display text changes. | passed by source verification |
| TC-03 | Empty option remains available | Inspect the same selectbox. | The blank option remains present before the tax department list. | passed by source verification |

## Verification Evidence

```text
PASS: clear label, value, and blank option are correct
```
