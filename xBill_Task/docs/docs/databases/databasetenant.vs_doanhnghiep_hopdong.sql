-- Table: vs_doanhnghiep_hopdong
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DoanhNghiep/DoanhNghiep_HopDong.cs
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
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   Ngay_HopDong datetime NULL -- C# DateTime?
--   Ten_DoanhNghiep varchar(255) NULL -- C# string
--   So_HopDong varchar(255) NULL -- C# string
--   Link_Ky varchar(255) NULL -- C# string
--   TrangThai int NULL -- C# int?
--   Ngay_Ky datetime NULL -- C# DateTime?
--   Nguoi_Ky bigint NULL -- C# long?

CREATE TABLE `vs_doanhnghiep_hopdong` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `Ngay_HopDong` datetime NULL,
    `Ten_DoanhNghiep` varchar(255) NULL,
    `So_HopDong` varchar(255) NULL,
    `Link_Ky` varchar(255) NULL,
    `TrangThai` int NULL,
    `Ngay_Ky` datetime NULL,
    `Nguoi_Ky` bigint NULL
);
