# CBCLOUDV2-9257 Report

## Status

- Implementation complete for BE import truc tiep va background import service.
- Automated test: passed 30/30 test tren `AppServiceTest`.
- Build `HDDT.Application`: thanh cong, 0 error.
- Manual QA bang file import <= 50 va > 50 dong: chua chay.

## Implemented Change

Dong bo required validation cho 9 field hang hoa dac trung loai 1 tai:

- `invoicecore`: import truc tiep <= 50 dong.
- `svinvoicesendemail/AppServiceImportBillHost`: import nen > 50 dong.

Chin field chi bat buoc khi `tinhtrangtaisan = 1`, khong phan biet `loaitaisan`. Field optional co du lieu van validate format va do dai.

## Changed Source

- `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`.
- `svinvoicesendemail/AppServiceImportBillHost/AppService/Models/VehicleAssetImportHelper.cs`.
- `svinvoicesendemail/AppServiceImportBillHost/AppServiceTest/VehicleAssetImportHelperTests.cs`.
- `svinvoicesendemail/AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj`.

## Verification

- `dotnet test AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj --no-restore`: passed 30/30.
- `dotnet build invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore`: succeeded, 0 error.
- Service nen dang target `netcoreapp2.1` va co cac canh bao EOL/package vulnerability ton tai san; khong phat sinh boi thay doi nay.

## Confirmed Out Of Scope

- Frontend.
- API tich hop `api-cloud-service`.
- Database.
- Mapping va XML/PDF.
