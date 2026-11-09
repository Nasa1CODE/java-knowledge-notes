-- Table: abproles
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/QuanLy/QuanLy_VaiTro.cs
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
--   ConcurrencyStamp varchar(255) NULL -- C# string
--   DisplayName varchar(255) NULL -- C# string
--   IsDefault bit NOT NULL -- C# bool
--   IsStatic bit NOT NULL -- C# bool
--   Name varchar(255) NULL -- C# string
--   NormalizedName varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `abproles` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ConcurrencyStamp` varchar(255) NULL,
    `DisplayName` varchar(255) NULL,
    `IsDefault` bit NOT NULL,
    `IsStatic` bit NOT NULL,
    `Name` varchar(255) NULL,
    `NormalizedName` varchar(255) NULL,
    `TenantId` int NULL
);
