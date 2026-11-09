# CBCLOUDV2-9170 Report

## Cập nhật 2026-09-25 — Xử lý sao chép hóa đơn khi chưa kích hoạt ACTIVE_ND_254 & nhánh DapperUpdateInv

### Nội dung đã thực hiện

1. **Sao chép hóa đơn (`CopyHoaDon`) khi chưa bật cấu hình `ACTIVE_ND_254`:**
   - Thêm phương thức `IsActiveND254Async()` trong `HoaDonAppService.cs` để kiểm tra cờ cấu hình `ACTIVE_ND_254` (Redis hash `QLCAUHINH` key `ACTIVE_ND_254`, fallback DB `vs_dm_ncc_cauhinh` kiểm tra `CauHinh_GiaTri == "1"`).
   - Thêm helper `ClearHangHoaDacTrungND254Fields(HD_ChiTiet_MoRong ctmr)` xóa 16 trường hàng hóa đặc trưng xe mới theo NĐ 254 (`LTSan`, `TTTSan`, `XXu`, `SGCNATKThuat`, `SSPKTCLXXuong`, `MNSXuat`, `TLTSDKy`, `NSXuat`, `TTMai`, `TNHieu`, `KLXe`, `TTLVHCSuat`, `TTai`, `SCNgoi`, `CLTSan`, `SBKSoat`), giữ lại `So_Khung`, `So_May`, nhóm vận tải và phân loại `Loai_HangHoa_DacTrung` (khớp với gate import `ClearInactiveND254VehicleAssetFields`).
   - Thêm helper `ClearHoaDonMoRongND254Fields(HD_HoaDon_MoRong hdmr)` xóa các trường địa điểm đăng ký phương tiện theo NĐ 254 (`Ma_Tinh`, `Ten_Tinh`, `Ma_Xa`, `Ten_Xa`).
   - Trong `CopyHoaDon`:
     - Nếu `activeND254 == false`: gọi `ClearHoaDonMoRongND254Fields` trên `hdmr` trước khi insert.
     - Trên từng dòng chi tiết sao chép: luôn gọi `NormalizeHangHoaDacTrungFields(ctmr, chiTiet.HangHoa_Loai)` để không mang dữ liệu đặc trưng lệch loại sang hóa đơn copy; đồng thời nếu `activeND254 == false` thì gọi `ClearHangHoaDacTrungND254Fields(ctmr)` trước khi insert.
2. **Hỗ trợ lưu chi tiết mở rộng ở nhánh Dapper (`UpdateDataInv` / `DapperUpdateInv`):**
   - Bổ sung `FindByChiTietId` và `DeleteByChiTietIds` trong `HDDT.DapperCore` (`IHD_ChiTiet_MoRongRepository`, `HD_ChiTiet_MoRongRepository`).
   - Trong `UpdateDataInv`: chuẩn hóa danh sách chi tiết mở rộng và gán `TongHop_Id`, `DoanhNghiep_MST`, `TenantId` trước khi chuyển sang `DapperUpdateInv`.
   - Trong `DapperUpdateInv`: tích hợp `PersistChiTietMoRongDapper` để upsert bản ghi mở rộng cho các dòng cập nhật và dòng mới; gọi `DeleteByChiTietIds` xóa mềm bản ghi mở rộng của các dòng chi tiết bị xóa.

### File thay đổi thực tế

| Repository | Đường dẫn file | Nội dung thay đổi |
|---|---|---|
| `invoicecore` | `aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs` | Thêm helper kiểm tra cấu hình ND254, xóa trường ND254 khi copy, chuẩn hóa dòng copy; tích hợp `UpdateDataInv`/`DapperUpdateInv` |
| `invoicecore` | `aspnet-core/src/hddt/HDDT.DapperCore/HDDT.DapperCore/IRepositories/IHD_ChiTiet_MoRongRepository.cs` | Khai báo `FindByChiTietId` và `DeleteByChiTietIds` |
| `invoicecore` | `aspnet-core/src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_ChiTiet_MoRongRepository.cs` | Cài đặt `FindByChiTietId` và `DeleteByChiTietIds` (Dapper SQL) |
| `frontend_angular` | `src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts` | Thêm `normalizeHangHoaDacTrungFields(ctmr, hangHoaLoai)` |
| `frontend_angular` | `src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts` | Gọi chuẩn hóa tại `chonHangHoaLoai`, `ChangeHangHoaDacTrung`, GET load; giữ trường dùng chung |
| `frontend_angular` | `src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts` | Gọi chuẩn hóa tại `chonHangHoaLoai`, `ChangeHangHoaDacTrung`, GET load; giữ trường dùng chung |
| `frontend_angular` | `src/app/hddt/hoadon/vemaybay/vemaybay.component.ts` | File ngoài phạm vi (đã có thay đổi từ trước phiên làm việc) |
| `docs` | `docs/features/CBCLOUDV2-9170/expect.md` | Bổ sung quy tắc sao chép hóa đơn khi chưa bật `ACTIVE_ND_254` |
| `docs` | `docs/features/CBCLOUDV2-9170/tasks.md` | Bổ sung Task 2i, cập nhật trạng thái Task 2h và TC43 |
| `docs` | `docs/features/CBCLOUDV2-9170/impact.md` | Bổ sung phạm vi ảnh hưởng và rủi ro cập nhật 2026-09-25 |
| `docs` | `docs/features/CBCLOUDV2-9170/report.md` | Báo cáo cập nhật 2026-09-25 |
| `docs` | `docs/features/CBCLOUDV2-9170/testcase.md` | Bổ sung TC45–TC48 kiểm thử copy hóa đơn và Dapper update |

### Kết quả biên dịch và kiểm tra cú pháp thực tế

- **Backend `invoicecore`:**
  - Lệnh: `dotnet build "D:\Source\bill_cloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\HDDT.Application.csproj" --no-restore -v:q -clp:ErrorsOnly`
  - Kết quả: `Build succeeded. 201 Warning(s) 0 Error(s)` (warning hiện hữu của solution, 0 error).
- **Frontend `frontend_angular`:**
  - Lệnh: `npx tsc -p src/tsconfig.json --noEmit`
  - Kết quả: `Exit code 0` (0 error).
- **Kiểm tra khoảng trắng / ký tự lạ (`git diff --check`):**
  - Cả `invoicecore` và `frontend_angular` đều trả về mã 0 (sạch, không có lỗi whitespace/BOM).

## Cập nhật 2026-09-24 — Fix bug rò rỉ / lưu sót dữ liệu hàng hóa đặc trưng

### Nội dung đã thực hiện

- **Vấn đề đã xử lý:** Khi người dùng chọn dòng hàng hóa đặc trưng (`HangHoa_Loai == 4`), điền các thông tin đặc trưng (xe hoặc vận tải) rồi lưu hóa đơn; sau đó mở lại sửa dòng đó sang loại hàng khác (`HangHoa_Loai != 4`) hoặc chuyển đổi giữa các phân loại đặc trưng (`Loai_HangHoa_DacTrung` giữa 1 và 2/3), các trường dữ liệu đặc trưng cũ không bị xóa mà vẫn bị lưu vào CSDL (`vs_hd_chitiet_morong`).
- **Phía Backend (`invoicecore`):**
  - Thêm phương thức `NormalizeHangHoaDacTrungFields(HD_ChiTiet_MoRong ctmr, int? hangHoaLoai)` và các helper xóa Nhóm A (17 trường xe + legacy `CLTSan`) / Nhóm B (5 trường thông tin người gửi/vận tải) vào `HoaDonAppService.cs`.
  - Tích hợp vào luồng `Create()` và `Update()` (nhánh EF Core `<= 150` dòng).
  - Trong `Update()`: nếu client gửi `ctmr == null` nhưng dòng chi tiết đã tồn tại trong CSDL (`ctMoi.Id > 0`) và chuyển khỏi loại 4, backend chủ động truy vấn bản ghi cũ trong CSDL (`_chiTietMRRepository.FirstOrDefaultAsync`), nếu có dữ liệu đặc trưng cũ thì làm sạch và gọi `UpdateAsync`.
- **Phía Frontend (`frontend_angular`):**
  - Thêm phương thức tập trung `normalizeHangHoaDacTrungFields(ctmr, hangHoaLoai)` trong `hoadon.service.ts`.
  - Cập nhật 2 component màn hình lập hóa đơn chính (`hoadon-goc` - Hóa đơn gốc, `hoadonbanhang` - Hóa đơn bán hàng):
    - Gọi hàm chuẩn hóa trong `chonHangHoaLoai` khi chuyển loại hàng hóa; khi chọn loại 4, khởi tạo nếu chưa có để không xóa mất các trường dùng chung.
    - Gọi chuẩn hóa duyệt qua toàn bộ chi tiết trong `ChangeHangHoaDacTrung` khi chuyển phân loại đặc trưng.
    - Bổ sung gọi chuẩn hóa tại bước khởi tạo dữ liệu hóa đơn (GET/load) để làm sạch model ngay khi mở màn hình.
  - Các màn hình chuyên thù khác (vé máy bay, bán tài sản công) giữ nguyên, không can thiệp.
- **Bảo toàn trường dùng chung:**
  - Quy tắc phân nhóm đảm bảo các trường dùng chung (`Thuoc_*`, `DienNuoc_*`, `BenhVien_*`, `TaiKhoan_*`, `BS_ChiTiet_01`..`10`, `DienGiai`, `Ma_Kho`...) tuyệt đối không bị ảnh hưởng khi chuyển đổi qua lại giữa các loại hàng hóa.

### File thay đổi thực tế

| Repository | Đường dẫn file | Nội dung thay đổi |
|---|---|---|
| `invoicecore` | `aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs` | Thêm helper chuẩn hóa, tích hợp vào chi tiết `Create` và `Update`, xử lý dọn rác bản ghi cũ |
| `frontend_angular` | `src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts` | Thêm `normalizeHangHoaDacTrungFields(ctmr, hangHoaLoai)` |
| `frontend_angular` | `src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts` | Gọi chuẩn hóa tại `chonHangHoaLoai`, `ChangeHangHoaDacTrung`, GET load; giữ trường dùng chung |
| `frontend_angular` | `src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts` | Gọi chuẩn hóa tại `chonHangHoaLoai`, `ChangeHangHoaDacTrung`, GET load; giữ trường dùng chung |
| `docs` | `docs/features/CBCLOUDV2-9170/expect.md` | Bổ sung mục Cập nhật ngày 2026-09-24 |
| `docs` | `docs/features/CBCLOUDV2-9170/tasks.md` | Bổ sung Task 2h |
| `docs` | `docs/features/CBCLOUDV2-9170/impact.md` | Bổ sung Cập nhật ảnh hưởng 2026-09-24 |
| `docs` | `docs/features/CBCLOUDV2-9170/report.md` | Bổ sung báo cáo Cập nhật 2026-09-24 |

### Kết quả biên dịch và kiểm thử tự động

- **Backend `invoicecore`:**
  - Lệnh: `dotnet build src/hddt/HDDT.Application/HDDT.Application.csproj`
  - Kết quả: `Build succeeded. 0 Error(s), 6 Warning(s)` (warning hiện hữu về package advisory và reference conflict).
- **Frontend `frontend_angular`:**
  - Lệnh: `npx tsc -p src/tsconfig.json --noEmit`
  - Kết quả: `Completed with exit code 0` (0 error).

## Cập nhật 2026-09-08

### Các thay đổi mới

- Hai màn hóa đơn áp dụng rule xe đã qua sử dụng theo [expect.md](expect.md); `TTai` chỉ bắt buộc với ô tô đã qua sử dụng, trường tùy chọn có giá trị vẫn kiểm tra định dạng/độ dài.
- Bỏ Chất lượng tài sản (`CLTSan`) khỏi panel nhập/readonly, validation và XML cả ba service. Giữ entity/DTO/cột/SQL legacy; panel hiện 17 trường, nhóm XML xe 15 trường.
- Mã Nước sản xuất dùng combobox `lstQuocTich`, hiển thị mã - tên và lưu `MNSXuat` mã 2 ký tự. XML đọc snapshot, không tra lại danh mục.
- Sửa thiếu DI provider `DM_NCC_QuocTichServiceProxy` trong `service-proxy.module.ts`.
- Bốn trường địa điểm cùng một dòng desktop; nhãn Tỉnh/Thành phố, Mã Tỉnh/Thành phố, Xã/Phường, Mã Xã/Phường. Màn hình nhỏ xuống dòng, mã vẫn disabled.
- Quốc tịch có `title="-- Chọn Quốc tịch --"`; nhập hộ chiếu chỉ hiển thị control, không tự xác định quốc tịch. Xóa hộ chiếu đặt tên/mã về `undefined`; cần test lưu/reload để kiểm chứng DB đã xóa dữ liệu cũ.
- CSS selectpicker Mã Nước sản xuất cao 30px, viền/nền/bo góc đồng nhất input. Sửa padding thành `0 24px 0 5px !important` vì CSS `.btn` global ghi đè làm chữ lệch xuống. Chưa QA sau patch cuối.

### File liên quan các patch mới

- `frontend_angular/src/shared/service-proxies/service-proxy.module.ts`: đăng ký provider.
- `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts` và `hoadonbanhang/hoadonbanhang.component.ts`: validation xe, xử lý quốc tịch/hộ chiếu.
- Hai template `.component.html` tương ứng: loại `CLTSan`, combobox nước sản xuất, nhãn/bố cục địa điểm và placeholder Quốc tịch.
- `hoadon-goc.component.scss`, `hoadonbanhang.component.css`: CSS selectpicker giới hạn trong panel xe, kể cả padding override.
- `HoaDonTT3268Utility.cs` và `TTin.cs` tại `invoicecore`, `invoice-sendmail-service`, `export-zip-pdf-service`: loại emission/detection/constant `CLTSan`.
- Không sửa generated `service-proxies.ts`, Excel import hoặc chạy migration trong đợt cập nhật này.

### Phát hiện chưa sửa — không được coi là hoàn tất Dapper

Một hóa đơn trên 150 dòng chuyển qua `CreateDataInv`/`UpdateDataInv`. Review mã nguồn phát hiện:

1. Guard CreateDataInv bỏ mở rộng chỉ có thông tin xe vì chỉ xét trường cũ.
2. DapperInsertInv ghép danh sách mở rộng đã lọc với toàn bộ chi tiết theo index, có thể gắn sai dòng; query chưa có thứ tự xác định.
3. DapperUpdateInv chỉ ghi bảng chi tiết, chưa ghi chi tiết mở rộng.

SQL header Add/AddRange/Update đã có sáu snapshot địa điểm/quốc tịch; repository chi tiết mở rộng có các trường xe nhưng luồng gọi còn lỗi. Ba lỗi này chưa sửa/chưa test DB. `TTai` UI 9,2 còn không khớp DB `decimal(10,2)` (8 chữ số nguyên). Cần xử lý trước khi xác nhận lưu đầy đủ.

Các build ở phần dưới là **ghi nhận lịch sử**, không áp dụng làm bằng chứng cho patch mới. Đợt này chỉ kiểm tra/chỉnh mã nguồn, không chạy build hay QA tích hợp.

## Kết quả triển khai

CBCLOUDV2-9170 đã mở rộng từ panel frontend cho 17 trường xe theo dòng sang hỗ trợ đầy đủ địa điểm cấp đầu hóa đơn. Trường xe tiếp tục ở `HD_ChiTiet_MoRong`; `Ma_Tinh`/`Ma_Xa` ở `HD_HoaDon_MoRong` được lưu theo tenant và lấy nhãn từ danh mục host.

Các khu vực source đã thay đổi:

- HDDT Core/EF: entity hóa đơn, DTO và mapping địa điểm.
- HDDT host catalog: `DM_TinhThanh`, `DM_XaPhuong`, DTO, mapper, DbSet và application service.
- HDDT persistence/repository: header `HD_HoaDon_MoRong` trong EF `Create`/`Update`, Dapper repository `Add`/`AddRange`/`Update` và projection giới hạn có đủ sáu snapshot địa điểm/quốc tịch; guard header xét từng tên/mã. Không áp dụng nhận định hoàn tất này cho chi tiết mở rộng ở nhánh Dapper trên 150 dòng: `CreateDataInv`/`DapperInsertInv`/`DapperUpdateInv` còn ba lỗi được ghi ở phần cập nhật 2026-09-08.
- Angular hóa đơn: `hoadon-goc` và `hoadonbanhang` có selectpicker tỉnh/xã dưới địa chỉ người mua, cascade, bind header, refresh control và validation Lưu/Trình ký/Ký subtype 1; `hoadonbanhang` thêm panel 17 trường xe mà không đổi subtype 2/3. Sửa template bọc dòng chi tiết và panel xe trong cùng `ng-container *ngFor`, xử lý lỗi runtime đọc `item.indexKey` ngoài scope; header và control cột `Loại HHĐT` được chuyển ngay sau cột `Loại` theo `hoadon-goc`. Khi có dòng xe subtype 1, hai cột bảng `Số khung`/`Số máy` được ẩn vì dữ liệu đã nằm trong panel xe; table được ép `width: 100%` để panel và bảng cùng biên. Xe subtype 1 bắt buộc Địa chỉ, SĐT, Email và CCCD người mua với marker `*`/validation action. Hai màn giới hạn nhập chuỗi/số theo contract và validation action kiểm tra lại độ dài chuỗi.
- Đồng nhất panel xe gốc chỉ đọc: bỏ 2 trường Tỉnh/Xã khỏi panel gốc trên `hoadon-goc` (Tỉnh/Xã là dữ liệu cấp hóa đơn, đã hiển thị dưới địa chỉ người mua) nên cả panel nhập liệu lẫn panel gốc chỉ còn 17 trường xe. `hoadonbanhang` bổ sung panel xe gốc chỉ đọc khớp `hoadon-goc`: thêm state `panelXeAnGoc` và 3 helper nhãn `tenLoaiTaiSan`/`tenTinhTrangTaiSan`/`tenXuatXu` cho các trường mã.
- Kế thừa địa điểm khi điều chỉnh: `getHoaDonGoc()` (`hoadon.service.ts`, dùng chung cả hai màn) trước đây kế thừa thông tin người mua (tên, CCCD, các trường `bS_ThongTin_DNMua_*`) từ `hoaDonGoc.hD_HoaDon_MoRong` nhưng bỏ sót `ma_Tinh`/`ma_Xa`, khiến combo Tỉnh/Xã rỗng khi tạo hóa đơn điều chỉnh (`loaiHoaDon=5`). Đã thêm 2 dòng copy `ma_Tinh`/`ma_Xa` trong cùng guard kế thừa.
- Sửa lệch cột bảng chi tiết hóa đơn gốc (`hoadonbanhang`, `tbody` gốc dùng chung `thead`): dòng gốc đặt cột `Loại HHĐT` sau `Điều chỉnh`/`Hàng hóa` (header đặt trước) và cột `Số khung`/`Số máy` thiếu điều kiện `&& !hasSpecialVehicle()`. Khi có dòng xe, hai lệch này cộng dồn làm dữ liệu rơi sai cột (`HD Gốc` vào cột Loại HHĐT, đơn vị `kg` vào Đơn giá…). Đã đưa cột `Loại HHĐT` lên ngay sau `Loại` và thêm `&& !hasSpecialVehicle()` cho `Số khung`/`Số máy` để khớp header và dòng nhập liệu.
- Đối chiếu `hoadon-goc` (màn quản lý hóa đơn): dòng gốc ở đây vốn đã đặt `Loại HHĐT` trước `Điều chỉnh` (khớp header) và không có cột bảng `Số khung`/`Số máy` (hai trường chỉ nằm trong panel xe), nên không dính lỗi lệch cột như `hoadonbanhang`; không cần sửa. Các quirk căn cột còn lại của `hoadon-goc` (td `thuoc_ChietKhau2` khi mẫu `THUOC`, td `TienThue` điều kiện `hangHoa_MaThue != undefined`) là hành vi cũ, không thuộc phạm vi ticket xe và không tác động hóa đơn xe.

Đối chiếu source với `hoadon-goc`: `hoadonbanhang` dùng cùng điều kiện xe subtype 1, bind đủ 17 trường vào `HD_ChiTiet_MoRong`, điều kiện bắt buộc, enum, giới hạn ký tự/số và panel theo dòng. Sửa giới hạn số từ `ngModelChange` sang handler `(input)` ghi trực tiếp `event.target.value` và model, vì `maxlength`/ngModel không cắt text đang gõ của `type="number"` một cách đáng tin cậy. Khác biệt còn lại là logic tính tiền/thuế và styling bảng đặc thù của hóa đơn bán hàng; không thay đổi trong ticket này.

`TTai` dùng control `input-number` hỗ trợ nhập số thập phân; `CLTSan` đã được bỏ khỏi UI và validation. Handler `(input)` giữ dấu phân cách đang gõ (không đổi `12,` thành `12`), giới hạn số chữ số, và handler `blur` chuẩn hóa giá trị hợp lệ về model số; validation action nhận cả `,`/`.`. `XemHoaDonModalComponent.close` thêm guard `hoaDon` vì `show4ChuyenDoi` và preview phân trang cố ý gán `hoaDon = undefined`.
- Angular service proxy: điều chỉnh tạm thời endpoint theo prefix `hddt` trong khi chờ sinh lại NSwag.
- XML gửi CQT: port `GetTHHDTrung` 15 trường xe, `GetNMuaInfo` `MTinh`/`MXa`, `GetTTChungInfo` `PBan = 2.1.1` khi có trường xe và `ConstantTTin` sang `invoice-sendmail-service/ConsumerApplication` và `export-zip-pdf-service/Common`; bổ sung `NMua` model và domain fields xe/địa điểm cho hai worker. `invoicecore` giữ implementation tương ứng. `export-zip-pdf-service` giữ baseline PBan `2.0.0`/`2.0.1` khi không có dữ liệu xe. Với hóa đơn có dữ liệu xe, cả ba generator map bắt buộc `NMua/DChi`, `SDThoai`, `DCTDTu`, `CCCDan` từ thông tin người mua sau nhánh mẫu/POS, xử lý phản hồi CQT `MLoi=20001` khi các thẻ này bị bỏ trống.
- Migration: file `database/2026-08-14-add-tinh-xa-to-vs_hd_tonghop_morong-and-danhmuc.sql` (ALTER header + CREATE 2 danh mục + cột `tinhthanh_ma`); dữ liệu danh mục import riêng.

Lỗi `AddRange` thiếu tám parameter header đã tồn tại (`Nguoihuy`, `NgayHuy`, `NguoiHuy_Id`, `MaDVQHNS`, `SoHoChieu`, `SoBangKe`, `NgayBangKe`, `File_BangKe`) được phát hiện và sửa trong quá trình thực hiện. Hai parameter địa điểm mới là `Ma_Tinh` và `Ma_Xa` được thêm riêng vào cùng câu lệnh.

## Bằng chứng xác minh

| Hạng mục | Kết quả |
| --- | --- |
| Targeted HDDT Core/EF/Dapper/Application build | Ghi nhận trong phiên triển khai: 0 errors; cần rerun trước release vì output chi tiết không lưu trong feature folder. |
| HDDT Application warnings | Ghi nhận trong phiên triển khai: 203 warnings hiện hữu. |
| Route API | Ghi nhận trong phiên triển khai: prefix `app` trả `404`; `/api/services/hddt/...` trả `401` khi chưa xác thực. Cần kiểm tra lại với token hợp lệ. |
| `VS.Web.sln` | Từng bị chặn bởi thiếu `TraceIdMiddleware.Tests.csproj` và file lock; cần xác minh trong môi trường sạch. |
| Frontend build | Không xác minh tái lập được. Có báo cáo thành công trước đó với OpenSSL legacy, nhưng các lần sau không có kết quả terminal do `ng serve`/toolchain hoạt động; không coi là passed. |
| Frontend build sau `hoadonbanhang` | Chưa có bằng chứng compiler thành công: không có OpenSSL legacy thì lỗi `error:0308010C`; có `NODE_OPTIONS=--openssl-legacy-provider` thì Webpack chạy đến bước xử lý SCSS và lỗi `node-sass` không hỗ trợ Windows runtime ABI 127. |
| XML CQT (trường xe, `MTinh`/`MXa`, `PBan`) | Đã implement; chưa kiểm tra XML thực tế gửi CQT, cần build BE + so khớp schema TT32/68. |
| SendMailConsumerApp build | `dotnet build ConsumerApplication/SendMailConsumerApp.csproj --no-restore`: 0 errors, 10 warnings hiện có/môi trường. |
| ZipPdfInvConsumer build | `dotnet build ZipPdfInvConsumer/ZipPdfInvConsumer.csproj --no-restore`: 0 errors, 27 warnings hiện có/môi trường. |
| XML NMua bắt buộc cho xe | Đã implement tại ba generator; cần build lại sau patch và gửi fixture/UAT CQT để xác nhận không còn `MLoi=20001`. |
| Clone chi tiết hóa đơn điều chỉnh | Dùng `HD_ChiTietDto.fromJS` thay vì JSON clone để giữ `toJSON()` cho dòng chi tiết, trường mở rộng, sản phẩm và thuế suất; tránh lỗi frontend `item.toJSON is not a function` khi Lưu/Ký. |
| Migration DB | Có file SQL; chưa chạy trên DB host/tenant. |
| QA API có xác thực, DB, UI | Not run. |

## Giới hạn còn lại

- Chạy migration `database/2026-08-14-add-tinh-xa-to-vs_hd_tonghop_morong-and-danhmuc.sql` trên DB host/tenant và import dữ liệu danh mục tỉnh/xã (có `tinhthanh_ma`).
- Chạy `nswag/refresh.bat` với backend đang chạy để thay proxy thủ công.
- Tách các thay đổi bẩn không liên quan ở service proxy/config trước khi phát hành.
- Thực hiện QA thủ công, gồm dữ liệu import có `tinhthanh_ma`, cascade, validation, lưu/mở lại, hóa đơn gốc readonly và kiểm tra XML gửi CQT (trường xe, `MTinh`/`MXa`, `PBan`).
- Kiểm tra XML thực tế của backend chính, luồng gửi mail và luồng export ZIP/PDF để xác nhận ba output đồng nhất theo TC18/TC19.
- QA TC30 bằng XML hóa đơn xe trên mẫu `6` hoặc `03XKNB`/`04HGDL`, xác nhận `DChi`, `SDThoai`, `DCTDTu`, `CCCDan` có giá trị người mua và CQT không trả `MLoi=20001`.
- QA trình duyệt `hoadonbanhang` theo TC22/TC23 để xác nhận không còn lỗi scope `item.indexKey` và vị trí cột `Loại HHĐT`.
- QA TC24 trên cả hai màn để xác nhận giới hạn ký tự khi gõ/paste và validation action khi dữ liệu bypass UI.
- QA TC25 để xác nhận không lặp cột `Số khung`/`Số máy` trên hóa đơn xe và không ảnh hưởng hóa đơn không có xe.
- QA TC26/TC27 cho dấu phân cách decimal và đóng preview không có `hoaDon`.
- QA TC28 để xác nhận panel xe cùng chiều rộng bảng.
- QA TC29 để xác nhận required buyer fields của xe trên cả hai màn.
- QA TC10 để xác nhận panel xe gốc chỉ đọc trên `hoadon-goc` và `hoadonbanhang` đồng nhất 17 trường (không có Tỉnh/Xã trong panel), trường mã hiển thị nhãn tiếng Việt.
- QA TC32 để xác nhận hóa đơn điều chỉnh (`loaiHoaDon=5`) kế thừa `ma_Tinh`/`ma_Xa` từ hóa đơn gốc, combo Tỉnh/Xã đổ đúng giá trị (không rỗng).
