---
feature: CBCLOUDV2-9544
updated_at: 2026-09-11
---

# Tasks — CBCLOUDV2-9544

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Xác định nguyên nhân XML sai định dạng số | invoicecore | completed | S | Chưa có |
| 2 | Chuẩn hóa số lượng trong XML view và XML ký | invoicecore | completed | S | Chưa có |
| 3 | Xử lý trường tiền gây `NaN` trên XML view | invoicecore | completed | M | Chưa có |
| 4 | Bổ sung và chạy unit test | invoicecore | completed | S | Chưa có |
| 5 | Kiểm thử API và CQT | invoicecore | pending | M | Chưa có |
| 6 | Cập nhật tài liệu task | docs | completed | S | Chưa có |

## Task 1 — Xác định nguyên nhân

- **Status:** completed
- **Service:** `invoicecore`
- **Mô tả:** Xác định `GetHtmlPagingById` dùng Type 1, `SaveAndSignInvoice` dùng Type 2 và nguồn sinh `<SLuong>`.
- **Kiểm chứng:** Rà call site `TaoFileXmlAdapter` và `GetDSHHDVuInfo`.
- **File đã rà:** `HoaDonAppService.cs`, `HoaDonUtilityAdapter.cs`, `HoaDonTT3268Utility.cs`.

## Task 2 — Chuẩn hóa số lượng XML

- **Status:** completed
- **Service:** `invoicecore`
- **Mô tả:** Sinh số lượng bằng định dạng XML bất biến cho Type 1, Type 2 và call không truyền Type.
- **Tiêu chí chấp nhận:** `1,34554` được serialize thành `1.34554`.
- **File đã chạm:** `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/HoaDonTT3268Utility.cs`.

## Task 3 — Xử lý numeric Type 1

- **Status:** completed
- **Service:** `invoicecore`
- **Mô tả:** Chuẩn hóa numeric Type 1 và đưa tổng chiết khấu null về `0`; Type 2 giữ logic tiền cũ.
- **Tiêu chí chấp nhận:** HTML không còn `NaN` và nguồn chiết khấu đúng nghiệp vụ.
- **File đã chạm:** `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/HoaDonTT3268Utility.cs`.

## Task 4 — Unit test

- **Status:** completed
- **Service:** `invoicecore`
- **Mô tả:** Tạo project test và kiểm thử formatter số XML.
- **Kiểm chứng:** `dotnet test ...HDDT.Application.Tests.csproj` → 9/9 pass.
- **File đã chạm:** `aspnet-core/test/HDDT.Application.Tests/`, `HDDT.Application/Properties/AssemblyInfo.cs`.

## Task 5 — Kiểm thử API và CQT

- **Status:** pending
- **Service:** `invoicecore`
- **Mô tả:** Kiểm thử thủ công thêm mới, điều chỉnh, thay thế và xác nhận CQT tiếp nhận.
- **Kiểm chứng:** TC-06 đến TC-10 trong `testcase.md`.
- **Phụ thuộc:** Môi trường ký và kết nối CQT.

## Task 6 — Cập nhật tài liệu

- **Status:** completed
- **Service:** `docs`
- **Mô tả:** Ghi nhận yêu cầu, cách sửa, testcase, ảnh hưởng và kết quả thực tế.
- **File đã chạm:** `features/CBCLOUDV2-9544/`.

