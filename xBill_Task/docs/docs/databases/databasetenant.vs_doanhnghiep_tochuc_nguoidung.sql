-- Table: vs_doanhnghiep_tochuc_nguoidung
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DoanhNghiep/DoanhNghiep_ToChuc_NguoiDung.cs
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
--   ToChuc_Id int NOT NULL -- C# int
--   NguoiDung_ThongTin_Id int NOT NULL -- C# int
--   UserId int NOT NULL -- C# int
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_doanhnghiep_tochuc_nguoidung` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ToChuc_Id` int NOT NULL,
    `NguoiDung_ThongTin_Id` int NOT NULL,
    `UserId` int NOT NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
