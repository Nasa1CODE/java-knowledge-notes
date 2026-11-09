# Báo Cáo Phân Tích & Phương Án Xử Lý Lỗi Race Condition (Đăng Xuất - TokenAuthController)

## 1. Thông Tin Lỗi & Bối Cảnh (Log Analysis)

* **Thời điểm xảy ra:**
  * `2026-09-10 17:23:49,877`: Thread `[221]` nhận request đăng xuất `LogOut - UserId: 34275` (traceId: `f8896bbe21ff4f4ea742068f3cc98925`).
  * `2026-09-10 17:23:49,900`: Thread `[111]` văng lỗi `AbpDbConcurrencyException` (traceId: `b14da8d5fb9244f1903465622520b68d`).
  * `2026-09-10 17:23:49,902`: Thread `[58 ]` văng lỗi `AbpDbConcurrencyException` (traceId: `f8896bbe21ff4f4ea742068f3cc98925`).
* **Host / Server:** `inv1_cyberbill_202`
* **Source Log:** `/opt/cyberbillapp/App_Data/Logs/Logs.txt`
* **Ngoại lệ:**
  ```text
  Abp.Domain.Uow.AbpDbConcurrencyException: Database operation expected to affect 1 row(s) but actually affected 0 row(s). 
  Data may have been modified or deleted since entities were loaded.
  ---> Microsoft.EntityFrameworkCore.DbUpdateConcurrencyException: Database operation expected to affect 1 row(s) but actually affected 0 row(s).
  ```

> **Đặc điểm mấu chốt:** 2 request có 2 traceId khác nhau được xử lý trên 3 Thread (`221`, `111`, `58`) và phát sinh lỗi **chỉ cách nhau đúng 2 mili-giây (0.002s)** khi cùng thao tác vào tài khoản người dùng `UserId: 34275`.

---

## 2. Vị Trí Gây Lỗi Trong Source Code

* **Controller:** [`TokenAuthController`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/aspnet-core/src/zero/VS.Web.Core/Controllers/TokenAuthController.cs#L934)
* **Action:** `GET /api/TokenAuth/LogOut` (dòng 934 - 953)
* **DbContext quản lý:** `VSDbContext` (kế thừa `AbpZeroDbContext` $\rightarrow$ `AbpZeroCommonDbContext`)
* **Đoạn code thực thi:**
  ```csharp
  [HttpGet]
  [AbpAuthorize]
  public async Task LogOut()
  {
      Logger.Info($"LogOut - UserId: {AbpSession.UserId}"); // Dòng 936
      if (AbpSession.UserId != null)
      {
          var tokenValidityKeyInClaims = User.Claims.First(c => c.Type == AppConsts.TokenValidityKey);
          var user = _userManager.GetUser(AbpSession.ToUserIdentifier());
          ...
          // Dòng 949: Thực hiện xóa TokenValidityKey và cập nhật ConcurrencyStamp của User
          await _userManager.RemoveTokenValidityKeyAsync(_userManager.GetUser(AbpSession.ToUserIdentifier()), tokenValidityKeyInClaims.Value);
          
          _nhatKyHoatDongRepository.ThemNhatKy(user, "Đăng xuất", "", NhatKy_Loai.DangXuat, NhatKy_Muc.TruyCap, "", "");
      }
  } // Kết thúc Action: AbpUowActionFilter gọi SaveChangesAsync() -> GÂY LỖI CONCURRENCY TẠI ĐÂY
  ```

---

## 3. Thông Tin Chính Xác Bảng & Cột Database Bị Tác Động

* **Phạm vi cơ sở dữ liệu:** Database **Host / Tenant** (tùy cấu hình lưu user của hệ thống, qua `VSDbContext`)
* **Bảng vật lý chính:** **`abpusers`** (Quản lý thông tin User và Concurrency Stamp)
* **Bảng vật lý liên quan:** **`abpuserclaims`** (Lưu claim `token_validity_key` bị xóa khi logout)

### Chi tiết các trường (Columns) bị tác động:

| Tên bảng | Tên trường | Kiểu dữ liệu | Ý nghĩa |
| :--- | :--- | :--- | :--- |
| **`abpusers`** | **`Id`** | `bigint` | Mã định danh người dùng (`34275`) |
| **`abpusers`** | **`ConcurrencyStamp`** | `varchar(128)` | **Trường cốt lõi gây lỗi:** Token kiểm tra phiên bản đồng thời của EF Core |
| **`abpusers`** | **`SecurityStamp`** | `varchar(128)` | Mã bảo mật phiên đăng nhập của Identity |
| **`abpusers`** | **`LastModificationTime`** | `datetime` | Thời gian sửa đổi gần nhất |
| **`abpuserclaims`** | **`UserId`** | `bigint` | Khóa ngoại trỏ đến `abpusers.Id` (`34275`) |
| **`abpuserclaims`** | **`ClaimType`** | `varchar(256)` | Loại claim (`token_validity_key`) |
| **`abpuserclaims`** | **`ClaimValue`** | `varchar(512)` | Giá trị token validity key cần thu hồi |

---

## 4. Cơ Chế Phát Sinh Lỗi (Race Condition Mechanism)

1. **Người dùng ấn nút "Đăng xuất" nhiều lần liên tiếp** (hoặc frontend mở nhiều tab, hoặc frontend có interceptor tự động bắt lỗi và đồng thời gọi API Logout):
   * Nút đăng xuất tại [`header.component.html`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/angular/src/app/shared/layout/header.component.html#L246) chưa có cơ chế disable khi click.
2. **Quá trình thực thi đồng thời tại Backend:**
   * **Request 1 (Thành công):** 
     - Tải entity `User` (với `ConcurrencyStamp = "STAMP-A"`).
     - Gọi `RemoveTokenValidityKeyAsync`: Đổi `ConcurrencyStamp` sang `"STAMP-B"` và xóa claim trong `abpuserclaims`.
     - EF Core commit SQL:
       ```sql
       UPDATE abpusers 
       SET ConcurrencyStamp = 'STAMP-B', SecurityStamp = '...' 
       WHERE Id = 34275 AND ConcurrencyStamp = 'STAMP-A';
       ```
       *(Khớp 1 dòng `affected rows = 1` $\rightarrow$ Thành công).*
   * **Request 2 (Văng lỗi sau 2ms):**
     - Đã nạp entity `User` từ trước đó (vẫn giữ `ConcurrencyStamp = "STAMP-A"`).
     - Khi Unit of Work kết thúc, EF Core thực thi câu lệnh `UPDATE`:
       ```sql
       UPDATE abpusers 
       SET ConcurrencyStamp = 'STAMP-C', SecurityStamp = '...' 
       WHERE Id = 34275 AND ConcurrencyStamp = 'STAMP-A';
       ```
     - Vì giá trị trong DB lúc này đã là `'STAMP-B'`, điều kiện `WHERE` **khớp 0 dòng** (`affected 0 rows`).
     - EF Core phát hiện vi phạm xung đột dữ liệu $\rightarrow$ ném ra `DbUpdateConcurrencyException`.

---

## 5. Phương Án Xử Lý & Khắc Phục Triệt Để

### Giải Pháp 1: Bắt và Bỏ Qua Ngoại Lệ Concurrency Tại API LogOut (Backend - Bắt buộc)
Đối với nghiệp vụ **Đăng xuất (LogOut)**, việc một request khác đã cập nhật `ConcurrencyStamp` hay thu hồi token trước đó chứng minh tài khoản **đã được đăng xuất thành công**. Việc ném lỗi 500 về client là không cần thiết.

Sửa lại hàm `LogOut()` và `LogOutSSO()` trong [`TokenAuthController.cs`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/aspnet-core/src/zero/VS.Web.Core/Controllers/TokenAuthController.cs#L934):

```csharp
[HttpGet]
[AbpAuthorize]
[UnitOfWork] // Đảm bảo kiểm soát UnitOfWork rõ ràng
public async Task LogOut()
{
    Logger.Info($"LogOut - UserId: {AbpSession.UserId}");
    if (AbpSession.UserId != null)
    {
        try
        {
            var tokenValidityKeyInClaims = User.Claims.FirstOrDefault(c => c.Type == AppConsts.TokenValidityKey);
            var user = await _userManager.GetUserAsync(AbpSession.ToUserIdentifier());
            if (user == null) return;

            var roles = await _userManager.GetRolesAsync(user);
            foreach (var roleName in roles)
            {
                var role = await _roleManager.GetRoleByNameAsync(roleName);
                if (role != null)
                {
                    var cachekey = $"{role.Id}@{user.TenantId}";
                    _cacheManager.GetRolePermissionCache().Remove(cachekey);
                }
            }
            _cacheManager.GetUserPermissionCache().Remove($"{user.Id}@{user.TenantId}");

            if (tokenValidityKeyInClaims != null)
            {
                await _userManager.RemoveTokenValidityKeyAsync(user, tokenValidityKeyInClaims.Value);
            }
            
            _nhatKyHoatDongRepository.ThemNhatKy(user, "Đăng xuất", "", NhatKy_Loai.DangXuat, NhatKy_Muc.TruyCap, "", "");
            
            // Chủ động lưu thay đổi trong try-catch
            await CurrentUnitOfWork.SaveChangesAsync();
        }
        catch (AbpDbConcurrencyException ex)
        {
            // Request khác đã logout trước đó thành công -> Ghi nhận log cảnh báo và bỏ qua
            Logger.Warn($"Concurrent logout detected for UserId: {AbpSession.UserId}. Safe to ignore. Details: {ex.Message}");
        }
    }
}
```

---

### Giải Pháp 2: Khóa Nút Chống Click Đúp Tại Frontend (Angular)
Tại các giao diện người dùng ([`header.component.ts`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/angular/src/app/shared/layout/header.component.ts) và [`top-bar-menu.component.ts`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/angular/src/app/shared/layout/nav/top-bar-menu.component.ts)):

1. Thêm cờ `isLoggingOut` để ngăn spam click:
```typescript
isLoggingOut = false;

logout(): void {
    if (this.isLoggingOut) {
        return;
    }
    this.isLoggingOut = true;
    this._authService.logout();
}
```

2. Trong [`AppAuthService.ts`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/angular/src/app/shared/common/auth/app-auth.service.ts), xóa token ngay lập tức tại Client trước khi gửi request Logout để vô hiệu hóa phiên ở frontend:
```typescript
logout(reload?: boolean, returnUrl?: string): void {
    const token = abp.auth.getToken();
    // Xóa ngay token ở client để tránh bắn request lặp lại
    abp.auth.clearToken();
    abp.utils.setCookieValue("enc_auth_token", undefined);

    if (token) {
        abp.ajax({
            url: AppConsts.remoteServiceBaseUrl + '/api/TokenAuth/LogOut',
            method: 'GET',
            headers: {
                'Abp.TenantId': abp.multiTenancy.getTenantIdCookie(),
                'Authorization': 'Bearer ' + token
            }
        }).always(() => {
            if (reload !== false) {
                location.href = returnUrl || "";
            }
        });
    } else {
        if (reload !== false) {
            location.href = returnUrl || "";
        }
    }
}
```
