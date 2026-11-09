-- Table: vs_hd_thongbao_hdmau
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/ThongBaoPhatHanh/HD_ThongBao_HDMau.cs
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
--   HDMau_KyHieu varchar(255) NULL -- C# string
--   HDMau_XSLT varchar(255) NULL -- C# string
--   HDMau_XML varchar(255) NULL -- C# string
--   LoaiHoaDon_MauSo varchar(255) NULL -- C# string
--   LoaiHoaDon_Ten varchar(255) NULL -- C# string
--   Loai_HD_DacThu varchar(255) NULL -- C# string
--   ThongBao_SoLuong int NOT NULL -- C# int
--   ThongBao_TuSo int NOT NULL -- C# int
--   ThongBao_DenSo int NOT NULL -- C# int
--   ThongBao_NgaySuDung datetime NULL -- C# DateTime?
--   ThongBao_Id int NOT NULL -- C# int
--   SuDung_TrangThai int NOT NULL -- C# int
--   SuDung_SoHienTai int NOT NULL -- C# int
--   SoHienTai_Reset int NULL -- C# int?
--   MauHD_Loai int NOT NULL -- C# int
--   MauHDGoc_Id int NULL -- C# int?
--   DMMau_Id int NULL -- C# int?
--   GiuSo_TuNgay datetime NULL -- C# DateTime?
--   GiuSo_DenNgay datetime NULL -- C# DateTime?
--   CapSo_TrangThai int NOT NULL -- C# int
--   CapSo_NgayCho datetime NULL -- C# DateTime?
--   CapSo_NgayHD datetime NULL -- C# DateTime?
--   Tct_HoatDong int NULL -- C# int?
--   Tct_Link varchar(255) NULL -- C# string
--   Tct_TaiKhoan varchar(255) NULL -- C# string
--   Tct_BaoMat varchar(255) NULL -- C# string
--   Tct_NgayApDung datetime NULL -- C# DateTime?
--   PhongBan varchar(255) NULL -- C# string
--   QuanLy_Xsl_Version varchar(255) NULL -- C# string
--   MaxLength_Line int NULL -- C# int?
--   MaxRow_Page int NULL -- C# int?
--   MaxRow_FullPage int NULL -- C# int?
--   HDMau_IsLayoutLandscape bit NULL -- C# bool?
--   HDMau_PaperSize int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   IsActive bit NULL -- C# bool?
--   IsLockout int NULL -- C# int?
--   Hdmau_ThongTu varchar(255) NULL -- C# string
--   IsPos bit NULL -- C# bool?

CREATE TABLE `vs_hd_thongbao_hdmau` (
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
    `HDMau_KyHieu` varchar(255) NULL,
    `HDMau_XSLT` varchar(255) NULL,
    `HDMau_XML` varchar(255) NULL,
    `LoaiHoaDon_MauSo` varchar(255) NULL,
    `LoaiHoaDon_Ten` varchar(255) NULL,
    `Loai_HD_DacThu` varchar(255) NULL,
    `ThongBao_SoLuong` int NOT NULL,
    `ThongBao_TuSo` int NOT NULL,
    `ThongBao_DenSo` int NOT NULL,
    `ThongBao_NgaySuDung` datetime NULL,
    `ThongBao_Id` int NOT NULL,
    `SuDung_TrangThai` int NOT NULL,
    `SuDung_SoHienTai` int NOT NULL,
    `SoHienTai_Reset` int NULL,
    `MauHD_Loai` int NOT NULL,
    `MauHDGoc_Id` int NULL,
    `DMMau_Id` int NULL,
    `GiuSo_TuNgay` datetime NULL,
    `GiuSo_DenNgay` datetime NULL,
    `CapSo_TrangThai` int NOT NULL,
    `CapSo_NgayCho` datetime NULL,
    `CapSo_NgayHD` datetime NULL,
    `Tct_HoatDong` int NULL,
    `Tct_Link` varchar(255) NULL,
    `Tct_TaiKhoan` varchar(255) NULL,
    `Tct_BaoMat` varchar(255) NULL,
    `Tct_NgayApDung` datetime NULL,
    `PhongBan` varchar(255) NULL,
    `QuanLy_Xsl_Version` varchar(255) NULL,
    `MaxLength_Line` int NULL,
    `MaxRow_Page` int NULL,
    `MaxRow_FullPage` int NULL,
    `HDMau_IsLayoutLandscape` bit NULL,
    `HDMau_PaperSize` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `IsActive` bit NULL,
    `IsLockout` int NULL,
    `Hdmau_ThongTu` varchar(255) NULL,
    `IsPos` bit NULL
);
