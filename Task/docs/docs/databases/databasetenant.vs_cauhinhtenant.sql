-- Table: vs_cauhinhtenant
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/QuanLy/CauHinh_Tenant.cs
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
--   CauHinh_Ma varchar(255) NULL -- C# string
--   CauHinh_GiaTri varchar(255) NULL -- C# string
--   CauHinh_MoTa varchar(255) NULL -- C# string
--   DaiLy_Id int NULL -- C# int?
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_cauhinhtenant` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `CauHinh_Ma` varchar(255) NULL,
    `CauHinh_GiaTri` varchar(255) NULL,
    `CauHinh_MoTa` varchar(255) NULL,
    `DaiLy_Id` int NULL,
    `TenantId` int NULL
);
