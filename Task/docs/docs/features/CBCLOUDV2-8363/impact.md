# CBCLOUDV2-8363 Impact

## Purpose

Đánh giá phạm vi ảnh hưởng của việc sửa lỗi danh sách chứng thư số không tự cập nhật (loading treo, phải F5) sau khi thêm/xóa.

## Phạm vi thay đổi

- Chỉ sửa logic refresh danh sách phía frontend của tab Chứng thư số.
- Không thay đổi backend, DTO, service-proxy, database.

## Thành phần bị ảnh hưởng

| Thành phần | File | Thay đổi | Mức ảnh hưởng |
| --- | --- | --- | --- |
| Tab Chứng thư số (logic) | `frontend_angular/.../thongtindoanhnghiep/doanhnghiep-chungthu-tab.component.ts` | `loadChungThu` thêm param `delay` + xử lý lỗi; `xoaChungThu` gọi `loadChungThu(0)`; `timKiemChungThu` thêm xử lý lỗi | Trung bình |
| Tab Chứng thư số (view) | `frontend_angular/.../thongtindoanhnghiep/doanhnghiep-chungthu-tab.component.html` | `(modalSave)` gọi `loadChungThu(0)` | Thấp |

## Không bị ảnh hưởng (đã xác nhận)

| Thành phần | Vì sao |
| --- | --- |
| Backend HDDT (`getAll_Mst`, `getAll`, `delete`, `createOrEdit`) | Không sửa, giữ nguyên contract |
| Modal thêm chứng thư số (`doanhnghiep-chungthu-tab-thongtin.component.ts`) | Không sửa; vẫn phát `modalSave` sau khi lưu thành công |
| Các tab khác (ngân hàng, liên hệ, email, gói dịch vụ, tổng cục thuế, thông tin chung) | Không đụng tới |
| `PrimengTableHelper` | Không sửa |
| Database | Không có thay đổi schema/dữ liệu |

## Rủi ro / Hạn chế đã biết

1. Refresh sau thêm/xóa dùng `getAll_Mst` nên bỏ qua ô tìm kiếm `tenchungthu` (hiển thị lại toàn bộ danh sách). Đây là hành vi giống lần tải đầu/F5 và phù hợp kỳ vọng, không coi là lỗi.
2. `reloadPage()` trở thành hàm không còn được gọi (giữ lại để tránh rủi ro; không có tham chiếu khác).

## Chưa được kiểm chứng (Not Verified)

- `npm run build` cho `frontend_angular` — chưa chạy.
- Kiểm thử thủ công trên môi trường chạy (thêm/xóa chứng thư số) — chưa thực hiện.

## Kết luận

Thay đổi phạm vi hẹp (2 file frontend, cùng 1 tab), rủi ro thấp, không đổi backend/DB. Cần build + kiểm thử thủ công trước khi release.
