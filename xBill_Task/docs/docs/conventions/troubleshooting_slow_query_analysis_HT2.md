# Báo Cáo Phân Tích Slow Query Log - HT2 Production (xBill Cloud)

- **File nguồn phân tích:** [`HT2_slow_query1.log`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/HT2_slow_query1.log)
- **Thời gian phân tích:** 16/09/2026
- **Môi trường:** Hệ thống Hóa đơn điện tử xBill Cloud (Production)

---

## 1. Tổng Quan Số Liệu Từ File Log

| Chỉ số | Giá trị | Nhận xét |
| :--- | :--- | :--- |
| **Cửa sổ thời gian ghi log** | **58 giây** (10:13:21 – 10:14:19 ngày 25/07/2025) | Tần suất xuất hiện log cực kỳ dày đặc. |
| **Tổng số lượt query bị ghi nhận** | **500 queries** | Trung bình **~8.6 queries/giây** rơi vào slow log. |
| **Tổng số dòng bị quét (`Rows_examined`)** | **10,095,548 dòng** (~10.1 triệu dòng) | Lãng phí CPU và Disk I/O rất lớn chỉ trong chưa đầy 1 phút. |
| **Thời gian thực thi tối đa / trung bình** | Max: **0.440s** / Avg: **0.020s** | Query chậm nhất ~0.44s, đa phần < 0.1s. |
| **Số query có `Query_time` < 10ms** | **386 / 500 queries** (chiếm 77.2%) | Bị ghi vào slow log do quét bảng hoặc không dùng index tối ưu. |
| **Hệ thống Database bị ảnh hưởng** | **Multi-tenant**:<br>• DB chủ: `invoicesys` (73 query)<br>• Tenant Shards: `dulieu07` (201), `dulieu03` (62), `dulieu06` (43), `dulieu05` (32), `invoicesystenantmyinv` (28), `dulieu04` (27), `dulieu01` (19), `dulieu02` (13) | Xảy ra đồng loạt trên tất cả các shard cơ sở dữ liệu tenant. |

> [!NOTE]
> **Về cấu hình MySQL Server:** 
> Có tới 386/500 query thực thi dưới 10ms (thậm chí 0.15ms) vẫn bị ghi vào log. Điều này cho thấy MySQL đang cấu hình `log_queries_not_using_indexes = ON` và `min_examined_row_limit = 0` (hoặc `long_query_time` rất thấp cỡ `0.001s`). Vì vậy, các query thực hiện Full Table Scan hoặc Range Scan chưa tối ưu đều bị ghi nhận, làm phình to file log và gây thêm tải I/O cho server.

---

## 2. Thống Kê Theo Bảng (Xếp Theo Tổng Số Dòng Bị Quét)

```
Bảng                                | Lượt gọi | Tổng dòng quét | Dòng quét max/lần | Tổng thời gian | Schema bị ảnh hưởng
------------------------------------+----------+----------------+-------------------+----------------+------------------------------------------
vs_dm_doanhnghiep_hdmau_cauhinh     | 22       | 7,367,327      | 515,253           | 5.563s         | dulieu01 -> dulieu07, invoicesystenantmyinv
vs_doanhnghiep_hopdong              | 18       | 1,735,848      | 96,436            | 1.304s         | invoicesys (DB quản trị)
vs_doanhnghiep_registertax          | 11       | 240,975        | 28,152            | 0.250s         | dulieu06, dulieu07, invoicesystenantmyinv
vs_nguoidung_thongtin               | 15       | 221,150        | 31,795            | 0.224s         | dulieu01 -> dulieu07
vs_doanhnghiep_thongtin             | 44       | 160,800        | 16,334            | 0.195s         | dulieu01 -> dulieu07
vs_transaction_log                  | 2        | 120,490        | 60,245            | 0.093s         | dulieu07
vs_dm_ncc_chicucthue                | 9        | 98,910         | 10,990            | 0.068s         | invoicesys
vs_saisot_dshoadon                  | 5        | 96,413         | 44,165            | 0.068s         | dulieu04, dulieu07
vs_dm_doanhnghiep_sanpham           | 131      | 2,851          | 203               | 0.258s         | dulieu03, dulieu04, dulieu05, dulieu06
Các query lấy chi tiết hóa đơn (t2) | 132      | 2,879          | 149               | 1.955s         | dulieu01 -> dulieu07 (Payload 58KB/query)
```

---

## 3. Chi Tiết Các Điểm Nghẽn & Nguyên Nhân Gốc Rễ

### 🔴 Điểm nghẽn 1: Bảng `vs_dm_doanhnghiep_hdmau_cauhinh` (Chiếm 73% tổng I/O)
- **Truy vấn trong log:**
  ```sql
  SELECT `v`.`Id`, `v`.`CreationTime`, ...
  FROM `vs_dm_doanhnghiep_hdmau_cauhinh` AS `v`
  WHERE ((false OR NOT (`v`.`IsDeleted`)) AND (false OR (`v`.`TenantId` = 73))) 
    AND ((((`v`.`DoanhNghiep_MST` = '0106295554') 
    AND `v`.`Mau_MaDacThu` IN ('BEPGJ', 'BEPGJ', 'BEPGJ', 'BEPGJ')) 
    AND ((`v`.`Mau_LoaiBien` = 4) OR (`v`.`Mau_LoaiBien` = 5))) 
    AND (`v`.`Mau_HieuLuc` = 1));
  ```
- **Hiện trạng:**
  - `dulieu07`: Quét **515,253 dòng/query** (toàn bộ bảng).
  - `dulieu05`: Quét **248,451 dòng/query**.
  - `dulieu03`: Quét **227,722 dòng/query**.
  - Tổng cộng quét **7.36 triệu dòng** chỉ trong 22 lần chạy (58 giây) và trả về `Rows_sent = 0`!
- **Nguyên nhân mã nguồn:**
  - File: `invoicecore/.../AppServices/HoaDon/ThongBao_HDMauAppService.cs` (hàm `GetFieldExtensionForHDMau`):
    ```csharp
    var tenDacThus = hD_ThongBao_HDMauDtos.Select(o => o.Loai_HD_DacThu);
    var hdMauCauHinhs = _DM_DoanhNghiep_HDMau_CauHinhRepository.GetAll()
        .Where(m => (m.DoanhNghiep_MST == dnMst || m.DoanhNghiep_MST == cccd)
        && tenDacThus.Contains(m.Mau_MaDacThu) 
        && (m.Mau_LoaiBien == 4 || m.Mau_LoaiBien == 5) && m.Mau_HieuLuc == 1).ToList();
    ```
  - **Thiếu Index:** Bảng `vs_dm_doanhnghiep_hdmau_cauhinh` trên các tenant database không có index trên `(TenantId, DoanhNghiep_MST, IsDeleted)`.
  - **Code chưa tối ưu:** `tenDacThus` không dùng `.Distinct()`, dẫn đến SQL sinh ra danh sách lặp `IN ('BEPGJ', 'BEPGJ', ...)`; và điều kiện `OR m.DoanhNghiep_MST == cccd` làm suy giảm hiệu quả tìm kiếm.

---

### 🔴 Điểm nghẽn 2: Bảng `vs_doanhnghiep_hopdong` (Database trung tâm `invoicesys`)
- **Truy vấn trong log:**
  ```sql
  SELECT `v`.`Id`, ...
  FROM `vs_doanhnghiep_hopdong` AS `v`
  WHERE (false OR NOT (`v`.`IsDeleted`)) AND (`v`.`DoanhNghiep_MST` = '5702117463');
  ```
- **Hiện trạng:**
  - Chạy 18 lần trong 58 giây.
  - Mỗi lần chạy quét đúng **96,436 dòng** (Full Table Scan bảng hợp đồng trên DB chủ).
- **Nguyên nhân mã nguồn:**
  - File: `invoicecore/.../AppServices/DoanhNghiep/DoanhNghiep_HopDongAppService.cs` (`GetHopDong()`):
    ```csharp
    var hopDong = await _doanhNghiep_HopDongRepository.GetAll()
        .Where(x => x.DoanhNghiep_MST == dn.DoanhNghiep_MST || x.DoanhNghiep_MST == dn.DoanhNghiep_CCCD).ToListAsync();
    ```
  - Frontend gọi `getHopDong()` tại hầu hết các trang: Dashboard, Danh sách hóa đơn, Tạo hóa đơn.
  - Bảng `vs_doanhnghiep_hopdong` trong `invoicesys` **hoàn toàn thiếu Index trên `DoanhNghiep_MST`**.

---

### 🔴 Điểm nghẽn 3: Bảng `vs_nguoidung_thongtin` – Lỗi Ép Kiểu Ngầm Định (`CAST`)
- **Truy vấn trong log:**
  ```sql
  SELECT `v`.`Id`, ...
  FROM `vs_nguoidung_thongtin` AS `v`
  WHERE ((false OR NOT (`v`.`IsDeleted`)) AND (false OR (`v`.`TenantId` = 79))) 
    AND (CAST(`v`.`UserId` AS signed) = 75056)
  LIMIT 1;
  ```
- **Hiện trạng:**
  - Mỗi lần tìm thông tin user quét **31,795 dòng**.
- **Nguyên nhân mã nguồn:**
  - Entity `NguoiDung_ThongTin.cs`: Thuộc tính `UserId` là `int`.
  - ABP Framework: `AbpSession.UserId` có kiểu `long?` (`Int64`).
  - Khi LINQ so sánh `o.UserId == AbpSession.UserId`, Pomelo EF Core tự sinh `CAST(v.UserId AS signed) = 75056`.
  - Việc bọc hàm `CAST(...)` quanh tên cột làm MySQL **vô hiệu hóa hoàn toàn Index trên cột `UserId`**, bắt buộc phải Full Scan bảng.

---

### 🟡 Điểm nghẽn 4: Bảng `vs_doanhnghiep_thongtin` với điều kiện `OR`
- **Truy vấn trong log:**
  ```sql
  SELECT COUNT(*)
  FROM `vs_doanhnghiep_thongtin` AS `v`
  WHERE ((false OR NOT (`v`.`IsDeleted`)) AND (false OR (`v`.`TenantId` = 79))) 
    AND (`v`.`DaiLy_Id` IS NULL AND ((`v`.`Id` = 18759) OR (`v`.`DoanhNghiepCha_Id` = 18759)));
  ```
- **Hiện trạng:**
  - Chạy 17 lần trong 58s, mỗi lần quét từ 4,715 đến **16,334 dòng**.
  - Thiếu index đa cột hỗ trợ điều kiện `(TenantId, DoanhNghiepCha_Id, IsDeleted)` và `(TenantId, Id)`.

---

### 🟡 Điểm nghẽn 5: Các bảng nghiệp vụ khác thiếu Index
1. **`vs_doanhnghiep_registertax`**: Quét 28,152 dòng/lần khi tìm kiếm `WHERE DoanhNghiep_MST = ... AND Status = 5 ORDER BY CreationTime DESC LIMIT 1`.
2. **`vs_transaction_log`**: Quét 60,245 dòng/lần khi tra cứu `WHERE TransactionCode = ...`.
3. **`vs_saisot_dshoadon`**: Quét 44,165 dòng/lần khi lọc `WHERE ThongbaoId = ...`.
4. **`vs_dm_ncc_chicucthue`**: Quét 10,990 dòng/lần trong `invoicesys` khi lọc theo `TinhThanh_Ma`.

---

### 🟡 Điểm nghẽn 6: Autocomplete Sản Phẩm `vs_dm_doanhnghiep_sanpham`
- **Truy vấn trong log:**
  ```sql
  WHERE ... AND (((LOCATE(CONVERT('...' USING utf8mb4) COLLATE utf8mb4_bin, LOWER(`v`.`SanPham_Ten`)) > 0) ...) 
             OR ((LOCATE(CONVERT('...' USING utf8mb4) COLLATE utf8mb4_bin, LOWER(`v`.`SanPham_Ma`)) > 0) ...))
  LIMIT 200
  ```
- **Hiện trạng:**
  - Chạy **131 lần / 58 giây** (> 2 lần/giây).
  - Dùng `LOCATE(..., LOWER(cột))` khiến MySQL không thể dùng B-Tree index cho chuỗi.
  - Mặc dù mỗi lần chỉ quét 3–203 dòng do đã lọc theo `DoanhNghiep_MST`, nhưng tần suất gọi quá lớn do người dùng gõ tìm kiếm không có debounce.

---

### 🟡 Điểm nghẽn 7: Payload hóa đơn cực lớn (Truncated Queries)
- Có 99 query bị MySQL cắt cụt ở buffer ~8KB do SELECT hàng trăm cột từ nhiều bảng hóa đơn (`vs_hd_thongtin`, `vs_hd_chitiet`, `vs_hd_mau`...).
- Lượng dữ liệu gửi qua mạng (`Bytes_sent`) lên tới **45KB – 58KB** chỉ cho 1–6 dòng, gây trễ mạng và tiêu tốn CPU tuần tự hóa dữ liệu.

---

## 4. Kế Hoạch Xử Lý Đề Xuất (Action Plan)

### Giai đoạn 1: Đánh Index ngay lập tức (Giảm ngay ~95% I/O)

#### 1. Trên database chủ (`invoicesys`):
```sql
USE invoicesys;

-- 1. Bảng hợp đồng (giảm từ 96,436 dòng xuống 1 dòng)
CREATE INDEX `IX_vs_doanhnghiep_hopdong_MST` 
ON `vs_doanhnghiep_hopdong` (`DoanhNghiep_MST`, `IsDeleted`, `TrangThai`);

-- 2. Danh mục chi cục thuế
CREATE INDEX `IX_vs_dm_ncc_chicucthue_TinhThanh` 
ON `vs_dm_ncc_chicucthue` (`TinhThanh_Ma`, `IsDeleted`, `CCT_BatDau`, `CCT_KetThuc`);
```

#### 2. Trên tất cả các database Tenant (`dulieu01` đến `dulieu08`, `invoicesystenantmyinv`):
```sql
-- 1. Bảng cấu hình mẫu hóa đơn (giảm từ 515,253 dòng xuống < 10 dòng)
CREATE INDEX `IX_hdmau_cauhinh_tenant_mst_madacthu` 
ON `vs_dm_doanhnghiep_hdmau_cauhinh` (`TenantId`, `DoanhNghiep_MST`, `Mau_MaDacThu`, `IsDeleted`, `Mau_HieuLuc`);

-- 2. Bảng thông tin người dùng
CREATE INDEX `IX_nguoidung_thongtin_tenant_userid` 
ON `vs_nguoidung_thongtin` (`TenantId`, `UserId`, `IsDeleted`);

-- 3. Bảng đăng ký thuế (RegisterTax)
CREATE INDEX `IX_registertax_mst_status` 
ON `vs_doanhnghiep_registertax` (`TenantId`, `DoanhNghiep_MST`, `Status`, `IsDeleted`, `CreationTime`);

-- 4. Bảng thông tin doanh nghiệp (hỗ trợ điều kiện cha/con)
CREATE INDEX `IX_doanhnghiep_thongtin_cha` 
ON `vs_doanhnghiep_thongtin` (`TenantId`, `DoanhNghiepCha_Id`, `IsDeleted`);

-- 5. Bảng log giao dịch
CREATE INDEX `IX_transaction_log_code` 
ON `vs_transaction_log` (`TenantId`, `TransactionCode`, `IsDeleted`);

-- 6. Bảng danh sách hóa đơn sai sót
CREATE INDEX `IX_saisot_dshoadon_thongbao` 
ON `vs_saisot_dshoadon` (`TenantId`, `ThongbaoId`, `IsDeleted`);
```

---

### Giai đoạn 2: Tối ưu Code Application (.NET / ABP Framework)

1. **Khắc phục lỗi `CAST(UserId AS signed)`**:
   - Trong `NguoiDung_ThongTin.cs`: Đổi `public int UserId` thành `public long UserId` (đồng bộ với `long` của `AbpUser.Id`).
   - Hoặc ép kiểu tường minh biến so sánh trong câu LINQ:
     ```csharp
     long? currentUserId = AbpSession.UserId;
     // Thay vì: o.UserId == AbpSession.UserId
     // Viết thành: o.UserId == (int)currentUserId.Value
     ```

2. **Tối ưu LINQ trong `ThongBao_HDMauAppService.cs`**:
   - Bổ sung `.Distinct()` cho danh sách mã đặc thù và loại bỏ các giá trị null/rỗng:
     ```csharp
     var tenDacThus = hD_ThongBao_HDMauDtos
         .Where(o => !string.IsNullOrEmpty(o.Loai_HD_DacThu))
         .Select(o => o.Loai_HD_DacThu)
         .Distinct()
         .ToList();
     ```
   - Áp dụng MemoryCache cho cấu hình mẫu hóa đơn (TTL: 15–30 phút) vì cấu hình mẫu hóa đơn rất hiếm khi thay đổi.

3. **Tối ưu gọi `GetHopDong()`**:
   - Cache kết quả `GetHopDong()` ở phía client (sessionStorage/state management) hoặc cache backend theo MST để tránh việc mỗi lần chuyển màn hình lại truy vấn DB chủ.

4. **Tối ưu Frontend Autocomplete sản phẩm**:
   - Bổ sung `debounceTime(300)` đến `debounceTime(400)` trên ô input tìm kiếm hàng hóa/dịch vụ của giao diện Angular.

---

### Giai đoạn 3: Cấu hình MySQL Server (Giảm rác slow log)

Thêm cấu hình vào file cấu hình MySQL (`my.cnf` hoặc thông qua DB Parameter Group):
```ini
# Đặt ngưỡng log query chậm thực tế (ví dụ: 0.5s hoặc 1.0s thay vì log query < 10ms)
long_query_time = 0.5

# Chỉ ghi log nếu query quét từ 1,000 dòng trở lên
min_examined_row_limit = 1000

# Tắt log các query không dùng index nếu bảng nhỏ
log_queries_not_using_indexes = OFF
```
