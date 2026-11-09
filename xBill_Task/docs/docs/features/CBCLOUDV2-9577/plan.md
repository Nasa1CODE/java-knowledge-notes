---
feature: CBCLOUDV2-9577
title: "[DEV] Nâng cấp check hóa đơn API và Excel import theo dữ liệu khách hàng đẩy lên"
plan-status: draft
service: api-cloud-service
service-repo: D:\XBill\Cloud\api-cloud-service
created_at: 2026-09-14
updated_at: 2026-09-14
---

# Plan - CBCLOUDV2-9577

## 1. Phạm vi đã chốt

- Chỉ lập phương án sửa source `D:\XBill\Cloud\api-cloud-service`; chưa sửa code.
- `invoicecore` và Excel import chưa sửa trong phase này.
- Bỏ `ACTIVE_ND_254` và request `version` khỏi điều kiện quyết định rule API.
- Chỉ áp dụng NĐ254 khi hóa đơn có ít nhất một dòng `loaihoadondactrung = 1` và có dữ liệu tại ít nhất một field mới thuộc phạm vi dòng loại `1`.
- Sáu field mới cấp hóa đơn được tính khi hóa đơn có dòng loại `1`; 15 field mới cấp chi tiết chỉ được dò trên chính các dòng loại `1`.
- Khi `UseND254 = true`, chạy toàn bộ validation NĐ254 hiện tại và cộng dồn lỗi vào `motaketqua`.

## 2. Điều kiện bật rule

```text
HasType1 =
    input.dschitiet.Any(x => x.loaihoadondactrung == 1)

HasNewFieldForType1 =
    HasAny6InvoiceND254Field(input)
    OR input.dschitiet
        .Where(x => x.loaihoadondactrung == 1)
        .Any(HasAny15DetailND254Field)

UseND254 = HasType1 AND HasNewFieldForType1
```

| Trạng thái | Hành vi |
|---|---|
| Không có dòng loại `1` | `UseND254 = false`; chạy rule cũ dù request có field mới |
| Có dòng loại `1` nhưng không có field mới phù hợp | `UseND254 = false`; chạy rule cũ |
| Có một trong 6 field mới cấp hóa đơn và có dòng loại `1` | `UseND254 = true` |
| Có một trong 15 field mới trên chính dòng loại `1` | `UseND254 = true` |
| Field mới chỉ nằm trên dòng loại `2/3` | Không được tính làm tín hiệu; chạy rule cũ nếu không có tín hiệu khác |

Không trả lỗi guard riêng khi có field mới nhưng không có dòng loại `1`; trường hợp này được xử lý theo rule cũ đã chốt.

| Kiểu dữ liệu | Được coi là có field |
|---|---|
| String | Khác null/rỗng/whitespace sau `Trim()` |
| Nullable number | `HasValue = true`; `0` vẫn tính là có dữ liệu |
| Số sai kiểu | Sentinel `int.MinValue`/`decimal.MinValue` vẫn bật để validator trả lỗi |
| Property không gửi hoặc gửi null | Không bật |

## 3. Allow-list 21 field

### 6 field cấp hóa đơn

| Nhóm | Field |
|---|---|
| Địa bàn | `ma_tinh`, `ten_tinh`, `ma_xa`, `ten_xa` |
| Quốc tịch | `ma_quoc_tich_nguoi_mua`, `quoc_tich_nguoi_mua` |

### 15 field cấp chi tiết

| # | Request | XML |
|---:|---|---|
| 1 | `loaitaisan` | `LTSan` |
| 2 | `tinhtrangtaisan` | `TTTSan` |
| 3 | `xuatxu` | `XXu` |
| 4 | `sogiaychungnhanatkt` | `SGCNATKThuat` |
| 5 | `soseripktcl` | `SSPKTCLXXuong` |
| 6 | `ma_nuocsx` | `MNSXuat` |
| 7 | `ten_loaitaisan` | `TLTSDKy` |
| 8 | `namsanxuat` | `NSXuat` |
| 9 | `ten_thuongmai` | `TTMai` |
| 10 | `ten_nhanhieu` | `TNHieu` |
| 11 | `kieuloaixe` | `KLXe` |
| 12 | `thetich_congsuat` | `TTLVHCSuat` |
| 13 | `trongtai` | `TTai` |
| 14 | `sochongoi` | `SCNgoi` |
| 15 | `sobienkiemsoat` | `SBKSoat` |

Không dùng `version`, `loaihoadondactrung`, `sokhung`, `somay`, `dnmua_ten`, `dnmua_mst` hoặc `dnmua_cccd` làm tín hiệu field mới. `loaihoadondactrung = 1` là điều kiện phạm vi bắt buộc nhưng không tự bật `UseND254`. Không đưa `CLTSan/chatluongtaisan` vào detector vì source API hiện không còn field này và XML không sinh `CLTSan`.

## 4. Thống kê vị trí đang dùng cờ

| Thành phần | Số vị trí phải rà/thay |
|---|---:|
| `GuiHoaDonAppService.cs` | 27 dòng dependency/helper/call-site |
| `HoaDonTT3278Utility.cs` | 14 dòng dependency/context/gate |
| `Results.cs` | 1 property context |
| `ND254FeatureChecker.cs` | 1 checker cần xóa khi hết tham chiếu |
| **Tổng consumer** | **42 dòng trên 3 file** |
| Lần đọc `_nd254FeatureChecker.IsActive()` | **5** |
| Literal `ACTIVE_ND_254` | **1** |

Line number dưới đây theo source hiện tại; lúc code phải tìm lại bằng symbol search.

## 5. GuiHoaDonAppService: vị trí và cách thay

File `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.

| Dòng hiện tại | Đang dùng cờ ở đâu | Thay bằng gì |
|---|---|---|
| 133, 200, 264 | Field, constructor parameter, assignment checker | Bỏ dependency checker; thêm detector thuần dữ liệu |
| 7913-7915 | `IsActiveND254()` đọc Redis/DB | Xóa; dùng `ND254DataDetector.HasType1AndAnyNewField(input)` |
| 7918-7930 | 3 overload ghép cờ với subtype 1 | Thay bằng detector `HasType1 && HasNewFieldForType1` cho ba DTO |
| 8014-8065 | Buyer validator nhận boolean | Truyền `UseND254` |
| 8068-8082 | Quốc tịch tự đọc cờ | Thêm parameter `useND254` |
| 8622, 8626 | Map địa bàn/quốc tịch thay thế | Dùng cùng `UseND254` |
| 8751 | Map 15 field chi tiết thay thế | `UseND254 && loaihoadondactrung == 1` |
| 8818-8819 | Validate buyer/quốc tịch thay thế | Truyền cùng `UseND254` |
| 9487 | Validate chi tiết thay thế | Dùng `UseND254`; helper tiếp tục lọc dòng loại `1` |
| 9698, 9702 | Map địa bàn/quốc tịch điều chỉnh | Dùng cùng `UseND254` |
| 9814 | Map 15 field chi tiết điều chỉnh | `UseND254 && loaihoadondactrung == 1` |
| 9877-9878 | Validate buyer/quốc tịch điều chỉnh | Truyền cùng `UseND254` |
| 10510 | Validate chi tiết điều chỉnh | Dùng `UseND254`; helper tiếp tục lọc dòng loại `1` |
| 11331, 11335 | Map địa bàn/quốc tịch hóa đơn gốc | Dùng cùng `UseND254` |
| 11461 | Map 15 field chi tiết hóa đơn gốc | `UseND254 && loaihoadondactrung == 1` |
| 11573-11574 | Validate buyer/quốc tịch hóa đơn gốc | Truyền cùng `UseND254` |
| 12222 | Validate chi tiết hóa đơn gốc | Dùng `UseND254`; helper tiếp tục lọc dòng loại `1` |

Mỗi API lưu tính đúng một lần:

```text
var useND254 = ND254DataDetector.HasType1AndAnyNewField(input);
validate(input, useND254);
map(input, entity, useND254);
```

Wrapper HSM/Token/MTT/XML tiếp tục gọi API lưu gốc/thay thế/điều chỉnh, không tự tính detector lần hai.

## 6. HoaDonTT3278Utility: vị trí và cách thay

File `src/hddt/WS.Application/Commons/HoaDon/HoaDonTT3278Utility.cs`.

| Dòng hiện tại | Đang dùng cờ ở đâu | Thay bằng gì |
|---|---|---|
| 35, 36, 41 | Inject/lưu checker | Bỏ checker khỏi utility |
| 56 | `TaoFileXml` đọc cờ | Tính `UseND254` từ entity |
| 132 | `TaoFileXmlCustom` đọc cờ | Tính từ entity |
| 261, 283 | `TaoFileXmlPhanTrang` đọc rồi truyền từng trang | Tính một lần từ hóa đơn gốc, dùng cùng snapshot |
| 402 | `TaoFileXmlPhanTrangCustom` đọc cờ | Tính từ entity |
| 840 | Gate `PBan` | Dùng `UseND254` và dữ liệu xe trên dòng loại `1` |
| 2090 | Gate buyer/location | Dùng `UseND254` |
| 2141 | Gate `QTNMua/MQTNMua` | Dùng `UseND254`, chỉ sinh node có giá trị |
| 2482 | Truyền cờ vào builder chi tiết | Truyền `UseND254` |
| 3466, 3486 | Parameter/gate `GetTHHDTrung` | Đổi sang `useND254`; sinh từng tag có dữ liệu |

XML phải detect `Loai_HangHoa_DacTrung = 1`, 6 field của `HD_HoaDon_MoRong` và 15 field của `HD_ChiTiet_MoRong` trên chính dòng loại `1`, vì luồng view/ký có thể chỉ nhận ID rồi load DB. Công thức detector từ entity phải tương đương detector request, không được chỉ kiểm tra “có bất kỳ field mới”.

## 7. Results và checker

| File/vị trí | Hiện tại | Thay bằng gì |
|---|---|---|
| `Results.cs:112` | `InputInfoInvoiceAdditional.IsActiveND254` | Đổi thành `UseND254` hoặc `HasND254Data` |
| `ND254FeatureChecker.cs` | Đọc Redis Hash, fallback host DB | Xóa sau khi không còn consumer |

Không xóa Redis key hoặc dữ liệu cấu hình DB; chỉ bỏ việc source API sử dụng.

## 8. “Check toàn bộ rule NĐ254”

Khi `UseND254 = true`, tất cả nhóm validator NĐ254 hiện tại được gọi:

| Nhóm | Validation chạy |
|---|---|
| Người mua | Required/maxlength Tên đơn vị, MST/CCCD chủ hộ, địa chỉ, mã tỉnh, mã xã, số điện thoại, họ tên người mua; email/CCCD chỉ maxlength |
| Địa bàn | Maxlength và kiểm tra mã tỉnh/mã xã tồn tại |
| Quốc tịch | Maxlength; mã có giá trị phải tồn tại |
| Chi tiết | Required/domain/maxlength cho mọi dòng `loaihoadondactrung = 1` |
| Mã nước sản xuất | Có giá trị phải tồn tại trong danh mục |

Các điều kiện nghiệp vụ bên trong validator giữ nguyên: giấy nhập khẩu phụ thuộc `xuatxu = 1`; phiếu xuất xưởng phụ thuộc `xuatxu = 0`; nhóm xe cũ và biển số phụ thuộc `tinhtrangtaisan = 1`.

Validation chi tiết vẫn lọc từng dòng theo `loaihoadondactrung = 1`. Field cũ `sokhung`, `somay` và 15 field mới được kiểm tra trên các dòng này; dòng loại `2/3` không bị áp rule xe NĐ254. Tất cả lỗi tiếp tục cộng dồn và trả một lần trong `motaketqua`; không thêm mã hoặc message guard mới.

## 9. Map/lưu và XML

- `UseND254 = true`: map/lưu 6 field cấp hóa đơn theo request; 15 field cấp chi tiết chỉ map trên dòng `loaihoadondactrung = 1`. Field optional có dữ liệu vẫn lưu, không cần đủ tất cả mới map.
- `UseND254 = false`: không map nhóm mới, giữ rule cũ.
- XML mới/sinh lại detect từ entity, không đọc config.
- Không sinh node rỗng.
- `PBan = 2.1.1` khi có ít nhất một trong 15 field xe trên dòng loại `1`; chỉ có quốc tịch/địa bàn thì giữ `2.1.0`.
- Giữ `SKhung`, `SMay`, `MDVQHNSach`; không sinh `CLTSan`.
- XML đã ký trên FTP không thay đổi.

## 10. API regression

| Nhóm | Phạm vi |
|---|---|
| Lưu | `SendInvoice`, gốc, thay thế, điều chỉnh |
| Wrapper XML | Ba API gốc/thay thế/điều chỉnh XML |
| HSM | Ba API HSM |
| Token | Ba API Token |
| MTT | `GuiHoaDonVaKyMTT`, `GuiHoaDonVaKyMTT_V2` |
| Render XML | thường, custom, phân trang, view `Type = 1`, ký `Type = 2` |

## 11. Test bắt buộc

1. Không có 21 field: rule cũ.
2. Có từng field trong 6 field cấp hóa đơn và có dòng loại `1`: bật `UseND254`.
3. Có từng field trong 15 field mới trên dòng loại `1`: bật `UseND254`.
4. Có field mới nhưng không có dòng loại `1`: chạy rule cũ.
5. Field mới chỉ nằm trên dòng loại `2/3`: không bật `UseND254` nếu không có tín hiệu khác.
6. Whitespace không bật; số `0` và sentinel sai kiểu trên dòng loại `1` có bật.
7. Khi bật, lỗi buyer + địa bàn + quốc tịch + nhiều dòng chi tiết loại `1` cùng được cộng dồn.
8. Hóa đơn có cả dòng loại `1` và loại khác: validation/map 15 field mới chỉ tác động dòng loại `1`.
9. Config bật nhưng không đủ điều kiện dữ liệu: vẫn rule cũ.
10. Config tắt/thiếu/lỗi nhưng đủ điều kiện dữ liệu: vẫn chạy rule NĐ254.
11. `version` null/`0`/`1` với cùng payload: kết quả giống nhau.
12. Map DB và XML đúng cho ba loại hóa đơn; `PBan` và 15 tag chỉ xét dòng loại `1`.
13. Sau sửa, search `ACTIVE_ND_254`, `IsActiveND254`, `ND254FeatureChecker` không còn consumer trong source API.

## 12. Ngoài scope

- Không sửa `D:\XBill\Cloud\invoicecore` hoặc Excel import trong phase này.
- Không thay DB schema, route, request/response DTO hoặc Swagger.
- Không đổi rule, nội dung hoặc mã lỗi validation hiện tại.
- Chưa triển khai code cho đến khi Plan được duyệt.

## Phê duyệt

- [ ] DEV xác nhận allow-list 21 field.
- [ ] DEV xác nhận null/rỗng/whitespace và số `0`.
- [ ] TechLead duyệt Plan trước khi code.
