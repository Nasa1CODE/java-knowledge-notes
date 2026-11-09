# Deploy - CBCLOUDV2-9418

## Thay đổi cần triển khai

- Deploy code `invoicecore` sau khi sửa import trực tiếp và `GetActiveND254()`.
- Deploy code `svinvoicesendemail` sau khi sửa import nền.
- Phát hành file mẫu Excel runtime mới cho:
  - GTGT: `Hoadon_FileMau_GTGT.xlsx`
  - Bán hàng: `HoadonBH_FileMau (7).xlsx` hoặc tên artifact runtime tương ứng
  - Vé xe: `Hoadon_FileMau_Vexe.xlsx`
- Cấu hình Redis nếu muốn bật tính năng:
  - Hash key: `QLCAUHINH`
  - Field: `ACTIVE_ND_254`
  - Value bật: `1`

## DB

Tenant DB cần có bốn cột nullable: `ten_tinh`, `ten_xa`, `quoc_tich_nguoi_mua`, `ma_quoc_tich_nguoi_mua`. `MaDVQHNS` đã tồn tại trong `vs_hd_tonghop_morong`.

## Rollback

1. Rollback code `invoicecore` và `svinvoicesendemail` về bản trước task.
2. Rollback file mẫu Excel runtime về bản trước task.
3. Nếu cần tắt nhanh tính năng nâng cấp, set Redis `QLCAUHINH.ACTIVE_ND_254` khác `1` hoặc xóa field; DB fallback cũng phải không bật.

## Smoke test sau deploy

| # | Bước | Kỳ vọng |
|---|---|---|
| 1 | Gọi `GetActiveND254()` khi Redis `QLCAUHINH.ACTIVE_ND_254=1` | Trả `true` |
| 2 | Tải file mẫu GTGT/Bán hàng/Vé xe | Có cột `MDVQHNS` đúng vị trí |
| 3 | Import ba file khi ND254 bật | Lưu `MDVQHNS`, quốc tịch, tỉnh/xã và nhóm xe |
| 4 | Import ba file khi ND254 tắt | Vẫn lưu `MDVQHNS`, quốc tịch; không lỗi và không lưu nhóm xe ND254 |

