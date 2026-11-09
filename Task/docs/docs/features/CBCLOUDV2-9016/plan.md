# CBCLOUDV2-9016 Plan

1. Inspect each route/component that owns a `Dinh kem bang ke` checkbox.
2. Trace create/edit adjustment flow from route params to `getHoaDonGoc()` and `createOrEditInv`.
3. Add FE handling to clear bang ke fields when unchecked.
4. Ensure save/trinh ky/ky paths reuse the same preparation logic.
5. Guard original-invoice mapping so unchanged flows preserve bang ke, but cleared flows are not repopulated from `hoaDonGoc`.
6. Ensure BE persists null/empty bang ke values when `File_BangKe_Sua == true` in both `Update()` and `UpdateDataInv()`.
7. Add docs, impact notes, and regression cases so the same pattern can be reused by other invoice screens/services.
