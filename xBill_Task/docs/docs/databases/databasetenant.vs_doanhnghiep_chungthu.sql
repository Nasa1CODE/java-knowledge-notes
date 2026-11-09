-- Table: vs_doanhnghiep_chungthu
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DoanhNghiep/DoanhNghiep_ChungThu.cs
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
--   ChungThu_Serial varchar(255) NULL -- C# string
--   ChungThu_SoHuu varchar(255) NULL -- C# string
--   ChungThu_Ncc varchar(255) NULL -- C# string
--   ChungThu_BatDau datetime NULL -- C# DateTime?
--   ChungThu_KetThuc datetime NULL -- C# DateTime?
--   ChungThu_Base64 varchar(255) NULL -- C# string
--   ChungThu_HieuLuc bit NOT NULL -- C# bool
--   ChungThu_HinhThuc int NOT NULL -- C# int
--   Service_Link varchar(255) NULL -- C# string
--   Service_TaiKhoan varchar(255) NULL -- C# string
--   Service_MatKhau varchar(255) NULL -- C# string
--   Service_Pid varchar(255) NULL -- C# string
--   Service_Secret varchar(255) NULL -- C# string
--   DoanhNghiep_Mst varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   Hsm_Ip varchar(255) NULL -- C# string
--   Hsm_Slot varchar(255) NULL -- C# string
--   Hsm_Object_Enduser varchar(255) NULL -- C# string
--   Hsm_Object_SubCa varchar(255) NULL -- C# string
--   Hsm_Object_RootCa varchar(255) NULL -- C# string
--   Hsm_Object_Key varchar(255) NULL -- C# string
--   Hsm_MatKhau varchar(255) NULL -- C# string
--   Hsm_HieuLuc bit NOT NULL -- C# bool
--   ChungThu_DangKy bit NULL -- C# bool?

CREATE TABLE `vs_doanhnghiep_chungthu` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ChungThu_Serial` varchar(255) NULL,
    `ChungThu_SoHuu` varchar(255) NULL,
    `ChungThu_Ncc` varchar(255) NULL,
    `ChungThu_BatDau` datetime NULL,
    `ChungThu_KetThuc` datetime NULL,
    `ChungThu_Base64` varchar(255) NULL,
    `ChungThu_HieuLuc` bit NOT NULL,
    `ChungThu_HinhThuc` int NOT NULL,
    `Service_Link` varchar(255) NULL,
    `Service_TaiKhoan` varchar(255) NULL,
    `Service_MatKhau` varchar(255) NULL,
    `Service_Pid` varchar(255) NULL,
    `Service_Secret` varchar(255) NULL,
    `DoanhNghiep_Mst` varchar(255) NULL,
    `TenantId` int NULL,
    `Hsm_Ip` varchar(255) NULL,
    `Hsm_Slot` varchar(255) NULL,
    `Hsm_Object_Enduser` varchar(255) NULL,
    `Hsm_Object_SubCa` varchar(255) NULL,
    `Hsm_Object_RootCa` varchar(255) NULL,
    `Hsm_Object_Key` varchar(255) NULL,
    `Hsm_MatKhau` varchar(255) NULL,
    `Hsm_HieuLuc` bit NOT NULL,
    `ChungThu_DangKy` bit NULL
);
