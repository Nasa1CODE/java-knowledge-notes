-- Table: vs_doanhnghiep_nganhang
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DoanhNghiep/DoanhNghiep_NganHang.cs
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
--   TenantId int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string

CREATE TABLE `vs_doanhnghiep_nganhang` (
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
    `TenantId` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL
);
