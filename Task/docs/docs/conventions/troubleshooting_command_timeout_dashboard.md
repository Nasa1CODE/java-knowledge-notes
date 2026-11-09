# Báo Cáo Phân Tích & Phương Án Xử Lý Lỗi Command Timeout (Dashboard DN)

## 1. Thông Tin Lỗi (Log Analysis)

* **Thời điểm xảy ra:**
  * `2026-09-10 17:20:14,880`: User thực hiện đăng nhập Cyber ID `/management/cyberid/login request`
  * `2026-09-10 17:20:45,332`: Bị văng lỗi sau đúng **30.45 giây** (ngưỡng mặc định `Command Timeout = 30s` của MySQL Connector).
* **TraceId:** `38f2ab956e9441a08b695729f524f4c6`
* **Host / Server:** `inv1_cyberbill4_207`
* **Source Log:** `/opt/cyberbillapp/App_Data/Logs/Logs.txt`
* **Ngoại lệ:**
  ```text
  System.InvalidOperationException: An exception has been raised that is likely due to a transient failure.
  ---> MySql.Data.MySqlClient.MySqlException (0x80004005): The Command Timeout expired before the operation completed.
  ```

---

## 2. Vị Trí Gây Lỗi Trong Source Code

* **Service:** [`DashBoard_DNAppService`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/Dashboard/DashBoard_DNAppService.cs)
* **Hàm:** `GetAll()` (dòng 387) $\rightarrow$ gọi hàm `Reload()` (dòng 402)
* **Đoạn code thực thi:**
  ```csharp
  // DashBoard_DNAppService.cs: line 395 - 404
  var qr = _hoaDonRepository
      .Query(m => m.Where(a =>
        (a.DoanhNghiep_MST == dn.DoanhNghiep_MST || a.DoanhNghiep_MST == dn.DoanhNghiep_CCCD) &&
        a.QuanLy_TrangThai == 3 &&
        a.Mau_NgayKy >= DateTime.Now.Date &&
        a.Mau_NgayKy < DateTime.Now.Date.AddDays(1)))
      ;
  if (qr != null && qr.Count() > 0) // <--- LINE 402: Bị Timeout tại đây khi EF Core chạy COUNT(*)
  {
      var lst = qr.ToList();        // <--- LINE 404: Nếu vượt qua Count() thì lại SELECT * quét lại DB lần 2
      ...
  }
  ```

---

## 3. Thông Tin Chính Xác Bảng & Cột Database

* **Phạm vi cơ sở dữ liệu:** Database **Tenant**
* **Tên bảng vật lý trong MySQL:** **`vs_hd_tonghop`**
  *(Ánh xạ từ Entity C# [`HD_HoaDon`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_HoaDon.cs#L13-L14) có attribute `[Table("vs_hd_tonghop")]`)*
* **Các trường (Columns) tham gia câu truy vấn:**

| Tên trường DB | Kiểu dữ liệu | Ý nghĩa trong câu query |
| :--- | :--- | :--- |
| **`DoanhNghiep_MST`** | `varchar(255)` | Mã số thuế / CCCD doanh nghiệp |
| **`QuanLy_TrangThai`** | `int` | Trạng thái hóa đơn (`3`: Đã ký / phát hành) |
| **`Mau_NgayKy`** | `datetime` | Thời gian ký hóa đơn (lọc theo ngày hiện tại) |
| **`Mau_HoaDon_Loai`** | `int` | Phân loại hóa đơn (Gốc, Thay thế, Điều chỉnh, Hủy) |
| **`IsDeleted`** | `bit / tinyint(1)` | Bộ lọc tự động xóa mềm của ABP Framework (`IsDeleted = 0`) |
| **`TenantId`** | `int` | Bộ lọc tự động đa người thuê (`IMayHaveTenant`) |

---

## 4. Nguyên Nhân Gốc Rễ (Root Cause)

1. **Full Table Scan trên bảng lớn `vs_hd_tonghop`:**
   * Bảng `vs_hd_tonghop` là bảng trung tâm lưu trữ toàn bộ hóa đơn của hệ thống (dữ liệu có thể lên tới hàng triệu bản ghi).
   * Điều kiện query kết hợp `(DoanhNghiep_MST = @mst OR DoanhNghiep_MST = @cccd)` cùng khoảng ngày `Mau_NgayKy >= ... AND Mau_NgayKy < ...`. Khi thiếu Composite Index bao gồm các cột này, MySQL phải quét toàn bộ bảng dẫn đến thời gian thực thi vượt quá 30 giây.
2. **Code Anti-pattern (Query 2 lần + Load dư thừa dữ liệu):**
   * **Truy vấn kép:** Dòng 402 gọi `qr.Count()` $\rightarrow$ EF Core phát sinh 1 câu `SELECT COUNT(*)`. Ngay sau đó dòng 404 lại gọi `qr.ToList()` $\rightarrow$ phát sinh tiếp 1 câu `SELECT *` quét lại DB.
   * **Tải thừa trường:** Entity `HD_HoaDon` có hơn 100 trường dữ liệu (gồm cả các trường text dài như XML, thông tin thỏa thuận, chữ ký...), trong khi hàm `Reload()` thực tế chỉ cần dùng duy nhất trường **`Mau_HoaDon_Loai`** để đếm số lượng.

---

## 5. Phương Án Xử Lý & Khắc Phục

### Giải Pháp 1: Tối Ưu Lại Code Trong `DashBoard_DNAppService.cs` (Bắt buộc)
Thay thế toàn bộ đoạn code trong hàm `Reload()` để:
- Bỏ câu `qr.Count()` thừa.
- Chỉ `Select(x => x.Mau_HoaDon_Loai)` để MySQL chỉ cần đọc đúng 1 cột (Index Only Scan), tốc độ tăng gấp hàng chục lần.

```csharp
public List<int> Reload()
{
    var dn = GetCurrentDoanhNghiep();
    List<int> result = new List<int>() { 0, 0, 0, 0 };

    var todayStart = DateTime.Now.Date;
    var todayEnd = todayStart.AddDays(1);
    var mst = dn.DoanhNghiep_MST;
    var cccd = dn.DoanhNghiep_CCCD;

    // Chỉ truy vấn duy nhất 1 lần và chỉ lấy trường Mau_HoaDon_Loai
    var lstLoaiHoaDon = _hoaDonRepository.GetAll()
        .Where(a => (a.DoanhNghiep_MST == mst || a.DoanhNghiep_MST == cccd)
                 && a.QuanLy_TrangThai == 3
                 && a.Mau_NgayKy >= todayStart
                 && a.Mau_NgayKy < todayEnd)
        .Select(a => a.Mau_HoaDon_Loai)
        .ToList();

    if (lstLoaiHoaDon.Count > 0)
    {
        int slgoc = 0, sldieuchinh = 0, slthaythe = 0, slhethieuluc = 0;
        foreach (var loai in lstLoaiHoaDon)
        {
            if (loai == 1)
                slgoc++;
            else if (loai == 3)
                slthaythe++;
            else if (loai == 5 || loai == 9)
                sldieuchinh++;
            else if (loai == 2 || loai == 4 || loai == 6)
                slhethieuluc++;
        }
        result = TinhPhanTram(slgoc, slthaythe, sldieuchinh, slhethieuluc);
    }

    return result;
}
```

---

### Giải Pháp 2: Bổ Sung Index Cho Bảng `vs_hd_tonghop` Trong Database
Tạo Composite Index tối ưu phục vụ cho truy vấn Dashboard:

```sql
-- Chạy trên các Database Tenant:
CREATE INDEX `IX_vs_hd_tonghop_Dashboard_Reload` 
ON `vs_hd_tonghop` (`IsDeleted`, `DoanhNghiep_MST`, `QuanLy_TrangThai`, `Mau_NgayKy`, `Mau_HoaDon_Loai`);
```

---

### Giải Pháp 3: Cấu Hình Tăng Resiliency & Timeout (Khuyến nghị thêm)
Trong cấu hình EF Core DbContext (`...DbContextConfigurer.cs`), bổ sung cấu hình retry và tăng timeout nếu cần:
```csharp
builder.UseMySql(connectionString, serverVersion, options =>
{
    options.EnableRetryOnFailure(
        maxRetryCount: 3,
        maxRetryDelay: TimeSpan.FromSeconds(5),
        errorNumbersToAdd: null);
    options.CommandTimeout(60); // Tăng timeout lên 60 giây nếu truy vấn thống kê lớn
});
```
