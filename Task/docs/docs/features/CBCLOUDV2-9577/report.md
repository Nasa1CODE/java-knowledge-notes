---
feature: CBCLOUDV2-9577
status: implemented
updated_at: 2026-09-14
---

# Report - CBCLOUDV2-9577

## Đã thực hiện

- Rà source `api-cloud-service` hiện tại; đối chiếu `invoicecore` nhưng chốt ngoài scope phase này.
- Thống kê điểm dùng `ACTIVE_ND_254` và trạng thái liên quan.
- Chốt 21 field detector: 6 field cấp hóa đơn và 15 field cấp chi tiết.
- Chốt một detector `UseND254` chung: phải có dòng `loaihoadondactrung = 1` và có một field mới phù hợp; 15 field chi tiết chỉ được dò trên dòng loại `1`.
- Đã thay gate cho validation, map/lưu và XML trong API bằng detector thuần dữ liệu.
- Đã bỏ `ND254FeatureChecker` và toàn bộ đường đọc `ACTIVE_ND_254` khỏi source/test của API.
- Đã đổi context XML nội bộ từ `IsActiveND254` sang `UseND254`; thuộc tính này không nằm trong response contract.
- XML phân trang chốt detector một lần từ hóa đơn đầy đủ trước khi tách trang.
- Lập testcase cho null/rỗng, số `0`, dữ liệu sai kiểu, thiếu subtype `1`, field mới trên subtype khác và dữ liệu lịch sử.

## Số liệu rà soát

| Repository | Kết quả |
|---|---|
| api-cloud-service trước sửa | 1 literal config; 5 lần gọi checker; 42 dòng consumer trên 3 file và 1 checker riêng |
| api-cloud-service sau sửa | 0 reference `ACTIVE_ND_254`, `IsActiveND254` hoặc `ND254FeatureChecker` trong `src` và `test` |
| invoicecore | Đã ghi nhận hiện trạng nhưng không sửa trong phase này |

## Kết quả kiểm thử

| Hạng mục | Kết quả |
|---|---|
| `WS.Application.Tests` | Passed 41, Failed 0, Skipped 0 |
| Build `WS.Core` | Thành công, 0 error |
| Build `WS.Application` | Thành công, 0 error |
| Build `WS.EntityFrameworkCore` | Thành công, 0 error |

Các build/test còn cảnh báo nền về package .NET Core 2.2 đã cũ, advisory `NU1902`/`NU1903` và duplicate `PackageReference` trong `VS.Core`; không phát sinh error từ thay đổi của task.
