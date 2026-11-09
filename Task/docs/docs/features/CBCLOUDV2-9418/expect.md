---
feature: CBCLOUDV2-9418
status: plan-review
services-affected: [invoicecore, svinvoicesendemail]
updated_at: 2026-09-09
---

# Expect - CBCLOUDV2-9418: Nâng cấp file import GTGT, Bán hàng, Vé xe

## Bối cảnh

File import GTGT, Bán hàng và Vé xe có thay đổi layout v8. Ba cột `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` là cột bổ sung độc lập của file import, không thuộc gate Nghị định 254. Nhóm Hàng hóa đặc trưng 1/xe phía sau được sắp xếp lại theo file mẫu mới. Hệ thống cũng cần đọc trạng thái bật tính năng Nghị định 254 từ Redis trước, nếu Redis không có thì fallback DB hiện tại.

Nguồn yêu cầu gồm ảnh Redis key `QLCAUHINH`, ba file Excel mẫu dưới `D:\D`, và tài liệu Word `[xb235, xb236, xb237, xb238] [xBill] [ALL] Nâng cấp file import_ GTGT, Bán hàng, Khác-v7-20260909_110520.docx`.

## Phạm vi áp dụng

- Import trực tiếp trong `invoicecore`.
- Import nền trong `svinvoicesendemail`.
- Ba loại file: GTGT, Bán hàng và Vé xe.
- Chỉ xử lý nhóm Hàng hóa đặc trưng 1 khi dòng có `loaihanghoa = 4` và `loaidactrung = 1`.
- Cờ `ACTIVE_ND_254` dùng để bật/tắt xử lý dữ liệu nâng cấp Hàng hóa đặc trưng 1.

## Yêu cầu nghiệp vụ

- Bổ sung cột `MDVQHNS` trước cụm thông tin Hàng hóa đặc trưng 1.
- `MDVQHNS` là chuỗi ký tự, không bắt buộc, tối đa 7 ký tự.
- Người dùng nhập `MDVQHNS` trong file import thì hệ thống lấy dữ liệu lên web khi tính năng Nghị định 254 đang bật.
- Khi Thuế chưa nâng cấp hoặc hệ thống tắt `ACTIVE_ND_254`, chỉ các trường thuộc nhóm Hàng hóa đặc trưng 1/xe không bắt buộc và nếu người dùng nhập thì bỏ qua dữ liệu nhóm này. Ba cột `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` vẫn được đọc/lưu theo rule riêng vì không thuộc ND254.
- Không sửa frontend trong task này, trừ việc API `GetActiveND254()` tiếp tục trả boolean cho FE theo nguồn Redis/DB mới.

## Vị trí cột theo file mẫu mới

| File | MDVQHNS | Mã quốc tịch | Quốc tịch | Loại HHDTr | Mã tỉnh | Tên tỉnh | Mã xã | Tên xã | Số khung | Số máy | Số biển kiểm soát | LastColumn |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| GTGT | L/12 | M/13 | N/14 | AO/41 | AP/42 | AQ/43 | AR/44 | AS/45 | AT/46 | AU/47 | BJ/62 | 62 |
| Bán hàng | L/12 | M/13 | N/14 | AP/42 | AQ/43 | AR/44 | AS/45 | AT/46 | AU/47 | AV/48 | BK/63 | 63 |
| Vé xe | I/9 | J/10 | K/11 | AO/41 | AP/42 | AQ/43 | AR/44 | AS/45 | AT/46 | AU/47 | BJ/62 | 62 |

Với GTGT, nhóm `DL đặc thù hóa đơn/hàng hóa` được đặt sau cùng file mẫu v8, sau thông tin người gửi hàng; code phải dịch mapping nhóm này ra cuối file để tránh đọc nhầm vào nhóm xe. `Mã tỉnh` và `Mã xã` vẫn validate theo danh mục `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong`. `Tên tỉnh` và `Tên xã` là dữ liệu cần lấy lên/lưu theo file import v8, không thay thế điều kiện validate mã.

## Acceptance Criteria

- **AC1:** File import GTGT, Bán hàng và Vé xe đọc đúng layout v8: 3 cột `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` ở vị trí mới và nhóm Hàng hóa đặc trưng 1/xe và nhóm `DL đặc thù` phía sau không bị lệch cột.
- **AC2:** `MDVQHNS` không bắt buộc; để trống vẫn import được.
- **AC3:** `MDVQHNS` có dữ liệu dài tối đa 7 ký tự thì được chấp nhận; vượt 7 ký tự thì trả lỗi maxlength rõ tên trường.
- **AC4:** Import luôn lưu `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` khi có dữ liệu hợp lệ; khi `ACTIVE_ND_254 = "1"` thì lưu thêm `Mã/Tên tỉnh xã` và nhóm Hàng hóa đặc trưng 1/xe theo mapping hiện có.
- **AC5:** Khi `ACTIVE_ND_254` thiếu, khác `"1"`, Redis lỗi và DB cũng không bật, import không bắt buộc các trường Hàng hóa đặc trưng 1/xe; nếu file có nhập thì bỏ qua dữ liệu nhóm xe, nhưng không bỏ qua `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch`.
- **AC6:** API `GetActiveND254()` ưu tiên đọc Redis Hash `QLCAUHINH`, field `ACTIVE_ND_254`; nếu không có field hoặc Redis lỗi thì fallback DB `vs_dm_ncc_cauhinh`; lỗi cuối cùng trả `false`.
- **AC7:** Import trực tiếp `invoicecore` và import nền `svinvoicesendemail` có cùng hành vi cho GTGT, Bán hàng và Vé xe.
- **AC8:** Cập nhật đủ entity/DTO/repository để các cột DB mới `ten_tinh`, `ten_xa`, `quoc_tich_nguoi_mua`, `ma_quoc_tich_nguoi_mua` được lưu/đọc.

## Ngoài phạm vi

- Không sửa giao diện Angular hoặc sinh lại NSwag proxy.
- Không đổi type/length DB của `MaDVQHNS`; maxlength 7 ký tự xử lý bằng validation import.
- Không đổi XML tag trong scope task này.
- Không sửa API tích hợp tạo hóa đơn ngoài luồng import Excel.
- Không áp dụng cho các biến thể hệ thống khác như LS/MSP/FUTA trong ticket Cloud này.

## Câu hỏi mở

| # | Câu hỏi | Người trả lời | Trạng thái |
|---|---|---|---|
| 1 | Khi `ACTIVE_ND_254` tắt, có cần bỏ qua cả `MDVQHNS` hay chỉ bỏ qua các field xe? | User | Đã chốt: `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` không thuộc ND254 nên vẫn đọc/lưu; gate chỉ áp nhóm Hàng hóa đặc trưng 1/xe. |

## Tài liệu liên quan

- `features/CBCLOUDV2-9404/`
- `features/CBCLOUDV2-9260/`
- `specs/system.md`
- `architecture.md`






