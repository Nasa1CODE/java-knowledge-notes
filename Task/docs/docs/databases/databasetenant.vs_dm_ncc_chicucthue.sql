-- Table: vs_dm_ncc_chicucthue
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_ChiCucThue.cs
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
--   CCT_Ma varchar(255) NULL -- C# string
--   TinhThanh_Ma varchar(255) NULL -- C# string
--   CCT_Ten varchar(255) NULL -- C# string
--   CCT_TenTat varchar(255) NULL -- C# string
--   CCT_BatDau datetime NULL -- C# DateTime?
--   CCT_KetThuc datetime NULL -- C# DateTime?
--   CCT_HieuLuc int NULL -- C# int?

CREATE TABLE `vs_dm_ncc_chicucthue` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `CCT_Ma` varchar(255) NULL,
    `TinhThanh_Ma` varchar(255) NULL,
    `CCT_Ten` varchar(255) NULL,
    `CCT_TenTat` varchar(255) NULL,
    `CCT_BatDau` datetime NULL,
    `CCT_KetThuc` datetime NULL,
    `CCT_HieuLuc` int NULL
);
