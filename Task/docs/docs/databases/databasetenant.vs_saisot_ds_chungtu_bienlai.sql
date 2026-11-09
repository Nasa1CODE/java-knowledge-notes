-- Table: vs_saisot_ds_chungtu_bienlai
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/ChungTu/DsSaiSot_ChungTu_BienLai.cs
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
--   ChungTu_Id int NULL -- C# int?
--   Mau_MauSo varchar(255) NULL -- C# string
--   Mau_So varchar(255) NULL -- C# string
--   Mau_KyHieu varchar(255) NULL -- C# string
--   NgayLap datetime NULL -- C# DateTime?
--   TinhChat int NULL -- C# int?
--   TCT_TTTiepNhan int NULL -- C# int?
--   TenantId int NULL -- C# int?
--   MaLoi varchar(255) NULL -- C# string
--   MoTaLoi varchar(255) NULL -- C# string
--   HuongDanXuLy varchar(255) NULL -- C# string
--   GhiChu varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   LoaiDanhSach int NULL -- C# int?

CREATE TABLE `vs_saisot_ds_chungtu_bienlai` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ThongbaoId` int NULL,
    `ChungTu_Id` int NULL,
    `Mau_MauSo` varchar(255) NULL,
    `Mau_So` varchar(255) NULL,
    `Mau_KyHieu` varchar(255) NULL,
    `NgayLap` datetime NULL,
    `TinhChat` int NULL,
    `TCT_TTTiepNhan` int NULL,
    `TenantId` int NULL,
    `MaLoi` varchar(255) NULL,
    `MoTaLoi` varchar(255) NULL,
    `HuongDanXuLy` varchar(255) NULL,
    `GhiChu` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `LoaiDanhSach` int NULL
);
