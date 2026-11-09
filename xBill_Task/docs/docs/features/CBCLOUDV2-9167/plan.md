# CBCLOUDV2-9167 Plan Docs - API tich hop hang hoa dac trung

## Summary

Task CBCLOUDV2-9167 cap nhat tai lieu API tich hop de ho tro bo field hang hoa dac trung moi cho nhom xe.

- Khong thay doi DB cho `vs_hd_chitiet_morong`; cac cot hang hoa dac trung moi trong bang nay da ton tai.
- Khong thay doi DB cho `vs_hd_tonghop_morong`; 2 cot `ma_tinh`, `ma_xa` da duoc them san, task nay chi sua code de nhan/map/render XML.
- `version` khong truyen/null/rong hoac khac `1`: giu nguyen luong hien tai, khong bat validate/map/render XML theo nghi dinh moi.
- Khi `version = 1` va dong `dschitiet[]` co `loaihoadondactrung = 1`: he thong bat validate, map du lieu hang hoa dac trung xe, va sinh XML tuong ung khi ky.
- Cac field hang hoa dac trung duoc truyen trong `dschitiet[]`, vi du lieu thuoc tung dong hang hoa/dich vu.

## API bi anh huong

| API | Input chinh | Ghi chu |
|---|---|---|
| `GuiHoaDonGoc` | `GuiHDGoc` | Luu hoa don goc |
| `GuiVaKyHoadonGocHSM` | `GuiHDGoc` | Luu hoa don goc roi ky HSM |
| `GuiHoaDonThayThe` | `GuiHoaDonTT` | Luu hoa don thay the |
| `GuiVaKyHoaDonThayTheHSM` | `GuiHoaDonTT` | Luu hoa don thay the roi ky HSM |
| `GuiHoaDonDieuChinh` | `GuiHoaDonDC` | Luu hoa don dieu chinh |
| `GuiVaKyHoaDonDieuChinhHSM` | `GuiHoaDonDC` | Luu hoa don dieu chinh roi ky HSM |
| `GuiHoaDonVaKyMTT` | `GuiHDGoc` | Luu, cap so, ky MTT, gui TCT |

## DB changes

Khong can chay migration trong task nay.

- Cac cot hang hoa dac trung trong `vs_hd_chitiet_morong` da co san.
- Hai cot dia ban hanh chinh trong `vs_hd_tonghop_morong` da co san: `ma_tinh`, `ma_xa`.
- Task nay chi can cap nhat code: DTO, entity, mapping luu, mapping XML, validate va test.

Mapping DB da co:

| Field request cap hoa don | Bang/cot DB | Ghi chu |
|---|---|---|
| `ma_tinh` | `vs_hd_tonghop_morong.ma_tinh` | Chi map khi `version = 1` va hoa don co dong `loaihoadondactrung = 1` |
| `ma_xa` | `vs_hd_tonghop_morong.ma_xa` | Chi map khi `version = 1` va hoa don co dong `loaihoadondactrung = 1` |



Nguon input cho `HD_HoaDon_MoRong`:

- `HD_HoaDon_MoRong` la du lieu mo rong cap tong hop/hoa don, nen lay tu object request chinh, khong lay tu `dschitiet[]`.
- Voi `GuiHoaDonGoc`: lay tu `GuiHDGoc.ma_tinh`, `GuiHDGoc.ma_xa`.
- Voi `GuiHoaDonThayThe`: lay tu `GuiHoaDonTT.ma_tinh`, `GuiHoaDonTT.ma_xa`.
- Voi `GuiHoaDonDieuChinh`: lay tu `GuiHoaDonDC.ma_tinh`, `GuiHoaDonDC.ma_xa`.
- `dschitiet[]` chi dung cho `HD_ChiTiet_MoRong`, bao gom `loaihoadondactrung` va 16 field hang hoa dac trung.
- Khi implement can them `version`, `ma_tinh`, `ma_xa` vao 3 DTO input chinh, khong them vao DTO chi tiet.
Dieu kien ap dung ma_tinh, ma_xa:

- Chi xu ly khi `version = 1` va hoa don co it nhat mot dong `dschitiet[].loaihoadondactrung = 1`.
- Neu `version` khong truyen/null/rong hoac khac `1` thi bo qua toan bo rule moi, khong validate/map/render XML cac field theo nghi dinh moi.
- Hoa don khong co dong hang hoa dac trung xe thi khong bat buoc truyen `ma_tinh`, `ma_xa`.
- Neu co truyen `ma_tinh`, `ma_xa` cho hoa don thuong, service co the bo qua de tranh anh huong luong cu.
- Khi co `version = 1` va `loaihoadondactrung = 1`, `ma_tinh`, `ma_xa` la thong tin cap hoa don, khong dat trong `dschitiet[]`.
Entity/service can cap nhat neu code chua co property tuong ung:

- Entity tong hop mo rong cua hoa don them `ma_tinh`.
- Entity tong hop mo rong cua hoa don them `ma_xa`.
- API luu hoa don chi map `ma_tinh`, `ma_xa` tu input cap hoa don vao object tong hop mo rong khi `version = 1` va hoa don co it nhat mot dong `dschitiet[].loaihoadondactrung = 1`. Hoa don thuong khong co hang hoa dac trung thi khong bat buoc va khong can map 2 field nay.
## Chi tiet can lam theo tung API

### 1. `GuiHoaDonGoc`

Endpoint:

- `POST /api/services/hddtws/GuiHoadon/GuiHoaDonGoc`

Input can cap nhat:

- Input chinh: `GuiHDGoc`.
- Field cap hoa don: bo sung `version`, `ma_tinh`, `ma_xa`; `version` dung de kich hoat rule moi, `ma_tinh`, `ma_xa` lay tu input chinh de map vao `HD_HoaDon_MoRong`, khong nam trong `dschitiet[]`.
- Field chi tiet: bo sung cac field request moi trong `GuiHDGoc.dschitiet[]` theo bang schema ben duoi.
- `sokhung`, `somay`, `loaihoadondactrung` da la field theo dong chi tiet, tiep tuc dung trong `dschitiet[]`.

Logic can lam:

1. Neu `version` khong truyen/null/rong/khac `1` hoac dong `dschitiet[]` khong co `loaihoadondactrung = 1`: giu nguyen validate/map hien tai, khong bat buoc bo field moi.
2. Neu `version = 1` va dong `dschitiet[]` co `loaihoadondactrung = 1`: validate dong do theo bang field bat buoc.
3. Map field cu nhu hien tai: `loaihoadondactrung`, `sokhung`, `somay`, `bienkiemsoat`, nhom nguoi gui hang.
4. Map field request moi vao `HD_ChiTiet_MoRong` theo bang mapping request -> DB.
5. Neu `version = 1` va hoa don co it nhat mot dong `loaihoadondactrung = 1` thi map `ma_tinh`, `ma_xa` cap hoa don vao `vs_hd_tonghop_morong`; cac truong hop con lai bo qua 2 field nay de giu luong cu.
6. Luu hoa don nhu luong hien tai.
7. Response giu nguyen `KquaGuiHD`, khong them response field moi.

Can test rieng:

- Khong truyen/null/rong `version` hoac khong co `loaihoadondactrung = 1`: tao hoa don thanh cong nhu cu.
- Co `version = 1` va `loaihoadondactrung = 1` day du field: luu thanh cong, DB co du lieu moi trong `vs_hd_chitiet_morong`.
- Co `version = 1` va `loaihoadondactrung = 1` thieu `sokhung`/`somay`/`loaitaisan`/`tinhtrangtaisan`/`xuatxu`: tra loi validate.
- `xuatxu = 1` thieu `sogiaychungnhanatkt`: tra loi validate.
- `xuatxu = 0` thieu `soseripktcl`: tra loi validate.
- `tinhtrangtaisan = 1` thieu `chatluongtaisan` hoac `sobienkiemsoat`: tra loi validate.

### 2. `GuiVaKyHoadonGocHSM`

Endpoint:

- `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoadonGocHSM`

Input can cap nhat:

- Dung lai input `GuiHDGoc`, nen huong toan bo thay doi cua `GuiHoaDonGoc`.
- Khong tao DTO rieng cho HSM.

Logic can lam:

1. Giu luong wrapper hien tai: goi `GuiHoaDonGoc(inp)` de luu hoa don truoc.
2. Khong duplicate validate/map field moi trong wrapper HSM.
3. Neu `GuiHoaDonGoc(inp)` tra loi validate hang hoa dac trung: dung luong, khong goi `KyHoaDon`.
4. Neu luu thanh cong: goi `KyHoaDon` nhu hien tai.
5. XML khi ky sinh tag moi dua tren du lieu da luu trong `HD_ChiTiet_MoRong`.
6. Response giu nguyen `KquaGuiVaKyHD`.

Can test rieng:

- Luong cu: luu va ky HSM thanh cong, XML khong bi thay doi ngoai y muon.
- Co `version = 1` va `loaihoadondactrung = 1` day du field: luu thanh cong, ky thanh cong, XML co tag hang hoa dac trung moi.
- Co `version = 1` va `loaihoadondactrung = 1` loi validate: khong phat sinh ky HSM.

### 3. `GuiHoaDonThayThe`

Endpoint:

- `POST /api/services/hddtws/GuiHoadon/GuiHoaDonThayThe`

Input can cap nhat:

- Input chinh: `GuiHoaDonTT`.
- Field cap hoa don: bo sung `version`, `ma_tinh`, `ma_xa`; `version` dung de kich hoat rule moi, `ma_tinh`, `ma_xa` lay tu input chinh de map vao `HD_HoaDon_MoRong`, khong nam trong `dschitiet[]`.
- Field chi tiet: bo sung cac field request moi trong `GuiHoaDonTT.dschitiet[]`.
- Giu cac field thay the hien tai nhu `hoadon_goc`, `lydo_thaythe`.

Logic can lam:

1. Validate nghiep vu thay the hien tai nhu cu.
2. Neu `version` khong truyen/null/rong/khac `1` hoac khong co dong nao `loaihoadondactrung = 1`: khong bat buoc field moi, khong lam thay doi luong cu.
3. Neu `version = 1` va dong `dschitiet[]` co `loaihoadondactrung = 1`: validate dong do theo bang field bat buoc.
4. Khi tao chi tiet hoa don thay the, map field moi vao `HD_ChiTiet_MoRong`.
5. Neu `version = 1` va hoa don co it nhat mot dong `loaihoadondactrung = 1` thi map `ma_tinh`, `ma_xa` cap hoa don vao `vs_hd_tonghop_morong`; cac truong hop con lai bo qua 2 field nay de giu luong cu.
6. Khong tu ke thua rule tu hoa don goc; hoa don thay the validate theo request thay the hien tai.
7. Response giu nguyen `KquaTT`.

Can test rieng:

- Luong cu: thay the hoa don thanh cong nhu hien tai.
- Co `version = 1` va `loaihoadondactrung = 1` day du field: luu hoa don thay the thanh cong, DB co du lieu moi.
- Co `version = 1` va `loaihoadondactrung = 1` loi field bat buoc/dieu kien: tra loi validate, khong tao hoa don thay the.
- Hoa don goc cu nhung request thay the co `version = 1` va `loaihoadondactrung = 1`: hoa don thay the validate/map theo nghi dinh moi.

### 4. `GuiVaKyHoaDonThayTheHSM`

Endpoint:

- `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonThayTheHSM`

Input can cap nhat:

- Dung lai input `GuiHoaDonTT`, nen huong toan bo thay doi cua `GuiHoaDonThayThe`.

Logic can lam:

1. Giu luong wrapper hien tai: goi `GuiHoaDonThayThe(input)` de luu hoa don thay the.
2. Khong duplicate validate/map field moi trong wrapper HSM.
3. Neu save loi validate hang hoa dac trung: dung luong, khong goi `KyHoaDon`.
4. Neu save thanh cong: goi `KyHoaDon` nhu hien tai.
5. XML khi ky sinh tag moi dua tren du lieu hoa don thay the da luu.
6. Response giu nguyen `KquaGuiVaKyHD`.

Can test rieng:

- Luong cu: thay the va ky HSM thanh cong nhu hien tai.
- Co `version = 1` va `loaihoadondactrung = 1` day du field: thay the thanh cong, ky HSM thanh cong, XML co tag moi.
- Co `version = 1` va `loaihoadondactrung = 1` loi validate: khong goi ky HSM.

### 5. `GuiHoaDonDieuChinh`

Endpoint:

- `POST /api/services/hddtws/GuiHoadon/GuiHoaDonDieuChinh`

Input can cap nhat:

- Input chinh: `GuiHoaDonDC`.
- Field cap hoa don: bo sung `version`, `ma_tinh`, `ma_xa`; `version` dung de kich hoat rule moi, `ma_tinh`, `ma_xa` lay tu input chinh de map vao `HD_HoaDon_MoRong`, khong nam trong `dschitiet[]`.
- Field chi tiet: bo sung cac field request moi trong `GuiHoaDonDC.dschitiet[]`.
- Giu cac field dieu chinh hien tai nhu `hoadon_goc`, `lydo_dieuchinh`, `noidung_truocdieuchinh`, `noidung_saudieuchinh`.

Logic can lam:

1. Validate nghiep vu dieu chinh hien tai nhu cu.
2. Neu `version` khong truyen/null/rong/khac `1` hoac khong co dong nao `loaihoadondactrung = 1`: khong bat buoc field moi, khong lam thay doi luong cu.
3. Neu `version = 1` va dong `dschitiet[]` co `loaihoadondactrung = 1`: validate dong do theo bang field bat buoc.
4. Khi tao chi tiet hoa don dieu chinh, map field moi vao `HD_ChiTiet_MoRong`.
5. Neu `version = 1` va hoa don co it nhat mot dong `loaihoadondactrung = 1` thi map `ma_tinh`, `ma_xa` cap hoa don vao `vs_hd_tonghop_morong`; cac truong hop con lai bo qua 2 field nay de giu luong cu.
6. Khong tu ke thua rule tu hoa don goc; hoa don dieu chinh validate theo request dieu chinh hien tai.
7. Response giu nguyen `KquaDC`.

Can test rieng:

- Luong cu: dieu chinh hoa don thanh cong nhu hien tai.
- Co `version = 1` va `loaihoadondactrung = 1` day du field: luu hoa don dieu chinh thanh cong, DB co du lieu moi.
- Co `version = 1` va `loaihoadondactrung = 1` loi field bat buoc/dieu kien: tra loi validate, khong tao hoa don dieu chinh.
- Hoa don goc cu nhung request dieu chinh co `version = 1` va `loaihoadondactrung = 1`: hoa don dieu chinh validate/map theo nghi dinh moi.

### 6. `GuiVaKyHoaDonDieuChinhHSM`

Endpoint:

- `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonDieuChinhHSM`

Input can cap nhat:

- Dung lai input `GuiHoaDonDC`, nen huong toan bo thay doi cua `GuiHoaDonDieuChinh`.

Logic can lam:

1. Giu luong wrapper hien tai: goi `GuiHoaDonDieuChinh(input)` de luu hoa don dieu chinh.
2. Khong duplicate validate/map field moi trong wrapper HSM.
3. Neu save loi validate hang hoa dac trung: dung luong, khong goi `KyHoaDon`.
4. Neu save thanh cong: goi `KyHoaDon` nhu hien tai.
5. XML khi ky sinh tag moi dua tren du lieu hoa don dieu chinh da luu.
6. Response giu nguyen `KquaGuiVaKyHD`.

Can test rieng:

- Luong cu: dieu chinh va ky HSM thanh cong nhu hien tai.
- Co `version = 1` va `loaihoadondactrung = 1` day du field: dieu chinh thanh cong, ky HSM thanh cong, XML co tag moi.
- Co `version = 1` va `loaihoadondactrung = 1` loi validate: khong goi ky HSM.

### 7. `GuiHoaDonVaKyMTT`

Endpoint:

- `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT`

Input can cap nhat:

- Dung lai input `GuiHDGoc`, nen huong toan bo thay doi cua `GuiHoaDonGoc`.

Logic can lam:

1. Giu luong hien tai: goi `GuiHoaDonGoc(inp)` de luu hoa don.
2. Khong duplicate validate/map field moi trong API MTT.
3. Neu `GuiHoaDonGoc(inp)` loi validate hang hoa dac trung: dung luong truoc buoc cap so, ky, gui TCT.
4. Neu luu thanh cong: cap so hoa don nhu hien tai.
5. Ky MTT nhu hien tai.
6. XML MTT sinh tag moi dua tren du lieu da luu trong `HD_ChiTiet_MoRong`.
7. Gui TCT bang XML da ky nhu hien tai.
8. Neu `GuiHoaDonVaKyMTT_V2` dang duoc publish/su dung production, ap dung cung rule de tranh lech behavior.

Can test rieng:

- Luong cu: luu, cap so, ky MTT, gui TCT nhu hien tai.
- Co `version = 1` va `loaihoadondactrung = 1` day du field: luu thanh cong, cap so, ky MTT, XML co tag moi truoc khi gui TCT.
- Co `version = 1` va `loaihoadondactrung = 1` loi validate: khong cap so, khong ky, khong gui TCT.



## Chi tiet DTO/entity can sua cho 16 field hang hoa dac trung

### DTO chi tiet can bo sung

16 field moi nam trong `dschitiet[]`, nen can bo sung vao cac DTO chi tiet cua 3 input luu hoa don:

| API input | DTO chi tiet can them field | Ghi chu |
|---|---|---|
| `GuiHDGoc.dschitiet[]` | DTO chi tiet hoa don goc | Dung cho `GuiHoaDonGoc`, `GuiVaKyHoadonGocHSM`, `GuiHoaDonVaKyMTT` |
| `GuiHoaDonTT.dschitiet[]` | DTO chi tiet hoa don thay the | Dung cho `GuiHoaDonThayThe`, `GuiVaKyHoaDonThayTheHSM` |
| `GuiHoaDonDC.dschitiet[]` | DTO chi tiet hoa don dieu chinh | Dung cho `GuiHoaDonDieuChinh`, `GuiVaKyHoaDonDieuChinhHSM` |

Danh sach 16 field request can them vao DTO chi tiet:

| Request field | Kieu/do dai | Ghi chu validate |
|---|---|---|
| `loaitaisan` | int 1 | Bat buoc khi `version = 1` va `loaihoadondactrung = 1`; `1`: O to, `2`: Mo to xe may |
| `tinhtrangtaisan` | int 1 | Bat buoc; `0`: Chua qua su dung, `1`: Da qua su dung |
| `xuatxu` | int 1 | Bat buoc; `0`: Trong nuoc, `1`: Nhap khau |
| `sogiaychungnhanatkt` | string max 200 | Bat buoc khi `xuatxu = 1` |
| `soseripktcl` | string max 200 | Bat buoc khi `xuatxu = 0` |
| `ma_nuocsx` | string max 2 | Bat buoc |
| `ten_loaitaisan` | string max 200 | Bat buoc |
| `namsanxuat` | int 4 | Bat buoc |
| `ten_thuongmai` | string max 300 | Bat buoc |
| `ten_nhanhieu` | string max 200 | Bat buoc |
| `kieuloaixe` | string max 50 | Bat buoc |
| `thetich_congsuat` | string max 10 | Bat buoc |
| `trongtai` | decimal 9,2 | Bat buoc |
| `sochongoi` | int 4 | Bat buoc |
| `chatluongtaisan` | number max 4,2 | Bat buoc khi `tinhtrangtaisan = 1` |
| `sobienkiemsoat` | string max 20 | Bat buoc khi `tinhtrangtaisan = 1` |

### Entity chi tiet can bo sung/kiem tra

DB `vs_hd_chitiet_morong` da co cot, nhung entity/model map bang nay phai co property tuong ung de save va render XML:

| Request field | Entity/DB field |
|---|---|
| `loaitaisan` | `ltsan` |
| `tinhtrangtaisan` | `tttsan` |
| `xuatxu` | `xxu` |
| `sogiaychungnhanatkt` | `sgcnatkthuat` |
| `soseripktcl` | `sspktclxxuong` |
| `ma_nuocsx` | `mnsxuat` |
| `ten_loaitaisan` | `tltsdky` |
| `namsanxuat` | `nsxuat` |
| `ten_thuongmai` | `ttmai` |
| `ten_nhanhieu` | `tnhieu` |
| `kieuloaixe` | `klxe` |
| `thetich_congsuat` | `ttlvhcsuat` |
| `trongtai` | `ttai` |
| `sochongoi` | `scngoi` |
| `chatluongtaisan` | `cltsan` |
| `sobienkiemsoat` | `sbksoat` |

Luu y:

- Khong them 16 field nay vao DTO cap hoa don; chi them vao DTO item trong `dschitiet[]`.
- HSM/MTT khong can DTO rieng, vi dung lai input cua API luu hoa don.
- Neu entity `HD_ChiTiet_MoRong` da co property thi chi can kiem tra mapping va XML; khong tao them migration DB.


### Validate bat buoc cho hang hoa dac trung xe

Chi validate cac field duoi day khi `version = 1` va dong chi tiet co `loaihoadondactrung = 1`. Neu dong khong phai hang hoa dac trung xe thi giu luong validate hien tai.

Field bat buoc luon:

| Request field | Entity/DB field | Ly do |
|---|---|---|
| `sokhung` | `So_Khung` | Bat buoc theo phu luc |
| `somay` | `So_May` | Bat buoc theo phu luc |
| `loaitaisan` | `ltsan` | Bat buoc theo phu luc |
| `tinhtrangtaisan` | `tttsan` | Bat buoc theo phu luc |
| `xuatxu` | `xxu` | Bat buoc theo phu luc |
| `ma_nuocsx` | `mnsxuat` | Bat buoc theo phu luc |
| `ten_loaitaisan` | `tltsdky` | Bat buoc theo phu luc |
| `namsanxuat` | `nsxuat` | Bat buoc theo phu luc |
| `ten_thuongmai` | `ttmai` | Bat buoc theo phu luc |
| `ten_nhanhieu` | `tnhieu` | Bat buoc theo phu luc |
| `kieuloaixe` | `klxe` | Bat buoc theo phu luc |
| `thetich_congsuat` | `ttlvhcsuat` | Bat buoc theo phu luc |
| `trongtai` | `ttai` | Bat buoc theo phu luc/rule nghiep vu |
| `sochongoi` | `scngoi` | Bat buoc theo phu luc |

Field bat buoc theo dieu kien:

| Dieu kien | Request field bat buoc | Entity/DB field |
|---|---|---|
| `xuatxu = 1` | `sogiaychungnhanatkt` | `sgcnatkthuat` |
| `xuatxu = 0` | `soseripktcl` | `sspktclxxuong` |
| `tinhtrangtaisan = 1` | `chatluongtaisan` | `cltsan` |
| `tinhtrangtaisan = 1` | `sobienkiemsoat` | `sbksoat` |

Luu y implement:

- Validate bat buoc phai chay truoc khi tao/save `HD_ChiTiet_MoRong` cho dong co `version = 1` va `loaihoadondactrung = 1`.
- Neu thieu `trongtai` thi tra loi validate theo rule nghiep vu, khong phu thuoc DB co bat buoc hay khong.
- Validate kieu/do dai theo schema truoc khi map vao entity.

## Chi tiet phan can sua cho `ma_tinh`, `ma_xa`

Hai field request moi:

```json
"ma_tinh": "01",
"ma_xa": "00004"
```

### 1. DTO input can sua

Them field cap hoa don, khong them vao `dschitiet[]`:

| DTO | Field can them | Ghi chu |
|---|---|---|
| `GuiHDGoc` | `public string ma_tinh { get; set; }`, `public string ma_xa { get; set; }` | Dung cho `GuiHoaDonGoc`, `GuiVaKyHoadonGocHSM`, `GuiHoaDonVaKyMTT` |
| `GuiHoaDonTT` | `public string ma_tinh { get; set; }`, `public string ma_xa { get; set; }` | Dung cho thay the va thay the HSM |
| `GuiHoaDonDC` | `public string ma_tinh { get; set; }`, `public string ma_xa { get; set; }` | Dung cho dieu chinh va dieu chinh HSM |

Khong sua cac DTO chi tiet cho 2 field nay:

- Khong them vao `ChiTietHDG`.
- Khong them vao `ChiTietTT`.
- Khong them vao `ChiTietDC`.

### 2. DB/schema

Khong can sua DB trong task nay.

- `vs_hd_tonghop_morong.ma_tinh` da co san.
- `vs_hd_tonghop_morong.ma_xa` da co san.
- Khong them 2 cot nay vao `vs_hd_chitiet_morong` vi day khong phai du lieu theo dong hang.

### 3. Entity/domain can sua

Them property vao entity map bang `vs_hd_tonghop_morong`:

```csharp
public string ma_tinh { get; set; }
public string ma_xa { get; set; }
```

Entity can sua:

- `HD_HoaDon_MoRong`

Khong them property nay vao `HD_ChiTiet_MoRong`.

### 4. Mapping trong API luu hoa don

Dieu kien map:

- Chi map khi hoa don co it nhat mot dong `dschitiet[].loaihoadondactrung = 1`.
- Neu hoa don thuong khong co dong dac trung xe thi bo qua `ma_tinh`, `ma_xa` de khong anh huong luong cu.

Mapping can them:

```csharp
if (hasHangHoaDacTrungXe)
{
    hd.HD_HoaDon_MoRong ??= new HD_HoaDon_MoRong();
    hd.HD_HoaDon_MoRong.ma_tinh = input.ma_tinh;
    hd.HD_HoaDon_MoRong.ma_xa = input.ma_xa;
}
```

Ap dung theo tung API luu:

| API luu | Input | Noi can map |
|---|---|---|
| `GuiHoaDonGoc` | `GuiHDGoc` | Khi tao/cap nhat `hdtt.HD_HoaDon_MoRong` |
| `GuiHoaDonThayThe` | `GuiHoaDonTT` | Khi tao/cap nhat `hdtt.HD_HoaDon_MoRong` cua hoa don thay the |
| `GuiHoaDonDieuChinh` | `GuiHoaDonDC` | Khi tao/cap nhat `hddc.HD_HoaDon_MoRong` cua hoa don dieu chinh |

Cac API wrapper khong map rieng:

- `GuiVaKyHoadonGocHSM` dung lai `GuiHoaDonGoc`.
- `GuiVaKyHoaDonThayTheHSM` dung lai `GuiHoaDonThayThe`.
- `GuiVaKyHoaDonDieuChinhHSM` dung lai `GuiHoaDonDieuChinh`.
- `GuiHoaDonVaKyMTT` dung lai `GuiHoaDonGoc`.

### 5. Validate `ma_tinh`, `ma_xa`

Chi validate khi `version = 1` va hoa don co it nhat mot dong `dschitiet[].loaihoadondactrung = 1`.

Rule de xuat:

| Field | Bat buoc | Kieu/do dai | Ghi chu |
|---|---|---|---|
| `ma_tinh` | Co khi `version = 1` va co `loaihoadondactrung = 1` | string max 3 | XML tag `MTinh`, theo request mau: `"01"` |
| `ma_xa` | Co khi `version = 1` va co `loaihoadondactrung = 1` | string max 8 | XML tag `MXa`, theo request mau: `"00004"` |


### 6. XML/PBan lien quan

- `ma_tinh`, `ma_xa` khong nam trong 16 field moi cua `TTHHDTrung`.
- `ma_tinh`, `ma_xa` render trong the `NMua`, path XML: `HDon/DLHDon/NDHDon/NMua`.
- Mapping XML: `HD_HoaDon_MoRong.ma_tinh` -> `NMua/MTinh`, `HD_HoaDon_MoRong.ma_xa` -> `NMua/MXa`.
- Chi render `MTinh`, `MXa` khi `version = 1` va hoa don co hang hoa dac trung xe `dschitiet[].loaihoadondactrung = 1`.
- 16 field moi cua chi tiet van la dieu kien render nhom XML hang hoa dac trung.
- Khi render nhom XML moi theo nghiep vu nay thi cap nhat `PBan = 2.1.1`.

### 7. Test case rieng cho `ma_tinh`, `ma_xa`

- Khong truyen/null/rong `version`, co hoac khong co `loaihoadondactrung = 1`, khong truyen `ma_tinh`, `ma_xa`: luu thanh cong nhu cu.
- Hoa don thuong co truyen `ma_tinh`, `ma_xa`: service bo qua hoac khong anh huong luong cu.
- Hoa don co `version = 1` va `loaihoadondactrung = 1`, truyen du `ma_tinh`, `ma_xa`: luu thanh cong vao `vs_hd_tonghop_morong`.
- Hoa don co `version = 1` va `loaihoadondactrung = 1`, thieu `ma_tinh` hoac `ma_xa`: tra loi validate.
- HSM/MTT: verify wrapper khong map rieng nhung du lieu van duoc luu do dung lai API luu.
- Ky sau: verify service ky load duoc `HD_HoaDon_MoRong.ma_tinh`, `HD_HoaDon_MoRong.ma_xa` neu XML can dung.

## Request schema

### Field cap hoa don

| Field | Kieu | Bat buoc | Mo ta |
|---|---|---:|---|
| `version` | string/int | Khong | `1`: chay rule nghi dinh moi; khong truyen/null/rong/khac `1`: giu luong cu |
| `ma_tinh` | string max 3 | Co khi `version = 1` va co `loaihoadondactrung = 1` | Render XML `NMua/MTinh`; khong bat buoc voi luong cu |
| `ma_xa` | string max 8 | Co khi `version = 1` va co `loaihoadondactrung = 1` | Render XML `NMua/MXa`; khong bat buoc voi luong cu |

### Field trong `dschitiet[]`

Ap dung cho dong chi tiet khi hoa don co `version = 1` va dong chi tiet co `loaihoadondactrung = 1`.

| Field request | Cot DB | The XML | Kieu/do dai | Bat buoc khi `version = 1` va `loaihoadondactrung = 1` |
|---|---|---|---|---|
| `loaihoadondactrung` | `Loai_HangHoa_DacTrung` | `LHHDTrung` | int 1 | Co, gia tri `1` de kich hoat validate bo field xe |
| `sokhung` | `So_Khung` | `SKhung` | string max 50 | Co |
| `somay` | `So_May` | `SMay` | string max 50 | Co |
| `loaitaisan` | `ltsan` | `LTSan` | int 1 | Co |
| `tinhtrangtaisan` | `tttsan` | `TTTSan` | int 1 | Co |
| `xuatxu` | `xxu` | `XXu` | int 1 | Co |
| `sogiaychungnhanatkt` | `sgcnatkthuat` | `SGCNATKThuat` | string max 200 | Co neu `xuatxu = 1` |
| `soseripktcl` | `sspktclxxuong` | `SSPKTCLXXuong` | string max 200 | Co neu `xuatxu = 0` |
| `ma_nuocsx` | `mnsxuat` | `MNSXuat` | string max 2 | Co |
| `ten_loaitaisan` | `tltsdky` | `TLTSDKy` | string max 200 | Co |
| `namsanxuat` | `nsxuat` | `NSXuat` | int 4 | Co |
| `ten_thuongmai` | `ttmai` | `TTMai` | string max 300 | Co |
| `ten_nhanhieu` | `tnhieu` | `TNHieu` | string max 200 | Co |
| `kieuloaixe` | `klxe` | `KLXe` | string max 50 | Co |
| `thetich_congsuat` | `ttlvhcsuat` | `TTLVHCSuat` | string max 10 | Co |
| `trongtai` | `ttai` | `TTai` | decimal 9,2 | Co |
| `sochongoi` | `scngoi` | `SCNgoi` | int 4 | Co |
| `chatluongtaisan` | `cltsan` | `CLTSan` | number max 4,2 | Co neu `tinhtrangtaisan = 1` |
| `sobienkiemsoat` | `sbksoat` | `SBKSoat` | string max 20 | Co neu `tinhtrangtaisan = 1` |

## Gia tri hop le va dieu kien bat buoc

| Field request | Gia tri hop le |
|---|---|
| `loaihoadondactrung` | `1`: Hang hoa dac trung xe o to/xe mo to, kich hoat validate bo field xe |
| `loaitaisan` | `1`: O to, `2`: Mo to xe may |
| `tinhtrangtaisan` | `0`: Chua qua su dung, `1`: Da qua su dung |
| `xuatxu` | `0`: Lap rap/san xuat trong nuoc, `1`: Nhap khau |

Dieu kien bat buoc:

- `sogiaychungnhanatkt` bat buoc khi `xuatxu = 1`.
- `soseripktcl` bat buoc khi `xuatxu = 0`.
- `chatluongtaisan` va `sobienkiemsoat` bat buoc khi `tinhtrangtaisan = 1`.

## Vi du request

### Hoa don goc co `version = 1` va `loaihoadondactrung = 1`

```json
{
  "doanhnghiep_mst": "0100000000",
  "loaihoadon_ma": "01GTKT",
  "mauso": "1",
  "kyhieu": "C26TAA",
  "ma_hoadon": "HDG-V2-001",
  "ngaylap": "13/08/2026",
  "version": "1",
  "ma_tinh": "01",
  "ma_xa": "00004",
  "dschitiet": [
    {
      "stt": 1,
      "loaihoadondactrung": 1,
      "ten": "Xe o to",
      "donvitinh": "Chiec",
      "soluong": 1,
      "dongia": 500000000,
      "tongtien_chuathue": 500000000,
      "mathue": "10",
      "tongtien_thue": 50000000,
      "tongtien_cothue": 550000000,
      "sokhung": "ABC123456789",
      "somay": "ENG123456",
      "loaitaisan": 1,
      "tinhtrangtaisan": 0,
      "xuatxu": 1,
      "sogiaychungnhanatkt": "GCN-001",
      "ma_nuocsx": "JP",
      "ten_loaitaisan": "O to con",
      "namsanxuat": 2026,
      "kieuloaixe": "Sedan",
      "trongtai": 1.50,
      "sochongoi": 5
    }
  ]
}
```

### Hoa don thay the co `version = 1` va `loaihoadondactrung = 1`

```json
{
  "doanhnghiep_mst": "0100000000",
  "loaihoadon_ma": "01GTKT",
  "mauso": "1",
  "kyhieu": "C26TAA",
  "ma_hoadon": "HDT-V2-001",
  "hoadon_goc": "HDG-OLD-001",
  "ngaylap": "13/08/2026",
  "version": "1",
  "ma_tinh": "01",
  "ma_xa": "00004",
  "lydo_thaythe": "Thay the hoa don co sai sot",
  "dschitiet": [
    {
      "stt": 1,
      "loaihoadondactrung": 1,
      "ten": "Xe mo to",
      "donvitinh": "Chiec",
      "soluong": 1,
      "dongia": 50000000,
      "tongtien_chuathue": 50000000,
      "mathue": "10",
      "tongtien_thue": 5000000,
      "tongtien_cothue": 55000000,
      "sokhung": "FRAME-001",
      "somay": "ENGINE-001",
      "loaitaisan": 2,
      "tinhtrangtaisan": 1,
      "xuatxu": 0,
      "soseripktcl": "PKTCL-001",
      "ma_nuocsx": "VN",
      "ten_loaitaisan": "Xe mo to hai banh",
      "namsanxuat": 2025,
      "kieuloaixe": "Mo to",
      "trongtai": 0.15,
      "sochongoi": 2,
      "chatluongtaisan": 95,
      "sobienkiemsoat": "30A12345"
    }
  ]
}
```

### Hoa don dieu chinh co `version = 1` va `loaihoadondactrung = 1`

```json
{
  "doanhnghiep_mst": "0100000000",
  "loaihoadon_ma": "01GTKT",
  "mauso": "1",
  "kyhieu": "C26TAA",
  "ma_hoadon": "HDC-V2-001",
  "hoadon_goc": "HDG-OLD-001",
  "ngaylap": "13/08/2026",
  "version": "1",
  "ma_tinh": "01",
  "ma_xa": "00004",
  "lydo_dieuchinh": "Dieu chinh thong tin hang hoa",
  "noidung_truocdieuchinh": "Thong tin hang hoa cu",
  "noidung_saudieuchinh": "Thong tin hang hoa moi",
  "dschitiet": [
    {
      "stt": 1,
      "loaihoadondactrung": 1,
      "ten": "Xe o to",
      "donvitinh": "Chiec",
      "soluong": 1,
      "dongia": 600000000,
      "tongtien_chuathue": 600000000,
      "mathue": "10",
      "tongtien_thue": 60000000,
      "tongtien_cothue": 660000000,
      "sokhung": "VIN-ADJ-001",
      "somay": "ENG-ADJ-001",
      "loaitaisan": 1,
      "tinhtrangtaisan": 0,
      "xuatxu": 1,
      "sogiaychungnhanatkt": "GCN-ADJ-001",
      "ma_nuocsx": "KR",
      "ten_loaitaisan": "O to tai",
      "namsanxuat": 2026,
      "kieuloaixe": "Truck",
      "trongtai": 2.50,
      "sochongoi": 3
    }
  ]
}
```


## Mapping tay request -> DB/entity -> XML

Do ten field request, cot DB/entity va the XML khong trung nhau, implement phai map tay. Khong dua vao AutoMapper mac dinh cho nhom field nay.

### Mapping chi tiet hang hoa dac trung

Nguon request nam trong `dschitiet[]`. Dich den DB/entity nam trong `HD_ChiTiet_MoRong`. XML sinh tu entity sau khi luu.

| Request field | Entity/DB field | XML tag | Ghi chu |
|---|---|---|---|
| `loaihoadondactrung` | `Loai_HangHoa_DacTrung` | `LHHDTrung` | Field kich hoat validate khi bang `1` |
| `sokhung` | `So_Khung` | `SKhung` | Field cu da co |
| `somay` | `So_May` | `SMay` | Field cu da co |
| `loaitaisan` | `ltsan` | `LTSan` | 1: O to, 2: Mo to xe may |
| `tinhtrangtaisan` | `tttsan` | `TTTSan` | 0: Chua qua su dung, 1: Da qua su dung |
| `xuatxu` | `xxu` | `XXu` | 0: Trong nuoc, 1: Nhap khau |
| `sogiaychungnhanatkt` | `sgcnatkthuat` | `SGCNATKThuat` | Bat buoc khi `xuatxu = 1` |
| `soseripktcl` | `sspktclxxuong` | `SSPKTCLXXuong` | Bat buoc khi `xuatxu = 0` |
| `ma_nuocsx` | `mnsxuat` | `MNSXuat` | Ma nuoc san xuat |
| `ten_loaitaisan` | `tltsdky` | `TLTSDKy` | Ten loai tai san dang ky |
| `namsanxuat` | `nsxuat` | `NSXuat` | Nam san xuat |
| `ten_thuongmai` | `ttmai` | `TTMai` | Bat buoc khi `version = 1` va `loaihoadondactrung = 1` |
| `ten_nhanhieu` | `tnhieu` | `TNHieu` | Bat buoc khi `version = 1` va `loaihoadondactrung = 1` |
| `kieuloaixe` | `klxe` | `KLXe` | Kieu loai xe |
| `thetich_congsuat` | `ttlvhcsuat` | `TTLVHCSuat` | Bat buoc khi `version = 1` va `loaihoadondactrung = 1` |
| `trongtai` | `ttai` | `TTai` | Decimal 9,2 |
| `sochongoi` | `scngoi` | `SCNgoi` | So nguoi cho phep cho |
| `chatluongtaisan` | `cltsan` | `CLTSan` | Bat buoc khi `tinhtrangtaisan = 1` |
| `sobienkiemsoat` | `sbksoat` | `SBKSoat` | Bat buoc khi `tinhtrangtaisan = 1` |

### Mapping cap hoa don

Nguon request nam tren object input chinh. Dich den DB/entity nam trong `HD_HoaDon_MoRong` / `vs_hd_tonghop_morong`.

| API input | Request field | Entity/DB field | Dieu kien map |
|---|---|---|---|
| `GuiHDGoc` | `ma_tinh` | `HD_HoaDon_MoRong.ma_tinh` | `version = 1` va hoa don co it nhat mot dong `loaihoadondactrung = 1` |
| `GuiHDGoc` | `ma_xa` | `HD_HoaDon_MoRong.ma_xa` | `version = 1` va hoa don co it nhat mot dong `loaihoadondactrung = 1` |
| `GuiHoaDonTT` | `ma_tinh` | `HD_HoaDon_MoRong.ma_tinh` | `version = 1` va hoa don thay the co it nhat mot dong `loaihoadondactrung = 1` |
| `GuiHoaDonTT` | `ma_xa` | `HD_HoaDon_MoRong.ma_xa` | `version = 1` va hoa don thay the co it nhat mot dong `loaihoadondactrung = 1` |
| `GuiHoaDonDC` | `ma_tinh` | `HD_HoaDon_MoRong.ma_tinh` | `version = 1` va hoa don dieu chinh co it nhat mot dong `loaihoadondactrung = 1` |
| `GuiHoaDonDC` | `ma_xa` | `HD_HoaDon_MoRong.ma_xa` | `version = 1` va hoa don dieu chinh co it nhat mot dong `loaihoadondactrung = 1` |


### Mapping XML `NMua` cho `ma_tinh`, `ma_xa`

Hai field dia ban hanh chinh cua nguoi mua render trong node `NMua`, khong render trong `TTHHDTrung`.

| Entity/DB field | XML path | XML tag | Kieu/do dai | Dieu kien render |
|---|---|---|---|---|
| `HD_HoaDon_MoRong.ma_tinh` | `HDon/DLHDon/NDHDon/NMua` | `MTinh` | string max 3 | `version = 1` va hoa don co dong `loaihoadondactrung = 1` |
| `HD_HoaDon_MoRong.ma_xa` | `HDon/DLHDon/NDHDon/NMua` | `MXa` | string max 8 | `version = 1` va hoa don co dong `loaihoadondactrung = 1` |

Rule:

- `MTinh` bat buoc khi `version = 1` va hoa don co hang hoa dac trung xe.
- `MXa` bat buoc khi `version = 1` va hoa don co hang hoa dac trung xe.
- Neu `version` khong truyen/null/rong/khac `1` hoac hoa don khong co `loaihoadondactrung = 1`, khong render `MTinh`, `MXa` de giu luong XML cu.
### Helper mapping de xuat

Tao helper dung chung de tranh lap logic o 3 API luu:

```csharp
// Pseudo-code: khi code that dung type cu the hoac helper overload cho tung DTO chi tiet.
private static bool IsNghiDinhMoi(HoaDonInputLike input)
{
    return input != null && input.version?.Trim() == "1";
}

private static bool HasHangHoaDacTrungXe(HoaDonInputLike input, IEnumerable<ChiTietLike> dschitiet)
{
    return IsNghiDinhMoi(input) && dschitiet != null && dschitiet.Any(x => x.loaihoadondactrung == 1);
}

private static void MapDacTrungXe(ChiTietLike item, HD_ChiTiet_MoRong mr)
{
    mr.Loai_HangHoa_DacTrung = item.loaihoadondactrung;
    mr.So_Khung = item.sokhung;
    mr.So_May = item.somay;
    mr.ltsan = item.loaitaisan;
    mr.tttsan = item.tinhtrangtaisan;
    mr.xxu = item.xuatxu;
    mr.sgcnatkthuat = item.sogiaychungnhanatkt;
    mr.sspktclxxuong = item.soseripktcl;
    mr.mnsxuat = item.ma_nuocsx;
    mr.tltsdky = item.ten_loaitaisan;
    mr.nsxuat = item.namsanxuat;
    mr.ttmai = item.ten_thuongmai;
    mr.tnhieu = item.ten_nhanhieu;
    mr.klxe = item.kieuloaixe;
    mr.ttlvhcsuat = item.thetich_congsuat;
    mr.ttai = item.trongtai;
    mr.scngoi = item.sochongoi;
    mr.cltsan = item.chatluongtaisan;
    mr.sbksoat = item.sobienkiemsoat;
}

private static void MapDiaBanDacTrung(HoaDonInputLike input, HD_HoaDon_MoRong mr)
{
    mr.ma_tinh = input.ma_tinh;
    mr.ma_xa = input.ma_xa;
}
```

Luu y implement:

- Snippet tren la pseudo-code de mo ta mapping; khi code that dung type cu the hoac helper overload cho `ChiTietHDG`, `ChiTietTT`, `ChiTietDC`.
- Chi goi `MapDacTrungXe` cho dong co `version = 1` va `loaihoadondactrung = 1` hoac khi can luu gia tri lien quan da validate.
- Chi goi `MapDiaBanDacTrung` khi `HasHangHoaDacTrungXe(input, input.dschitiet) = true`.
- XML utility khong lay tu request nua, ma lay tu entity da luu: `HD_ChiTiet_MoRong` va `HD_HoaDon_MoRong`.

## XML output

XML duoc sinh o buoc ky, khong sinh ngay tai thoi diem API nhan request.

- Voi API luu roi ky HSM, XML sinh trong service ky sau khi hoa don da luu thanh cong.
- Voi API MTT, XML sinh trong service ky MTT truoc khi gui TCT.
- Voi luong luu truoc, ky sau, XML van sinh tag moi neu 16 field moi da duoc luu trong `HD_ChiTiet_MoRong`.
- Hoa don cu khong co du lieu field moi thi XML giu nguyen nhu hien tai.

### Rule email nguoi mua cho the `NMua/DCTDTu`

Chi ap dung rule lay email dau tien cho the `HDon/DLHDon/NDHDon/NMua/DCTDTu` khi hoa don thuoc rule moi. O buoc nhan request, rule moi duoc kich hoat khi `version = 1` va co dong `loaihoadondactrung = 1`. O buoc render XML/ky sau, API khong con nhan `version` tu request, nen dieu kien ap dung can dua tren du lieu rule moi da duoc luu trong hoa don: `HasHangHoaDacTrungXe(hoaDon) = true`.

Pham vi anh huong la XML gui TCT cua du 7 API trong Plan va luong luu truoc ky sau qua API `KyHoaDon`, nhung chi khi hoa don da luu co du lieu hang hoa dac trung moi.

- Input khong doi, van nhan email nguoi mua tu field cap hoa don `dnmua_email`.
- Neu khong phai rule moi: giu nguyen logic email XML hien tai, khong ep lay email dau tien.
- Khi la rule moi va `dnmua_email` co 1 email: dung chinh email do de gan vao `HDon/DLHDon/NDHDon/NMua/DCTDTu`.
- Khi la rule moi va `dnmua_email` co nhieu email: tach theo dau `,` hoac `;`, trim khoang trang, lay email dau tien co gia tri de gan vao `HDon/DLHDon/NDHDon/NMua/DCTDTu`.
- Khong thay doi logic `NMua/TTKhac/TTin`: cac thong tin email trong `TTKhac/TTin` van giu nguyen cach render hien tai, tuc la neu DB dang luu nhieu email thi `TTKhac/TTin` van render nguyen chuoi email do.
- Khong thay doi gia tri luu DB cua `DNMua_Email`, de khong anh huong luong gui email noi bo dang co the gui cho nhieu email.
- Khong thay doi validate email hien tai neu validate da chap nhan danh sach email phan tach bang `,` hoac `;`.
- Vi tri code can cap nhat khi implement: helper render XML trong `HoaDonTT3278Utility.GetNMuaInfo(...)`, tao helper dung chung vi du `GetFirstBuyerEmailForXml(hoaDon.DNMua_Email)`.
- Dieu kien goi helper lay email dau tien trong XML: chi goi khi set `NMua/DCTDTu` va `HasHangHoaDacTrungXe(hoaDon) = true`.

Dieu kien render XML hang hoa dac trung moi: chi render khi dong chi tiet co du lieu trong nhom 16 field moi ben duoi. Khi render nhom field moi nay, cap nhat the `PBan` thanh `2.1.1`.

16 field moi dung lam dieu kien render XML:

- `loaitaisan` -> DB `ltsan` -> XML `LTSan`
- `tinhtrangtaisan` -> DB `tttsan` -> XML `TTTSan`
- `xuatxu` -> DB `xxu` -> XML `XXu`
- `sogiaychungnhanatkt` -> DB `sgcnatkthuat` -> XML `SGCNATKThuat`
- `soseripktcl` -> DB `sspktclxxuong` -> XML `SSPKTCLXXuong`
- `ma_nuocsx` -> DB `mnsxuat` -> XML `MNSXuat`
- `ten_loaitaisan` -> DB `tltsdky` -> XML `TLTSDKy`
- `namsanxuat` -> DB `nsxuat` -> XML `NSXuat`
- `ten_thuongmai` -> DB `ttmai` -> XML `TTMai`
- `ten_nhanhieu` -> DB `tnhieu` -> XML `TNHieu`
- `kieuloaixe` -> DB `klxe` -> XML `KLXe`
- `thetich_congsuat` -> DB `ttlvhcsuat` -> XML `TTLVHCSuat`
- `trongtai` -> DB `ttai` -> XML `TTai`
- `sochongoi` -> DB `scngoi` -> XML `SCNgoi`
- `chatluongtaisan` -> DB `cltsan` -> XML `CLTSan`
- `sobienkiemsoat` -> DB `sbksoat` -> XML `SBKSoat`

Tag can sinh khi co du lieu hang hoa dac trung:

- `SKhung`
- `SMay`
- `LTSan`
- `TTTSan`
- `XXu`
- `SGCNATKThuat`
- `SSPKTCLXXuong`
- `MNSXuat`
- `TLTSDKy`
- `NSXuat`
- `TTMai`
- `TNHieu`
- `KLXe`
- `TTLVHCSuat`
- `TTai`
- `SCNgoi`
- `CLTSan`
- `SBKSoat`

Vi du XML rut gon:

```xml
<TTHHDTrung>
  <TTin>
    <TTruong>SKhung</TTruong>
    <DLieu>ABC123456789</DLieu>
  </TTin>
  <TTin>
    <TTruong>SMay</TTruong>
    <DLieu>ENG123456</DLieu>
  </TTin>
  <TTin>
    <TTruong>LTSan</TTruong>
    <DLieu>1</DLieu>
  </TTin>
  <TTin>
    <TTruong>XXu</TTruong>
    <DLieu>1</DLieu>
  </TTin>
  <TTin>
    <TTruong>SGCNATKThuat</TTruong>
    <DLieu>GCN-001</DLieu>
  </TTin>
</TTHHDTrung>
```

## Acceptance criteria

- Tai lieu liet ke du 7 API bi anh huong.
- Tai lieu ghi ro validate hang hoa dac trung kich hoat theo `version = 1` va `dschitiet[].loaihoadondactrung = 1`.
- Tai lieu ghi ro field moi nam trong `dschitiet[]`.
- Tai lieu co bang field request, cot DB/entity, the XML, field bat buoc, dieu kien bat buoc va mapping tay request -> DB/entity -> XML.
- Tai lieu co vi du request co `version = 1` va `loaihoadondactrung = 1` cho hoa don goc, thay the, dieu chinh.
- Tai lieu co `version`, `ma_tinh`, `ma_xa` trong request example, ghi ro DB da co cot `vs_hd_tonghop_morong.ma_tinh`, `vs_hd_tonghop_morong.ma_xa`, nguon input cap hoa don cho `HD_HoaDon_MoRong`, mapping XML `HDon/DLHDon/NDHDon/NMua/MTinh`, `HDon/DLHDon/NDHDon/NMua/MXa`, va dieu kien chi ap dung khi `version = 1` va hoa don co `loaihoadondactrung = 1`.
- Tai lieu co phan XML output, dieu kien render theo 16 field moi, cap nhat `PBan = 2.1.1`, va luu y HSM/MTT.

## Estimate

| Hang muc | Estimate |
|---|---:|
| Cap nhat tai lieu API/schema | 1.5-2h |
| Bo sung vi du request/XML | 1-1.5h |
| Review rule bat buoc tu phu luc | 0.5-1h |

Tong docs task: **3-4.5h**.


## Response va ma ket qua API tich hop

Phan nay document rieng cau truc response va ma thong diep tra ve cua 7 API bi anh huong. Thay doi CBCLOUDV2-9167 khong doi response contract hien tai; chi them validate/map/XML cho hoa don co `version = 1` va `dschitiet[].loaihoadondactrung = 1`.

### 1. Danh sach API va response DTO

| API | Input | Response DTO | Ghi chu |
|---|---|---|---|
| `GuiHoaDonGoc` | `GuiHDGoc` | `KquaGuiHD` | Luu hoa don goc |
| `GuiVaKyHoadonGocHSM` | `GuiHDGoc` | `KquaGuiVaKyHD` | Luu hoa don goc roi ky HSM |
| `GuiHoaDonThayThe` | `GuiHoaDonTT` | `KquaTT` | Luu hoa don thay the |
| `GuiVaKyHoaDonThayTheHSM` | `GuiHoaDonTT` | `KquaGuiVaKyHD` | Luu hoa don thay the roi ky HSM |
| `GuiHoaDonDieuChinh` | `GuiHoaDonDC` | `KquaDC` | Luu hoa don dieu chinh |
| `GuiVaKyHoaDonDieuChinhHSM` | `GuiHoaDonDC` | `KquaGuiVaKyHD` | Luu hoa don dieu chinh roi ky HSM |
| `GuiHoaDonVaKyMTT` | `GuiHDGoc` | `KetQuaKyVaGuiTctMTT` | Luu, cap so, ky MTT, gui TCT |

### 2. Response structure

`KquaGuiHD` - dung cho `GuiHoaDonGoc`:

```json
{
  "maketqua": "01",
  "motaketqua": "Gui hoa don goc thanh cong",
  "magiaodich": "...",
  "sohoadon": "...",
  "mauso": "...",
  "kyhieu": "...",
  "ngayky": "...",
  "tct_macoquan": "...",
  "ma_tinh": "...",
  "ma_xa": "...",
  "key": 0
}
```

`KquaTT` - dung cho `GuiHoaDonThayThe`:

```json
{
  "maketqua": "01",
  "motaketqua": "Gui hoa don thay the thanh cong",
  "magiaodich": "...",
  "sohoadon": "...",
  "mauso": "...",
  "kyhieu": "...",
  "ngayky": "...",
  "tct_macoquan": "...",
  "ma_tinh": "...",
  "ma_xa": "..."
}
```

`KquaDC` - dung cho `GuiHoaDonDieuChinh`:

```json
{
  "maketqua": "01",
  "motaketqua": "Gui hoa don dieu chinh thanh cong",
  "magiaodich": "...",
  "sohoadon": "...",
  "mauso": "...",
  "kyhieu": "...",
  "ngayky": "...",
  "tct_macoquan": "...",
  "ma_tinh": "...",
  "ma_xa": "..."
}
```

`KquaGuiVaKyHD` - dung cho 3 API HSM:

```json
{
  "maketqua": "01",
  "motaketqua": "Gui va ky hoa don thanh cong",
  "magiaodich": "...",
  "mauso": "...",
  "kyhieu": "...",
  "sohoadon": "...",
  "ngayky": "...",
  "base64xml": "...",
  "link_tracuu": "...",
  "trangthai": "...",
  "motatrangthai": "...",
  "ketqua": false,
  "tct_macoquan": "...",
  "ma_tinh": "...",
  "ma_xa": "...",
  "loaihoadon": "...",
  "ngaylap": "...",
  "ma_hoadon": "..."
}
```

`KetQuaKyVaGuiTctMTT` - dung cho `GuiHoaDonVaKyMTT`:

```json
{
  "ketqua": true,
  "motaketqua": "Gui TCT hoa don thanh cong!",
  "maketqua": "01",
  "ma_hoadon": "...",
  "magiaodich": "...",
  "loaihoadon": "...",
  "mauso": "...",
  "kyhieu": "...",
  "sohoadon": "...",
  "ngaylap": "...",
  "trangthai": 0,
  "motatrangthai": "...",
  "tct_macoquan": "...",
  "base64xml": "...",
  "ngayky": "..."
}
```

### 3. Ma ket qua API luu hoa don

`GuiHoaDonGoc`:

| Ma | Truong hop |
|---|---|
| `01` | Gui/luu hoa don goc thanh cong |
| `02` | Khong tim thay thong tin doanh nghiep |
| `03` | Day lai hoa don sau 30s hoac trung ho so |
| `04` | Loi validate input, bao gom validate field hang hoa dac trung khi `version = 1` va `loaihoadondactrung = 1` |
| `05` | Hoa don da gui yeu cau ky |
| `06` | Loi mau hoa don, ky hieu, nam hoa don |
| `07` | Doanh nghiep da dang ky TT78 nhung gui sai luong |
| `08` | Doanh nghiep chua dang ky TT78 nhung gui sai luong |
| `00` | Loi phat sinh |

`GuiHoaDonThayThe`:

| Ma | Truong hop |
|---|---|
| `01` | Gui hoa don thay the thanh cong |
| `02` | Khong tim thay thong tin doanh nghiep |
| `03` | Day lai hoa don sau 30s hoac trung ho so |
| `04` | Khong tim thay thong tin mau hoa don hoac loi ma co quan thue |
| `05` | Khong tim thay thong tin hoa don goc |
| `06` | Hoa don goc chua phat hanh hoac loi ky hieu/nam hoa don |
| `07` | Khong duoc thay the hoa don nay |
| `08` | Loi validate input, bao gom validate field hang hoa dac trung khi `version = 1` va `loaihoadondactrung = 1` |
| `09` | Dung luong file qua lon |
| `10` | Noi dung file khong dung dinh dang |
| `00` | Loi phat sinh |

`GuiHoaDonDieuChinh`:

| Ma | Truong hop |
|---|---|
| `01` | Gui hoa don dieu chinh thanh cong |
| `02` | Khong tim thay thong tin doanh nghiep |
| `03` | Day lai hoa don sau 30s hoac trung ho so |
| `04` | Khong tim thay thong tin mau hoa don hoac loi ma co quan thue |
| `05` | Khong tim thay thong tin hoa don goc hoac khong thuoc doanh nghiep |
| `06` | Hoa don goc chua phat hanh hoac loi ky hieu/nam hoa don |
| `07` | Khong duoc dieu chinh hoa don nay |
| `08` | Loi validate input, bao gom validate field hang hoa dac trung khi `version = 1` va `loaihoadondactrung = 1` |
| `09` | Dung luong file qua lon |
| `10` | Noi dung file khong dung dinh dang |
| `00` | Loi phat sinh |

### 4. Ma ket qua API HSM

`GuiVaKyHoadonGocHSM`:

- Neu buoc luu hoa don loi thi tra lai ma cua `GuiHoaDonGoc`.
- Neu buoc ky loi thi map ma tu `KyHoaDon`: `04 -> 07`, `05 -> 08`, `06 -> 07`, `07 -> 09`, `08 -> 10`, cac ma khac giu nguyen.
- Thanh cong tra `maketqua = "01"`, `motaketqua = "Gui va ky hoa don thanh cong"`.

`GuiVaKyHoaDonThayTheHSM`:

- Neu buoc luu hoa don loi thi tra lai ma cua `GuiHoaDonThayThe`.
- Neu buoc ky loi thi map ma tu `KyHoaDon`: `04 -> 11`, `05 -> 12`, `06 -> 13`, `07 -> 14`, `08 -> 15`, cac ma khac giu nguyen.
- Thanh cong tra `maketqua = "01"`, `motaketqua = "Gui va ky hoa don thanh cong"`.

`GuiVaKyHoaDonDieuChinhHSM`:

- Neu buoc luu hoa don loi thi map ma tu `GuiHoaDonDieuChinh`: `04 -> 06`, `05 -> 12`, `06 -> 13`, `07 -> 14`, `08 -> 04`, cac ma khac giu nguyen.
- Neu buoc ky loi thi map ma tu `KyHoaDon`: `04 -> 07`, `05 -> 08`, `06 -> 07`, `07 -> 09`, `08 -> 10`, cac ma khac giu nguyen.
- Thanh cong tra `maketqua = "01"`, `motaketqua = "Gui va ky hoa don thanh cong"`.

### 5. Ma ket qua API MTT

`GuiHoaDonVaKyMTT` gom 4 buoc: luu hoa don goc, cap so, ky MTT, gui TCT.

| Buoc | Ket qua tra ve |
|---|---|
| Luu hoa don loi | `ketqua = false`, `motaketqua` theo `GuiHoaDonGoc`; cac ma validate hang hoa dac trung nam trong buoc nay |
| Cap so loi | `ketqua = false`, `maketqua/motaketqua` theo `CapSoHoaDon` |
| Ky MTT loi | `ketqua = false`, `maketqua/motaketqua` theo `KyHoaDonMTT` |
| Gui TCT loi | `ketqua = false`, `motaketqua` theo `GuiTCTHoaDonMTT` |
| Thanh cong | `ketqua = true`, thuong `maketqua = "01"`, `motaketqua = "Gui TCT hoa don thanh cong!"` |

### 6. Ma loi validate field hang hoa dac trung

Khi `version = 1` va `dschitiet[].loaihoadondactrung = 1`, cac loi validate field moi duoc gom vao message validate hien tai:

- `GuiHoaDonGoc`: tra `maketqua = "04"`, `motaketqua = <message validate>`.
- `GuiHoaDonThayThe`: tra `maketqua = "08"`, `motaketqua = <message validate>`.
- `GuiHoaDonDieuChinh`: tra `maketqua = "08"`, `motaketqua = <message validate>`.
- Cac API HSM/MTT dung lai ket qua validate cua API luu hoa don tuong ung.

Cac field validate bat buoc gom: `sokhung`, `somay`, `loaitaisan`, `tinhtrangtaisan`, `xuatxu`, `ma_nuocsx`, `ten_loaitaisan`, `namsanxuat`, `ten_thuongmai`, `ten_nhanhieu`, `kieuloaixe`, `thetich_congsuat`, `trongtai`, `sochongoi`, `ma_tinh`, `ma_xa`; field dieu kien: `sogiaychungnhanatkt` khi `xuatxu = 1`, `soseripktcl` khi `xuatxu = 0`, `chatluongtaisan` va `sobienkiemsoat` khi `tinhtrangtaisan = 1`.

## Bo sung rule validate thong tin nguoi mua cho hoa don dac trung

### 1. Dieu kien kich hoat

Rule validate thong tin nguoi mua chi kich hoat khi hoa don thoa dong thoi 2 dieu kien:

```csharp
input.version?.Trim() == "1"
    && dschitiet.Any(x => x.loaihoadondactrung == 1)
```

Neu `version` khong truyen/null/rong/khac `1` hoac khong co dong `loaihoadondactrung = 1` thi giu nguyen luong validate hien tai, khong bat buoc them cac field duoi day.

### 2. Field cap hoa don can validate

Cac field nay nam o cap hoa don trong request, khong nam trong `dschitiet[]`.

| Request field | XML path/tag | Bat buoc khi `version = 1` va co `loaihoadondactrung = 1` | Do dai toi da | Ghi chu |
|---|---|---|---:|---|
| `dnmua_ten` | `HDon/DLHDon/NDHDon/NMua/Ten` | Co | 400 | Ten nguoi mua/don vi mua |
| `dnmua_mst` | `HDon/DLHDon/NDHDon/NMua/MST` | Co | 14 | Ma so thue nguoi mua |
| `dnmua_diachi` | `HDon/DLHDon/NDHDon/NMua/DChi` | Co | 400 | Dia chi nguoi mua |
| `ma_tinh` | `HDon/DLHDon/NDHDon/NMua/MTinh` | Co | 3 | Ma tinh/thanh pho noi dang ky phuong tien |
| `ma_xa` | `HDon/DLHDon/NDHDon/NMua/MXa` | Co | 8 | Ma xa/phuong noi dang ky phuong tien |
| `dnmua_sdt` | `HDon/DLHDon/NDHDon/NMua/SDThoai` | Co | 20 | So dien thoai nguoi mua |
| `dnmua_email` | `HDon/DLHDon/NDHDon/NMua/DCTDTu` | Co | 50 | Dia chi thu dien tu nguoi mua |
| `dnmua_tennguoimua` | `HDon/DLHDon/NDHDon/NMua/HVTNMHang` | Co | 100 | Ho va ten nguoi mua hang |

### 3. Vi tri code can sua

Them helper validate chung, vi 3 input chinh co bo field nguoi mua tuong duong nhau:

- `ValidateNguoiMuaDacTrungXe(bool hasHangHoaDacTrungXe, GuiHDGoc input)`.
- `ValidateNguoiMuaDacTrungXe(bool hasHangHoaDacTrungXe, GuiHoaDonTT input)`.
- `ValidateNguoiMuaDacTrungXe(bool hasHangHoaDacTrungXe, GuiHoaDonDC input)`.
- `ValidateNguoiMuaDacTrungXeValues(...)` xu ly required va max length cho 8 field cap hoa don.

Gan helper nay vao dau cac ham validate luu hoa don:

| API luu hoa don | Ham validate can goi helper | Ma loi validate hien tai |
|---|---|---|
| `GuiHoaDonGoc([FromBody] GuiHDGoc)` | `ValidateHDGoc(...)` | `maketqua = "04"` |
| `GuiHoaDonThayThe([FromBody] GuiHoaDonTT)` | `ValidateHDTT(...)` | `maketqua = "08"` |
| `GuiHoaDonDieuChinh([FromBody] GuiHoaDonDC)` | `ValidateHDDC(...)` | `maketqua = "08"` |

### 4. Pham vi API ap dung

Rule nghiep vu ap dung cho du 7 API tich hop:

| API | Cach ap dung validate |
|---|---|
| `GuiHoadonGoc` | Validate truc tiep trong luong luu hoa don goc |
| `GuiVaKyHoadonGocHSM` | Goi luong luu hoa don goc, neu validate loi thi dung truoc khi ky HSM |
| `GuiHoadonThayThe` | Validate truc tiep trong luong luu hoa don thay the |
| `GuiVaKyHoaDonThayTheHSM` | Goi luong luu/thay the, neu validate loi thi dung truoc khi ky HSM |
| `GuiHoadonDieuChinh` | Validate truc tiep trong luong luu hoa don dieu chinh |
| `GuiVaKyHoaDonDieuChinhHSM` | Goi luong luu/dieu chinh, neu validate loi thi dung truoc khi ky HSM |
| `GuiHoaDonVaKyMTT` | Goi `GuiHoaDonGoc` de luu, neu validate loi thi dung truoc cap so, ky MTT va gui TCT |

### 5. Anh huong response va XML

Khong thay doi response contract. Neu validate loi thi message duoc gom vao `motaketqua` theo co che hien tai cua tung API luu hoa don.

Khong them tag XML moi trong rule nay. Cac tag `NMua/Ten`, `NMua/MST`, `NMua/DChi`, `NMua/MTinh`, `NMua/MXa`, `NMua/SDThoai`, `NMua/DCTDTu`, `NMua/HVTNMHang` da thuoc nhom thong tin nguoi mua; rule nay chi bat buoc validate input truoc khi luu/ky khi hoa don co `version = 1` va hang hoa dac trung.

## Plan fix validate `ma_tinh`, `ma_xa` theo host DB

### 1. Nguyen nhan can fix

Hai bang danh muc dia ban:

- `vs_danhmuc_tinh_thanh`
- `vs_danhmuc_xa_phuong`

nam o host DB, khong nam o tenant DB. Neu validate `ma_tinh`, `ma_xa` bang tenant connection thi co the gap loi table not found, vi du `Table 'invoicesysv2tenant01.vs_danhmuc_tinh_thanh' doesn't exist`, hoac catalog rong lam API tra sai `Mã tỉnh không tồn tại.` / `Mã xã không tồn tại.`.

### 2. Scope fix

Chi fix validate cho task CBCLOUDV2-9167 trong service:

- `\XBill\Cloud\api-cloud-service`
- File chinh can sua: `src\hddt\WS.Application\AppServices\HoaDon\GuiHoaDonAppService.cs`

Khong thay doi DB. Khong sua XML trong scope fix nay. Khong anh huong API XML raw nhu `GuiHoaDonGocXML`, `GuiHoaDonDieuChinhXML`, `GuiHoaDonThayTheXML`.

### 3. API ap dung

Validate `ma_tinh`, `ma_xa` ap dung cho du 7 API tich hop da nam trong task:

| API | Input | Cach ap dung validate dia ban |
|---|---|---|
| `GuiHoaDonGoc` | `GuiHDGoc` | Validate truc tiep truoc khi luu hoa don goc |
| `GuiVaKyHoadonGocHSM` | `GuiHDGoc` | Goi luong luu hoa don goc; neu validate loi thi dung truoc khi ky HSM |
| `GuiHoaDonThayThe` | `GuiHoaDonTT` | Validate truc tiep truoc khi luu hoa don thay the |
| `GuiVaKyHoaDonThayTheHSM` | `GuiHoaDonTT` | Goi luong luu hoa don thay the; neu validate loi thi dung truoc khi ky HSM |
| `GuiHoaDonDieuChinh` | `GuiHoaDonDC` | Validate truc tiep truoc khi luu hoa don dieu chinh |
| `GuiVaKyHoaDonDieuChinhHSM` | `GuiHoaDonDC` | Goi luong luu hoa don dieu chinh; neu validate loi thi dung truoc khi ky HSM |
| `GuiHoaDonVaKyMTT` | `GuiHDGoc` | Goi `GuiHoaDonGoc`; neu validate loi thi dung truoc cap so, ky MTT va gui TCT |

### 4. Dieu kien validate dia ban

Chi validate ton tai `ma_tinh`, `ma_xa` khi hoa don thoa dong thoi 2 dieu kien:

```csharp
input.version?.Trim() == "1"
    && dschitiet.Any(x => x.loaihoadondactrung == 1)
```

Neu `version` khong truyen/null/rong/khac `1` hoac hoa don khong co dong `loaihoadondactrung = 1` thi giu nguyen luong cu, khong bat buoc va khong validate ton tai `ma_tinh`, `ma_xa`.

### 5. Rule validate can bo sung

Sau khi validate bat buoc va do dai hien tai:

| Field | Rule ton tai | Message |
|---|---|---|
| `ma_tinh` | Ton tai trong `vs_danhmuc_tinh_thanh.tinhthanh_ma`, `IsDeleted = 0`, `tinhthanh_hieuluc` khac false/null hop le | `Mã tỉnh không tồn tại.` |
| `ma_xa` | Ton tai trong `vs_danhmuc_xa_phuong.xa_phuong_ma`, thuoc dung `tinhthanh_ma = ma_tinh`, `IsDeleted = 0`, `xa_phuong_hieuluc` khac false/null hop le | `Mã xã không tồn tại.` |

Can normalize truoc khi so sanh:

- Trim khoang trang.
- Giu leading zero, vi ma co dang `"01"`, `"00004"`, `"10141"`.
- Khong parse sang number.

### 6. Huong implementation de tranh query sai DB

Trong `api-cloud-service`, source hien co `DM_NCC_TinhThanh` cu, chua thay entity rieng cho `vs_danhmuc_tinh_thanh` va `vs_danhmuc_xa_phuong`. Co 2 phuong an:

| Phuong an | Cach lam | Danh gia |
|---|---|---|
| A - Them entity host catalog | Them entity `DM_TinhThanh`, `DM_XaPhuong`, mapping table `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong`, inject repository vao `GuiHoaDonAppService`, query trong `using (_unitOfWorkManager.Current.SetTenantId(null))` | Dong bo voi BE `invoicecore`, de unit test va dung pattern ABP |
| B - Query raw host DB | Tao helper query raw bang host/default connection string, dung `MySqlConnection`/Dapper hoac EF raw SQL, boc `try/catch` | It file hon, nhung can can than connection string va kho mock test |

Khuyen nghi dung phuong an A neu project da co entity host catalog tu task lien quan; neu source `api-cloud-service` chua co entity/table mapping thi dung phuong an B de fix nhanh va tranh lan rong.

### 7. Step by step fix code

1. Kiem tra trong `api-cloud-service` da co entity/table mapping `DM_TinhThanh`, `DM_XaPhuong` cho `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` chua.
2. Neu chua co entity, chon mot trong 2 cach:
   - Them entity host catalog + `DbSet` + mapping table.
   - Hoac them private helper raw query host DB trong `GuiHoaDonAppService`.
3. Tao helper load catalog dia ban, vi du:

```csharp
private VehicleAssetLocationCatalog LoadVehicleAssetLocationCatalog()
```

Helper nay phai:

- Chay bang host DB, khong dung tenant DB.
- Boc `try/catch`.
- Log ngan gon, vi du `Validate vehicle location catalog error`.
- Neu query loi thi tra catalog rong de API khong crash boi exception DB.

4. Tao helper validate ton tai:

```csharp
private string ValidateDiaBanDacTrungXe(bool isNghiDinhMoi, bool hasHangHoaDacTrungXe, string maTinh, string maXa)
```

Helper nay:

- Return empty neu `isNghiDinhMoi = false` hoac `hasHangHoaDacTrungXe = false`.
- Neu `ma_tinh`, `ma_xa` dang trong trang thai missing thi de rule bat buoc hien tai bao loi, tranh duplicate message.
- Neu co gia tri thi check catalog:
  - `ma_tinh` khong ton tai -> them `Mã tỉnh không tồn tại.`
  - cap `ma_tinh` + `ma_xa` khong ton tai -> them `Mã xã không tồn tại.`

5. Goi helper trong `ValidateNguoiMuaDacTrungXeValues(...)` hoac ngay sau `ValidateNguoiMuaDacTrungXe(...)` cua 3 input:
   - `GuiHDGoc`
   - `GuiHoaDonTT`
   - `GuiHoaDonDC`

6. Dam bao cac luong HSM/MTT khong can viet validate rieng, vi da di qua API luu hoa don:
   - HSM goc -> `GuiHoaDonGoc`.
   - HSM thay the -> `GuiHoaDonThayThe`.
   - HSM dieu chinh -> `GuiHoaDonDieuChinh`.
   - MTT -> `GuiHoaDonGoc`.

7. Build `WS.Application` va chay unit test/manual test theo case ben duoi.

### 8. Ma loi va response sau fix

Khong doi response contract, chi bo sung message validate:

| API | Khi `ma_tinh`/`ma_xa` khong ton tai | Ma loi |
|---|---|---|
| `GuiHoaDonGoc` | `motaketqua` gom `Mã tỉnh không tồn tại.` / `Mã xã không tồn tại.` | `maketqua = "04"` |
| `GuiVaKyHoadonGocHSM` | Tra theo ket qua loi cua buoc luu hoa don goc, dung truoc khi ky | Theo mapping hien tai cua HSM goc |
| `GuiHoaDonThayThe` | `motaketqua` gom `Mã tỉnh không tồn tại.` / `Mã xã không tồn tại.` | `maketqua = "08"` |
| `GuiVaKyHoaDonThayTheHSM` | Tra theo ket qua loi cua buoc luu thay the, dung truoc khi ky | Theo mapping hien tai cua HSM thay the |
| `GuiHoaDonDieuChinh` | `motaketqua` gom `Mã tỉnh không tồn tại.` / `Mã xã không tồn tại.` | `maketqua = "08"` |
| `GuiVaKyHoaDonDieuChinhHSM` | Tra theo ket qua loi cua buoc luu dieu chinh, dung truoc khi ky | Theo mapping hien tai cua HSM dieu chinh |
| `GuiHoaDonVaKyMTT` | Tra loi tu `GuiHoaDonGoc`, dung truoc cap so/ky/gui TCT | Theo response MTT hien tai |

### 9. Test case can chay

| Case | Input | Ky vong |
|---|---|---|
| Hoa don luong cu | Khong truyen/null/rong `version`, co hoac khong co dong `loaihoadondactrung = 1` | Thanh cong nhu luong cu, khong bat field moi |
| Hoa don thuong | `version = 1` nhung khong co dong `loaihoadondactrung = 1`, khong truyen `ma_tinh`, `ma_xa` | Thanh cong nhu luong cu |
| Hoa don dac trung dung dia ban | `version = 1`, co dong `loaihoadondactrung = 1`, `ma_tinh = "01"`, `ma_xa` ton tai va thuoc `01` | Validate pass, luu du lieu vao `vs_hd_tonghop_morong` |
| Thieu `ma_tinh` | Co dong dac trung, khong truyen `ma_tinh` | Bao `Mã tỉnh không được để trống.` |
| Thieu `ma_xa` | Co dong dac trung, khong truyen `ma_xa` | Bao `Mã xã không được để trống.` |
| `ma_tinh` khong ton tai | Co dong dac trung, truyen ma tinh khong co trong host catalog | Bao `Mã tỉnh không tồn tại.` |
| `ma_xa` khong ton tai | Co dong dac trung, truyen ma xa khong co trong host catalog | Bao `Mã xã không tồn tại.` |
| `ma_xa` khong thuoc `ma_tinh` | Ma tinh ton tai, ma xa ton tai nhung thuoc tinh khac | Bao `Mã xã không tồn tại.` |
| Vuot do dai `ma_tinh` | `ma_tinh` qua 3 ky tu | Bao loi do dai hien tai |
| Vuot do dai `ma_xa` | `ma_xa` qua 8 ky tu | Bao loi do dai hien tai |
| Query catalog loi | Gia lap host DB loi/khong truy cap duoc | Ghi log ngan gon, khong crash API; neu co dia ban thi validate khong ton tai |

### 10. Anh huong can luu y

- Chi anh huong API co `version = 1` va hoa don dac trung xe `loaihoadondactrung = 1`.
- Hoa don khong truyen/null/rong `version`, hoa don thuong va hoa don dac trung loai khac giu luong cu.
- Khong sinh XML neu validate fail, vi fail truoc buoc luu/ky.
- Neu query nham tenant DB thi loi cu se lap lai; day la diem can test bang tenant khong co 2 bang danh muc.

### 11. Trang thai cap nhat code theo rule `version`

Da cap nhat trong `\XBill\Cloud\api-cloud-service`:

- Them field `version` kieu string vao 3 input chinh: `GuiHDGoc`, `GuiHoaDonTT`, `GuiHoaDonDC`.
- Them helper `IsNghiDinhMoi(version)` voi dieu kien `version.Trim() == "1"`.
- Them helper `HasHangHoaDacTrungXeMoi(...)` de check dong thoi:
  - `version = 1`.
  - Co dong `dschitiet[].loaihoadondactrung = 1`.
- Neu `version` khong truyen/null/rong/khac `1` thi bo qua:
  - Validate 16 field xe.
  - Validate thong tin nguoi mua bat buoc theo hang hoa dac trung.
  - Validate ton tai `ma_tinh`, `ma_xa`.
  - Map `ma_tinh`, `ma_xa` va 16 field xe vao entity mo rong theo rule moi.
  - Render XML tag moi va cap nhat `PBan = 2.1.1`.
- Giu lai logic cu cua `loaihoadondactrung`, bao gom map `Loai_HangHoa_DacTrung`, `So_Khung`, `So_May` va cac rule dac trung cu.
- XML `PBan = 2.1.1`, `MTinh`, `MXa` va 16 tag moi chi bat khi hoa don da co du lieu field moi trong `HD_ChiTiet_MoRong`.
- Giu lai logic query host DB cho `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong`, nhung chi goi khi `version = 1` va co hang hoa dac trung xe.

## Bo sung validate dong bo theo BE import

### 1. Ly do

Sau khi doi chieu voi validate BE import trong `invoicecore`, API tich hop can bo sung cac rule con thieu de tranh 2 loi:

- Field bat buoc moi bi bo trong nhung van gui thanh cong.
- Field so truyen sai kieu hoac vuot do dai lam roi vao `[Internal server error]` thay vi tra validate nghiep vu.

### 2. Field bat buoc bo sung

Khi `version = 1` va dong `dschitiet[]` co `loaihoadondactrung = 1`, cac field sau bat buoc phai co:

| Request field | Message khi thieu |
|---|---|
| `ten_thuongmai` | `Tên thương mại không được để trống.` |
| `ten_nhanhieu` | `Tên nhãn hiệu không được để trống.` |
| `thetich_congsuat` | `Thể tích làm việc hoặc Công suất không được để trống.` |

### 3. Validate kieu du lieu so

Cac field so duoi day neu truyen chu/ky tu khong phai so thi tra validate tieng Viet, khong de exception model binding/DB:

| Request field | Message khi sai kieu |
|---|---|
| `loaihoadondactrung` | `Loại hóa đơn đặc trưng dữ liệu không hợp lệ.` |
| `loaitaisan` | `Loại tài sản dữ liệu không hợp lệ.` |
| `tinhtrangtaisan` | `Tình trạng tài sản dữ liệu không hợp lệ.` |
| `xuatxu` | `Xuất xứ dữ liệu không hợp lệ.` |
| `namsanxuat` | `Năm sản xuất dữ liệu không hợp lệ.` |
| `trongtai` | `Trọng tải dữ liệu không hợp lệ.` |
| `sochongoi` | `Số người cho phép chở dữ liệu không hợp lệ.` |
| `chatluongtaisan` | `Chất lượng tài sản % dữ liệu không hợp lệ.` |

### 4. Validate do dai/dinh dang so

| Request field | Rule | Message |
|---|---|---|
| `trongtai` | Decimal toi da `9,2` | `Trọng tải không đúng định dạng.` |
| `sochongoi` | So nguyen toi da 4 chu so | `Số người cho phép chở không đúng định dạng.` |
| `chatluongtaisan` | Decimal toi da `4,2`, chi bat khi `tinhtrangtaisan = 1` | `Chất lượng tài sản % không đúng định dạng.` |

### 5. Vi tri code da ap dung

- Them converter cho field so trong 3 DTO chi tiet: `GuiHDGoc`, `GuiHoaDonTT`, `GuiHoaDonDC`.
- Them helper converter trong `src\hddt\WS.Application\DataTransferObjects\GuiHoaDon\VehicleAssetNullableNumberConverters.cs`.
- Them validate bat buoc/kieu/dinh dang trong `ValidateHangHoaDacTrungXeValues(...)`.
- Them validate `loaihoadondactrung` sai kieu vao 3 luong validate chi tiet cua hoa don goc, thay the, dieu chinh.

## Unit test da bo sung sau khi implement `version`

### Test project

- Them test project rieng: `\XBill\Cloud\api-cloud-service\test\WS.Application.Tests\WS.Application.Tests.csproj`.
- Them test file: `\XBill\Cloud\api-cloud-service\test\WS.Application.Tests\HoaDon\VehicleAssetVersionRuleTests.cs`.

### Test cases da cover

| Case | Ky vong |
|---|---|
| `version` null/rong/khoang trang/`0`/`2` | Khong bat rule nghi dinh moi |
| `version = "1"` hoac `" 1 "` | Bat rule nghi dinh moi |
| Khong truyen `version`, co `loaihoadondactrung = 1` | Khong validate/map/render field moi, giu luong cu |
| `version = 1` va `loaihoadondactrung = 1` | Bat validate/map theo rule moi |
| Field so truyen chu/ky tu khong phai so | Converter giu gia tri sentinel de validate tra message `dữ liệu không hợp lệ` |
| Validate field so sai kieu | Tra dung message cho `loaitaisan`, `tinhtrangtaisan`, `xuatxu`, `namsanxuat`, `trongtai`, `sochongoi` |
| Validate do dai field string dong xe | Tra dung message vuot do dai cho `sokhung`, `somay`, `sogiaychungnhanatkt`, `soseripktcl`, `ma_nuocsx`, `ten_loaitaisan`, `ten_thuongmai`, `ten_nhanhieu`, `kieuloaixe`, `thetich_congsuat`, `sobienkiemsoat` |
| Validate do dai/dinh dang field so dong xe | Tra dung message cho `trongtai 9,2`, `sochongoi 4 so`, `chatluongtaisan 4,2` |
| Validate do dai thong tin nguoi mua | Tra dung message cho `Ten`, `MST`, `DChi`, `MTinh`, `MXa`, `SDThoai`, `DCTDTu`, `HVTNMHang` |
| XML rule moi, `dnmua_email` co 1 email | `NMua/DCTDTu` dung dung email da nhap; `NMua/TTKhac/TTin` giu logic cu |
| XML rule moi, `dnmua_email` co nhieu email phan tach bang `,` hoac `;` | `NMua/DCTDTu` chi dung email dau tien sau khi trim; `NMua/TTKhac/TTin` van giu nguyen chuoi email theo logic cu |
| XML khong phai rule moi, `dnmua_email` co nhieu email | Giu logic XML hien tai, khong set/lua chon email dau tien cho `NMua/DCTDTu` |
| XML hoa don cu chi co `SKhung`, `SMay` | Khong bat `PBan = 2.1.1`, khong render 16 tag moi |
| XML co du lieu mot trong 16 field moi | Bat dieu kien schema moi |

### Lenh da chay

```bash
dotnet test "D:\XBill\Cloud\api-cloud-service\test\WS.Application.Tests\WS.Application.Tests.csproj" -v normal
```

### Ket qua

```text
Test Run Successful.
Total tests: 17
Passed: 17
0 Error(s)
```

Ghi chu: qua trinh build/test van co warning package `.NET Core 2.2` va duplicate package reference cu cua project, khong co loi compile/unit test.

## Huong dan doc loi HTTP 400 khi test API

### Y nghia

Khi Postman/Newman hien `Status Code: 400 Bad Request`, day la request bi server tu choi truoc hoac trong buoc validate. Khong ket luan loi da fix hay chua neu chi nhin tab `Headers`; can mo tab `Response`/`Body` de xem message chi tiet.

### Cac nguyen nhan hay gap voi CBCLOUDV2-9167

| Dieu kien request | Nguyen nhan co the gap | Can kiem tra trong response body |
|---|---|---|
| Co `version = "1"` va co dong `dschitiet[].loaihoadondactrung = 1` | Thieu field bat buoc theo nghi dinh moi | Message `... không được để trống.` |
| Co `version = "1"` va co dong xe dac trung | `ma_tinh`, `ma_xa` thieu hoac khong ton tai trong danh muc host DB | `Mã tỉnh không được để trống.`, `Mã xã không được để trống.`, `Mã tỉnh không tồn tại.`, `Mã xã không tồn tại.` |
| Field int/decimal moi truyen chu/ky tu | Converter nhan sai kieu va tra validate nghiep vu | `... dữ liệu không hợp lệ.` |
| Field so truyen dung kieu so nhung vuot format | Vuot gioi han `trongtai 9,2`, `sochongoi 4 so`, `chatluongtaisan 4,2` | `... không đúng định dạng.` |
| JSON sai format/model binding loi ngoai cac field moi | Request bi reject truoc khi vao logic nghiep vu | Response body cua framework/API gateway |

### Rule phan biet message

| Truong hop | Message dung |
|---|---|
| Sai kieu du lieu, vi du `sochongoi = "abc"` | `Số người cho phép chở dữ liệu không hợp lệ.` |
| Dung kieu so nhung vuot 4 chu so, vi du `sochongoi = 10000` | `Số người cho phép chở không đúng định dạng.` |
| Sai kieu du lieu, vi du `chatluongtaisan = "abc"` | `Chất lượng tài sản % dữ liệu không hợp lệ.` |
| Dung kieu so nhung vuot `4,2`, vi du `chatluongtaisan = 123.45` | `Chất lượng tài sản % không đúng định dạng.` |

### Neu request khong truyen `version`

Neu request khong truyen `version`, `version = null`, `version = ""` hoac khac `"1"`:

- Khong bat validate/map/render XML theo bo field nghi dinh moi.
- Khong bat buoc `ma_tinh`, `ma_xa` theo rule moi.
- Logic cu cua `loaihoadondactrung` van giu nguyen.
- Neu van gap HTTP 400 thi can doc response body, vi loi co the den tu validate cu hoac JSON/model binding khac, khong phai rule moi CBCLOUDV2-9167.

### Cach tester can chup/gui loi

Khi bao loi 400, can gui kem:

- Tab `Response`/`Body`, khong chi chup tab `Headers`.
- Request body da gui, toi thieu gom `version`, `ma_tinh`, `ma_xa`, va dong `dschitiet[]` bi loi.
- Ten API dang test: `GuiHoadonGoc`, `GuiVaKyHoadonGocHSM`, `GuiHoadonThayThe`, `GuiVaKyHoaDonThayTheHSM`, `GuiHoadonDieuChinh`, `GuiVaKyHoaDonDieuChinhHSM`, hoac `GuiHoaDonVaKyMTT`.


