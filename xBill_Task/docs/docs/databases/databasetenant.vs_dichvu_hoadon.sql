-- Table: vs_dichvu_hoadon
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DichVu/DichVu_HoaDon.cs
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
--   DoanhNghiep_GoiDichVuId int NOT NULL -- C# int
--   DichVu_HopDong_So varchar(255) NULL -- C# string
--   HoaDon_NgayKy datetime NULL -- C# DateTime?
--   HoaDon_DinhDang int NOT NULL -- C# int
--   HoaDon_Loai int NOT NULL -- C# int
--   HoaDon_FileKhac varchar(255) NULL -- C# string
--   HoaDon_Xlst varchar(255) NULL -- C# string
--   HoaDon_Xml varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_dichvu_hoadon` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DoanhNghiep_GoiDichVuId` int NOT NULL,
    `DichVu_HopDong_So` varchar(255) NULL,
    `HoaDon_NgayKy` datetime NULL,
    `HoaDon_DinhDang` int NOT NULL,
    `HoaDon_Loai` int NOT NULL,
    `HoaDon_FileKhac` varchar(255) NULL,
    `HoaDon_Xlst` varchar(255) NULL,
    `HoaDon_Xml` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
