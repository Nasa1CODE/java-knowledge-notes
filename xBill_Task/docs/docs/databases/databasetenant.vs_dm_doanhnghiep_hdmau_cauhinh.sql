-- Table: vs_dm_doanhnghiep_hdmau_cauhinh
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMDoanhNghiep/DM_DoanhNghiep_HDMau_CauHinh.cs
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
--   Mau_MaDacThu varchar(255) NULL -- C# string
--   DoanhNghiep_HDMau_Id int NULL -- C# int?
--   NhaCungCap_HDMau_Id int NULL -- C# int?
--   Mau_LoaiBien int NULL -- C# int?
--   Mau_BienSo varchar(255) NULL -- C# string
--   Mau_TenHienThi varchar(255) NULL -- C# string
--   Mau_KieuDuLieu int NULL -- C# int?
--   Mau_MacDinh varchar(255) NULL -- C# string
--   Mau_DoRongHienThi int NULL -- C# int?
--   Mau_TruyenDuLieuXML varchar(255) NULL -- C# string
--   Mau_HieuLuc int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_dm_doanhnghiep_hdmau_cauhinh` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Mau_MaDacThu` varchar(255) NULL,
    `DoanhNghiep_HDMau_Id` int NULL,
    `NhaCungCap_HDMau_Id` int NULL,
    `Mau_LoaiBien` int NULL,
    `Mau_BienSo` varchar(255) NULL,
    `Mau_TenHienThi` varchar(255) NULL,
    `Mau_KieuDuLieu` int NULL,
    `Mau_MacDinh` varchar(255) NULL,
    `Mau_DoRongHienThi` int NULL,
    `Mau_TruyenDuLieuXML` varchar(255) NULL,
    `Mau_HieuLuc` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
