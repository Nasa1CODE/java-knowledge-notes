-- Table: vs_daily
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DaiLy/ThongTinDaiLy.cs
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
--   DaiLy_Ma varchar(255) NULL -- C# string
--   DaiLy_Ten varchar(255) NULL -- C# string
--   DaiLy_Loai int NULL -- C# int?
--   TinhThanh_Ma varchar(255) NULL -- C# string
--   TinhThanh_Ten varchar(255) NULL -- C# string
--   DaiLy_DiaChi varchar(255) NULL -- C# string
--   DaiLy_NguoiQuanLy varchar(255) NULL -- C# string
--   DaiLy_SDT varchar(255) NULL -- C# string
--   DaiLy_Email varchar(255) NULL -- C# string
--   DaiLy_HieuLuc int NULL -- C# int?
--   DaiLy_BatDau datetime NULL -- C# DateTime?
--   DaiLy_KetThuc datetime NULL -- C# DateTime?
--   DaiLy_Logo varchar(255) NULL -- C# string
--   DaiLyCha_Id int NULL -- C# int?

CREATE TABLE `vs_daily` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DaiLy_Ma` varchar(255) NULL,
    `DaiLy_Ten` varchar(255) NULL,
    `DaiLy_Loai` int NULL,
    `TinhThanh_Ma` varchar(255) NULL,
    `TinhThanh_Ten` varchar(255) NULL,
    `DaiLy_DiaChi` varchar(255) NULL,
    `DaiLy_NguoiQuanLy` varchar(255) NULL,
    `DaiLy_SDT` varchar(255) NULL,
    `DaiLy_Email` varchar(255) NULL,
    `DaiLy_HieuLuc` int NULL,
    `DaiLy_BatDau` datetime NULL,
    `DaiLy_KetThuc` datetime NULL,
    `DaiLy_Logo` varchar(255) NULL,
    `DaiLyCha_Id` int NULL
);
