---
feature: CBCLOUDV2-9544
status: implemented-awaiting-manual-test
updated_at: 2026-09-11
---

# Report — CBCLOUDV2-9544

## 1. Đã làm gì

- Xác định `GetHtmlPagingById` dùng XML view Type 1.
- Xác định `SaveAndSignInvoice` tạo XML ký Type 2 qua `SignAndAssignNOInvHSM`/`SignInv`.
- Bổ sung formatter XML dùng dấu chấm thập phân.
- Áp dụng formatter số lượng cho XML view và XML ký.
- Chuẩn hóa numeric gây `NaN` trên Type 1; giữ hành vi cũ cho trường tiền Type 2.
- Bổ sung unit test cho `1.34554`, null, số âm và làm tròn.

## 2. File đã thay đổi (thật)

| File | Thay đổi |
|---|---|
| `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/HoaDonTT3268Utility.cs` | Formatter và mapping numeric XML |
| `aspnet-core/src/hddt/HDDT.Application/Properties/AssemblyInfo.cs` | Cho project test truy cập helper internal |
| `aspnet-core/test/HDDT.Application.Tests/HDDT.Application.Tests.csproj` | Project unit test |
| `aspnet-core/test/HDDT.Application.Tests/HoaDon/HoaDonTT3268UtilityTests.cs` | Test định dạng số XML |

## 3. Kết quả kiểm chứng

### Tự động

| # | Lệnh đã chạy | Kết quả |
|---|---|---|
| 1 | `dotnet test aspnet-core/test/HDDT.Application.Tests/HDDT.Application.Tests.csproj --no-restore -m:1 -nr:false -p:BuildInParallel=false` | Pass 9/9, fail 0, skip 0 |
| 2 | `git diff --check` | Không có lỗi whitespace; có cảnh báo LF/CRLF |

Build có warning tồn tại sẵn về `SSH.NET 2020.0.2` và `System.Transactions`; không có test fail do thay đổi này.

### Thủ công

Chưa có bằng chứng nghiệm thu trên QA/CQT.

### Chưa chạy được

| Việc | Vì sao |
|---|---|
| Ký/gửi CQT cho thêm mới, điều chỉnh, thay thế | Phụ thuộc HSM/token, dữ liệu QA và CQT |
| Regression POS/PXK/mẫu đặc thù | Chưa có bộ dữ liệu tích hợp local |

## 4. Sai khác so với plan

Code được xử lý trước khi tạo ticket docs theo yêu cầu sửa lỗi trực tiếp. Bộ tài liệu này ghi nhận hậu kiểm; Gate 1 vẫn chờ DEV và TechLead xác nhận.

## 5. Việc còn lại / hạn chế đã biết

- Chạy TC-06 đến TC-10 trên QA.
- Ghi bằng chứng XML trước ký và phản hồi CQT.
- Review diff trước commit; chưa có commit/PR.

## 6. Đề xuất cập nhật docs (Gate 2)

Không có thay đổi nghiệp vụ hoặc kiến trúc cần cập nhật vào tài liệu hệ thống.

## 7. Link commit / PR

| Service | Commit / PR |
|---|---|
| invoicecore | Chưa có |
| docs | Chưa có |
