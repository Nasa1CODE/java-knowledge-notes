# CBCLOUDV2-9257 Test Cases

## Preconditions

- Dung template import moi GTGT, Ban hang hoac Ve xe.
- Dong test co `tinhchat = 4`, `loaihoadondactrung = 1`.
- Chuan bi file <= 50 dong cho BE va file > 50 dong cho worker.

| ID | Scenario | Expected | Status |
|---|---|---|---|
| TC01 | Xe moi (`tinhtrangtaisan = 0`) de trong 9 field | Khong bao required 9 field | pass - unit worker |
| TC02 | Xe da dung de trong `ma_nuocsx` | Bao Ma Nuoc san xuat khong duoc de trong | pass - unit worker |
| TC03 | Xe da dung de trong `ten_loaitaisan` | Bao Ten loai tai san dang ky khong duoc de trong | pass - unit worker |
| TC04 | Xe da dung de trong `namsanxuat` | Bao Nam san xuat khong duoc de trong | pass - unit worker |
| TC05 | Xe da dung de trong `ten_thuongmai` | Bao Ten thuong mai khong duoc de trong | pass - unit worker |
| TC06 | Xe da dung de trong `ten_nhanhieu` | Bao Ten nhan hieu khong duoc de trong | pass - unit worker |
| TC07 | Xe da dung de trong `kieuloaixe` | Bao Kieu loai xe khong duoc de trong | pass - unit worker |
| TC08 | Xe da dung de trong `thetich_congsuat` | Bao The tich/Cong suat khong duoc de trong | pass - unit worker |
| TC09 | Xe da dung de trong `trongtai` | Bao Trong tai khong duoc de trong | pass - unit worker |
| TC10 | Xe da dung de trong `sochongoi` | Bao So nguoi cho phep cho khong duoc de trong | pass - unit worker |
| TC11 | Xe moi co 3 field so la chu | Bao du lieu khong hop le, khong coi la o trong | pass - unit worker |
| TC12 | Xe moi co nam > 4 chu so, trong tai vuot 9,2, so cho > 9999 | Bao du lieu khong hop le | pass - unit worker |
| TC13 | Xe moi co field chuoi vuot maxlength | Bao vuot do dai hien tai | pass - unit worker |
| TC14 | Thieu So khung/So may/Loai tai san/Tinh trang/Xuat xu | Rule cu van bao loi | pass - unit worker |
| TC15 | Nhap khau/lap rap thieu chung tu | Rule cu van bao loi | pass - unit worker |
| TC16 | Xe da dung thieu Chat luong tai san/Bien kiem soat | Rule cu van bao loi | pass - unit worker |
| TC17 | Template cu hoac subtype khac 1 | Khong chay rule 9 field | pass - unit worker |
| TC18 | Mot hoa don tron dong xe moi/xe da dung | Validate dung theo tung dong | not run |
| TC19 | Lap TC01-TC18 voi file <= 50 dong | BE tra dung ket qua | not run |
| TC20 | Lap TC01-TC18 voi file > 50 dong | Worker tra ket qua giong BE | not run |

## Loai hoa don can lap lai

- Hoa don GTGT.
- Hoa don Ban hang.
- Hoa don Ve xe.

## Ngoai pham vi

- FE.
- API tich hop.
- XML/PDF.
