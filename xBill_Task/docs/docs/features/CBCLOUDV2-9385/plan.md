---
feature: CBCLOUDV2-9385
title: Bỏ bắt buộc Địa chỉ thư điện tử trên API Hàng hóa đặc trưng 1
plan-status: testing
service: api-cloud-service
service-repo: ../api-cloud-service
services-affected: [api-cloud-service]
owner: DEV + AI
created_at: 2026-09-08
updated_at: 2026-09-08
---

# Plan - CBCLOUDV2-9385

## 1. Mục tiêu

Bỏ duy nhất required `dnmua_email` trong shared validator người mua của Hàng hóa đặc trưng loại 1. Không đổi API contract, mapping, XML, maxlength hoặc validation Email khi có dữ liệu.

## 2. Căn cứ xác định phạm vi API

- Tài liệu CBCLOUDV2-9397 tại commit docs `3b4d420986bec4fafef0881df9afea4cc46aa8b2` xác định ba API lưu và năm wrapper HSM/MTT dùng chung validation.
- Source `GuiHoaDonAppService.cs` xác nhận ba hàm `ValidateHDGoc(...)`, `ValidateHDTT(...)`, `ValidateHDDC(...)` đều gọi `ValidateNguoiMuaDacTrungXe(...)`.
- Ba wrapper HSM và hai API MTT gọi lại API lưu, không có validator Email đặc trưng riêng.
- Ba wrapper XML deserialize request và gọi lại API lưu tương ứng, nên chỉ cần regression.

## 3. Điều kiện kích hoạt chính xác

Shared buyer validator chỉ chạy khi:

```csharp
IsNghiDinhMoi(version)
&& dschitiet != null
&& dschitiet.Any(x => x?.loaihoadondactrung == 1)
```

Tương ứng code hiện tại:

```csharp
HasHangHoaDacTrungXeMoi(version, dschitiet)
```

- `IsNghiDinhMoi(version)` chỉ true khi `version` khác rỗng và `version.Trim() == "1"`.
- Không thêm `loaihanghoa == 4`: field này thuộc mô hình Import, không phải gate hiện tại của API.
- Không thêm điều kiện theo `loaitaisan`, `tinhtrangtaisan` hoặc loại hóa đơn.

## 4. Danh sách API cần áp dụng

### 4.1. Ba API lưu gọi validator trực tiếp

| # | Endpoint | Validation entry |
|---|---|---|
| 1 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGoc` | `ValidateHDGoc(GuiHDGoc, ...)` |
| 2 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayThe` | `ValidateHDTT(GuiHoaDonTT, ...)` |
| 3 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinh` | `ValidateHDDC(GuiHoaDonDC, ...)` |

### 4.2. Năm API kế thừa, không sửa duplicate logic

| # | Endpoint | Gọi lại |
|---|---|---|
| 4 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoadonGocHSM` | `GuiHoaDonGoc` |
| 5 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonThayTheHSM` | `GuiHoaDonThayThe` |
| 6 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonDieuChinhHSM` | `GuiHoaDonDieuChinh` |
| 7 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT` | `GuiHoaDonGoc` |
| 8 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT_V2` | `GuiHoaDonGoc` |

### 4.3. Ba API XML chỉ regression

| Endpoint | Gọi lại |
|---|---|
| `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGocXML` | `GuiHoaDonGoc` |
| `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayTheXML` | `GuiHoaDonThayThe` |
| `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinhXML` | `GuiHoaDonDieuChinh` |

## 5. Thiết kế chi tiết

### 5.1. Sửa shared buyer validator

- **File:** `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.
- **Method:** `ValidateNguoiMuaDacTrungXeValues(...)`.
- Xóa duy nhất check:

```csharp
if (string.IsNullOrWhiteSpace(email))
    message += "Địa chỉ thư điện tử không được để trống.";
```

- Không sửa ba overload `ValidateNguoiMuaDacTrungXe(...)` và không sửa `HasHangHoaDacTrungXeMoi(...)`; nhờ đó phạm vi vẫn bị gate bởi `version = 1` và subtype 1.

### 5.2. Validation Email có dữ liệu giữ nguyên

- Giữ `IsTooLong(email, 50)` trong shared validator đặc trưng.
- Giữ `IsValidMailAddress(...)` và logic tách danh sách Email bằng `,`/`;` tại `ValidateHDGoc`, `ValidateHDTT`, `ValidateHDDC`.
- Không đổi message `Email không đúng định dạng.` hoặc `Địa chỉ thư điện tử không được vượt quá 50 ký tự.`.
- Không sửa required `Email không được để trống.` riêng của tenant hiện tại; đây là rule độc lập ngoài task.

### 5.3. Mapping và XML giữ nguyên

- Vẫn map `input.dnmua_email` vào `HD_HoaDon.DNMua_Email`; khi trống giữ cách lưu chuỗi rỗng hiện tại.
- Không sửa helper lấy Email đầu tiên cho `HDon/DLHDon/NDHDon/NMua/DCTDTu` khi Email có nhiều giá trị.
- Không sửa `NMua/TTKhac/TTin`, luồng gửi Email hoặc dữ liệu đã lưu.

### 5.4. Các required khác giữ nguyên

Giữ required và maxlength hiện tại của:

- `dnmua_ten` / Tên.
- `dnmua_mst` / Mã số thuế.
- `dnmua_diachi` / Địa chỉ.
- `ma_tinh`, `ma_xa`.
- `dnmua_sdt` / Số điện thoại.
- `dnmua_tennguoimua` / Họ và tên người mua hàng.
- Toàn bộ field Hàng hóa đặc trưng trong `ValidateHangHoaDacTrungXeValues(...)`.

## 6. Automated test

Trên branch implementation, dùng test project `test/WS.Application.Tests/WS.Application.Tests.csproj` theo pattern CBCLOUDV2-9397. Nếu branch đích chưa có source test project nhưng chỉ có `bin/obj`, tạo lại test project tối thiểu đúng pattern đã chốt ở CBCLOUDV2-9397; không sử dụng build artifact làm source.

Các test bắt buộc:

1. Gate true, Email null/rỗng/whitespace: không có message required Email đặc trưng.
2. Gate true, Email dài 51 byte: vẫn có message maxlength 50.
3. Gate false: validator đặc trưng trả rỗng và không thay đổi luồng cũ.
4. Negative gate cho `version` null/rỗng/khác `1` và subtype null/2/3.
5. Thiếu từng buyer field khác: vẫn có đúng message required.
6. Email có dữ liệu sai định dạng hoặc danh sách chứa phần tử sai: vẫn bị reject ở ba validation entry.
7. Regression mapping Email có dữ liệu và Email trống.

## 7. Thứ tự triển khai

1. Khóa đúng repo/branch `api-cloud-service`; không sửa repo khác.
2. Xóa một required check Email trong shared validator.
3. Cập nhật/tạo test source theo §6.
4. Chạy unit test và build `WS.Application`.
5. Test ba API lưu với request Email trống, hợp lệ, sai định dạng và vượt maxlength.
6. Regression ba HSM, hai MTT và ba wrapper XML; request lỗi phải dừng trước side effect.
7. Cập nhật `tasks.md`, `testcase.md`, `impact.md`, tạo `report.md` từ output thật.

## 8. Kế hoạch kiểm chứng

| # | Kiểm chứng | Kết quả kỳ vọng |
|---|---|---|
| 1 | `dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal` | Tất cả test pass; có case Email optional và gate subtype 1 |
| 2 | `dotnet build src/hddt/WS.Application/WS.Application.csproj --no-restore --verbosity minimal` | Build thành công, 0 error |
| 3 | Postman/Newman ba API lưu | Email trống không báo required đặc trưng; invalid/maxlength vẫn lỗi |
| 4 | Manual ba wrapper HSM | Validation đồng nhất; request lỗi không gọi HSM |
| 5 | Manual hai API MTT | Validation đồng nhất; request lỗi không cấp số/ký/gửi TCT |
| 6 | Manual ba wrapper XML | Deserialize và gọi lại API lưu đúng hành vi mới |

## 9. Thay đổi kỹ thuật

| Hạng mục | Thay đổi |
|---|---|
| API route/request/response | Không |
| DTO/entity/mapping | Không |
| Database/migration | Không |
| XML schema/rendering | Không |
| Queue/config/dependency | Không |
| Validation behavior | Có, nới duy nhất required Email của rule đặc trưng loại 1 |

## 10. Rủi ro và rollback

| Rủi ro | Mức | Giảm thiểu / rollback |
|---|---|---|
| Xóa nhầm format hoặc maxlength | Trung bình | Diff chỉ xóa required; test invalid và 51 byte; rollback một dòng |
| Mở rộng sang request không phải subtype 1 | Trung bình | Giữ nguyên `HasHangHoaDacTrungXeMoi`; test negative gate |
| Wrapper tiếp tục side effect khi có lỗi khác | Cao | Regression HSM/MTT với request lỗi trước ký/cấp số/gửi TCT |
| Nhầm required đặc trưng với rule tenant riêng | Trung bình | Không sửa block tenant; testcase riêng |
| Không có source test trên branch | Trung bình | Tạo lại test project tối thiểu theo pattern 9397, không dùng `bin/obj` |

## 11. Tương thích và docs

- Backward compatible về contract và dữ liệu; chỉ nới validation trong đúng phạm vi.
- Multi-tenant context và authorization không đổi.
- Không cần `deploy.md`.
- `specs/system.md`, `architecture.md`, `design.md`, `databases/`: N/A vì không đổi contract, kiến trúc, UI hoặc schema.

## 12. Câu hỏi mở

Không có câu hỏi nghiệp vụ chặn. Branch implementation phải được DEV chỉ định trước khi code nếu không dùng branch hiện tại.

## 13. Sai lệch trong lúc triển khai

- Branch `develop_v3` không có source test project, chỉ còn artifact `bin/obj`. Đã tạo test project tối thiểu và một file test riêng cho CBCLOUDV2-9385 theo pattern test của CBCLOUDV2-9397 trong object docs/source đã đối chiếu; không mang code nghiệp vụ của task khác vào branch.
- Lần chạy build song song với test gặp khóa file `VS.Core.Shared.dll` (`CS2012`). Đây là xung đột tiến trình kiểm thử; build tuần tự sau đó thành công với 0 error.
- Lần chạy test đầu tiên có một fixture truyền thiếu `hoTenNguoiMua`, đã sửa dữ liệu test. Không thay đổi production code ngoài dòng required Email đã nêu trong Plan.
- Chưa chạy API manual do cần tenant, authentication và môi trường tích hợp HSM/MTT/CQT. Các testcase tương ứng giữ `not run`.
