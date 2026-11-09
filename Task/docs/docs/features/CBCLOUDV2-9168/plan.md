# CBCLOUDV2-9168 Plan Docs - Import hang hoa dac trung xe

## Summary

Task CBCLOUDV2-9168 cap nhat import Excel de ho tro bo field hang hoa dac trung xe trong file import.

- Chi fix 3 loai import theo file mau da cung cap:
  - HD GTGT.
  - HD ban hang.
  - HD ve xe.
- Khong fix phieu xuat kho, chung tu, thuoc, nuoc, dien trong task nay.
- Chi ap dung logic moi cho file import moi co du cot hang hoa dac trung.
- File cu khong co cac cot moi van import binh thuong theo luong hien tai.
- Rule bat validate/map moi chi bat khi dong hang co dong thoi:
  - `tinhchat = 4`
  - `loaihoadondactrung = 1`
- Khong dung `version`.
- Khong thay doi DB trong task nay; cac cot trong `vs_hd_chitiet_morong` da co san.
- XML khong can sua rieng trong task import neu he thong da sinh XML tu du lieu luu trong DB. Task import chi can doc, validate va luu dung du lieu vao bang chi tiet mo rong.

## Pham vi import can cap nhat

### BE import truc tiep

Can cap nhat luong doc/validate/luu import tai:

- Source: `\XBill\Cloud\invoicecore`
- Helper chinh:
  - `aspnet-core\src\hddt\HDDT.Application\Commons\HoaDon\ExcelHelpers\NhapDSHoaDonExcelHelper.cs`
- Cac luong import can cap nhat:
  - GTGT: `ImportExcelFile(...)`
  - Ban hang: `ImportExcelFile_BH(...)`
  - Ve xe: `ImportExcelFile_VeXe(...)`
- Muc tieu:
  - Nhan dien file cu/file moi theo header.
  - Chi doc/validate/map cac field moi khi file moi co cot moi va dong hang thoa `tinhchat = 4`, `loaihoadondactrung = 1`.
  - File cu khong co cot moi van import binh thuong.

### Service nen xu ly import lon hon 50 dong

Can cap nhat dong bo tai:

- Source: `\XBill\Cloud\svinvoicesendemail`
- Worker: `AppServiceImportBillHost`
- Router chinh:
  - `AppServiceImportBillHost\AppService\Process.cs`
- Cac helper import can cap nhat:
  - `NhapDSHoaDonExcelHelper` cho hoa don GTGT.
  - `BanHang_ExcelHelper` cho hoa don ban hang.
  - `ImportVeXeHelper` cho hoa don ve xe.
- Ngoai pham vi task nay:
  - `PhieuXuatKhoExcelHelper`.
  - `ExcelHelperChungTu`.
  - Cac import thuoc, nuoc, dien neu tach helper rieng.

### Trang thai entity/model theo tung service

| Service | Path | Trang thai hien tai | Can lam trong task import |
|---|---|---|---|
| BE import truc tiep | `\XBill\Cloud\invoicecore` | Entity DB da co `HD_ChiTiet_MoRong` voi 16 field moi, da co `HD_HoaDon_MoRong.Ma_Tinh`, `HD_HoaDon_MoRong.Ma_Xa`; Dapper repository chi tiet da dung cot `ttlvhcsuat` sau khi sua. | Them field vao model row import neu chua co, vi `HoaDonRow` import hien chua co `ma_tinh`, `ma_xa` va 16 field request moi; map tu row import vao entity da co. |
| Worker import nen > 50 dong | `\XBill\Cloud\svinvoicesendemail` | Chua co du entity/model/repository cho 16 field moi va `ma_tinh`, `ma_xa`. | Them property vao `HoaDonRow`, `HD_ChiTiet_MoRong`, `HD_HoaDon_MoRong`; them cot vao repository insert/update; map/validate dong bo voi `invoicecore`. |

Chi ghi nhan trang thai entity cho import. Task nay khong sua API ky, khong sua XML rieng, khong them DB migration.

## File mau da kiem tra

### 1. HD GTGT

- File: `\XBill\File\Cloud\Hoadon_FileMau_GTGT (1).xlsx`
- Sheet: `file mẫu`
- So cot: 73
- Cac cot dieu kien va hang hoa dac trung:

| Cot Excel | Header | Field logic |
|---:|---|---|
| 19 | `Tính chất hàng hóa` | `tinhchat` / `tinhchathh` |
| 38 | `Loại hàng hóa đặc trưng` | `loaihoadondactrung` / `loaidactrung` |
| 39 | `Số khung` | `sokhung` |
| 40 | `Số máy` | `somay` |
| 41 | `Biển kiểm soát` | field cu `bienkiemsoat` |
| 56 | `Mã tỉnh` | `ma_tinh` |
| 57 | `Mã xã` | `ma_xa` |
| 58 | `Loại tài sản` | `loaitaisan` |
| 59 | `Tình trạng tài sản` | `tinhtrangtaisan` |
| 60 | `Xuất xứ` | `xuatxu` |
| 61 | `Số GCN chất lượng ATKT` | `sogiaychungnhanatkt` |
| 62 | `Số seri phiếu KTCL xuất xưởng` | `soseripktcl` |
| 63 | `Mã nước sản xuất` | `ma_nuocsx` |
| 64 | `Tên loại tài sản đăng ký` | `ten_loaitaisan` |
| 65 | `Năm sản xuất` | `namsanxuat` |
| 66 | `Tên thương mại` | `ten_thuongmai` |
| 67 | `Tên nhãn hiệu` | `ten_nhanhieu` |
| 68 | `Kiểu loại xe` | `kieuloaixe` |
| 69 | `Thể tích làm việc hoặc Công suất` | `thetich_congsuat` |
| 70 | `Trọng tải` | `trongtai` |
| 71 | `Số người cho phép chở` | `sochongoi` |
| 72 | `Chất lượng tài sản %` | `chatluongtaisan` |
| 73 | `Số biển kiểm soát` | `sobienkiemsoat` |

### 2. HD ve xe

- File: `\XBill\File\Cloud\Hoadon_FileMau_Vexe.xlsx`
- Sheet: `KL`
- So cot moi du kien: 62
- Cac cot dieu kien, cot dac thu cu va hang hoa dac trung:

| Cot Excel | Header | Field logic |
|---:|---|---|
| 16 | `Tính chất hàng hóa` | `tinhchat` / `tinhchathh` |
| 21 | `Biển kiểm soát` | field ve xe hien tai |
| 38 | `Loại hàng hóa đặc trưng` | `loaihoadondactrung` / `loaidactrung` |
| 39 | `Số khung` | `sokhung` |
| 40 | `Số máy` | `somay` |
| 44 | `Số định danh người gửi hàng` | `sodinhdanhng` / `So_Dinh_Danh_Gui_Hang` |
| 45 | `Mã tỉnh` | `ma_tinh` |
| 46 | `Mã xã` | `ma_xa` |
| 47 | `Loại tài sản` | `loaitaisan` |
| 48 | `Tình trạng tài sản` | `tinhtrangtaisan` |
| 49 | `Xuất xứ` | `xuatxu` |
| 50 | `Số GCN chất lượng ATKT` | `sogiaychungnhanatkt` |
| 51 | `Số seri phiếu KTCL xuất xưởng` | `soseripktcl` |
| 52 | `Mã nước sản xuất` | `ma_nuocsx` |
| 53 | `Tên loại tài sản đăng ký` | `ten_loaitaisan` |
| 54 | `Năm sản xuất` | `namsanxuat` |
| 55 | `Tên thương mại` | `ten_thuongmai` |
| 56 | `Tên nhãn hiệu` | `ten_nhanhieu` |
| 57 | `Kiểu loại xe` | `kieuloaixe` |
| 58 | `Thể tích làm việc hoặc Công suất` | `thetich_congsuat` |
| 59 | `Trọng tải` | `trongtai` |
| 60 | `Số người cho phép chở` | `sochongoi` |
| 61 | `Chất lượng tài sản %` | `chatluongtaisan` |
| 62 | `Số biển kiểm soát` | `sobienkiemsoat` |

Luu y: `Số định danh người gửi hàng` la cot dac thu cu cua ve xe, khong duoc dung chung cot voi `Mã tỉnh`. Nhom cot hang hoa dac trung xe phai tang len 1 cot, bat dau tu `Mã tỉnh` cot 45.
### 3. HD ban hang

- File: `\XBill\File\Cloud\HoadonBH_FileMau (7) (1).xlsx`
- Sheet: `file mẫu`
- So cot: 64
- Cac cot dieu kien va hang hoa dac trung:

| Cot Excel | Header | Field logic |
|---:|---|---|
| 20 | `Tính chất hàng hóa` | `tinhchat` / `tinhchathh` |
| 39 | `Loại hàng hóa đặc trưng` | `loaihoadondactrung` / `loaidactrung` |
| 40 | `Số khung` | `sokhung` |
| 41 | `Số máy` | `somay` |
| 42 | `Biển kiểm soát` | field cu `bienkiemsoat` |
| 47 | `Mã tỉnh` | `ma_tinh` |
| 48 | `Mã xã` | `ma_xa` |
| 49 | `Loại tài sản` | `loaitaisan` |
| 50 | `Tình trạng tài sản` | `tinhtrangtaisan` |
| 51 | `Xuất xứ` | `xuatxu` |
| 52 | `Số GCN chất lượng ATKT` | `sogiaychungnhanatkt` |
| 53 | `Số seri phiếu KTCL xuất xưởng` | `soseripktcl` |
| 54 | `Mã nước sản xuất` | `ma_nuocsx` |
| 55 | `Tên loại tài sản đăng ký` | `ten_loaitaisan` |
| 56 | `Năm sản xuất` | `namsanxuat` |
| 57 | `Tên thương mại` | `ten_thuongmai` |
| 58 | `Tên nhãn hiệu` | `ten_nhanhieu` |
| 59 | `Kiểu loại xe` | `kieuloaixe` |
| 60 | `Thể tích làm việc hoặc Công suất` | `thetich_congsuat` |
| 61 | `Trọng tải` | `trongtai` |
| 62 | `Số người cho phép chở` | `sochongoi` |
| 63 | `Chất lượng tài sản %` | `chatluongtaisan` |
| 64 | `Số biển kiểm soát` | `sobienkiemsoat` |

## Dieu kien bat logic moi

### Dieu kien theo dong hang

Chi bat validate/map hang hoa dac trung xe khi dong import thoa man:

| Field import | Gia tri | Ghi chu |
|---|---:|---|
| `tinhchat` / `tinhchathh` | `4` | Dong hang hoa dac trung theo file import |
| `loaihoadondactrung` / `loaidactrung` | `1` | Nhom xe: o to, mo to xe may |

Neu chi co mot trong hai dieu kien thi khong du dieu kien chay logic moi. Can giu luong hien tai, tru cac validate hien tai san co cua import.

### Dieu kien file moi/file cu

- Khong phan biet file cu/file moi theo ten file.
- Khong phan biet file cu/file moi theo so luong cot tuyet doi vi khach hang co the chen/xoa cot tuy bien.
- Phan biet bang header cot Excel sau khi da chuan hoa ten header.
- File moi: header co nhom cot hang hoa dac trung moi.
- File cu: header khong co nhom cot hang hoa dac trung moi.
- Parser phai tim cot theo ten header/cau hinh header, khong phu thuoc tuyet doi vao index co dinh.
- Khi file cu khong co cot moi:
  - Khong doc cac field moi.
  - Khong bat validate cac field moi.
  - Khong bat validate `ma_tinh`, `ma_xa` va cac thong tin bat buoc moi theo phu luc, ke ca khi file cu da co dong `tinhchat = 4` va `loaihoadondactrung = 1`.
  - Khong tao loi thieu cot.
  - Import nhu hien tai.
- Khi file moi co cot moi nhung dong hang khong thoa `tinhchat = 4` va `loaihoadondactrung = 1`:
  - Khong bat validate field moi cho dong do.
  - Chi validate theo luong hien tai.

### Rule nhan dien template moi

Can tao helper dung chung, vi du `DetectHangHoaDacTrungTemplate(headerMap)`.

Nguyen tac:

1. Chuan hoa header truoc khi so sanh:
   - Trim khoang trang.
   - Dua ve lower-case.
   - Bo dau tieng Viet neu template dung ten cot tieng Viet.
   - Bo ky tu dac biet khong can thiet nhu khoang trang kep, dau `_`, dau `-` neu code hien tai da co convention tuong tu.
2. Template moi khi ton tai it nhat mot trong cac cot nhan dien manh:
   - `loaitaisan`
   - `tinhtrangtaisan`
   - `xuatxu`
   - `trongtai`
   - `ma_nuocsx`
   - `ten_loaitaisan`
3. Neu muon chat hon de tranh nham cot trung ten, co the yeu cau co dong thoi:
   - Mot cot dieu kien: `loaihoadondactrung` hoac `loaidactrung`
   - Va it nhat mot cot moi: `loaitaisan`, `tinhtrangtaisan`, `xuatxu`, `trongtai`
4. Khuyen nghi dung rule chat hon:

```csharp
bool hasLoaiDacTrungColumn = HasColumn("loaihoadondactrung") || HasColumn("loaidactrung");
bool hasNewVehicleColumn = HasAnyColumn("loaitaisan", "tinhtrangtaisan", "xuatxu", "trongtai", "ma_nuocsx", "ten_loaitaisan");
bool isNewTemplate = hasLoaiDacTrungColumn && hasNewVehicleColumn;
```

Ly do:

- File cu co the da co `loaidactrung`, `sokhung`, `somay` tu cac rule dac thu cu.
- 16 cot moi moi la dau hieu chac chan hon cua template moi.
- Neu chi dua vao `loaidactrung` thi de kich hoat nham voi file cu da co cot dac thu.
- Vi vay file cu GTGT/Ban hang/Ve xe co dong xe dac thu cu van phai di theo luong cu, khong duoc bao loi `Mã tỉnh không được để trống.` / `Mã xã không được để trống.` do thieu cum cot moi.

### Header alias can ho tro

Can ho tro alias theo ten request/ten cot noi bo hien tai:

| Field logic | Alias header can chap nhan |
|---|---|
| `tinhchat` | `tinhchat`, `tinhchathh`, `tinh_chat`, `tinh_chat_hh` |
| `loaihoadondactrung` | `loaihoadondactrung`, `loaidactrung`, `loai_hanghoa_dactrung`, `loai_hd_dac_trung` |
| `loaitaisan` | `loaitaisan`, `loai_tai_san` |
| `tinhtrangtaisan` | `tinhtrangtaisan`, `tinh_trang_tai_san` |
| `xuatxu` | `xuatxu`, `xuat_xu` |
| `sogiaychungnhanatkt` | `sogiaychungnhanatkt`, `so_giay_chung_nhan_atkt`, `sgcnatkthuat` |
| `soseripktcl` | `soseripktcl`, `so_seri_pktcl`, `sspktclxxuong` |
| `ma_nuocsx` | `ma_nuocsx`, `ma_nuoc_sx`, `mnsxuat` |
| `ten_loaitaisan` | `ten_loaitaisan`, `ten_loai_tai_san`, `tltsdky` |
| `namsanxuat` | `namsanxuat`, `nam_san_xuat`, `nsxuat` |
| `ten_thuongmai` | `ten_thuongmai`, `ten_thuong_mai`, `ttmai` |
| `ten_nhanhieu` | `ten_nhanhieu`, `ten_nhan_hieu`, `tnhieu` |
| `kieuloaixe` | `kieuloaixe`, `kieu_loai_xe`, `klxe` |
| `thetich_congsuat` | `thetich_congsuat`, `the_tich_cong_suat`, `ttlvhcsuat` |
| `trongtai` | `trongtai`, `trong_tai`, `ttai` |
| `sochongoi` | `sochongoi`, `so_cho_ngoi`, `scngoi` |
| `chatluongtaisan` | `chatluongtaisan`, `chat_luong_tai_san`, `cltsan` |
| `sobienkiemsoat` | `sobienkiemsoat`, `so_bien_kiem_soat`, `sbksoat` |

## Danh sach field moi can import

Can bo sung vao model row import, parser Excel, validate va mapping vao `HD_ChiTiet_MoRong`.

| Ten cot/request import | Cot DB `vs_hd_chitiet_morong` | XML tag | Kieu/do dai | Bat buoc khi `tinhchat = 4` va `loaihoadondactrung = 1` |
|---|---|---|---|---|
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
| `chatluongtaisan` | `cltsan` | `CLTSan` | decimal 4,2 | Co neu `tinhtrangtaisan = 1` |
| `sobienkiemsoat` | `sbksoat` | `SBKSoat` | string max 20 | Co neu `tinhtrangtaisan = 1` |

Field da co/da dung lai:

| Ten cot/request import | Cot DB | XML tag | Ghi chu |
|---|---|---|---|
| `sokhung` | `So_Khung` | `SKhung` | Bat buoc khi `tinhchat = 4` va `loaihoadondactrung = 1` |
| `somay` | `So_May` | `SMay` | Bat buoc khi `tinhchat = 4` va `loaihoadondactrung = 1` |
| `loaihoadondactrung` / `loaidactrung` | `Loai_HangHoa_DacTrung` | Theo XML cu | Gia tri `1` kich hoat rule xe |

## Mapping `ma_tinh`, `ma_xa`

`ma_tinh`, `ma_xa` khong nam trong 16 field chi tiet hang hoa dac trung.

Day la thong tin cap hoa don/nguoi mua, render XML trong:

- Path XML: `HDon/DLHDon/NDHDon/NMua`
- `ma_tinh` -> tag `MTinh`
- `ma_xa` -> tag `MXa`

Vi vay khi import phai luu vao bang tong hop mo rong:

| Field Excel | Cot DB | Entity | Dieu kien luu |
|---|---|---|---|
| `Mã tỉnh` | `vs_hd_tonghop_morong.ma_tinh` | `HD_HoaDon_MoRong.Ma_Tinh` | Hoa don co it nhat mot dong `tinhchat = 4` va `loaihoadondactrung = 1` |
| `Mã xã` | `vs_hd_tonghop_morong.ma_xa` | `HD_HoaDon_MoRong.Ma_Xa` | Hoa don co it nhat mot dong `tinhchat = 4` va `loaihoadondactrung = 1` |

Nguon lay khi import Excel:

- Do file Excel gom nhieu dong chi tiet trong cung mot hoa don, `ma_tinh`, `ma_xa` chi luu mot lan theo hoa don.
- Uu tien lay `ma_tinh`, `ma_xa` tu dong co `Ma hoa don` cua hoa don do.
- Neu dong co `Ma hoa don` de trong 2 cot nay nhung dong chi tiet dac trung xe co gia tri, co the fallback lay gia tri dau tien khac rong trong cac dong cung hoa don.
- Neu mot hoa don co nhieu dong cung truyen `ma_tinh`, `ma_xa` khac nhau thi bao loi du lieu khong thong nhat, khong nen tu chon ngau nhien.

Phan code can sua rieng cho import:

- Them `ma_tinh`, `ma_xa` vao `HoaDonRow` hoac model row tuong ung.
- Them parser header cho `Mã tỉnh`, `Mã xã` theo dung vi tri 3 file mau da gui.
- Khi tao `HD_HoaDon_MoRong` trong 3 helper GTGT/BH/Ve xe, map them:

```csharp
hd.HD_HoaDon_MoRong ??= new HD_HoaDon_MoRong();
hd.HD_HoaDon_MoRong.Ma_Tinh = hdrow.ma_tinh;
hd.HD_HoaDon_MoRong.Ma_Xa = hdrow.ma_xa;
```

- Cap nhat entity/repository cua `svinvoicesendemail` neu chua co property/cau SQL cho 2 cot nay:
  - `AppServiceImportBillHost\AppService\Domain\HD_HoaDon_MoRong.cs`
  - `AppServiceImportBillHost\AppService\Repositories\HD_HoaDon_MoRongRepository.cs`
  - Them `ma_tinh`, `ma_xa` vao cau `INSERT`, `AddRange` neu dung, va `UPDATE` neu co cap nhat lai mo rong.

## Rule validate dung chung cho GTGT, ban hang, ve xe

Rule nghiep vu ap dung giong nhau cho ca 3 loai import:

- HD GTGT.
- HD ban hang.
- HD ve xe.

Khac nhau duy nhat giua 3 loai import la vi tri cot trong file Excel mau. Parser can truyen dung index cot vao helper chung, con validate/map thi dung chung mot bo rule ben duoi.

Dieu kien kich hoat rule moi:

- Chi ap dung voi file moi co nhom cot hang hoa dac trung.
- Chi validate dong chi tiet thoa dong thoi:
  - `tinhchat = 4`.
  - `loaihoadondactrung = 1` hoac field noi bo tuong ung `loaidactrung = 1`.
- File cu khong co nhom cot moi van import binh thuong, khong bat validate cac field moi.
- File moi co nhom cot moi nhung dong khong thoa dieu kien tren thi giu luong validate/map hien tai, khong bat cac field hang hoa dac trung xe.

## Cap nhat danh gia - tach validate cap hoa don va cap dong

Qua ra soat luong import nhieu dong chi tiet trong cung mot hoa don, can tach ro 2 nhom validate:

1. Validate cap dong chi tiet:
   - Ap dung theo tung dong Excel.
   - Chi gom cac field hang hoa dac trung xe nam tren dong hang.
   - Chi chay khi dong do thoa `tinhchat = 4` va `loaihoadondactrung = 1`.
   - Neu dong chi tiet con khong co thong tin nguoi mua thi khong duoc bao loi cac field cap hoa don.

2. Validate cap hoa don/nguoi mua:
   - Ap dung mot lan cho hoa don chinh, khong validate lap theo tung dong chi tiet con.
   - Chi chay khi hoa don co it nhat mot dong thoa `tinhchat = 4` va `loaihoadondactrung = 1`.
   - Lay du lieu tu dong hoa don chinh/dong dau cua nhom hoa don, noi dang doc cac thong tin `mahoadon`, `nguoimuahang`, `diachi`, `sdt`, `email`, `ma_tinh`, `ma_xa`.
   - Cac dong chi tiet con cua cung hoa don neu de trong thong tin nguoi mua thi van import hop le, mien la dong hoa don chinh da co du thong tin bat buoc.

Ly do can sua:

- File import mot hoa don co nhieu dong chi tiet thuong chi dien thong tin nguoi mua o dong hoa don chinh.
- Neu validate `nguoimuahang`, `diachi`, `ma_tinh`, `ma_xa`, `sdt`, `email` trong helper validate tung dong xe thi cac dong chi tiet con se bi bao loi sai va loi bi lap theo `Dòng n`.
- `ma_tinh`, `ma_xa` la field cap hoa don luu vao `HD_HoaDon_MoRong`/`vs_hd_tonghop_morong`, khong phai field rieng cua tung dong `HD_ChiTiet_MoRong`.

Phan can sua trong code:

| Service | File | Viec can sua |
|---|---|---|
| BE import truc tiep | `\XBill\Cloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\Commons\HoaDon\ExcelHelpers\NhapDSHoaDonExcelHelper.cs` | Tach validate thong tin nguoi mua/ma tinh/ma xa ra khoi `ValidateVehicleAssetImportFields(...)`; chi goi validate cap hoa don cho dong hoa don chinh |
| Worker import nen | `\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Models\VehicleAssetImportHelper.cs` | Tach validate thong tin nguoi mua/ma tinh/ma xa ra khoi `ValidateFields(...)`; helper validate dong chi tiet chi con validate field xe |
| Worker GTGT | `\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Service\NhapDSHoaDonExcelHelper.cs` | Goi validate cap hoa don o dong hoa don chinh, truyen catalog tinh/xa, khong goi lap tren dong chi tiet con |
| Worker Ban hang | `\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Service\BanHang_ExcelHelper.cs` | Dong bo cach goi validate cap hoa don nhu GTGT |
| Worker Ve xe | `\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Service\ImportVeXeHelper.cs` | Dong bo cach goi validate cap hoa don nhu GTGT |

Step sua chi tiet:

1. Sua helper dung chung import hang hoa dac trung xe.
   - File BE: `\XBill\Cloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\Commons\HoaDon\ExcelHelpers\NhapDSHoaDonExcelHelper.cs`.
   - File worker: `\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Models\VehicleAssetImportHelper.cs`.
   - Doi `ReadVehicleAssetImportFields(...)` / `ReadFields(...)` de chi doc field Excel va goi validate cap dong chi tiet.
   - Tach `ValidateVehicleAssetImportFields(...)` / `ValidateFields(...)` thanh 2 nhom:
     - `ValidateVehicleAssetDetailFields(...)`: chi validate 16 field xe theo tung dong.
     - `ValidateVehicleAssetInvoiceFields(...)`: chi validate thong tin nguoi mua/dia ban cap hoa don.
   - Khong de `ValidateVehicleAssetDetailFields(...)` check cac field `nguoimuahang`, `mst`, `diachi`, `ma_tinh`, `ma_xa`, `sdt`, `email`.

2. Sua dieu kien validate cap dong chi tiet.
   - Van giu dieu kien file moi co cot moi.
   - Van giu dieu kien dong chi tiet `tinhchat = 4` va `loaihoadondactrung = 1`.
   - Moi dong xe dac trung tu validate rieng 16 field cua chinh dong do.
   - Neu dong chi tiet con khong co thong tin nguoi mua/dia ban thi khong bao loi field cap hoa don.

3. Sua validate cap hoa don/nguoi mua.
   - Chi goi khi hoa don co it nhat mot dong xe dac trung trong nhom dong cua cung hoa don.
   - Chi lay du lieu tu dong hoa don chinh/dong dau nhom hoa don.
   - Validate bat buoc va do dai:
     - `nguoimuahang`/`Tên`.
     - `diachi`/`Địa chỉ`.
     - `ma_tinh`/`Mã tỉnh`.
     - `ma_xa`/`Mã xã`.
     - `sdt`/`Số điện thoại`.
     - `email`/`Địa chỉ thư điện tử`.
     - `mst` chi validate do dai neu co truyen.
   - Validate ton tai:
     - `ma_tinh` ton tai trong host catalog `vs_danhmuc_tinh_thanh`.
     - `ma_xa` ton tai trong host catalog `vs_danhmuc_xa_phuong` va thuoc dung `ma_tinh`.

4. Sua luong import GTGT trong BE va worker.
   - BE: trong flow import GTGT, sau khi doc cac row cua mot hoa don, xac dinh nhom hoa don co dong xe dac trung hay khong.
   - Worker: trong `NhapDSHoaDonExcelHelper.cs`, khong de `VehicleAssetImportHelper.ReadFields(...)` tra loi cap hoa don tren tung row.
   - Goi `ValidateVehicleAssetInvoiceFields(...)` mot lan tren row hoa don chinh neu nhom hoa don co xe dac trung.
   - Khi luu `HD_HoaDon_MoRong`, lay `ma_tinh`, `ma_xa` tu row hoa don chinh.

5. Sua luong import Ban hang trong BE va worker.
   - Ap dung cung pattern nhu GTGT.
   - Luu y cot Excel khac GTGT, nhung helper validate dung chung.
   - Duy tri cac validate hien tai cua Ban hang ngoai scope task.

6. Sua luong import Ve xe trong BE va worker.
   - Ap dung cung pattern nhu GTGT.
   - Luu y cot Excel cua Ve xe khac GTGT/Ban hang.
   - Khong lam anh huong logic dac thu hien co cua Ve xe ngoai nhom hang hoa dac trung xe.

7. Sua mapping luu du lieu mo rong.
   - `HD_HoaDon_MoRong.Ma_Tinh`, `HD_HoaDon_MoRong.Ma_Xa`: chi map tu row hoa don chinh khi hoa don co xe dac trung.
   - `HD_ChiTiet_MoRong`: map 16 field xe theo tung dong chi tiet xe dac trung.
   - Khong map `ma_tinh`, `ma_xa` vao `HD_ChiTiet_MoRong`.

8. Cap nhat unit test/regression test.
   - Them test helper cho mot hoa don nhieu dong: row chinh co thong tin nguoi mua/dia ban, row con trong cac field nay thi khong loi.
   - Them test row con thieu field xe van loi theo row con.
   - Them test row chinh thieu `ma_tinh`/`ma_xa` chi loi mot lan.
   - Chay lai test helper worker va build BE neu co the.

Nhom field chi validate cap hoa don/nguoi mua:

| Field import | XML tag | Scope validate | Rule |
|---|---|---|---|
| `nguoimuahang` hoac field ten nguoi mua tuong ung | `NMua/Ten` | Cap hoa don | Bat buoc khi hoa don co dong xe dac trung; neu khong co thong tin nguoi mua thi truyen `Ban cho nguoi tieu dung` |
| `mst` | `NMua/MST` | Cap hoa don | Validate do dai neu co truyen |
| `diachi` | `NMua/DChi` | Cap hoa don | Bat buoc |
| `ma_tinh` | `NMua/MTinh` | Cap hoa don | Bat buoc, max 3, ton tai trong host catalog |
| `ma_xa` | `NMua/MXa` | Cap hoa don | Bat buoc, max 8, ton tai va thuoc dung `ma_tinh` trong host catalog |
| `sdt` hoac field so dien thoai nguoi mua tuong ung | `NMua/SDThoai` | Cap hoa don | Bat buoc, max 20 |
| `email` | `NMua/DCTDTu` | Cap hoa don | Bat buoc, max 50 |

Nhom field chi validate cap dong chi tiet:

- `sokhung`, `somay`, `loaitaisan`, `tinhtrangtaisan`, `xuatxu`, `sogiaychungnhanatkt`, `soseripktcl`, `ma_nuocsx`, `ten_loaitaisan`, `namsanxuat`, `ten_thuongmai`, `ten_nhanhieu`, `kieuloaixe`, `thetich_congsuat`, `trongtai`, `sochongoi`, `chatluongtaisan`, `sobienkiemsoat`.

Acceptance bo sung:

- Mot hoa don co nhieu dong chi tiet, chi dong hoa don chinh co thong tin nguoi mua va dia ban: import khong bao loi thieu `Tên`, `Địa chỉ`, `Mã tỉnh`, `Mã xã`, `Số điện thoại`, `Địa chỉ thư điện tử` o cac dong chi tiet con.
- Neu dong hoa don chinh thieu thong tin cap hoa don bat buoc va hoa don co dong xe dac trung: chi bao loi mot lan theo dong hoa don chinh.
- 16 field xe van validate theo tung dong xe dac trung; dong xe nao thieu/sai field thi bao dung dong do.

Field hang hoa dac trung bat buoc khi kich hoat rule:

| Field import | XML tag | Do dai/kieu | Rule |
|---|---|---|---|
| `sokhung` | `SKhung` | string max 50 | Bat buoc |
| `somay` | `SMay` | string max 50 | Bat buoc |
| `loaitaisan` | `LTSan` | int 1 | Bat buoc, gia tri `1` hoac `2` |
| `tinhtrangtaisan` | `TTTSan` | int 1 | Bat buoc, gia tri `0` hoac `1` |
| `xuatxu` | `XXu` | int 1 | Bat buoc, gia tri `0` hoac `1` |
| `sogiaychungnhanatkt` | `SGCNATKThuat` | string max 200 | Bat buoc neu `xuatxu = 1` |
| `soseripktcl` | `SSPKTCLXXuong` | string max 200 | Bat buoc neu `xuatxu = 0` |
| `ma_nuocsx` | `MNSXuat` | string max 2 | Bat buoc |
| `ten_loaitaisan` | `TLTSDKy` | string max 200 | Bat buoc |
| `namsanxuat` | `NSXuat` | int 4 | Bat buoc |
| `ten_thuongmai` | `TTMai` | string max 300 | Bat buoc |
| `ten_nhanhieu` | `TNHieu` | string max 200 | Bat buoc |
| `kieuloaixe` | `KLXe` | string max 50 | Bat buoc |
| `thetich_congsuat` | `TTLVHCSuat` | string max 10 | Bat buoc |
| `trongtai` | `TTai` | decimal 9,2 | Bat buoc |
| `sochongoi` | `SCNgoi` | int 4 | Bat buoc |
| `chatluongtaisan` | `CLTSan` | decimal 4,2 | Bat buoc neu `tinhtrangtaisan = 1` |
| `sobienkiemsoat` | `SBKSoat` | string max 20 | Bat buoc neu `tinhtrangtaisan = 1` |

Thong tin nguoi mua/nguoi dang ky can validate cap hoa don khi kich hoat rule:

Luu y: nhom field nay chi validate mot lan theo dong hoa don chinh, khong validate lap theo tung dong chi tiet con.

| Field import hien co | XML tag | Do dai | Rule |
|---|---|---:|---|
| `nguoimuahang` hoac field ten nguoi mua tuong ung | `NMua/Ten` | 400 | Bat buoc. Neu khong co thong tin nguoi mua thi truyen gia tri theo quy dinh: `Ban cho nguoi tieu dung` |
| `mst` | `NMua/MST` | 14 | Bat buoc neu co MST nguoi dang ky |
| `diachi` | `NMua/DChi` | 400 | Bat buoc |
| `ma_tinh` | `NMua/MTinh` | 3 | Bat buoc |
| `ma_xa` | `NMua/MXa` | 8 | Bat buoc |
| `sdt` hoac field so dien thoai nguoi mua tuong ung | `NMua/SDThoai` | 20 | Bat buoc |
| `email` | `NMua/DCTDTu` | 50 | Bat buoc |

Ghi chu:

- Khong them validate ngoai cac field tren cho dong khong thoa dieu kien `tinhchat = 4` va `loaihoadondactrung = 1`.
- Ten thong bao validate phai dung ten chi tieu trong file quy dinh va tra ve tieng Viet co dau.
- `TTLVHCSuat` la ten tag/cot dung, khong dung `TTLVHCS`.
- `sspktclxxuong` la ten cot DB dung, khong dung `sspktcclxxuong`.
- `ma_tinh` phai ton tai trong bang danh muc `vs_danhmuc_tinh_thanh`.
- `ma_xa` phai ton tai trong bang danh muc `vs_danhmuc_xa_phuong` va thuoc dung `ma_tinh` da truyen.
- Hai bang danh muc `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` nam o host DB, khong nam o tenant DB.
- Neu khong ton tai thi tra message validate: `Mã tỉnh không tồn tại.` hoac `Mã xã không tồn tại.`

Xu ly loi query danh muc dia ban:

- BE import truc tiep `\XBill\Cloud\invoicecore`: phan load danh muc `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` phai chuyen ve host tenant/host DB, boc `try/catch`, query DB chi lay raw column roi moi normalize/map trong memory de tranh loi EF Core khong translate duoc helper C#.
- Worker import nen `\XBill\Cloud\svinvoicesendemail`: load danh muc dia ban bang host/default connection trong `Process.cs`, sau do truyen catalog vao helper import GTGT/BH/Ve xe; khong query 2 bang danh muc nay bang tenant connection.
- Worker repository load danh muc dia ban can boc `try/catch` quanh query Dapper.
- Neu query danh muc dia ban loi thi ghi log ngan gon, vi du `Import validate location error` hoac `Import validate địa bàn lỗi`, kem message/exception de tra cuu.
- Khi query danh muc dia ban loi, khong de import crash boi exception DB; catalog fallback rong va cac dong co `ma_tinh`, `ma_xa` se bi validate `Mã tỉnh không tồn tại.` / `Mã xã không tồn tại.` theo rule ton tai danh muc.

## Phan can sua them - validate do dai/dinh dang so

Can bo sung dong bo cho ca 2 luong import:

- BE import truc tiep: `\XBill\Cloud\invoicecore`.
- Worker import nen file > 50 dong: `\XBill\Cloud\svinvoicesendemail`.

Chi validate cac rule duoi day khi thoa dung dieu kien task import:

- File import la file moi co nhom cot hang hoa dac trung.
- Dong chi tiet co `tinhchat = 4`.
- Dong chi tiet co `loaihoadondactrung = 1` hoac field noi bo tuong ung `loaidactrung = 1`.

Neu file cu khong co nhom cot moi, hoac dong khong thoa dieu kien tren, khong bat cac validate nay.

| Field import | DB/XML | Rule can bo sung | Message validate |
|---|---|---|---|
| `trongtai` | `ttai` / `TTai` | Bat buoc va dung decimal toi da `9,2` | `Trọng tải dữ liệu không hợp lệ.` |
| `sochongoi` | `scngoi` / `SCNgoi` | Bat buoc va la so nguyen toi da 4 chu so | `Số người cho phép chở dữ liệu không hợp lệ.` |
| `chatluongtaisan` | `cltsan` / `CLTSan` | Bat buoc khi `tinhtrangtaisan = 1`; neu co truyen thi luon validate decimal toi da `4,2` | `Chất lượng tài sản % dữ liệu không hợp lệ.` |

Chi tiet code can sua them:

1. Trong `invoicecore`, helper import chung hang hoa dac trung xe can co validate:
   - `trongtai` vuot `decimal 9,2` thi tra `Trọng tải dữ liệu không hợp lệ.`
   - `sochongoi` < 0 hoac > 9999 thi tra `Số người cho phép chở dữ liệu không hợp lệ.`
   - `chatluongtaisan` vuot `decimal 4,2` khi co truyen gia tri thi tra `Chất lượng tài sản % dữ liệu không hợp lệ.`
   - `chatluongtaisan` van chi bat buoc khi `tinhtrangtaisan = 1`; voi `tinhtrangtaisan = 0`, neu khong truyen thi hop le.
2. Trong `svinvoicesendemail`, `VehicleAssetImportHelper.ValidateFields(...)` phai dong bo y het 3 validate tren de file > 50 dong tra ket qua giong BE import truc tiep.
3. Them helper format decimal dung chung neu chua co:
   - Dem phan nguyen va phan thap phan bang `CultureInfo.InvariantCulture`.
   - `decimal 9,2` nghia la toi da 7 chu so phan nguyen va 2 chu so thap phan.
   - `decimal 4,2` nghia la toi da 2 chu so phan nguyen va 2 chu so thap phan.
4. Them unit test rieng cho case so dung kieu nhung vuot format:
   - `trongtai = 12345678.12` -> loi `Trọng tải dữ liệu không hợp lệ.`
   - `sochongoi = 10000` -> loi `Số người cho phép chở dữ liệu không hợp lệ.`
   - `chatluongtaisan = 123.45` va `tinhtrangtaisan = 1` -> loi `Chất lượng tài sản % dữ liệu không hợp lệ.`
   - `chatluongtaisan = 123.45` va `tinhtrangtaisan = 0` -> loi `Chất lượng tài sản % dữ liệu không hợp lệ.` neu file van truyen gia tri.

## Ket qua doi chieu file testcase import

Da doi chieu 3 sheet trong file testcase:

| Sheet | Tong case | Uoc tinh da dat sau fix | Con thieu |
|---|---:|---:|---:|
| `Import GTGT` | 412 | 412 | 0 |
| `Import BH` | 412 | 412 | 0 |
| `Import KHAC` / Ve xe | 412 | 412 | 0 |

Phan da bo sung nam o nhanh import nen `> 50` cua moi sheet:

| Nhanh | Case can bo sung code |
|---|---|
| HD thuong `> 50` | `TTai` vuot `decimal 9,2`; `SCNgoi` vuot 4 chu so; `CLTSan` vuot `decimal 4,2` |
| HD MTT `> 50` | `TTai` vuot `decimal 9,2`; `SCNgoi` vuot 4 chu so; `CLTSan` vuot `decimal 4,2` |

Ly do:

- BE import truc tiep `<= 50` da co helper validate format so.
- Worker import nen `svinvoicesendemail` da duoc bo sung validate format so cho `trongtai`, `sochongoi`, `chatluongtaisan`.
- Ket qua file `<= 50` / `> 50` da dong bo theo rule validate format so.

## Gia tri hop le

| Field | Gia tri hop le |
|---|---|
| `loaitaisan` | `1` = O to, `2` = Mo to xe may |
| `tinhtrangtaisan` | `0` = Chua qua su dung, `1` = Da qua su dung |
| `xuatxu` | `0` = Lap rap/san xuat trong nuoc, `1` = Nhap khau |

Rule dieu kien:

- `sogiaychungnhanatkt` bat buoc khi `xuatxu = 1`.
- `soseripktcl` bat buoc khi `xuatxu = 0`.
- `chatluongtaisan`, `sobienkiemsoat` bat buoc khi `tinhtrangtaisan = 1`.
- `ten_thuongmai`, `ten_nhanhieu`, `thetich_congsuat` bat buoc khi dong kich hoat rule hang hoa dac trung xe.
- `nguoimuahang`, `diachi`, `ma_tinh`, `ma_xa`, `sdt`, `email` bat buoc khi hoa don co dong kich hoat rule hang hoa dac trung xe; `mst` bat buoc neu co MST nguoi dang ky.
- `ma_tinh`, `ma_xa` phai validate ton tai theo danh muc dia ban hanh chinh truoc khi cho import thanh cong.

## Chi tiet can lam theo tung loai import

### 1. Import HD GTGT

Nhan dien:

- `TypeHd = 1`
- Worker vao `NhapDSHoaDonExcelHelper.ImportExcelFile(...)`
- File mau tham chieu: `\XBill\File\Cloud\Hoadon_FileMau_GTGT (1).xlsx`
- Cot theo file mau da gui:
  - `Tính chất hàng hóa`: cot 19.
  - `Loại hàng hóa đặc trưng`: cot 38.
  - `Số khung`, `Số máy`: cot 39, 40.
  - `Mã tỉnh`, `Mã xã`: cot 56, 57.
  - Nhom 16 field moi: cot 58 den 73.

Can lam:

1. Bo sung mapping header cho cac cot moi theo dung file GTGT da gui.
2. Bo sung 16 field moi vao row model/import DTO noi bo neu chua co.
3. Khi doc tung dong, lay `tinhchat/tinhchathh` va `loaihoadondactrung/loaidactrung`.
4. Neu `tinhchat = 4` va `loaihoadondactrung = 1`:
   - Validate field bat buoc theo bang field moi.
   - Validate do dai theo bang field moi.
   - Validate dinh dang so cho `trongtai`, `sochongoi`, `chatluongtaisan`.
   - Validate gia tri enum cua `loaitaisan`, `tinhtrangtaisan`, `xuatxu`.
   - Map vao `HD_ChiTiet_MoRong`.
5. Neu khong thoa dieu kien:
   - Giu luong validate/map hien tai.
   - Khong bat buoc 16 field moi.
6. Dam bao file cu cua GTGT khong co cot moi van import thanh cong.

### 2. Import HD ban hang

Nhan dien:

- `TypeHd = 2`
- Worker vao `BanHang_ExcelHelper.ImportExcelFile(...)`
- File mau tham chieu: `\XBill\File\Cloud\HoadonBH_FileMau (7) (1).xlsx`
- Cot theo file mau da gui:
  - `Tính chất hàng hóa`: cot 20.
  - `Loại hàng hóa đặc trưng`: cot 39.
  - `Số khung`, `Số máy`: cot 40, 41.
  - `Mã tỉnh`, `Mã xã`: cot 47, 48.
  - Nhom 16 field moi: cot 49 den 64.

Can lam:

1. Bo sung header va parser cho cac cot moi trong file ban hang moi.
2. Bo sung field vao `HoaDonRow`/model noi bo neu dung chung voi helper.
3. Dung cung helper validate hang hoa dac trung xe voi GTGT de tranh lech rule.
4. Validate dinh dang so cho `trongtai`, `sochongoi`, `chatluongtaisan` giong GTGT.
5. Map cac field moi vao `HD_ChiTiet_MoRong` khi dong hang thoa `tinhchat = 4` va `loaihoadondactrung = 1`.
6. File ban hang cu khong co cot moi khong bi loi thieu cot.

### 3. Import HD ve xe

Nhan dien:

- `TypeHd = 6`
- Worker vao `ImportVeXeHelper.ImportExcelFile(...)`
- File mau tham chieu: `\XBill\File\Cloud\Hoadon_FileMau_Vexe.xlsx`
- Cot theo file mau da gui:
  - `Tính chất hàng hóa`: cot 16.
  - `Loại hàng hóa đặc trưng`: cot 38.
  - `Số khung`, `Số máy`: cot 39, 40.
  - `Số định danh người gửi hàng`: cot 44, giu nguyen theo logic ve xe hien tai.
  - `Mã tỉnh`, `Mã xã`: cot 45, 46, bat dau sau cot `Số định danh người gửi hàng`.
  - Nhom 16 field moi: cot 47 den 62.

Can lam:

1. Ra soat vi file ve xe da co cac field dac thu nhu bien so, gio/ngay xuat ben.
2. Bo sung parser cho nhom cot hang hoa dac trung xe theo dung file ve xe da gui.
3. Neu dong hang co `tinhchat = 4` va `loaihoadondactrung = 1`, validate/map 16 field moi nhu rule chung.
4. Validate dinh dang so cho `trongtai`, `sochongoi`, `chatluongtaisan` giong GTGT/Ban hang.
5. Khong thay doi validate hien co cua ve xe neu dong khong thoa dieu kien moi.
6. File ve xe cu import nhu hien tai.

### Ngoai pham vi

Task nay khong sua cac import sau:

- Phieu xuat kho: `PhieuXuatKhoExcelHelper.ImportExcelFile_PhieuXuatKho(...)`.
- Chung tu/hoa don khac: `ExcelHelperChungTu.ImportExcelFile(...)`.
- Thuoc, nuoc, dien neu co helper rieng.
- Cac loai fallback khac khong phai HD ban hang.

## Thay doi ky thuat can lam

### Model row import

Cap nhat `HoaDonRow` hoac model row tuong ung de co cac property:

- `loaitaisan`
- `tinhtrangtaisan`
- `xuatxu`
- `sogiaychungnhanatkt`
- `soseripktcl`
- `ma_nuocsx`
- `ten_loaitaisan`
- `namsanxuat`
- `ten_thuongmai`
- `ten_nhanhieu`
- `kieuloaixe`
- `thetich_congsuat`
- `trongtai`
- `sochongoi`
- `chatluongtaisan`
- `sobienkiemsoat`

Neu code import dung ten DB/entity truc tiep thi map tu ten cot import sang cot DB:

| Import | Entity/DB |
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

### Header/parser Excel

Can them co che:

1. Doc header thanh dictionary ten cot -> index cot.
2. Chay `DetectHangHoaDacTrungTemplate(headerMap)` mot lan sau khi doc header.
3. Header moi co the them cuoi file mau de giam anh huong index cu.
4. Khi header khong ton tai, gia tri field moi de null.
5. Khong throw loi thieu cot moi doi voi file cu.
6. Chuan hoa ten header neu file dang dung tieng Viet co dau/khong dau.
7. Khi `isNewTemplate = false`, bo qua toan bo doc/validate/map 16 field moi.
8. Khi `isNewTemplate = true`, van chi validate/map 16 field moi theo tung dong thoa `tinhchat = 4` va `loaihoadondactrung = 1`.

### Validate

Can tach helper validate dung chung cho cac import:

- Input: row, stt dong, `tinhchat`, `loaihoadondactrung`.
- Neu khong thoa `tinhchat = 4` va `loaihoadondactrung = 1` thi return rong.
- Neu thoa dieu kien thi validate:
  - Bat buoc.
  - Do dai.
  - Kieu so/decimal.
  - Dinh dang so: `trongtai` toi da `decimal 9,2`, `sochongoi` toi da 4 chu so, `chatluongtaisan` toi da `decimal 4,2` khi co truyen gia tri.
  - Gia tri hop le.
  - Dieu kien theo `xuatxu`, `tinhtrangtaisan`.
- Message loi dung tieng Viet co dau va dung ten chi tieu theo file quy dinh.

Thong bao validate dinh dang so can dung:

| Field import | Dieu kien loi | Message |
|---|---|---|
| `trongtai` | Dung kieu so nhung vuot `decimal 9,2` | `Trọng tải dữ liệu không hợp lệ.` |
| `sochongoi` | Dung kieu so nhung vuot 4 chu so | `Số người cho phép chở dữ liệu không hợp lệ.` |
| `chatluongtaisan` | Dung kieu so nhung vuot `decimal 4,2` khi co truyen gia tri | `Chất lượng tài sản % dữ liệu không hợp lệ.` |

### Mapping luu DB

Can cap nhat noi tao `HD_ChiTiet`/`HD_ChiTiet_MoRong` trong tung helper:

1. Neu dong khong thoa dieu kien moi, giu map hien tai.
2. Neu dong thoa dieu kien moi, dam bao co `HD_ChiTiet_MoRong`.
3. Map `loaihoadondactrung`, `sokhung`, `somay` nhu hien tai.
4. Map them 16 field moi vao `HD_ChiTiet_MoRong`.
5. `chatluongtaisan` map decimal vao `cltsan`.

## Test cases can co

### File cu

| Case | Ky vong |
|---|---|
| GTGT file cu khong co cot moi | Import thanh cong nhu hien tai |
| Ban hang file cu khong co cot moi | Import thanh cong nhu hien tai |
| Ve xe file cu khong co cot moi | Import thanh cong nhu hien tai |
| File cu co `loaidactrung`, `sokhung`, `somay` nhung khong co 16 cot moi | Khong coi la template moi, khong bat validate 16 field moi |
| File cu bi chen them cot khac khong lien quan | Van import theo header/index hien tai, khong nham la template moi |

### Nhan dien file moi/file cu

| Case | Ky vong |
|---|---|
| Header co `loaihoadondactrung` va `loaitaisan` | `isNewTemplate = true` |
| Header co `loaidactrung` va `trongtai` | `isNewTemplate = true` |
| Header chi co `loaidactrung` | `isNewTemplate = false` |
| Header chi co `loaitaisan` nhung khong co cot loai dac trung | `isNewTemplate = false` de tranh nham template |
| Header dung alias `loai_hanghoa_dactrung`, `the_tich_cong_suat` | Map dung ve field logic |
| Header tieng Viet co dau/khong dau neu duoc cau hinh alias | Map dung ve field logic |
| File GTGT da gui co cot 19/38 va nhom cot 58-73 | `isNewTemplate = true`, lay dung cot theo header |
| File ban hang da gui co cot 20/39 va nhom cot 49-64 | `isNewTemplate = true`, lay dung cot theo header |
| File ve xe da gui co cot 16/38 va nhom cot 46-61 | `isNewTemplate = true`, lay dung cot theo header |

### File moi hop le

| Case | Ky vong |
|---|---|
| GTGT co dong `tinhchat = 4`, `loaihoadondactrung = 1`, du field | Import thanh cong, luu du `HD_ChiTiet_MoRong` |
| Ban hang co dong `tinhchat = 4`, `loaihoadondactrung = 1`, du field | Import thanh cong, luu du `HD_ChiTiet_MoRong` |
| Ve xe co dong `tinhchat = 4`, `loaihoadondactrung = 1`, du field | Import thanh cong, luu du `HD_ChiTiet_MoRong` |

### File moi khong kich hoat rule

| Case | Ky vong |
|---|---|
| Co cot moi nhung `tinhchat != 4` | Khong bat validate field moi |
| Co cot moi, `tinhchat = 4`, `loaihoadondactrung` rong/khac 1 | Khong bat validate 16 field moi |
| Co cot moi, `loaihoadondactrung = 1`, `tinhchat` rong/khac 4 | Khong bat validate 16 field moi |
| Co cot moi, `loaihoadondactrung = 1`, `tinhchat` rong/khac 4, thieu `sokhung`/`somay` | Khong bat validate `sokhung`/`somay` |
| Dong hoa don chinh khong phai hang hoa dac trung, dong con la `tinhchat = 4` va `loaihoadondactrung = 1` | Validate `ma_tinh`/`ma_xa` theo dong con hang hoa dac trung; cac thong tin nguoi mua van validate mot lan theo dong hoa don chinh |
| Dong hang hoa khong thoa dong thoi `tinhchat = 4` va `loaihoadondactrung = 1` | Khong validate `ma_tinh`/`ma_xa` |

### Validate loi

| Case | Ky vong |
|---|---|
| Thieu `sokhung` | Bao loi So khung khong duoc de trong |
| Thieu `somay` | Bao loi So may khong duoc de trong |
| Thieu tung field bat buoc trong 16 field | Bao loi dung ten chi tieu |
| Thieu `ten_thuongmai` | Bao loi Ten thuong mai khong duoc de trong |
| Thieu `ten_nhanhieu` | Bao loi Ten nhan hieu khong duoc de trong |
| Thieu `thetich_congsuat` | Bao loi The tich lam viec hoac Cong suat khong duoc de trong |
| `xuatxu = 1` thieu `sogiaychungnhanatkt` | Bao loi bat buoc |
| `xuatxu = 0` thieu `soseripktcl` | Bao loi bat buoc |
| `tinhtrangtaisan = 1` thieu `chatluongtaisan` | Bao loi bat buoc |
| `tinhtrangtaisan = 1` thieu `sobienkiemsoat` | Bao loi bat buoc |
| Hoa don co dong kich hoat rule nhung thieu ten nguoi mua/nguoi dang ky | Bao loi Ten khong duoc de trong |
| Hoa don co dong kich hoat rule nhung thieu dia chi nguoi mua/nguoi dang ky | Bao loi Dia chi khong duoc de trong |
| Hoa don co dong kich hoat rule nhung thieu `ma_tinh` hoac `ma_xa` | Bao loi Ma tinh/Ma xa khong duoc de trong |
| Hoa don co dong kich hoat rule, `ma_tinh` khong co trong `vs_danhmuc_tinh_thanh` | Bao loi Ma tinh khong ton tai |
| Hoa don co dong kich hoat rule, `ma_xa` khong co trong `vs_danhmuc_xa_phuong` hoac khong thuoc `ma_tinh` da truyen | Bao loi Ma xa khong ton tai |
| Hoa don co dong kich hoat rule nhung thieu so dien thoai | Bao loi So dien thoai khong duoc de trong |
| Hoa don co dong kich hoat rule nhung thieu dia chi thu dien tu | Bao loi Dia chi thu dien tu khong duoc de trong |
| Vuot do dai thong tin nguoi mua: Ten 400, MST 14, DChi 400, MTinh 3, MXa 8, SDThoai 20, DCTDTu 50 | Bao loi do dai dung max |
| Vuot do dai cac field string | Bao loi do dai dung max |
| `chatluongtaisan` co thap phan | Luu dung decimal |

### Service nen

| Case | Ky vong |
|---|---|
| GTGT tren 50 dong day queue vao `svinvoicesendemail` | Worker xu ly cung rule voi import thuong |
| Ban hang tren 50 dong day queue vao `svinvoicesendemail` | Worker xu ly cung rule voi import thuong |
| Ve xe tren 50 dong day queue vao `svinvoicesendemail` | Worker xu ly cung rule voi import thuong |
| File cu GTGT/BH/Ve xe tren 50 dong | Worker khong bat loi cot moi |
| File moi GTGT/BH/Ve xe tren 50 dong co loi validate | Ho so import that bai/co message loi dung rule |

## Acceptance Criteria

- Co Plan/docs rieng cho CBCLOUDV2-9168.
- Liet ke ro cac loai import bi anh huong: GTGT, ban hang, ve xe.
- Ghi ro ngoai pham vi: phieu xuat kho, chung tu/hoa don khac, thuoc, nuoc, dien.
- Ghi ro dieu kien bat rule moi: `tinhchat = 4` va `loaihoadondactrung = 1`.
- Ghi ro `sokhung`/`somay` cung chi bat buoc khi dong hang thoa dong thoi `tinhchat = 4` va `loaihoadondactrung = 1`, khong chi check rieng `loaihoadondactrung = 1`.
- Ghi ro `ma_tinh`/`ma_xa` lay va validate theo dung dong hang hoa dac trung thoa `tinhchat = 4` va `loaihoadondactrung = 1`; khi luu van map vao `HD_HoaDon_MoRong`/`vs_hd_tonghop_morong`.
- Ghi ro file cu import binh thuong, khong bat loi thieu cot moi.
- Ghi ro co che phan biet file cu/file moi bang header cot Excel, khong dua vao ten file.
- Co helper nhan dien template moi bang dieu kien: co cot loai dac trung va it nhat mot cot hang hoa dac trung moi.
- Ghi ro index cot theo 3 file Excel mau da gui.
- Ghi ro can cap nhat ca `invoicecore` va `svinvoicesendemail`.
- Ghi ro danh sach 16 field moi, mapping DB, validate bat buoc va validate do dai.
- Co danh sach test case cho file cu, file moi hop le, file moi loi validate, va case worker > 50 dong.

## Estimate

| Hang muc | Estimate |
|---|---:|
| Ra soat file mau/header va mapping 3 helper import | 1-2h |
| Cap nhat parser/model/header cho GTGT, ban hang, ve xe | 4-6h |
| Them validate dung rule va message tieng Viet | 3-4h |
| Map luu `HD_ChiTiet_MoRong` trong 3 helper | 3-4h |
| Dong bo service nen `svinvoicesendemail` cho GTGT/BH/Ve xe > 50 dong | 3-5h |
| Unit test/integration test cac case chinh | 4-6h |
| Review file cu/file moi va fix regression | 2-3h |

Tong estimate: 20-30h.

Neu uu tien nhanh va chi test happy path + validate chinh cho 3 file mau: 16-22h.



