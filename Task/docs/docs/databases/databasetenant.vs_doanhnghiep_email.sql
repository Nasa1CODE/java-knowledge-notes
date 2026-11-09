-- Table: vs_doanhnghiep_email
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DoanhNghiep_Email.cs
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
--   DoanhNghiep_TaiKhoanEmail varchar(255) NULL -- C# string
--   DoanhNghiep_MatKhau varchar(255) NULL -- C# string
--   DoanhNghiep_Port varchar(255) NULL -- C# string
--   DoanhNghiep_Ssl bit NOT NULL -- C# bool
--   Mail_Smtp varchar(255) NULL -- C# string
--   Mail_From varchar(255) NULL -- C# string
--   Mail_Name varchar(255) NULL -- C# string
--   Email_Loai int NULL -- C# int?
--   DoanhNghiep_Mst varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_doanhnghiep_email` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DoanhNghiep_TaiKhoanEmail` varchar(255) NULL,
    `DoanhNghiep_MatKhau` varchar(255) NULL,
    `DoanhNghiep_Port` varchar(255) NULL,
    `DoanhNghiep_Ssl` bit NOT NULL,
    `Mail_Smtp` varchar(255) NULL,
    `Mail_From` varchar(255) NULL,
    `Mail_Name` varchar(255) NULL,
    `Email_Loai` int NULL,
    `DoanhNghiep_Mst` varchar(255) NULL,
    `TenantId` int NULL
);
