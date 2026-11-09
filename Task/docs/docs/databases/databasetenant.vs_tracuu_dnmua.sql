-- Table: vs_tracuu_dnmua
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/TraCuu/TraCuu_DnMua.cs
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
--   UserName varchar(255) NULL -- C# string
--   PassWord varchar(255) NULL -- C# string
--   User_Id int NOT NULL -- C# int

CREATE TABLE `vs_tracuu_dnmua` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TenantId` int NULL,
    `UserName` varchar(255) NULL,
    `PassWord` varchar(255) NULL,
    `User_Id` int NOT NULL
);
