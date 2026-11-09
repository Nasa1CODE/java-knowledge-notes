-- Table: vs_dm_doanhnghiep_khachhang
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMDoanhNghiep/DMDoanhNghiep_KhachHang.cs
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
--   KhachHang_Loai int NOT NULL -- C# int
--   KhachHang_MST varchar(255) NULL -- C# string
--   KhachHang_Ma varchar(255) NULL -- C# string
--   KhachHang_Ten varchar(255) NULL -- C# string
--   KhachHang_TenNguoiMua varchar(255) NULL -- C# string
--   KhachHang_Email varchar(255) NULL -- C# string
--   KhachHang_SDT varchar(255) NULL -- C# string
--   KhachHang_DiaChi varchar(255) NULL -- C# string
--   KhachHang_GhiChu varchar(255) NULL -- C# string
--   KhachHang_NguoiDaiDien varchar(255) NULL -- C# string
--   KhachHang_NguoiLienHe varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   UserId bigint NULL -- C# long?
--   KhachHang_MaDVQHNS varchar(255) NULL -- C# string
--   KhachHang_SoHoChieu varchar(255) NULL -- C# string
--   KhachHang_CCCD varchar(255) NULL -- C# string

CREATE TABLE `vs_dm_doanhnghiep_khachhang` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `KhachHang_Loai` int NOT NULL,
    `KhachHang_MST` varchar(255) NULL,
    `KhachHang_Ma` varchar(255) NULL,
    `KhachHang_Ten` varchar(255) NULL,
    `KhachHang_TenNguoiMua` varchar(255) NULL,
    `KhachHang_Email` varchar(255) NULL,
    `KhachHang_SDT` varchar(255) NULL,
    `KhachHang_DiaChi` varchar(255) NULL,
    `KhachHang_GhiChu` varchar(255) NULL,
    `KhachHang_NguoiDaiDien` varchar(255) NULL,
    `KhachHang_NguoiLienHe` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `UserId` bigint NULL,
    `KhachHang_MaDVQHNS` varchar(255) NULL,
    `KhachHang_SoHoChieu` varchar(255) NULL,
    `KhachHang_CCCD` varchar(255) NULL
);
