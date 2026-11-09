# CBCLOUDV2-8919 Test Cases

| Case | Expected | Status |
| --- | --- | --- |
| VE_MAYBAY new invoice `loaiHoaDon=1`, `QuanLy_XacThuc_Loai=1` | CKTM checkbox is visible and checked | not run |
| VE_MAYBAY replacement invoice `loaiHoaDon=3`, original `QuanLy_XacThuc_Loai=1` | CKTM checkbox is visible and checked | not run |
| VE_MAYBAY adjustment invoice `loaiHoaDon=5`, original `QuanLy_XacThuc_Loai=1` | CKTM checkbox is visible and checked | not run |
| GTGT/hoadon-goc replacement or adjustment from original CKTM invoice | CKTM checkbox is visible and checked | not run |
| GTTT/hoadonbanhang replacement or adjustment from original CKTM invoice | CKTM checkbox is visible and checked | not run |
| User unchecks CKTM checkbox and saves | `QuanLy_XacThuc_Loai` is saved as `0` | not run |
| User checks CKTM checkbox and saves | `QuanLy_XacThuc_Loai` is saved as `1` | not run |
