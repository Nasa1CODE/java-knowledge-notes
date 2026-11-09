# CBCLOUDV2-9020 Plan

1. Use Cloud fixes from `CBCLOUDV2-8919` and `CBCLOUDV2-9181` as the reference behavior.
2. Compare MSP invoice forms against Cloud:
   - GTGT: `hoadon-goc`
   - GTTT: `hoadonbanhang`
   - Skip ve may bay because MSP did not already have CKTM checkbox there.
3. Patch only FE state mapping:
   - Copy CKTM from `hoaDonGoc` only when creating a new adjustment/replacement invoice.
   - Always set `tinhChatHoaDon` from the current `hoaDon.quanLy_XacThuc_Loai` after load.
4. Verify by static search and diff. Manual QA remains required on browser/API.
