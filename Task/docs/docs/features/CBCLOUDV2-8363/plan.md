# CBCLOUDV2-8363 Plan

## Status

- Status: implemented
- Gate 1 plan review: bug fix nhỏ, phạm vi 2 file frontend; thực hiện trực tiếp theo yêu cầu.

## Goal

Sửa lỗi danh sách chứng thư số không tự cập nhật (loading treo, phải F5) sau khi thêm/xóa chứng thư số, tại màn Hệ thống > Thông tin doanh nghiệp > tab Chứng thư số.

## Context

- Service liên quan: `frontend_angular/` (`docs/architecture.md` §6, §13 — UI/màn hình thuộc `frontend_angular/src/app/hddt/`).
- Component: `src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-chungthu-tab.component.ts` + `.html`.
- Modal thêm: `doanhnghiep-chungthu-tab-thongtin.component.ts` (không sửa, chỉ phát `modalSave` sau khi lưu thành công).
- `PrimengTableHelper` (`src/shared/helpers/PrimengTableHelper.ts`): `shouldResetPaging(event)` trả về `true` khi không có `event`; `showLoadingIndicator`/`hideLoadingIndicator` bật/tắt cờ `isLoading` dùng cho `[busyIf]`.

## Approach

Thống nhất đường dẫn refresh sau thêm/xóa về đúng đường dẫn đã hoạt động ổn định (giống F5): `loadChungThu()` → `getAll_Mst()`, thay vì phụ thuộc vào `paginator.changePage()`. Đồng thời đảm bảo overlay loading luôn được tắt kể cả khi request lỗi.

Thay đổi cụ thể:

1. `loadChungThu(delay: number = 2000)`: thêm tham số `delay` để refresh sau CRUD có thể chạy ngay (`delay = 0`), giữ nguyên delay 2000ms cho lần tải đầu ở `ngOnInit`. Thêm callback error trong `subscribe` để luôn gọi `hideLoadingIndicator()`.
2. `xoaChungThu`: sau khi `delete` thành công, gọi `this.loadChungThu(0)` thay cho `this.reloadPage()`.
3. `timKiemChungThu`: thêm callback error để luôn tắt loading (đường dẫn tìm kiếm/phân trang).
4. HTML: đổi `(modalSave)="timKiemChungThu()"` thành `(modalSave)="loadChungThu(0)"` để luồng thêm dùng cùng đường dẫn refresh ổn định.

Ghi chú: `reloadPage()` được giữ lại (không còn được gọi) để tránh rủi ro, không có tham chiếu nào khác tới nó.

## Impact

- Frontend: 2 file (`doanhnghiep-chungthu-tab.component.ts`, `doanhnghiep-chungthu-tab.component.html`).
- Backend/DB: không đổi.
- Các tab khác của Thông tin doanh nghiệp: không đổi.

## Verification Plan

- `get_diagnostics` trên 2 file đã sửa: không có lỗi.
- Cần build/kiểm thử: `npm run build` trong `frontend_angular/` và kiểm thử thủ công thêm/xóa chứng thư số trên môi trường chạy (xem `report.md` phần Verification).

## Risk

| Risk | Impact | Mitigation | Rollback |
| --- | --- | --- | --- |
| `getAll_Mst` bỏ qua filter tìm kiếm `tenchungthu` khi refresh | Thấp — sau thêm/xóa hiển thị toàn bộ danh sách (giống lần tải đầu/F5, đúng kỳ vọng) | Chấp nhận; đồng bộ với hành vi tải đầu | Revert về `reloadPage()`/`timKiemChungThu()` |
| Refresh delay 0 nhưng backend chưa kịp phản ánh thay đổi | Thấp — `delete`/`createOrEdit` đã trả về trước khi refresh | Refresh chỉ chạy trong callback thành công của thao tác CRUD | Tăng nhẹ delay nếu cần |

## Rollback

Revert 2 file frontend về trạng thái trước (khôi phục `reloadPage()` trong `xoaChungThu`, `(modalSave)="timKiemChungThu()"` trong HTML, và bỏ tham số/handler error).
