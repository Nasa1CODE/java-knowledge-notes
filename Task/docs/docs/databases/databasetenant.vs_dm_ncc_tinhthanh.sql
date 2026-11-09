-- Table: vs_dm_ncc_tinhthanh
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_TinhThanh.cs
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
--   TinhThanh_Ma varchar(255) NULL -- C# string
--   TinhThanh_Ten varchar(255) NULL -- C# string
--   TinhThanh_TenTat varchar(255) NULL -- C# string
--   TinhThanh_BatDau datetime NULL -- C# DateTime?
--   TinhThanh_KetThuc datetime NULL -- C# DateTime?
--   TinhThanh_HieuLuc int NULL -- C# int?

CREATE TABLE `vs_dm_ncc_tinhthanh` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TinhThanh_Ma` varchar(255) NULL,
    `TinhThanh_Ten` varchar(255) NULL,
    `TinhThanh_TenTat` varchar(255) NULL,
    `TinhThanh_BatDau` datetime NULL,
    `TinhThanh_KetThuc` datetime NULL,
    `TinhThanh_HieuLuc` int NULL
);
