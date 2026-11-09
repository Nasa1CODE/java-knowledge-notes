# Testcase - CBCLOUDV2-9397

## Truy vết AC -> case

| AC | Case |
|---|---|
| AC1 | TC-01 |
| AC2 | TC-02, TC-03 |
| AC3 | TC-04, TC-05, TC-06 |
| AC4 | TC-07, TC-08, TC-09 |
| AC5 | TC-10, TC-11, TC-12 |
| AC6 | TC-13, TC-14 |

## TC-01 - Xe mới để trống 9 field

- **Trạng thái:** pass - automated 2026-09-07
- **Loại:** luồng chính
- **auto/manual:** auto
- **Các bước:** Gọi shared validator cho `version = 1`, subtype 1, `tinhtrangtaisan = 0`, để trống 9 field.
- **Kết quả mong đợi:** Không có message required của 9 field.

## TC-02 - Xe đã dùng thiếu từng field

- **Trạng thái:** pass - automated 2026-09-07
- **Loại:** lỗi
- **auto/manual:** auto, parameterized cho 9 field
- **Kết quả mong đợi:** Mỗi field thiếu trả đúng message `STT ... không được để trống.`.

## TC-03 - Không phân biệt loại tài sản

- **Trạng thái:** pass - automated 2026-09-07
- **Loại:** biên
- **auto/manual:** auto
- **Các bước:** Lặp TC-02 với `loaitaisan = 1` và `loaitaisan = 2`.
- **Kết quả mong đợi:** Cùng áp dụng required 9 field.

## TC-04 - Xe mới truyền sai kiểu field số

- **Trạng thái:** pass - automated 2026-09-07
- **Loại:** lỗi
- **auto/manual:** auto
- **Dữ liệu:** Sentinel parse lỗi cho `namsanxuat`, `trongtai`, `sochongoi`.
- **Kết quả mong đợi:** Báo `dữ liệu không hợp lệ`, không coi như field optional trống.

## TC-05 - Xe mới truyền số vượt format

- **Trạng thái:** pass - automated 2026-09-07
- **Loại:** biên
- **auto/manual:** auto
- **Dữ liệu:** năm ngoài 0-9999, trọng tải vượt `decimal(9,2)`, số chỗ ngồi ngoài 0-9999.
- **Kết quả mong đợi:** Báo `không đúng định dạng` theo message hiện tại.

## TC-06 - Xe mới truyền chuỗi vượt maxlength

- **Trạng thái:** pass - automated 2026-09-07
- **Loại:** biên
- **auto/manual:** auto
- **Kết quả mong đợi:** Các field có dữ liệu vẫn bị kiểm tra maxlength hiện tại.

## TC-07 - Ba API lưu

- **Trạng thái:** not run
- **Loại:** luồng chính
- **auto/manual:** manual - cần API/tenant DB test - **người nghiệm thu:** TBD
- **API:** `GuiHoaDonGoc`, `GuiHoaDonThayThe`, `GuiHoaDonDieuChinh`.
- **Kết quả mong đợi:** Xe mới bỏ trống 9 field được lưu; xe đã dùng thiếu field bị từ chối.

## TC-08 - Ba wrapper HSM

- **Trạng thái:** not run
- **Loại:** hồi quy
- **auto/manual:** manual - cần HSM test - **người nghiệm thu:** TBD
- **API:** ba API `GuiVaKy...HSM`.
- **Kết quả mong đợi:** Dùng đúng validation từ API lưu; lỗi validation không gọi ký.

## TC-09 - Hai API MTT

- **Trạng thái:** not run
- **Loại:** hồi quy
- **auto/manual:** manual - có side effect cấp số/ký/gửi TCT - **người nghiệm thu:** TBD
- **API:** `GuiHoaDonVaKyMTT`, `GuiHoaDonVaKyMTT_V2`.
- **Kết quả mong đợi:** Dùng đúng validation; lỗi validation không cấp số, ký hoặc gửi TCT.

## TC-10 - Rule nền bắt buộc giữ nguyên

- **Trạng thái:** pass - automated 2026-09-07
- **Loại:** hồi quy
- **auto/manual:** auto
- **Dữ liệu:** Thiếu `sokhung`, `somay`, `loaitaisan`, `tinhtrangtaisan`, `xuatxu`.
- **Kết quả mong đợi:** Vẫn báo required/enum như hiện tại.

## TC-11 - Chứng từ theo xuất xứ

- **Trạng thái:** pass - automated 2026-09-07
- **Loại:** hồi quy
- **auto/manual:** auto
- **Kết quả mong đợi:** `xuatxu = 1` yêu cầu `sogiaychungnhanatkt`; `xuatxu = 0` yêu cầu `soseripktcl`.

## TC-12 - Chất lượng và biển kiểm soát xe đã dùng

- **Trạng thái:** pass - automated 2026-09-07
- **Loại:** hồi quy
- **auto/manual:** auto
- **Kết quả mong đợi:** `tinhtrangtaisan = 1` vẫn yêu cầu `chatluongtaisan` và `sobienkiemsoat`.

## TC-13 - Version không kích hoạt rule mới

- **Trạng thái:** not run - outer version routing không nằm trong unit test private validator
- **Loại:** hồi quy
- **auto/manual:** auto
- **Dữ liệu:** version null/rỗng/khác `1`.
- **Kết quả mong đợi:** Không chạy validator mới; luồng cũ giữ nguyên.

## TC-14 - Subtype khác 1

- **Trạng thái:** pass - automated 2026-09-07
- **Loại:** hồi quy
- **auto/manual:** auto
- **Dữ liệu:** `loaihoadondactrung` null, 2 hoặc 3.
- **Kết quả mong đợi:** Không áp dụng rule 9 field.

## TC-15 - Wrapper XML

- **Trạng thái:** not run
- **Loại:** hồi quy
- **auto/manual:** manual - contract XML cần môi trường API - **người nghiệm thu:** TBD
- **API:** `GuiHoaDonGocXML`, `GuiHoaDonThayTheXML`, `GuiHoaDonDieuChinhXML`.
- **Kết quả mong đợi:** Việc gọi lại API lưu không làm thay đổi luồng XML ngoài rule đã chốt.

## TC-16 - Cách ly tenant

- **Trạng thái:** not run
- **Loại:** phân quyền
- **auto/manual:** manual - cần hai tenant test - **người nghiệm thu:** TBD
- **Kết quả mong đợi:** Request và hóa đơn test của tenant A không đọc/ghi vào tenant B.
