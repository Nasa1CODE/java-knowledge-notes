-- Table: abppermissions
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/QuanLy/QuanLy_Permission.cs
--
-- Fields inferred from C# entity properties. Verify exact SQL types, lengths, indexes, and constraints against real migrations/schema before deployment.
-- Fields:
--   Id int NOT NULL -- inherited Entity key
--   CreationTime datetime NOT NULL -- inherited audit field
--   CreatorUserId bigint NULL -- inherited audit field
--   LastModificationTime datetime NULL -- inherited audit field
--   LastModifierUserId bigint NULL -- inherited audit field
--   Discriminator varchar(255) NULL -- C# string
--   IsGranted bit NOT NULL -- C# bool
--   Name varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   RoleId int NULL -- C# int?
--   UserId int NULL -- C# int?

CREATE TABLE `abppermissions` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `Discriminator` varchar(255) NULL,
    `IsGranted` bit NOT NULL,
    `Name` varchar(255) NULL,
    `TenantId` int NULL,
    `RoleId` int NULL,
    `UserId` int NULL
);
