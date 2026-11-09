-- Table: vs_bc26ac_tonghop
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/BaoCao/Bc26ac_TongHop.cs
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
--   ThoiGian_Loai int NOT NULL -- C# int
--   ThoiGian_Thang int NULL -- C# int?
--   ThoiGian_Quy int NULL -- C# int?
--   ThoiGian_Nam int NOT NULL -- C# int
--   BaoCao_MauSo varchar(255) NULL -- C# string
--   BaoCao_DonViTinh varchar(255) NULL -- C# string
--   DoanhNghiep_Ten varchar(255) NULL -- C# string
--   DoanhNghiep_DiaChi varchar(255) NULL -- C# string
--   BaoCao_NgayLap datetime NOT NULL -- C# DateTime
--   BaoCao_NguoiLap varchar(255) NULL -- C# string
--   DoanhNghiep_NguoiDaiDien varchar(255) NULL -- C# string
--   BaoCao_TrangThai int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_bc26ac_tonghop` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ThoiGian_Loai` int NOT NULL,
    `ThoiGian_Thang` int NULL,
    `ThoiGian_Quy` int NULL,
    `ThoiGian_Nam` int NOT NULL,
    `BaoCao_MauSo` varchar(255) NULL,
    `BaoCao_DonViTinh` varchar(255) NULL,
    `DoanhNghiep_Ten` varchar(255) NULL,
    `DoanhNghiep_DiaChi` varchar(255) NULL,
    `BaoCao_NgayLap` datetime NOT NULL,
    `BaoCao_NguoiLap` varchar(255) NULL,
    `DoanhNghiep_NguoiDaiDien` varchar(255) NULL,
    `BaoCao_TrangThai` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
