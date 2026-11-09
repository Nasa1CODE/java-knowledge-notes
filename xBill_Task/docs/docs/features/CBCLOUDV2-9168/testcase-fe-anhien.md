# CBCLOUDV2-9168 - Testcase FE: Ẩn/hiện theo cờ ACTIVE_ND_254

Tài liệu này dành cho tester, chỉ tập trung vào phần **ẩn/hiện giao diện** trên form nhập/sửa hóa đơn khi bật/tắt cờ `ACTIVE_ND_254`. Không bao gồm phần import Excel (xem `testcase.md`).

---

## 1. Chuẩn bị môi trường

### 1.1. Cờ ACTIVE_ND_254

Cờ nằm ở **host DB**, bảng `vs_dm_ncc_cauhinh`. Cờ đọc **toàn hệ thống**, không phân biệt đại lý.

Bật cờ:

```sql
INSERT INTO vs_dm_ncc_cauhinh (cauhinh_ma, cauhinh_giatri, cauhinh_mota, isdeleted)
VALUES ('ACTIVE_ND_254', '1', N'Bat nhap hang hoa dac trung xe (ND 254)', 0);
```

Tắt cờ (chọn 1 trong 3 cách, kết quả phải giống nhau):

```sql
-- Cách 1: đổi giá trị
UPDATE vs_dm_ncc_cauhinh SET cauhinh_giatri = '0' WHERE cauhinh_ma = 'ACTIVE_ND_254';

-- Cách 2: đánh dấu xóa
UPDATE vs_dm_ncc_cauhinh SET isdeleted = 1 WHERE cauhinh_ma = 'ACTIVE_ND_254';

-- Cách 3: xóa hẳn dòng cấu hình
DELETE FROM vs_dm_ncc_cauhinh WHERE cauhinh_ma = 'ACTIVE_ND_254';
```

Kiểm tra giá trị hiện tại:

```sql
SELECT cauhinh_ma, cauhinh_giatri, isdeleted
FROM vs_dm_ncc_cauhinh
WHERE cauhinh_ma = 'ACTIVE_ND_254';
```

### 1.2. Lưu ý bắt buộc khi đổi cờ

- Sau khi đổi cờ trong DB, **phải F5 / load lại trang** form hóa đơn. Cờ được đọc 1 lần khi mở form (`ngOnInit`), không tự cập nhật khi đang mở form.
- Nếu không thấy đổi, kiểm tra tab Network → request `GetActiveND254` trả về `true` hay `false`.
- Endpoint: `/api/services/hddt/DoanhNghiep_ThongTinChung/GetActiveND254`.

### 1.3. Phạm vi form cần test

| Form | Đường dẫn nghiệp vụ | Có đọc cờ? |
|---|---|---|
| Hóa đơn GTGT (HĐ gốc) | Hóa đơn → Lập hóa đơn GTGT | Có |
| Hóa đơn bán hàng | Hóa đơn → Lập hóa đơn bán hàng | Có |
| Vé máy bay / Vé xe | Hóa đơn → Lập hóa đơn vé | **Không** (không có panel xe) |

---

## 2. Bảng đối chiếu hành vi mong đợi

Đây là bảng tra nhanh. Mọi case bên dưới đều phải khớp bảng này.

| Thành phần giao diện | Cờ TẮT | Cờ BẬT + dòng chi tiết là xe (`Loại HHĐT` = Số khung/Số máy) | Cờ BẬT + dòng chi tiết KHÔNG phải xe |
|---|---|---|---|
| Lựa chọn **"Hàng hóa đặc trưng"** trong dropdown `Loại` | **Hiện** | Hiện | Hiện |
| Cột **"Loại HHĐT"** | **Hiện** (khi có dòng hàng hóa đặc trưng) | Hiện | Hiện |
| Cột **"Số khung"**, **"Số máy"** | **Hiện** | **Ẩn** | Hiện |
| Panel **"Thông tin hàng hóa đặc trưng (xe ô tô, mô tô)"** | **Ẩn** | **Hiện** | Ẩn |
| Ô **Tỉnh/Thành phố**, **Xã/Phường** (khối người mua) | **Ẩn** | **Hiện** | Ẩn |
| Validate bắt buộc 16 trường xe | **Không chạy** | **Chạy** | Không chạy |
| Cột **Biển kiểm soát**, **Tên/Địa chỉ/MST người gửi** | Hiện theo luồng cũ | Hiện theo luồng cũ | Hiện theo luồng cũ |

**Nguyên tắc chính cần nhớ:** cờ `ACTIVE_ND_254` **chỉ** điều khiển panel xe + Tỉnh/Xã + validate xe. Các thứ cũ (chọn "Hàng hóa đặc trưng", cột "Loại HHĐT", cột "Số khung"/"Số máy", các cột người gửi) **không được biến mất** khi tắt cờ.

---

## 3. Nhóm A — Cờ TẮT (luồng cũ phải nguyên vẹn)

Chuẩn bị: tắt cờ theo mục 1.1, F5 lại trang.

### A01 — Vẫn chọn được "Hàng hóa đặc trưng"

| Bước | Thao tác |
|---|---|
| 1 | Mở form **Hóa đơn GTGT**, thêm 1 dòng chi tiết |
| 2 | Mở dropdown cột **Loại** |

**Mong đợi:** danh sách vẫn có đủ: Hàng hóa, Dịch vụ, Chiết khấu, Ghi chú/diễn giải, **Hàng hóa đặc trưng**.
**Fail nếu:** mất lựa chọn "Hàng hóa đặc trưng".

Lặp lại với form **Hóa đơn bán hàng** và **Vé máy bay**.

### A02 — Cột "Loại HHĐT" vẫn hiện

| Bước | Thao tác |
|---|---|
| 1 | Ở dòng chi tiết, chọn `Loại` = **Hàng hóa đặc trưng** |

**Mong đợi:** xuất hiện cột **"Loại HHĐT"** với dropdown chọn loại (Số khung/Số máy, Biển kiểm soát, Thông tin người gửi...).
**Fail nếu:** cột "Loại HHĐT" không hiện.

### A03 — Cột "Số khung"/"Số máy" vẫn hiện (điểm hay lỗi nhất)

| Bước | Thao tác |
|---|---|
| 1 | Ở cột **Loại HHĐT**, chọn loại tương ứng **Số khung/Số máy** |

**Mong đợi:**
- Bảng chi tiết xuất hiện **2 cột riêng: "Số khung" và "Số máy"**.
- Nhập được giá trị vào 2 ô này.
- **Không** xuất hiện panel "Thông tin hàng hóa đặc trưng (xe ô tô, mô tô)".

**Fail nếu:** không thấy 2 cột Số khung/Số máy → đây là lỗi mất luồng cũ.

Lặp lại với **cả 3 form**: HĐ GTGT, HĐ bán hàng, Vé máy bay.

### A04 — Không hiện panel xe

**Mong đợi:** không có dòng mở rộng bên dưới dòng chi tiết chứa các trường: Loại tài sản, Tình trạng tài sản, Xuất xứ, Năm sản xuất, Trọng tải, Số chỗ ngồi, Chất lượng tài sản...

### A05 — Không hiện Tỉnh/Xã ở khối người mua

**Mong đợi:** khối thông tin người mua **không** có 2 ô **Tỉnh/Thành phố** và **Xã/Phường**.

### A06 — Lưu và ký hóa đơn bình thường

| Bước | Thao tác |
|---|---|
| 1 | Nhập đủ thông tin hóa đơn, có 1 dòng Hàng hóa đặc trưng với Số khung/Số máy |
| 2 | Bấm **Lưu**, sau đó **Ký** |

**Mong đợi:**
- Lưu thành công, **không** có thông báo bắt buộc nhập các trường xe (Loại tài sản, Trọng tải, Số chỗ ngồi...).
- **Không** bắt buộc nhập Tỉnh/Xã.
- Mở lại hóa đơn: 2 ô Số khung/Số máy hiển thị đúng giá trị đã nhập.

### A07 — Các cột người gửi vẫn hoạt động

| Bước | Thao tác |
|---|---|
| 1 | Ở cột **Loại HHĐT**, chọn **Biển kiểm soát** ở 1 dòng và **Thông tin người gửi** ở dòng khác |

**Mong đợi:** vẫn hiện các cột: Biển kiểm soát, Tên người gửi, Địa chỉ người gửi, MST người gửi, Số định danh người gửi.

---

## 4. Nhóm B — Cờ BẬT (tính năng mới)

Chuẩn bị: bật cờ theo mục 1.1, F5 lại trang.

### B01 — Hiện panel xe khi chọn đúng loại

| Bước | Thao tác |
|---|---|
| 1 | Mở form **Hóa đơn GTGT**, thêm dòng chi tiết |
| 2 | Chọn `Loại` = **Hàng hóa đặc trưng** |
| 3 | Chọn `Loại HHĐT` = loại tương ứng **Số khung/Số máy** |

**Mong đợi:**
- Xuất hiện dòng mở rộng với panel **"Thông tin hàng hóa đặc trưng (xe ô tô, mô tô) - dòng N"**.
- Panel chứa đầy đủ các trường: Số khung, Số máy, Loại tài sản, Tình trạng tài sản, Xuất xứ, Số giấy chứng nhận ATKT, Số seri phiếu KTCL, Nước sản xuất, Tên loại tài sản, Năm sản xuất, Tên thương mại, Tên nhãn hiệu, Kiểu loại xe, Thể tích/công suất, Trọng tải, Số chỗ ngồi, Chất lượng tài sản.
- **2 cột riêng "Số khung"/"Số máy" ở bảng chi tiết bị ẨN** (vì đã có trong panel).

### B02 — Panel thu gọn/mở rộng

| Bước | Thao tác |
|---|---|
| 1 | Bấm nút toggle trên tiêu đề panel |

**Mong đợi:** panel thu gọn / mở lại bình thường, dữ liệu đã nhập không mất.

### B03 — Bảng không bị vỡ layout (kiểm tra colspan)

| Bước | Thao tác |
|---|---|
| 1 | Với panel xe đang hiện, quan sát bảng chi tiết |

**Mong đợi:**
- Dòng panel xe trải **đúng hết chiều rộng** bảng, không thừa/thiếu ô trống ở cuối dòng.
- Đường kẻ bảng thẳng hàng, không bị lệch cột.

Test thêm ở các cấu hình bảng khác nhau để đảm bảo colspan đúng:
- Có bật cấu hình **chiết khấu chi tiết**.
- Mẫu hóa đơn loại **THUOC / DUOCHD** (có thêm cột Nước SX, Số lô, Hạn dùng).
- Mẫu hóa đơn loại **BẢO HIỂM**.
- Có bật 1–5 trường mở rộng chi tiết.

### B04 — Hiện Tỉnh/Xã ở khối người mua

**Mong đợi:** khi hóa đơn có ít nhất 1 dòng xe, khối người mua hiện thêm **Tỉnh/Thành phố** và **Xã/Phường**; chọn Tỉnh thì danh sách Xã lọc theo Tỉnh đó.

### B05 — Validate bắt buộc các trường xe

| Bước | Thao tác |
|---|---|
| 1 | Có dòng xe, để trống một số trường bắt buộc (Số khung, Số máy, Loại tài sản...) |
| 2 | Bấm **Lưu** hoặc **Ký** |

**Mong đợi:** hiện thông báo lỗi tiếng Việt có dấu, chỉ rõ dòng và tên trường thiếu.

### B06 — Validate định dạng số

| Trường | Giá trị nhập | Mong đợi |
|---|---|---|
| Trọng tải | vượt `decimal 9,2` (ví dụ 12345678.99) | Báo lỗi định dạng |
| Số chỗ ngồi | quá 4 chữ số (ví dụ 12345) | Báo lỗi định dạng |
| Chất lượng tài sản | vượt `decimal 4,2` (ví dụ 12345.67) | Báo lỗi định dạng |

### B07 — Lưu và mở lại

| Bước | Thao tác |
|---|---|
| 1 | Nhập đủ thông tin xe, Lưu |
| 2 | Mở lại hóa đơn vừa lưu |

**Mong đợi:** panel xe hiện lại đầy đủ, dữ liệu đúng như đã nhập, các ô ở chế độ chỉ đọc (nếu hóa đơn đã ký).

### B08 — Chọn loại HHĐT khác thì ẩn panel

| Bước | Thao tác |
|---|---|
| 1 | Đang ở dòng xe có panel hiện |
| 2 | Đổi `Loại HHĐT` sang **Biển kiểm soát** |

**Mong đợi:** panel xe ẩn đi, cột Biển kiểm soát hiện ra theo luồng cũ.

---

## 5. Nhóm C — Chuyển đổi trạng thái cờ

### C01 — Bật → Tắt

| Bước | Thao tác |
|---|---|
| 1 | Bật cờ, tạo và ký 1 hóa đơn có dòng xe đầy đủ 16 trường |
| 2 | Tắt cờ, F5 |
| 3 | Mở lại hóa đơn đã tạo ở bước 1 |

**Mong đợi:**
- Không còn panel xe.
- Hiện 2 cột Số khung/Số máy với giá trị đã lưu.
- Form không báo lỗi JS (kiểm tra Console trình duyệt).

**Cần ghi nhận (rủi ro đã biết, không phải bug của FE):** file **XML/PDF** của hóa đơn tạo ở bước 1 có thể **mất các trường xe** khi tắt cờ, do phần sinh XML/PDF không gate theo cờ. Tester cần tải XML + xem PDF của hóa đơn đó và báo lại kết quả thực tế.

### C02 — Tắt → Bật

| Bước | Thao tác |
|---|---|
| 1 | Tắt cờ, tạo hóa đơn có Số khung/Số máy theo luồng cũ, Lưu |
| 2 | Bật cờ, F5, mở lại hóa đơn |

**Mong đợi:** panel xe hiện ra, 2 trường Số khung/Số máy có sẵn giá trị cũ, các trường xe còn lại để trống.

### C03 — Đổi cờ khi đang mở form

| Bước | Thao tác |
|---|---|
| 1 | Mở form nhập hóa đơn |
| 2 | Đổi cờ trong DB, **không** F5 |

**Mong đợi:** giao diện **giữ nguyên** trạng thái cũ (đúng thiết kế — cờ chỉ đọc lúc mở form). Sau khi F5 mới đổi.

### C04 — Cờ đọc toàn hệ thống, không theo đại lý

| Bước | Thao tác |
|---|---|
| 1 | Bật cờ |
| 2 | Đăng nhập bằng tài khoản thuộc **các đại lý khác nhau** |

**Mong đợi:** tất cả đại lý đều thấy trạng thái giống nhau (cùng bật). Tắt cờ thì tất cả cùng tắt.

---

## 6. Nhóm D — Hóa đơn điều chỉnh / thay thế (khu vực rủi ro cao)

Form hóa đơn điều chỉnh/thay thế hiển thị **2 bảng**: phần trên là **chi tiết hóa đơn gốc** (chỉ đọc), phần dưới là **chi tiết hóa đơn mới** (nhập liệu). Cả 2 dùng chung 1 dòng tiêu đề cột.

### D01 — HĐ gốc có xe, HĐ mới cũng có xe, cờ BẬT

**Mong đợi:**
- Bảng HĐ gốc: hiện panel xe chỉ đọc, các ô bị khóa (`disabled`).
- Bảng HĐ mới: hiện panel xe nhập được.
- Cả 2 bảng **không** hiện 2 cột Số khung/Số máy.
- Layout không lệch cột.

### D02 — HĐ gốc có xe, HĐ mới KHÔNG có dòng xe, cờ BẬT ⚠️

Đây là case **nghi ngờ có lỗi**, cần test kỹ và chụp màn hình.

| Bước | Thao tác |
|---|---|
| 1 | Bật cờ |
| 2 | Tạo HĐ gốc có dòng xe (`Loại HHĐT` = Số khung/Số máy), ký |
| 3 | Lập hóa đơn **điều chỉnh** (hoặc **thay thế**) cho hóa đơn đó |
| 4 | Ở bảng HĐ mới, **xóa hết** dòng xe hoặc đổi loại sang Hàng hóa thường |

**Mong đợi đúng:** hoặc là hiện panel xe (không hiện 2 cột), hoặc là hiện 2 cột (không hiện panel) — **không được hiện cả hai cùng lúc**, và bảng không lệch cột.

**Kết quả nghi ngờ sẽ gặp:**
- Dòng tiêu đề **hiện** 2 cột "Số khung"/"Số máy".
- Bảng HĐ gốc **vẫn hiện** panel xe.
- Dòng panel xe **thiếu 2 ô** so với số cột tiêu đề → **bảng bị lệch/vỡ layout ở cuối dòng**.

Nếu gặp đúng hiện tượng trên, ghi nhận là **bug**, đính kèm ảnh chụp toàn bảng.

### D03 — HĐ gốc có xe, cờ TẮT

**Mong đợi:**
- Cả 2 bảng đều hiện 2 cột Số khung/Số máy.
- Bảng HĐ gốc: 2 ô có giá trị và bị khóa.
- Không bảng nào hiện panel xe.

### D04 — Điều chỉnh nhiều hóa đơn (DCTT nhiều HĐ)

| Bước | Thao tác |
|---|---|
| 1 | Vào luồng điều chỉnh trực tiếp nhiều hóa đơn |

**Mong đợi:** tất cả ô nhập Số khung/Số máy (và các trường xe nếu cờ bật) đều ở trạng thái **khóa** (`disabled`), không sửa được.

---

## 7. Nhóm E — Không ảnh hưởng form khác

### E01 — Vé máy bay / Vé xe

| Bước | Thao tác |
|---|---|
| 1 | Test lần lượt với cờ BẬT và cờ TẮT |

**Mong đợi:** hành vi **giống hệt nhau** ở cả 2 trạng thái cờ — vẫn chọn được "Hàng hóa đặc trưng", vẫn hiện cột "Loại HHĐT", vẫn hiện 2 cột Số khung/Số máy. Form này **không** có panel xe và **không** đọc cờ.

### E02 — Hóa đơn không có hàng hóa đặc trưng

| Bước | Thao tác |
|---|---|
| 1 | Lập hóa đơn chỉ có dòng Hàng hóa / Dịch vụ thông thường |

**Mong đợi:** ở cả 2 trạng thái cờ, bảng chi tiết giống hệt bản cũ — không hiện cột Loại HHĐT, Số khung, Số máy, không có panel xe.

---

## 8. Danh sách kiểm tra nhanh (checklist bàn giao)

Cờ TẮT:

- [ ] Vẫn chọn được "Hàng hóa đặc trưng" (3 form)
- [ ] Vẫn hiện cột "Loại HHĐT" (3 form)
- [ ] Vẫn hiện 2 cột "Số khung"/"Số máy" (3 form)
- [ ] Không hiện panel xe
- [ ] Không hiện Tỉnh/Xã người mua
- [ ] Lưu/ký không bị chặn bởi validate xe

Cờ BẬT:

- [ ] Hiện panel xe khi chọn đúng loại
- [ ] Ẩn 2 cột Số khung/Số máy khi panel hiện
- [ ] Hiện Tỉnh/Xã người mua
- [ ] Validate 16 trường xe chạy đúng
- [ ] Validate định dạng số (trọng tải, số chỗ ngồi, chất lượng tài sản)
- [ ] Bảng không lệch cột (test cả cấu hình chiết khấu chi tiết / THUOC / BẢO HIỂM)

Chuyển trạng thái:

- [ ] Bật → Tắt: mở lại HĐ cũ không lỗi
- [ ] Tắt → Bật: mở lại HĐ cũ không lỗi
- [ ] Ghi nhận kết quả XML/PDF của HĐ xe sau khi tắt cờ
- [ ] Cờ áp dụng đồng nhất cho mọi đại lý

Điều chỉnh/thay thế:

- [ ] D01 hiển thị đúng
- [ ] **D02 — case nghi ngờ lỗi, bắt buộc test và chụp màn hình**
- [ ] D03 hiển thị đúng
- [ ] D04 các ô bị khóa đúng

---

## 9. Mẫu báo lỗi

Khi phát hiện sai lệch, ghi nhận theo mẫu:

```text
Mã case:            (ví dụ D02)
Form:               HĐ GTGT / HĐ bán hàng / Vé máy bay
Trạng thái cờ:      BẬT / TẮT
Loại hóa đơn:       Mới / Điều chỉnh / Thay thế / DCTT nhiều HĐ
Các bước tái hiện:  1. ... 2. ... 3. ...
Kết quả thực tế:    ...
Kết quả mong đợi:   ...
Ảnh chụp:           (đính kèm toàn bảng chi tiết)
Console trình duyệt: (có lỗi JS không)
Network GetActiveND254 trả về: true / false
```
