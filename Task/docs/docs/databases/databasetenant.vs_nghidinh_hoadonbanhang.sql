-- Table: vs_nghidinh_hoadonbanhang
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/QuanLy/NghiDinhHoaDonBanHang.cs
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
--   Ma int NULL -- C# int?
--   TenNghiDinh varchar(255) NULL -- C# string
--   HieuLuc bit NULL -- C# bool?
--   TagXml varchar(255) NULL -- C# string
--   StringMauhd varchar(255) NULL -- C# string
--   StringXmlhd varchar(255) NULL -- C# string

CREATE TABLE `vs_nghidinh_hoadonbanhang` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Ma` int NULL,
    `TenNghiDinh` varchar(255) NULL,
    `HieuLuc` bit NULL,
    `TagXml` varchar(255) NULL,
    `StringMauhd` varchar(255) NULL,
    `StringXmlhd` varchar(255) NULL
);
