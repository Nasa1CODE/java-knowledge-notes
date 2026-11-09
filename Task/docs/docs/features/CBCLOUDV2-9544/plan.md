---
feature: CBCLOUDV2-9544
title: "Lỗi Thêm mới/điều chỉnh/thay thế hóa đơn nhập"
plan-status: plan-review
service: invoicecore
service-repo: ./invoicecore
created_at: 2026-09-11
updated_at: 2026-09-11
---

# Plan — CBCLOUDV2-9544

## Câu hỏi chặn (blocking)

Không có.

## Mục tiêu

- Chuẩn hóa riêng trường số lượng cho XML view và XML ký (AC1, AC2).
- Bảo đảm trường tiền trên XML view luôn là chuỗi số hợp lệ (AC3).
- Kiểm thử làm tròn và culture `vi-VN` (AC4).
- Giữ nhánh xử lý tiền cũ cho `Type = 2` (AC5).

## Bối cảnh

- `hddt/HoaDon/GetHtmlPagingById` sử dụng XML view `Type = 1`.
- `SaveAndSignInvoice` đi qua `SignAndAssignNOInvHSM` hoặc `SignInv`, tạo XML ký bằng `TaoFileXmlAdapter(..., 2)`.
- Hai loại XML cùng dựng chi tiết qua `HoaDonTT3268Utility.GetDSHHDVuInfo`.

## Nguyên nhân gốc

`GetDSHHDVuInfo` dùng `DoFormat` cho `HangHoa_SoLuong`. Formatter này có thể sinh dấu phẩy thập phân như `1,34554`, không phù hợp khi XSLT/CQT chuyển đổi sang số. Một số tổng tiền Type 1 còn có thể là chuỗi rỗng khi nguồn dữ liệu null, làm HTML hiển thị `NaN`.

## Giả định · Câu hỏi mở · Ngoài phạm vi

- **Giả định:** `Type = 1` là XML hiển thị; `Type = 2` là XML tạo để ký/gửi.
- **Câu hỏi mở:** Không có.
- **Ngoài phạm vi:** FE, database, API contract, Redis, cấu hình và XML utility khác.

## Cách làm

1. Bổ sung formatter số XML dùng `CultureInfo.InvariantCulture`.
2. Dùng formatter cho `<SLuong>` ở cả XML view và XML ký.
3. Chỉ chuẩn hóa trường tiền khi `input.Type == 1`; giữ nhánh cũ cho Type 2.
4. Với tổng chiết khấu thương mại Type 1, dùng đúng nguồn nghiệp vụ và đưa null về `0`.
5. Bổ sung unit test cho dấu chấm, null, số âm, làm tròn và `1.34554`.

## Thay đổi kỹ thuật

| Hạng mục | Có/Không | Chi tiết |
|---|---|---|
| Entity / migration | Không | Không đổi dữ liệu hoặc schema |
| DTO / AppService | Không | Chỉ xác minh call chain `SaveAndSignInvoice` |
| XML utility | Có | `HoaDonTT3268Utility` |
| Màn hình / route | Không | Không sửa FE |
| Hàng đợi / tích hợp | Không | Không đổi contract CQT |
| Cấu hình | Không | Không thêm Redis/config |

## Thứ tự thực hiện & phụ thuộc

1. Xác định call chain Type 1 và Type 2.
2. Sửa formatter và mapping XML.
3. Bổ sung unit test.
4. Chạy test, kiểm tra diff và đánh giá ảnh hưởng.

## Kế hoạch kiểm chứng

| # | Lệnh / bước kiểm | Kết quả kỳ vọng |
|---|---|---|
| 1 | `dotnet test aspnet-core/test/HDDT.Application.Tests/HDDT.Application.Tests.csproj --no-restore -m:1 -nr:false -p:BuildInParallel=false` | Build thành công, toàn bộ test pass |
| 2 | Xem hóa đơn với số lượng `1,34554` | XML là `1.34554`, HTML không có `NaN` |
| 3 | Ký hóa đơn thêm mới/điều chỉnh/thay thế | XML ký dùng dấu chấm và CQT tiếp nhận |
| 4 | So sánh trường tiền Type 2 trước/sau | Nguồn và giá trị nghiệp vụ không đổi |

## Ma trận rủi ro

| Rủi ro | Ảnh hưởng | Giảm thiểu | Rollback |
|---|---|---|---|
| Hàm dựng chi tiết dùng chung | Nhiều luồng tạo XML nhận chuỗi `<SLuong>` mới | Chỉ đổi biểu diễn của cùng giá trị số; test Type 1/2 | Khôi phục riêng mapping `SLuong` |
| Numeric null trên Type 1 | HTML hiển thị `NaN` | Đưa trường cần hiển thị về `0` | Khôi phục từng trường Type 1 |
| Thay đổi lan sang tiền Type 2 | Có thể ảnh hưởng XML ký | Giữ `DoFormat` ở nhánh không phải Type 1 | Khôi phục điều kiện formatter |

## Ghi chú triển khai

Không cần script database, Redis, cấu hình hoặc thao tác môi trường.

## Đề xuất cập nhật docs (Gate 2)

Không đề xuất sửa tài liệu hệ thống vì không đổi nghiệp vụ hay contract.

## Phê duyệt (Gate 1) — chỉ người điền, AI không tự điền

- [ ] DEV tự review: chờ duyệt
- [ ] TechLead approve: chờ duyệt

> Code đã được sửa trước khi tạo docs theo yêu cầu xử lý lỗi trực tiếp; cần review hậu kiểm trước khi phát hành.

