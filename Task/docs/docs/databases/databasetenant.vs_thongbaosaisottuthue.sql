-- Table: vs_thongbaosaisottuthue
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/TongCucThue/ThongBaoSaiSotTuThue.cs
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
--   MauSo varchar(255) NULL -- C# string
--   Ten varchar(255) NULL -- C# string
--   DiaDanh varchar(255) NULL -- C# string
--   TenCqtTren varchar(255) NULL -- C# string
--   TenCqt varchar(255) NULL -- C# string
--   Tnnt varchar(255) NULL -- C# string
--   DiaChi_Nnt varchar(255) NULL -- C# string
--   MaGddt varchar(255) NULL -- C# string
--   DiaChi_Tdt varchar(255) NULL -- C# string
--   ThoiHan datetime NULL -- C# DateTime?
--   Lan int NULL -- C# int?
--   HinhThuc varchar(255) NULL -- C# string
--   ChucDanh varchar(255) NULL -- C# string
--   DoanhNghiep_Mst varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   SoThongBao varchar(255) NULL -- C# string
--   NgayThongBao datetime NULL -- C# DateTime?

CREATE TABLE `vs_thongbaosaisottuthue` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `MauSo` varchar(255) NULL,
    `Ten` varchar(255) NULL,
    `DiaDanh` varchar(255) NULL,
    `TenCqtTren` varchar(255) NULL,
    `TenCqt` varchar(255) NULL,
    `Tnnt` varchar(255) NULL,
    `DiaChi_Nnt` varchar(255) NULL,
    `MaGddt` varchar(255) NULL,
    `DiaChi_Tdt` varchar(255) NULL,
    `ThoiHan` datetime NULL,
    `Lan` int NULL,
    `HinhThuc` varchar(255) NULL,
    `ChucDanh` varchar(255) NULL,
    `DoanhNghiep_Mst` varchar(255) NULL,
    `TenantId` int NULL,
    `SoThongBao` varchar(255) NULL,
    `NgayThongBao` datetime NULL
);
