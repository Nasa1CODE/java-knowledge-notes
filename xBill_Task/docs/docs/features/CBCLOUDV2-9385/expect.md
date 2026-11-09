# Expect - CBCLOUDV2-9385: Bỏ bắt buộc Địa chỉ thư điện tử trên API Hàng hóa đặc trưng 1

status: testing
services-affected: api-cloud-service

## Bối cảnh

Task CBCLOUDV2-9167 bổ sung Hàng hóa đặc trưng loại 1 cho API tích hợp. Hiện shared validator thông tin người mua tại `api-cloud-service` trả message `Địa chỉ thư điện tử không được để trống.` khi `dnmua_email` trống trong request thuộc rule mới.

Task CBCLOUDV2-9385 nới riêng điều kiện bắt buộc này, đồng bộ nghiệp vụ với task Import CBCLOUDV2-9386. Danh sách API được xác định từ tài liệu CBCLOUDV2-9397 tại commit docs `3b4d420986bec4fafef0881df9afea4cc46aa8b2` và đối chiếu source hiện tại.

## Điều kiện áp dụng

Chỉ áp dụng khi đồng thời:

- Request có `version = "1"` sau khi trim.
- Có ít nhất một phần tử `dschitiet[]` có `loaihoadondactrung = 1`.

API không có điều kiện `loaihanghoa = 4` như luồng Import Excel. Không bổ sung điều kiện theo `loaitaisan` hoặc `tinhtrangtaisan` cho việc bỏ required Email.

## Mong muốn

- Cho phép `dnmua_email` null, rỗng hoặc chỉ có khoảng trắng mà không trả message required riêng của rule Hàng hóa đặc trưng loại 1.
- Nếu `dnmua_email` có dữ liệu, tiếp tục kiểm tra định dạng, danh sách email phân tách bằng `,`/`;` và maxlength theo rule hiện tại.
- Tiếp tục map/lưu `DNMua_Email` và render XML theo logic hiện tại khi có dữ liệu; task không thay đổi rule lấy email đầu tiên trong XML của CBCLOUDV2-9167.
- Giữ nguyên required và maxlength của các trường thông tin người mua khác.

## API chịu thay đổi hành vi

### API lưu gọi validator trực tiếp

| # | Endpoint | Input |
|---|---|---|
| 1 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGoc` | `GuiHDGoc` |
| 2 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayThe` | `GuiHoaDonTT` |
| 3 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinh` | `GuiHoaDonDC` |

### API kế thừa qua API lưu

| # | Endpoint | API gọi lại |
|---|---|---|
| 4 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoadonGocHSM` | `GuiHoaDonGoc` |
| 5 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonThayTheHSM` | `GuiHoaDonThayThe` |
| 6 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonDieuChinhHSM` | `GuiHoaDonDieuChinh` |
| 7 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT` | `GuiHoaDonGoc` |
| 8 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT_V2` | `GuiHoaDonGoc` |

### API regression, không sửa riêng

- `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGocXML`.
- `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayTheXML`.
- `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinhXML`.

Ba API XML deserialize payload rồi gọi lại API lưu tương ứng; không duplicate validation và không đổi contract XML.

## Acceptance Criteria

- **AC1:** `GuiHoaDonGoc` thỏa điều kiện Hàng hóa đặc trưng loại 1, Email trống và các field khác hợp lệ không trả `Địa chỉ thư điện tử không được để trống.`.
- **AC2:** `GuiHoaDonThayThe` và `GuiHoaDonDieuChinh` cho kết quả tương tự AC1.
- **AC3:** Ba wrapper HSM và hai API MTT kế thừa đúng kết quả validation từ API lưu; lỗi validation khác vẫn dừng trước bước ký/cấp số/gửi TCT.
- **AC4:** Ba API XML gọi lại API lưu tương ứng và không phát sinh required Email của rule Hàng hóa đặc trưng loại 1.
- **AC5:** Email có dữ liệu sai định dạng, danh sách email sai hoặc vượt maxlength 50 vẫn bị từ chối theo message hiện tại.
- **AC6:** Required/maxlength của `dnmua_ten`, `dnmua_mst`, `dnmua_diachi`, `ma_tinh`, `ma_xa`, `dnmua_sdt`, `dnmua_tennguoimua` và toàn bộ field chi tiết xe giữ nguyên.
- **AC7:** Request `version` null/rỗng/khác `1` hoặc không có dòng `loaihoadondactrung = 1` giữ nguyên luồng hiện tại.
- **AC8:** Mapping `DNMua_Email`, XML `NMua/DCTDTu`, rule gửi email và rule Email riêng theo tenant hiện tại không bị sửa bởi task này.

## Ngoài phạm vi

- Không sửa frontend, `invoicecore`, Import Excel hoặc service nền.
- Không sửa DTO, API route/response, Swagger/NSwag, entity, DB/schema, XML structure, queue hoặc cấu hình.
- Không thay đổi regex, cách tách danh sách Email, maxlength 50 hoặc message lỗi hiện có.
- Không bỏ required cho trường người mua khác.
- Không sửa rule tenant riêng đang yêu cầu `Email không được để trống.` ngoài shared validator Hàng hóa đặc trưng.

## Câu hỏi mở

Không có câu hỏi nghiệp vụ chặn. Khi implementation cần kiểm tra branch đích có source test `test/WS.Application.Tests`; branch `develop_v3` hiện chỉ còn `bin/obj` tại đường dẫn này.

## Tài liệu liên quan

- `features/CBCLOUDV2-9167/plan.md`.
- `features/CBCLOUDV2-9397/` tại commit `3b4d420986bec4fafef0881df9afea4cc46aa8b2`.
- `features/CBCLOUDV2-9386/`.
- `specs/system.md` - API integration.
