-- Table: vs_thongbao
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoTro/ThongBao.cs
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
--   ThongBao_Loai int NOT NULL -- C# int
--   ThongBao_TenantId int NULL -- C# int?
--   ThongBao_DoanhNghiep_MST varchar(255) NULL -- C# string
--   ThongBao_DoiTuong varchar(255) NULL -- C# string
--   ThongBao_TieuDe varchar(255) NULL -- C# string
--   ThongBao_ThongTin varchar(255) NULL -- C# string
--   HieuLuc bit NULL -- C# bool?
--   HieuLuc_BatDau datetime NULL -- C# DateTime?
--   HieuLuc_KetThuc datetime NULL -- C# DateTime?
--   TrangThai_Doc bit NULL -- C# bool?
--   DaiLy_Id int NULL -- C# int?
--   ThongBao_MauLoai varchar(255) NULL -- C# string

CREATE TABLE `vs_thongbao` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ThongBao_Loai` int NOT NULL,
    `ThongBao_TenantId` int NULL,
    `ThongBao_DoanhNghiep_MST` varchar(255) NULL,
    `ThongBao_DoiTuong` varchar(255) NULL,
    `ThongBao_TieuDe` varchar(255) NULL,
    `ThongBao_ThongTin` varchar(255) NULL,
    `HieuLuc` bit NULL,
    `HieuLuc_BatDau` datetime NULL,
    `HieuLuc_KetThuc` datetime NULL,
    `TrangThai_Doc` bit NULL,
    `DaiLy_Id` int NULL,
    `ThongBao_MauLoai` varchar(255) NULL
);
