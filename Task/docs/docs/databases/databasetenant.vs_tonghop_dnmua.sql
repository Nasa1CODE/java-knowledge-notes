-- Table: vs_tonghop_dnmua
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/TraCuu/TongHop_DnMua.cs
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
--   DNMua_Id int NOT NULL -- C# int
--   TongHop_Id int NOT NULL -- C# int
--   TenantId int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   User_Id int NOT NULL -- C# int

CREATE TABLE `vs_tonghop_dnmua` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DNMua_Id` int NOT NULL,
    `TongHop_Id` int NOT NULL,
    `TenantId` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `User_Id` int NOT NULL
);
