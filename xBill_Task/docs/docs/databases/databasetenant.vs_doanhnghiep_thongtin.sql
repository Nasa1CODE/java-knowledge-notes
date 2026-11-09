-- Table: vs_doanhnghiep_thongtin
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DoanhNghiep/DoanhNghiep_ThongTin.cs
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
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   DoanhNghiep_Ten varchar(255) NULL -- C# string
--   DoanhNghiepCha_Id int NULL -- C# int?
--   DoanhNghiepOng_Id int NULL -- C# int?
--   DoanhNghiep_DiaChi varchar(255) NULL -- C# string
--   DoanhNghiep_DiaChi_01 varchar(255) NULL -- C# string
--   ChiCucThue_Ma varchar(255) NULL -- C# string
--   ChiCucThue_Ten varchar(255) NULL -- C# string
--   DoanhNghiep_TinhThanh_Ma varchar(255) NULL -- C# string
--   DoanhNghiep_TinhThanh varchar(255) NULL -- C# string
--   DoanhNghiep_QuanHuyen_Ma varchar(255) NULL -- C# string
--   DoanhNghiep_QuanHuyen varchar(255) NULL -- C# string
--   DoanhNghiep_Logo varchar(255) NULL -- C# string
--   DoanhNghiep_SDT varchar(255) NULL -- C# string
--   DoanhNghiep_Email varchar(255) NULL -- C# string
--   DoanhNghiep_Fax varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   DoanhNghiep_NgayThanhLap datetime NULL -- C# DateTime?
--   DoanhNghiep_Website varchar(255) NULL -- C# string
--   Tct_HoatDong int NULL -- C# int?
--   Tct_Link varchar(255) NULL -- C# string
--   Tct_TaiKhoan varchar(255) NULL -- C# string
--   Tct_BaoMat varchar(255) NULL -- C# string
--   Tct_NgayApDung datetime NULL -- C# DateTime?
--   Tct_NgayCapNhap datetime NULL -- C# DateTime?
--   DoanhNghiep_NguoiDaiDien varchar(255) NULL -- C# string
--   DoanhNghiep_NDD_CMND varchar(255) NULL -- C# string
--   DoanhNghiep_NDD_NgayCap datetime NULL -- C# DateTime?
--   DoanhNghiep_NDD_NoiCap varchar(255) NULL -- C# string
--   DoanhNghiep_NDD_ChucVu varchar(255) NULL -- C# string
--   DaiLy_Id int NULL -- C# int?
--   DoanhNghiep_TaiKhoan varchar(255) NULL -- C# string
--   DoanhNghiep_NganHang varchar(255) NULL -- C# string
--   DoanhNghiep_Loai_ChiNhanh int NULL -- C# int?
--   DoanhNghiep_HoanThanhDangKy int NULL -- C# int?
--   DoanhNghiep_DiaChiThongBao varchar(255) NULL -- C# string
--   DoanhNghiep_TrangThai int NULL -- C# int?
--   Link_HopDong varchar(255) NULL -- C# string
--   DoanhNghiep_DiaChi_BoSung varchar(255) NULL -- C# string
--   TrangThai_HopDong int NULL -- C# int?
--   IsVerify_Phone bit NULL -- C# bool?
--   Tct_PheDuyet bit NULL -- C# bool?
--   Tct_LoaiHoaDon bit NULL -- C# bool?
--   Tct_PhuongThucGui int NULL -- C# int?
--   MaCqt varchar(255) NULL -- C# string
--   IsPos bit NULL -- C# bool?
--   Tct_LoaiHoaDonKoMa bit NULL -- C# bool?
--   Type_Of_Use int NULL -- C# int?
--   DoanhNghiep_CCCD varchar(255) NULL -- C# string
--   Number_Change int NULL -- C# int?

CREATE TABLE `vs_doanhnghiep_thongtin` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `DoanhNghiep_Ten` varchar(255) NULL,
    `DoanhNghiepCha_Id` int NULL,
    `DoanhNghiepOng_Id` int NULL,
    `DoanhNghiep_DiaChi` varchar(255) NULL,
    `DoanhNghiep_DiaChi_01` varchar(255) NULL,
    `ChiCucThue_Ma` varchar(255) NULL,
    `ChiCucThue_Ten` varchar(255) NULL,
    `DoanhNghiep_TinhThanh_Ma` varchar(255) NULL,
    `DoanhNghiep_TinhThanh` varchar(255) NULL,
    `DoanhNghiep_QuanHuyen_Ma` varchar(255) NULL,
    `DoanhNghiep_QuanHuyen` varchar(255) NULL,
    `DoanhNghiep_Logo` varchar(255) NULL,
    `DoanhNghiep_SDT` varchar(255) NULL,
    `DoanhNghiep_Email` varchar(255) NULL,
    `DoanhNghiep_Fax` varchar(255) NULL,
    `TenantId` int NULL,
    `DoanhNghiep_NgayThanhLap` datetime NULL,
    `DoanhNghiep_Website` varchar(255) NULL,
    `Tct_HoatDong` int NULL,
    `Tct_Link` varchar(255) NULL,
    `Tct_TaiKhoan` varchar(255) NULL,
    `Tct_BaoMat` varchar(255) NULL,
    `Tct_NgayApDung` datetime NULL,
    `Tct_NgayCapNhap` datetime NULL,
    `DoanhNghiep_NguoiDaiDien` varchar(255) NULL,
    `DoanhNghiep_NDD_CMND` varchar(255) NULL,
    `DoanhNghiep_NDD_NgayCap` datetime NULL,
    `DoanhNghiep_NDD_NoiCap` varchar(255) NULL,
    `DoanhNghiep_NDD_ChucVu` varchar(255) NULL,
    `DaiLy_Id` int NULL,
    `DoanhNghiep_TaiKhoan` varchar(255) NULL,
    `DoanhNghiep_NganHang` varchar(255) NULL,
    `DoanhNghiep_Loai_ChiNhanh` int NULL,
    `DoanhNghiep_HoanThanhDangKy` int NULL,
    `DoanhNghiep_DiaChiThongBao` varchar(255) NULL,
    `DoanhNghiep_TrangThai` int NULL,
    `Link_HopDong` varchar(255) NULL,
    `DoanhNghiep_DiaChi_BoSung` varchar(255) NULL,
    `TrangThai_HopDong` int NULL,
    `IsVerify_Phone` bit NULL,
    `Tct_PheDuyet` bit NULL,
    `Tct_LoaiHoaDon` bit NULL,
    `Tct_PhuongThucGui` int NULL,
    `MaCqt` varchar(255) NULL,
    `IsPos` bit NULL,
    `Tct_LoaiHoaDonKoMa` bit NULL,
    `Type_Of_Use` int NULL,
    `DoanhNghiep_CCCD` varchar(255) NULL,
    `Number_Change` int NULL
);
