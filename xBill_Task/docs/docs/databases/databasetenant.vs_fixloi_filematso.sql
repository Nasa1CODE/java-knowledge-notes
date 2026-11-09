-- Table: vs_fixloi_filematso
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/TraCuu/FixLoiMatSoFile.cs
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
--   TongHop_Id int NOT NULL -- C# int
--   Status int NOT NULL -- C# int
--   FilePath varchar(255) NULL -- C# string
--   DoanhNghiep_Mst varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   NgayKyHd datetime NULL -- C# DateTime?

CREATE TABLE `vs_fixloi_filematso` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TongHop_Id` int NOT NULL,
    `Status` int NOT NULL,
    `FilePath` varchar(255) NULL,
    `DoanhNghiep_Mst` varchar(255) NULL,
    `TenantId` int NULL,
    `NgayKyHd` datetime NULL
);
