# Expect — CBCLOUDV2-8963: [Cloud][ND254][Admin] Danh mục quốc tịch

> BA sở hữu file này. Viết mong muốn ĐÃ clear với người dùng. Không viết cách làm (đó là việc của plan).

status: approved   # NGUỒN DUY NHẤT của status vòng đời: draft → plan-review → approved → in-progress → testing → done
                # Chỉ người (BA/TechLead) đổi. AI không tự đổi sang approved.
jira: CBCLOUDV2-8963
  - System: Cloud
  - Service: invoicemanagement
  - BE: invoicemanagement/aspnet-core → `D:\BILL\invoicemanagement\aspnet-core`
  - FE: invoicemanagement/angular → `D:\BILL\invoicemanagement\angular`
  - Git base: `origin/develop_cloud`
  - Git branch đề xuất: `hungtq_dev_cloud`

## Bối cảnh / Vấn đề

CBCLOUDV2-8963 là task phát triển cho hệ thống **Cloud**. Nghiệp vụ giống CBCLOUDV2-8988 đã làm cho hệ thống Liên Sơn: bổ sung danh mục mã quốc tịch theo ND254 trên admin service.

Dữ liệu tham chiếu mẫu:

| STT | Mã | Tên |
|---:|---|---|
| 1 | AD | Andorran |
| 2 | AE | Utd.Arab Emir. |
| 3 | AF | Afghanistan |
| 4 | AG | Antigua/Barbuda |
| 5 | AI | Anguilla |
| 6 | AL | Albania |
| 7 | AM | Armenia |

## Mong muốn

- Tại service admin Cloud tạo màn hình đầy đủ thêm, sửa, xoá, tìm kiếm, xuất Excel cho danh mục quốc tịch.
- Tạo thêm bảng `vs_dm_ncc_quoctich` cho hệ thống Cloud.
- Cache danh mục lên Redis và có cơ chế cập nhật/xóa cache khi dữ liệu thay đổi.
- Phát triển từ nhánh git Cloud `develop_cloud`, sinh nhánh `hungtq_dev_cloud`.

## Acceptance Criteria

- [ ] Có màn **Danh mục quốc tịch** trên admin Cloud với route/menu riêng.
- [ ] Người có quyền `Admin.DanhMuc.QuocTich` xem được danh sách; quyền create/edit/delete/import điều khiển nút tương ứng.
- [ ] Tìm kiếm theo mã hoặc tên quốc tịch.
- [ ] Thêm mới quốc tịch: bắt buộc mã/tên, normalize mã trim/bỏ khoảng trắng/uppercase, chặn trùng mã đang hiệu lực/chưa xóa mềm.
- [ ] Sửa quốc tịch: cho sửa tên, ngày bắt đầu, ngày kết thúc, hiệu lực; giữ ổn định mã theo pattern danh mục hiện có.
- [ ] Xóa quốc tịch bằng soft-delete, không hiển thị trong danh sách active.
- [ ] Xuất Excel danh sách quốc tịch theo filter hiện tại.
- [ ] Tải file mẫu và nhập Excel danh sách quốc tịch; validate header/dữ liệu/duplicate và báo lỗi rõ.
- [ ] Danh sách không phân trang được cache bằng Redis qua ABP `ICacheManager`.
- [ ] Cache được clear/cập nhật sau Create/Update/Delete/Import, không cần restart service.
- [ ] Có script MariaDB tạo/rollback bảng trong `deploy.md`; không dùng EF migration.
- [ ] Kết quả build/test/manual thật được ghi trong `report.md`, không fake pass.

## Out-of-scope

- Không sửa nghiệp vụ danh mục quốc tịch của hệ thống Liên Sơn CBCLOUDV2-8988.
- Không chỉnh các repo ngoài `D:\BILL\invoicemanagement` cho phần code.
- Không thêm queue/message tích hợp ngoài dynamic ABP AppService.
- Không hardcode seed dài vào code nếu chưa có nguồn dữ liệu chính thức.
- Không ghi secret/connection string Redis/DB vào docs, code hoặc log.

## Câu hỏi mở

- [ ] Gate 1: BA/TechLead xác nhận AC và chuyển `status` sang `approved` trước khi code theo rule 02.
- [ ] DBA/TechLead xác nhận MariaDB version Cloud có hỗ trợ generated column để dùng unique active code theo script chính hay phải dùng fallback.
- [ ] Xác nhận dữ liệu Cloud là host-level giống danh mục NCC hiện có hay cần scope tenant riêng.
