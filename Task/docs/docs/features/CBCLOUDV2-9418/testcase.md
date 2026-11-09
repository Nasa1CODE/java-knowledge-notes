# Testcase - CBCLOUDV2-9418

## Phạm vi

Test import Excel GTGT, Bán hàng và Vé xe cho layout v8: `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` độc lập ND254; nhóm Hàng hóa đặc trưng 1/xe theo flag `ACTIVE_ND_254`.

## Test cases

| ID | Nhóm | Điều kiện | Dữ liệu | Kết quả kỳ vọng | Status |
|---|---|---|---|---|---|
| TC-01 | Layout | GTGT file mẫu mới | `MDVQHNS=L/12`, `Mã quốc tịch=M/13`, `Quốc tịch=N/14`, `Số biển kiểm soát=BJ/62`, `DL đặc thù=BP:BY/68-77` | Import đọc đúng các field, không lệch cột | not-run |
| TC-02 | Layout | Bán hàng file mẫu mới | `MDVQHNS=L/12`, `Mã quốc tịch=M/13`, `Quốc tịch=N/14`, `Số biển kiểm soát=BK/63` | Import đọc đúng các field, không lệch cột | not-run |
| TC-03 | Layout | Vé xe file mẫu mới | `MDVQHNS=I/9`, `Mã quốc tịch=J/10`, `Quốc tịch=K/11`, `Số biển kiểm soát=BJ/62` | Import đọc đúng các field, không lệch cột | not-run |
| TC-04 | Positive | ND254 tắt hoặc bật | `MDVQHNS = 1234567` | Import thành công, lưu `HD_HoaDon_MoRong.MaDVQHNS = 1234567` | not-run |
| TC-05 | Positive | ND254 tắt hoặc bật | `MDVQHNS` trống | Import thành công, không báo required | not-run |
| TC-06 | Negative | ND254 tắt hoặc bật | `MDVQHNS = 12345678` | Báo lỗi `MDVQHNS không được vượt quá 7 ký tự.` | not-run |
| TC-07 | Gate | ND254 tắt ở Redis và DB | User nhập field nhóm xe và 3 cột bổ sung | Import không báo lỗi nhóm xe, không lưu nhóm xe; vẫn lưu `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` | not-run |
| TC-08 | Redis | Redis Hash `QLCAUHINH` có `ACTIVE_ND_254=1` | DB không cần đọc | `GetActiveND254()` trả `true` | not-run |
| TC-09 | Redis fallback | Redis thiếu field hoặc lỗi kết nối, DB có `ACTIVE_ND_254=1` | DB bật | `GetActiveND254()` trả `true` | not-run |
| TC-10 | Redis fallback | Redis thiếu/lỗi, DB thiếu hoặc value khác `1` | Không bật | `GetActiveND254()` trả `false` | not-run |
| TC-11 | Regression | Dòng không phải Hàng hóa đặc trưng 1 | `loaihanghoa != 4` hoặc `loaidactrung != 1` | Không kích hoạt validation/lưu nhóm nâng cấp | not-run |
| TC-12 | Regression | Xe đã qua sử dụng khi ND254 bật | Thiếu `Số biển kiểm soát` | Vẫn báo lỗi bắt buộc biển số như rule hiện tại | not-run |

## Automated checks đề xuất

- Source/unit test xác nhận mapping cột của ba file.
- Test helper cho `MDVQHNS` trống/7/8 ký tự.
- Test helper cho ND254 bật/tắt quyết định validate/map.
- API unit test hoặc source assertion cho `GetActiveND254()` có nhánh Redis và DB fallback.

## Manual checks bắt buộc

- Import ba file mẫu thật trên môi trường có Redis `QLCAUHINH.ACTIVE_ND_254=1`.
- Import lại khi Redis/DB không bật ND254.
- Mở web kiểm tra dữ liệu đã lưu/không lưu theo flag.


| TC-14 | Regression | GTGT file mẫu v8 | Nhập giá trị ở DL đặc thù hóa đơn_01 và DL đặc thù hàng hóa_01 cuối file | Lưu vào BS_ThongTin_DNMua_01 và BS_ChiTiet_01, không lấy nhầm dữ liệu xe | not-run |

