-- Table: vs_doanhnghiep_tochuc
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DoanhNghiep/DoanhNghiep_ToChuc.cs
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
--   Ma varchar(255) NULL -- C# string
--   Ten varchar(255) NULL -- C# string
--   ToChuc_Cha_Id int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   Tc_DienThoai varchar(255) NULL -- C# string
--   Tc_Fax varchar(255) NULL -- C# string
--   Tc_Email varchar(255) NULL -- C# string
--   Tc_DiaChi varchar(255) NULL -- C# string
--   Tc_TaiKhoan varchar(255) NULL -- C# string
--   Tc_NganHang varchar(255) NULL -- C# string
--   Tc_Website varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_doanhnghiep_tochuc` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Ma` varchar(255) NULL,
    `Ten` varchar(255) NULL,
    `ToChuc_Cha_Id` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `Tc_DienThoai` varchar(255) NULL,
    `Tc_Fax` varchar(255) NULL,
    `Tc_Email` varchar(255) NULL,
    `Tc_DiaChi` varchar(255) NULL,
    `Tc_TaiKhoan` varchar(255) NULL,
    `Tc_NganHang` varchar(255) NULL,
    `Tc_Website` varchar(255) NULL,
    `TenantId` int NULL
);
