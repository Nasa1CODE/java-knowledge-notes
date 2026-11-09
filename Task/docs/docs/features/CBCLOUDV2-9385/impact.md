# Impact - CBCLOUDV2-9385

## 1. Mục đích

Đánh giá ảnh hưởng của việc bỏ required `dnmua_email` cho API Hàng hóa đặc trưng loại 1 tại `api-cloud-service`.

## 2. Phạm vi thay đổi

- Logic validation: có, nới một required check.
- API contract: không đổi route, request DTO hoặc response.
- Dữ liệu: request có thể lưu `DNMua_Email` rỗng theo mapping hiện tại.
- DB/schema/migration: không.
- XML/queue/config/dependency: không.

## 3. Thành phần bị ảnh hưởng

| Service | File / method | Mức | Lý do |
|---|---|---|---|
| `api-cloud-service` | `GuiHoaDonAppService.ValidateNguoiMuaDacTrungXeValues(...)` | Trung bình | Shared validation của ba input gốc/thay thế/điều chỉnh |
| `api-cloud-service` | `ValidateHDGoc`, `ValidateHDTT`, `ValidateHDDC` | Trung bình | Ba entry gọi shared validator, không dự kiến sửa |
| `api-cloud-service` | 3 wrapper HSM, 2 API MTT | Trung bình | Kế thừa hành vi qua API lưu, có side effect ký/cấp số/gửi TCT |
| `api-cloud-service` | 3 wrapper XML | Thấp | Deserialize rồi gọi API lưu; chỉ regression |
| `api-cloud-service` | `test/WS.Application.Tests` | Thấp | Test Email optional, maxlength, gate và regression |

## 4. API chịu ảnh hưởng

- Trực tiếp: `GuiHoaDonGoc`, `GuiHoaDonThayThe`, `GuiHoaDonDieuChinh`.
- Kế thừa: `GuiVaKyHoadonGocHSM`, `GuiVaKyHoaDonThayTheHSM`, `GuiVaKyHoaDonDieuChinhHSM`, `GuiHoaDonVaKyMTT`, `GuiHoaDonVaKyMTT_V2`.
- Regression: `GuiHoaDonGocXML`, `GuiHoaDonThayTheXML`, `GuiHoaDonDieuChinhXML`.

## 5. Xác nhận không bị ảnh hưởng

| Vùng | Lý do |
|---|---|
| Import Excel và worker | Thuộc CBCLOUDV2-9386, không nằm trong `api-cloud-service` |
| DTO/Swagger/NSwag | Không đổi contract |
| Mapping `DNMua_Email` | Vẫn map giá trị hoặc chuỗi rỗng như hiện tại |
| XML `NMua/DCTDTu` | Không đổi cấu trúc hoặc rule lấy Email đầu tiên |
| Regex/danh sách/maxlength | Chỉ xóa required đặc trưng, giữ validation khi có dữ liệu |
| Buyer field và field xe khác | Không sửa các check còn lại |
| Tenant/auth | Không đổi tenant context hoặc authorization |
| DB/schema | Không có migration hoặc SQL |
| Rule Email tenant riêng | Nằm ngoài shared validator đặc trưng và được giữ nguyên |

## 6. Rủi ro và hạn chế

| Rủi ro/hạn chế | Mức | Xử lý |
|---|---|---|
| Shared helper ảnh hưởng đồng thời nhiều endpoint | Trung bình | Test ba input và regression mọi wrapper |
| HSM/MTT có side effect | Cao khi test sai môi trường | Chỉ chạy môi trường test; dùng request lỗi để xác nhận dừng trước side effect |
| Branch hiện tại thiếu source test | Trung bình | Tạo lại test project tối thiểu theo pattern commit 9397 nếu cần |
| Tenant riêng vẫn bắt buộc Email | Trung bình | Ghi rõ là rule độc lập, regression để tránh hiểu sai phạm vi |
| Email trống không thể dùng để gửi mail | Trung bình | Không đổi service gửi mail; BA/QA xác nhận nghiệp vụ |

## 7. Chưa được kiểm chứng

- Đã sửa code, chạy 14 automated tests pass và build `WS.Application` thành công với 0 error.
- Chưa gọi ba API lưu.
- Chưa regression HSM, MTT và XML trên môi trường test.
- Chưa kiểm tra hai tenant thực tế.

## 8. Kết luận

Rủi ro tổng thể trung bình: code thực tế chỉ xóa một required check và automated test đã phủ Email optional, gate, maxlength, các buyer field còn lại. Vẫn cần manual regression endpoint trước phát hành vì HSM/MTT có side effect và rule tenant riêng cần môi trường tích hợp.
