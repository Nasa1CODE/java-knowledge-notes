-- Table: vs_dichvu_hopdong
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DichVu/DichVu_HopDong.cs
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
--   HopDong_Loai int NULL -- C# int?
--   HopDong_So varchar(255) NULL -- C# string
--   HopDong_Ngay datetime NULL -- C# DateTime?
--   DaiLy_Ma varchar(255) NULL -- C# string
--   HopDong_File varchar(255) NULL -- C# string
--   BenBan_NgayKy datetime NULL -- C# DateTime?
--   BenBan_ChungThu varchar(255) NULL -- C# string
--   BenMua_NgayKy datetime NULL -- C# DateTime?
--   BenMua_ChungThu varchar(255) NULL -- C# string
--   VerifyCert_BenBan_Loai varchar(255) NULL -- C# string
--   VerifyCert_BenBan_DaTa varchar(255) NULL -- C# string
--   VerifyCert_BenMua_Loai varchar(255) NULL -- C# string
--   VerifyCert_BenMua_DaTa varchar(255) NULL -- C# string
--   HoaDon_TrangThai int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   DichVu_loai int NULL -- C# int?
--   HopDong_TrangThai int NULL -- C# int?
--   LyDoTuChoi varchar(255) NULL -- C# string
--   Soluong int NULL -- C# int?

CREATE TABLE `vs_dichvu_hopdong` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DoanhNghiep_GoiDichVuId` int NOT NULL,
    `HopDong_Loai` int NULL,
    `HopDong_So` varchar(255) NULL,
    `HopDong_Ngay` datetime NULL,
    `DaiLy_Ma` varchar(255) NULL,
    `HopDong_File` varchar(255) NULL,
    `BenBan_NgayKy` datetime NULL,
    `BenBan_ChungThu` varchar(255) NULL,
    `BenMua_NgayKy` datetime NULL,
    `BenMua_ChungThu` varchar(255) NULL,
    `VerifyCert_BenBan_Loai` varchar(255) NULL,
    `VerifyCert_BenBan_DaTa` varchar(255) NULL,
    `VerifyCert_BenMua_Loai` varchar(255) NULL,
    `VerifyCert_BenMua_DaTa` varchar(255) NULL,
    `HoaDon_TrangThai` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `DichVu_loai` int NULL,
    `HopDong_TrangThai` int NULL,
    `LyDoTuChoi` varchar(255) NULL,
    `Soluong` int NULL
);
