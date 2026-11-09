# CBCLOUDV2-9257 Tasks

## Task List

| ID | Cong viec | Service | Status |
|---|---|---|---|
| T01 | Chot rule 9 field chi theo `tinhtrangtaisan = 1` | Docs | complete |
| T02 | Sua required 6 field text | `invoicecore` | complete |
| T03 | Sua required/format 3 field so | `invoicecore` | complete |
| T04 | Dong bo required 6 field text | Import worker | complete |
| T05 | Dong bo required/format 3 field so | Import worker | complete |
| T06 | Bo sung unit test `VehicleAssetImportHelperTests` | Import worker | complete |
| T07 | Regression template/subtype/enum/xuat xu/xe da dung bang unit test | Import worker | complete |
| T08 | Build `HDDT.Application` | `invoicecore` | complete |
| T09 | Test va build `AppServiceImportBillHost` | Import worker | complete |
| T10 | Manual test GTGT/Ban hang/Ve xe <= 50 va > 50 dong | QA | pending |
| T11 | Cap nhat report va testcase theo ket qua | Docs | complete |

## Source du kien thay doi

- `invoicecore/.../NhapDSHoaDonExcelHelper.cs`.
- `svinvoicesendemail/.../Models/VehicleAssetImportHelper.cs`.
- `svinvoicesendemail/.../AppServiceTest/VehicleAssetImportHelperTests.cs`.
- `svinvoicesendemail/.../AppServiceTest/AppServiceTest.csproj` de bat test discovery.

## Scope Lock

- Co BE import truc tiep va service import nen.
- Khong co FE hoac API tich hop.
