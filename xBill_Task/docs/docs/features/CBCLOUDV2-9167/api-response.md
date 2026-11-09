---
feature: CBCLOUDV2-9167
title: "Kết quả trả ra của các API theo source hiện tại"
updated_at: 2026-09-14
source: api-cloud-service
---

# API Response - CBCLOUDV2-9167

## Mục đích

Tách phần `Response va ma ket qua API tich hop` khỏi `plan.md` của CBCLOUDV2-9167 và cập nhật theo source `api-cloud-service` hiện tại. File này mô tả logical response DTO; khi ABP result wrapping được bật, DTO nằm trong thuộc tính `result` của response HTTP.

Phạm vi chi tiết message trong file này là validation NĐ254/CBCLOUDV2-9571 và cách các API/wrapper trả mã tương ứng. Các validation hóa đơn cũ không thuộc NĐ254 vẫn được nối vào cùng `motaketqua`, nhưng không được liệt kê toàn bộ tại đây.

## Bảng mã kết quả theo từng API

Đọc `maketqua` để xác định kết quả, sau đó đọc `motaketqua` để lấy nội dung chi tiết.

### `SendInvoice`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Lỗi phát sinh |
| `01` | Gửi hóa đơn gốc thành công |
| `02` | Không tìm thấy thông tin doanh nghiệp |
| `03` | Đẩy lại hóa đơn sau 30 giây hoặc trùng hồ sơ |
| `04` | Lỗi validate input, bao gồm validation NĐ254 |
| `05` | Hóa đơn đã gửi yêu cầu ký |
| `06` | Lỗi mẫu số, ký hiệu hoặc năm hóa đơn |
| `07` | Doanh nghiệp đã đăng ký TT78 nhưng gửi sai luồng |
| `08` | Doanh nghiệp chưa đăng ký TT78 nhưng gửi sai luồng |

### `GuiHoaDonGoc`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Lỗi phát sinh |
| `01` | Gửi hóa đơn gốc thành công |
| `02` | Không tìm thấy thông tin doanh nghiệp |
| `03` | Đẩy lại hóa đơn sau 30 giây hoặc trùng hồ sơ |
| `04` | Lỗi validate input, bao gồm validation NĐ254 |
| `05` | Hóa đơn đã gửi yêu cầu ký |
| `06` | Lỗi mẫu số, ký hiệu hoặc năm hóa đơn |
| `07` | Doanh nghiệp đã đăng ký TT78 nhưng gửi sai luồng |
| `08` | Doanh nghiệp chưa đăng ký TT78 nhưng gửi sai luồng |

### `GuiHoaDonThayThe`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Lỗi phát sinh |
| `01` | Gửi hóa đơn thay thế thành công |
| `02` | Không tìm thấy thông tin doanh nghiệp |
| `03` | Đẩy lại hóa đơn sau 30 giây hoặc trùng hồ sơ |
| `04` | Không tìm thấy mẫu hóa đơn hoặc lỗi mã cơ quan thuế |
| `05` | Không tìm thấy hóa đơn gốc |
| `06` | Hóa đơn gốc chưa phát hành hoặc lỗi ký hiệu/năm hóa đơn |
| `07` | Không được thay thế hóa đơn này |
| `08` | Lỗi validate input, bao gồm validation NĐ254 |
| `09` | Dung lượng file quá lớn |
| `10` | Nội dung file không đúng định dạng |

### `GuiHoaDonDieuChinh`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Lỗi phát sinh |
| `01` | Gửi hóa đơn điều chỉnh thành công |
| `02` | Không tìm thấy thông tin doanh nghiệp |
| `03` | Đẩy lại hóa đơn sau 30 giây hoặc trùng hồ sơ |
| `04` | Không tìm thấy mẫu hóa đơn hoặc lỗi mã cơ quan thuế |
| `05` | Không tìm thấy hóa đơn gốc hoặc hóa đơn không thuộc doanh nghiệp |
| `06` | Hóa đơn gốc chưa phát hành hoặc lỗi ký hiệu/năm hóa đơn |
| `07` | Không được điều chỉnh hóa đơn này |
| `08` | Lỗi validate input, bao gồm validation NĐ254 |
| `09` | Dung lượng file quá lớn |
| `10` | Nội dung file không đúng định dạng |

### `GuiHoaDonGocXML`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Không đọc được XML hoặc lỗi phát sinh |
| `01` - `08` | Cùng ý nghĩa với mã tương ứng của `GuiHoaDonGoc` |

### `GuiHoaDonThayTheXML`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Không đọc được XML hoặc lỗi phát sinh |
| `01` - `10` | Cùng ý nghĩa với mã tương ứng của `GuiHoaDonThayThe` |

### `GuiHoaDonDieuChinhXML`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Không đọc được XML hoặc lỗi phát sinh |
| `01` - `10` | Cùng ý nghĩa với mã tương ứng của `GuiHoaDonDieuChinh` |

### `GuiVaKyHoadonGocHSM`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Lỗi phát sinh |
| `01` | Gửi và ký hóa đơn thành công |
| `02` | Không tìm thấy thông tin doanh nghiệp |
| `03` | Đẩy lại sau 30 giây hoặc trùng hồ sơ |
| `04` | Lỗi validate input, bao gồm validation NĐ254; dừng trước bước ký |
| `05` | Hóa đơn đã gửi yêu cầu ký |
| `06` | Lỗi mẫu số, ký hiệu hoặc năm hóa đơn |
| `07` | Gửi sai luồng TT78 hoặc bước ký thất bại; đọc `motaketqua` để biết lỗi cụ thể |
| `08` | Gửi sai luồng TT78 hoặc bước ký thất bại; đọc `motaketqua` để biết lỗi cụ thể |
| `09` | Bước ký thất bại; nội dung cụ thể nằm trong `motaketqua` |
| `10` | Bước ký thất bại; nội dung cụ thể nằm trong `motaketqua` |

### `GuiVaKyHoaDonThayTheHSM`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Lỗi phát sinh |
| `01` | Gửi và ký hóa đơn thành công |
| `02` | Không tìm thấy thông tin doanh nghiệp |
| `03` | Đẩy lại sau 30 giây hoặc trùng hồ sơ |
| `04` | Không tìm thấy mẫu hóa đơn hoặc lỗi mã cơ quan thuế |
| `05` | Không tìm thấy hóa đơn gốc |
| `06` | Hóa đơn gốc chưa phát hành hoặc lỗi ký hiệu/năm hóa đơn |
| `07` | Không được thay thế hóa đơn này |
| `08` | Lỗi validate input, bao gồm validation NĐ254; dừng trước bước ký |
| `09` | Dung lượng file quá lớn |
| `10` | Nội dung file không đúng định dạng |
| `11` | Bước ký thất bại; mã lỗi ký gốc là `04` |
| `12` | Bước ký thất bại; mã lỗi ký gốc là `05` |
| `13` | Bước ký thất bại; mã lỗi ký gốc là `06` |
| `14` | Bước ký thất bại; mã lỗi ký gốc là `07` |
| `15` | Bước ký thất bại; mã lỗi ký gốc là `08` |

### `GuiVaKyHoaDonDieuChinhHSM`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Lỗi phát sinh |
| `01` | Gửi và ký hóa đơn thành công |
| `02` | Không tìm thấy thông tin doanh nghiệp |
| `03` | Đẩy lại sau 30 giây hoặc trùng hồ sơ |
| `04` | Lỗi validate input, bao gồm validation NĐ254; dừng trước bước ký |
| `06` | Không tìm thấy mẫu hóa đơn hoặc lỗi mã cơ quan thuế |
| `12` | Không tìm thấy hóa đơn gốc hoặc hóa đơn không thuộc doanh nghiệp |
| `13` | Hóa đơn gốc chưa phát hành hoặc lỗi ký hiệu/năm hóa đơn |
| `14` | Không được điều chỉnh hóa đơn này |
| `07` | Bước ký thất bại; nội dung cụ thể nằm trong `motaketqua` |
| `08` | Bước ký thất bại; nội dung cụ thể nằm trong `motaketqua` |
| `09` | Dung lượng file quá lớn hoặc bước ký thất bại; đọc `motaketqua` để phân biệt |
| `10` | File sai định dạng hoặc bước ký thất bại; đọc `motaketqua` để phân biệt |

Wrapper HSM có đổi mã lỗi giữa các bước. Bảng trên đã ghi **mã cuối cùng mà client nhận được**, không yêu cầu người tích hợp tự quy đổi từ mã nội bộ. Khi một mã có thể đại diện cho nhiều lỗi, `motaketqua` là thông tin quyết định ý nghĩa cụ thể.

### `GuiVaKyHoaDonGocToken`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Lỗi phát sinh |
| `01` | Gửi hóa đơn hoặc gửi và ký hóa đơn thành công |
| `02` | Trùng hồ sơ |
| `03` | Validation lỗi, chữ ký số không hợp lệ hoặc lỗi nghiệp vụ trước khi hoàn tất ký |

### `GuiVaKyHoaDonThayTheToken`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Lỗi phát sinh |
| `01` | Gửi hóa đơn hoặc gửi hóa đơn đã ký thành công |
| `02` | Trùng hồ sơ |
| `03` | Validation lỗi, chữ ký số không hợp lệ hoặc lỗi nghiệp vụ trước khi hoàn tất ký |

### `GuiVaKyHoaDonDieuChinhToken`

| Mã | Ý nghĩa hiện tại |
|---|---|
| `00` | Lỗi phát sinh |
| `01` | Gửi hóa đơn hoặc gửi hóa đơn đã ký thành công |
| `02` | Trùng hồ sơ |
| `03` | Validation lỗi, chữ ký số không hợp lệ hoặc lỗi nghiệp vụ trước khi hoàn tất ký |

### `GuiHoaDonVaKyMTT`

| Mã/kết quả | Ý nghĩa hiện tại |
|---|---|
| `ketqua = true`, thường `maketqua = "01"` | Lưu, cấp số, ký và gửi TCT thành công |
| `ketqua = false`, `maketqua = null` | Lỗi bước lưu hoặc validation; `motaketqua` lấy từ `GuiHoaDonGoc` |
| `ketqua = false`, mã từ `CapSoHoaDon` | Lỗi bước cấp số |
| `ketqua = false`, mã từ `KyHoaDonMTT` | Lỗi bước ký MTT |
| `ketqua = false`, message từ bước gửi TCT | Lỗi gửi TCT |

### `GuiHoaDonVaKyMTT_V2`

| Mã/kết quả | Ý nghĩa hiện tại |
|---|---|
| `ketqua = true`, thường `maketqua = "01"` | Lưu, cấp số, ký và gửi TCT thành công |
| `ketqua = false`, `maketqua = null` | Lỗi bước lưu hoặc validation; `motaketqua` lấy từ `GuiHoaDonGoc` |
| `ketqua = false`, mã từ `CapSoHoaDon` | Lỗi bước cấp số |
| `ketqua = false`, mã từ `KyHoaDonMTT` | Lỗi bước ký MTT |
| `ketqua = false`, message từ bước gửi TCT | Lỗi gửi TCT |

`maketqua = null` ở nhánh validation MTT là hành vi code hiện tại: wrapper chỉ copy `motaketqua`, không copy `maketqua = "04"` từ `GuiHoaDonGoc`.

## Điều kiện validation hiện tại

> Phần này ghi nhận đúng hành vi của source hiện tại. Không dùng danh sách required trong `plan.md` cũ của CBCLOUDV2-9167 để đánh giá thiếu/thừa.

Nhóm validation NĐ254 cho hàng hóa đặc trưng loại 1 hiện được kích hoạt khi:

- `ACTIVE_ND_254 = "1"` theo `ND254FeatureChecker`; và
- request có ít nhất một dòng `dschitiet[].loaihoadondactrung = 1`.

Request `version` vẫn tồn tại để tương thích nhưng không còn điều khiển nhóm validation này.

Thông tin người mua đang bắt buộc trong nhánh trên:

| Request field | XML | Rule hiện tại |
|---|---|---|
| `dnmua_ten` | `<NMua><Ten>` | Bắt buộc; tối đa 400 byte UTF-8 |
| `dnmua_mst` | `<NMua><MST>` | Bắt buộc; nhận MST hoặc CCCD chủ hộ; tối đa 14 byte UTF-8 |
| `dnmua_diachi` | `<NMua><DChi>` | Bắt buộc; tối đa 400 byte UTF-8 |
| `ma_tinh` | `<NMua><MTinh>` | Bắt buộc; tối đa 2 ký tự và phải thuộc danh mục hiện hành |
| `ten_tinh` | `<NMua><TTinh>` | Không required; tối đa 50 ký tự nếu có |
| `ma_xa` | `<NMua><MXa>` | Bắt buộc; tối đa 5 ký tự và phải thuộc tỉnh đã chọn |
| `ten_xa` | `<NMua><TXa>` | Không required; tối đa 50 ký tự nếu có |
| `dnmua_sdt` | `<NMua><SDThoai>` | Bắt buộc; tối đa 20 byte UTF-8 |
| `dnmua_tennguoimua` | `<NMua><HVTNMHang>` | Bắt buộc; tối đa 100 byte UTF-8 |
| `dnmua_email` | `<NMua><DCTDTu>` | Không required trong source hiện tại; tối đa 50 byte nếu có |
| `dnmua_cccd` | `<NMua><CCCDan>` | Không required; tối đa 12 byte nếu có |

Lưu ý: required và giới hạn độ dài của các field người mua trong bảng trên thuộc nhánh hàng hóa đặc trưng loại 1, ngoại trừ kiểm tra `dnmua_cccd` quá 12 byte. Kiểm tra độ dài `dnmua_cccd` đang nằm trong validator chung nên vẫn chạy khi NĐ254 tắt hoặc hóa đơn không có dòng loại 1.

### Message người mua, địa bàn và quốc tịch

| Field/trường hợp | Message chính xác theo source |
|---|---|
| Thiếu `dnmua_ten` | `Tên đơn vị không được để trống.` |
| Thiếu `dnmua_mst` | `MST/CCCD chủ hộ không được để trống.` |
| Thiếu `dnmua_diachi` | `Địa chỉ không được để trống.` |
| Thiếu `ma_tinh` | `Mã tỉnh không được để trống.` |
| Thiếu `ma_xa` | `Mã xã không được để trống.` |
| Thiếu `dnmua_sdt` | `Số điện thoại không được để trống.` |
| Thiếu `dnmua_tennguoimua` | `Họ và tên người mua hàng không được để trống.` |
| `dnmua_ten` quá 400 byte | `Tên đơn vị không được vượt quá 400 ký tự.` |
| `dnmua_mst` quá 14 byte | `MST/CCCD chủ hộ không được vượt quá 14 ký tự.` |
| `dnmua_diachi` quá 400 byte | `Địa chỉ không được vượt quá 400 ký tự.` |
| `ma_tinh` quá 2 ký tự | `Mã tỉnh không được vượt quá 2 ký tự.` |
| `ten_tinh` quá 50 ký tự | `Tên tỉnh không được vượt quá 50 ký tự.` |
| `ma_xa` quá 5 ký tự | `Mã xã không được vượt quá 5 ký tự.` |
| `ten_xa` quá 50 ký tự | `Tên xã không được vượt quá 50 ký tự.` |
| `dnmua_sdt` quá 20 byte | `Số điện thoại không được vượt quá 20 ký tự.` |
| `dnmua_email` quá 50 byte | `Địa chỉ thư điện tử không được vượt quá 50 ký tự.` |
| `dnmua_tennguoimua` quá 100 byte | `Họ và tên người mua hàng không được vượt quá 100 ký tự.` |
| `dnmua_cccd` quá 12 byte | `Căn cước công dân quá dài.` |
| `ma_tinh` không có trong danh mục | `Mã tỉnh không tồn tại.` |
| `ma_xa` không thuộc tỉnh hoặc không có trong danh mục | `Mã xã không tồn tại.` |
| `ma_quoc_tich_nguoi_mua` quá 2 ký tự | `Mã quốc tịch không được vượt quá 2 ký tự.` |
| `quoc_tich_nguoi_mua` quá 50 ký tự | `Quốc tịch không được vượt quá 50 ký tự.` |
| Mã quốc tịch không có trong danh mục | `Mã quốc tịch không tồn tại.` |

Kiểm tra danh mục địa bàn chỉ chạy khi request có đồng thời `ma_tinh` và `ma_xa`. Nếu thiếu một trong hai mã, nhánh hàng hóa đặc trưng loại 1 chỉ trả message required tương ứng, không trả thêm message `không tồn tại` cho cặp địa bàn. Kiểm tra mã quốc tịch và mã nước sản xuất chạy khi mã tương ứng có dữ liệu.

### Chi tiết hàng hóa đặc trưng loại 1

Khi `ACTIVE_ND_254 = "1"` và dòng chi tiết có `loaihoadondactrung = 1`, source hiện tại validate như sau:

| Request field | Rule theo code hiện tại |
|---|---|
| `sokhung` | Luôn bắt buộc; tối đa 50 byte UTF-8 |
| `somay` | Luôn bắt buộc; tối đa 50 byte UTF-8 |
| `loaitaisan` | Luôn bắt buộc; chỉ nhận `1` hoặc `2` |
| `tinhtrangtaisan` | Luôn bắt buộc; chỉ nhận `0` hoặc `1` |
| `xuatxu` | Luôn bắt buộc; chỉ nhận `0` hoặc `1` |
| `sogiaychungnhanatkt` | Bắt buộc khi `xuatxu = 1`; tối đa 255 ký tự |
| `soseripktcl` | Bắt buộc khi `xuatxu = 0`; tối đa 255 ký tự |
| `ma_nuocsx` | Chỉ bắt buộc khi `tinhtrangtaisan = 1`; tối đa 2 byte UTF-8; nếu có thì phải tồn tại trong danh mục quốc tịch |
| `ten_loaitaisan` | Chỉ bắt buộc khi `tinhtrangtaisan = 1`; tối đa 255 ký tự |
| `namsanxuat` | Chỉ bắt buộc khi `tinhtrangtaisan = 1`; nếu có phải trong khoảng `0..9999` |
| `ten_thuongmai` | Chỉ bắt buộc khi `tinhtrangtaisan = 1`; tối đa 400 ký tự |
| `ten_nhanhieu` | Chỉ bắt buộc khi `tinhtrangtaisan = 1`; tối đa 255 ký tự |
| `kieuloaixe` | Chỉ bắt buộc khi `tinhtrangtaisan = 1`; tối đa 50 byte UTF-8 |
| `thetich_congsuat` | Chỉ bắt buộc khi `tinhtrangtaisan = 1`; tối đa 10 byte UTF-8 |
| `trongtai` | Chỉ bắt buộc khi `tinhtrangtaisan = 1`; nếu có phải đúng decimal `(9,2)` |
| `sochongoi` | Chỉ bắt buộc khi `tinhtrangtaisan = 1`; nếu có phải trong khoảng `0..9999` |
| `sobienkiemsoat` | Chỉ bắt buộc khi `tinhtrangtaisan = 1`; tối đa 20 byte UTF-8 |

Điều kiện `tinhtrangtaisan = 1` chỉ quyết định field nào là required. Khi client vẫn gửi dữ liệu, các kiểm tra sai kiểu, sai miền giá trị và vượt độ dài tiếp tục chạy cho dòng `loaihoadondactrung = 1`, kể cả field đó không bắt buộc theo tình trạng tài sản hoặc xuất xứ đã chọn.

### Message required của chi tiết theo code hiện tại

Mỗi message chi tiết có prefix `STT {stt} : `. Giá trị `{stt}` lấy trực tiếp từ `dschitiet[].stt` (field nullable trong cả ba DTO), không phải số thứ tự vòng lặp. Nếu client không gửi `stt`, source hiện trả prefix `STT  : `. Nếu một dòng thiếu nhiều field thì các message được nối liên tiếp trong `motaketqua`.

| Field | Điều kiện phát sinh | Message trả ra |
|---|---|---|
| `sokhung` | Dòng loại 1 và null/rỗng | `STT {stt} : Số khung không được để trống.` |
| `somay` | Dòng loại 1 và null/rỗng | `STT {stt} : Số máy không được để trống.` |
| `loaitaisan` | Dòng loại 1 và không có giá trị | `STT {stt} : Loại tài sản không được để trống.` |
| `tinhtrangtaisan` | Dòng loại 1 và không có giá trị | `STT {stt} : Tình trạng tài sản không được để trống.` |
| `xuatxu` | Dòng loại 1 và không có giá trị | `STT {stt} : Xuất xứ không được để trống.` |
| `sogiaychungnhanatkt` | `xuatxu = 1` và null/rỗng | `STT {stt} : Số Giấy chứng nhận chất lượng an toàn kỹ thuật và bảo vệ môi trường (đối với xe nhập khẩu) không được để trống.` |
| `soseripktcl` | `xuatxu = 0` và null/rỗng | `STT {stt} : Số seri Phiếu kiểm tra chất lượng xuất xưởng (xe sản xuất, lắp ráp trong nước) không được để trống.` |
| `ma_nuocsx` | `tinhtrangtaisan = 1` và null/rỗng | `STT {stt} : Mã Nước sản xuất không được để trống.` |
| `ten_loaitaisan` | `tinhtrangtaisan = 1` và null/rỗng | `STT {stt} : Tên loại tài sản đăng ký không được để trống.` |
| `namsanxuat` | `tinhtrangtaisan = 1` và không có giá trị | `STT {stt} : Năm sản xuất không được để trống.` |
| `ten_thuongmai` | `tinhtrangtaisan = 1` và null/rỗng | `STT {stt} : Tên thương mại không được để trống.` |
| `ten_nhanhieu` | `tinhtrangtaisan = 1` và null/rỗng | `STT {stt} : Tên nhãn hiệu không được để trống.` |
| `kieuloaixe` | `tinhtrangtaisan = 1` và null/rỗng | `STT {stt} : Kiểu loại xe không được để trống.` |
| `thetich_congsuat` | `tinhtrangtaisan = 1` và null/rỗng | `STT {stt} : Thể tích làm việc hoặc Công suất không được để trống.` |
| `trongtai` | `tinhtrangtaisan = 1` và không có giá trị | `STT {stt} : Trọng tải không được để trống.` |
| `sochongoi` | `tinhtrangtaisan = 1` và không có giá trị | `STT {stt} : Số người cho phép chở không được để trống.` |
| `sobienkiemsoat` | `tinhtrangtaisan = 1` và null/rỗng | `STT {stt} : Số biển kiểm soát không được để trống.` |

### Message sai kiểu hoặc sai giá trị

Các message trong bảng này có prefix `STT {stt} : `, trừ dòng được ghi chú riêng.

| Field/trường hợp | Message trả ra |
|---|---|
| `loaihoadondactrung` sai kiểu dữ liệu | `STT {stt} : Loại hóa đơn đặc trưng dữ liệu không hợp lệ.` |
| `loaihoadondactrung` khác `1`, `2`, `3` | `STT {stt} : Loại hóa đơn đặc trưng không đúng định dạng.` |
| `loaitaisan` sai kiểu dữ liệu | `STT {stt} : Loại tài sản dữ liệu không hợp lệ.` |
| `loaitaisan` khác `1`, `2` | `STT {stt} : Loại tài sản không đúng định dạng.` |
| `tinhtrangtaisan` sai kiểu dữ liệu | `STT {stt} : Tình trạng tài sản dữ liệu không hợp lệ.` |
| `tinhtrangtaisan` khác `0`, `1` | `STT {stt} : Tình trạng tài sản không đúng định dạng.` |
| `xuatxu` sai kiểu dữ liệu | `STT {stt} : Xuất xứ dữ liệu không hợp lệ.` |
| `xuatxu` khác `0`, `1` | `STT {stt} : Xuất xứ không đúng định dạng.` |
| `namsanxuat` sai kiểu dữ liệu | `STT {stt} : Năm sản xuất dữ liệu không hợp lệ.` |
| `namsanxuat` ngoài `0..9999` | `STT {stt} : Năm sản xuất không đúng định dạng.` |
| `trongtai` sai kiểu dữ liệu | `STT {stt} : Trọng tải dữ liệu không hợp lệ.` |
| `trongtai` không đúng decimal `(9,2)` | `STT {stt} : Trọng tải không đúng định dạng.` |
| `sochongoi` sai kiểu dữ liệu | `STT {stt} : Số người cho phép chở dữ liệu không hợp lệ.` |
| `sochongoi` ngoài `0..9999` | `STT {stt} : Số người cho phép chở không đúng định dạng.` |
| `ma_nuocsx` không có trong danh mục | `Mã nước sản xuất không tồn tại.`; source hiện không gắn prefix `STT` |

Validation `loaihoadondactrung` nằm trong validation chi tiết chung và hiện vẫn chạy cả khi gate NĐ254 tắt. Các validation còn lại trong bảng thuộc helper hàng hóa đặc trưng loại 1.

### Message vượt độ dài của chi tiết

| Field | Message trả ra |
|---|---|
| `sokhung` quá 50 byte | `STT {stt} : Số khung không được vượt quá 50 ký tự.` |
| `somay` quá 50 byte | `STT {stt} : Số máy không được vượt quá 50 ký tự.` |
| `sogiaychungnhanatkt` quá 255 ký tự | `STT {stt} : Số Giấy chứng nhận chất lượng an toàn kỹ thuật và bảo vệ môi trường (đối với xe nhập khẩu) không được vượt quá 255 ký tự.` |
| `soseripktcl` quá 255 ký tự | `STT {stt} : Số seri Phiếu kiểm tra chất lượng xuất xưởng (xe sản xuất, lắp ráp trong nước) không được vượt quá 255 ký tự.` |
| `ma_nuocsx` quá 2 byte | `STT {stt} : Mã Nước sản xuất không được vượt quá 2 ký tự.` |
| `ten_loaitaisan` quá 255 ký tự | `STT {stt} : Tên loại tài sản đăng ký không được vượt quá 255 ký tự.` |
| `ten_thuongmai` quá 400 ký tự | `STT {stt} : Tên thương mại không được vượt quá 400 ký tự.` |
| `ten_nhanhieu` quá 255 ký tự | `STT {stt} : Tên nhãn hiệu không được vượt quá 255 ký tự.` |
| `kieuloaixe` quá 50 byte | `STT {stt} : Kiểu loại xe không được vượt quá 50 ký tự.` |
| `thetich_congsuat` quá 10 byte | `STT {stt} : Thể tích làm việc hoặc Công suất không được vượt quá 10 ký tự.` |
| `sobienkiemsoat` quá 20 byte | `STT {stt} : Số biển kiểm soát không được vượt quá 20 ký tự.` |

Ví dụ dòng STT `1` thiếu cả Số khung và Số máy:

```json
{
  "motaketqua": "STT 1 : Số khung không được để trống.STT 1 : Số máy không được để trống."
}
```

Nếu cùng payload không gửi `dschitiet[].stt`, message thực tế là:

```json
{
  "motaketqua": "STT  : Số khung không được để trống.STT  : Số máy không được để trống."
}
```

`chatluongtaisan`/`CLTSan` không có trong validator và không sinh XML theo source hiện tại.

### Quốc tịch người mua

Quốc tịch không phụ thuộc hàng hóa đặc trưng loại 1. Khi `ACTIVE_ND_254 = "1"`, source áp dụng:

| Request field | Rule theo code hiện tại |
|---|---|
| `ma_quoc_tich_nguoi_mua` | Optional; tối đa 2 ký tự; nếu có phải tồn tại trong danh mục quốc tịch |
| `quoc_tich_nguoi_mua` | Optional; tối đa 50 ký tự |

Message của CBCLOUDV2-9571 đã cập nhật trên working tree hiện tại:

| Trường hợp | Message nối vào `motaketqua` |
|---|---|
| Thiếu `dnmua_ten` | `Tên đơn vị không được để trống.` |
| Thiếu `dnmua_mst` | `MST/CCCD chủ hộ không được để trống.` |
| Thiếu cả hai | `Tên đơn vị không được để trống.MST/CCCD chủ hộ không được để trống.` |
| Thiếu `dnmua_cccd` | Không phát sinh lỗi required |

Các lỗi validation được nối liên tiếp vào `motaketqua`, không tự thêm dấu cách hoặc xuống dòng.

## Ma trận kết quả theo API

| API/method | Response DTO | Thành công | Lỗi validation NĐ254 | Kết quả trả ra |
|---|---|---|---|---|
| `SendInvoice` | `KquaGuiHD` | `maketqua = "01"` | `maketqua = "04"` | `motaketqua` chứa toàn bộ message validate |
| `GuiHoaDonGoc` | `KquaGuiHD` | `01` | `04` | Dừng trước lưu hóa đơn hợp lệ/ký |
| `GuiHoaDonThayThe` | `KquaTT` | `01` | `08` | Dừng trước lưu/ký thay thế |
| `GuiHoaDonDieuChinh` | `KquaDC` | `01` | `08` | Dừng trước lưu/ký điều chỉnh |
| `GuiHoaDonGocXML` | `KquaGuiHD` | Theo `GuiHoaDonGoc` | `04` | Sau deserialize, trả nguyên kết quả API gốc |
| `GuiHoaDonThayTheXML` | `KquaTT` | Theo `GuiHoaDonThayThe` | `08` | Sau deserialize, trả nguyên kết quả API thay thế |
| `GuiHoaDonDieuChinhXML` | `KquaDC` | Theo `GuiHoaDonDieuChinh` | `08` | Sau deserialize, trả nguyên kết quả API điều chỉnh |
| `GuiVaKyHoadonGocHSM` | `KquaGuiVaKyHD` | `01` | `04` | Giữ mã từ bước `GuiHoaDonGoc`; không gọi ký |
| `GuiVaKyHoaDonThayTheHSM` | `KquaGuiVaKyHD` | `01` | `08` | Giữ mã từ bước `GuiHoaDonThayThe`; không gọi ký |
| `GuiVaKyHoaDonDieuChinhHSM` | `KquaGuiVaKyHD` | `01` | `04` | Map mã validate `08` của API điều chỉnh thành `04`; không gọi ký |
| `GuiVaKyHoaDonGocToken` | `KquaGuiVaKyHDToken` | `01` ở bước thành công | `03` | Mã mặc định giữ nguyên, `motaketqua` nhận message validate |
| `GuiVaKyHoaDonThayTheToken` | `KquaGuiVaKyHDToken` | `01` ở bước thành công | `03` | Mã mặc định giữ nguyên, không tạo XML/phiên ký |
| `GuiVaKyHoaDonDieuChinhToken` | `KquaGuiVaKyHDToken` | `01` ở bước thành công | `03` | Mã mặc định giữ nguyên, không tạo XML/phiên ký |
| `GuiHoaDonVaKyMTT` | `KetQuaKyVaGuiTctMTT` | Thường `ketqua = true`, `maketqua = "01"` từ bước gửi TCT | `ketqua = false`, `maketqua = null` | Chỉ copy `motaketqua` từ `GuiHoaDonGoc`; không cấp số/ký/gửi TCT |
| `GuiHoaDonVaKyMTT_V2` | `KetQuaKyVaGuiTctMTT` | Theo kết quả gửi TCT | `ketqua = false`, `maketqua = null` | Hành vi lỗi bước lưu giống MTT V1 |

Tenant có nhánh mapping message riêng, ví dụ HomeCredit, có thể thay `motaketqua` theo `maketqua` sau khi wrapper HSM nhận kết quả. Bảng trên mô tả luồng chuẩn và mã nghiệp vụ trong source hiện tại.

## Response DTO chính

| DTO | Thuộc tính đáng chú ý |
|---|---|
| `KquaGuiHD` | `maketqua`, `motaketqua`, `magiaodich`, `sohoadon`, `mauso`, `kyhieu`, `ngayky`, `tct_macoquan`, `ma_tinh`, `ma_xa`, `key` |
| `KquaTT` | `maketqua`, `motaketqua`, `magiaodich`, `sohoadon`, `mauso`, `kyhieu`, `ngayky`, `tct_macoquan`, `ma_tinh`, `ma_xa` |
| `KquaDC` | `maketqua`, `motaketqua`, `magiaodich`, `sohoadon`, `mauso`, `kyhieu`, `ngayky`, `tct_macoquan`, `ma_tinh`, `ma_xa` |
| `KquaGuiVaKyHD` | Thêm `base64xml`, `link_tracuu`, `trangthai`, `motatrangthai`, `ketqua`, `loaihoadon`, `ngaylap`, `ma_hoadon` |
| `KquaGuiVaKyHDToken` | `maketqua`, `motaketqua`, `magiaodich`, `ngaylap`, `maphiengiaodich`, `base64xml` |
| `KetQuaKyVaGuiTctMTT` | `ketqua`, `maketqua`, `motaketqua`, thông tin hóa đơn, trạng thái và `base64xml` |

Khi trả lỗi sớm, các thuộc tính không được gán có thể là `null`, giá trị mặc định hoặc bị serializer bỏ qua.

## Ví dụ response validation

### Hóa đơn gốc hoặc SendInvoice thiếu Tên đơn vị

```json
{
  "maketqua": "04",
  "motaketqua": "Tên đơn vị không được để trống."
}
```

### Thay thế hoặc điều chỉnh thiếu MST/CCCD chủ hộ

```json
{
  "maketqua": "08",
  "motaketqua": "MST/CCCD chủ hộ không được để trống."
}
```

### HSM điều chỉnh thiếu cả hai field

```json
{
  "maketqua": "04",
  "motaketqua": "Tên đơn vị không được để trống.MST/CCCD chủ hộ không được để trống."
}
```

### Token thiếu Tên đơn vị

```json
{
  "maketqua": "03",
  "motaketqua": "Tên đơn vị không được để trống.",
  "maphiengiaodich": null,
  "base64xml": null
}
```

### MTT lỗi ở bước lưu

```json
{
  "ketqua": false,
  "maketqua": null,
  "motaketqua": "Tên đơn vị không được để trống."
}
```

`maketqua` của MTT đang `null` vì nhánh lỗi chỉ copy `guiHD.motaketqua`, không copy `guiHD.maketqua = "04"`. Đây là hành vi hiện có, không phải thay đổi của CBCLOUDV2-9167 hoặc CBCLOUDV2-9571.

## Ghi chú kiểm thử

- Business validation trả DTO lỗi theo mã trên; không phát sinh exception ở luồng bình thường.
- Với XML wrapper, XML deserialize lỗi trả `maketqua = "00"`, `motaketqua = "Lỗi phát sinh"`.
- Khi `ACTIVE_ND_254` tắt/thiếu/lỗi hoặc không có subtype 1, các required message NĐ254 không phát sinh.
- Không kết luận lỗi theo HTTP status đơn thuần; cần đọc `result.maketqua`, `result.motaketqua` hoặc `result.ketqua` nếu response được ABP wrap.
