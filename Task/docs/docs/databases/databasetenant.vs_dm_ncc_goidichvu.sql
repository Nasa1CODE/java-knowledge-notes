-- Table: vs_dm_ncc_goidichvu
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_GoiDichVu.cs
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
--   DichVu_Loai int NOT NULL -- C# int
--   DichVu_Ma varchar(255) NULL -- C# string
--   DichVu_Ten varchar(255) NULL -- C# string
--   DichVu_SoLuong int NOT NULL -- C# int
--   DichVu_ThoiGian_SuDung int NOT NULL -- C# int
--   DichVu_ThoiGian_LuuTru int NOT NULL -- C# int
--   DichVu_Gia int NOT NULL -- C# int
--   DichVu_BatDau datetime NULL -- C# DateTime?
--   DichVu_KetThuc datetime NULL -- C# DateTime?
--   DichVu_HieuLuc bit NOT NULL -- C# bool
--   DaiLy_Id int NULL -- C# int?

CREATE TABLE `vs_dm_ncc_goidichvu` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DichVu_Loai` int NOT NULL,
    `DichVu_Ma` varchar(255) NULL,
    `DichVu_Ten` varchar(255) NULL,
    `DichVu_SoLuong` int NOT NULL,
    `DichVu_ThoiGian_SuDung` int NOT NULL,
    `DichVu_ThoiGian_LuuTru` int NOT NULL,
    `DichVu_Gia` int NOT NULL,
    `DichVu_BatDau` datetime NULL,
    `DichVu_KetThuc` datetime NULL,
    `DichVu_HieuLuc` bit NOT NULL,
    `DaiLy_Id` int NULL
);
