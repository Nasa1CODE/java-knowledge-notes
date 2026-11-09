# CBCLOUDV2-9170 Plan

## Cập nhật kế hoạch 2026-09-08

- Thiết kế hiện tại lấy [expect.md](expect.md) làm chuẩn: 17 trường panel/15 trường XML sau bỏ `CLTSan`; rule bắt buộc theo xe đã qua sử dụng; combobox `MNSXuat` dùng danh mục quốc tịch và lưu snapshot mã.
- Đã triển khai UI trên cả hai màn: địa điểm một dòng desktop với nhãn Tỉnh/Thành phố, Mã Tỉnh/Thành phố, Xã/Phường, Mã Xã/Phường; Quốc tịch ẩn/xóa model khi bỏ hộ chiếu và có placeholder tiếng Việt; provider Quốc tịch được đăng ký trong module.
- Đã chỉnh CSS selectpicker xe (30px, viền/nền đồng nhất, padding `!important` ghi đè `.btn`); còn QA hiển thị sau patch cuối.
- Header hiện lưu sáu snapshot tên/mã tỉnh, xã, quốc tịch; XML gồm `TTinh`/`MTinh`/`TXa`/`MXa` và `QTNMua`/`MQTNMua`, không tra lại danh mục khi sinh XML.
- **Việc tiếp theo, chưa triển khai:** sửa guard CreateDataInv bỏ dữ liệu xe; ghép đúng mở rộng với dòng gốc trong DapperInsertInv; bổ sung persistence chi tiết mở rộng trong DapperUpdateInv. Nhánh Dapper áp dụng một hóa đơn trên 150 dòng. Cần kiểm tra TC41–TC43 sau sửa.
- Đã sửa (2026-09-14): giới hạn `TTai` UI trước hiểu sai `9,2`; nay đúng `decimal(9,2)` = 7 nguyên + 2 thập phân, nằm trong DB `decimal(10,2)`.
- Không chỉnh tay generated proxy, không sửa Excel import, không tự chạy build/migration hoặc dừng IDE/IIS. Các build ghi dưới đây thuộc lịch sử; chưa có build cho patch mới.

## Mục tiêu

Hoàn thiện hỗ trợ Tỉnh/Thành phố và Phường/Xã cấp đầu hóa đơn cho hàng hóa đặc trưng loại xe, từ danh mục host, API, persistence tenant đến combobox Angular có cascade.

## Thiết kế đã triển khai

1. Phân tách dữ liệu theo cấp: 17 trường đặc trưng xe thuộc `HD_ChiTiet_MoRong` theo dòng; `Ma_Tinh`/`Ma_Xa` thuộc `HD_HoaDon_MoRong` cấp đầu hóa đơn.
2. Danh mục tỉnh/phường thuộc host qua `DM_TinhThanh`/`DM_XaPhuong`; hóa đơn tenant lưu `ma_tinh`/`ma_xa`.
3. API danh mục nằm dưới prefix `/api/services/hddt/`, không dùng prefix `app`.
4. Frontend đặt hai selectpicker có tìm kiếm dưới địa chỉ người mua; tỉnh thay đổi thì cascade và refresh selectpicker.
5. Validation bắt buộc chỉ áp dụng khi có dòng `hangHoa_Loai == 4`, có chi tiết mở rộng và loại xe 1. Panel xe của hóa đơn gốc chỉ đọc và chỉ gồm 17 trường xe (Tỉnh/Xã là dữ liệu cấp hóa đơn nên chỉ đặt dưới địa chỉ người mua, không lặp trong panel); `hoadonbanhang` có panel xe gốc chỉ đọc khớp `hoadon-goc`.
5b. Khi tạo hóa đơn điều chỉnh/tham chiếu hóa đơn gốc (ví dụ `loaiHoaDon=5`), `getHoaDonGoc()` kế thừa `ma_Tinh`/`ma_Xa` từ `hoaDonGoc.hD_HoaDon_MoRong` cùng nhóm thông tin người mua để combo Tỉnh/Xã đổ đúng giá trị gốc.
6. Persistence bao gồm Dapper `Add`, `AddRange`, `Update` và các projection giới hạn; `AddRange` đã được sửa để truyền đủ tám parameter header cũ bị thiếu, đồng thời truyền `Ma_Tinh`/`Ma_Xa` mới.
7. Có file migration `database/2026-08-14-add-tinh-xa-to-vs_hd_tonghop_morong-and-danhmuc.sql`: ALTER header + CREATE 2 danh mục (kèm cột `tinhthanh_ma`); dữ liệu danh mục import riêng.
8. XML gửi CQT: `HoaDonTT3268Utility` của `invoicecore`, `invoice-sendmail-service/ConsumerApplication` và `export-zip-pdf-service/Common` emit 15 trường xe vào `TTHHDTrung/TTin`; `GetNMuaInfo` thêm `MTinh`/`MXa` vào `NMua`; `GetTTChungInfo` nâng `TTChung.PBan` lên `2.1.1` khi có trường xe. Khi không có dữ liệu xe, mỗi service giữ baseline PBan hiện hữu; `export-zip-pdf-service` giữ `2.0.0`/`2.0.1`. Constant mã trường ở `ConstantTTin`; hai worker thêm domain fields để materialize dữ liệu XML.

## Trình tự triển khai/hoàn tất

1. Ánh xạ entity catalog host, DTO, mapper, DbSet và application service cho tỉnh/phường.
2. Bổ sung cột địa điểm vào entity/DTO hóa đơn, Dapper và repository projection tenant.
3. Cập nhật proxy frontend tạm thời theo contract endpoint thực tế; xác nhận route bằng phản hồi `401` sau khi đổi từ `app` sang `hddt`.
4. Bổ sung control, bind header, cascade, refresh selectpicker và validation save/ký cho subtype 1.
5. Bổ sung XML gửi CQT cho backend chính, gửi mail và export ZIP/PDF: trường xe vào `TTHHDTrung`, `MTinh`/`MXa` vào `NMua`, nâng `PBan` khi có trường xe.
6. Khi phát hành, chạy migration SQL trên DB host/tenant, import dữ liệu danh mục, sinh lại proxy bằng NSwag từ backend đang chạy, build lại frontend và QA thủ công luồng có xác thực gồm cả XML.

## Bằng chứng xác minh ghi nhận trong phiên triển khai

- Các lệnh targeted build HDDT Core, EF, Dapper và Application từng hoàn thành với 0 errors; output chi tiết không được lưu trong feature folder.
- Lần build Application ghi nhận 203 warnings hiện hữu; output chi tiết không được lưu trong feature folder.
- `VS.Web.sln` từng bị chặn bởi thiếu project `TraceIdMiddleware.Tests` và file lock.
- Build frontend không được xác minh lặp lại được: từng có báo cáo thành công với OpenSSL legacy ở phiên trước, nhưng các lần sau không có kết quả terminal do `ng serve`/toolchain đang hoạt động. Không ghi nhận là build thành công.
- `invoice-sendmail-service/ConsumerApplication/SendMailConsumerApp.csproj` build 0 errors với 10 warnings hiện có/môi trường.
- `export-zip-pdf-service/ZipPdfInvConsumer/ZipPdfInvConsumer.csproj --no-restore` build 0 errors với 27 warnings hiện có/môi trường.

## Rủi ro và phụ thuộc

| Rủi ro/phụ thuộc | Giảm thiểu |
| --- | --- |
| Proxy sinh tự động đang được sửa tay tạm thời | Chạy `nswag/refresh.bat` với backend đang chạy trước phát hành. |
| Dữ liệu import không có quan hệ tỉnh | Bổ sung/tái nạp dữ liệu `tinhthanh_ma` trước khi người dùng chọn theo tỉnh. |
| API, DB, UI chưa QA thủ công có xác thực | Thực hiện checklist trong `testcase.md`. |
| Service proxy và config có thay đổi bẩn không liên quan | Tách/kiểm tra riêng trước khi phát hành. |
| Ba luồng XML chưa so khớp output thực tế | Tạo XML hóa đơn xe và hóa đơn thường qua backend chính, gửi mail, export ZIP/PDF; kiểm tra TC18/TC19. |
