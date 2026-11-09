# Invoicecore Vehicle Asset PascalCase Design

## Scope

The user has renamed the 16 vehicle/asset properties in `HD_ChiTiet_MoRong` and `HD_ChiTiet_MoRongDto` to the following exact PascalCase-style names:

`LTSan`, `TTTSan`, `XXu`, `SGCNATKThuat`, `SSPKTCLXXuong`, `MNSXuat`, `TLTSDKy`, `NSXuat`, `TTMai`, `TNHieu`, `KLXe`, `TTLVHCSuat`, `TTai`, `SCNgoi`, `CLTSan`, and `SBKSoat`.

The change is limited to the remaining backend references. The database schema and existing deployment SQL remain unchanged.

## Persistence Mapping

The Dapper SQL retains lowercase database column names: `ltsan`, `tttsan`, `xxu`, `sgcnatkthuat`, `sspktcclxxuong`, `mnsxuat`, `tltsdky`, `nsxuat`, `ttmai`, `tnhieu`, `klxe`, `ttlvhcs`, `ttai`, `scngoi`, `cltsan`, and `sbksoat`.

Dapper parameter names are changed to match the renamed entity properties, such as `@LTSan` for the `ltsan` column and `@TTai` for the `ttai` column. The manual `HD_HoaDonRepository` projection uses the same PascalCase names on both sides of each assignment.

## Verification

Build the affected HDDT Application, DapperCore, and EntityFrameworkCore projects. Confirm no lowercase C# property reference remains outside the SQL column identifiers and the database deployment script.
