-- Table: vs_dm_ncc_mauhoadon
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_HoaDonMau.cs
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
--   Hdmau_Ma varchar(255) NULL -- C# string
--   Hdmau_Ten varchar(255) NULL -- C# string
--   Hdmau_Xslt varchar(255) NULL -- C# string
--   Hdmau_Xml varchar(255) NULL -- C# string
--   Hdmau_Thumb varchar(255) NULL -- C# string
--   Loaihoadon_MauSo varchar(255) NULL -- C# string
--   Loaihoadon_Ten varchar(255) NULL -- C# string
--   Loai_HD_DacThu varchar(255) NULL -- C# string
--   DaiLy_Id int NULL -- C# int?
--   Hdmau_Version int NULL -- C# int?
--   QuanLy_Xsl_Version varchar(255) NULL -- C# string
--   MaxLength_Line int NULL -- C# int?
--   MaxRow_Page int NULL -- C# int?
--   MaxRow_FullPage int NULL -- C# int?
--   Hdmau_ThongTu varchar(255) NULL -- C# string

CREATE TABLE `vs_dm_ncc_mauhoadon` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Hdmau_Ma` varchar(255) NULL,
    `Hdmau_Ten` varchar(255) NULL,
    `Hdmau_Xslt` varchar(255) NULL,
    `Hdmau_Xml` varchar(255) NULL,
    `Hdmau_Thumb` varchar(255) NULL,
    `Loaihoadon_MauSo` varchar(255) NULL,
    `Loaihoadon_Ten` varchar(255) NULL,
    `Loai_HD_DacThu` varchar(255) NULL,
    `DaiLy_Id` int NULL,
    `Hdmau_Version` int NULL,
    `QuanLy_Xsl_Version` varchar(255) NULL,
    `MaxLength_Line` int NULL,
    `MaxRow_Page` int NULL,
    `MaxRow_FullPage` int NULL,
    `Hdmau_ThongTu` varchar(255) NULL
);
