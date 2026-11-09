# [CBCLOUDV2-8312] Báo cáo doanh thu theo bên mua & theo sản phẩm — export lớn đưa vào Quản lý xuất file

- Jira: https://jira.cybertech.vn/browse/CBCLOUDV2-8312
- Trạng thái: draft
- Class: Medium
- Liên quan: CBCLOUDV2-8391 (đã làm export ngầm cho Báo cáo doanh thu theo sản phẩm)

## Bối cảnh & vấn đề

Khi người dùng xuất Excel "Báo cáo doanh thu theo bên mua" với khoảng từ ngày – đến ngày lớn, dữ liệu vượt khả năng xử lý trong request/response, API bị timeout và người dùng nhận lỗi. Cần chuyển các export lớn sang xử lý nền (background) giống cơ chế đã áp dụng cho "Báo cáo doanh thu theo sản phẩm" ở CBCLOUDV2-8391. Đồng thời màn "Quản lý xuất file" hiện chưa phân biệt được loại file export, cần thêm cột "Loại file".

Lý do làm ngay: cam kết với khách hàng.

## Mong muốn (User Story)

- Là **người dùng có quyền xuất báo cáo**, tôi muốn khi export báo cáo với dữ liệu lớn, hệ thống tiếp nhận và xử lý ngầm thay vì báo lỗi timeout, để tôi có thể quay lại tải file khi hoàn thành.
- Là **người dùng**, tôi muốn màn "Quản lý xuất file" có cột "Loại file" để phân biệt file hóa đơn với các file báo cáo.
- Là **admin QLDV**, tôi muốn cấu hình được ngưỡng số bản ghi (`CLOUD_ACTIVE_MAX_REPORT`) trên trang admin để điều chỉnh khi nào export chuyển sang chạy ngầm.

## Acceptance Criteria (Given-When-Then)

### Export ngầm — Báo cáo doanh thu theo bên mua

- Given người dùng ở màn `/app/hddt/baocao/tinhhinhsudunghoadontheobenmua`, When export với số bản ghi **≤ ngưỡng** `CLOUD_ACTIVE_MAX_REPORT`, Then hệ thống trả file Excel trực tiếp như hiện tại.
- Given người dùng export với số bản ghi **> ngưỡng**, When gọi API export, Then hệ thống tạo job `ServiceExportBill`, đẩy vào queue `ExportData`, và hiển thị popup "Tiến trình xuất file đang thực hiện, vui lòng download file tại Quản lý tải file" kèm link clickable đến `/app/hddt/hoadon/xuatfile-excel` (giống hành vi 8391).
- Given job export đã được tạo, When worker `AppServiceExportBillHost` xử lý xong, Then job trong "Quản lý xuất file" chuyển trạng thái thành công và người dùng click để download được file Excel.
- Given ngưỡng không tồn tại trong Redis, When export, Then đọc từ DB; nếu vẫn thiếu hoặc không hợp lệ thì fallback `50000` (giống 8391).

### Cột "Loại file" — màn Quản lý xuất file

- Given màn `/app/hddt/hoadon/xuatfile-excel`, When hiển thị danh sách, Then có thêm cột "Loại file" với giá trị:
  - Dữ liệu export hóa đơn (bao gồm dữ liệu cũ) → "Hóa đơn".
  - Job từ báo cáo theo sản phẩm → "Báo cáo doanh thu theo sản phẩm".
  - Job từ báo cáo theo bên mua → "Báo cáo doanh thu theo bên mua".
- Given dữ liệu cũ trước release, When xem danh sách, Then các dòng cũ hiển thị "Hóa đơn", không cần migrate dữ liệu.

### Cấu hình admin

- Given admin QLDV đăng nhập `fe-xbill-admin-cloud`, When mở màn cấu hình tham số hệ thống có sẵn, Then chỉnh sửa được giá trị `CLOUD_ACTIVE_MAX_REPORT` (áp dụng toàn hệ thống).
- Given admin cập nhật giá trị mới, When người dùng export sau đó, Then ngưỡng mới có hiệu lực (Redis/DB được cập nhật tương ứng).

### Đồng bộ báo cáo theo sản phẩm (8391)

- Given báo cáo doanh thu theo sản phẩm đã có export ngầm từ 8391, When 8312 release, Then hành vi của nó khớp với hành vi mới (cột Loại file hiển thị đúng tên), không thay đổi flow đã chạy.

## Phạm vi

### In-scope

- `frontend_angular`: màn báo cáo theo bên mua (xử lý response status 2 → popup + link); màn Quản lý xuất file (thêm cột Loại file).
- `invoicecore`: `TaiExcel` của báo cáo theo bên mua — kiểm tra ngưỡng, tạo `ServiceExportBill`, đẩy queue `ExportData`; API danh sách xuất file trả thêm thông tin loại file.
- `AppServiceExportBillHost` (worker): thêm service export riêng cho báo cáo theo bên mua, routing theo `XuatFile_MoTa`.
- `fe-xbill-admin-cloud`: thêm key `CLOUD_ACTIVE_MAX_REPORT` vào màn cấu hình tham số có sẵn.
- Rà soát báo cáo theo sản phẩm (8391) hiển thị đúng cột Loại file.

### Out-of-scope

- Không thay đổi database schema (tận dụng `XuatFile_MoTa` hiện có để phân loại).
- Không thay đổi flow export hóa đơn hiện tại.
- Không chia nhỏ/zip file Excel lớn.
- Không thêm permission mới — dùng quyền xem/xuất báo cáo hiện có.
- Không cấu hình ngưỡng theo tenant — chỉ 1 giá trị toàn hệ thống.
- Không thêm thông báo email/notification khi export hoàn thành.

## Luồng nghiệp vụ liên quan

- `docs/specs/system.md` — mục 5.7 (PDF, ZIP, XML, Excel output), 6.5 (Asynchronous processing).
- `docs/features/CBCLOUDV2-8391/` — pattern export ngầm báo cáo, tái sử dụng toàn bộ cơ chế queue/worker/message.
- Chưa có spec domain `docs/specs/baocao.md` — cần tạo hoặc bổ sung khi đóng feature (Gate 2).

## Dữ liệu & quy tắc nghiệp vụ

- Ngưỡng: số bản ghi, key `CLOUD_ACTIVE_MAX_REPORT`, đọc Redis → DB → fallback `50000` (dùng chung key với 8391, không tạo key riêng).
- Job discriminator: `XuatFile_MoTa = "BaoCaoDoanhThuTheoBenMua"` (đề xuất, thống nhất với pattern `"BaoCaoDoanhThuTheoSanPham"` của 8391).
- Input export gốc serialize vào `XuatFile_ThamSo`; `TotalCount`/`MaxReportCount` nằm trong export input object, không nằm trong DTO public (theo chuẩn 8391).
- Tên file download giữ theo `XuatFile_DuongDan` (đã fix ở 8391).
- Phân quyền: theo quyền xem/xuất báo cáo hiện có, không thêm permission.
- Mapping cột Loại file thực hiện ở tầng hiển thị/API, không migrate dữ liệu cũ.

## Câu hỏi mở

1. Khi job export lỗi (worker fail), màn Quản lý xuất file hiển thị trạng thái/thông báo gì? Có cho phép người dùng chạy lại không, hay giữ nguyên hành vi hiện tại của export hóa đơn?
2. Màn cấu hình admin hiện tại lưu tham số vào đâu (DB config table hay Redis trực tiếp)? Khi admin sửa giá trị, có cần cơ chế invalidate/ghi đè Redis không?
3. Cột "Loại file" có cần filter/search theo loại không, hay chỉ hiển thị?
4. Ngoài export hóa đơn và 2 báo cáo này, màn Quản lý xuất file có loại job nào khác (chứng từ, bảng kê...) cần định nghĩa tên hiển thị không?
5. File export báo cáo có thời hạn lưu trữ/xóa tự động không?
6. Giá trị hiển thị "Loại file" có cần đa ngôn ngữ (localization key) hay hardcode tiếng Việt?
