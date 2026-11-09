# Expect — CBCLOUDV2-9162: [DEV] [Admin-Cloud]Danh mục tỉnh thành/ xã phường

> BA sở hữu file này. Viết mong muốn ĐÃ clear với người dùng. Không viết cách làm (đó là việc của plan).

status: approved   # NGUỒN DUY NHẤT của status vòng đời: draft → plan-review → approved → in-progress → testing → done
                # Chỉ người (BA/TechLead) đổi. AI không tự đổi sang approved.
jira: CBCLOUDV2-9162
  - System: Cloud
  - Service: invoicemanagement
  - BE: invoicemanagement/aspnet-core → `D:\BILL\invoicemanagement\aspnet-core`
  - FE: invoicemanagement/angular → `D:\BILL\invoicemanagement\angular`
  - Git base: `origin/develop_cloud`
  - Git branch đề xuất: `hungtq_dev_cloud`

## Bối cảnh / Vấn đề
- Có màn **Danh mục tỉnh thành trên admin nhưng muốn tạo 1 danh mục tỉnh thành mới :"Tỉnh thành mới" có crud đầy đủ giống màn Danh mục tỉnh thành
- đã có bảng trong DB: vs_danhmuc_tinh_thanh, vs_danhmuc_xa_phuong

## Mong muốn
Tạo 1 danh mục "tỉnh thành mới" và "xã phường" theo tài liệu ở D:\BILL\docs\features\CBCLOUDV2-9162\attachment.md
Lưu ý:
1. xã phải map với tỉnh

2. danh sách chính xác đã có đủ và ở trong file trên nhóm, tách ra làm dữ liệu để chạy chính xác trên demo luôn
Lưu redis sau thi thêm dữ liệu:
1. có 1 key chứa danh sách tỉnh thành: VS_LIST_PROVINCE
2. Mỗi Tỉnh sẽ có 1 key riêng để lưu xã phường: VS_LIST_WARD_[province_code]

Khi có cập nhật, thay đổi dữ liệu cần update lại redis

## Acceptance Criteria

- [x Có màn **Danh mục tỉnh thành trên admin nhưng muốn tạo 1 danh mục tỉnh thành mới :"Tỉnh thành mới" có crud đầy đủ giống màn Danh mục tỉnh thành
- [x Người có quyền `Admin.DanhMuc.TỉnhThành` xem được danh sách; quyền create/edit/delete/import điều khiển nút tương ứng.
- [x Tìm kiếm theo mã hoặc tên tỉnh thành
- [x Thêm mới tỉnh thành: bắt buộc mã/tên, normalize mã trim/bỏ khoảng trắng/uppercase, chặn trùng mã đang hiệu lực/chưa xóa mềm.
- [x Sửa tỉnh thành: cho sửa tên, ngày bắt đầu, ngày kết thúc, hiệu lực; giữ ổn định mã theo pattern danh mục hiện có.
- [x Xóa tỉnh thành bằng soft-delete, không hiển thị trong danh sách active.
- [x Xuất Excel danh sách tỉnh thành theo filter hiện tại.
- [x Tải file mẫu và nhập Excel danh sách tỉnh thành; validate header/dữ liệu/duplicate và báo lỗi rõ.


## Out-of-scope



## Câu hỏi mở

