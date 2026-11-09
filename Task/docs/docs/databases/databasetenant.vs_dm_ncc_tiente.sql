-- Table: vs_dm_ncc_tiente
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_TienTe.cs
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
--   TienTe_Ma varchar(255) NULL -- C# string
--   TienTe_Ten varchar(255) NULL -- C# string
--   TienTe_Xu varchar(255) NULL -- C# string
--   TienTe_TenTat varchar(255) NULL -- C# string
--   TienTe_TyLeChuyenDoi int NULL -- C# int?
--   TienTe_DocPhanCach varchar(255) NULL -- C# string
--   TienTe_KyHieuKetThuc varchar(255) NULL -- C# string
--   TienTe_BatDau datetime NULL -- C# DateTime?
--   TienTe_KetThuc datetime NULL -- C# DateTime?
--   TienTe_HieuLuc int NULL -- C# int?
--   TienTe_ThuTu_HienThi int NULL -- C# int?

CREATE TABLE `vs_dm_ncc_tiente` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TienTe_Ma` varchar(255) NULL,
    `TienTe_Ten` varchar(255) NULL,
    `TienTe_Xu` varchar(255) NULL,
    `TienTe_TenTat` varchar(255) NULL,
    `TienTe_TyLeChuyenDoi` int NULL,
    `TienTe_DocPhanCach` varchar(255) NULL,
    `TienTe_KyHieuKetThuc` varchar(255) NULL,
    `TienTe_BatDau` datetime NULL,
    `TienTe_KetThuc` datetime NULL,
    `TienTe_HieuLuc` int NULL,
    `TienTe_ThuTu_HienThi` int NULL
);
