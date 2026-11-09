-- Table: vs_hdpos_chitiet
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_Pos_ChiTiet.cs
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
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   HoaDon_Id int NULL -- C# int?
--   QuanLy_Id int NULL -- C# int?
--   HoaDon_So varchar(255) NULL -- C# string
--   HoaDon_KyHieu varchar(255) NULL -- C# string
--   HoaDon_KhMauSo varchar(255) NULL -- C# string
--   TrangThai int NULL -- C# int?
--   MaLoi varchar(255) NULL -- C# string
--   MoTaLoi varchar(255) NULL -- C# string
--   HuongDanXuLy varchar(255) NULL -- C# string

CREATE TABLE `vs_hdpos_chitiet` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `HoaDon_Id` int NULL,
    `QuanLy_Id` int NULL,
    `HoaDon_So` varchar(255) NULL,
    `HoaDon_KyHieu` varchar(255) NULL,
    `HoaDon_KhMauSo` varchar(255) NULL,
    `TrangThai` int NULL,
    `MaLoi` varchar(255) NULL,
    `MoTaLoi` varchar(255) NULL,
    `HuongDanXuLy` varchar(255) NULL
);
