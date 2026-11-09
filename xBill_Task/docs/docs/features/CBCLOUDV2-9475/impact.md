# CBCLOUDV2-9475 — Đánh giá phạm vi tác động (Impact Assessment)

## 1. Mục đích (Purpose)

Đánh giá phạm vi tác động kỹ thuật và nghiệp vụ khi triển khai tính năng cấu hình phương thức thanh toán mặc định khi lập hóa đơn điện tử cho hệ thống BillCloud (`CBCLOUDV2-9475`), chuyển giao từ `CBCLOUDV2-9416`.

## 2. Phạm vi thay đổi (Change Scope)

- **Loại thay đổi:** Thay đổi logic ứng dụng (logic-only), mở rộng schema cơ sở dữ liệu (schema extension nullable), cập nhật API contract nội bộ và giao diện người dùng.
- **Cơ sở dữ liệu:** Thêm 2 cột nullable vào bảng `vs_doanhnghiep_cauhinh`. Không dùng EF Core migration; sử dụng raw SQL script có review. Không sửa đổi dữ liệu cũ.
- **Tương thích ngược:** Cột mới nullable, dữ liệu cũ mang giá trị `NULL` tương đương với cấu hình TẮT, hoàn toàn không ảnh hưởng đến các service khác (`api-cloud-service`, `api-qldv-service`, các worker xử lý nền).

## 3. Thành phần bị ảnh hưởng (Affected Components)

| Tầng / Thành phần | File / Đối tượng | Mức độ ảnh hưởng | Mô tả chi tiết |
|---|---|---|---|
| **Database** | `vs_doanhnghiep_cauhinh` (Tenant DB) | 🟡 Trung bình | Thêm 2 cột: `cauhinh_phuongthucthanhtoan` (INT NULL), `isphuongthucthanhtoan` (TINYINT(1) NULL DEFAULT 0). |
| **Backend Core** | `DoanhNghiep_CauHinh.cs` | 🟢 Thấp | Thêm 2 property entity tương ứng. |
| **Backend DTO** | `DoanhNghiep_CauHinhDto.cs` | 🟢 Thấp | Thêm 2 property DTO cho API. |
| **Backend Service** | `DoanhNghiep_CauHinhAppService.cs` | 🟡 Trung bình | Inject repository `vs_dm_ncc_phuongthucthanhtoan`, thêm API `GetListPhuongThucThanhToan`, validate input trong `Update()` và xóa cache. |
| **Backend Service** | `HoaDonAppService.cs` | 🟡 Trung bình | Bổ sung hàm private `GetPhuongThucThanhToanMacDinh()`, cập nhật `InforHoaDonTongHop` để sao chép đủ mã/tên PTTT cho hóa đơn thay thế và áp dụng default an toàn không ghi đè mã 0. |
| **Frontend Proxies** | `service-proxies.ts` | 🟡 Trung bình | Thêm method và properties vào proxy client Angular. |
| **Frontend UI** | `doanhnghiep-cauhinh-tab.component.{html,ts}` | 🟡 Trung bình | Thêm switch toggle và dropdown chọn phương thức trong tab Cấu hình hiển thị. |
| **Frontend Service** | `hoadon.service.ts` | 🟡 Trung bình | Thêm `getPhuongThucThanhToanMacDinh()`, cập nhật `getHoaDonGoc()` cho hóa đơn mới, hóa đơn thay thế, điều chỉnh. |
| **Frontend UI** | 5 invoice components (`hoadon-goc`, `hoadonbanhang`, `hoadondiennuoc`, `hoa-don-ban-tai-san-cong`, `vemaybay`) | 🟢 Thấp | Bỏ gán cứng Tiền mặt trong constructor, phân biệt autocomplete vs custom text mã 0. |

## 4. Khu vực không thuộc phạm vi (Confirmed Unaffected)

- **Hóa đơn đã phát hành trong quá khứ:** Không quét hay cập nhật lại bất kỳ bản ghi hóa đơn nào đã lưu trong `vs_hoadon`.
- **Định dạng XML và PDF:** Trường `ThanhToan_PhuongThuc` và `ThanhToan_PhuongThuc_Ten` tiếp tục được đọc từ bản ghi hóa đơn như hiện tại; không thay đổi cấu trúc XML gửi cơ quan thuế hay template in PDF.
- **Hệ thống hàng đợi và Worker:** Không thay đổi hợp đồng tin nhắn RabbitMQ / Kafka; các worker xuất file ZIP/PDF, gửi email, gửi bảng kê hoạt động bình thường.
- **Các API service độc lập:** `api-cloud-service` và `api-qldv-service` không bị ảnh hưởng do 2 cột mới trong `vs_doanhnghiep_cauhinh` là nullable và không làm thay đổi các câu truy vấn hiện có.
- **Màn hình tra cứu công cộng (`searchBill` / `TraCuu`):** Không truy cập bảng cấu hình doanh nghiệp, hoàn toàn không bị ảnh hưởng.

## 5. Rủi ro và biện pháp giảm thiểu (Known Risks & Mitigations)

1. **Rủi ro:** Triển khai backend code trước khi DBA chạy script SQL trên database.
   - *Hậu quả:* EF Core quăng lỗi `Unknown column 'cauhinh_phuongthucthanhtoan'` khi đọc hoặc lưu cấu hình doanh nghiệp.
   - *Giảm thiểu:* Bắt buộc chạy script SQL trong `deploy.md` trước khi deploy bản cập nhật của `invoicecore`.
2. **Rủi ro:** Không xóa cache Redis cấu hình doanh nghiệp dẫn tới không áp dụng được cấu hình mới ngay lập tức.
   - *Hậu quả:* Người dùng vừa lưu cấu hình nhưng khi lập hóa đơn mới vẫn ra Tiền mặt.
   - *Giảm thiểu:* Đã tích hợp lời gọi `_cacheHelper.ClearCache` trong hàm `Update` với key chuẩn `${TenantId}_${MSTOrCCCD}`.
3. **Rủi ro:** Ghi đè phương thức thanh toán tùy chỉnh (mã 0) hoặc phương thức của hóa đơn thay thế.
   - *Hậu quả:* Mất thông tin thanh toán người dùng tự nhập (ví dụ: "Thẻ thành viên", "Voucher").
   - *Giảm thiểu:* Kiểm tra chặt chẽ điều kiện `string.IsNullOrWhiteSpace(ThanhToan_PhuongThuc_Ten)` trước khi áp dụng default.

## 6. Chưa được kiểm chứng (Not Verified)

- Các bước ký HSM, gửi cơ quan thuế (CQT) và gửi email thực tế chưa thể kiểm chứng trên môi trường local do phụ thuộc hạ tầng môi trường thật, cần QA kiểm chứng trên môi trường Staging/QA.

## 7. Kết luận (Conclusion)

Thay đổi mang tính cục bộ trong module Cấu hình và module Lập hóa đơn của BillCloud, rủi ro tổng thể ở mức **THẤP - TRUNG BÌNH**. Tính tương thích ngược được đảm bảo hoàn toàn. Có thể tiến hành triển khai sau khi DBA hoàn thành bước chạy SQL.
