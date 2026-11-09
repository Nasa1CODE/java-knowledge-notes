# Invoicecore Vehicle Asset PascalCase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Synchronize Dapper persistence and invoice projection with the user-renamed PascalCase vehicle/asset entity and DTO properties.

**Architecture:** Entity and DTO properties already use the requested PascalCase names. Dapper SQL retains lowercase database column identifiers but binds parameters by the renamed property names. The manual EF invoice projection assigns the same PascalCase property name from source to destination.

**Tech Stack:** C#, Dapper, Entity Framework Core, ASP.NET Zero/ABP, .NET SDK.

---

## File Structure

- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_ChiTiet_MoRongRepository.cs` - change Dapper parameter names only.
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/Repositories/HoaDon/HD_HoaDonRepository.cs` - change manual projection property names.

### Task 1: Synchronize Persistence References

**Files:**
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_ChiTiet_MoRongRepository.cs:51-52,68-69,80`
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/Repositories/HoaDon/HD_HoaDonRepository.cs:546-561`

- [ ] **Step 1: Replace the 16 Dapper parameter names in `Add` and `AddRange`, retaining lowercase SQL column names**

```sql
@LTSan,@TTTSan,@XXu,@SGCNATKThuat,@SSPKTCLXXuong,@MNSXuat,@TLTSDKy,@NSXuat,@TTMai,@TNHieu,@KLXe,@TTLVHCSuat,@TTai,@SCNgoi,@CLTSan,@SBKSoat
```

- [ ] **Step 2: Replace the 16 `Update` parameter names with the matching PascalCase names**

```sql
ltsan = @LTSan,tttsan = @TTTSan,xxu = @XXu,sgcnatkthuat = @SGCNATKThuat,sspktcclxxuong = @SSPKTCLXXuong,mnsxuat = @MNSXuat,tltsdky = @TLTSDKy,nsxuat = @NSXuat,ttmai = @TTMai,tnhieu = @TNHieu,klxe = @KLXe,ttlvhcs = @TTLVHCSuat,ttai = @TTai,scngoi = @SCNgoi,cltsan = @CLTSan,sbksoat = @SBKSoat
```

- [ ] **Step 3: Replace the manual projection assignments with exact PascalCase source and destination names**

```csharp
LTSan = ct.HD_ChiTiet_MoRong.LTSan,
TTTSan = ct.HD_ChiTiet_MoRong.TTTSan,
XXu = ct.HD_ChiTiet_MoRong.XXu,
SGCNATKThuat = ct.HD_ChiTiet_MoRong.SGCNATKThuat,
SSPKTCLXXuong = ct.HD_ChiTiet_MoRong.SSPKTCLXXuong,
MNSXuat = ct.HD_ChiTiet_MoRong.MNSXuat,
TLTSDKy = ct.HD_ChiTiet_MoRong.TLTSDKy,
NSXuat = ct.HD_ChiTiet_MoRong.NSXuat,
TTMai = ct.HD_ChiTiet_MoRong.TTMai,
TNHieu = ct.HD_ChiTiet_MoRong.TNHieu,
KLXe = ct.HD_ChiTiet_MoRong.KLXe,
TTLVHCSuat = ct.HD_ChiTiet_MoRong.TTLVHCSuat,
TTai = ct.HD_ChiTiet_MoRong.TTai,
SCNgoi = ct.HD_ChiTiet_MoRong.SCNgoi,
CLTSan = ct.HD_ChiTiet_MoRong.CLTSan,
SBKSoat = ct.HD_ChiTiet_MoRong.SBKSoat,
```

- [ ] **Step 4: Verify no lowercase C# parameter/property references remain in the two files**

Run: `rg -n "@(ltsan|tttsan|xxu|sgcnatkthuat|sspktcclxxuong|mnsxuat|tltsdky|nsxuat|ttmai|tnhieu|klxe|ttlvhcs|ttai|scngoi|cltsan|sbksoat)|\.ltsan|\.tttsan|\.xxu|\.sgcnatkthuat|\.sspktcclxxuong|\.mnsxuat|\.tltsdky|\.nsxuat|\.ttmai|\.tnhieu|\.klxe|\.ttlvhcs|\.ttai|\.scngoi|\.cltsan|\.sbksoat" src/hddt/HDDT.DapperCore/HDDT.DapperCore/Repositories/HD_ChiTiet_MoRongRepository.cs src/hddt/HDDT.EntityFrameworkCore/EntityFrameworkCore/Repositories/HoaDon/HD_HoaDonRepository.cs`

Expected: No matches.

### Task 2: Verify Affected Projects

**Files:**
- Verify: `invoicecore/aspnet-core/src/hddt/HDDT.DapperCore/HDDT.DapperCore/HDDT.DapperCore.csproj`
- Verify: `invoicecore/aspnet-core/src/hddt/HDDT.EntityFrameworkCore/HDDT.EntityFrameworkCore.csproj`

- [ ] **Step 1: Check the final diff has only Dapper parameter and projection renames**

Run: `git diff --check`

Expected: Exit code 0 with no whitespace errors.

- [ ] **Step 2: Build Dapper persistence**

Run: `dotnet build src/hddt/HDDT.DapperCore/HDDT.DapperCore/HDDT.DapperCore.csproj --no-restore`

Expected: Build succeeded with 0 errors.

- [ ] **Step 3: Build EF projection**

Run: `dotnet build src/hddt/HDDT.EntityFrameworkCore/HDDT.EntityFrameworkCore.csproj --no-restore`

Expected: Build succeeded with 0 errors.
