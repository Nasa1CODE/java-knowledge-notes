---
feature: CBCLOUDV2-9403
status: testing
services-affected: [api-cloud-service]
updated_at: 2026-09-08
---

# Expect - CBCLOUDV2-9403: Bỏ trường Chất lượng tài sản trên API Hàng hóa đặc trưng 1

## Bối cảnh

CBCLOUDV2-9167 đã bổ sung `chatluongtaisan` cho API Hàng hóa đặc trưng loại 1, validate `decimal(4,2)`, bắt buộc khi `tinhtrangtaisan = 1` và map xuống `HD_ChiTiet_MoRong.cltsan`. CBCLOUDV2-9403 yêu cầu bỏ trường này khỏi API, đồng bộ nghiệp vụ với CBCLOUDV2-9404 của luồng Import.

## Đối tượng và điều kiện áp dụng

- Khách hàng tích hợp ba API lập hóa đơn gốc, thay thế và điều chỉnh cùng các wrapper HSM/MTT/XML kế thừa.
- Chỉ áp dụng cho từng phần tử `dschitiet[]` có `loaihoadondactrung = 1` khi request dùng `version = "1"` sau khi trim.
- API không có field/gate `loaihanghoa = 4` của Import Excel.
- Không bổ sung điều kiện theo `loaitaisan`, `tinhtrangtaisan` hoặc loại hóa đơn.

## Mong muốn

- Bỏ `chatluongtaisan` khỏi ba DTO chi tiết API gốc/thay thế/điều chỉnh và khỏi schema request được công bố.
- Không validate required, kiểu dữ liệu hoặc precision `4,2` của Chất lượng tài sản.
- Không map/lưu giá trị request vào `HD_ChiTiet_MoRong.cltsan`; dữ liệu mới từ API để `cltsan = null`.
- Xe đã qua sử dụng vẫn bắt buộc `sobienkiemsoat` và các trường hiện hành khác.
- Payload JSON cũ còn gửi `chatluongtaisan` không làm request lỗi chỉ vì thuộc tính dư; giá trị bị bỏ qua.
- Bỏ trường `CLTSan` khỏi XML Hàng hóa đặc trưng loại 1, kể cả khi bản ghi lịch sử còn giá trị `cltsan`.
- Dữ liệu `cltsan` cũ, entity và cột DB vẫn được giữ; task chỉ ngừng đưa giá trị đó vào XML.

## API chịu thay đổi hành vi

### API lưu trực tiếp

| # | Endpoint | Input |
|---|---|---|
| 1 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGoc` | `GuiHDGoc` / `ChiTietHDG` |
| 2 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayThe` | `GuiHoaDonTT` / `ChiTietTT` |
| 3 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinh` | `GuiHoaDonDC` / `ChiTietDC` |

### API kế thừa

| # | Endpoint | Gọi lại |
|---|---|---|
| 4 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoadonGocHSM` | `GuiHoaDonGoc` |
| 5 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonThayTheHSM` | `GuiHoaDonThayThe` |
| 6 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonDieuChinhHSM` | `GuiHoaDonDieuChinh` |
| 7 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT` | `GuiHoaDonGoc` |
| 8 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT_V2` | `GuiHoaDonGoc` |
| 9 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGocXML` | `GuiHoaDonGoc` |
| 10 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayTheXML` | `GuiHoaDonThayThe` |
| 11 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinhXML` | `GuiHoaDonDieuChinh` |

## Acceptance Criteria

- **AC1:** Ba DTO chi tiết API không còn công bố property `chatluongtaisan` trong request schema.
- **AC2:** Ba API lưu nhận request `version = "1"`, subtype 1, xe đã qua sử dụng, không có Chất lượng tài sản nhưng đủ field còn lại mà không trả message chứa `Chất lượng tài sản`.
- **AC3:** Nếu JSON cũ vẫn gửi `chatluongtaisan` null, chuỗi, số hợp lệ hoặc số vượt `4,2`, API không validate field này và không lưu xuống `cltsan`.
- **AC4:** Ba wrapper HSM và hai API MTT kế thừa đúng hành vi mới; lỗi validation khác vẫn dừng trước ký/cấp số/gửi TCT.
- **AC5:** Xe đã qua sử dụng thiếu `sobienkiemsoat` vẫn trả lỗi bắt buộc; required/enum/maxlength/định dạng của mọi field đặc trưng khác giữ nguyên.
- **AC6:** Request `version` null/rỗng/khác `1` hoặc subtype null/2/3 giữ hành vi hiện tại, không kích hoạt rule subtype 1 mới.
- **AC7:** Bản ghi mới tạo qua API có `cltsan = null`, `sbksoat` và các field còn lại được map đúng.
- **AC8:** XML sinh cho Hàng hóa đặc trưng loại 1 không còn phần tử có `TTruong = "CLTSan"`, áp dụng cả hóa đơn mới và hóa đơn lịch sử.
- **AC9:** Không xóa entity/cột DB `cltsan` và không cập nhật dữ liệu cũ; việc bỏ XML không cần migration.

## Ngoài phạm vi

- Không sửa frontend, `invoicecore`, Import Excel hoặc `svinvoicesendemail`.
- Không đổi route, response, authentication, authorization, tenant routing, queue hoặc config.
- Không drop/rename cột DB và không tạo migration.
- Không cập nhật/xóa dữ liệu `cltsan` lịch sử trong DB.
- Không sửa field Hàng hóa đặc trưng loại 1 khác.

## Giả định

- Newtonsoft JSON hiện tại bỏ qua property dư, nên client cũ còn gửi `chatluongtaisan` vẫn gọi được API nhưng giá trị không còn tác dụng.
- Với wrapper XML input, cần regression payload có/không có node tương ứng; XML output đều không được sinh `CLTSan`.

## Câu hỏi mở

Không có câu hỏi nghiệp vụ chặn. TechLead cần xác nhận việc xóa property khỏi Swagger/NSwag là thay đổi contract được chấp nhận tại Gate 1.

## Tài liệu liên quan

- `features/CBCLOUDV2-9167/`
- `features/CBCLOUDV2-9397/`
- `features/CBCLOUDV2-9404/`
- `specs/system.md`
