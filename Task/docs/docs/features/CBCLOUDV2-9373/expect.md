---
feature: CBCLOUDV2-9373
title: "[API] Bổ sung Mã quốc tịch, Quốc tịch"
services-affected: [api-cloud-service]
created_at: 2026-09-10
updated_at: 2026-09-10
---

# Expect — CBCLOUDV2-9373

## Scope
- Chỉ API trong `D:\XBill\Cloud\api-cloud-service`.
- Không sửa FE, không sửa import Excel.
- Rule quốc tịch áp dụng khi cấu hình global `ACTIVE_ND_254 = "1"`, không phụ thuộc Hàng hóa đặc trưng 1 và không phụ thuộc request `version`.

## Acceptance Criteria
- AC-1: API hóa đơn gốc/thay thế/điều chỉnh nhận optional `quoc_tich_nguoi_mua` và `ma_quoc_tich_nguoi_mua`; chỉ xử lý theo rule mới khi `ACTIVE_ND_254 = "1"`.
- AC-2: Dữ liệu được lưu vào `vs_hd_tonghop_morong.quoc_tich_nguoi_mua`, `vs_hd_tonghop_morong.ma_quoc_tich_nguoi_mua` khi ND254 bật, không yêu cầu `loaihoadondactrung = 1`.
- AC-3: Validate maxlength API khi ND254 bật: `QTNMua` tối đa 50 ký tự, `MQTNMua` tối đa 2 ký tự.
- AC-4: XML buyer node map `quoc_tich_nguoi_mua -> <QTNMua>`, `ma_quoc_tich_nguoi_mua -> <MQTNMua>` khi ND254 bật.
- AC-5: Có API danh mục `DM_NCC_QuocTich/GetAllNoPage` để lấy dropdown quốc tịch cho FE ticket khác.
- AC-6: Payload cũ không có quốc tịch vẫn hoạt động bình thường.
- AC-7: Khi ND254 bật, hóa đơn không có Hàng hóa đặc trưng 1 vẫn áp dụng quốc tịch; request `version` không còn ảnh hưởng gate.
- AC-8: Khi ND254 bật và có `ma_quoc_tich_nguoi_mua`, API phải check mã tồn tại trong danh mục quốc tịch; nếu không tồn tại trả `Mã quốc tịch không tồn tại.`

- AC-9: Khi ND254 bật và dòng chi tiết có `loaihoadondactrung = 1`, API phải check `dschitiet[].ma_nuocsx` tồn tại trong danh mục quốc tịch/quốc gia; nếu không tồn tại trả `Mã nước sản xuất không tồn tại.`


