-- Table: vs_dm_doanhnghiep_kho
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMDoanhNghiep/DMDoanhNghiep_Kho.cs
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
--   MaKho varchar(255) NULL -- C# string
--   TenKho varchar(255) NULL -- C# string
--   TrangThai bit NULL -- C# bool?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NOT NULL -- C# int

CREATE TABLE `vs_dm_doanhnghiep_kho` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `MaKho` varchar(255) NULL,
    `TenKho` varchar(255) NULL,
    `TrangThai` bit NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NOT NULL
);
