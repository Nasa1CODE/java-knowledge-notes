---
feature: CBCLOUDV2-9418
plan-status: plan-review
services-affected: [invoicecore, svinvoicesendemail]
service-repos: [../invoicecore, ../svinvoicesendemail]
owner: AI
created_at: 2026-09-09
updated_at: 2026-09-09
---

# Plan - CBCLOUDV2-9418: Nâng cấp file import GTGT, Bán hàng, Vé xe

## 1. Blocking questions

Không có câu hỏi chặn implementation. Đã chốt: `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` không thuộc Nghị định 254 nên không bị gate bởi `ACTIVE_ND_254`; gate chỉ áp dụng nhóm Hàng hóa đặc trưng 1/xe.

## 2. Approach summary

Cập nhật layout import v8 của GTGT, Bán hàng và Vé xe. Ba cột `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` là dữ liệu bổ sung độc lập, không phụ thuộc Nghị định 254. Nhóm Hàng hóa đặc trưng 1/xe phía sau được gate bằng `ACTIVE_ND_254`. Cập nhật `GetActiveND254()` đọc Redis Hash `QLCAUHINH` trước, fallback DB nếu cache miss/lỗi.

## 3. Requirement trace

| AC | Covered by |
|---|---|
| AC1 | §5.1, §5.2 |
| AC2 | §5.1, §5.3 |
| AC3 | §5.3 |
| AC4 | §5.4 |
| AC5 | §5.5 |
| AC6 | §5.6 |
| AC7 | §5.2, §6 |
| AC8 | §7, §8, §10 |

## 4. Affected services

| Service | Severity | Main change |
|---|---|---|
| `invoicecore` | Trung bình | Import trực tiếp, API `GetActiveND254()`, entity/DTO/mapping `HD_HoaDon_MoRong` |
| `svinvoicesendemail` | Trung bình | Import nền GTGT/Bán hàng/Vé xe, mapping `MaDVQHNS` |
| `docs` | Thấp | Feature docs, DB docs và token report |

## 5. Detailed design

### 5.1 Layout cột file mẫu v8

Ba cột `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` là cột bổ sung độc lập, không thuộc rule/gate Nghị định 254. Các cột từ `Mã tỉnh`, `Tên tỉnh`, `Mã xã`, `Tên xã` trở đi thuộc nhóm Hàng hóa đặc trưng 1/xe và chịu gate `ACTIVE_ND_254`.

| Loại import | `MaDVQHNS` | `MaQuocTichNguoiMua` | `QuocTichNguoiMua` | `LoaiHangHoaDacTrung` | `MaTinh` | `TenTinh` | `MaXa` | `TenXa` | `SoKhung` | `SoMay` | `SoBienKiemSoat` | `LastColumn` |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| GTGT | 12 | 13 | 14 | 41 | 42 | 43 | 44 | 45 | 46 | 47 | 62 | 62 |
| Bán hàng | 12 | 13 | 14 | 42 | 43 | 44 | 45 | 46 | 47 | 48 | 63 | 63 |
| Vé xe | 9 | 10 | 11 | 41 | 42 | 43 | 44 | 45 | 46 | 47 | 62 | 62 |

Các cột xe sau `SoMay` dịch tuần tự theo file v8: `LoaiTaiSan`, `TinhTrangTaiSan`, `XuatXu`, `SoGCN`, `SoSeri`, `MaNuocSX`, `TenLoaiTaiSanDangKy`, `NamSanXuat`, `TenThuongMai`, `TenNhanHieu`, `KieuLoaiXe`, `TheTichLamViecHoacCongSuat`, `TrongTai`, `SoNguoiChoPhepCho`, `SoBienKiemSoat`. Với GTGT, các cột `DL đặc thù hóa đơn/hàng hóa` chuyển ra sau thông tin người gửi hàng, tương ứng 68-77; không còn đọc ở 46-55.

### 5.2 Đồng bộ direct/background

- `invoicecore` và `svinvoicesendemail` phải dùng cùng mapping vị trí cột.
- Ba gate `IsNewVehicleAssetImportTemplate/IsNewTemplate` đổi theo `LastColumn` v8: GTGT 77, Bán hàng 68, Vé xe 65.
- Không dùng mapping v7 cũ; layout v8 được xác định bằng tổng cột và loại file import.

### 5.3 Validate dữ liệu mới

- `MDVQHNS`: không bắt buộc, nếu có dữ liệu thì trim và kiểm tra `Length <= 7`; rule này không phụ thuộc ND254.
- `Mã quốc tịch`, `Quốc tịch`: không bắt buộc, trim trước khi lưu; không phụ thuộc ND254.
- `Mã tỉnh`, `Mã xã`: giữ validate theo `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` khi ND254 bật.
- `Tên tỉnh`, `Tên xã`: đọc/lưu cùng nhóm tỉnh xã khi ND254 bật.
- Khi ND254 tắt: chỉ bỏ qua validate/lưu nhóm Hàng hóa đặc trưng 1/xe, không bỏ qua ba cột `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch`.

### 5.4 Lưu dữ liệu

- Thêm field import nếu thiếu trong `HoaDonRow` của worker; `invoicecore` đã có property `MaDVQHNS`.
- Khi `checkSaveMoRong/HasHoaDonMoRongFields` chạy, coi `MaDVQHNS`, `MaQuocTichNguoiMua`, `QuocTichNguoiMua` là dấu hiệu tạo `HD_HoaDon_MoRong` độc lập ND254; các field tỉnh/xã/xe chỉ tạo/lưu theo gate ND254.
- Gán `MaDVQHNS`, `ma_quoc_tich_nguoi_mua`, `quoc_tich_nguoi_mua`; khi ND254 bật thì gán thêm `ma_tinh`, `ten_tinh`, `ma_xa`, `ten_xa` và nhóm xe.
- XML hiện có lấy `MDVQHNSach` từ `HD_HoaDon_MoRong.MaDVQHNS`, nên không sửa XML tag.

### 5.5 Tắt Nghị định 254 thì bỏ qua dữ liệu nâng cấp

- Khi flag ND254 false:
  - Không validate required/maxlength của nhóm field Hàng hóa đặc trưng 1/xe.
  - Không lưu `Ma_Tinh`, `Ten_Tinh`, `Ma_Xa`, `Ten_Xa` và chi tiết xe.
  - Vẫn đọc/lưu `MaDVQHNS`, `Ma_Quoc_Tich_Nguoi_Mua`, `Quoc_Tich_Nguoi_Mua` vì 3 cột này không thuộc ND254.
  - Nếu user nhập dữ liệu nhóm xe, import vẫn đi tiếp như tài liệu Word yêu cầu.
- Giữ các field cũ không thuộc nhóm nâng cấp và các validation hóa đơn/hàng hóa hiện tại.

### 5.6 Đọc `ACTIVE_ND_254` từ Redis trước, fallback DB

File: `aspnet-core/src/hddt/HDDT.Application/AppServices/CauHinh/DoanhNghiep_ThongTinChungAppService.cs`.

- Inject Redis theo pattern hiện có của `invoicecore`, ưu tiên `StackExchange.Redis.IConnectionMultiplexer` nếu project đã đăng ký.
- Đọc Redis Hash:
  - key: `QLCAUHINH`
  - field: `ACTIVE_ND_254`
  - bật khi value đúng `"1"` sau trim.
- Cache miss, field thiếu, value khác `"1"`, Redis lỗi hoặc parse lỗi: fallback DB như logic hiện tại:
  - `_dm_NCC_CauHinhRepository.GetAll().Any(x => x.CauHinh_Ma == "ACTIVE_ND_254" && x.CauHinh_GiaTri == "1")`
  - Không lọc `DaiLy_Id`.
- Nếu DB cũng lỗi thì trả `false`.

## 6. Implementation order

1. Kiểm tra branch/status hai repo, giữ nguyên thay đổi đang có từ các task trước.
2. Sửa `GetActiveND254()` trong `invoicecore` để đọc Redis trước, fallback DB.
3. Sửa import trực tiếp `invoicecore`: thêm đọc `MaDVQHNS`, cập nhật mapping cột GTGT/Bán hàng/Vé xe, validate maxlength, mapping `HD_HoaDon_MoRong`.
4. Sửa import nền `svinvoicesendemail`: thêm field `MaDVQHNS`, cập nhật ba router và helper chung.
5. Bổ sung test source/unit cho direct và worker.
6. Build/test từng repo bằng lệnh cụ thể ở §11.
7. Cập nhật report, impact, deploy và token report.

## 7. Database changes

Schema tenant cần có thêm bốn cột nullable trong `vs_hd_tonghop_morong`: `ten_tinh`, `ten_xa`, `quoc_tich_nguoi_mua`, `ma_quoc_tich_nguoi_mua`. `MaDVQHNS` đã tồn tại với `varchar(255) NULL`; task chỉ siết maxlength ở validation import là 7 ký tự, không đổi DB type.

## 8. Configuration changes

- Redis Hash `QLCAUHINH`, field `ACTIVE_ND_254`.
- DB fallback `vs_dm_ncc_cauhinh.CauHinh_Ma = ACTIVE_ND_254`.
- Không thêm secret hoặc appsettings key mới.

## 9. Integration surfaces

| Surface | Impact |
|---|---|
| REST API | `GetActiveND254()` giữ response boolean, không đổi contract. |
| Queue/worker | Không đổi queue name/DTO ngoài nội bộ model import worker. |
| XML | Không đổi trong scope task; nếu XML cần thêm field mới thì tạo task riêng. |
| Excel template | Có đổi layout cột; cần phát hành file mẫu runtime cùng code. |
| Frontend | Không sửa code FE; FE nhận boolean cũ từ API. |

## 10. Out of scope

- Không sửa Angular component/proxy.
- Không đổi API import ngoài Excel.
- Không đổi XML schema/tag.
- Không hỗ trợ song song layout cũ bằng dò header nếu không có yêu cầu mới.
- Không triển khai cho LS/MSP/FUTA trong ticket Cloud.

## 11. Verification plan

| # | Lệnh / bước kiểm | Kết quả kỳ vọng |
|---|---|---|
| 1 | `dotnet build aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore --verbosity minimal` | Build thành công, 0 error |
| 2 | `dotnet test aspnet-core/test/VS.Tests/VS.Tests.csproj --no-restore --verbosity quiet` | Test liên quan import pass nếu project reference local hợp lệ |
| 3 | `dotnet test AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj --no-restore --verbosity quiet` trong `svinvoicesendemail` | Worker tests pass |
| 4 | Manual import GTGT/Bán hàng/Vé xe với `ACTIVE_ND_254=1` trên Redis | Lưu `MDVQHNS`, lưu nhóm field xe, hiển thị lên web |
| 5 | Manual import GTGT/Bán hàng/Vé xe khi Redis/DB không bật `ACTIVE_ND_254` | Không lỗi required nhóm nâng cấp, không lưu/không hiển thị dữ liệu nâng cấp |
| 6 | Manual kiểm file mẫu tải từ API | Cột `MDVQHNS` và thứ tự cột khớp file mẫu mới |

## 12. Risk matrix

| Rủi ro | Ảnh hưởng | Giảm thiểu | Rollback |
|---|---|---|---|
| Lệch cột sau khi thêm `MDVQHNS` | Import sai dữ liệu hàng hóa đặc trưng 1 | Test ba layout GTGT/BH/Vé xe và kiểm workbook mẫu | Revert mapping cột |
| Redis value khác format | FE thấy flag sai | Trim value, chỉ bật khi `"1"`, fallback DB khi miss/lỗi | Revert `GetActiveND254()` về DB |
| ND254 tắt nhưng vẫn lưu nhóm xe mới | Không đúng yêu cầu Thuế chưa nâng cấp | Gate validate/save nhóm xe bằng flag; không gate 3 cột bổ sung độc lập | Revert hoặc tắt flag |

## 13. Deploy notes

- Phát hành file mẫu Excel runtime cho GTGT, Bán hàng và Vé xe cùng thời điểm deploy code.
- Cấu hình Redis `QLCAUHINH.ACTIVE_ND_254 = 1` khi muốn bật xử lý nâng cấp.
- Nếu Redis chưa có key/field, hệ thống fallback DB hiện tại.



