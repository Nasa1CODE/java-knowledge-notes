-- Table: vs_notification_users
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoTro/ThongBao_Log.cs
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
--   TrangThai_Doc bit NULL -- C# bool?
--   DaiLy_Id int NULL -- C# int?
--   TenantId int NULL -- C# int?
--   NotiFy_UserId int NULL -- C# int?
--   ThongBao_Id int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string

CREATE TABLE `vs_notification_users` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TrangThai_Doc` bit NULL,
    `DaiLy_Id` int NULL,
    `TenantId` int NULL,
    `NotiFy_UserId` int NULL,
    `ThongBao_Id` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL
);
