-- Table: vs_dm_ncc_thuesuat
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_ThueSuat.cs
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
--   ThueSuat_Ma int NOT NULL -- C# int
--   ThueSuat_Ten varchar(255) NULL -- C# string
--   ThueSuat_GiaTri decimal(18,2) NOT NULL -- C# decimal
--   ThueSuat_HieuLuc bit NOT NULL -- C# bool
--   ThueSuat_BatDau datetime NULL -- C# DateTime?
--   ThueSuat_KetThuc datetime NULL -- C# DateTime?
--   ThueSuat_Key varchar(255) NULL -- C# string
--   ThueSuat_MaAPI varchar(255) NULL -- C# string

CREATE TABLE `vs_dm_ncc_thuesuat` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ThueSuat_Ma` int NOT NULL,
    `ThueSuat_Ten` varchar(255) NULL,
    `ThueSuat_GiaTri` decimal(18,2) NOT NULL,
    `ThueSuat_HieuLuc` bit NOT NULL,
    `ThueSuat_BatDau` datetime NULL,
    `ThueSuat_KetThuc` datetime NULL,
    `ThueSuat_Key` varchar(255) NULL,
    `ThueSuat_MaAPI` varchar(255) NULL
);
