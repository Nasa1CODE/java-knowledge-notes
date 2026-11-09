-- Table: vs_dm_ncc_quanhuyen
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_QuanHuyen.cs
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
--   QuanHuyen_Ma varchar(255) NULL -- C# string
--   QuanHuyen_Ten varchar(255) NULL -- C# string
--   QuanHuyen_TenTat varchar(255) NULL -- C# string
--   QuanHuyen_BatDau datetime NULL -- C# DateTime?
--   QuanHuyen_KetThuc datetime NULL -- C# DateTime?
--   QuanHuyen_HieuLuc int NULL -- C# int?
--   TinhThanh_Ma varchar(255) NULL -- C# string

CREATE TABLE `vs_dm_ncc_quanhuyen` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `QuanHuyen_Ma` varchar(255) NULL,
    `QuanHuyen_Ten` varchar(255) NULL,
    `QuanHuyen_TenTat` varchar(255) NULL,
    `QuanHuyen_BatDau` datetime NULL,
    `QuanHuyen_KetThuc` datetime NULL,
    `QuanHuyen_HieuLuc` int NULL,
    `TinhThanh_Ma` varchar(255) NULL
);
