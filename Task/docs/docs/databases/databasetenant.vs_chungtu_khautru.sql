-- Table: vs_chungtu_khautru
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/ChungTu/ChungTu_KhauTru.cs
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
--   Mau_KyHieu varchar(255) NULL -- C# string
--   Mau_Id int NOT NULL -- C# int
--   Mau_So varchar(255) NULL -- C# string
--   Ct_So varchar(255) NULL -- C# string
--   Ct_NgayLap datetime NULL -- C# DateTime?
--   Ct_NgayKy datetime NULL -- C# DateTime?
--   Ct_MauNguoiKy varchar(255) NULL -- C# string
--   Ct_ThoiDiemTtn varchar(255) NULL -- C# string
--   Ct_ThuNhapChiuThue decimal(18,2) NULL -- C# decimal?
--   Ct_ThuNhapTinhThue decimal(18,2) NULL -- C# decimal?
--   Ct_SoThue decimal(18,2) NULL -- C# decimal?
--   Ct_TrangThai int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   FilePath varchar(255) NULL -- C# string
--   Ct_DNBan_Ten varchar(255) NULL -- C# string
--   Ct_DNBan_TinhThanhTen varchar(255) NULL -- C# string
--   Ct_DNBan_DiaChi varchar(255) NULL -- C# string
--   Ct_DNBan_Mst varchar(255) NULL -- C# string
--   Ct_DNBan_Sdt varchar(255) NULL -- C# string
--   Ct_DNBan_Fax varchar(255) NULL -- C# string
--   Ct_DNBan_Email varchar(255) NULL -- C# string
--   Ct_DNBan_Website varchar(255) NULL -- C# string
--   Ct_DNBan_TaiKhoan varchar(255) NULL -- C# string
--   Ct_DNBan_NganHang varchar(255) NULL -- C# string
--   Ct_NMua_Ten varchar(255) NULL -- C# string
--   Ct_NMua_Mst varchar(255) NULL -- C# string
--   Ct_NMua_QuocTich varchar(255) NULL -- C# string
--   Ct_NMua_CuTru bit NULL -- C# bool?
--   Ct_NMua_DiaChi varchar(255) NULL -- C# string
--   Ct_NMua_Sdt varchar(255) NULL -- C# string
--   Ct_NMua_Email varchar(255) NULL -- C# string
--   Ct_GiayToTuyThan varchar(255) NULL -- C# string
--   Ct_GiayToTuyThan_NoiCap varchar(255) NULL -- C# string
--   Ct_GiayToTuyThan_NgayCap datetime NULL -- C# DateTime?
--   Ct_KhoanThuNhap varchar(255) NULL -- C# string
--   Ct_KhoanBaoHiem varchar(255) NULL -- C# string
--   Ct_KhoanTuThienNhanDao decimal(18,2) NULL -- C# decimal?
--   Ct_KhoanBaoHiem_So decimal(18,2) NULL -- C# decimal?
--   Ct_ThuNhapChiuThue_DaTra decimal(18,2) NULL -- C# decimal?
--   Ct_ThuNhap_DuocNhan decimal(18,2) NULL -- C# decimal?
--   QuanLy_GuiEmail int NULL -- C# int?
--   QuanLyVBTT_FileName varchar(255) NULL -- C# string
--   Ct_Loai int NULL -- C# int?
--   Mau_HopDong_So varchar(255) NULL -- C# string
--   Mau_HopDong_Ngay datetime NULL -- C# DateTime?
--   Ct_LyDoHuy varchar(255) NULL -- C# string
--   Ct_SoBaoMat varchar(255) NULL -- C# string
--   Ct_TThang int NULL -- C# int?
--   Ct_DThang int NULL -- C# int?
--   Ct_Nam int NULL -- C# int?
--   Ct_goc_id int NULL -- C# int?

CREATE TABLE `vs_chungtu_khautru` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Mau_KyHieu` varchar(255) NULL,
    `Mau_Id` int NOT NULL,
    `Mau_So` varchar(255) NULL,
    `Ct_So` varchar(255) NULL,
    `Ct_NgayLap` datetime NULL,
    `Ct_NgayKy` datetime NULL,
    `Ct_MauNguoiKy` varchar(255) NULL,
    `Ct_ThoiDiemTtn` varchar(255) NULL,
    `Ct_ThuNhapChiuThue` decimal(18,2) NULL,
    `Ct_ThuNhapTinhThue` decimal(18,2) NULL,
    `Ct_SoThue` decimal(18,2) NULL,
    `Ct_TrangThai` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `FilePath` varchar(255) NULL,
    `Ct_DNBan_Ten` varchar(255) NULL,
    `Ct_DNBan_TinhThanhTen` varchar(255) NULL,
    `Ct_DNBan_DiaChi` varchar(255) NULL,
    `Ct_DNBan_Mst` varchar(255) NULL,
    `Ct_DNBan_Sdt` varchar(255) NULL,
    `Ct_DNBan_Fax` varchar(255) NULL,
    `Ct_DNBan_Email` varchar(255) NULL,
    `Ct_DNBan_Website` varchar(255) NULL,
    `Ct_DNBan_TaiKhoan` varchar(255) NULL,
    `Ct_DNBan_NganHang` varchar(255) NULL,
    `Ct_NMua_Ten` varchar(255) NULL,
    `Ct_NMua_Mst` varchar(255) NULL,
    `Ct_NMua_QuocTich` varchar(255) NULL,
    `Ct_NMua_CuTru` bit NULL,
    `Ct_NMua_DiaChi` varchar(255) NULL,
    `Ct_NMua_Sdt` varchar(255) NULL,
    `Ct_NMua_Email` varchar(255) NULL,
    `Ct_GiayToTuyThan` varchar(255) NULL,
    `Ct_GiayToTuyThan_NoiCap` varchar(255) NULL,
    `Ct_GiayToTuyThan_NgayCap` datetime NULL,
    `Ct_KhoanThuNhap` varchar(255) NULL,
    `Ct_KhoanBaoHiem` varchar(255) NULL,
    `Ct_KhoanTuThienNhanDao` decimal(18,2) NULL,
    `Ct_KhoanBaoHiem_So` decimal(18,2) NULL,
    `Ct_ThuNhapChiuThue_DaTra` decimal(18,2) NULL,
    `Ct_ThuNhap_DuocNhan` decimal(18,2) NULL,
    `QuanLy_GuiEmail` int NULL,
    `QuanLyVBTT_FileName` varchar(255) NULL,
    `Ct_Loai` int NULL,
    `Mau_HopDong_So` varchar(255) NULL,
    `Mau_HopDong_Ngay` datetime NULL,
    `Ct_LyDoHuy` varchar(255) NULL,
    `Ct_SoBaoMat` varchar(255) NULL,
    `Ct_TThang` int NULL,
    `Ct_DThang` int NULL,
    `Ct_Nam` int NULL,
    `Ct_goc_id` int NULL
);
