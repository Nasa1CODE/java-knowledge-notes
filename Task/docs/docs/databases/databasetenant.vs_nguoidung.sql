-- Table: vs_nguoidung
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/QuanLy/NguoiDung.cs
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
--   UserId bigint NOT NULL -- C# long
--   TenantId int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   UserName varchar(255) NULL -- C# string
--   Oid varchar(255) NULL -- C# string
--   TrangThaiDangKyMB int NULL -- C# int?
--   Custom_Field varchar(255) NULL -- C# string
--   Uuid_CyberId varchar(255) NULL -- C# string
--   Subid_CyberId varchar(255) NULL -- C# string
--   IsActive_Hddv bit NULL -- C# bool?
--   DoanhNghiep_MST_Old varchar(255) NULL -- C# string

CREATE TABLE `vs_nguoidung` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `UserId` bigint NOT NULL,
    `TenantId` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `UserName` varchar(255) NULL,
    `Oid` varchar(255) NULL,
    `TrangThaiDangKyMB` int NULL,
    `Custom_Field` varchar(255) NULL,
    `Uuid_CyberId` varchar(255) NULL,
    `Subid_CyberId` varchar(255) NULL,
    `IsActive_Hddv` bit NULL,
    `DoanhNghiep_MST_Old` varchar(255) NULL
);
