# Invoicecore Vehicle Asset Detail Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Persist and expose the new vehicle/asset detail fields on `vs_hd_chitiet_morong` through the `invoicecore` backend.

**Architecture:** The entity and its application DTO will use the exact existing database column names as C# property names. Existing `ReverseMap()` mapping will carry identical properties automatically; Dapper's explicit `Add`, `AddRange`, and `Update` SQL must each be extended so Dapper invoice writes persist all fields. The schema is deployed through an SQL script because HDDT has no EF migration directory.

**Tech Stack:** C#, ASP.NET Zero/ABP, Entity Framework Core, AutoMapper, Dapper, MySQL/MariaDB, .NET solution build.

---

## File Structure

- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_ChiTiet_MoRong.cs` - persistence entity properties.
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/HoaDon/QuanLyHoaDon/HD_ChiTiet_MoRongDto.cs` - API input/output properties.
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_ChiTiet_MoRongRepository.cs` - explicit Dapper create/update statements.
- Create: `invoicecore/aspnet-core/database/2026-08-13-add-vehicle-asset-columns-to-vs_hd_chitiet_morong.sql` - schema deployment script.

### Task 1: Extend Entity and DTO Contract

**Files:**
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_ChiTiet_MoRong.cs:51-58`
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/HoaDon/QuanLyHoaDon/HD_ChiTiet_MoRongDto.cs:54-61`

- [ ] **Step 1: Add the exact database-named fields to the entity after the existing specialized-goods fields**

```csharp
public int? ltsan { get; set; }
public int? tttsan { get; set; }
public int? xxu { get; set; }
public string sgcnatkthuat { get; set; }
public string sspktcclxxuong { get; set; }
public string mnsxuat { get; set; }
public string tltsdky { get; set; }
public int? nsxuat { get; set; }
public string ttmai { get; set; }
public string tnhieu { get; set; }
public string klxe { get; set; }
public string ttlvhcs { get; set; }
public decimal? ttai { get; set; }
public int? scngoi { get; set; }
public int? cltsan { get; set; }
public string sbksoat { get; set; }
```

- [ ] **Step 2: Add the identical fields and types to `HD_ChiTiet_MoRongDto`**

```csharp
public int? ltsan { get; set; }
public int? tttsan { get; set; }
public int? xxu { get; set; }
public string sgcnatkthuat { get; set; }
public string sspktcclxxuong { get; set; }
public string mnsxuat { get; set; }
public string tltsdky { get; set; }
public int? nsxuat { get; set; }
public string ttmai { get; set; }
public string tnhieu { get; set; }
public string klxe { get; set; }
public string ttlvhcs { get; set; }
public decimal? ttai { get; set; }
public int? scngoi { get; set; }
public int? cltsan { get; set; }
public string sbksoat { get; set; }
```

- [ ] **Step 3: Build the solution to verify DTO mapping and project compilation**

Run: `dotnet build VS.Web.sln --no-restore`

Expected: Build succeeds with no errors.

### Task 2: Persist New Fields in Dapper Writes

**Files:**
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_ChiTiet_MoRongRepository.cs:51-52`
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_ChiTiet_MoRongRepository.cs:68-69`
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_ChiTiet_MoRongRepository.cs:79-80`

- [ ] **Step 1: Extend the `Add` SQL column and parameter lists after `So_Dinh_Danh_Gui_Hang`**

```sql
,ltsan,tttsan,xxu,sgcnatkthuat,sspktcclxxuong,mnsxuat,tltsdky,nsxuat,ttmai,tnhieu,klxe,ttlvhcs,ttai,scngoi,cltsan,sbksoat
```

```sql
,@ltsan,@tttsan,@xxu,@sgcnatkthuat,@sspktcclxxuong,@mnsxuat,@tltsdky,@nsxuat,@ttmai,@tnhieu,@klxe,@ttlvhcs,@ttai,@scngoi,@cltsan,@sbksoat
```

- [ ] **Step 2: Apply the same field and parameter lists to the `AddRange` SQL statement**

```sql
,ltsan,tttsan,xxu,sgcnatkthuat,sspktcclxxuong,mnsxuat,tltsdky,nsxuat,ttmai,tnhieu,klxe,ttlvhcs,ttai,scngoi,cltsan,sbksoat
```

```sql
,@ltsan,@tttsan,@xxu,@sgcnatkthuat,@sspktcclxxuong,@mnsxuat,@tltsdky,@nsxuat,@ttmai,@tnhieu,@klxe,@ttlvhcs,@ttai,@scngoi,@cltsan,@sbksoat
```

- [ ] **Step 3: Extend the `Update` SET clause before `WHERE Id = @Id`**

```sql
,ltsan = @ltsan,tttsan = @tttsan,xxu = @xxu,sgcnatkthuat = @sgcnatkthuat,sspktcclxxuong = @sspktcclxxuong,mnsxuat = @mnsxuat,tltsdky = @tltsdky,nsxuat = @nsxuat,ttmai = @ttmai,tnhieu = @tnhieu,klxe = @klxe,ttlvhcs = @ttlvhcs,ttai = @ttai,scngoi = @scngoi,cltsan = @cltsan,sbksoat = @sbksoat
```

- [ ] **Step 4: Inspect the repository source to verify all 16 field names occur in each of the three write paths**

Run: `rg -n "ltsan|tttsan|xxu|sgcnatkthuat|sspktcclxxuong|mnsxuat|tltsdky|nsxuat|ttmai|tnhieu|klxe|ttlvhcs|ttai|scngoi|cltsan|sbksoat" src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_ChiTiet_MoRongRepository.cs`

Expected: Each field appears in `Add`, `AddRange`, and `Update` statements.

### Task 3: Add Database Deployment Script

**Files:**
- Create: `invoicecore/aspnet-core/database/2026-08-13-add-vehicle-asset-columns-to-vs_hd_chitiet_morong.sql`

- [ ] **Step 1: Create the SQL schema change with the approved nullable `ttai` definition**

```sql
ALTER TABLE vs_hd_chitiet_morong
    ADD COLUMN ltsan int(1) NULL COMMENT 'Loai tai san',
    ADD COLUMN tttsan int(1) NULL COMMENT 'Tinh trang tai san',
    ADD COLUMN xxu int(1) NULL COMMENT 'Xuat xu',
    ADD COLUMN sgcnatkthuat varchar(200) NULL COMMENT 'So Giay chung nhan chat luong an toan ky thuat va bao ve moi truong (doi voi xe nhap khau)',
    ADD COLUMN sspktcclxxuong varchar(200) NULL COMMENT 'So seri Phieu kiem tra chat luong xuat xuong (xe san xuat, lap rap trong nuoc)',
    ADD COLUMN mnsxuat varchar(2) NULL COMMENT 'Ma Nuoc san xuat',
    ADD COLUMN tltsdky varchar(200) NULL COMMENT 'Ten loai tai san dang ky',
    ADD COLUMN nsxuat int(4) NULL COMMENT 'Nam san xuat',
    ADD COLUMN ttmai varchar(300) NULL COMMENT 'Ten thuong mai',
    ADD COLUMN tnhieu varchar(200) NULL COMMENT 'Ten nhan hieu',
    ADD COLUMN klxe varchar(50) NULL COMMENT 'Kieu loai xe',
    ADD COLUMN ttlvhcs varchar(10) NULL COMMENT 'The tich lam viec hoac Cong suat',
    ADD COLUMN ttai decimal(10, 2) NULL COMMENT 'Trong tai',
    ADD COLUMN scngoi int(4) NULL COMMENT 'So nguoi cho phep cho',
    ADD COLUMN cltsan int(4) NULL COMMENT 'Chat luong tai san %',
    ADD COLUMN sbksoat varchar(255) NULL COMMENT 'So bien kiem soat';
```

- [ ] **Step 2: Review the script against the entity field list and user-approved nullable `ttai` type**

Run: `rg -n "ltsan|tttsan|xxu|sgcnatkthuat|sspktcclxxuong|mnsxuat|tltsdky|nsxuat|ttmai|tnhieu|klxe|ttlvhcs|ttai|scngoi|cltsan|sbksoat|ttai decimal\(10, 2\) NULL" database/2026-08-13-add-vehicle-asset-columns-to-vs_hd_chitiet_morong.sql`

Expected: The command prints all 16 column definitions, including `ttai decimal(10, 2) NULL`.

### Task 4: Final Verification

**Files:**
- Verify: `invoicecore/aspnet-core/VS.Web.sln`
- Verify: all files changed by Tasks 1-3

- [ ] **Step 1: Build the complete solution**

Run: `dotnet build VS.Web.sln --no-restore`

Expected: Build succeeds with no errors.

- [ ] **Step 2: Inspect the final change set**

Run: `git diff -- src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_ChiTiet_MoRong.cs src/hddt/HDDT.Application/DataTransferObjects/HoaDon/QuanLyHoaDon/HD_ChiTiet_MoRongDto.cs src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_ChiTiet_MoRongRepository.cs database/2026-08-13-add-vehicle-asset-columns-to-vs_hd_chitiet_morong.sql`

Expected: Only the 16 approved fields and the SQL deployment script are present.
