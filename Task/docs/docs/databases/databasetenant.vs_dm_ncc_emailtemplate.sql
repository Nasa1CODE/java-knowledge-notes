-- Table: vs_dm_ncc_emailtemplate
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_EmailTemplate.cs
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
--   Tem_Loai int NOT NULL -- C# int
--   Tem_Ten varchar(255) NULL -- C# string
--   Tem_TieuDe varchar(255) NULL -- C# string
--   Tem_NoiDung varchar(255) NULL -- C# string
--   Tem_HieuLuc bit NOT NULL -- C# bool
--   Tem_BatDau datetime NULL -- C# DateTime?
--   Tem_KetThuc datetime NULL -- C# DateTime?
--   DaiLy_Id int NULL -- C# int?

CREATE TABLE `vs_dm_ncc_emailtemplate` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Tem_Loai` int NOT NULL,
    `Tem_Ten` varchar(255) NULL,
    `Tem_TieuDe` varchar(255) NULL,
    `Tem_NoiDung` varchar(255) NULL,
    `Tem_HieuLuc` bit NOT NULL,
    `Tem_BatDau` datetime NULL,
    `Tem_KetThuc` datetime NULL,
    `DaiLy_Id` int NULL
);
