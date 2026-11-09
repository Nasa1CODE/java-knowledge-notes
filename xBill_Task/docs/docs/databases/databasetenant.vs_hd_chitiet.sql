-- Table: vs_hd_chitiet
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_ChiTiet.cs
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
--   TongHop_Id int NOT NULL -- C# int
--   HoaDon_So varchar(255) NULL -- C# string
--   STT int NULL -- C# int?
--   Vat_Rate int NULL -- C# int?
--   HangHoa_Ma varchar(255) NULL -- C# string
--   HangHoa_Ten varchar(255) NULL -- C# string
--   DonViTinh_Ma varchar(255) NULL -- C# string
--   DonViTinh_Ten varchar(255) NULL -- C# string
--   HangHoa_DonGia decimal(18,2) NULL -- C# decimal?
--   HangHoa_SoLuong decimal(18,2) NULL -- C# decimal?
--   ChietKhau_PhanTram decimal(18,2) NULL -- C# decimal?
--   TongTien_ChietKhau decimal(18,2) NULL -- C# decimal?
--   TongTien_ChuaThue decimal(18,2) NULL -- C# decimal?
--   TongTien_CoThue decimal(18,2) NULL -- C# decimal?
--   HangHoa_MaThue int NULL -- C# int?
--   HangHoa_Thue decimal(18,2) NULL -- C# decimal?
--   HangHoa_TenThue varchar(255) NULL -- C# string
--   TongTien_Thue decimal(18,2) NULL -- C# decimal?
--   KhuyenMai bit NOT NULL -- C# bool
--   TongTien_DieuChinh decimal(18,2) NULL -- C# decimal?
--   TongTien_ThueDieuChinh decimal(18,2) NULL -- C# decimal?
--   DieuChinh_TangGiam bit NULL -- C# bool?
--   HangHoa_Loai int NULL -- C# int?
--   VanChuyen_Loai int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   GhiChu varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_hd_chitiet` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TongHop_Id` int NOT NULL,
    `HoaDon_So` varchar(255) NULL,
    `STT` int NULL,
    `Vat_Rate` int NULL,
    `HangHoa_Ma` varchar(255) NULL,
    `HangHoa_Ten` varchar(255) NULL,
    `DonViTinh_Ma` varchar(255) NULL,
    `DonViTinh_Ten` varchar(255) NULL,
    `HangHoa_DonGia` decimal(18,2) NULL,
    `HangHoa_SoLuong` decimal(18,2) NULL,
    `ChietKhau_PhanTram` decimal(18,2) NULL,
    `TongTien_ChietKhau` decimal(18,2) NULL,
    `TongTien_ChuaThue` decimal(18,2) NULL,
    `TongTien_CoThue` decimal(18,2) NULL,
    `HangHoa_MaThue` int NULL,
    `HangHoa_Thue` decimal(18,2) NULL,
    `HangHoa_TenThue` varchar(255) NULL,
    `TongTien_Thue` decimal(18,2) NULL,
    `KhuyenMai` bit NOT NULL,
    `TongTien_DieuChinh` decimal(18,2) NULL,
    `TongTien_ThueDieuChinh` decimal(18,2) NULL,
    `DieuChinh_TangGiam` bit NULL,
    `HangHoa_Loai` int NULL,
    `VanChuyen_Loai` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `GhiChu` varchar(255) NULL,
    `TenantId` int NULL
);
