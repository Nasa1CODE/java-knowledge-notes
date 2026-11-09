# CBCLOUDV2-8363 Expect

## Feature Status

- Status: in-progress
- Class: Bug fix
- Source: Jira bug CBCLOUDV2-8363

## Bug Description

Màn hình: Hệ thống > Thông tin doanh nghiệp > Chứng thư số
(`/app/hddt/cauhinh/thongtindoanhnghiep`, tab Chứng thư số).

Các bước tái hiện:

1. Vào Hệ thống > Thông tin doanh nghiệp > Chứng thư số.
2. Click xóa một chứng thư số.
3. Click thêm chứng thư số > chọn chứng thư số > Lưu.

Kết quả thực tế:

- Sau khi **xóa** chứng thư số, hệ thống bị loading mãi, phải F5 lại danh sách mới cập nhật.
- Sau khi **thêm** chứng thư số, hệ thống bị loading mãi, phải F5 lại danh sách mới cập nhật.

Kết quả mong muốn:

- Sau khi thêm hoặc xóa chứng thư số, danh sách phải tự cập nhật ngay lập tức, không cần F5.

## Root Cause (đã xác định qua đọc source)

File: `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-chungthu-tab.component.ts` (+ `.html`).

- Lần tải đầu và khi F5 dùng `loadChungThu()` → `_chungThuServiceProxy.getAll_Mst()` — đây là đường dẫn tải dữ liệu hoạt động ổn định (nên F5 luôn cập nhật đúng).
- Sau khi **thêm** (`(modalSave)="timKiemChungThu()"`) và sau khi **xóa** (`reloadPage()` → `paginator.changePage()` → `timKiemChungThu()`) lại dùng một đường dẫn khác: `getAll()` được kích hoạt gián tiếp qua `paginator.changePage()`.
- Đường dẫn này (1) phụ thuộc vào việc `paginator.changePage()` phát sự kiện `onPageChange`, và (2) không có xử lý lỗi trong `subscribe`, nên khi request không hoàn tất/không phát sự kiện thì overlay loading (`primengTableHelper.isLoading`) được bật nhưng không bao giờ được tắt → "loading mãi" và danh sách không cập nhật cho tới khi F5.

## Acceptance Criteria

- Xóa chứng thư số: danh sách cập nhật ngay (bản ghi biến mất), không còn loading treo, không cần F5.
- Thêm chứng thư số: danh sách cập nhật ngay (bản ghi mới xuất hiện), không còn loading treo, không cần F5.
- Overlay loading luôn được tắt kể cả khi request thất bại.
- Không thay đổi hành vi các tab khác của màn Thông tin doanh nghiệp.

## Out Of Scope

- Không thay đổi backend (`getAll_Mst`, `getAll`, `delete`, `createOrEdit` giữ nguyên).
- Không thay đổi luồng đọc chứng thư số từ phần mềm ký client trong modal thêm.
- Không thay đổi các tab khác (ngân hàng, liên hệ, email, gói dịch vụ, tổng cục thuế...).
