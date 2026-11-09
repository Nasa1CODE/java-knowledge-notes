# CBCLOUDV2-9257 Plan

## Muc tieu va scope

Cap nhat dong bo BE import truc tiep va service import nen. Giai doan hien tai chi lap tai lieu, chua sua code.

Khong sua FE, API tich hop, DB, DTO, mapping hoac XML.

## Rule dich

Rule chi ap dung voi template moi va dong `tinhchat = 4`, `loaihoadondactrung = 1`.

- Tao `isUsedVehicle = data.tinhtrangtaisan == 1`.
- Ca 9 field `ma_nuocsx`, `ten_loaitaisan`, `namsanxuat`, `ten_thuongmai`, `ten_nhanhieu`, `kieuloaixe`, `thetich_congsuat`, `trongtai`, `sochongoi` chi required khi `isUsedVehicle`.
- Khong tao dieu kien theo `loaitaisan`.
- Field optional de trong thi hop le; field optional co gia tri sai van bao loi.

## Danh sach field can fix trong code

| Field import | Property `HoaDonRow` | Property luu `HD_ChiTiet_MoRong` | Code required hien tai | Code sau fix |
|---|---|---|---|---|
| Ma Nuoc san xuat | `data.ma_nuocsx` | `MNSXuat` | Bat buoc moi dong xe loai 1 | Chi bat buoc khi `data.tinhtrangtaisan == 1` |
| Ten loai tai san dang ky | `data.ten_loaitaisan` | `TLTSDKy` | Bat buoc moi dong xe loai 1 | Chi bat buoc khi `data.tinhtrangtaisan == 1` |
| Nam san xuat | raw `namSanXuatText`, parsed `data.namsanxuat` | `NSXuat` | Bat buoc moi dong xe loai 1 | Chi bat buoc khi `data.tinhtrangtaisan == 1` |
| Ten thuong mai | `data.ten_thuongmai` | `TTMai` | Bat buoc moi dong xe loai 1 | Chi bat buoc khi `data.tinhtrangtaisan == 1` |
| Ten nhan hieu | `data.ten_nhanhieu` | `TNHieu` | Bat buoc moi dong xe loai 1 | Chi bat buoc khi `data.tinhtrangtaisan == 1` |
| Kieu loai xe | `data.kieuloaixe` | `KLXe` | Bat buoc moi dong xe loai 1 | Chi bat buoc khi `data.tinhtrangtaisan == 1` |
| The tich lam viec hoac Cong suat | `data.thetich_congsuat` | `TTLVHCSuat` | Bat buoc moi dong xe loai 1 | Chi bat buoc khi `data.tinhtrangtaisan == 1` |
| Trong tai | raw `trongTaiText`, parsed `data.trongtai` | `TTai` | Bat buoc moi dong xe loai 1 | Chi bat buoc khi `data.tinhtrangtaisan == 1` |
| So nguoi cho phep cho | raw `soChoNgoiText`, parsed `data.sochongoi` | `SCNgoi` | Bat buoc moi dong xe loai 1 | Chi bat buoc khi `data.tinhtrangtaisan == 1` |

Chi sua required condition cua 9 field tren. Cac lenh mapping sang `HD_ChiTiet_MoRong` duoc giu nguyen.

## Step 1 - Sua BE import truc tiep

Source:

`invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`

1. Giu nguyen `IsNewVehicleAssetImportTemplate(...)`, `ReadVehicleAssetImportFields(...)` va `IsVehicleAssetImportRow(...)`.
2. Chi sua `ValidateVehicleAssetImportDetailFields(...)`.
3. Dat `isUsedVehicle` sau guard `IsVehicleAssetImportRow(data)`.
4. Sua tung required text hien tai:
   - `if (string.IsNullOrWhiteSpace(data.ma_nuocsx))`.
   - `if (string.IsNullOrWhiteSpace(data.ten_loaitaisan))`.
   - `if (string.IsNullOrWhiteSpace(data.ten_thuongmai))`.
   - `if (string.IsNullOrWhiteSpace(data.ten_nhanhieu))`.
   - `if (string.IsNullOrWhiteSpace(data.kieuloaixe))`.
   - `if (string.IsNullOrWhiteSpace(data.thetich_congsuat))`.
5. Them `isUsedVehicle &&` vao 6 dieu kien tren; khong gom cac maxlength check vao nhanh nay.
6. Sua block `namsanxuat` thanh ba nhanh ro rang:
   - `isUsedVehicle && string.IsNullOrWhiteSpace(namSanXuatText)`: bao required.
   - Raw text khong trong va `!data.namsanxuat.HasValue`: bao du lieu khong hop le.
   - Co parsed value nhung raw dai hon 4 ky tu hoac ngoai 0-9999: bao du lieu khong hop le.
7. Sua block `trongtai`:
   - `isUsedVehicle && string.IsNullOrWhiteSpace(trongTaiText)`: bao required.
   - Raw text khong trong va `!data.trongtai.HasValue`: bao du lieu khong hop le.
   - Co parsed value va sai `decimal 9,2`: bao du lieu khong hop le.
8. Sua block `sochongoi`:
   - `isUsedVehicle && string.IsNullOrWhiteSpace(soChoNgoiText)`: bao required.
   - Raw text khong trong va `!data.sochongoi.HasValue`: bao du lieu khong hop le.
   - Co parsed value ngoai 0-9999: bao du lieu khong hop le.
9. Giu nguyen toan bo maxlength, enum, chung tu theo xuat xu, chat luong tai san, bien kiem soat va message.
10. Khong sua vi tri cot GTGT/Ban hang/Ve xe, mapping `HD_ChiTiet_MoRong` hoac `HD_HoaDon_MoRong`.

## Step 2 - Sua service import nen

Source chinh:

`svinvoicesendemail/AppServiceImportBillHost/AppService/Models/VehicleAssetImportHelper.cs`

1. Giu nguyen `IsNewTemplate(...)`, `ReadFields(...)` va `IsVehicleAssetRow(...)`.
2. Chi sua `ValidateDetailFields(...)` theo dung thu tu/rule cua BE.
3. Boc chinh xac 6 lenh sau vao `if (isUsedVehicle)`:
   - `Require(message, data.ma_nuocsx, "Ma Nuoc san xuat")`.
   - `Require(message, data.ten_loaitaisan, "Ten loai tai san dang ky")`.
   - `Require(message, data.ten_thuongmai, "Ten thuong mai")`.
   - `Require(message, data.ten_nhanhieu, "Ten nhan hieu")`.
   - `Require(message, data.kieuloaixe, "Kieu loai xe")`.
   - `Require(message, data.thetich_congsuat, "The tich lam viec hoac Cong suat")`.
4. Thay ba lenh `RequireNumber(...)` cua `namSanXuatText/data.namsanxuat`, `trongTaiText/data.trongtai`, `soChoNgoiText/data.sochongoi` bang validation co dieu kien:
   - Raw trong: chi required khi xe da dung.
   - Raw khong trong va parsed value null: bao du lieu khong hop le.
   - Parsed value co: validate gioi han hien tai.
5. Giu nguyen `ApplyHoaDonMoRong(...)`, `ApplyChiTietMoRong(...)`, repository va catalog Tinh/Xa.
6. Khong sua ba router `Service/NhapDSHoaDonExcelHelper.cs`, `Service/BanHang_ExcelHelper.cs`, `Service/ImportVeXeHelper.cs`.
7. Xac nhan ba router van truyen dung raw value va `VehicleAssetImportColumns` vao helper chung.

## Step 3 - Bo sung automated test service nen

File:

`svinvoicesendemail/AppServiceImportBillHost/AppServiceTest/VehicleAssetImportHelperTests.cs`

1. Cap nhat case missing required hien tai de dung `tinhtrangtaisan = 1`.
2. Them case xe moi de trong ca 9 field va xac nhan khong co message required.
3. Them parameterized case xe da dung thieu tung field trong nhom 9 va xac nhan message dung.
4. Them case xe moi co `namsanxuat`, `trongtai`, `sochongoi` sai kieu va xac nhan van bao loi.
5. Them case xe moi co ba field so vuot format va xac nhan van bao loi.
6. Regression subtype khac 1, template cu, enum, xuat xu, chat luong tai san va bien kiem soat.

## Step 4 - Verify BE va service nen

1. Build `invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj`.
2. Chay test `svinvoicesendemail/AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj`.
3. Build `svinvoicesendemail/AppServiceImportBillHost/AppService.sln`; neu output bi lock, build ra output tam va ghi ro trong report.
4. Manual import GTGT, Ban hang, Ve xe voi file <= 50 dong de vao BE truc tiep.
5. Lap lai cung bo du lieu voi file > 50 dong de vao worker.
6. Doi chieu message cua hai luong phai giong nhau.

## Step 5 - Hoan tat tai lieu sau implementation

- Danh dau tung muc trong `tasks.md` theo ket qua thuc te.
- Ghi command/build result va warning hien co vao `report.md`.
- Cap nhat status testcase; khong danh dau pass neu chua chay.
- Neu direct/background chua dong nhat, giu task chua complete.
