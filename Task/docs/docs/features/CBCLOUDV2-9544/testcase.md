---
feature: CBCLOUDV2-9544
updated_at: 2026-09-11
---

# Testcase — CBCLOUDV2-9544

## Truy vết AC → case

| AC | Case |
|---|---|
| AC1 | TC-01, TC-06 |
| AC2 | TC-07, TC-08, TC-09 |
| AC3 | TC-02, TC-03, TC-06 |
| AC4 | TC-04, TC-05 |
| AC5 | TC-10 |

## Test tự động

| ID | Dữ liệu / thao tác | Kết quả mong đợi |
|---|---|---|
| TC-01 | Format số lượng `1.34554` dưới culture bất kỳ | Kết quả `1.34554`, không chứa dấu phẩy |
| TC-02 | Format numeric bằng `0` | Kết quả `0`, XSLT chuyển đổi được sang số |
| TC-03 | Tổng chiết khấu thương mại null trên Type 1 | XML sinh `0`, HTML không có `NaN` |
| TC-04 | Tắt làm tròn với `1.34554` | Giữ nguyên `1.34554` |
| TC-05 | Bật làm tròn 4 chữ số | `1.34554` thành `1.3455`; `1.34555` thành `1.3456` |

## Test thủ công

### TC-06 — Xem hóa đơn phân trang

- **AC liên quan:** AC1, AC3
- **Loại:** luồng chính
- **auto/manual:** manual
- **Tiền đề:** Hóa đơn nhập có dòng ghi chú số lượng `1,34554`; tổng chiết khấu để trống.
- **Bước:** Gọi `hddt/HoaDon/GetHtmlPagingById` và mở HTML.
- **Kết quả:** Số lượng hiển thị đúng; số lượng và tổng chiết khấu không có `NaN`.

### TC-07 — Thêm mới và ký hóa đơn

- **AC liên quan:** AC2
- **Loại:** luồng chính
- **auto/manual:** manual — phụ thuộc HSM/token và CQT
- **Bước:** Thêm mới hóa đơn có số lượng `1,34554`, sau đó ký.
- **Kết quả:** XML có `<SLuong>1.34554</SLuong>` và không lỗi chuyển đổi dữ liệu sang số.

### TC-08 — Điều chỉnh hóa đơn

- **AC liên quan:** AC2
- **Loại:** hồi quy
- **auto/manual:** manual — phụ thuộc HSM/token và CQT
- **Bước:** Lập và ký hóa đơn điều chỉnh có số lượng thập phân.
- **Kết quả:** XML số lượng dùng dấu chấm; ký và gửi thành công.

### TC-09 — Thay thế hóa đơn

- **AC liên quan:** AC2
- **Loại:** hồi quy
- **auto/manual:** manual — phụ thuộc HSM/token và CQT
- **Bước:** Lập và ký hóa đơn thay thế có số lượng thập phân.
- **Kết quả:** XML số lượng dùng dấu chấm; ký và gửi thành công.

### TC-10 — Hồi quy trường tiền Type 2

- **AC liên quan:** AC5
- **Loại:** hồi quy
- **auto/manual:** manual
- **Bước:** So sánh XML Type 2 trước/sau với cùng đơn giá, thành tiền, thuế và chiết khấu.
- **Kết quả:** Chỉ biểu diễn `<SLuong>` thay đổi; nguồn và giá trị nghiệp vụ của trường tiền không đổi.

## Case biên bổ sung

- Số lượng null, `0`, số nguyên, số âm.
- Bật/tắt làm tròn với số lượng có nhiều chữ số thập phân.
- Hóa đơn thường, điều chỉnh, thay thế, phiếu xuất kho và POS.
- Tenant khác không truy cập được dữ liệu hóa đơn; thay đổi không tác động tenant scope.

