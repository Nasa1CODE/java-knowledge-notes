-- Table: vs_doanhnghiep_cauhinhhienthi
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DoanhNghiep_CauHinhHienThi.cs
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
--   DS_Mau_MauSo bit NULL -- C# bool?
--   DS_Mau_KyHieu bit NULL -- C# bool?
--   DS_Mau_So bit NULL -- C# bool?
--   DS_Mau_NgayLap bit NULL -- C# bool?
--   DS_Mau_NgayKy bit NULL -- C# bool?
--   DS_Mau_NguoiLap bit NULL -- C# bool?
--   DS_Mau_NguoiKy bit NULL -- C# bool?
--   DS_Mau_HopDong_So bit NULL -- C# bool?
--   DS_Mau_HopDong_NgayKy bit NULL -- C# bool?
--   DS_Mau_GhiChu bit NULL -- C# bool?
--   DS_Mau_HoaDon_Loai bit NULL -- C# bool?
--   DS_Mau_HDGoc_Id bit NULL -- C# bool?
--   DS_DNMua_MST bit NULL -- C# bool?
--   DS_DNMua_Ten bit NULL -- C# bool?
--   DS_DNMua_DiaChi bit NULL -- C# bool?
--   DS_ThanhToan_PhuongThuc bit NULL -- C# bool?
--   DS_ThanhToan_TongTien bit NULL -- C# bool?
--   DS_ThanhToan_ThoiHan bit NULL -- C# bool?
--   DS_TongHop_TongTien_ChuaVat bit NULL -- C# bool?
--   DS_TongHop_TongTien_KhoanKhac bit NULL -- C# bool?
--   DS_TongHop_TienThue bit NULL -- C# bool?
--   DS_TongHop_TongTien_CoVat bit NULL -- C# bool?
--   DS_TongHop_NgoaiTe_CoVat bit NULL -- C# bool?
--   DS_TongHop_TongTien_CoVat_Chu bit NULL -- C# bool?
--   DS_QuanLy_TrangThai bit NULL -- C# bool?
--   DS_QuanLy_SoBaoMat bit NULL -- C# bool?
--   CN_ChuyenDoi bit NULL -- C# bool?
--   CN_KyHoaDon bit NULL -- C# bool?
--   CN_The_TrinhKy bit NULL -- C# bool?
--   DS_DNBan_MST bit NULL -- C# bool?
--   DS_DNBan_Ten bit NULL -- C# bool?
--   DS_DNBan_DiaChi bit NULL -- C# bool?
--   DS_DNMua_Tennguoimua bit NULL -- C# bool?
--   DS_Mau_HeThongKhacId varchar(255) NULL -- C# string
--   DS_TrangThai_Gui_TBSS bit NULL -- C# bool?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_doanhnghiep_cauhinhhienthi` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DS_Mau_MauSo` bit NULL,
    `DS_Mau_KyHieu` bit NULL,
    `DS_Mau_So` bit NULL,
    `DS_Mau_NgayLap` bit NULL,
    `DS_Mau_NgayKy` bit NULL,
    `DS_Mau_NguoiLap` bit NULL,
    `DS_Mau_NguoiKy` bit NULL,
    `DS_Mau_HopDong_So` bit NULL,
    `DS_Mau_HopDong_NgayKy` bit NULL,
    `DS_Mau_GhiChu` bit NULL,
    `DS_Mau_HoaDon_Loai` bit NULL,
    `DS_Mau_HDGoc_Id` bit NULL,
    `DS_DNMua_MST` bit NULL,
    `DS_DNMua_Ten` bit NULL,
    `DS_DNMua_DiaChi` bit NULL,
    `DS_ThanhToan_PhuongThuc` bit NULL,
    `DS_ThanhToan_TongTien` bit NULL,
    `DS_ThanhToan_ThoiHan` bit NULL,
    `DS_TongHop_TongTien_ChuaVat` bit NULL,
    `DS_TongHop_TongTien_KhoanKhac` bit NULL,
    `DS_TongHop_TienThue` bit NULL,
    `DS_TongHop_TongTien_CoVat` bit NULL,
    `DS_TongHop_NgoaiTe_CoVat` bit NULL,
    `DS_TongHop_TongTien_CoVat_Chu` bit NULL,
    `DS_QuanLy_TrangThai` bit NULL,
    `DS_QuanLy_SoBaoMat` bit NULL,
    `CN_ChuyenDoi` bit NULL,
    `CN_KyHoaDon` bit NULL,
    `CN_The_TrinhKy` bit NULL,
    `DS_DNBan_MST` bit NULL,
    `DS_DNBan_Ten` bit NULL,
    `DS_DNBan_DiaChi` bit NULL,
    `DS_DNMua_Tennguoimua` bit NULL,
    `DS_Mau_HeThongKhacId` varchar(255) NULL,
    `DS_TrangThai_Gui_TBSS` bit NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
