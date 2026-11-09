# CBCLOUDV2-9170 Deploy

## Gate bổ sung ngày 2026-09-08

- **Chưa sẵn sàng xác nhận luồng Dapper xe:** phải sửa ba lỗi guard create bỏ mở rộng xe, create gắn nhầm ID mở rộng và update không ghi mở rộng (TC41–TC43). Nhánh này áp dụng một hóa đơn trên 150 dòng, không phải chỉ số lượng hóa đơn trong lô.
- Đã sửa (2026-09-14): TTai UI trước hiểu sai `9,2` thành 9 chữ số nguyên, nay đúng `decimal(9,2)` = 7 nguyên + 2 thập phân, nằm trong DB `decimal(10,2)`; vẫn cần QA giá trị biên (TC44).
- Xác nhận migration header có đủ tên/mã tỉnh, tên/mã xã, tên/mã quốc tịch. Migration xe giữ `CLTSan` legacy, không DROP; danh mục `vs_dm_ncc_quoctich` dùng lại, không tạo/seed lại.
- Kiểm tra API `/api/services/hddt/DM_NCC_QuocTich/GetAllNoPage` có dữ liệu hiệu lực với token hợp lệ. Provider `DM_NCC_QuocTichServiceProxy` phải có trong `service-proxy.module.ts` sau khi sinh proxy; không sửa tay `service-proxies.ts`.
- QA TC35–TC40: bố cục địa điểm một dòng desktop, placeholder Quốc tịch, xóa hộ chiếu/lưu/reload, combobox nước sản xuất và CSS chữ căn giữa sau patch padding, rule xe đã qua sử dụng và loại CLTSan.
- XML qua cả ba service: 15 trường nhóm xe, không phát `CLTSan`; tên/mã địa điểm và quốc tịch lấy snapshot. Kiểm tra `MNSXuat` sau lưu/reload và dữ liệu legacy.
- Không có build hay QA tích hợp mới trong đợt chỉnh UI/CSS/provider này; không dùng các kết quả lịch sử để bỏ qua release gate. Migration chưa chạy trong phiên này. Chỉ thực hiện lệnh triển khai khi được cho phép.

## Điều kiện trước khi phát hành

- Chạy migration `database/2026-08-14-add-tinh-xa-to-vs_hd_tonghop_morong-and-danhmuc.sql` để tạo cột `vs_hd_tonghop_morong.ma_tinh`/`ma_xa` và 2 bảng danh mục host `vs_danhmuc_tinh_thanh`, `vs_danhmuc_xa_phuong` (có `tinhthanh_ma`).
- Bảo đảm dữ liệu import danh mục phường/xã có quan hệ tỉnh `tinhthanh_ma`.
- Tách thay đổi service proxy/config không liên quan khỏi gói phát hành.
- Hoàn thành lại targeted backend build, frontend build từ proxy NSwag vừa generate, và tất cả case API/UI/persistence trong `testcase.md`. Đây là gate bắt buộc trước release.

## Thứ tự triển khai

1. Chạy migration SQL trên DB host/tenant và import dữ liệu danh mục tỉnh/xã trước khi khởi động backend cho QA.
2. Build backend có entity, DTO, mapper, DbSet, application service, Dapper, repository projection và XML (`HoaDonTT3268Utility`, `ConstantTTin`, `NMua`) mới; gồm `invoice-sendmail-service/ConsumerApplication/SendMailConsumerApp.csproj` và `export-zip-pdf-service/ZipPdfInvConsumer/ZipPdfInvConsumer.csproj`; chỉ tiếp tục khi build đạt.
3. Khi backend đang chạy và có Swagger/API contract hiện hành, chạy `nswag/refresh.bat` để sinh lại proxy Angular. Không giữ chỉnh sửa generated proxy thủ công làm kết quả cuối.
4. Xác nhận endpoint dùng đúng prefix bằng request có xác thực:
   - `/api/services/hddt/DM_TinhThanh/GetAllNoPage`
   - `/api/services/hddt/DM_XaPhuong/GetXaPhuongTheoTinh`
5. Build lại frontend từ proxy vừa sinh; chỉ triển khai frontend khi build tái lập được.
6. Thực hiện QA thủ công có xác thực theo `testcase.md` trên cả `hoadon-goc` và `hoadonbanhang`: API, cascade tỉnh/xã, validation đúng điều kiện `hangHoa_Loai == 4 && loai_HangHoa_DacTrung == 1`, persistence DB qua EF/Dapper, reload, subtype 2/3 không bị ảnh hưởng và hiển thị readonly hóa đơn gốc. Trên `hoadonbanhang`, chạy TC22/TC23 để xác nhận panel xe không lỗi scope `item.indexKey` và cột `Loại HHĐT` đứng sau cột `Loại`; chạy TC24 trên cả hai màn để xác nhận giới hạn ký tự khi nhập/paste và validation khi dữ liệu bypass UI; chạy TC25 để xác nhận không lặp cột `Số khung`/`Số máy` khi có dòng xe; chạy TC26/TC27 cho dấu decimal và đóng preview không có `hoaDon`; chạy TC28 để xác nhận panel cùng chiều rộng bảng; chạy TC29 cho Địa chỉ/SĐT/Email/CCCD bắt buộc với xe. Kiểm tra XML thực tế gửi CQT qua backend chính, gửi mail và export ZIP/PDF theo TC18/TC19: khối `TTHHDTrung` chứa trường xe có giá trị, `NMua` có `MTinh`/`MXa`, và `TTChung/PBan = 2.1.1` khi có trường xe; khi không có dữ liệu xe, service giữ baseline PBan hiện hữu.
7. Chỉ sau khi bước 1-6 đạt mới triển khai frontend và backend theo quy trình release của đội.

## Lưu ý vận hành

- Phản hồi `401` với request chưa xác thực cho route `hddt` là dấu hiệu route được nhận; cần dùng tài khoản hợp lệ để kiểm tra dữ liệu thực tế.
- Với Node hiện tại, chạy frontend build qua môi trường có OpenSSL legacy (ví dụ `NODE_OPTIONS=--openssl-legacy-provider`) và Node runtime được `node-sass` version hiện tại hỗ trợ; chỉ coi là đạt khi có output compiler thành công.
- Nếu không có quan hệ tỉnh trong dữ liệu phường/xã, lựa chọn tỉnh có thể trả danh sách rỗng dù API và giao diện hoạt động đúng.
