-- Table: vs_hd_chitiet_morong
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_ChiTiet_MoRong.cs
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
--   ChiTiet_Id int NOT NULL -- C# int
--   Thuoc_SoLo varchar(255) NULL -- C# string
--   Thuoc_HanSuDung datetime NULL -- C# DateTime?
--   Thuoc_ChietKhau2 decimal(18,2) NULL -- C# decimal?
--   Thuoc_NuocSX varchar(255) NULL -- C# string
--   BenhVien_MucBHTra decimal(18,2) NULL -- C# decimal?
--   BenhVien_BHTra decimal(18,2) NULL -- C# decimal?
--   DienNuoc_BoChiSo varchar(255) NULL -- C# string
--   DienNuoc_SoLuongTieuThu decimal(18,2) NULL -- C# decimal?
--   DienNuoc_ChiSoMoi decimal(18,2) NULL -- C# decimal?
--   DienNuoc_ChiSoCu decimal(18,2) NULL -- C# decimal?
--   DienNuoc_HeSoNhan decimal(18,2) NULL -- C# decimal?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   Nuoc_MucDichSuDung varchar(255) NULL -- C# string
--   Ma_Kho varchar(255) NULL -- C# string
--   DienGiai varchar(255) NULL -- C# string
--   TaiKhoan_No varchar(255) NULL -- C# string
--   TaiKhoan_Dt varchar(255) NULL -- C# string
--   TaiKhoan_Vt varchar(255) NULL -- C# string
--   TaiKhoan_GiaVon varchar(255) NULL -- C# string
--   TaiKhoan_Thue varchar(255) NULL -- C# string
--   phikhac_tyle decimal(18,2) NULL -- C# decimal?
--   phikhac_sotien decimal(18,2) NULL -- C# decimal?
--   BS_ChiTiet_01 varchar(255) NULL -- C# string
--   BS_ChiTiet_02 varchar(255) NULL -- C# string
--   BS_ChiTiet_03 varchar(255) NULL -- C# string
--   BS_ChiTiet_04 varchar(255) NULL -- C# string
--   BS_ChiTiet_05 varchar(255) NULL -- C# string
--   BS_ChiTiet_06 varchar(255) NULL -- C# string
--   BS_ChiTiet_07 varchar(255) NULL -- C# string
--   BS_ChiTiet_08 varchar(255) NULL -- C# string
--   BS_ChiTiet_09 varchar(255) NULL -- C# string
--   BS_ChiTiet_10 varchar(255) NULL -- C# string
--   Loai_HangHoa_DacTrung int NULL -- C# int?
--   So_Khung varchar(255) NULL -- C# string
--   So_May varchar(255) NULL -- C# string
--   Bien_Kiem_Soat varchar(255) NULL -- C# string
--   Ten_Nguoi_Gui_Hang varchar(255) NULL -- C# string
--   Dia_Chi_Nguoi_Gui_Hang varchar(255) NULL -- C# string
--   MST_Nguoi_Gui_Hang varchar(255) NULL -- C# string
--   So_Dinh_Danh_Gui_Hang varchar(255) NULL -- C# string

CREATE TABLE `vs_hd_chitiet_morong` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ChiTiet_Id` int NOT NULL,
    `Thuoc_SoLo` varchar(255) NULL,
    `Thuoc_HanSuDung` datetime NULL,
    `Thuoc_ChietKhau2` decimal(18,2) NULL,
    `Thuoc_NuocSX` varchar(255) NULL,
    `BenhVien_MucBHTra` decimal(18,2) NULL,
    `BenhVien_BHTra` decimal(18,2) NULL,
    `DienNuoc_BoChiSo` varchar(255) NULL,
    `DienNuoc_SoLuongTieuThu` decimal(18,2) NULL,
    `DienNuoc_ChiSoMoi` decimal(18,2) NULL,
    `DienNuoc_ChiSoCu` decimal(18,2) NULL,
    `DienNuoc_HeSoNhan` decimal(18,2) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `Nuoc_MucDichSuDung` varchar(255) NULL,
    `Ma_Kho` varchar(255) NULL,
    `DienGiai` varchar(255) NULL,
    `TaiKhoan_No` varchar(255) NULL,
    `TaiKhoan_Dt` varchar(255) NULL,
    `TaiKhoan_Vt` varchar(255) NULL,
    `TaiKhoan_GiaVon` varchar(255) NULL,
    `TaiKhoan_Thue` varchar(255) NULL,
    `phikhac_tyle` decimal(18,2) NULL,
    `phikhac_sotien` decimal(18,2) NULL,
    `BS_ChiTiet_01` varchar(255) NULL,
    `BS_ChiTiet_02` varchar(255) NULL,
    `BS_ChiTiet_03` varchar(255) NULL,
    `BS_ChiTiet_04` varchar(255) NULL,
    `BS_ChiTiet_05` varchar(255) NULL,
    `BS_ChiTiet_06` varchar(255) NULL,
    `BS_ChiTiet_07` varchar(255) NULL,
    `BS_ChiTiet_08` varchar(255) NULL,
    `BS_ChiTiet_09` varchar(255) NULL,
    `BS_ChiTiet_10` varchar(255) NULL,
    `Loai_HangHoa_DacTrung` int NULL,
    `So_Khung` varchar(255) NULL,
    `So_May` varchar(255) NULL,
    `Bien_Kiem_Soat` varchar(255) NULL,
    `Ten_Nguoi_Gui_Hang` varchar(255) NULL,
    `Dia_Chi_Nguoi_Gui_Hang` varchar(255) NULL,
    `MST_Nguoi_Gui_Hang` varchar(255) NULL,
    `So_Dinh_Danh_Gui_Hang` varchar(255) NULL
);
