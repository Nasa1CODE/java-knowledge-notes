# Báo Cáo Phân Tích & Phương Án Xử Lý Lỗi Lệch Tham Số Stored Procedure (BaoCaoHoaDonXoaBo)

## 1. Thông Tin Lỗi & Bối Cảnh (Log Analysis)

* **Thời điểm xảy ra:**
  * `2026-09-10 14:21:13,537`: Nhận request gọi API báo cáo `GetData BaoCaoHoaDonXoaBo - dnMST: 3702756353`
  * `2026-09-10 14:21:13,541`: Văng lỗi chỉ sau 4 mili-giây do MySQL từ chối thực thi procedure.
* **TraceId:** `16db4a00325145e382077b4ac0fda601`
* **Host / Server:** `inv1_cyberbill4_207`
* **Source Log:** `/opt/cyberbillapp/App_Data/Logs/Logs.txt`
* **Ngoại lệ:**
  ```text
  MySql.Data.MySqlClient.MySqlException (0x80004005): Incorrect number of arguments for PROCEDURE dulieu04.BaoCaoHoaDonXoaBo; expected 7, got 8
  ```

> **Ý nghĩa lỗi:** Code backend truyền vào **8 đối số (arguments)**, trong khi Stored Procedure `BaoCaoHoaDonXoaBo` trong database **`dulieu04`** chỉ khai báo nhận **7 tham số (parameters)**.

---

## 2. Vị Trí Gây Lỗi Trong Source Code

* **Service:** [`BaoCaoHoaDonXoaBoAppService`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/BaoCao/BaoCaoHoaDonXoaBoAppService.cs#L39) $\rightarrow$ gọi hàm `GetData()`
* **Repository:** [`BaoCaoRepository`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/Repositories/DoanhNghiep/BaoCaoRepository.cs#L34-L39) $\rightarrow$ gọi hàm `GetBaoCaoHoaDonXoaBo()`
* **Đoạn code thực thi tại dòng 34:**
  ```csharp
  // BaoCaoRepository.cs (dòng 34)
  var query = "CALL BaoCaoHoaDonXoaBo('" + dnMST + "','" + dnMSTOld + "', " + issendtbssstring + ",  " + ngaylaptustring + ", " + ngaylapdenstring + " ," + ngayhuytustring + "," + ngayhuydenstring + "," + nguoihuy_idstring + ")";
  command.CommandText = query;
  command.CommandType = System.Data.CommandType.Text;
  using (var result = await command.ExecuteReaderAsync()) // <--- DÒNG 39: Bị văng lỗi Incorrect number of arguments tại đây
  ```

---

## 3. Thông Tin Database & Stored Procedure

* **Database Name:** **`dulieu04`** (Database Tenant lưu dữ liệu của doanh nghiệp có MST `3702756353`)
* **Tên Stored Procedure:** **`BaoCaoHoaDonXoaBo`**
* **Các bảng dữ liệu nghiệp vụ liên quan bên trong Procedure:**
  * `vs_hd_tonghop` (Bảng hóa đơn)
  * `vs_hd_thongbaohuy` / `vs_hd_thongbaohuy_hdmau` (Thông báo hủy/xóa bỏ hóa đơn)
  * `abpusers` (Thông tin người dùng hủy hóa đơn)

### So sánh danh sách tham số giữa Code C# và Database:

| STT | Tham số Code C# gửi xuống (8 tham số) | Tham số DB hiện tại kỳ vọng (7 tham số) | Trạng thái |
| :---: | :--- | :--- | :--- |
| 1 | `p_dnMST` (`3702756353`) | `p_dnMST` | Khớp |
| **2** | **`p_dnMSTOld`** (Mới thêm) | *(Chưa có trong DB)* | **LỆCH (Thừa tham số này)** |
| 3 | `p_issendtbss` | `p_issendtbss` | Bị dịch chuyển vị trí |
| 4 | `p_ngaylaptu` | `p_ngaylaptu` | Bị dịch chuyển vị trí |
| 5 | `p_ngaylapden` | `p_ngaylapden` | Bị dịch chuyển vị trí |
| 6 | `p_ngayhuytu` | `p_ngayhuytu` | Bị dịch chuyển vị trí |
| 7 | `p_ngayhuyden` | `p_ngayhuyden` | Bị dịch chuyển vị trí |
| 8 | `p_nguoihuy_id` | `p_nguoihuy_id` | Bị dịch chuyển vị trí |

---

## 4. Nguyên Nhân Gốc Rễ (Root Cause)

Qua kiểm tra lịch sử Git commit của file [`BaoCaoRepository.cs`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/Repositories/DoanhNghiep/BaoCaoRepository.cs):
* **Commit cũ:** Procedure chỉ nhận **7 tham số**:
  ```csharp
  var query = "CALL BaoCaoHoaDonXoaBo('" + dnMST + "', " + issendtbssstring + ", " + ngaylaptustring + ", " + ngaylapdenstring + " ," + ngayhuytustring + "," + ngayhuydenstring + "," + nguoihuy_idstring + ")";
  ```
* **Commit mới (`c572db5a` - Ticket `CBCLOUDV2-5654`):** Dev bổ sung tính năng hỗ trợ doanh nghiệp có MST cũ / CCCD (`dnMSTOld`), nên thêm `dnMSTOld` vào vị trí thứ 2 trong câu lệnh `CALL BaoCaoHoaDonXoaBo(...)` $\rightarrow$ thành **8 tham số**.
* **Nguyên nhân chính:** Code C# đã được build và deploy lên server `inv1_cyberbill4_207`, nhưng **Database `dulieu04` (và có thể các DB tenant `dulieuXX` khác) chưa được chạy script ALTER PROCEDURE để thêm tham số `dnMSTOld`**.
* Do đó, khi người dùng vào chức năng "Báo cáo hóa đơn xóa bỏ", MySQL kiểm tra signature của procedure và chặn ngay lập tức: `expected 7, got 8`.

---

## 5. Các Câu Lệnh SQL Kiểm Tra Procedure Hiện Tại

Dưới đây là các câu lệnh SQL giúp DBA / DevOps kiểm tra chính xác định nghĩa và số lượng tham số của Procedure trên server MySQL:

### Lệnh 1: Xem toàn bộ mã nguồn tạo Procedure hiện tại
```sql
SHOW CREATE PROCEDURE `dulieu04`.`BaoCaoHoaDonXoaBo`;
```
*(Nếu dùng MySQL CLI / Terminal, thêm `\G` ở cuối: `SHOW CREATE PROCEDURE dulieu04.BaoCaoHoaDonXoaBo\G` để hiển thị dạng dọc dễ đọc).*

---

### Lệnh 2: Xem chi tiết danh sách từng tham số (Tên, Kiểu dữ liệu, Thứ tự)
Truy vấn trực tiếp từ bảng metadata hệ thống `information_schema.PARAMETERS`:
```sql
SELECT 
    ORDINAL_POSITION AS `STT`,
    PARAMETER_MODE AS `Che_Do`,
    PARAMETER_NAME AS `Ten_Tham_So`,
    DTD_IDENTIFIER AS `Kieu_Du_Lieu`
FROM information_schema.PARAMETERS 
WHERE SPECIFIC_SCHEMA = 'dulieu04' 
  AND SPECIFIC_NAME = 'BaoCaoHoaDonXoaBo'
ORDER BY ORDINAL_POSITION;
```
> **Kết quả kỳ vọng:**
> * Nếu trả về **7 dòng** $\rightarrow$ Database này **chưa cập nhật** (nguyên nhân gây lỗi).
> * Nếu trả về **8 dòng** $\rightarrow$ Database đã được cập nhật đủ tham số.

---

### Lệnh 3: Quét hàng loạt tất cả Database Tenant (`dulieu%`) để phát hiện các DB bị lỗi
Vì hệ thống chạy mô hình Multi-tenant với nhiều database (`dulieu01`, `dulieu02`, `dulieu03`, `dulieu04`,...), câu lệnh sau sẽ thống kê trạng thái tham số trên toàn bộ các database:
```sql
SELECT 
    SPECIFIC_SCHEMA AS `Database_Tenant`,
    COUNT(*) AS `So_Luong_Tham_So`,
    CASE 
        WHEN COUNT(*) = 8 THEN 'ĐÃ CẬP NHẬT (OK)' 
        WHEN COUNT(*) = 7 THEN 'CHƯA CẬP NHẬT (LỖI)' 
        ELSE 'BẤT THƯỜNG' 
    END AS `Trang_Thai`
FROM information_schema.PARAMETERS
WHERE SPECIFIC_SCHEMA LIKE 'dulieu%' 
  AND SPECIFIC_NAME = 'BaoCaoHoaDonXoaBo'
GROUP BY SPECIFIC_SCHEMA
ORDER BY SPECIFIC_SCHEMA;
```

---

### Lệnh 4: Xem thời gian tạo và sửa đổi lần cuối (Modified Time) của Procedure
```sql
SELECT 
    ROUTINE_SCHEMA AS `Database`,
    ROUTINE_NAME AS `Ten_Procedure`,
    CREATED AS `Ngay_Tao`,
    LAST_ALTERED AS `Ngay_Sua_Cuoi`,
    DEFINER AS `Definer`
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'dulieu04' 
  AND ROUTINE_NAME = 'BaoCaoHoaDonXoaBo';
```

---

## 6. Phương Án Xử Lý & Khắc Phục Triệt Để

### Giải Pháp 1: Cập nhật Stored Procedure trên Database Tenant (Khuyến nghị thực hiện ngay)
Cần chạy script cập nhật Stored Procedure trên database **`dulieu04`** (và rà soát tất cả các tenant DB `dulieu01`, `dulieu02`,...):

```sql
USE `dulieu04`; -- Và các database dulieuXX khác

DROP PROCEDURE IF EXISTS `BaoCaoHoaDonXoaBo`;

DELIMITER $$
CREATE PROCEDURE `BaoCaoHoaDonXoaBo`(
    IN `p_dnMST` VARCHAR(50),
    IN `p_dnMSTOld` VARCHAR(50),        -- Tham số mới bổ sung
    IN `p_issendtbss` INT,
    IN `p_ngaylaptu` DATETIME,
    IN `p_ngaylapden` DATETIME,
    IN `p_ngayhuytu` DATETIME,
    IN `p_ngayhuyden` DATETIME,
    IN `p_nguoihuy_id` INT
)
BEGIN
    -- Logic query báo cáo hóa đơn xóa bỏ
    -- Lưu ý điều kiện lọc MST cần kiểm tra cả p_dnMST và p_dnMSTOld:
    -- WHERE (h.DoanhNghiep_MST = p_dnMST OR (p_dnMSTOld IS NOT NULL AND h.DoanhNghiep_MST = p_dnMSTOld))
    ...
END$$
DELIMITER ;
```

---

### Giải Pháp 2: Xử Lý Tương Thích Ngược (Fallback) trong Code C# (An toàn khi DB chưa đồng bộ)
Trong thời gian chờ cập nhật toàn bộ database tenant, có thể sửa [`BaoCaoRepository.cs`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/Repositories/DoanhNghiep/BaoCaoRepository.cs#L34) để fallback tự động nếu DB chưa nâng cấp:

```csharp
public async Task<List<BaoCaoHoaDonXoaBo>> GetBaoCaoHoaDonXoaBo(
    string dnMST, string dnMSTOld, int? issendtbss, 
    DateTime? ngaylaptu, DateTime? ngaylapden, 
    DateTime? ngayhuytu, DateTime? ngayhuyden, int? nguoihuy_id)
{
    var context = Context.Database;
    var resultquery = new List<BaoCaoHoaDonXoaBo>();
    string ngaylaptustring = ngaylaptu.HasValue ? $"'{ngaylaptu.Value:yyyy-MM-dd HH:mm:ss}'" : "null";
    string ngaylapdenstring = ngaylapden.HasValue ? $"'{ngaylapden.Value:yyyy-MM-dd HH:mm:ss}'" : "null";
    string ngayhuytustring = ngayhuytu.HasValue ? $"'{ngayhuytu.Value:yyyy-MM-dd HH:mm:ss}'" : "null";
    string ngayhuydenstring = ngayhuyden.HasValue ? $"'{ngayhuyden.Value:yyyy-MM-dd HH:mm:ss}'" : "null";
    string issendtbssstring = issendtbss.HasValue ? issendtbss.Value.ToString() : "null";
    string nguoihuy_idstring = nguoihuy_id.HasValue ? nguoihuy_id.Value.ToString() : "null";
    string dnMSTOldString = !string.IsNullOrEmpty(dnMSTOld) ? $"'{dnMSTOld}'" : "null";

    using (var command = context.GetDbConnection().CreateCommand())
    {
        // Thử gọi Procedure 8 tham số trước
        var query8 = $"CALL BaoCaoHoaDonXoaBo('{dnMST}', {dnMSTOldString}, {issendtbssstring}, {ngaylaptustring}, {ngaylapdenstring}, {ngayhuytustring}, {ngayhuydenstring}, {nguoihuy_idstring})";
        command.CommandText = query8;
        command.CommandType = System.Data.CommandType.Text;
        command.Transaction = context.CurrentTransaction?.GetDbTransaction();

        try
        {
            using (var result = await command.ExecuteReaderAsync())
            {
                ReadData(result, resultquery);
            }
        }
        catch (MySql.Data.MySqlClient.MySqlException ex) when (ex.Message.Contains("expected 7, got 8"))
        {
            // Fallback gọi Procedure 7 tham số nếu Tenant DB chưa kịp nâng cấp
            var query7 = $"CALL BaoCaoHoaDonXoaBo('{dnMST}', {issendtbssstring}, {ngaylaptustring}, {ngaylapdenstring}, {ngayhuytustring}, {ngayhuydenstring}, {nguoihuy_idstring})";
            command.CommandText = query7;
            using (var result = await command.ExecuteReaderAsync())
            {
                ReadData(result, resultquery);
            }
        }
    }
    return resultquery;
}
```
