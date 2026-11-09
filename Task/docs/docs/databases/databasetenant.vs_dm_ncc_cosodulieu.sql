-- Table: vs_dm_ncc_cosodulieu
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_CoSoDuLieu.cs
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
--   Csdl_Ma varchar(255) NULL -- C# string
--   Csdl_KetNoi varchar(255) NULL -- C# string
--   Csdl_GhiChu varchar(255) NULL -- C# string
--   Csdl_TrangThai int NOT NULL -- C# int
--   Tenant_Id int NULL -- C# int?

CREATE TABLE `vs_dm_ncc_cosodulieu` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Csdl_Ma` varchar(255) NULL,
    `Csdl_KetNoi` varchar(255) NULL,
    `Csdl_GhiChu` varchar(255) NULL,
    `Csdl_TrangThai` int NOT NULL,
    `Tenant_Id` int NULL
);
