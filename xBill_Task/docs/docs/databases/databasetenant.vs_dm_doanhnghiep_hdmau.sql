-- Table: vs_dm_doanhnghiep_hdmau
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMDoanhNghiep/DMDoanhNghiep_HDMau.cs
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
--   HDMau_Ma varchar(255) NULL -- C# string
--   HDMau_Ten varchar(255) NULL -- C# string
--   LoaiHoaDon_MauSo varchar(255) NULL -- C# string
--   LoaiHoaDon_Ten varchar(255) NULL -- C# string
--   Loai_HD_DacThu varchar(255) NULL -- C# string
--   NCC_HDMau_Ma varchar(255) NULL -- C# string
--   HDMau_XSLT varchar(255) NULL -- C# string
--   HDMau_XML varchar(255) NULL -- C# string
--   HDMau_Trangthai int NOT NULL -- C# int
--   HDMau_NgayHieuLuc datetime NULL -- C# DateTime?
--   HDMau_NgayHetHieuLuc datetime NULL -- C# DateTime?
--   DaiLy_Id int NULL -- C# int?
--   TenantId int NULL -- C# int?
--   HDMau_KyHieu varchar(255) NULL -- C# string
--   HDMau_MauSo varchar(255) NULL -- C# string
--   HDMau_Version int NULL -- C# int?
--   TrangThai_Chot int NULL -- C# int?
--   LyDoTuChoi varchar(255) NULL -- C# string
--   QuanLy_Xsl_Version varchar(255) NULL -- C# string
--   MaxLength_Line int NULL -- C# int?
--   MaxRow_Page int NULL -- C# int?
--   MaxRow_FullPage int NULL -- C# int?
--   HDMau_IsLayoutLandscape bit NULL -- C# bool?
--   HDMau_ThongTu varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   DoanhNghiep_Ten varchar(255) NULL -- C# string
--   DoanhNghiep_DiaChi varchar(255) NULL -- C# string
--   DoanhNghiep_SDT varchar(255) NULL -- C# string
--   DoanhNghiep_Email varchar(255) NULL -- C# string
--   DoanhNghiep_Fax varchar(255) NULL -- C# string
--   DoanhNghiep_Website varchar(255) NULL -- C# string
--   DoanhNghiep_TaiKhoan varchar(255) NULL -- C# string
--   DoanhNghiep_NganHang varchar(255) NULL -- C# string

CREATE TABLE `vs_dm_doanhnghiep_hdmau` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `HDMau_Ma` varchar(255) NULL,
    `HDMau_Ten` varchar(255) NULL,
    `LoaiHoaDon_MauSo` varchar(255) NULL,
    `LoaiHoaDon_Ten` varchar(255) NULL,
    `Loai_HD_DacThu` varchar(255) NULL,
    `NCC_HDMau_Ma` varchar(255) NULL,
    `HDMau_XSLT` varchar(255) NULL,
    `HDMau_XML` varchar(255) NULL,
    `HDMau_Trangthai` int NOT NULL,
    `HDMau_NgayHieuLuc` datetime NULL,
    `HDMau_NgayHetHieuLuc` datetime NULL,
    `DaiLy_Id` int NULL,
    `TenantId` int NULL,
    `HDMau_KyHieu` varchar(255) NULL,
    `HDMau_MauSo` varchar(255) NULL,
    `HDMau_Version` int NULL,
    `TrangThai_Chot` int NULL,
    `LyDoTuChoi` varchar(255) NULL,
    `QuanLy_Xsl_Version` varchar(255) NULL,
    `MaxLength_Line` int NULL,
    `MaxRow_Page` int NULL,
    `MaxRow_FullPage` int NULL,
    `HDMau_IsLayoutLandscape` bit NULL,
    `HDMau_ThongTu` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `DoanhNghiep_Ten` varchar(255) NULL,
    `DoanhNghiep_DiaChi` varchar(255) NULL,
    `DoanhNghiep_SDT` varchar(255) NULL,
    `DoanhNghiep_Email` varchar(255) NULL,
    `DoanhNghiep_Fax` varchar(255) NULL,
    `DoanhNghiep_Website` varchar(255) NULL,
    `DoanhNghiep_TaiKhoan` varchar(255) NULL,
    `DoanhNghiep_NganHang` varchar(255) NULL
);
