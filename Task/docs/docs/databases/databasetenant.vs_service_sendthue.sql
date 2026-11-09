-- Table: vs_service_sendthue
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/Services/Service_SendThue.cs
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
--   TCT_Link varchar(255) NULL -- C# string
--   TCT_TaiKhoan varchar(255) NULL -- C# string
--   TCT_BaoMat varchar(255) NULL -- C# string
--   File_DinhKem varchar(255) NULL -- C# string
--   TrangThaiGui int NOT NULL -- C# int
--   NgayGui datetime NULL -- C# DateTime?
--   MaLoi varchar(255) NULL -- C# string
--   MaXacThuc varchar(255) NULL -- C# string
--   MaXacThuc_NgayCap datetime NULL -- C# DateTime?
--   HoaDon_Id int NOT NULL -- C# int
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   HoaDon text NOT NULL -- C# HD_HoaDon

CREATE TABLE `vs_service_sendthue` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TCT_Link` varchar(255) NULL,
    `TCT_TaiKhoan` varchar(255) NULL,
    `TCT_BaoMat` varchar(255) NULL,
    `File_DinhKem` varchar(255) NULL,
    `TrangThaiGui` int NOT NULL,
    `NgayGui` datetime NULL,
    `MaLoi` varchar(255) NULL,
    `MaXacThuc` varchar(255) NULL,
    `MaXacThuc_NgayCap` datetime NULL,
    `HoaDon_Id` int NOT NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `HoaDon` text NOT NULL
);
