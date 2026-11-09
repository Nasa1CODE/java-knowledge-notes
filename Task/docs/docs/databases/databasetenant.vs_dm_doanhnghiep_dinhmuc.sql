-- Table: vs_dm_doanhnghiep_dinhmuc
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMDoanhNghiep/DMDoanhNghiep_DinhMuc.cs
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
--   DinhMuc_Ma varchar(255) NULL -- C# string
--   DinhMuc_Ten varchar(255) NULL -- C# string
--   Bo_ChiSo varchar(255) NULL -- C# string
--   TuSo decimal(18,2) NULL -- C# decimal?
--   DenSo decimal(18,2) NULL -- C# decimal?
--   DonGia decimal(18,2) NOT NULL -- C# decimal
--   ThueSuat decimal(18,2) NULL -- C# decimal?
--   MaThueSuat int NULL -- C# int?
--   HieuLuc int NULL -- C# int?
--   Ngay_BatDau datetime NULL -- C# DateTime?
--   Ngay_KetThuc datetime NULL -- C# DateTime?
--   GhiChu varchar(255) NULL -- C# string
--   TenThueSuat varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string

CREATE TABLE `vs_dm_doanhnghiep_dinhmuc` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DinhMuc_Ma` varchar(255) NULL,
    `DinhMuc_Ten` varchar(255) NULL,
    `Bo_ChiSo` varchar(255) NULL,
    `TuSo` decimal(18,2) NULL,
    `DenSo` decimal(18,2) NULL,
    `DonGia` decimal(18,2) NOT NULL,
    `ThueSuat` decimal(18,2) NULL,
    `MaThueSuat` int NULL,
    `HieuLuc` int NULL,
    `Ngay_BatDau` datetime NULL,
    `Ngay_KetThuc` datetime NULL,
    `GhiChu` varchar(255) NULL,
    `TenThueSuat` varchar(255) NULL,
    `TenantId` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL
);
