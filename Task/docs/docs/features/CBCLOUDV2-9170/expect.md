# CBCLOUDV2-9170 Expect

## Scope

Phạm vi đã mở rộng từ yêu cầu frontend-only cho 17 trường xe theo từng dòng sang hỗ trợ đầy đủ backend và frontend cho địa điểm và quốc tịch người mua trên hóa đơn. Các trường xe vẫn thuộc từng dòng `HD_ChiTiet_MoRong`; Tỉnh/Thành phố, Phường/Xã và Quốc tịch là thông tin cấp đầu hóa đơn tại `HD_HoaDon_MoRong`.

- Dữ liệu danh mục dùng phía host: `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` và danh mục admin hiện có `vs_dm_ncc_quoctich`; bảng phường/xã có quan hệ `tinhthanh_ma`.
- Dữ liệu hóa đơn dùng phía tenant: `vs_hd_tonghop_morong.ten_tinh`, `ma_tinh`, `ten_xa`, `ma_xa`, `quoc_tich_nguoi_mua` và `ma_quoc_tich_nguoi_mua`. Các trường tên là snapshot tại thời điểm lưu hóa đơn, không tra lại danh mục host khi sinh XML.
- Có file migration `database/2026-08-14-add-tinh-xa-to-vs_hd_tonghop_morong-and-danhmuc.sql`: ALTER `vs_hd_tonghop_morong` thêm các cột snapshot địa điểm/quốc tịch nullable; tên tỉnh, tên xã và quốc tịch dài tối đa 50 ký tự, mã quốc tịch dài tối đa 2 ký tự; CREATE hai bảng danh mục Tỉnh/Xã; Quốc tịch dùng bảng admin hiện có, không tạo hoặc seed lại. Dữ liệu Tỉnh/Xã được import riêng từ nguồn nghiệp vụ chính thức, ngoài phạm vi file migration.

## Cập nhật ngày 2026-09-08

- Panel hiện có 17 trường: Số khung/Số máy và 15 trường xe còn lại; đã bỏ Chất lượng tài sản (`CLTSan`) khỏi UI, validation và XML, giữ cột/property legacy.
- Bốn control địa điểm nằm cùng một dòng desktop dưới địa chỉ người mua, theo thứ tự nhãn: **Tỉnh/Thành phố**, **Mã Tỉnh/Thành phố**, **Xã/Phường**, **Mã Xã/Phường**. Màn hình nhỏ xuống dòng; mã vẫn disabled và tự điền theo danh mục.
- Đã đăng ký `DM_NCC_QuocTichServiceProxy` trong `frontend_angular/src/shared/service-proxies/service-proxy.module.ts` để xử lý `NullInjectorError`. Không sửa tay file generated `service-proxies.ts` trong đợt cập nhật này.
- Combobox Quốc tịch có `title="-- Chọn Quốc tịch --"` thay thông báo mặc định `Nothing selected`. Nhập hộ chiếu không tự suy ra quốc tịch; chọn tên mới điền mã. `onChangeSoHoChieu()` đặt cả tên/mã về `undefined` khi xóa hộ chiếu hoặc nhập toàn khoảng trắng. Cần QA payload và DB khi xóa giá trị đã lưu; không coi `undefined` là bằng chứng đã persist `null`.
- Combobox `MNSXuat` dùng chung `lstQuocTich`, lưu mã, không tự điền trường xe khác. CSS selectpicker chỉ trong panel xe: cao 30px, viền `#8da7b3`, nền `#fcfeff`, bo góc 3px, font 12px. Padding `0 24px 0 5px !important` ghi đè `.btn` global để tránh chữ lệch xuống; đồng bộ hover/focus/disabled. Chưa xác minh trình duyệt sau lần sửa padding cuối.

## Hạn chế Dapper chưa sửa

Kiểm tra mã nguồn phát hiện luồng một hóa đơn **trên 150 dòng chi tiết** chuyển sang `CreateDataInv`/`UpdateDataInv`; không đồng nghĩa tạo nhiều hóa đơn trong một request.

1. `CreateDataInv`: guard lọc chi tiết mở rộng chỉ xét trường cũ (BS/thuốc/điện nước), nên mở rộng chỉ có dữ liệu xe bị loại khỏi danh sách lưu.
2. `DapperInsertInv`: ghép danh sách mở rộng đã lọc với toàn bộ chi tiết theo chỉ số; có thể gắn sai `ChiTiet_Id` khi xen kẽ dòng có/không có mở rộng. Truy vấn lấy chi tiết cũng chưa có `ORDER BY`.
3. `DapperUpdateInv`: bulk insert/update bảng chi tiết nhưng chưa insert/update bản ghi chi tiết mở rộng.

SQL `Add`/`AddRange`/`Update` của repository mở rộng đã có trường mới; header đã có sáu trường snapshot địa điểm/quốc tịch. Điều này **không chứng minh luồng lưu xe Dapper hoàn tất**. Ba lỗi trên mới được phát hiện, chưa sửa và chưa chạy DB. Xem testcase TC41–TC43.

## Hành vi nghiệp vụ và giao diện

- Chỉ khi dòng thỏa `hangHoa_Loai == 4`, có `hD_ChiTiet_MoRong` và `loai_HangHoa_DacTrung == 1` (xe ô tô, mô tô), giao diện mới yêu cầu chọn Tỉnh/Thành phố và Phường/Xã.
- Bốn trường Tên tỉnh, Mã tỉnh, Tên xã và Mã xã được đặt dưới địa chỉ người mua trên cả `hoadon-goc` và `hoadonbanhang`; Tên tỉnh và Tên xã là combobox có tìm kiếm bằng `selectpicker`.
- Khi chọn Tên tỉnh, giao diện tự động điền Mã tỉnh tương ứng. Trường Mã tỉnh ở trạng thái disable, người dùng không được nhập hoặc sửa trực tiếp.
- Khi chọn Tên xã, giao diện tự động điền Mã xã tương ứng. Trường Mã xã ở trạng thái disable, người dùng không được nhập hoặc sửa trực tiếp.
- Chọn lại hoặc xóa Tên tỉnh sẽ xóa Tên xã và Mã xã đã chọn trước đó, sau đó nạp lại danh sách xã/phường theo Mã tỉnh.
- Khi không có `maTinh`, API phường/xã trả toàn bộ danh mục. Khi có `maTinh`, kể cả chuỗi rỗng, API lọc theo tỉnh được truyền vào.
- Khi Lưu, Trình ký hoặc Ký, chỉ kiểm tra bắt buộc tỉnh/xã và trường xe cho loại xe 1; subtype hàng hóa đặc trưng 2/3 và các loại HHĐT khác giữ nguyên hành vi trước đây.
- Tỉnh/Thành phố và Phường/Xã là dữ liệu cấp hóa đơn (`hD_HoaDon_MoRong`), chỉ hiển thị dưới địa chỉ người mua; panel chi tiết xe (cả nhập liệu lẫn hóa đơn gốc chỉ đọc) chỉ gồm 17 trường xe, không lặp lại Tỉnh/Xã.
- Khi tạo hóa đơn điều chỉnh/thay thế (`loaiHoaDon` tham chiếu hóa đơn gốc, ví dụ 5), `getHoaDonGoc()` kế thừa đủ `ten_Tinh`/`ma_Tinh` và `ten_Xa`/`ma_Xa` từ `hoaDonGoc.hD_HoaDon_MoRong` sang hóa đơn mới cùng nhóm thông tin người mua, để combo Tỉnh/Xã đổ đúng giá trị gốc thay vì rỗng.
- Panel chi tiết xe của hóa đơn gốc (chỉ đọc) hiển thị đồng nhất trên `hoadon-goc` và `hoadonbanhang`: cùng 17 trường xe, các trường mã (Loại tài sản, Tình trạng, Xuất xứ) hiển thị nhãn tiếng Việt thay cho mã số.
- Sau khi nạp hoặc thay đổi danh mục, giao diện refresh `selectpicker` để đồng bộ control với model Angular.
- Trên bảng chi tiết `hoadonbanhang`, header và control cột `Loại HHĐT` nằm ngay sau cột `Loại`, cùng thứ tự với `hoadon-goc`; chỉ hiển thị control khi dòng là hàng hóa đặc trưng.
- Dòng panel xe phải dùng cùng scope `item`/`i` với dòng chi tiết tương ứng để không truy cập `item.indexKey` ngoài `*ngFor`.
- Trên `hoadonbanhang`, khi hóa đơn có dòng xe subtype 1, ẩn hai cột bảng `Số khung` và `Số máy`; hai giá trị này chỉ nhập/hiển thị trong panel thông tin xe của dòng tương ứng. Hóa đơn không có dòng xe giữ hai cột theo cấu hình hiện có.
- Panel xe trên `hoadonbanhang` dùng cùng chiều rộng container với bảng chi tiết; table luôn chiếm `width: 100%` để panel `<td colspan>` không rộng hơn header/dòng hàng.
- Khi có dòng xe subtype 1, Địa chỉ, SĐT, Tên đơn vị và MST/CCCD chủ hộ người mua là bắt buộc trên cả hai màn; nhãn có dấu `*` đỏ và Lưu/Trình ký/Ký cảnh báo trường thiếu. CCCD không còn là trường bắt buộc (xem cập nhật 2026-09-11 bên dưới). Các subtype HHĐT khác giữ rule người mua cũ.

## Quốc tịch theo Số hộ chiếu

- Áp dụng trên cả `hoadon-goc` và `hoadonbanhang`, không phụ thuộc hóa đơn có dòng xe hay không.
- Số hộ chiếu rỗng hoặc chỉ có khoảng trắng: ẩn Quốc tịch/Mã quốc tịch và không yêu cầu nhập. Khi người dùng xóa Số hộ chiếu, xóa cả hai giá trị quốc tịch khỏi model.
- Có Số hộ chiếu: hiển thị Quốc tịch dạng dropdown `selectpicker` có tìm kiếm và Mã quốc tịch dạng input disabled. Chọn tên sẽ tự điền mã và snapshot tên tương ứng.
- Việc hiển thị 2 trường này chỉ theo điều kiện có Số hộ chiếu, **không bắt buộc phải chọn**; người dùng có thể để trống Quốc tịch/Mã quốc tịch dù đã nhập hộ chiếu và vẫn Lưu/Trình ký/Ký bình thường (cập nhật 2026-09-09, bỏ `required` trên select và bỏ điều kiện chặn validate).
- Nếu có nhập Quốc tịch/Mã quốc tịch thì vẫn giới hạn độ dài: tên tối đa 50 ký tự, mã tối đa 2 ký tự.
- Danh mục host `DM_NCC_QuocTich` được cung cấp qua `/api/services/hddt/DM_NCC_QuocTich/GetAllNoPage`, đọc bảng admin hiện có `vs_dm_ncc_quoctich`: chỉ trả bản ghi `QuocTich_HieuLuc == 1` đang trong khoảng ngày hiệu lực và sắp xếp theo tên. Migration tính năng không tạo hoặc seed lại danh mục này.
- Snapshot lưu tại `HD_HoaDon_MoRong.Quoc_Tich_Nguoi_Mua` và `Ma_Quoc_Tich_Nguoi_Mua`; entity/DTO giới hạn 50/2 ký tự. EF, Dapper `Add`/`AddRange`/`Update`, các projection giới hạn và domain downstream truyền đủ hai trường.
- Hóa đơn điều chỉnh/thay thế kế thừa đủ Số hộ chiếu và tên/mã quốc tịch từ hóa đơn gốc. Khách hàng có hộ chiếu nhưng không có quốc tịch yêu cầu chọn quốc tịch trên hóa đơn.
- Cột nullable giữ tương thích hóa đơn cũ chỉ có hộ chiếu. Khi mở bản ghi có mã nhưng thiếu tên, có thể backfill tên từ danh mục; chỉ persist khi lưu lại. Khi sửa/lưu hóa đơn có hộ chiếu, validation mới vẫn áp dụng.
- Cả ba luồng sinh XML dùng trực tiếp snapshot: `Quoc_Tich_Nguoi_Mua` → `NMua/QTNMua` (50 ký tự), `Ma_Quoc_Tich_Nguoi_Mua` → `NMua/MQTNMua` (2 ký tự), đặt sau `SHChieu`. Không tra lại danh mục host. Yêu cầu không phát thẻ quốc tịch rỗng khi thiếu dữ liệu.

## Backend và contract

- Host catalog có entity `DM_TinhThanh` và `DM_XaPhuong`, ánh xạ cột snake_case rõ ràng; có DTO, mapper và `DbSet` tương ứng.
- Dịch vụ công bố các endpoint thực tế:
  - `/api/services/hddt/DM_TinhThanh/GetAllNoPage`
  - `/api/services/hddt/DM_XaPhuong/GetXaPhuongTheoTinh`
- Ở cấp header, `HD_HoaDon_MoRong` persist đủ `Ten_Tinh`/`Ma_Tinh`, `Ten_Xa`/`Ma_Xa` và tên/mã quốc tịch trong EF `Create`/`Update`; Dapper repository `Add`/`AddRange`/`Update` cùng các projection giới hạn cũng có đủ sáu trường snapshot. Các guard tạo/cập nhật header xét từng tên hoặc mã, kể cả khi không có trường mở rộng header cũ. Kết luận này chỉ áp dụng cho header; persistence `HD_ChiTiet_MoRong` ở nhánh Dapper trên 150 dòng còn ba lỗi đã nêu tại mục Hạn chế Dapper chưa sửa.
- Bốn cột địa điểm đều nullable để tương thích hóa đơn cũ. Hóa đơn cũ chỉ có mã vẫn đọc được; khi mở màn hình, tên có thể được backfill từ danh mục để hiển thị và chỉ được snapshot xuống hóa đơn nếu người dùng lưu lại.
- Khi cập nhật `AddRange`, phát hiện danh sách `VALUES` cũ thiếu tám parameter của các cột header đã tồn tại (`Nguoihuy`, `NgayHuy`, `NguoiHuy_Id`, `MaDVQHNS`, `SoHoChieu`, `SoBangKe`, `NgayBangKe`, `File_BangKe`). Tám parameter này được bổ sung cùng với hai parameter mới `Ma_Tinh`/`Ma_Xa`.
- `src/shared/service-proxies/service-proxies.ts` là file generated, không sửa tay. Sau khi backend chạy, phải regenerate bằng `nswag/refresh.bat` để đồng bộ DTO địa điểm/quốc tịch, `DMNCCQuocTichDto` và `DM_NCC_QuocTichServiceProxy`.

## XML gửi Cơ quan Thuế (TT32/68)

- `HoaDonTT3268Utility.GetTHHDTrung` của `invoicecore`, `invoice-sendmail-service/ConsumerApplication` và `export-zip-pdf-service/Common` emit 15 trường xe vào khối `TTHHDTrung/TTin` của từng dòng hàng: `LTSan`, `TTTSan`, `XXu`, `SGCNATKThuat`, `SSPKTCLXXuong`, `MNSXuat`, `TLTSDKy`, `NSXuat`, `TTMai`, `TNHieu`, `KLXe`, `TTLVHCSuat`, `TTai`, `SCNgoi`, `SBKSoat`. Mỗi item gồm `LHHDTrung`/`TTruong`/`DLieu`; chỉ emit khi trường có giá trị và dòng có `Loai_HangHoa_DacTrung`. Số thập phân `TTai` và số nguyên dùng `InvariantCulture`. `CLTSan` không còn hiển thị, validation hoặc phát XML; property/cột dữ liệu cũ được giữ để tương thích.
- `GetNMuaInfo` của ba service thêm 4 thẻ vào `HDon\DLHDon\NDHDon\NMua`: `TTinh` (Tên tỉnh, chuỗi tối đa 50 ký tự), `MTinh` (Mã tỉnh, dài 3), `TXa` (Tên xã, chuỗi tối đa 50 ký tự) và `MXa` (Mã xã, dài 8). Mapping dùng trực tiếp snapshot `HD_HoaDon_MoRong.Ten_Tinh` → `TTinh`, `Ma_Tinh` → `MTinh`, `Ten_Xa` → `TXa`, `Ma_Xa` → `MXa`; không tra danh mục host khi sinh XML. Các thẻ chỉ emit khi có giá trị; hóa đơn cũ thiếu tên chỉ phát các thẻ mã đang có (Điểm a.1.1, khoản 5, Phụ lục Nghị định 254).

| STT | Tên trường | Tên thẻ XML | Kiểu dữ liệu | Độ dài tối đa |
| ---: | --- | --- | --- | ---: |
| 1 | Tên tỉnh | `TTinh` | Chuỗi ký tự | 50 |
| 2 | Tên xã | `TXa` | Chuỗi ký tự | 50 |
- Khi `HasVehicleDacTrungField(hoaDon)` trả về `true`, `GetNMuaInfo` của cả ba service luôn map `NMua/DChi`, `NMua/SDThoai`, `NMua/DCTDTu` và `NMua/CCCDan` lần lượt từ `DNMua_DiaChi`, `DNMua_SDT`, `DNMua_Email` và `HD_HoaDon_MoRong.DNMua_CCCD`. Mapping này đặt sau các nhánh mẫu/POS để hóa đơn xe không bị thay `DChi` thành `VanChuyen_KhoNhap`; hóa đơn không có dữ liệu xe giữ logic XML cũ.
- Khi lập hóa đơn điều chỉnh mới (`mau_HoaDon_Loai = 5`), clone sâu `hoaDonGoc.dsChiTiet` sang `hoaDon.dsChiTiet` và reset `Id` của dòng/mở rộng. Hai `tbody` cùng hiển thị panel 17 trường xe: khối hóa đơn gốc chỉ đọc, khối hóa đơn điều chỉnh cho phép nhập; cột `Loại HHĐT` đứng ngay sau cột `Loại` ở cả hai khối.
- `GetTTChungInfo` của ba service nâng `TTChung.PBan` lên `2.1.1` khi hóa đơn có ít nhất 1 trong 15 trường xe (helper `HasVehicleDacTrungField`); khi không có dữ liệu xe, mỗi service giữ baseline PBan hiện hữu. Giá trị legacy chỉ có `CLTSan` không kích hoạt phiên bản này.
- `HoaDonAppService.GetThongDiepPosRequest` và `QuanLyHoaDonPosAppService.GetTTChung` nâng `TTChung.PBan` từ `2.1.0` lên `2.1.1` khi danh sách hóa đơn POS có dòng `HangHoa_Loai = 4` và `Loai_HangHoa_DacTrung = 1`; call site ký POS một hóa đơn truyền `invCloneObj` vào danh sách để condition đọc được `DSChiTiet`. Subtype `2`/`3` và danh sách không xe giữ `2.1.0`.
- `ConstantTTin` của ba service tái dùng `NSXuat` sẵn có và khai báo các constant xe còn lại, không còn `CLTSan`. Domain `invoice-sendmail-service` và `export-zip-pdf-service` vẫn giữ property dữ liệu cũ cùng `Ma_Tinh`/`Ma_Xa` để materialize dữ liệu DB tương thích trước khi tạo XML.

## Quy tắc bắt buộc cho chi tiết xe

Áp dụng cho từng dòng thỏa `hangHoa_Loai == 4`, có `hD_ChiTiet_MoRong` và `loai_HangHoa_DacTrung == 1`.

- Luôn bắt buộc: `So_Khung`, `So_May`, `LTSan`, `TTTSan`, `XXu`.
- `TTTSan = 1` (Đã qua sử dụng): bắt buộc `MNSXuat`, `TLTSDKy`, `NSXuat`, `TTMai`, `TNHieu`, `KLXe`, `TTLVHCSuat`, `SCNgoi` và `SBKSoat`.
- `MNSXuat` là dropdown có tìm kiếm trên cả hai màn hóa đơn, tái sử dụng danh mục `DM_NCC_QuocTich`; option hiển thị `QuocTich_Ma - QuocTich_Ten` và lưu `QuocTich_Ma` tối đa 2 ký tự vào snapshot dòng hóa đơn. XML lấy trực tiếp snapshot `MNSXuat`, không tra lại danh mục khi sinh XML.
- `TTTSan = 1` và `LTSan = 1` (Ô tô đã qua sử dụng): bắt buộc thêm `TTai`.
- Với xe chưa qua sử dụng, các trường có điều kiện trên được phép để trống; nếu có nhập thì vẫn kiểm tra độ dài, kiểu dữ liệu và miền giá trị.
- `XXu = 1` (Nhập khẩu): bắt buộc `SGCNATKThuat`.
- `XXu = 0` (Sản xuất, lắp ráp trong nước): bắt buộc `SSPKTCLXXuong`.
- Giá trị enum: `LTSan` 1 = Ô tô, 2 = Mô tô xe máy; `TTTSan` 0 = Chưa qua sử dụng, 1 = Đã qua sử dụng; `XXu` 0 = Sản xuất, lắp ráp trong nước, 1 = Nhập khẩu.
- `TTai` chỉ giới hạn ở UI: số dương, định dạng `decimal(9,2)` (precision 9, scale 2) tức tối đa 7 chữ số phần nguyên và 2 chữ số thập phân (`0.01` đến `9999999.99`). Database dùng `decimal(10,2)` (8 nguyên + 2 thập phân) nên `decimal(9,2)` luôn nằm trong miền giá trị DB, không còn lệch giới hạn.
- Khi thiếu bất kỳ trường bắt buộc nào, cảnh báo theo từng dòng hiển thị trong danh sách lỗi và ba nút Lưu, Trình ký, Ký bị disable. Validation khi bấm nút vẫn được giữ lại.
- Các giới hạn ký tự áp dụng ngay khi nhập: trường chuỗi dùng `maxlength`; trường số dùng handler `(input)` để cắt trực tiếp giá trị hiển thị và model vì browser không áp dụng `maxlength` đáng tin cậy cho `type="number"`. `NSXuat` và `SCNgoi` tối đa 4 chữ số; `TTai` tối đa 7 chữ số phần nguyên và 2 chữ số thập phân (`decimal(9,2)`). Validation trước action kiểm tra lại để chặn dữ liệu nạp/gán vượt giới hạn.
- `TTai` nhận cả dấu phẩy và dấu chấm thập phân khi nhập. Trong lúc gõ, handler giữ dấu phẩy để người dùng có thể nhập tiếp, ví dụ `12,` rồi `12,5`; khi blur, giá trị hợp lệ được chuẩn hóa vào model số dùng dấu chấm. Validation action nhận cả hai dấu.

| Field | Giới hạn UI |
| --- | --- |
| `So_Khung`, `So_May` | Tối đa 50 ký tự |
| `MNSXuat` | Tối đa 2 ký tự |
| `SGCNATKThuat`, `SSPKTCLXXuong`, `TLTSDKy`, `TNHieu` | Tối đa 255 ký tự |
| `TTMai` | Tối đa 400 ký tự |
| `KLXe` | Tối đa 50 ký tự |
| `TTLVHCSuat` | Tối đa 10 ký tự |
| `NSXuat` | Số nguyên 4 chữ số, từ 1000 đến 9999 |
| `SCNgoi` | Số nguyên từ 0 đến 9999 |
| `SBKSoat` | Tối đa 20 ký tự |

## Cập nhật ngày 2026-09-11 — Validate người mua khi có hàng hóa đặc trưng xe (subtype 1)

Điều chỉnh rule bắt buộc thông tin người mua tại mục "Hành vi nghiệp vụ và giao diện" (dòng bắt buộc CCCD ở trên đã lỗi thời): khi hóa đơn có dòng thỏa `hasSpecialVehicle()` (`hangHoa_Loai == 4` và `hD_ChiTiet_MoRong.loai_HangHoa_DacTrung == 1`):

- **Bắt buộc mới:** `Tên đơn vị` (`hoaDon.dnMua_Ten`) và `MST/CCCD chủ hộ` (`hoaDon.dnMua_MST`) — nhãn hiển thị dấu `*` đỏ khi `hasSpecialVehicle()` true, cộng thêm các điều kiện bắt buộc cũ theo `dnMua_TenNguoiMua`/`mau_MauSo` đã có từ trước.
- **Bỏ bắt buộc:** `CCCD` (`hoaDon.hD_HoaDon_MoRong.dnMua_CCCD`) — không còn dấu `*` đỏ, không còn chặn Lưu/Trình ký/Ký dù có dòng xe.
- Giữ nguyên bắt buộc cũ: `Địa chỉ` (`dnMua_DiaChi`) và `Số điện thoại` (`dnMua_SDT`).
- Áp dụng đồng nhất trên cả hai màn hóa đơn dùng chung logic `hasSpecialVehicle()`:
  - `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html` + `.ts` (hàm `getVehicleValidationError()`, trả về string lỗi đầu tiên).
  - `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.html` + `.ts` (hàm `getVehicleValidationErrors()`, trả về mảng lỗi).
- Không đụng tới `vemaybay.component.ts` (vé máy bay) — màn này chỉ gán `dnMua_CCCD` từ tra cứu khách hàng, không có logic validate theo `hasSpecialVehicle()`.
- Chưa build/chưa QA thủ công trên trình duyệt trong phiên sửa này.

## Cập nhật ngày 2026-09-11 — PBan thẻ `TDiep` (phong bì gửi TCT)

Yêu cầu mới, tách biệt với mục "XML gửi Cơ quan Thuế (TT32/68)" ở trên: mục đó nói về `TTChung.PBan` **nằm trong chính hóa đơn** (`HDon/DLHDon/NDHDon/TTChung`). Mục này nói về `TTChung.PBan` **nằm trong phong bì `TDiep`** gửi TCT — một vị trí khác trong XML/API, dùng chung điều kiện nghiệp vụ nhưng độc lập về code.

- **Quy tắc:** hóa đơn/lô có ít nhất 1 dòng hàng hóa đặc trưng xe (`HangHoa_Loai == 4` và `Loai_HangHoa_DacTrung == 1`) → `TDiep.TTChung.PBan = "2.1.1"`. Không có dữ liệu xe → giữ nguyên baseline PBan hiện có của từng file (không đồng nhất giữa các service).
- Baseline giữ nguyên khi không có dữ liệu xe: `2.1.0` ở `invoicecore` và `api-cloud-service`; `2.0.1` ở `export-zip-pdf-service` và `invoice-senddata2tct-service`.
- File đã sửa (7 file, cả hóa đơn thường lẫn POS/MTT):
  - `api-cloud-service/.../AppServices/HoaDon/TCTAppService.cs` — `GetThongDiepRequest` (hóa đơn thường) thêm tham số `HD_HoaDon hoaDon`, dùng helper `HasHangHoaDacTrungXe`/`HasHangHoaDacTrungXeMoi` (style lowercase field + gate `Loai_HangHoa_DacTrung`).
  - `api-cloud-service/.../AppServices/HoaDon/GuiHoaDonAppService.cs` — `GetThongDiepPosRequest` (POS); sửa luôn call site trước đó truyền `lstInv` rỗng (`new List<HD_HoaDon>()`) thành truyền hóa đơn thực tế nên điều kiện xe mới đọc được dữ liệu.
  - `api-cloud-service/.../Commons/HoaDon/HoaDonHelper.cs` — `GetThongDiepPosRequest` (POS), 2 call site tương tự.
  - `invoicecore/.../AppServices/HoaDon/HoaDonAppService.cs` — `GetThongDiepRequest` (hóa đơn thường, 4 call site dùng chung gồm gửi thường và 2 luồng gửi lại sai sót) và `GetThongDiepPosRequest` (POS); dùng helper `HasVehicleDacTrungField` (style PascalCase field, theo mẫu `HoaDonTT3268Utility.cs`).
  - `invoicecore/.../AppServices/HoaDon/QuanLyHoaDonPosAppService.cs` — `GetTTChung` (POS batch); kèm fix dữ liệu tiên quyết: `GetHDonXML` trước đó clone hóa đơn qua object EF riêng nhưng không copy `DSChiTiet` ngược lại object gốc trong `hdPos.listHd`, khiến điều kiện xe luôn `false` — đã bổ sung `item.DSChiTiet = inv.DSChiTiet;`.
  - `export-zip-pdf-service/MixPosInvConsumer/Services/MixPosInvService.cs` — `GetTTChung` (POS batch, baseline `2.0.1`); helper `HasVehicleDacTrungField` duplicate local vì bản gốc trong `HoaDonTT3268Utility.cs` là `private`.
  - `invoice-senddata2tct-service/MixPosInvConsumer/Services/MixPosInvService.cs` — `GetTTChung` (POS batch, baseline `2.0.1`); helper `HasVehicleDacTrungField` viết đơn giản hơn các file khác (xem ghi chú entity bên dưới).
- **Khoảng trống entity phát hiện khi triển khai:** `invoice-senddata2tct-service`'s `HD_ChiTiet_MoRong` (`Data.Core/Data.Core/Domains/HD_ChiTiet_MoRong.cs`) **không có** 14/15 trường xe chi tiết (`LTSan`, `TTTSan`, `XXu`, `NSXuat`, `TTai`, `SCNgoi`, `SGCNATKThuat`, `SSPKTCLXXuong`, `MNSXuat`, `TLTSDKy`, `TTMai`, `TNHieu`, `KLXe`, `TTLVHCSuat`, `SBKSoat`) — chỉ có `Loai_HangHoa_DacTrung`. Vì vậy helper của service này dùng thẳng quy tắc gốc `HD_ChiTiet.HangHoa_Loai == 4 && HD_ChiTiet_MoRong.Loai_HangHoa_DacTrung == 1` thay vì kiểm tra 15 trường như các service khác.
- **Bỏ qua hoàn toàn (quyết định của user):** `api-qldv-service/.../TCTAppService.cs` (`PBan = "2.0.0"` không đổi) — entity `HD_ChiTiet_MoRong` của service này không có bất kỳ trường xe đặc trưng nào nên không thể detect; không sửa file này.
- **Ngoài phạm vi xác nhận lại:** `GetThongDiepRequestTBSS`, `GetThongDiepRequestVAN`, `GetThongDiepBangKeRequest` (giữ PBan cũ không điều kiện); `invoice-sendmail-service`/`svinvoicesendemail` không có code dựng phong bì `TDiep` gửi TCT nên không có gì để sửa.
- Chưa build lại các project sau đợt sửa này trong phiên làm việc; chưa có QA thủ công XML `TDiep` thực tế cho cả hóa đơn thường và POS.

## Cập nhật ngày 2026-09-14 — Fix bug: điều kiện xe không kích hoạt ở 4 luồng hóa đơn thường (`TDiep`)

Sau khi user báo "API liên quan sửa gần đây đang lỗi", kiểm tra lại phát hiện điều kiện xe của mục PBan `TDiep` (2026-09-11 ở trên) **không bao giờ đúng** ở 4 luồng "hóa đơn thường" (không phải POS) tại `api-cloud-service` và `invoicecore`, vì hóa đơn được nạp bằng `IRepository<HD_HoaDon>.GetAsync(id)` (hoặc tương đương) — plain query không `Include` navigation `DSChiTiet`. Dự án không bật `UseLazyLoadingProxies`, nên `hoaDon.DSChiTiet` luôn `null` tại các điểm gọi này, khiến `HasHangHoaDacTrungXe`/`HasVehicleDacTrungField` luôn trả `false` và `PBan` luôn giữ baseline cũ (`2.1.0`) dù hóa đơn thực sự có dòng xe đặc trưng.

- **Luồng POS/MTT không bị ảnh hưởng** — các nơi build `lstInv`/`hdClone` cho POS đều dùng `GetIncludeAll`/`GetAllIncludeAll()` hoặc `.Include(...)` tường minh sẵn có từ trước, nên `DSChiTiet` đã có dữ liệu.
- **4 điểm đã sửa** (thêm `.Include(x => x.DSChiTiet).ThenInclude(c => c.HD_ChiTiet_MoRong)` vào query nạp hóa đơn, thay cho `GetAsync(id)` phẳng):
  - `api-cloud-service/.../AppServices/HoaDon/TCTAppService.cs` — `GuiTCT(int id, bool? guiLai)`, dòng nạp `hdObj`.
  - `invoicecore/.../AppServices/HoaDon/HoaDonAppService.cs` — `GuiTCT(int id, bool? guiLai, string xmlHDPos, string mathongdiep)`, dòng nạp `hdObj` (ảnh hưởng cả gửi thường lẫn 2 luồng gửi lại sai sót dùng chung `hdObj`).
  - `invoicecore/.../AppServices/HoaDon/HoaDonAppService.cs` — `GuiHdSaiSotDenTCT(int id, int? loaitb)`, dòng nạp `hdObj`.
  - `invoicecore/.../AppServices/HoaDon/HoaDonAppService.cs` — `UploadFileDaKySaiSot(FileHoaDonDto input)`, dòng nạp `hdObj`.
- Đã build lại `HDDT.Application.csproj` (invoicecore) và `WS.Application.csproj` (api-cloud-service) độc lập với `dotnet build --no-restore`: cả hai 0 Error (215 và 36 warning hiện hữu, không liên quan thay đổi).
- Chưa QA thủ công gửi TCT thực tế một hóa đơn thường có dòng xe qua 4 luồng này để xác nhận XML `TDiep` xuất `PBan=2.1.1`.

## Cập nhật ngày 2026-09-24 — Fix bug: dữ liệu hàng hóa đặc trưng cũ không bị xóa khi đổi loại/subtype

Xử lý lỗi rò rỉ / lưu sót dữ liệu hàng hóa đặc trưng: khi người dùng chọn dòng hàng hóa đặc trưng (`HangHoa_Loai == 4`), chọn phân loại đặc trưng (xe hoặc vận tải), điền thông tin và lưu hóa đơn; sau đó mở lại sửa dòng đó sang loại hàng khác (`HangHoa_Loai != 4`) hoặc chuyển đổi giữa các phân loại đặc trưng (`Loai_HangHoa_DacTrung` giữa 1 và 2/3), các trường đặc trưng cũ vẫn bị lưu và tồn tại trong bảng `vs_hd_chitiet_morong`.

- **Quy tắc làm sạch (chuẩn hóa dữ liệu):**
  - **Trường dùng chung tuyệt đối không xóa:** Thuốc (`Thuoc_*`), Bệnh viện (`BenhVien_*`), Điện nước (`DienNuoc_*`), Kế toán/kho/chi phí (`Ma_Kho`, `DienGiai`, `TaiKhoan_*`, `phikhac_*`), Bổ sung (`BS_ChiTiet_01`..`10`), thông tin định danh/multi-tenant (`ChiTiet_Id`, `DoanhNghiep_MST`, `TenantId`).
  - **Khi `HangHoa_Loai != 4`:** Xóa toàn bộ trường Nhóm A (17 trường xe + trường legacy `CLTSan`) và Nhóm B (thông tin người gửi/biển kiểm soát vận tải), gán `Loai_HangHoa_DacTrung = null`.
  - **Khi `HangHoa_Loai == 4` và `Loai_HangHoa_DacTrung == 1` (Xe):** Xóa toàn bộ trường Nhóm B, giữ lại Nhóm A.
  - **Khi `HangHoa_Loai == 4` và `Loai_HangHoa_DacTrung in (2, 3)` (Vận tải / Sàn TMĐT):** Xóa toàn bộ trường Nhóm A, giữ lại Nhóm B.
  - **Khi `HangHoa_Loai == 4` và subtype khác/null:** Xóa cả Nhóm A và Nhóm B.
- **Phía Backend (`invoicecore`):**
  - `invoicecore/.../AppServices/HoaDon/HoaDonAppService.cs`:
    - Bổ sung các private helper: `NormalizeHangHoaDacTrungFields`, `ClearHangHoaDacTrungGroupA`, `ClearHangHoaDacTrungGroupB`, `HasAnyHangHoaDacTrungData`.
    - Trong `Create()` (nhánh chi tiết): chuẩn hóa `ctmr` theo `chiTiet.HangHoa_Loai` trước khi `InsertAndGetIdAsync`.
    - Trong `Update()` (nhánh chi tiết): nếu `ctmr != null`, chuẩn hóa trước khi `InsertOrUpdateAsync`. Nếu `ctmr == null` và `ctMoi.HangHoa_Loai != 4`, chủ động kiểm tra bản ghi cũ trong CSDL bằng `_chiTietMRRepository.FirstOrDefaultAsync(x => x.ChiTiet_Id == ctMoi.Id)`; nếu còn dữ liệu đặc trưng cũ thì làm sạch và gọi `UpdateAsync`.
- **Phía Frontend (`frontend_angular`):**
  - `frontend_angular/.../hoadon.service.ts`: Thêm hàm dùng chung `normalizeHangHoaDacTrungFields(ctmr, hangHoaLoai)` phân tách rõ các trường Nhóm A và Nhóm B.
  - Áp dụng trên 2 màn hình hóa đơn chính (`hoadon-goc.component.ts` - Hóa đơn gốc và `hoadonbanhang.component.ts` - Hóa đơn bán hàng):
    - Gọi chuẩn hóa trong `chonHangHoaLoai` khi chuyển loại hàng hóa; khi chọn loại 4, không `new` đè object `hD_ChiTiet_MoRong` nếu đã tồn tại nhằm bảo toàn các trường dùng chung.
    - Gọi chuẩn hóa duyệt qua toàn bộ chi tiết trong `ChangeHangHoaDacTrung` khi chuyển phân loại đặc trưng.
    - Bổ sung gọi chuẩn hóa tại bước khởi tạo dữ liệu hóa đơn (GET/load) để làm sạch model ngay khi mở màn hình.
  - Các màn hình chuyên thù khác (vé máy bay, tài sản công) không thuộc phạm vi sửa đổi đợt này.
- **Kết quả biên dịch:**
  - `HDDT.Application.csproj` (invoicecore): `dotnet build` 0 Error, 6 Warning hiện hữu.
  - `frontend_angular`: `npx tsc --noEmit` 0 Error.
- **Hạn chế Dapper chưa sửa:** Hóa đơn > 150 dòng chạy qua nhánh Dapper (`UpdateDataInv`/`DapperUpdateInv`) vẫn giữ nguyên hạn chế riêng biệt TC41-TC43 đã ghi nhận từ trước.

## Cập nhật ngày 2026-09-25 — Không sao chép thông tin đặc trưng mới (NĐ 254) khi chưa bật cấu hình ACTIVE_ND_254

Bổ sung xử lý khi người dùng thực hiện sao chép hóa đơn (`CopyHoaDon`):
- **Kiểm tra cấu hình `ACTIVE_ND_254`:** Tích hợp kiểm tra qua `IsActiveND254Async()` (đọc Redis `QLCAUHINH:ACTIVE_ND_254`, fallback bảng `vs_dm_ncc_cauhinh`).
- **Khi cấu hình chưa kích hoạt (`activeND254 == false`):**
  - **Phần mở rộng hóa đơn (`HD_HoaDon_MoRong`):** Xóa các trường địa điểm đăng ký phương tiện theo NĐ 254 (`Ma_Tinh`, `Ten_Tinh`, `Ma_Xa`, `Ten_Xa`) qua helper `ClearHoaDonMoRongND254Fields`.
  - **Phần mở rộng dòng chi tiết (`HD_ChiTiet_MoRong`):** Xóa 16 trường hàng hóa đặc trưng xe mới theo NĐ 254 (`LTSan`, `TTTSan`, `XXu`, `SGCNATKThuat`, `SSPKTCLXXuong`, `MNSXuat`, `TLTSDKy`, `NSXuat`, `TTMai`, `TNHieu`, `KLXe`, `TTLVHCSuat`, `TTai`, `SCNgoi`, `CLTSan`, `SBKSoat`) qua helper `ClearHangHoaDacTrungND254Fields`.
  - **Bảo toàn trường cũ:** Giữ nguyên các trường đã có trước NĐ 254 gồm `So_Khung`, `So_May`, nhóm vận tải (Nhóm B) và phân loại `Loai_HangHoa_DacTrung` (đồng bộ với quy tắc xử lý gate import `ClearInactiveND254VehicleAssetFields`).
- **Chuẩn hóa loại hàng hóa khi copy:** Trên mỗi dòng chi tiết sao chép, luôn gọi `NormalizeHangHoaDacTrungFields(ctmr, chiTiet.HangHoa_Loai)` trước khi insert để tránh sao chép dữ liệu đặc trưng rác bị lệch loại hàng hóa từ hóa đơn nguồn.

## Ngoài phạm vi

- Không có thay đổi kiến trúc hệ thống, worker, queue hoặc tài liệu kiến trúc chung.
- Migration được cung cấp dạng file SQL nhưng chưa chạy trong đợt triển khai này; dữ liệu danh mục tỉnh/xã import riêng.
- Không đổi logic tính tiền, thuế, chữ ký; XML chỉ bổ sung trường đặc trưng xe và tên/mã tỉnh/xã người mua.
- Chưa có kết quả QA thủ công đầy đủ cho API có xác thực, DB, giao diện và XML thực tế gửi CQT.
