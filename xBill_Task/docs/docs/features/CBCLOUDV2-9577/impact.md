---
feature: CBCLOUDV2-9577
updated_at: 2026-09-14
---

# Impact - CBCLOUDV2-9577

## Phạm vi ảnh hưởng

| Thành phần | Ảnh hưởng dự kiến |
|---|---|
| API validation | Điều kiện chạy rule chuyển từ config sang dữ liệu request |
| API map/lưu | Khi đủ điều kiện `UseND254`, field mới được lưu không phụ thuộc config; 15 field chi tiết chỉ lưu trên dòng loại `1` |
| XML/PDF/HTML | Điều kiện sinh tag và `PBan` chuyển sang dữ liệu entity |
| Excel import | Ngoài scope, không thay đổi trong phase này |
| Redis/host DB | API không còn đọc `ACTIVE_ND_254` để chọn rule |
| DB schema | Không dự kiến migration |
| API contract | Không thay đổi DTO/route/response |

## Tương thích ngược

- Payload không đồng thời có dòng loại `1` và field mới phù hợp tiếp tục đi luồng cũ.
- Field số `0` phải được xem là có dữ liệu, không được nhầm thành rỗng.
- Dữ liệu NĐ254 gửi khi cấu hình cũ đang tắt sẽ không còn bị bỏ qua/xóa.

## Rủi ro

| Rủi ro | Mức | Kiểm soát |
|---|---|---|
| Converter làm mất tín hiệu số sai kiểu | Cao | Sentinel số trên dòng loại `1` vẫn phải bật `UseND254` |
| Một field mới trên phạm vi loại `1` làm phát sinh nhiều required error | Cao | Đây là rule đã chốt; regression message cộng dồn và thông báo cho client |
| XML lịch sử thay đổi khi sinh lại | Cao | Test riêng, xin xác nhận nghiệp vụ; không sửa XML đã ký FTP |
| Field cũ vô tình kích hoạt NĐ254 | Trung bình | Danh sách allow-list, không suy luận bằng reflection mọi property |
| Field mới trên dòng loại `2/3` vô tình kích hoạt NĐ254 | Cao | Detector chỉ dò 15 field chi tiết trên dòng `loaihoadondactrung = 1` |
| Còn call-site đọc config | Trung bình | `rg ACTIVE_ND_254/IsActiveND254` phải không còn consumer trong source API |

## Ghi chú đánh giá ảnh hưởng cho Tester

### 1. Phạm vi cần test lại

Tester cần tập trung test lại các API gửi/lưu hóa đơn của `api-cloud-service`, gồm:

- Hóa đơn gốc.
- Hóa đơn thay thế.
- Hóa đơn điều chỉnh.
- Các wrapper dùng lại ba luồng trên: XML, HSM, Token, MTT.
- Luồng sinh lại XML/HTML/PDF từ dữ liệu đã lưu trong DB.
- XML thường, XML custom layout, XML phân trang, XML view `Type = 1`, XML ký `Type = 2`.

Không test Excel import trong phase này vì `invoicecore`/Excel import nằm ngoài phạm vi thay đổi.

### 2. Thay đổi nghiệp vụ chính

Trước task này, API bật rule NĐ254 theo cấu hình `ACTIVE_ND_254`.

Sau task này, API tự xác định theo dữ liệu khách hàng gửi. Rule NĐ254 chỉ bật khi đồng thời thỏa hai điều kiện:

- Có ít nhất một dòng chi tiết `loaihoadondactrung = 1`.
- Có ít nhất một field mới hợp lệ thuộc allow-list NĐ254.

Nếu thiếu một trong hai điều kiện trên, API phải chạy theo rule cũ, dù cấu hình `ACTIVE_ND_254` đang bật.

### 3. Field dùng để bật NĐ254

Các field dưới đây là field tín hiệu để xác định payload có dữ liệu NĐ254 hay không. Đây không phải danh sách field bắt buộc.

Sáu field cấp hóa đơn chỉ được tính là tín hiệu bật NĐ254 khi hóa đơn có ít nhất một dòng `loaihoadondactrung = 1`:

| Nhóm | Field |
|---|---|
| Địa bàn | `ma_tinh`, `ten_tinh`, `ma_xa`, `ten_xa` |
| Quốc tịch người mua | `ma_quoc_tich_nguoi_mua`, `quoc_tich_nguoi_mua` |

Lưu ý riêng nhóm quốc tịch người mua:

- `ma_quoc_tich_nguoi_mua` và `quoc_tich_nguoi_mua` thuộc dữ liệu NĐ254 nhưng không bắt buộc nhập khi `loaihoadondactrung = 1`.
- Nếu có gửi thì validate maxlength và kiểm tra mã quốc tịch tồn tại.
- Nếu không gửi quốc tịch, API không được báo lỗi thiếu quốc tịch.

Mười lăm field cấp chi tiết chỉ được tính trên chính dòng `loaihoadondactrung = 1`:

| Field request | Ý nghĩa/XML |
|---|---|
| `loaitaisan` | Loại tài sản / `LTSan` |
| `tinhtrangtaisan` | Tình trạng tài sản / `TTTSan` |
| `xuatxu` | Xuất xứ / `XXu` |
| `sogiaychungnhanatkt` | Số giấy chứng nhận ATKT / `SGCNATKThuat` |
| `soseripktcl` | Số seri phiếu KTCL xuất xưởng / `SSPKTCLXXuong` |
| `ma_nuocsx` | Mã nước sản xuất / `MNSXuat` |
| `ten_loaitaisan` | Tên loại tài sản / `TLTSDKy` |
| `namsanxuat` | Năm sản xuất / `NSXuat` |
| `ten_thuongmai` | Tên thương mại / `TTMai` |
| `ten_nhanhieu` | Tên nhãn hiệu / `TNHieu` |
| `kieuloaixe` | Kiểu loại xe / `KLXe` |
| `thetich_congsuat` | Thể tích/công suất / `TTLVHCSuat` |
| `trongtai` | Trọng tải / `TTai` |
| `sochongoi` | Số chỗ ngồi / `SCNgoi` |
| `sobienkiemsoat` | Số biển kiểm soát / `SBKSoat` |

Các field sau không được tự bật NĐ254:

- `version`.
- `loaihoadondactrung`.
- `sokhung`, `somay`.
- `dnmua_ten`, `dnmua_mst`, `dnmua_cccd`.
- Các field mới nếu chỉ nằm trên dòng loại `2`, loại `3` hoặc dòng không có `loaihoadondactrung = 1`.

### 4. Quy tắc xác định có dữ liệu

Tester cần kiểm tra kỹ các giá trị biên:

| Kiểu dữ liệu | Kỳ vọng |
|---|---|
| String `null`, rỗng, toàn khoảng trắng | Không được tính là có dữ liệu |
| String có ký tự sau khi trim | Được tính là có dữ liệu |
| Nullable number có giá trị `0` | Được tính là có dữ liệu |
| Nullable number sai kiểu, converter đưa về sentinel `int.MinValue`/`decimal.MinValue` | Vẫn phải bật NĐ254 để validator trả lỗi dữ liệu không hợp lệ |

### 5. Ảnh hưởng validation

Khi `UseND254 = false`:

- Không chạy required/maxlength/domain của nhóm NĐ254.
- Không validate quốc tịch/địa bàn theo rule NĐ254.
- Không validate 15 field xe NĐ254.
- Payload phải giữ hành vi cũ.

Khi `UseND254 = true`:

- Validate nhóm người mua NĐ254: tên đơn vị, MST/CCCD chủ hộ, địa chỉ, mã tỉnh, mã xã, số điện thoại, họ tên người mua.
- Validate maxlength các field người mua, địa bàn và quốc tịch.
- Validate mã tỉnh/mã xã tồn tại.
- Validate mã quốc tịch tồn tại khi có gửi mã; quốc tịch không phải trường bắt buộc.
- Validate 15 field chi tiết chỉ trên dòng `loaihoadondactrung = 1`.
- Vẫn giữ điều kiện nghiệp vụ cũ: giấy nhập khẩu phụ thuộc `xuatxu = 1`, phiếu xuất xưởng phụ thuộc `xuatxu = 0`, nhóm xe cũ/biển số phụ thuộc `tinhtrangtaisan = 1`.
- Tất cả lỗi phải được cộng dồn vào `motaketqua`, không dừng ở lỗi đầu tiên.

### 6. Ảnh hưởng map/lưu DB

Khi `UseND254 = true`:

- Sáu field cấp hóa đơn được map vào `HD_HoaDon_MoRong`.
- Mười lăm field chi tiết chỉ được map vào `HD_ChiTiet_MoRong` của dòng `loaihoadondactrung = 1`.
- Dòng loại `2/3` không được lưu 15 field xe NĐ254, kể cả request có gửi các field này.
- Field cũ như `sokhung`, `somay`, biển kiểm soát, người gửi hàng vẫn giữ hành vi cũ.

Khi `UseND254 = false`:

- Không map sáu field header NĐ254.
- Không map 15 field chi tiết NĐ254.
- Không sinh dữ liệu NĐ254 rỗng trong DB/XML.

### 7. Ảnh hưởng XML/PDF/HTML

Luồng render/sinh lại file không đọc request gốc, nên phải tự detect từ entity đã lưu trong DB:

- `UseND254 = true` khi DB có dòng `Loai_HangHoa_DacTrung = 1` và có field mới phù hợp.
- `PBan = 2.1.1` chỉ khi có dữ liệu trong 15 field xe NĐ254 trên dòng loại `1`.
- Nếu chỉ có địa bàn/quốc tịch mà không có dữ liệu xe trong 15 field chi tiết thì `PBan` vẫn là `2.1.0`.
- XML chỉ sinh tag NĐ254 có dữ liệu, không sinh tag rỗng.
- Mười lăm tag xe NĐ254 chỉ sinh cho dòng `Loai_HangHoa_DacTrung = 1`.
- `SKhung`, `SMay`, `MDVQHNSach` giữ hành vi cũ.
- Không sinh tag `CLTSan`.
- XML đã ký trên FTP không bị sửa lại.

### 8. Matrix test khuyến nghị

| Case | Input | Kỳ vọng |
|---|---|---|
| 1 | Không có dòng loại `1`, có field mới header | Rule cũ |
| 2 | Có dòng loại `1`, không có field mới | Rule cũ |
| 3 | Có dòng loại `1`, field mới header có giá trị | Bật NĐ254 |
| 4 | Có dòng loại `1`, field mới chi tiết trên dòng loại `1` | Bật NĐ254 |
| 5 | Có dòng loại `1`, field mới chi tiết chỉ nằm trên dòng loại `2/3` | Rule cũ nếu không có tín hiệu khác |
| 6 | Chỉ có `sokhung`/`somay` và dòng loại `1` | Rule cũ |
| 7 | Field string mới toàn whitespace | Rule cũ |
| 8 | Field số mới bằng `0` trên dòng loại `1` | Bật NĐ254 |
| 9 | Field số mới sai kiểu trên dòng loại `1` | Bật NĐ254 và trả lỗi dữ liệu không hợp lệ |
| 10 | Payload đủ NĐ254 nhưng config `ACTIVE_ND_254` tắt | Vẫn bật NĐ254 |
| 11 | Payload không đủ NĐ254 nhưng config `ACTIVE_ND_254` bật | Vẫn rule cũ |
| 12 | Cùng payload nhưng `version` null/`0`/`1` | Kết quả giống nhau |
| 13 | Có nhiều lỗi buyer + chi tiết | `motaketqua` chứa đủ lỗi |
| 14 | Hóa đơn có dòng loại `1` và `2/3` | Validate/map 15 field chỉ dòng loại `1` |
| 15 | Sinh lại XML từ DB chỉ có quốc tịch/địa bàn | Không nâng `PBan` lên `2.1.1` |
| 16 | Sinh lại XML từ DB có field xe NĐ254 dòng loại `1` | `PBan = 2.1.1`, sinh đúng tag có dữ liệu |

### 9. Dấu hiệu lỗi cần báo DEV

Tester cần báo lỗi nếu gặp một trong các hiện tượng sau:

- API còn phụ thuộc trạng thái `ACTIVE_ND_254`.
- Thay đổi `version` làm thay đổi kết quả validate/map/XML.
- Field cũ `sokhung`/`somay` làm bật toàn bộ required NĐ254.
- Field mới trên dòng loại `2/3` làm bật NĐ254.
- String whitespace bị tính là có dữ liệu.
- Số `0` bị coi là rỗng.
- Dữ liệu sai kiểu không bật validator NĐ254.
- XML sinh tag NĐ254 rỗng.
- XML sinh 15 tag xe cho dòng không phải loại `1`.
- `PBan` lên `2.1.1` khi không có dữ liệu xe NĐ254 trên dòng loại `1`.
- Lỗi validation chỉ trả lỗi đầu tiên thay vì cộng dồn.
