# Plan - CBCLOUDV2-9397: Đồng bộ điều kiện bắt buộc hàng hóa đặc trưng 1 cho API tích hợp

plan-status: draft

service: api-cloud-service
service-repo: ../api-cloud-service

## Câu hỏi chặn

- [x] B1: Xác nhận test suite HDDT sẽ được đặt ở đâu -> **Chốt:** tạo lại test project tối thiểu tại `test/WS.Application.Tests`, không khôi phục test unrelated từ commit tạm (2026-09-07).

## Ngoại lệ thực thi được người dùng chỉ định

- Thực hiện trực tiếp trên branch `manh/dev_v2`, không tạo `feature/CBCLOUDV2-9397`.
- Bỏ qua Gate 1 theo chỉ đạo trực tiếp trong phiên làm việc ngày 2026-09-07; `plan-status` và feature status không được AI tự đổi sang `approved`.

## Mục tiêu

Đồng bộ AC1-AC6 bằng cách sửa required condition của đúng 9 field trong shared validator API, không thay đổi maxlength hoặc contract dữ liệu đã triển khai từ CBCLOUDV2-9167.

## Bối cảnh

- API tích hợp nằm trong `api-cloud-service`, prefix `/api/services/hddtws/*`.
- Ba DTO chi tiết `ChiTietHDG`, `ChiTietTT`, `ChiTietDC` đều đi qua các overload `ValidateHangHoaDacTrungXe(...)` và hội tụ tại `ValidateHangHoaDacTrungXeValues(...)`.
- Validator chỉ được gọi khi `IsNghiDinhMoi(version)`; bên trong helper tiếp tục guard `loaiHoaDonDacTrung == 1`.

## Nguyên nhân gốc

File `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`, method `ValidateHangHoaDacTrungXeValues(...)` đang:

- Required vô điều kiện 6 field chuỗi: `maNuocSx`, `tenLoaiTaiSan`, `tenThuongMai`, `tenNhanHieu`, `kieuLoaiXe`, `theTichCongSuat`.
- Required vô điều kiện 3 field số khi nullable không có giá trị: `namSanXuat`, `trongTai`, `soChoNgoi`.

Do đó xe mới (`tinhTrangTaiSan = 0`) vẫn bị báo thiếu 9 field.

## Danh sách API cần áp dụng

### API lưu gọi validator trực tiếp

| # | Endpoint | Input | Vai trò |
|---|---|---|---|
| 1 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGoc` | `GuiHDGoc` | Lưu hóa đơn gốc |
| 2 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayThe` | `GuiHoaDonTT` | Lưu hóa đơn thay thế |
| 3 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinh` | `GuiHoaDonDC` | Lưu hóa đơn điều chỉnh |

### API kế thừa qua API lưu

| # | Endpoint | API được gọi lại |
|---|---|---|
| 4 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoadonGocHSM` | `GuiHoaDonGoc` |
| 5 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonThayTheHSM` | `GuiHoaDonThayThe` |
| 6 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonDieuChinhHSM` | `GuiHoaDonDieuChinh` |
| 7 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT` | `GuiHoaDonGoc` |
| 8 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT_V2` | `GuiHoaDonGoc` |

Không duplicate logic tại 5 wrapper. Ba API nhận XML `GuiHoaDonGocXML`, `GuiHoaDonThayTheXML`, `GuiHoaDonDieuChinhXML` gọi lại API lưu tương ứng nên chỉ thuộc phạm vi regression, không đổi contract trong task này.

## Cách làm step by step

### Step 1 - Sửa shared validator

File: `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.

1. Giữ nguyên guard `loaiHoaDonDacTrung != 1` và điều kiện gọi bên ngoài `IsNghiDinhMoi(version)`.
2. Trong `ValidateHangHoaDacTrungXeValues(...)`, khai báo `isUsedVehicle = tinhTrangTaiSan == 1`.
3. Thêm `isUsedVehicle` vào required check của 6 field chuỗi:
   `maNuocSx`, `tenLoaiTaiSan`, `tenThuongMai`, `tenNhanHieu`, `kieuLoaiXe`, `theTichCongSuat`.
4. Sửa `namSanXuat` theo thứ tự:
   invalid sentinel `int.MinValue` vẫn báo sai dữ liệu; null chỉ báo required khi `isUsedVehicle`; có giá trị vẫn kiểm tra 0-9999.
5. Sửa `trongTai` theo thứ tự:
   invalid sentinel `decimal.MinValue` vẫn báo sai dữ liệu; null chỉ báo required khi `isUsedVehicle`; có giá trị vẫn kiểm tra `decimal(9,2)`.
6. Sửa `soChoNgoi` theo thứ tự:
   invalid sentinel `int.MinValue` vẫn báo sai dữ liệu; null chỉ báo required khi `isUsedVehicle`; có giá trị vẫn kiểm tra 0-9999.
7. Không đưa các check maxlength vào nhánh `isUsedVehicle`; optional có giá trị vẫn phải validate.
8. Không thêm điều kiện `loaiTaiSan`; ô tô và mô tô/xe máy dùng cùng rule.

### Step 2 - Giữ nguyên các rule ngoài phạm vi

1. Giữ required/enum của `soKhung`, `soMay`, `loaiTaiSan`, `tinhTrangTaiSan`, `xuatXu`.
2. Giữ chứng từ bắt buộc theo `xuatXu`.
3. Giữ `chatLuongTaiSan`, `soBienKiemSoat` bắt buộc khi `tinhTrangTaiSan = 1`.
4. Giữ nguyên DTO, mapping `HD_ChiTiet_MoRong`, mapping XML và DB.
5. Không sửa riêng từng API wrapper HSM/MTT.

### Step 3 - Bổ sung automated test

1. Xe mới để trống cả 9 field: không có message required.
2. Xe đã qua sử dụng thiếu lần lượt từng field: có đúng message required.
3. Xe mới truyền sentinel/sai kiểu cho 3 field số: vẫn báo dữ liệu không hợp lệ.
4. Xe mới truyền số vượt format: vẫn báo không đúng định dạng.
5. Xe mới truyền chuỗi vượt maxlength: vẫn báo vượt quá độ dài hiện tại.
6. Case `loaiTaiSan = 1` và `loaiTaiSan = 2` cho cùng kết quả required.
7. Regression `version != 1`, subtype khác 1, chứng từ theo xuất xứ, chất lượng và biển kiểm soát.

### Step 4 - Kiểm chứng API

1. Chạy unit test tại test project HDDT sau khi B1 được chốt.
2. Build `src/hddt/WS.Application/WS.Application.csproj`.
3. Gửi request tối thiểu cho 3 API lưu với xe mới và xe đã qua sử dụng.
4. Regression 5 wrapper HSM/MTT; xác nhận lỗi validation dừng trước bước ký/cấp số/gửi TCT.
5. Regression 3 API XML wrapper để xác nhận việc dùng lại API lưu không phát sinh sai khác ngoài dự kiến.

## Thay đổi kỹ thuật

| Hạng mục | Có/Không | Chi tiết |
|---|---|---|
| Entity / migration | Không | DB và entity giữ nguyên |
| DTO / AppService | Có | Chỉ sửa shared validator trong AppService; không đổi DTO |
| Màn hình / route | Không | Không sửa FE hoặc route |
| Hàng đợi / tích hợp | Không | Không đổi queue; hành vi validate API thay đổi |
| Cấu hình | Không | Không thêm khóa cấu hình |

## Thứ tự thực hiện & phụ thuộc

Chốt B1 -> sửa shared validator -> unit test -> build -> test 3 API lưu -> regression wrapper HSM/MTT/XML -> cập nhật report/impact theo kết quả thật.

## Kế hoạch kiểm chứng

| # | Lệnh / bước kiểm | Kết quả kỳ vọng |
|---|---|---|
| 1 | `dotnet test <HDDT_TEST_CSPROJ> --no-restore` | Tất cả test pass; đường dẫn chốt tại B1 |
| 2 | `dotnet build src/hddt/WS.Application/WS.Application.csproj --no-restore` | 0 error |
| 3 | Postman/Newman gọi 3 API lưu | Xe mới bỏ trống 9 field pass; xe đã dùng thiếu field bị reject |
| 4 | Postman/Newman gọi 5 wrapper HSM/MTT | Kết quả validation đồng nhất, request lỗi không đi tiếp bước ký/gửi |
| 5 | Manual regression 3 API XML | Luồng cũ không bị ảnh hưởng |

## Ma trận rủi ro

| Rủi ro | Ảnh hưởng | Giảm thiểu | Rollback |
|---|---|---|---|
| Nới required nhầm cho xe đã dùng | Thiếu dữ liệu XML/thuế | Test đủ 9 field với `tinhTrangTaiSan = 1` | Khôi phục required cũ |
| Optional null bị đánh đồng với parse lỗi | Cho qua dữ liệu sai | Giữ sentinel `MinValue` và test riêng | Khôi phục ba block số |
| Sửa lặp tại wrapper | Lệch behavior giữa API | Chỉ sửa helper dùng chung | Revert helper |
| Lộ dữ liệu giữa tenant khi test | Rủi ro dữ liệu | Dùng tenant test và dữ liệu giả; kiểm tra tenant context | Hủy dữ liệu test |

## Ghi chú triển khai

Không cần DB, cấu hình, môi trường, queue hoặc `deploy.md`.

## Đề xuất cập nhật docs (Gate 2)

- Không đề xuất sửa `specs/system.md` hoặc `architecture.md`; đây là điều chỉnh validation của feature API đã có.
- Cập nhật `impact.md`, `testcase.md`, `report.md` trong feature sau khi triển khai.

## Phê duyệt (Gate 1) - chỉ người điền, AI không tự điền

- [ ] DEV tự review: <tên> - <ngày>
- [ ] TechLead approve: <tên> - <ngày> - <link commit/PR>
