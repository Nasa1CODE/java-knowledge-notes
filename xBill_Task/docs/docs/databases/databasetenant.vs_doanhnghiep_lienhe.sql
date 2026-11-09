-- Table: vs_doanhnghiep_lienhe
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DoanhNghiep_LienHe.cs
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
--   LienHe_HoTen varchar(255) NULL -- C# string
--   LienHe_Sdt varchar(255) NULL -- C# string
--   LienHe_Email varchar(255) NULL -- C# string
--   LienHe_NgaySinh datetime NULL -- C# DateTime?
--   LienHe_GioiTinh int NULL -- C# int?
--   LienHe_DiaChi varchar(255) NULL -- C# string
--   LienHe_ChucVu varchar(255) NULL -- C# string
--   DoanhNghiep_Mst varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_doanhnghiep_lienhe` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `LienHe_HoTen` varchar(255) NULL,
    `LienHe_Sdt` varchar(255) NULL,
    `LienHe_Email` varchar(255) NULL,
    `LienHe_NgaySinh` datetime NULL,
    `LienHe_GioiTinh` int NULL,
    `LienHe_DiaChi` varchar(255) NULL,
    `LienHe_ChucVu` varchar(255) NULL,
    `DoanhNghiep_Mst` varchar(255) NULL,
    `TenantId` int NULL
);
