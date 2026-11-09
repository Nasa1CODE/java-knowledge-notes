# Validate dữ liệu import — CBCLOUDV2-9162

Nguồn: `docs/features/CBCLOUDV2-9162/attachment.md` — Quyết định 19/2025/QĐ-TTg.

## File đã sinh

- `data/CBCLOUDV2-9162-tinh-thanh-import.xlsx`
- `data/CBCLOUDV2-9162-xa-phuong-import.xlsx`

## Kết quả kiểm tra

- Số tỉnh/thành parse được: **34** / kỳ vọng **34**.
- Số xã/phường/đặc khu parse được: **3320** / tổng theo heading **3321**.
- Header tỉnh: `STT, Mã, Tên, Tên tắt, Bắt đầu, Kết thúc, Hiệu lực`.
- Header xã/phường: `STT, Mã, Tên, Tên tắt, Bắt đầu, Kết thúc, Hiệu lực, Mã tỉnh thành`.
- Mã tỉnh không đúng format `\d{2}`: **0**.
- Mã xã/phường không đúng format `\d{5}`: **0**.
- Duplicate mã tỉnh: **0**.
- Duplicate mã xã/phường: **0**.
- Xã/phường map tới mã tỉnh không tồn tại: **0**.
- Tỉnh thiếu so với Appendix I chốt: **0**.
- Tỉnh ngoài Appendix I chốt: **0**.
- Tỉnh có số dòng xã/phường lệch so với heading: **1**.

## Đối soát số lượng theo tỉnh

| Mã tỉnh | Tên tỉnh/thành | Theo tài liệu | Parse được | Kết quả |
|---|---|---:|---:|---|
| 01 | Thành phố Hà Nội | 126 | 126 | OK |
| 04 | Tỉnh Cao Bằng | 56 | 56 | OK |
| 08 | Tỉnh Tuyên Quang | 124 | 124 | OK |
| 11 | Tỉnh Điện Biên | 45 | 45 | OK |
| 12 | Tỉnh Lai Châu | 38 | 38 | OK |
| 14 | Tỉnh Sơn La | 75 | 75 | OK |
| 15 | Tỉnh Lào Cai | 99 | 99 | OK |
| 19 | Tỉnh Thái Nguyên | 92 | 92 | OK |
| 20 | Tỉnh Lạng Sơn | 65 | 65 | OK |
| 22 | Tỉnh Quảng Ninh | 54 | 54 | OK |
| 24 | Tỉnh Bắc Ninh | 99 | 99 | OK |
| 25 | Tỉnh Phú Thọ | 148 | 148 | OK |
| 31 | Thành phố Hải Phòng | 114 | 114 | OK |
| 33 | Tỉnh Hưng Yên | 104 | 104 | OK |
| 37 | Tỉnh Ninh Bình | 129 | 129 | OK |
| 38 | Tỉnh Thanh Hóa | 166 | 166 | OK |
| 40 | Tỉnh Nghệ An | 130 | 130 | OK |
| 42 | Tỉnh Hà Tĩnh | 69 | 69 | OK |
| 44 | Tỉnh Quảng Trị | 78 | 78 | OK |
| 46 | Thành phố Huế | 40 | 40 | OK |
| 48 | Thành phố Đà Nẵng | 94 | 93 | LỆCH |
| 51 | Tỉnh Quảng Ngãi | 96 | 96 | OK |
| 52 | Tỉnh Gia Lai | 135 | 135 | OK |
| 56 | Tỉnh Khánh Hòa | 65 | 65 | OK |
| 66 | Tỉnh Đắk Lắk | 102 | 102 | OK |
| 68 | Tỉnh Lâm Đồng | 124 | 124 | OK |
| 75 | Tỉnh Đồng Nai | 95 | 95 | OK |
| 79 | Thành phố Hồ Chí Minh | 168 | 168 | OK |
| 80 | Tỉnh Tây Ninh | 96 | 96 | OK |
| 82 | Tỉnh Đồng Tháp | 102 | 102 | OK |
| 86 | Tỉnh Vĩnh Long | 124 | 124 | OK |
| 91 | Tỉnh An Giang | 102 | 102 | OK |
| 92 | Thành phố Cần Thơ | 103 | 103 | OK |
| 96 | Tỉnh Cà Mau | 64 | 64 | OK |

## Dòng đã chuẩn hóa/sửa OCR

- Dòng 1024: mã `071.47` được chuẩn hóa thành `07147`.
- Dòng 1024: sửa OCR `Phượng Hiệp Hòa` thành `Phường Hiệp Hòa` cho mã `07147`.

## Lưu ý import

1. Import `CBCLOUDV2-9162-tinh-thanh-import.xlsx` trước.
2. Sau khi tỉnh import thành công, import `CBCLOUDV2-9162-xa-phuong-import.xlsx` vì file xã/phường validate `Mã tỉnh thành` phải tồn tại và đang hiệu lực.
3. Sau import, kiểm tra Redis keys `VS_LIST_PROVINCE` và `VS_LIST_WARD_[province_code]` trên đúng Redis DB cấu hình của môi trường.
