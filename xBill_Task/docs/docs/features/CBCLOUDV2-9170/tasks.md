# CBCLOUDV2-9170 Tasks

## Cập nhật 2026-09-08 — trạng thái hiện tại

Các kết quả build bên dưới là ghi nhận lịch sử, không xác minh các patch mới. Đợt cập nhật này không chạy build/DB/QA trình duyệt.

- [x] Điều kiện bắt buộc xe đã qua sử dụng theo bảng tại [expect.md](expect.md#quy-tắc-bắt-buộc-cho-chi-tiết-xe); `TTai` chỉ bắt buộc với ô tô đã qua sử dụng.
- [x] Bỏ `CLTSan` khỏi UI/validation/XML ba service; giữ persistence legacy. Panel 17 trường, XML nhóm xe 15 trường.
- [x] `MNSXuat` là combobox tìm kiếm mã/tên từ `DM_NCC_QuocTich`, lưu mã tối đa 2 ký tự.
- [x] Đăng ký provider Quốc tịch trong `service-proxy.module.ts`; không sửa generated proxy trong đợt này.
- [x] Tỉnh/Thành phố, Mã Tỉnh/Thành phố, Xã/Phường, Mã Xã/Phường cùng một dòng desktop.
- [x] Quốc tịch có placeholder tiếng Việt; xóa hộ chiếu đặt tên/mã về `undefined` và ẩn control.
- [x] CSS combobox xe cao 30px và padding `!important` để ghi đè padding global `.btn`.
- [ ] QA giao diện sau patch cuối, lưu/reload quốc tịch và mã nước sản xuất (TC35–TC40).
- [ ] Sửa Dapper CreateDataInv loại bỏ mở rộng chỉ có dữ liệu xe (TC41).
- [ ] Sửa DapperInsertInv gắn sai `ChiTiet_Id` do ghép hai danh sách khác độ dài theo chỉ số (TC42).
- [x] Sửa DapperUpdateInv ghi nhận và chuẩn hóa chi tiết mở rộng (TC43).
- [x] Giải quyết lệch giới hạn `TTai`: sửa UI từ 9 chữ số nguyên (hiểu sai `9,2`) thành đúng `decimal(9,2)` = 7 chữ số nguyên + 2 thập phân, nằm gọn trong `decimal(10,2)` của DB (TC44).
- [x] Fix rò rỉ dữ liệu hàng hóa đặc trưng: chuẩn hóa làm sạch các trường `HD_ChiTiet_MoRong` cũ khi đổi loại hàng hóa != 4 hoặc đổi subtype xe/vận tải (cả BE và FE).
- [x] Xử lý sao chép hóa đơn khi chưa bật cấu hình `ACTIVE_ND_254`: loại bỏ thông tin đặc trưng xe mới NĐ 254 và tỉnh/xã, chuẩn hóa chi tiết copy (Task 2i).

Phần persistence header đã có sáu trường snapshot; nhánh Dapper được chọn khi một hóa đơn có hơn 150 dòng.

## Task 2i - Xử lý sao chép hóa đơn khi chưa kích hoạt cấu hình ACTIVE_ND_254

- Status: completed (code complete, BE dotnet build 0 error, FE tsc 0 error, manual QA pending)
- Area/service: `invoicecore` (`HoaDonAppService.cs`)
- Description: Khi thực hiện sao chép hóa đơn (`CopyHoaDon`):
  1. Kiểm tra cờ cấu hình `ACTIVE_ND_254` (Redis hash `QLCAUHINH` key `ACTIVE_ND_254`, fallback DB `vs_dm_ncc_cauhinh`).
  2. Nếu cấu hình chưa kích hoạt (`activeND254 == false`):
     - Xóa các trường địa điểm đăng ký phương tiện NĐ 254 mới trên header (`HD_HoaDon_MoRong`: `Ma_Tinh`, `Ten_Tinh`, `Ma_Xa`, `Ten_Xa`).
     - Xóa 16 trường hàng hóa đặc trưng xe mới theo NĐ 254 trên các dòng chi tiết (`HD_ChiTiet_MoRong`: `LTSan`, `TTTSan`, `XXu`, `SGCNATKThuat`, `SSPKTCLXXuong`, `MNSXuat`, `TLTSDKy`, `NSXuat`, `TTMai`, `TNHieu`, `KLXe`, `TTLVHCSuat`, `TTai`, `SCNgoi`, `CLTSan`, `SBKSoat`).
     - Giữ nguyên các trường xe đã có trước NĐ 254 (`So_Khung`, `So_May`), nhóm vận tải (Nhóm B), và phân loại `Loai_HangHoa_DacTrung` (đồng bộ với gate import `ClearInactiveND254VehicleAssetFields`).
  3. Chuẩn hóa dữ liệu dòng chi tiết: luôn gọi `NormalizeHangHoaDacTrungFields(ctmr, chiTiet.HangHoa_Loai)` trước khi insert chi tiết mở rộng của hóa đơn copy để dọn dẹp các trường đặc trưng rác nếu dòng gốc bị lệch loại.
- Acceptance criteria:
  - [x] Thêm helper `IsActiveND254Async()` trong `HoaDonAppService.cs` đọc Redis `QLCAUHINH:ACTIVE_ND_254` và fallback DB `vs_dm_ncc_cauhinh`.
  - [x] Thêm helper `ClearHangHoaDacTrungND254Fields(ctmr)` và `ClearHoaDonMoRongND254Fields(hdmr)`.
  - [x] Trong `CopyHoaDon`: tích hợp kiểm tra cấu hình, làm sạch header mở rộng và chi tiết mở rộng khi cấu hình tắt.
  - [x] Trong `CopyHoaDon`: luôn gọi `NormalizeHangHoaDacTrungFields(ctmr, chiTiet.HangHoa_Loai)` trên chi tiết mở rộng trước khi lưu.
  - [x] Biên dịch: `HDDT.Application.csproj` build thành công 0 error.
  - [ ] QA thủ công: sao chép hóa đơn khi cấu hình tắt và bật để xác nhận đúng dữ liệu mong đợi.
- Verification:
  - `dotnet build src/hddt/HDDT.Application/HDDT.Application.csproj` → 0 error.

## Task 2h - Fix rơi rớt dữ liệu hàng hóa đặc trưng cũ khi đổi loại hàng hóa / subtype

- Status: completed (code complete, BE dotnet build 0 error, FE tsc 0 error, manual QA pending)
- Area/service: `invoicecore` (`HoaDonAppService.cs`), `frontend_angular` (`hoadon.service.ts`, `hoadon-goc.component.ts`, `hoadonbanhang.component.ts`)
- Description: Khi người dùng đổi loại hàng hóa khỏi loại 4 (hoặc đổi giữa phân loại Xe và Vận tải), các trường dữ liệu đặc trưng cũ trong `HD_ChiTiet_MoRong` (`vs_hd_chitiet_morong`) không bị xóa mà vẫn bị lưu vào CSDL. Thực hiện chuẩn hóa dữ liệu 2 chiều trên 2 màn hình hóa đơn chính (Frontend làm sạch UI model trên Hóa đơn gốc & Hóa đơn bán hàng + Backend làm sạch persistence).
- Acceptance criteria:
  - [x] `HoaDonService.normalizeHangHoaDacTrungFields(ctmr, hangHoaLoai)` tại `hoadon.service.ts`: chuẩn hóa Nhóm A (17 trường xe + legacy `cltSan`), Nhóm B (5 trường vận tải), và `loai_HangHoa_DacTrung` theo đúng ma trận nghiệp vụ. Bảo toàn tuyệt đối các trường dùng chung.
  - [x] `hoadon-goc.component.ts` (màn Hóa đơn gốc): gọi `normalizeHangHoaDacTrungFields` trong `chonHangHoaLoai`, `ChangeHangHoaDacTrung` và GET load; không new đè object `hD_ChiTiet_MoRong` nếu đã tồn tại khi chọn `event == 4`.
  - [x] `hoadonbanhang.component.ts` (màn Hóa đơn bán hàng): gọi `normalizeHangHoaDacTrungFields` trong `chonHangHoaLoai`, `ChangeHangHoaDacTrung` và GET load; không new đè object khi `event == 4`.
  - [x] `HoaDonAppService.cs`: thêm `NormalizeHangHoaDacTrungFields(ctmr, hangHoaLoai)` và các helper xóa Nhóm A/B; gọi trong `Create()` và `Update()`.
  - [x] `HoaDonAppService.Update()`: xử lý trường hợp `ctmr == null` nhưng dòng đã tồn tại trong DB (`ctMoi.Id > 0`) và chuyển khỏi loại 4: truy vấn bản ghi cũ trong CSDL qua `_chiTietMRRepository`, nếu có dữ liệu đặc trưng cũ thì làm sạch và cập nhật.
  - [x] Phạm vi áp dụng frontend giới hạn đúng 2 màn hình: `hoadon-goc` và `hoadonbanhang`.
  - [x] Biên dịch: `HDDT.Application.csproj` build thành công 0 error; `frontend_angular` tsc check thành công 0 error.
  - [ ] QA thủ công: kiểm tra các luồng lưu, mở lại, đổi loại hàng hóa, đổi subtype.
- Verification:
  - `dotnet build src/hddt/HDDT.Application/HDDT.Application.csproj` → 0 error.
  - `npx tsc -p src/tsconfig.json --noEmit` → exit 0.

## Task 2g - Fix lệch cột bảng chi tiết hóa đơn gốc (`hoadon-goc`, `hoadonbanhang`)

- Status: fix complete, build chưa chạy (frontend), manual QA pending
- Area/service: `frontend_angular/` — `hoadon-goc.component.html`, `hoadon-goc.component.ts`, `hoadonbanhang.component.ts`
- Description: Hai nguyên nhân lệch cột độc lập, cùng ảnh hưởng bảng "hóa đơn gốc":
  1. (`hoadon-goc.component.html`) Cột `Tiền thuế` (`TienThue`) đặt `*ngIf="item.hangHoa_MaThue != undefined"` ngay trên thẻ `<td>`, trong khi header `<th>` tương ứng không có điều kiện (luôn render). Khi một dòng gốc có `hangHoa_MaThue` rỗng/undefined (thường gặp ở dòng hàng hóa đặc trưng/xe), cả ô `<td>` bị bỏ qua hoàn toàn khiến các cột phía sau bị dồn lệch sang trái.
  2. (`hoadon-goc.component.ts` và `hoadonbanhang.component.ts`) `getInvoiceDetailColumnCount()` — dùng làm `[attr.colspan]` cho dòng panel chi tiết hàng hóa đặc trưng (xe) chỉ đọc — không cộng hai cột `Số khung`/`Số máy` (`soKhungColunm`/`soMayColunm`, cùng điều kiện `&& !hasSpecialVehicle()` với `<th>` tương ứng trong header). Khi hai cột này đang hiển thị (tức `hasSpecialVehicle()` còn `false` vì hóa đơn điều chỉnh mới tạo chưa có dòng xe nào ở `dsChiTiet`), `colspan` bị thiếu 2 so với số cột header thực tế → panel/dòng bị lệch ngay khi load. Sau khi người dùng chọn loại hàng hóa xe (4) ở một dòng chi tiết bên dưới, `hasSpecialVehicle()` chuyển `true`, header tự ẩn đúng 2 cột đó, số cột header hiện tại tình cờ khớp lại với `colspan` vốn luôn thiếu 2 — tạo cảm giác "chọn hàng hóa thì hiện đúng" như user báo cáo, dù bản chất `getInvoiceDetailColumnCount()` vẫn sai công thức.
- Acceptance criteria:
  - [x] `hoadon-goc.component.html` dòng ~1260: bỏ `*ngIf` khỏi `<td>` cột `TienThue` của bảng hóa đơn gốc, chuyển điều kiện `item.hangHoa_MaThue != undefined` vào `<input>` bên trong (giống pattern dòng ~1744-1748 của bảng điều chỉnh).
  - [x] Xác nhận `hoadonbanhang.component.html` không có bug tương tự cột `TienThue`: bảng hóa đơn gốc ở đây không có cột này, và toàn bộ điều kiện `*ngIf` trên `<td>` khớp đúng với `<th>` tương ứng (đối chiếu toàn bộ header/body).
  - [x] `hoadon-goc.component.ts` `getInvoiceDetailColumnCount()`: thêm `if (this.soKhungColunm && !this.hasSpecialVehicle()) count++;` và tương tự cho `soMayColunm`, khớp đúng điều kiện `<th>`/`<td>` của hai cột này.
  - [x] `hoadonbanhang.component.ts` `getInvoiceDetailColumnCount()`: xác nhận có cùng cặp cột `soKhungColunm`/`soMayColunm` với cùng điều kiện `&& !hasSpecialVehicle()` trong `.html`; áp dụng fix tương tự.
  - [ ] Build lại frontend — chưa chạy trong phiên này.
  - [ ] QA thủ công: mở hóa đơn điều chỉnh (`loaiHoaDon=5`) có dòng hóa đơn gốc với `hangHoa_MaThue` rỗng (đặc biệt dòng hàng hóa đặc trưng/xe) VÀ chưa chọn hàng hóa xe ở dòng điều chỉnh bên dưới (để `Số khung`/`Số máy` còn hiển thị ở header); xác nhận toàn bộ giá trị dòng gốc và panel chi tiết xe nằm đúng cột header ngay khi load, không cần chọn hàng hóa mới đúng.
- Verification: Chưa build, chưa QA thủ công.

## Task 2f - Fix sai giới hạn `TTai` (hiểu sai ký hiệu `decimal 9,2`)

- Status: fix complete, build chưa chạy (frontend), manual QA pending
- Area/service: `frontend_angular/` — `hoadonbanhang.component`, `hoadon-goc.component`, `input-number` usage
- Description: Đợt trước hiểu `TTai decimal 9,2` là "9 chữ số nguyên + 2 chữ số thập phân" nên set `maxIntegerDigits="9"`; đúng ra `decimal(9,2)` là ký hiệu `decimal(precision, scale)` chuẩn — tổng 9 chữ số có nghĩa, scale 2, nên phần nguyên chỉ có `9 - 2 = 7` chữ số. Sửa lại `maxIntegerDigits` từ `9` xuống `7` và regex validate `parseVehicleDecimal` từ `\d{1,9}` xuống `\d{1,7}` ở cả hai màn; đồng thời điều này khiến `decimal(9,2)` luôn nằm trong `decimal(10,2)` của DB, không còn cần đổi schema.
- Acceptance criteria:
  - [x] `hoadonbanhang.component.html`: `input-number` của `tTai` đổi `maxIntegerDigits="9"` → `"7"`, `maxlength="12"` → `"10"`.
  - [x] `hoadon-goc.component.html`: tương tự.
  - [x] `hoadonbanhang.component.ts` và `hoadon-goc.component.ts`: `parseVehicleDecimal` regex `\d{1,9}` → `\d{1,7}`; message lỗi cập nhật "tối đa 7 chữ số phần nguyên".
  - [ ] Build lại frontend — chưa chạy trong phiên này.
  - [ ] QA thủ công: nhập `TTai` với 8 chữ số phần nguyên bị chặn/báo lỗi; giá trị tối đa hợp lệ `9999999.99` lưu được qua EF/Dapper không lỗi DB.
- Verification: Chưa build, chưa QA thủ công.

## Task 2e - Fix bug: điều kiện xe không kích hoạt ở 4 luồng hóa đơn thường (`TDiep`)

- Status: fix complete, build verified, manual QA pending
- Area/service: `api-cloud-service` (BE/API), `invoicecore` (BE)
- Description: Task 2d thêm điều kiện xe cho PBan nhưng 4 luồng "hóa đơn thường" nạp hóa đơn bằng `GetAsync(id)` phẳng (không `Include DSChiTiet`), dự án không bật lazy loading proxies nên `DSChiTiet` luôn `null` tại các điểm này → điều kiện xe luôn `false`, PBan không bao giờ lên `2.1.1`. Chi tiết tại [expect.md](expect.md#cập-nhật-ngày-2026-09-14--fix-bug-điều-kiện-xe-không-kích-hoạt-ở-4-luồng-hóa-đơn-thường-tdiep).
- Acceptance criteria:
  - [x] `api-cloud-service` `TCTAppService.GuiTCT(int, bool?)`: nạp `hdObj` có `Include(DSChiTiet).ThenInclude(HD_ChiTiet_MoRong)`.
  - [x] `invoicecore` `HoaDonAppService.GuiTCT(int, bool?, string, string)`: nạp `hdObj` có Include tương tự.
  - [x] `invoicecore` `HoaDonAppService.GuiHdSaiSotDenTCT`: nạp `hdObj` có Include tương tự.
  - [x] `invoicecore` `HoaDonAppService.UploadFileDaKySaiSot`: nạp `hdObj` có Include tương tự.
  - [x] Xác nhận luồng POS/MTT không bị lỗi này (đã dùng `GetIncludeAll`/`Include` sẵn có).
  - [x] Build `HDDT.Application.csproj` và `WS.Application.csproj` độc lập với `dotnet build --no-restore`: cả hai 0 Error.
  - [ ] QA thủ công: gửi TCT một hóa đơn thường (không phải POS) có dòng xe qua cả 4 luồng, xác nhận XML `TDiep` xuất `PBan=2.1.1`.
- Verification: Build 0 Error đã xác minh trong phiên này; chưa QA thủ công XML thực tế.

## Task 3b - Validate người mua bắt buộc khi có hàng hóa đặc trưng xe (subtype 1)

- Status: implementation complete, build/QA pending
- Area/service: `frontend_angular/` — `hoadonbanhang.component`, `hoadon-goc.component`
- Description: Đổi rule bắt buộc thông tin người mua khi `hasSpecialVehicle()` true: thêm bắt buộc `Tên đơn vị` (`dnMua_Ten`) và `MST/CCCD chủ hộ` (`dnMua_MST`); bỏ bắt buộc `CCCD` (`dnMua_CCCD`). Giữ nguyên bắt buộc `Địa chỉ`/`Số điện thoại`. Chi tiết tại [expect.md](expect.md#cập-nhật-ngày-2026-09-11--validate-người-mua-khi-có-hàng-hóa-đặc-trưng-xe-subtype-1).
- Acceptance criteria:
  - [x] `hoadonbanhang.component.html`: nhãn `MST/CCCD chủ hộ` và `Tên đơn vị` thêm `*` đỏ khi `hasSpecialVehicle()`; nhãn `CCCD` bỏ `*` đỏ.
  - [x] `hoadonbanhang.component.ts` `getVehicleValidationError()`: bỏ check `dnMua_CCCD` bắt buộc, thêm check `dnMua_Ten` và `dnMua_MST` bắt buộc.
  - [x] `hoadon-goc.component.html`/`.ts` áp dụng đồng nhất (hàm `getVehicleValidationErrors()`).
  - [x] Xác nhận `vemaybay.component.ts` không có logic `hasSpecialVehicle()` liên quan nên không cần sửa.
  - [ ] Build lại frontend sau đợt sửa — chưa chạy trong phiên này.
  - [ ] QA thủ công trên trình duyệt: hóa đơn có dòng xe subtype 1 không còn bị chặn Lưu/Trình ký/Ký khi thiếu CCCD nhưng bị chặn khi thiếu Tên đơn vị hoặc MST/CCCD chủ hộ; hóa đơn không có dòng xe giữ rule cũ.
- Verification: Chưa build, chưa QA thủ công trên trình duyệt.

## Task 2d - PBan thẻ `TDiep` (phong bì gửi TCT) cho hóa đơn thường và MTT

- Status: implementation complete, build/QA pending
- Area/service: `api-cloud-service` (BE/API), `invoicecore` (BE), `export-zip-pdf-service`, `invoice-senddata2tct-service`
- Description: Nâng `TTChung.PBan` của phong bì `TDiep` (khác vị trí với `TTChung.PBan` bên trong hóa đơn ở Task 2b) lên `2.1.1` có điều kiện khi hóa đơn/lô POS có dòng hàng hóa đặc trưng xe (`HangHoa_Loai == 4` và `Loai_HangHoa_DacTrung == 1`); không có dữ liệu xe thì giữ baseline cũ của từng service (`2.1.0` hoặc `2.0.1`). Xem chi tiết 7 file tại [expect.md](expect.md#cập-nhật-ngày-2026-09-11--pban-thẻ-tdiep-phong-bì-gửi-tct).
- Acceptance criteria:
  - [x] `api-cloud-service`: `TCTAppService.GetThongDiepRequest` (hóa đơn thường), `GuiHoaDonAppService.GetThongDiepPosRequest` và `HoaDonHelper.GetThongDiepPosRequest` (POS) áp dụng điều kiện xe; 2 call site truyền `lstInv` rỗng trước đó đã sửa để truyền hóa đơn thực tế.
  - [x] `invoicecore`: `HoaDonAppService.GetThongDiepRequest` (hóa đơn thường, gồm 2 luồng gửi lại sai sót) và `GetThongDiepPosRequest`, `QuanLyHoaDonPosAppService.GetTTChung` (POS) áp dụng điều kiện xe.
  - [x] `QuanLyHoaDonPosAppService.GetHDonXML` bổ sung `item.DSChiTiet = inv.DSChiTiet;` để điều kiện xe đọc được dữ liệu (trước đó dữ liệu clone EF không được copy ngược).
  - [x] `export-zip-pdf-service` và `invoice-senddata2tct-service`: `MixPosInvService.GetTTChung` (POS) áp dụng điều kiện xe, giữ baseline `2.0.1`.
  - [x] `api-qldv-service` bị loại khỏi phạm vi theo quyết định user (entity thiếu trường xe); không sửa.
  - [ ] Build lại `api-cloud-service`, `invoicecore`, `export-zip-pdf-service`, `invoice-senddata2tct-service` sau đợt sửa — chưa chạy trong phiên này.
  - [ ] QA thủ công: gửi TCT một hóa đơn thường có dòng xe và một lô POS có dòng xe, xác nhận file XML `TDiep` xuất `PBan=2.1.1`; hóa đơn/lô không xe giữ baseline cũ.
- Verification: Chưa build, chưa QA thủ công XML thực tế.

## Task 1 - Danh mục địa điểm host

- Status: implementation complete, verification pending
- Area/service: HDDT host catalog
- Description: Thêm `DM_TinhThanh`, `DM_XaPhuong` với cột snake_case rõ ràng, DTO, mapper, DbSet và application service.
- Acceptance criteria:
  - [x] Có API lấy tỉnh không phân trang và lấy phường/xã theo tỉnh.
  - [x] API dùng prefix `hddt`.
  - [x] `maTinh` null trả toàn bộ phường/xã; giá trị non-null lọc theo tỉnh.
- Verification: Trong phiên triển khai, route `hddt` đã trả `401` khi chưa xác thực; cần xác minh lại bằng API có xác thực.

## Task 2 - Persistence hóa đơn tenant

- Status: header implementation complete; Dapper detail persistence incomplete; verification pending
- Area/service: HDDT Core/EF/Dapper
- Description: Header `HD_HoaDon_MoRong` đã có đủ snapshot tên/mã tỉnh, xã và quốc tịch qua entity, DTO, EF, Dapper repository `Add`/`AddRange`/`Update` và projection hạn chế. Nhánh `CreateDataInv`/`UpdateDataInv` cho hóa đơn trên 150 dòng chưa hoàn tất persistence `HD_ChiTiet_MoRong`; xem TC41–TC43.
- Acceptance criteria:
  - [x] Các cột tenant `ma_tinh`/`ma_xa` được sử dụng.
- [x] Đã sửa tám parameter header cũ bị thiếu ở luồng `AddRange`; đồng thời thêm `Ma_Tinh`/`Ma_Xa`.
- [x] Các guard persistence tạo/cập nhật `HD_HoaDon_MoRong` khi chỉ có `Ma_Tinh` hoặc `Ma_Xa`, tránh mất dữ liệu địa điểm trên hóa đơn xe.
  - [x] Có file migration `database/2026-08-14-add-tinh-xa-to-vs_hd_tonghop_morong-and-danhmuc.sql` (ALTER header + CREATE 2 danh mục + cột `tinhthanh_ma`); dữ liệu danh mục import riêng.
- Verification: Targeted build từng ghi nhận 0 errors trong phiên triển khai; cần rerun trong pipeline/release. Migration cần chạy trên DB tenant/host trước QA.

## Task 2b - XML CQT trường đặc trưng xe

- Status: implementation complete, verification pending
- Area/service: `invoicecore` HDDT Application, `invoice-sendmail-service/ConsumerApplication` và `export-zip-pdf-service/Common`
- Description: Ba `HoaDonTT3268Utility.GetTHHDTrung` emit 15 trường xe vào `TTHHDTrung/TTin` (mỗi item `LHHDTrung`/`TTruong`/`DLieu`); thêm constant mã trường vào `ConstantTTin`. Domain worker bổ sung property xe để nạp dữ liệu DB.
- Acceptance criteria:
  - [x] Chỉ emit trường khi có giá trị và `Loai_HangHoa_DacTrung.HasValue`.
  - [x] Decimal (`TTai`) dùng `InvariantCulture`; số nguyên `ToString(InvariantCulture)`.
  - [x] Tái sử dụng constant `NSXuat` sẵn có; 14 constant xe còn lại; đã loại constant `CLTSan`.
  - [x] `GetTTChungInfo` nâng `TTChung.PBan` lên `2.1.1` khi có ít nhất 1 trong 15 trường xe (helper `HasVehicleDacTrungField`); khi không có dữ liệu xe, mỗi service giữ baseline PBan hiện hữu.
- [x] `SendMailConsumerApp.csproj` và `ZipPdfInvConsumer.csproj` build 0 errors sau khi port XML.
- [x] Khi có dữ liệu xe, ba generator map bắt buộc `NMua/DChi`, `SDThoai`, `DCTDTu`, `CCCDan` từ người mua sau nhánh mẫu/POS; hóa đơn thường giữ logic cũ.
- Verification: Chưa kiểm tra XML thực tế gửi CQT; cần build BE + so khớp schema TT32/68.

## Task 2c - XML CQT mã tỉnh/xã người mua (NMua)

- Status: implementation complete, verification pending
- Area/service: `invoicecore` XML `NMua`, `invoice-sendmail-service/ConsumerApplication` và `export-zip-pdf-service/Common`
- Description: Thêm 2 thẻ `MTinh` (dài 3) / `MXa` (dài 8) vào `HDon\DLHDon\NDHDon\NMua`, điền từ `HD_HoaDon_MoRong.Ma_Tinh`/`Ma_Xa`; domain worker map hai cột DB để utility có dữ liệu xuất XML.
- Acceptance criteria:
  - [x] Thẻ đặt trong `NMua`, trước `MKHang` theo thứ tự spec.
  - [x] Chỉ emit khi có giá trị (hóa đơn thường không phát sinh thẻ rỗng).
- Verification: Chưa kiểm tra XML thực tế; cần build BE + xác nhận độ dài/thứ tự theo Điểm a.1.1, khoản 5, Phụ lục Nghị định 254.

## Task 3 - Giao diện địa điểm và validation

- Status: implementation complete, manual QA pending
- Area/service: `frontend_angular/`
- Description: Thêm combobox tỉnh/phường có tìm kiếm dưới địa chỉ người mua, bind header, cascade, refresh selectpicker, panel 17 trường/validation Lưu-Trình ký-Ký trên `hoadon-goc` và `hoadonbanhang`. Panel xe của hóa đơn gốc (chỉ đọc) chỉ gồm 17 trường xe (bỏ Tỉnh/Xã để đồng nhất với panel nhập liệu); `hoadonbanhang` bổ sung panel xe gốc chỉ đọc (state `panelXeAnGoc`, helper `tenLoaiTaiSan`/`tenTinhTrangTaiSan`/`tenXuatXu`) khớp `hoadon-goc`. Ở bảng chi tiết bán hàng, bọc dòng chi tiết và panel xe trong cùng `ng-container *ngFor` để giữ scope `item`/`i`; chuyển cột `Loại HHĐT` ngay sau cột `Loại` theo `hoadon-goc`.
- Acceptance criteria:
- [x] Chỉ yêu cầu tỉnh/xã khi `hangHoa_Loai == 4`, có chi tiết mở rộng và subtype xe 1.
  - [x] Chọn tỉnh nạp lại danh sách phường/xã.
  - [x] Panel xe gốc chỉ đọc trên cả `hoadon-goc` và `hoadonbanhang` gồm cùng 17 trường xe, không hiển thị Tỉnh/Xã trong panel; các trường mã hiển thị nhãn tiếng Việt.
  - [x] Hóa đơn điều chỉnh (`getHoaDonGoc`, ví dụ `loaiHoaDon == 5`) kế thừa `ma_Tinh`/`ma_Xa` từ `hoaDonGoc.hD_HoaDon_MoRong`; combo Tỉnh/Xã đổ đúng giá trị gốc, không rỗng.
  - [x] `hoadonbanhang` giữ nguyên subtype hàng hóa đặc trưng 2/3; panel xe chỉ render cho subtype 1.
  - [x] Panel xe dùng scope `item`/`i` của cùng vòng lặp; không còn đọc `item.indexKey` ngoài scope.
  - [x] Cột `Loại HHĐT` đứng ngay sau cột `Loại` trên bảng chi tiết `hoadonbanhang`.
  - [x] Khi có dòng xe subtype 1, `hoadonbanhang` ẩn cột bảng `Số khung`/`Số máy`; dữ liệu chỉ nhập trong panel xe, tránh lặp control.
  - [x] Table `hoadonbanhang` chiếm toàn bộ container để panel xe và bảng có cùng chiều rộng.
  - [x] Với xe subtype 1, cả hai màn yêu cầu Địa chỉ, SĐT, Email và CCCD người mua; label có `*` đỏ, validation xe chặn action khi thiếu.
  - [x] Cả `hoadon-goc` và `hoadonbanhang` giới hạn nhập theo contract: chuỗi dùng `maxlength`, `NSXuat`/`SCNgoi` 4 chữ số, `TTai` đúng `decimal(9,2)` (7 nguyên + 2 thập phân); validation action kiểm tra lại độ dài chuỗi và định dạng số.
  - [x] `TTai` nhận dấu `,` hoặc `.` thập phân và chuẩn hóa về model số; modal xem trước không dereference `hoaDon` khi luồng preview không truyền invoice.
- Verification: Chưa QA thủ công; build frontend bị chặn bởi `node-sass` không hỗ trợ Node runtime hiện tại.

## Task 4 - Contract proxy frontend

- Status: done with follow-up
- Area/service: `frontend_angular/service-proxies`
- Description: Điều chỉnh proxy sinh tạm thời để gọi route `hddt` đúng thực tế.
- Acceptance criteria:
  - [x] Không còn gọi nhầm `/api/services/app/...` cho hai API địa điểm.
  - [ ] Chạy lại `nswag/refresh.bat` từ backend đang chạy để thay thế thay đổi thủ công.
- Verification: Cần chạy lại sinh proxy trong quy trình deploy.

## Task 5 - Build và QA tích hợp

- Status: pending
- Area/service: backend, frontend, API, DB
- Acceptance criteria:
  - [x] Targeted backend builds 0 errors; Application có 203 warnings hiện hữu.
  - [ ] Full `VS.Web.sln` build.
  - [ ] Build frontend tái lập được sau cập nhật `hoadonbanhang`.
  - [ ] QA API có xác thực, persistence DB và UI theo `testcase.md`.
- Blockers/notes: Full solution bị chặn bởi thiếu `TraceIdMiddleware.Tests.csproj` và lock. `npm run build` hiện lỗi `error:0308010C:digital envelope routines::unsupported` nếu không có OpenSSL legacy; lần chạy có `NODE_OPTIONS=--openssl-legacy-provider` chỉ trả cảnh báo npm mà không có output compiler, nên frontend chưa có bằng chứng build tái lập được.
