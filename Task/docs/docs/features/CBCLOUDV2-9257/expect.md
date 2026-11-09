# CBCLOUDV2-9257 Expect

## Muc tieu

Dieu chinh dieu kien bat buoc cua 9 truong hang hoa dac trung loai 1 trong hai luong import Excel:

- BE import truc tiep tai `invoicecore` cho file <= 50 dong.
- Service import nen tai `svinvoicesendemail/AppServiceImportBillHost` cho file > 50 dong.

## Dieu kien ap dung

Rule moi chi chay khi file la template moi va dong import thoa:

- `tinhchat = 4`.
- `loaihoadondactrung = 1`.

`tinhtrangtaisan = 1` la xe da qua su dung; `tinhtrangtaisan = 0` la xe chua qua su dung.

## Expected Behavior

Chin truong sau chi bat buoc khi `tinhtrangtaisan = 1`:

- `ma_nuocsx`.
- `ten_loaitaisan`.
- `namsanxuat`.
- `ten_thuongmai`.
- `ten_nhanhieu`.
- `kieuloaixe`.
- `thetich_congsuat`.
- `trongtai`.
- `sochongoi`.

Khong phan biet `loaitaisan` khi ap dung required cho 9 truong.

Khi `tinhtrangtaisan = 0`, 9 truong duoc phep de trong. Neu co gia tri thi van validate kieu, dinh dang va do dai hien tai.

## Rule giu nguyen

- Required cua `sokhung`, `somay`, `loaitaisan`, `tinhtrangtaisan`, `xuatxu`.
- `xuatxu = 1` yeu cau `sogiaychungnhanatkt`.
- `xuatxu = 0` yeu cau `soseripktcl`.
- `tinhtrangtaisan = 1` yeu cau `chatluongtaisan` va `sobienkiemsoat`.
- Validate danh muc Tinh/Xa, mapping DB va message hien tai.
- File template cu va dong khong phai hang hoa dac trung loai 1 giu luong cu.

## Out Of Scope

- Khong sua frontend.
- Khong sua API tich hop `api-cloud-service`.
- Khong sua DB, DTO, mapping luu du lieu hoac XML.
- Khong thay doi cac gioi han do dai hien tai.

