-- Table: abptenants
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/QuanLy/QuanLy_Tenant.cs
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
--   ConnectionString varchar(255) NULL -- C# string
--   CustomCssId varchar(255) NULL -- C# string
--   EditionId int NULL -- C# int?
--   IsActive bit NOT NULL -- C# bool
--   IsInTrialPeriod bit NOT NULL -- C# bool
--   LogoFileType varchar(255) NULL -- C# string
--   LogoId varchar(255) NULL -- C# string
--   Name varchar(255) NULL -- C# string
--   SubscriptionEndDateUtc datetime NULL -- C# DateTime?
--   TenancyName varchar(255) NULL -- C# string

CREATE TABLE `abptenants` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ConnectionString` varchar(255) NULL,
    `CustomCssId` varchar(255) NULL,
    `EditionId` int NULL,
    `IsActive` bit NOT NULL,
    `IsInTrialPeriod` bit NOT NULL,
    `LogoFileType` varchar(255) NULL,
    `LogoId` varchar(255) NULL,
    `Name` varchar(255) NULL,
    `SubscriptionEndDateUtc` datetime NULL,
    `TenancyName` varchar(255) NULL
);
