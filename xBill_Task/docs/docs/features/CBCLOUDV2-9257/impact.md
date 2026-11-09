# CBCLOUDV2-9257 Impact

## Pham vi anh huong

| Thanh phan | Anh huong |
|---|---|
| `invoicecore` | Import truc tiep <= 50 dong; sua required trong `ValidateVehicleAssetImportDetailFields(...)` |
| `svinvoicesendemail/AppServiceImportBillHost` | Import nen > 50 dong; sua required trong `VehicleAssetImportHelper.ValidateDetailFields(...)` |
| Ba router nen GTGT/Ban hang/Ve xe | Khong sua logic router; tiep tuc dung helper chung |
| `api-cloud-service` | Khong sua |
| `frontend_angular` | Khong sua |
| Database/XML | Khong sua |

## Anh huong hanh vi

- Xe moi duoc import khi de trong 9 truong cua task, neu cac field bat buoc khac hop le.
- Xe da qua su dung van phai co du 9 truong.
- Gia tri optional co truyen sai kieu/format/do dai van bi reject.
- Ket qua validation phai dong nhat giua import truc tiep va import nen.

## Rui ro

- Hai service co implementation validator rieng; neu chi sua mot ben se gay lech ket qua theo so dong file.
- Numeric parser tra nullable cho ca o trong va parse loi; validator phai dua them raw cell text de phan biet hai truong hop.
- Khong sua FE va API tich hop nen hai luong nay tiep tuc giu rule hien tai.

## Rollback

Khoi phuc required check cu trong hai validator import; khong can rollback DB.

