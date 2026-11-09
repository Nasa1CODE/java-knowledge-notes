-- Table: vs_tbss_phanhoi_hoadon
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/PhanHoiSaiSotHoaDon.cs
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
--   TransLogId int NULL -- C# int?
--   TbssId int NULL -- C# int?
--   TCT_SoThongBao int NULL -- C# int?
--   TCT_NgayThongBao datetime NULL -- C# DateTime?
--   hoadon_ngaylap datetime NULL -- C# DateTime?
--   HoaDon_STT int NULL -- C# int?
--   HoaDon_MaCQT varchar(255) NULL -- C# string
--   HoaDon_MauSo varchar(255) NULL -- C# string
--   HoaDon_KyHieu varchar(255) NULL -- C# string
--   HoaDon_So varchar(255) NULL -- C# string
--   LoaiHoaDon_ApDung int NULL -- C# int?
--   HoaDon_TinhChat int NULL -- C# int?
--   HoaDon_TrangThaiTiepNhan int NULL -- C# int?
--   TenantId int NULL -- C# int?
--   DoanhNghiep_Mst varchar(255) NULL -- C# string

CREATE TABLE `vs_tbss_phanhoi_hoadon` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TransLogId` int NULL,
    `TbssId` int NULL,
    `TCT_SoThongBao` int NULL,
    `TCT_NgayThongBao` datetime NULL,
    `hoadon_ngaylap` datetime NULL,
    `HoaDon_STT` int NULL,
    `HoaDon_MaCQT` varchar(255) NULL,
    `HoaDon_MauSo` varchar(255) NULL,
    `HoaDon_KyHieu` varchar(255) NULL,
    `HoaDon_So` varchar(255) NULL,
    `LoaiHoaDon_ApDung` int NULL,
    `HoaDon_TinhChat` int NULL,
    `HoaDon_TrangThaiTiepNhan` int NULL,
    `TenantId` int NULL,
    `DoanhNghiep_Mst` varchar(255) NULL
);
