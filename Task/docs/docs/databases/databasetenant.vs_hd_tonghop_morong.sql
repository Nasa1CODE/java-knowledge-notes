-- Table: vs_hd_tonghop_morong
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_HoaDon_MoRong.cs
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
--   Thuoc_DiaChiGiaoHang varchar(255) NULL -- C# string
--   DienNuoc_MaKhachHang varchar(255) NULL -- C# string
--   DienNuoc_ThangNam decimal(18,2) NULL -- C# decimal?
--   DienNuoc_SoCongTo decimal(18,2) NULL -- C# decimal?
--   DienNuoc_SoHo varchar(255) NULL -- C# string
--   DienNuoc_HeSo decimal(18,2) NULL -- C# decimal?
--   DienNuoc_SoLuongTieuThu decimal(18,2) NULL -- C# decimal?
--   DienNuoc_ChiSoMoi decimal(18,2) NULL -- C# decimal?
--   DienNuoc_ChiSoCu decimal(18,2) NULL -- C# decimal?
--   DienNuoc_TuNgay datetime NULL -- C# DateTime?
--   DienNuoc_DenNgay datetime NULL -- C# DateTime?
--   XangDau_PhiKhac decimal(18,2) NULL -- C# decimal?
--   XangDau_PhiKhac_TyLe decimal(18,2) NULL -- C# decimal?
--   VeMayBay_ThuHo_ThueKhac decimal(18,2) NULL -- C# decimal?
--   VeMayBay_ThuHo_PhiKhac decimal(18,2) NULL -- C# decimal?
--   VeMayBay_TienPhi decimal(18,2) NULL -- C# decimal?
--   VeMayBay_ThueSuat decimal(18,2) NULL -- C# decimal?
--   VeMayBay_MaThueSuat varchar(255) NULL -- C# string
--   VeMayBay_TienThue decimal(18,2) NULL -- C# decimal?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   Benhvien_Loaidichvu varchar(255) NULL -- C# string
--   Nuoc_HeThongNuoc varchar(255) NULL -- C# string
--   Nuoc_SoDangKy varchar(255) NULL -- C# string
--   Nuoc_MucPhiMoiTruong int NULL -- C# int?
--   Nuoc_PhiKhac decimal(18,2) NULL -- C# decimal?
--   HangHai_TenTau varchar(255) NULL -- C# string
--   HangHai_DungTichThanhPhan varchar(255) NULL -- C# string
--   HangHai_LoaiTau varchar(255) NULL -- C# string
--   HangHai_QuyDoi decimal(18,2) NULL -- C# decimal?
--   HangHai_TongTienCoVat_ChuTiengAnh varchar(255) NULL -- C# string
--   HangHai_NgayDen datetime NULL -- C# DateTime?
--   HangHai_NgayDi datetime NULL -- C# DateTime?
--   XayDung_CongTrinh varchar(255) NULL -- C# string
--   KhachHang_NgaySinh datetime NULL -- C# DateTime?
--   DNBan_Tc_Ma varchar(255) NULL -- C# string
--   DNBan_Tc_Ten varchar(255) NULL -- C# string
--   DNBan_Tc_DienThoai varchar(255) NULL -- C# string
--   DNBan_Tc_Fax varchar(255) NULL -- C# string
--   DNBan_Tc_Email varchar(255) NULL -- C# string
--   DNBan_Tc_DiaChi varchar(255) NULL -- C# string
--   DNBan_Tc_TaiKhoan varchar(255) NULL -- C# string
--   DNBan_Tc_NganHang varchar(255) NULL -- C# string
--   DNBan_Tc_Website varchar(255) NULL -- C# string
--   Sp_SoNb varchar(255) NULL -- C# string
--   Sp_SoDdh varchar(255) NULL -- C# string
--   Sp_SoNoiBoXnk varchar(255) NULL -- C# string
--   Sp_NguoiTao_NgayTao varchar(255) NULL -- C# string
--   Sp_SoHopDong varchar(255) NULL -- C# string
--   Sp_TrinhDuocVien varchar(255) NULL -- C# string
--   Sp_NhanVienGiaoHang varchar(255) NULL -- C# string
--   Sp_SoKhoan varchar(255) NULL -- C# string
--   phikhac_tyle decimal(18,2) NULL -- C# decimal?
--   phikhac_sotien decimal(18,2) NULL -- C# decimal?
--   BS_ThongTin_DNMua_01 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_02 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_03 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_04 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_05 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_06 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_07 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_08 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_09 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_10 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_11 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_12 varchar(255) NULL -- C# string
--   BS_ThongTin_DNMua_13 varchar(255) NULL -- C# string
--   DNMua_CCCD varchar(255) NULL -- C# string
--   Nguoihuy varchar(255) NULL -- C# string
--   NgayHuy datetime NULL -- C# DateTime?
--   NguoiHuy_Id int NULL -- C# int?
--   MaDVQHNS varchar(255) NULL -- C# string
--   SoHoChieu varchar(255) NULL -- C# string
--   SoBangKe varchar(255) NULL -- C# string
--   NgayBangKe datetime NULL -- C# DateTime?
--   File_BangKe varchar(255) NULL -- C# string

CREATE TABLE `vs_hd_tonghop_morong` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TongHop_Id` int NOT NULL,
    `Thuoc_DiaChiGiaoHang` varchar(255) NULL,
    `DienNuoc_MaKhachHang` varchar(255) NULL,
    `DienNuoc_ThangNam` decimal(18,2) NULL,
    `DienNuoc_SoCongTo` decimal(18,2) NULL,
    `DienNuoc_SoHo` varchar(255) NULL,
    `DienNuoc_HeSo` decimal(18,2) NULL,
    `DienNuoc_SoLuongTieuThu` decimal(18,2) NULL,
    `DienNuoc_ChiSoMoi` decimal(18,2) NULL,
    `DienNuoc_ChiSoCu` decimal(18,2) NULL,
    `DienNuoc_TuNgay` datetime NULL,
    `DienNuoc_DenNgay` datetime NULL,
    `XangDau_PhiKhac` decimal(18,2) NULL,
    `XangDau_PhiKhac_TyLe` decimal(18,2) NULL,
    `VeMayBay_ThuHo_ThueKhac` decimal(18,2) NULL,
    `VeMayBay_ThuHo_PhiKhac` decimal(18,2) NULL,
    `VeMayBay_TienPhi` decimal(18,2) NULL,
    `VeMayBay_ThueSuat` decimal(18,2) NULL,
    `VeMayBay_MaThueSuat` varchar(255) NULL,
    `VeMayBay_TienThue` decimal(18,2) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `Benhvien_Loaidichvu` varchar(255) NULL,
    `Nuoc_HeThongNuoc` varchar(255) NULL,
    `Nuoc_SoDangKy` varchar(255) NULL,
    `Nuoc_MucPhiMoiTruong` int NULL,
    `Nuoc_PhiKhac` decimal(18,2) NULL,
    `HangHai_TenTau` varchar(255) NULL,
    `HangHai_DungTichThanhPhan` varchar(255) NULL,
    `HangHai_LoaiTau` varchar(255) NULL,
    `HangHai_QuyDoi` decimal(18,2) NULL,
    `HangHai_TongTienCoVat_ChuTiengAnh` varchar(255) NULL,
    `HangHai_NgayDen` datetime NULL,
    `HangHai_NgayDi` datetime NULL,
    `XayDung_CongTrinh` varchar(255) NULL,
    `KhachHang_NgaySinh` datetime NULL,
    `DNBan_Tc_Ma` varchar(255) NULL,
    `DNBan_Tc_Ten` varchar(255) NULL,
    `DNBan_Tc_DienThoai` varchar(255) NULL,
    `DNBan_Tc_Fax` varchar(255) NULL,
    `DNBan_Tc_Email` varchar(255) NULL,
    `DNBan_Tc_DiaChi` varchar(255) NULL,
    `DNBan_Tc_TaiKhoan` varchar(255) NULL,
    `DNBan_Tc_NganHang` varchar(255) NULL,
    `DNBan_Tc_Website` varchar(255) NULL,
    `Sp_SoNb` varchar(255) NULL,
    `Sp_SoDdh` varchar(255) NULL,
    `Sp_SoNoiBoXnk` varchar(255) NULL,
    `Sp_NguoiTao_NgayTao` varchar(255) NULL,
    `Sp_SoHopDong` varchar(255) NULL,
    `Sp_TrinhDuocVien` varchar(255) NULL,
    `Sp_NhanVienGiaoHang` varchar(255) NULL,
    `Sp_SoKhoan` varchar(255) NULL,
    `phikhac_tyle` decimal(18,2) NULL,
    `phikhac_sotien` decimal(18,2) NULL,
    `BS_ThongTin_DNMua_01` varchar(255) NULL,
    `BS_ThongTin_DNMua_02` varchar(255) NULL,
    `BS_ThongTin_DNMua_03` varchar(255) NULL,
    `BS_ThongTin_DNMua_04` varchar(255) NULL,
    `BS_ThongTin_DNMua_05` varchar(255) NULL,
    `BS_ThongTin_DNMua_06` varchar(255) NULL,
    `BS_ThongTin_DNMua_07` varchar(255) NULL,
    `BS_ThongTin_DNMua_08` varchar(255) NULL,
    `BS_ThongTin_DNMua_09` varchar(255) NULL,
    `BS_ThongTin_DNMua_10` varchar(255) NULL,
    `BS_ThongTin_DNMua_11` varchar(255) NULL,
    `BS_ThongTin_DNMua_12` varchar(255) NULL,
    `BS_ThongTin_DNMua_13` varchar(255) NULL,
    `DNMua_CCCD` varchar(255) NULL,
    `Nguoihuy` varchar(255) NULL,
    `NgayHuy` datetime NULL,
    `NguoiHuy_Id` int NULL,
    `MaDVQHNS` varchar(255) NULL,
    `SoHoChieu` varchar(255) NULL,
    `SoBangKe` varchar(255) NULL,
    `NgayBangKe` datetime NULL,
    `File_BangKe` varchar(255) NULL
);
