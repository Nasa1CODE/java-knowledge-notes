---
feature: HKD-001
title: Khởi tạo Kiến trúc Nền tảng & Phân hệ Danh mục Dùng chung (Master Data)
status: done
services-affected: [hkd-backend-service]
owner: TechLead / Backend Dev
created_at: 2026-11-09
updated_at: 2026-11-09
---

# Expectation — HKD-001: Khởi tạo Kiến trúc Nền tảng & Danh mục Gốc

## 1. Hiện trạng (Context)

- Hệ thống Quản trị Kế toán Hộ Kinh Doanh (HKD) đang ở giai đoạn khởi tạo nền móng, chưa có cấu trúc mã nguồn backend và mô hình CSDL chuẩn.
- Các nghiệp vụ cốt lõi sau này (Hóa đơn bán hàng, Phiếu nhập/xuất kho, Sổ sách kế toán Thông tư 88, Kê khai thuế Thông tư 40) đều phụ thuộc 100% vào tập dữ liệu danh mục gốc (**Master Data**).
- Cần thiết lập khung kiến trúc chuẩn (Base Architecture) để đảm bảo:
  - Khả năng kiểm toán (Audit Trail: ai tạo, sửa lúc nào).
  - Khả năng kiểm soát xung đột dữ liệu đồng thời (Optimistic Locking).
  - Tuân thủ nghiêm ngặt quy định pháp lý kế toán thuế Việt Nam.

---

## 2. Kỳ vọng Nghiệp vụ (Expected Behavior)

Trích xuất từ các tài liệu nghiệp vụ: `3.5_SRS_Danh_muc.docx`, `3.12_Nhom_nganh_nghe_muc_thue.docx`, `3.13_Tai_khoan_ke_toan.docx`.

### 2.1. Danh mục Tài khoản Kế toán (Thông tư 88/2021/TT-BTC)
Hệ thống kế toán HKD áp dụng chế độ kế toán tinh gọn, không dùng hệ thống 4 chữ số phức tạp như Doanh nghiệp (Thông tư 200), mà dùng các tài khoản chuẩn sau:
- **Loại 1, 2 (Tài sản):**
  - `111` - Tiền mặt
  - `112` - Tiền gửi ngân hàng
  - `131` - Phải thu của khách hàng (Tài khoản lưỡng tính: Dư Nợ = Khách nợ, Dư Có = Khách trả trước)
  - `152` - Nguyên liệu, vật liệu
  - `156` - Hàng hóa
  - `211` - Tài sản cố định
- **Loại 3 (Nguồn vốn / Nợ phải trả):**
  - `331` - Phải trả cho người bán (Tài khoản lưỡng tính: Dư Có = Nợ NCC, Dư Nợ = Trả trước NCC)
  - `333` - Thuế và các khoản phải nộp Nhà nước
  - `334` - Phải trả người lao động
- **Loại 5 (Doanh thu):**
  - `511` - Doanh thu bán hàng và cung cấp dịch vụ
- **Loại 6 (Chi phí):**
  - `642` - Chi phí quản lý và bán hàng
- **Loại 9 (Xác định kết quả kinh doanh):**
  - `911` - Xác định kết quả kinh doanh

### 2.2. Danh mục Nhóm Ngành Nghề & Biểu Thuế (Thông tư 40/2021/TT-BTC)
HKD nộp thuế theo tỷ lệ % tính trên doanh thu theo 4 nhóm ngành nghề chính:
1. **Phân phối, cung cấp hàng hóa:** Thuế GTGT 1% + Thuế TNCN 0.5% (Tổng: 1.5%).
2. **Dịch vụ, xây dựng không bao thầu nguyên vật liệu:** Thuế GTGT 5% + Thuế TNCN 2% (Tổng: 7%).
3. **Sản xuất, vận tải, dịch vụ có gắn với hàng hóa, xây dựng có bao thầu NVL:** Thuế GTGT 3% + Thuế TNCN 1.5% (Tổng: 4.5%).
4. **Hoạt động kinh doanh khác:** Thuế GTGT 2% + Thuế TNCN 1% (Tổng: 3%).

### 2.3. Danh mục Khách hàng & Nhà cung cấp (Partners)
- Quản lý thông tin đối tác: Mã đối tác, Tên, Loại đối tác (`CUSTOMER`, `SUPPLIER`, `BOTH`), Mã số thuế / CCCD, Địa chỉ, Số điện thoại, Email, Tài khoản công nợ mặc định (131 hoặc 331).

### 2.4. Danh mục Hàng hóa, Dịch vụ & Đơn vị tính (Products & Units)
- Mã hàng hóa (SKU), Tên hàng hóa, Loại (`GOODS` - Hàng hóa, `SERVICE` - Dịch vụ, `MATERIAL` - Vật tư).
- Đơn vị tính cơ sở (`Unit`).
- Nhóm ngành nghề tính thuế trực thuộc (Liên kết `TaxCategory` để khi bán hàng tự động tính đúng thuế suất).
- Giá mua tham chiếu, Giá bán tham chiếu, Cờ theo dõi tồn kho (`trackInventory = true/false`).

---

## 3. Tiêu chí Nghiệm thu (Acceptance Criteria)

- **AC-1 (Base Entity & Audit):** Mọi bảng dữ liệu nghiệp vụ đều kế thừa `BaseEntity` gồm: `id` (UUID hoặc BIGINT Identity), `created_at`, `updated_at`, `created_by`, `updated_by`, `is_deleted` (Soft Delete), `version` (Optimistic Locking).
- **AC-2 (Data Seeding TT88 & TT40):** Khi khởi chạy ứng dụng, hệ thống tự động khởi tạo (seed) đầy đủ danh mục Tài khoản kế toán TT88 và 4 Nhóm biểu thuế TT40 nếu chưa tồn tại.
- **AC-3 (Validation):**
  - Mã tài khoản, Mã hàng hóa, Mã đối tác là duy nhất trong cùng 1 Hộ kinh doanh (Tenant).
  - Tỷ lệ thuế suất không được âm, tổng thuế GTGT + TNCN phải chính xác theo quy định.
- **AC-4 (JPA Contracts):** Các Entity tuân thủ chuẩn an toàn bộ nhớ và Session của Hibernate: không dùng `@Data` / `@EqualsAndHashCode` sinh tự động của Lombok làm hỏng `Set` / `Map`.

---

## 4. Phạm vi Loại trừ (Out Of Scope)

- Chưa thực hiện màn hình giao diện (UI Frontend).
- Chưa xử lý các giao dịch kế toán phát sinh (Hóa đơn, Phiếu thu chi) - sẽ thực hiện ở `HKD-002` trở đi.
