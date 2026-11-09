-- Table: vs_dm_doanhnghiep_sanpham
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMDoanhNghiep/DMDoanhNghiep_SanPham.cs
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
--   SanPham_Ma varchar(255) NULL -- C# string
--   SanPham_Ten varchar(255) NULL -- C# string
--   SanPham_DonViTinh varchar(255) NULL -- C# string
--   SanPham_Gia decimal(18,2) NOT NULL -- C# decimal
--   SanPham_ThueSuat decimal(18,2) NULL -- C# decimal?
--   SanPham_MaThueSuat int NULL -- C# int?
--   SanPham_GhiChu varchar(255) NULL -- C# string
--   SanPham_TrangThai bit NOT NULL -- C# bool
--   DienGiai varchar(255) NULL -- C# string
--   TaiKhoan_No varchar(255) NULL -- C# string
--   TaiKhoan_Dt varchar(255) NULL -- C# string
--   TaiKhoan_Vt varchar(255) NULL -- C# string
--   TaiKhoan_GiaVon varchar(255) NULL -- C# string
--   TaiKhoan_Thue varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NOT NULL -- C# int
--   SanPham_Loai int NULL -- C# int?
--   SanPham_SoLuong int NULL -- C# int?
--   SanPham_ChietKhau decimal(18,2) NULL -- C# decimal?
--   SanPham_SoTienChietKhau double NULL -- C# double?
--   SanPham_ThanhTienTT double NULL -- C# double?
--   SanPham_TienThue double NULL -- C# double?
--   SanPham_LoaiHHDT int NULL -- C# int?
--   SanPham_SoKhung varchar(255) NULL -- C# string
--   SanPham_SoMay varchar(255) NULL -- C# string
--   SanPham_TenNguoiGuiHang varchar(255) NULL -- C# string
--   SanPham_DiaChiNguoiGui varchar(255) NULL -- C# string
--   SanPham_MSTNguoiGui varchar(255) NULL -- C# string
--   SanPham_SDDNguoiGui varchar(255) NULL -- C# string
--   SanPham_BienKiemSoat varchar(255) NULL -- C# string
--   SanPham_KhuyenMai int NULL -- C# int?
--   SanPham_TiLeThueDT decimal(18,2) NULL -- C# decimal?

CREATE TABLE `vs_dm_doanhnghiep_sanpham` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `SanPham_Ma` varchar(255) NULL,
    `SanPham_Ten` varchar(255) NULL,
    `SanPham_DonViTinh` varchar(255) NULL,
    `SanPham_Gia` decimal(18,2) NOT NULL,
    `SanPham_ThueSuat` decimal(18,2) NULL,
    `SanPham_MaThueSuat` int NULL,
    `SanPham_GhiChu` varchar(255) NULL,
    `SanPham_TrangThai` bit NOT NULL,
    `DienGiai` varchar(255) NULL,
    `TaiKhoan_No` varchar(255) NULL,
    `TaiKhoan_Dt` varchar(255) NULL,
    `TaiKhoan_Vt` varchar(255) NULL,
    `TaiKhoan_GiaVon` varchar(255) NULL,
    `TaiKhoan_Thue` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NOT NULL,
    `SanPham_Loai` int NULL,
    `SanPham_SoLuong` int NULL,
    `SanPham_ChietKhau` decimal(18,2) NULL,
    `SanPham_SoTienChietKhau` double NULL,
    `SanPham_ThanhTienTT` double NULL,
    `SanPham_TienThue` double NULL,
    `SanPham_LoaiHHDT` int NULL,
    `SanPham_SoKhung` varchar(255) NULL,
    `SanPham_SoMay` varchar(255) NULL,
    `SanPham_TenNguoiGuiHang` varchar(255) NULL,
    `SanPham_DiaChiNguoiGui` varchar(255) NULL,
    `SanPham_MSTNguoiGui` varchar(255) NULL,
    `SanPham_SDDNguoiGui` varchar(255) NULL,
    `SanPham_BienKiemSoat` varchar(255) NULL,
    `SanPham_KhuyenMai` int NULL,
    `SanPham_TiLeThueDT` decimal(18,2) NULL
);
