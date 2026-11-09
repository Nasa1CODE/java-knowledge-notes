-- Table: vs_saisot_dshoadon
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DanhSachSaiSotHoaDon.cs
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
--   ThongbaoId int NULL -- C# int?
--   Hoadon_Id int NULL -- C# int?
--   Ma_CoQuanThue varchar(255) NULL -- C# string
--   HoaDon_MauSo varchar(255) NULL -- C# string
--   HoaDon_So varchar(255) NULL -- C# string
--   HoaDon_KyHieu varchar(255) NULL -- C# string
--   HoaDon_Ngay datetime NOT NULL -- C# DateTime
--   HoaDon_TinhChat int NULL -- C# int?
--   TCT_TTTiepNhan int NULL -- C# int?
--   TenantId int NULL -- C# int?
--   DoanhNghiep_Mst varchar(255) NULL -- C# string
--   MaLoi varchar(255) NULL -- C# string
--   MoTaLoi varchar(255) NULL -- C# string
--   HuongDanXuLy varchar(255) NULL -- C# string
--   GhiChu varchar(255) NULL -- C# string

CREATE TABLE `vs_saisot_dshoadon` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ThongbaoId` int NULL,
    `Hoadon_Id` int NULL,
    `Ma_CoQuanThue` varchar(255) NULL,
    `HoaDon_MauSo` varchar(255) NULL,
    `HoaDon_So` varchar(255) NULL,
    `HoaDon_KyHieu` varchar(255) NULL,
    `HoaDon_Ngay` datetime NOT NULL,
    `HoaDon_TinhChat` int NULL,
    `TCT_TTTiepNhan` int NULL,
    `TenantId` int NULL,
    `DoanhNghiep_Mst` varchar(255) NULL,
    `MaLoi` varchar(255) NULL,
    `MoTaLoi` varchar(255) NULL,
    `HuongDanXuLy` varchar(255) NULL,
    `GhiChu` varchar(255) NULL
);
