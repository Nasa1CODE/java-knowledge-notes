# CBCLOUDV2-9170 Impact

## Cập nhật ảnh hưởng 2026-09-08

- Frontend: hai template hóa đơn đổi nhãn/bố cục địa điểm thành một dòng desktop; Quốc tịch có placeholder tiếng Việt, xóa tên/mã model (`undefined`) khi bỏ hộ chiếu; combobox MNSXuat dùng danh mục quốc tịch. Không suy ra quốc tịch từ số hộ chiếu.
- `service-proxy.module.ts`: đăng ký `DM_NCC_QuocTichServiceProxy` khắc phục NullInjectorError; không sửa generated proxy trong đợt này.
- CSS `hoadon-goc.component.scss` và `hoadonbanhang.component.css`: style bootstrap-select chỉ trong panel xe, cao 30px, padding `!important` thắng `.btn` global; cần QA chữ/caret/focus/disabled trên trình duyệt sau patch cuối.
- Validation: bắt buộc có điều kiện theo xe đã qua sử dụng; `TTai` chỉ bắt buộc với ô tô đã qua sử dụng. Quy tắc đầy đủ tại [expect.md](expect.md).
- `CLTSan`: không còn UI/validation/XML/detection/constant ở ba generator; giữ persistence legacy, không DROP cột. Panel 17 trường và nhóm XML xe 15 trường.
- Header có sáu snapshot địa điểm/quốc tịch; XML đọc tên/mã snapshot, không tra lại host. Quốc tịch dùng danh mục admin sẵn có, không seed lại.
- **Blocker Dapper chưa sửa:** hóa đơn trên 150 dòng bị guard create bỏ dữ liệu xe; create có thể ghép sai ID dòng mở rộng; update chưa ghi mở rộng chi tiết. SQL repository có cột mới không đủ để kết luận end-to-end hoàn tất. Xem TC41–TC43.
- **Đã giải quyết (2026-09-14):** TTai UI trước đây hiểu sai `decimal 9,2` thành 9 chữ số nguyên; sửa lại đúng `decimal(9,2)` = 7 chữ số nguyên + 2 thập phân, nằm gọn trong DB `decimal(10,2)`. Xem mục cập nhật bên dưới.
- Không chạy build/DB/QA tích hợp cho patch mới; các bằng chứng build phía dưới chỉ là lịch sử. Không sửa Excel import trong đợt này.

## Cập nhật ảnh hưởng 2026-09-14 — Fix lệch cột bảng chi tiết hóa đơn gốc (`hoadon-goc`, `hoadonbanhang`)

- Nguyên nhân 1 (`hoadon-goc.component.html`): cột `Tiền thuế` (`TienThue`) trong bảng hóa đơn gốc đặt `*ngIf="item.hangHoa_MaThue != undefined"` trực tiếp trên `<td>` trong khi `<th>` header luôn render (không điều kiện) — khi dòng gốc có `hangHoa_MaThue` rỗng, toàn bộ `<td>` bị loại khỏi DOM khiến các cột sau (`Kho`, `SoHD`, `Hành động`) dồn lệch sang trái so với header.
- Sửa 1: bỏ `*ngIf` khỏi `<td>`, chuyển điều kiện vào `<input>` bên trong ô — theo đúng pattern đã dùng ở bảng chi tiết hóa đơn điều chỉnh (editable) trong cùng file. Đã đối chiếu `hoadonbanhang.component.html`: bảng hóa đơn gốc ở đây không có cột `TienThue` nên không có bug tương tự ở điểm này.
- Nguyên nhân 2 (`hoadon-goc.component.ts` và `hoadonbanhang.component.ts`), theo phản hồi tiếp theo của user ("hiện trạng khi tôi chọn ở hàng hóa chi tiết bên dưới thì sẽ hiện đúng chắc là do chỗ tính cộng cột"): `getInvoiceDetailColumnCount()` (dùng làm `[attr.colspan]` cho dòng panel chi tiết hàng hóa đặc trưng xe chỉ đọc) không cộng hai cột `Số khung`/`Số máy` (`soKhungColunm`/`soMayColunm`), trong khi `<th>` của hai cột này hiển thị có điều kiện `&& !hasSpecialVehicle()`. Khi hóa đơn điều chỉnh mới tạo chưa có dòng xe nào ở `dsChiTiet` hiện tại, `hasSpecialVehicle()` (chỉ kiểm tra hóa đơn hiện tại, không phải hóa đơn gốc) trả `false` nên hai cột này vẫn hiện ở header, nhưng `colspan` bị thiếu 2 → panel lệch ngay khi load. Sau khi user chọn loại hàng hóa xe (4) ở dòng chi tiết bên dưới, `hasSpecialVehicle()` chuyển `true`, header tự ẩn đúng 2 cột đó nên số cột thực tế tình cờ khớp lại với `colspan` vốn luôn thiếu 2 — đây là lý do user thấy "chọn hàng hóa thì hiện đúng".
- Sửa 2: thêm `if (this.soKhungColunm && !this.hasSpecialVehicle()) count++;` và tương tự cho `soMayColunm` vào `getInvoiceDetailColumnCount()` của cả hai file, khớp đúng điều kiện hiển thị thực tế của `<th>`/`<td>` hai cột này (đã xác nhận `hoadonbanhang.component.html` có cùng cặp `<th>`/`<td>` `soKhungColunm`/`soMayColunm` với cùng điều kiện `&& !hasSpecialVehicle()`, không phải bị ẩn hẳn như ghi nhận trước đó).
- Chỉ đổi `hoadon-goc.component.html`, `hoadon-goc.component.ts`, `hoadonbanhang.component.ts`; không đổi logic tính tiền/thuế hay dữ liệu backend.
- Chưa build frontend, chưa QA thủ công trong phiên sửa này.

## Cập nhật ảnh hưởng 2026-09-14 — Sửa sai giới hạn `TTai` (`decimal 9,2`)

- Nguyên nhân: hiểu sai ký hiệu `decimal 9,2` (chuẩn `decimal(precision, scale)`, tổng 9 chữ số có nghĩa, scale 2 → phần nguyên 7 chữ số) thành "9 chữ số nguyên + 2 chữ số thập phân"; đã set `maxIntegerDigits="9"` và regex `\d{1,9}` sai.
- Sửa: `hoadonbanhang.component.html`/`hoadon-goc.component.html` đổi `maxIntegerDigits` 9→7, `maxlength` 12→10; `hoadonbanhang.component.ts`/`hoadon-goc.component.ts` đổi regex `parseVehicleDecimal` từ `\d{1,9}` thành `\d{1,7}`, cập nhật message lỗi.
- Hệ quả tích cực: `decimal(9,2)` (7 nguyên + 2 thập phân) luôn nằm trong `decimal(10,2)` của DB (8 nguyên + 2 thập phân) → không còn lệch miền giá trị UI/DB, không cần đổi schema.
- Chỉ đổi frontend validation/UI limit, không đổi entity, DTO, API hay database.
- Chưa build frontend, chưa QA thủ công trong phiên sửa này.

## Cập nhật ảnh hưởng 2026-09-14 — Fix bug điều kiện xe không kích hoạt (4 luồng hóa đơn thường)

- Nguyên nhân: `TCTAppService.GuiTCT`, `HoaDonAppService.GuiTCT`/`GuiHdSaiSotDenTCT`/`UploadFileDaKySaiSot` nạp hóa đơn bằng `GetAsync(id)` phẳng, không `Include DSChiTiet`; dự án không bật `UseLazyLoadingProxies` nên điều kiện xe (Task 2d) luôn `false`, PBan `TDiep` không bao giờ lên `2.1.1` cho hóa đơn thường dù có dòng xe.
- Sửa 4 điểm nạp `hdObj` thêm `.Include(x => x.DSChiTiet).ThenInclude(c => c.HD_ChiTiet_MoRong)`; không đổi logic nghiệp vụ khác, không đổi DTO/contract.
- Luồng POS/MTT không bị ảnh hưởng (đã Include sẵn từ trước).
- Đã build `HDDT.Application.csproj` (invoicecore) và `WS.Application.csproj` (api-cloud-service) độc lập, 0 Error cả hai. Chưa QA thủ công gửi TCT thực tế.

## Cập nhật ảnh hưởng 2026-09-11 — Validate người mua khi có hàng hóa đặc trưng xe

- `hoadonbanhang.component` và `hoadon-goc.component` (`.html` + `.ts`): khi `hasSpecialVehicle()` true, đổi `Tên đơn vị`/`MST/CCCD chủ hộ` thành bắt buộc, bỏ bắt buộc `CCCD`; `Địa chỉ`/`Số điện thoại` giữ nguyên bắt buộc.
- Không ảnh hưởng backend/API/XML — chỉ đổi validate phía UI (nhãn `*` đỏ và message chặn Lưu/Trình ký/Ký), không đổi entity, DTO hay dữ liệu gửi CQT.
- `vemaybay.component.ts` xác nhận không dùng `hasSpecialVehicle()` nên không bị ảnh hưởng.
- Chưa build frontend, chưa QA thủ công trên trình duyệt trong phiên sửa này.

## Cập nhật ảnh hưởng 2026-09-11 — PBan thẻ `TDiep`

- Phạm vi khác với PBan bên trong hóa đơn (mục XML CQT ở trên): đây là `TTChung.PBan` của **phong bì `TDiep`** gửi TCT — nâng lên `2.1.1` có điều kiện khi hóa đơn/lô POS có dòng hàng hóa đặc trưng xe, giữ baseline cũ khi không có dữ liệu xe.
- 4 service bị ảnh hưởng, 7 file: `api-cloud-service` (`TCTAppService.cs`, `GuiHoaDonAppService.cs`, `HoaDonHelper.cs`), `invoicecore` (`HoaDonAppService.cs`, `QuanLyHoaDonPosAppService.cs`), `export-zip-pdf-service` và `invoice-senddata2tct-service` (`MixPosInvConsumer/Services/MixPosInvService.cs`).
- Kèm 1 fix dữ liệu tiên quyết trong `QuanLyHoaDonPosAppService.GetHDonXML` (copy `DSChiTiet` ngược lại object gốc sau khi clone EF) và 3 call site sửa từ truyền list hóa đơn rỗng sang truyền hóa đơn thực tế (2 ở `api-cloud-service`), nếu không điều kiện xe sẽ luôn `false`.
- Phát hiện khoảng trống dữ liệu: entity `HD_ChiTiet_MoRong` của `invoice-senddata2tct-service` thiếu 14/15 trường xe chi tiết, chỉ còn `Loai_HangHoa_DacTrung`; helper detect ở service này dùng quy tắc gốc (`HangHoa_Loai==4 && Loai_HangHoa_DacTrung==1`) thay vì kiểm tra field-by-field như 3 service kia.
- `api-qldv-service` loại khỏi phạm vi theo quyết định user (entity không có trường xe đặc trưng); giữ nguyên `PBan="2.0.0"` không điều kiện.
- `invoice-sendmail-service`/`svinvoicesendemail` xác nhận không có code dựng phong bì `TDiep` gửi TCT nên không có gì để sửa.
- Chưa build lại 4 service và chưa QA thủ công XML `TDiep` thực tế trong phiên triển khai này.

## Purpose

CBCLOUDV2-9170 bổ sung lựa chọn Tỉnh/Thành phố và Phường/Xã cấp đầu hóa đơn cho hàng hóa đặc trưng loại xe, sử dụng danh mục host và lưu mã trên hóa đơn tenant.

## Phạm vi ảnh hưởng / Change scope

Thay đổi gồm backend, contract sinh proxy và frontend. Đây không còn là thay đổi frontend-only.

| Khu vực | Mức | Ảnh hưởng |
| --- | --- | --- |
| Host catalog | High | `DM_TinhThanh`/`DM_XaPhuong`, DTO, mapper, DbSet và endpoint danh mục; dùng các bảng host `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong`. |
| Tenant invoice persistence | High | Header `HD_HoaDon_MoRong` đã có sáu snapshot địa điểm/quốc tịch trong EF, Dapper repository và projection. Chi tiết `HD_ChiTiet_MoRong` ở nhánh hóa đơn trên 150 dòng chưa hoàn tất: create có thể bỏ hoặc gắn sai mở rộng, update chưa ghi mở rộng. |
| API contract/proxy | Medium | Endpoint phải dùng `/api/services/hddt/`; proxy Angular đang có điều chỉnh tạm thời. |
| Angular hóa đơn | High | `hoadon-goc` và `hoadonbanhang` có combobox tìm kiếm, cascade, bind header, refresh selectpicker, panel 17 trường và validation Lưu/Trình ký/Ký cho subtype xe 1. Panel xe gốc chỉ đọc trên cả hai màn đồng nhất 17 trường (Tỉnh/Xã bỏ khỏi panel, chỉ đặt dưới địa chỉ người mua); `hoadonbanhang` thêm panel xe gốc chỉ đọc (`panelXeAnGoc` + helper nhãn `tenLoaiTaiSan`/`tenTinhTrangTaiSan`/`tenXuatXu`). `hoadonbanhang` bọc dòng chi tiết/panel xe trong cùng vòng lặp để giữ scope, đặt cột `Loại HHĐT` ngay sau `Loại`, ẩn cột bảng `Số khung`/`Số máy` khi có dòng xe để tránh lặp control, và ép table `width: 100%` để panel cùng chiều rộng bảng. Xe subtype 1 yêu cầu thêm Địa chỉ, SĐT, Email, CCCD người mua; hai màn giới hạn ký tự chuỗi/số ngay khi nhập và kiểm tra lại trước action. |
| Kế thừa hóa đơn điều chỉnh | Medium | `getHoaDonGoc()` trong `hoadon.service.ts` (dùng chung cả hai màn) kế thừa thêm `ma_Tinh`/`ma_Xa` từ `hoaDonGoc.hD_HoaDon_MoRong` cùng nhóm thông tin người mua, để hóa đơn điều chỉnh (`loaiHoaDon=5`) không bị rỗng combo Tỉnh/Xã. |
| Xem trước hóa đơn | Medium | `XemHoaDonModalComponent.close` guard `hoaDon` trước khi đọc loại/trạng thái, tránh lỗi close với luồng preview chuyển đổi/phân trang không truyền invoice. |
| XML CQT (TThông tin đặc trưng) | Medium | `HoaDonTT3268Utility.GetTHHDTrung` của `invoicecore`, `invoice-sendmail-service` và `export-zip-pdf-service` bổ sung 15 trường xe (`LTSan`, `TTTSan`, `XXu`, `SGCNATKThuat`, `SSPKTCLXXuong`, `MNSXuat`, `TLTSDKy`, `NSXuat`, `TTMai`, `TNHieu`, `KLXe`, `TTLVHCSuat`, `TTai`, `SCNgoi`, `SBKSoat`) vào `TTHHDTrung/TTin`; constant mã trường thêm ở `ConstantTTin`. Chỉ emit khi trường có giá trị và dòng thuộc loại đặc trưng. |
| XML CQT (NMua) | Medium | `NMua` của `invoicecore`, `invoice-sendmail-service` và `export-zip-pdf-service` thêm `MTinh` (dài 3) và `MXa` (dài 8), điền từ `HD_HoaDon_MoRong.Ma_Tinh`/`Ma_Xa` trong `GetNMuaInfo`. Chỉ emit khi có giá trị. Điểm a.1.1, khoản 5, Phụ lục Nghị định 254. |
| PBan phong bì `TDiep` gửi TCT | Medium | `api-cloud-service` (`TCTAppService.cs`, `GuiHoaDonAppService.cs`, `HoaDonHelper.cs`), `invoicecore` (`HoaDonAppService.cs`, `QuanLyHoaDonPosAppService.cs`), `export-zip-pdf-service`, `invoice-senddata2tct-service` nâng `TTChung.PBan` của `TDiep` lên `2.1.1` có điều kiện xe cho cả hóa đơn thường và POS; giữ baseline cũ khi không có dữ liệu xe. `api-qldv-service` loại khỏi phạm vi. |
| Schema/migration | Medium | Có file migration `database/2026-08-14-add-tinh-xa-to-vs_hd_tonghop_morong-and-danhmuc.sql`: ALTER `vs_hd_tonghop_morong` thêm `ma_tinh`/`ma_xa`, CREATE `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` (+ cột `tinhthanh_ma`). Dữ liệu danh mục import riêng. |
| Kiến trúc/tài liệu chung | None | Không có thay đổi kiến trúc hệ thống nên không cập nhật docs/spec/architecture chung. |

## Không thuộc phạm vi / Confirmed unaffected

- Queue, job bất đồng bộ, event và message contract: không thay đổi. `invoice-sendmail-service` và `export-zip-pdf-service` chỉ thay đổi domain model và XML utility để materialize/xuất dữ liệu mới.
- Tính tiền, thuế và ký số: không thay đổi logic nghiệp vụ; chỉ validation UI yêu cầu header location trước luồng lưu/ký đối với xe.
- Gửi CQT/XML: chỉ bổ sung các trường đặc trưng xe vào khối `TTHHDTrung` (khi có giá trị); không đổi cấu trúc XML còn lại, tính tiền/thuế hay chữ ký.
- Public lookup và các màn hóa đơn khác ngoài `hoadon-goc`/`hoadonbanhang`: không thay đổi.
- Cấu hình runtime và kiến trúc hệ thống: không đổi; `appconfig.json` và proxy churn không liên quan phải được tách khỏi gói phát hành.

## Rủi ro / Hạn chế đã biết / Known risks and limitations

- Phải import/bổ sung quan hệ tỉnh cho danh mục phường/xã (`tinhthanh_ma`), nếu không cascade có thể không trả dữ liệu kỳ vọng.
- Thay đổi proxy generated tạm thời phải được thay bằng `nswag/refresh.bat` khi backend chạy.
- `service-proxies` có trailing whitespace và churn lớn đã tồn tại; thay đổi component liên quan kiểm tra `git diff --check` sạch, nhưng cần tách phần bẩn không liên quan trước khi phát hành.
- API có xác thực, persistence DB và thao tác UI chưa QA thủ công.
- Targeted backend builds từng được ghi nhận thành công trong phiên triển khai; full `VS.Web.sln` bị chặn do thiếu `TraceIdMiddleware.Tests.csproj` và lock. Frontend chưa có bằng chứng build tái lập được sau cập nhật `hoadonbanhang` và sau khi NSwag regenerate.
- `invoice-sendmail-service` build `ConsumerApplication/SendMailConsumerApp.csproj` thành công với 0 errors; warning còn lại là framework `netcoreapp3.1` hết hỗ trợ, package advisory và warning code có sẵn.
- `export-zip-pdf-service` build `ZipPdfInvConsumer/ZipPdfInvConsumer.csproj --no-restore` thành công với 0 errors; 27 warnings hiện hữu, gồm framework `netcoreapp3.1` hết hỗ trợ và warning code có sẵn.
- Validation frontend bổ sung cho toàn bộ trường xe bắt buộc và theo điều kiện nhập khẩu/lắp ráp, đã qua sử dụng. Không thay đổi entity hoặc schema; `TTai` giới hạn đúng `decimal(9,2)` (7 nguyên + 2 thập phân) ở UI, nằm trong miền `decimal(10,2)` của database.
- Angular 6/Webpack cũ cần OpenSSL legacy trên Node hiện tại. Khi có `NODE_OPTIONS=--openssl-legacy-provider`, build đi đến bước Webpack nhưng bị chặn bởi `node-sass` không hỗ trợ Windows runtime ABI 127; chưa có bằng chứng build thành công.

## Chưa được kiểm chứng / Not verified

- API với token hợp lệ và dữ liệu host thực tế.
- Persistence tenant sau lưu/mở lại hóa đơn.
- Cascade và validation trên trình duyệt với dữ liệu tỉnh/xã đã import.
- Build frontend tái lập từ proxy NSwag vừa generate và full `VS.Web.sln` trong môi trường sạch.
- Render thực tế `hoadonbanhang` cho TC22/TC23 sau sửa scope panel xe và vị trí cột `Loại HHĐT`.
- Nhập/paste thực tế các giới hạn ký tự xe trên hai màn theo TC24.
- Nhập dấu phẩy/dấu chấm decimal và đóng preview qua các luồng không gán `hoaDon` theo TC26/TC27.
- Kiểm tra căn chiều rộng panel xe theo TC28.
- Kiểm tra required buyer fields cho xe theo TC29.

## Cập nhật ảnh hưởng 2026-09-24 — Fix bug rò rỉ dữ liệu hàng hóa đặc trưng

- **Phạm vi thay đổi:**
  - `invoicecore`: `HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs` — thêm private helper `NormalizeHangHoaDacTrungFields`, gọi trong `Create()` và `Update()` (nhánh EF Core `<= 150` dòng), bổ sung logic dọn dẹp bản ghi cũ trong CSDL khi `ctmr == null`.
  - `frontend_angular`: `hoadon.service.ts` — thêm `normalizeHangHoaDacTrungFields(ctmr, hangHoaLoai)`; 2 màn hình hóa đơn chính (`hoadon-goc`, `hoadonbanhang`) gọi chuẩn hóa khi đổi loại hàng hóa, đổi phân loại đặc trưng và khi nạp hóa đơn ban đầu. Các màn chuyên thù khác (vé máy bay, tài sản công) không thay đổi.
- **Khu vực xác nhận không bị ảnh hưởng (Confirmed Unaffected):**
  - Các trường dùng chung của dòng hàng hóa (`Thuoc_*`, `DienNuoc_*`, `BenhVien_*`, `TaiKhoan_*`, `BS_ChiTiet_01`..`10`, `DienGiai`, `Ma_Kho`...) được bảo toàn tuyệt đối theo ma trận nghiệp vụ.
  - Contract API và shape DTO không thay đổi; không cần regenerate NSwag `service-proxies.ts`.
  - Nhánh Dapper cho hóa đơn > 150 dòng (`UpdateDataInv`/`DapperUpdateInv`) giữ nguyên, hạn chế riêng biệt TC41-TC43 không bị ảnh hưởng.
  - Logic tính tiền, thuế, ký số và xuất XML giữ nguyên.
- **Rủi ro và cơ chế xử lý dữ liệu lịch sử:**
  - Các hóa đơn đã phát sinh dữ liệu rác trong `vs_hd_chitiet_morong` trước thời điểm triển khai bản vá: sẽ được tự động làm sạch (lazy healing) ngay khi người dùng mở lại hóa đơn và bấm lưu (do frontend chuẩn hóa model khi nạp và backend làm sạch khi cập nhật). Không cần thiết phải chạy migration/backfill SQL toàn bộ hệ thống.

## Cập nhật ảnh hưởng 2026-09-25 — Sao chép hóa đơn khi chưa bật cấu hình ACTIVE_ND_254 & nhánh Dapper

- **Phạm vi thay đổi:**
  - `invoicecore`: `HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs`:
    - Thêm phương thức `IsActiveND254Async()` kiểm tra cấu hình từ Redis / CSDL.
    - Thêm helper `ClearHangHoaDacTrungND254Fields(HD_ChiTiet_MoRong)` và `ClearHoaDonMoRongND254Fields(HD_HoaDon_MoRong)`.
    - Trong `CopyHoaDon`: khi cấu hình `ACTIVE_ND_254` chưa bật (`activeND254 == false`), làm sạch 16 trường xe mới NĐ 254 trên dòng chi tiết và các trường tỉnh/xã trên header mở rộng; luôn gọi `NormalizeHangHoaDacTrungFields` trên từng dòng chi tiết để tránh kế thừa dữ liệu lệch loại hàng hóa.
    - Trong `UpdateDataInv` và `DapperUpdateInv` (nhánh Dapper hóa đơn > 150 dòng): bổ sung lưu chi tiết mở rộng `HD_ChiTiet_MoRong` qua `PersistChiTietMoRongDapper` và xóa mềm các dòng mở rộng bị xóa qua `DeleteByChiTietIds`.
  - `invoicecore`: `HDDT.DapperCore/.../IHD_ChiTiet_MoRongRepository.cs` và `HD_ChiTiet_MoRongRepository.cs`:
    - Thêm `FindByChiTietId(int chiTietId, int tongHopId, int? tenantId, string mst)` để tìm kiếm bản ghi mở rộng theo `ChiTiet_Id` kết hợp kiểm tra multi-tenant.
    - Thêm `DeleteByChiTietIds(List<int> chiTietIds, int? tenantId, string mst)` để xóa mềm các bản ghi mở rộng khi dòng chi tiết tương ứng bị xóa.
- **Khu vực xác nhận không bị ảnh hưởng (Confirmed Unaffected):**
  - Khi `ACTIVE_ND_254` bật: sao chép đầy đủ toàn bộ trường đặc trưng hợp lệ theo đúng loại hàng hóa.
  - Các trường cũ trước NĐ 254 (`So_Khung`, `So_May`, nhóm vận tải `Bien_Kiem_Soat`, `Ten_Nguoi_Gui_Hang`...) vẫn được giữ lại khi sao chép kể cả khi `ACTIVE_ND_254` tắt.
  - Frontend không cần sửa đổi thêm cho luồng copy do `CopyHoaDon` thực hiện hoàn toàn ở Backend và client sau đó gọi `suaHoaDon(result.data, true)` nạp lại dữ liệu đã được làm sạch từ CSDL.
- **Rủi ro và điểm cần lưu ý:**
  - `FindByChiTietId` trong Dapper lọc chặt `TenantId` và `DoanhNghiep_MST`. Với các dữ liệu cũ lịch sử nếu `TenantId` null hoặc `MST` lệch, Dapper có thể không tìm thấy bản ghi cũ và thực hiện chèn mới (insert) thay vì cập nhật (update).
  - Phương thức dùng `SingleOrDefault` có thể gây ngoại lệ nếu CSDL tồn tại nhiều bản ghi mở rộng cho cùng một `ChiTiet_Id` (dữ liệu trùng lặp lịch sử); trong trường hợp đó `DapperUpdateInv` sẽ rollback transaction và trả về 0.

## Kết luận / Conclusion

Rủi ro phát hành ở mức trung bình do feature xuyên host catalog, tenant persistence và proxy generated. Chỉ phát hành sau khi proxy được regenerate, frontend build tái lập được và QA có xác thực hoàn thành các case trong `testcase.md`.
