-- Table: vs_dm_khachhang_nganhang
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMDoanhNghiep/DMKhachHang_NganHang.cs
--
-- Fields inferred from C# entity properties. Verify exact SQL types, lengths, indexes, and constraints against real migrations/schema before deployment.
-- Fields:
--   Id int NOT NULL -- inherited Entity key
--   CreationTime datetime NOT NULL -- inherited audit field
--   CreatorUserId bigint NULL -- inherited audit field
--   LastModificationTime datetime NULL -- inherited audit field
--   LastModifierUserId bigint NULL -- inherited audit field
--   IsDeleted bit NOT NULL -- inherited soft-delete field
--   DeleterUserId bigint NULL -- inherited soft-delete field
--   DeletionTime datetime NULL -- inherited soft-delete field
--   TaiKhoan_Ma varchar(255) NULL -- C# string
--   TaiKhoan_Ten varchar(255) NULL -- C# string
--   NganHang_Ma varchar(255) NULL -- C# string
--   NganHang_Ten varchar(255) NULL -- C# string
--   NganHang_ChiNhanh varchar(255) NULL -- C# string
--   KhachHang_MST varchar(255) NULL -- C# string
--   KhachHang_Id int NULL -- C# int?
--   Stt int NULL -- C# int?
--   TenantId int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string

CREATE TABLE `vs_dm_khachhang_nganhang` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TaiKhoan_Ma` varchar(255) NULL,
    `TaiKhoan_Ten` varchar(255) NULL,
    `NganHang_Ma` varchar(255) NULL,
    `NganHang_Ten` varchar(255) NULL,
    `NganHang_ChiNhanh` varchar(255) NULL,
    `KhachHang_MST` varchar(255) NULL,
    `KhachHang_Id` int NULL,
    `Stt` int NULL,
    `TenantId` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL
);
