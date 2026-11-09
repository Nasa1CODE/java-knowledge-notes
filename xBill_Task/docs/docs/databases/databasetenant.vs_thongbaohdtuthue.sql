-- Table: vs_thongbaohdtuthue
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/TongCucThue/ThongBaoHdTuThue.cs
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
--   Stt int NULL -- C# int?
--   MaCqtCap varchar(255) NULL -- C# string
--   KyHieu_MauSo varchar(255) NULL -- C# string
--   KyHieu_HoaDon varchar(255) NULL -- C# string
--   SoHoaDon varchar(255) NULL -- C# string
--   LoaiApDung int NULL -- C# int?
--   LyDo varchar(255) NULL -- C# string
--   DoanhNghiep_Mst varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   ThongBao_Id int NULL -- C# int?

CREATE TABLE `vs_thongbaohdtuthue` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Stt` int NULL,
    `MaCqtCap` varchar(255) NULL,
    `KyHieu_MauSo` varchar(255) NULL,
    `KyHieu_HoaDon` varchar(255) NULL,
    `SoHoaDon` varchar(255) NULL,
    `LoaiApDung` int NULL,
    `LyDo` varchar(255) NULL,
    `DoanhNghiep_Mst` varchar(255) NULL,
    `TenantId` int NULL,
    `ThongBao_Id` int NULL
);
