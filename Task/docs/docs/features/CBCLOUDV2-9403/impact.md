# Impact - CBCLOUDV2-9403

## 1. Mục đích

Đánh giá ảnh hưởng khi bỏ `chatluongtaisan` khỏi request API và `CLTSan` khỏi XML Hàng hóa đặc trưng loại 1, đồng thời giữ entity/cột DB và dữ liệu vật lý.

## 2. Phạm vi thay đổi

- Validation và mapping API: có.
- Request DTO/Swagger contract: có, bỏ một property ở ba detail model.
- Route/response/auth/permission: không.
- XML output: có, không còn `CLTSan` cho dữ liệu mới hoặc lịch sử.
- Entity/DB/schema/data vật lý: không đổi.
- Queue/config/dependency/frontend: không đổi.

## 3. Thành phần bị ảnh hưởng

| Thành phần | File/vùng | Mức | Lý do |
|---|---|---|---|
| Ba request DTO | `GuiHDGoc.cs`, `GuiHoaDonTT.cs`, `GuiHoaDonDC.cs` | Cao | Contract công khai bỏ property |
| Shared validator | `GuiHoaDonAppService.cs` | Cao | Ba API lưu dùng chung validation |
| Shared mapper | `GuiHoaDonAppService.cs` | Cao | Dữ liệu mới không còn ghi `cltsan` |
| HSM/MTT wrappers | Cùng AppService | Trung bình | Kế thừa API lưu và có side effect |
| XML renderer | `HoaDonTT3278Utility.cs`, `TTin.cs` | Cao | Bỏ field output loại 1 và constant |
| XML wrappers | Cùng AppService | Trung bình | Input cũ/mới cần tương thích deserialize; output đổi |
| Automated tests | `test/WS.Application.Tests/HoaDon` | Thấp | Signature reflection và regression thay đổi |
| External API clients | Generated/manual clients | Cao | Schema không còn field; client cũ cần được xác nhận |

## 4. Xác nhận không bị ảnh hưởng

| Vùng | Lý do |
|---|---|
| `invoicecore` và `svinvoicesendemail` | Thuộc task Import CBCLOUDV2-9404, không phải API task này |
| Frontend | Không dùng/sửa giao diện trong scope API tích hợp |
| `HD_ChiTiet_MoRong.cltsan` và DB column | Giữ để đọc dữ liệu cũ, không có migration |
| Dữ liệu `cltsan` lịch sử | Giữ trong DB nhưng không còn xuất ra XML |
| Field `sobienkiemsoat` | Vẫn required khi xe đã qua sử dụng và vẫn map |
| Field đặc trưng khác | Không thay đổi required/enum/maxlength/format |
| Queue/config/auth/tenant routing | Không đổi contract hoặc luồng xử lý |
| Subtype 2/3 | Gate subtype 1 giữ nguyên |

## 5. Rủi ro và hạn chế

| Rủi ro/hạn chế | Mức | Xử lý |
|---|---|---|
| Xóa property làm client generated không compile khi regenerate | Cao | Thông báo contract, Gate 1 xác nhận consumer và rollout |
| JSON và XML xử lý property dư khác nhau | Cao | Automated JSON test và manual ba XML wrapper |
| Bỏ validate nhưng quên mapping | Cao | Test mapper + DB read-back `cltsan IS NULL` |
| Bỏ nhầm field XML ngoài subtype 1 | Cao | Sửa đúng block `HasHangHoaDacTrungXeMoi`; regression loại 2/3 |
| HSM/MTT phát sinh side effect khi request lỗi khác | Cao | Regression trên môi trường test trước release |
| Worktree API có test untracked từ task trước | Trung bình | Không restore/ghi đè; review diff theo ticket |

## 6. Chưa được kiểm chứng

- Consumer nào đang compile trực tiếp theo property `chatluongtaisan` trong generated client.
- Hành vi XML deserializer khi payload cũ còn node quality và XML output sau khi bỏ `CLTSan`.
- Automated test, build, ba API lưu, HSM/MTT/XML và DB read-back.
- Nhánh implementation chưa được DEV xác nhận; source hiện ở `manh/dev_v2` với test untracked.

## 7. Kết luận

Rủi ro tổng thể cao vì thay đổi cả request contract và XML output dùng chung cho 11 endpoint/call chain. Chỉ nên phát hành sau khi xác nhận consumer, kiểm payload cũ JSON/XML, chứng minh dữ liệu mới không ghi `cltsan` và XML mới/lịch sử đều không còn `CLTSan`.
