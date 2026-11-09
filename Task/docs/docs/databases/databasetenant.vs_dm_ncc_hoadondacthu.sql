-- Table: vs_dm_ncc_hoadondacthu
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_HoaDonDacThu.cs
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
--   Loai_HD_DacThu_Ma varchar(255) NULL -- C# string
--   Loai_HD_DacThu_Ten varchar(255) NULL -- C# string
--   LoaiHoaDon_MoTa varchar(255) NULL -- C# string
--   LoaiHoaDon_HieuLuc int NULL -- C# int?
--   LoaiHoaDon_BatDau datetime NULL -- C# DateTime?
--   LoaiHoaDon_KetThuc datetime NULL -- C# DateTime?

CREATE TABLE `vs_dm_ncc_hoadondacthu` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Loai_HD_DacThu_Ma` varchar(255) NULL,
    `Loai_HD_DacThu_Ten` varchar(255) NULL,
    `LoaiHoaDon_MoTa` varchar(255) NULL,
    `LoaiHoaDon_HieuLuc` int NULL,
    `LoaiHoaDon_BatDau` datetime NULL,
    `LoaiHoaDon_KetThuc` datetime NULL
);
