-- Table: vs_registertax_ncc_dichvu
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/RegisterTax_NCC_DichVu.cs
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
--   TenantId int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   STT int NULL -- C# int?
--   Ten varchar(255) NULL -- C# string
--   Mst varchar(255) NULL -- C# string
--   TuNgay datetime NULL -- C# DateTime?
--   DenNgay datetime NULL -- C# DateTime?
--   GhiChu varchar(255) NULL -- C# string
--   Registertax_Id int NULL -- C# int?

CREATE TABLE `vs_registertax_ncc_dichvu` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TenantId` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `STT` int NULL,
    `Ten` varchar(255) NULL,
    `Mst` varchar(255) NULL,
    `TuNgay` datetime NULL,
    `DenNgay` datetime NULL,
    `GhiChu` varchar(255) NULL,
    `Registertax_Id` int NULL
);
