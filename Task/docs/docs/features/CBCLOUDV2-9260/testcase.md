# Testcase - CBCLOUDV2-9260

Tất cả testcase giữ `not run` cho tới khi có bằng chứng automated hoặc runtime.

## Truy vết AC

| AC | Testcase |
|---|---|
| AC1 | TC-03, TC-05, TC-07 |
| AC2 | TC-04, TC-06, TC-08 |
| AC3 | TC-01, TC-02, TC-09 |
| AC4 | TC-10, TC-11 |
| AC5 | TC-12, TC-13 |
| AC6 | TC-14 |
| AC7 | TC-15 |

| ID | Luồng | Dữ liệu chính | Kết quả mong đợi | Auto/manual | Status |
|---|---|---|---|---|---|
| TC-01 | Boundary hợp lệ | Parameterized bảy field, độ dài đúng N mới | Không có message maxlength cho field | auto | pass (7 cases) |
| TC-02 | Boundary lỗi | Parameterized bảy field, độ dài N+1 | Có đúng message `không được vượt quá N ký tự` | auto | pass (7 cases) |
| TC-03 | GTGT trực tiếp | Template mới, loại 1, `<= 50` dòng, N/N+1 | Áp dụng đủ bảy giới hạn mới | manual | not run |
| TC-04 | GTGT nền | Cùng dữ liệu, `> 50` dòng | Kết quả đồng nhất direct | manual | not run |
| TC-05 | Bán hàng trực tiếp | Template mới, loại 1, `<= 50` dòng | Áp dụng đủ bảy giới hạn mới | manual | not run |
| TC-06 | Bán hàng nền | Cùng dữ liệu, `> 50` dòng | Kết quả đồng nhất direct | manual | not run |
| TC-07 | Vé xe trực tiếp | Template mới, loại 1, `<= 50` dòng | Áp dụng đủ bảy giới hạn mới | manual | not run |
| TC-08 | Vé xe nền | Cùng dữ liệu, `> 50` dòng | Kết quả đồng nhất direct | manual | not run |
| TC-09 | Unicode boundary | Chuỗi Unicode có số ký tự và byte khác nhau quanh N | Cả hai service đánh giá theo số ký tự, không theo byte UTF-8 | auto + manual | pass worker; direct manual not run |
| TC-10 | Template cũ | Không đủ cột template mới | Không kích hoạt rule đặc trưng mới | auto + manual | not run |
| TC-11 | Sai loại | `loaihanghoa != 4` hoặc `loaidactrung` null/2/3 | Không kích hoạt bảy maxlength mới | auto + manual | pass subtype 2 worker; case còn lại not run |
| TC-12 | Required/xuất xứ | Thiếu field required; `xuatxu=1/0` thiếu chứng từ tương ứng | Message required hiện tại giữ nguyên | auto + manual | not run |
| TC-13 | Danh mục địa bàn | Mã tỉnh/xã không tồn tại hoặc không thuộc nhau | Message catalog hiện tại giữ nguyên | auto + manual | not run |
| TC-14 | DB boundary | Import năm field mở rộng ở N, đọc lại tenant DB/XML | Lưu đủ giá trị, không truncate/lỗi column | manual + SQL | not run |
| TC-15 | Field ngoài scope | Các maxlength khác tại N/N+1 | Hành vi cũ không đổi | regression auto | not run |

## Bộ field parameterized

| Property | N |
|---|---:|
| `ma_tinh` | 2 |
| `ma_xa` | 5 |
| `ten_loaitaisan` | 255 |
| `ten_nhanhieu` | 255 |
| `sogiaychungnhanatkt` | 255 |
| `soseripktcl` | 255 |
| `ten_thuongmai` | 400 |

## An toàn kiểm thử

- Chỉ dùng tenant test và dữ liệu giả.
- Deploy schema test trước khi chạy case giá trị dài.
- Không vận hành queue production.
- Không đánh dấu pass manual chỉ dựa trên build hoặc source review.

## Bằng chứng automated

```powershell
dotnet test AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj --no-restore --filter "FullyQualifiedName~VehicleAssetMaxLengthTests" --verbosity minimal
```

Kết quả: `Passed: 16, Failed: 0, Skipped: 0`.
