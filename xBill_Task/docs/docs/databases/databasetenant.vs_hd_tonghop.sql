-- Table: vs_hd_tonghop
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_HoaDon.cs
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
--   Mau_HinhThucNhap int NOT NULL -- C# int
--   Mau_HeThongKhacId varchar(255) NULL -- C# string
--   Mau_LoaiHoaDon_Ma varchar(255) NULL -- C# string
--   Mau_Loai_HD_DacThu varchar(255) NULL -- C# string
--   Mau_HDMau_Id int NOT NULL -- C# int
--   Mau_HDMau_Ma varchar(255) NULL -- C# string
--   Mau_MauSo varchar(255) NULL -- C# string
--   Mau_KyHieu varchar(255) NULL -- C# string
--   Mau_So varchar(255) NULL -- C# string
--   Mau_Ten varchar(255) NULL -- C# string
--   Mau_NgayLap datetime NOT NULL -- C# DateTime
--   Mau_NgayKy datetime NULL -- C# DateTime?
--   KhachHang_Ma varchar(255) NULL -- C# string
--   Mau_NguoiLap varchar(255) NULL -- C# string
--   Mau_NguoiKy varchar(255) NULL -- C# string
--   Mau_NguoiLap_UserId bigint NULL -- C# long?
--   Mau_NguoiKy_UserId bigint NULL -- C# long?
--   Mau_Matoken varchar(255) NULL -- C# string
--   Mau_MaXacThuc_NgayGui datetime NULL -- C# DateTime?
--   Mau_HopDong_So varchar(255) NULL -- C# string
--   Mau_HopDong_NgayKy datetime NULL -- C# DateTime?
--   Mau_TienTe_Ma varchar(255) NULL -- C# string
--   Mau_TyGiaNgoaiTe varchar(255) NULL -- C# string
--   Mau_GhiChu varchar(255) NULL -- C# string
--   Mau_HoaDon_Loai int NOT NULL -- C# int
--   Mau_HDGoc_Id int NULL -- C# int?
--   Mau_HDThayDoi_MoTa varchar(255) NULL -- C# string
--   Mau_HDThayDoi_Ngay datetime NULL -- C# DateTime?
--   DNBan_MST varchar(255) NULL -- C# string
--   DNBan_Ten varchar(255) NULL -- C# string
--   DNBan_DiaChi varchar(255) NULL -- C# string
--   DNBan_MaBuuDien varchar(255) NULL -- C# string
--   DNBan_QuanHuyen_Ten varchar(255) NULL -- C# string
--   DNBan_TinhThanh_Ten varchar(255) NULL -- C# string
--   DNBan_QuocGia varchar(255) NULL -- C# string
--   DNBan_SDT varchar(255) NULL -- C# string
--   DNBan_FAX varchar(255) NULL -- C# string
--   DNBan_Email varchar(255) NULL -- C# string
--   DNBan_NganHang_TaiKhoan varchar(255) NULL -- C# string
--   DNBan_NganHang_TruSo varchar(255) NULL -- C# string
--   DNBan_NguoiDaiDien varchar(255) NULL -- C# string
--   DNBan_NguoiKy varchar(255) NULL -- C# string
--   DNBan_NguoiGui varchar(255) NULL -- C# string
--   DNBan_Website varchar(255) NULL -- C# string
--   DNMua_TenNguoiMua varchar(255) NULL -- C# string
--   DNMua_Ten varchar(255) NULL -- C# string
--   DNMua_MST varchar(255) NULL -- C# string
--   DNMua_DiaChi varchar(255) NULL -- C# string
--   DNMua_DiaChiGiaoHang varchar(255) NULL -- C# string
--   DNMua_MaBuuDien varchar(255) NULL -- C# string
--   DNMua_QuanHuyen_Ten varchar(255) NULL -- C# string
--   DNMua_TinhThanh_Ten varchar(255) NULL -- C# string
--   DNMua_QuocGia varchar(255) NULL -- C# string
--   DNMua_SDT varchar(255) NULL -- C# string
--   DNMua_Fax varchar(255) NULL -- C# string
--   DNMua_Email varchar(255) NULL -- C# string
--   DNMua_NganHang_TaiKhoan varchar(255) NULL -- C# string
--   DNMua_NganHang_TruSo varchar(255) NULL -- C# string
--   DNMua_TrangThaiKy int NULL -- C# int?
--   DNMua_NguoiKy varchar(255) NULL -- C# string
--   DNMua_NgayKy datetime NULL -- C# DateTime?
--   ThanhToan_PhuongThuc int NOT NULL -- C# int
--   ThanhToan_PhuongThuc_Ten varchar(255) NULL -- C# string
--   ThanhToan_GhiChu varchar(255) NULL -- C# string
--   ThanhToan_TongTien decimal(18,2) NULL -- C# decimal?
--   ThanhToan_ThoiHan datetime NULL -- C# DateTime?
--   ThanhToan_DieuKhoan varchar(255) NULL -- C# string
--   ThanhToan_NganHang varchar(255) NULL -- C# string
--   ThanhToan_TaiKhoan varchar(255) NULL -- C# string
--   VanChuyen_So varchar(255) NULL -- C# string
--   VanChuyen_NgayXuat datetime NULL -- C# DateTime?
--   VanChuyen_DieuDong varchar(255) NULL -- C# string
--   VanChuyen_GiaoHang varchar(255) NULL -- C# string
--   VanChuyen_KhoXuat varchar(255) NULL -- C# string
--   VanChuyen_KhoNhap varchar(255) NULL -- C# string
--   VanChuyen_PhuongThuc varchar(255) NULL -- C# string
--   VanChuyen_LyDo varchar(255) NULL -- C# string
--   VanChuyen_Lenh varchar(255) NULL -- C# string
--   TongHop_TongTien_ChuaVAT decimal(18,2) NOT NULL -- C# decimal
--   TongHop_TongTien_KhoanKhac decimal(18,2) NULL -- C# decimal?
--   TongHop_TienThue decimal(18,2) NOT NULL -- C# decimal
--   TongHop_TongTien_CoVAT decimal(18,2) NOT NULL -- C# decimal
--   TongHop_NgoaiTe_CoVAT decimal(18,2) NULL -- C# decimal?
--   TongHop_TongTien_ChietKhau_ThuongMai decimal(18,2) NULL -- C# decimal?
--   TongHop_TongTien_CoVAT_Chu varchar(255) NULL -- C# string
--   TongHop_TongTien_ChuaVAT_TangGiam bit NULL -- C# bool?
--   TongHop_TongTien_CoVAT_TangGiam bit NULL -- C# bool?
--   TongHop_TienThue_TangGiam bit NULL -- C# bool?
--   TongHop_TongTien_KhoanKhac_TangGiam bit NULL -- C# bool?
--   TCT_DNBan_MST varchar(255) NULL -- C# string
--   TCT_DNMua_MST varchar(255) NULL -- C# string
--   TCT_TongTien_CoVat decimal(18,2) NULL -- C# decimal?
--   TCT_TienThue decimal(18,2) NULL -- C# decimal?
--   TCT_NgayXuat datetime NULL -- C# DateTime?
--   TCT_Hash varchar(255) NULL -- C# string
--   TCT_SoXacThuc_HDGoc varchar(255) NULL -- C# string
--   TCT_SoXacThuc varchar(255) NULL -- C# string
--   TCT_PSD_ChuKy varchar(255) NULL -- C# string
--   TCT_PSD_Khoa varchar(255) NULL -- C# string
--   VAN_QRCode varchar(255) NULL -- C# string
--   TCT_MaHoaDon varchar(255) NULL -- C# string
--   VAN_Ma varchar(255) NULL -- C# string
--   VAN_CoQuanThue_Ma varchar(255) NULL -- C# string
--   QuanLy_TBPH_So varchar(255) NULL -- C# string
--   QuanLy_DieuChinh_Loai int NULL -- C# int?
--   QuanLy_XacThuc_Loai int NULL -- C# int?
--   QuanLy_ChuyenDoi bit NULL -- C# bool?
--   QuanLy_ChuyenDoi_NguoiChuyenDoi varchar(255) NULL -- C# string
--   QuanLy_ChuyenDoi_Ngay datetime NULL -- C# DateTime?
--   QuanLy_GiuSo int NULL -- C# int?
--   QuanLy_TrangThai int NOT NULL -- C# int
--   QuanLy_TrangThai_Thue int NOT NULL -- C# int
--   QuanLy_Thue_NgayGui datetime NULL -- C# DateTime?
--   QuanLy_Thue_NgayCapMa datetime NULL -- C# DateTime?
--   QuanLy_Thue_MaLoi varchar(255) NULL -- C# string
--   QuanLy_KySo_NguoiMua int NULL -- C# int?
--   QuanLy_KySo_NguoiBan int NULL -- C# int?
--   QuanLy_KySo_VAN int NULL -- C# int?
--   QuanLy_GuiEmail int NULL -- C# int?
--   QuanLy_GuiEmail_LanDau datetime NULL -- C# DateTime?
--   QuanLy_VanBanThoaThuan varchar(255) NULL -- C# string
--   QuanLy_VanBan_Id int NULL -- C# int?
--   QuanLy_FileXPS varchar(255) NULL -- C# string
--   QuanLy_FileXML varchar(255) NULL -- C# string
--   QuanLy_FileXML_HDPos varchar(255) NULL -- C# string
--   QuanLy_FileXml_Thue varchar(255) NULL -- C# string
--   QuanLy_FileXML_Version varchar(255) NULL -- C# string
--   QuanLy_FileXSLT varchar(255) NULL -- C# string
--   QuanLy_FileLogo varchar(255) NULL -- C# string
--   QuanLy_FileHinhNen varchar(255) NULL -- C# string
--   Mau_HDKhacGoc_Id int NULL -- C# int?
--   IsExtendData bit NULL -- C# bool?
--   MaTraCuu_Khac varchar(255) NULL -- C# string
--   HoSoId int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   DNban_ThongTin_BoSung varchar(255) NULL -- C# string
--   LoaiHoaDon406 int NULL -- C# int?
--   KhuPhiThueQuan bit NULL -- C# bool?

CREATE TABLE `vs_hd_tonghop` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Mau_HinhThucNhap` int NOT NULL,
    `Mau_HeThongKhacId` varchar(255) NULL,
    `Mau_LoaiHoaDon_Ma` varchar(255) NULL,
    `Mau_Loai_HD_DacThu` varchar(255) NULL,
    `Mau_HDMau_Id` int NOT NULL,
    `Mau_HDMau_Ma` varchar(255) NULL,
    `Mau_MauSo` varchar(255) NULL,
    `Mau_KyHieu` varchar(255) NULL,
    `Mau_So` varchar(255) NULL,
    `Mau_Ten` varchar(255) NULL,
    `Mau_NgayLap` datetime NOT NULL,
    `Mau_NgayKy` datetime NULL,
    `KhachHang_Ma` varchar(255) NULL,
    `Mau_NguoiLap` varchar(255) NULL,
    `Mau_NguoiKy` varchar(255) NULL,
    `Mau_NguoiLap_UserId` bigint NULL,
    `Mau_NguoiKy_UserId` bigint NULL,
    `Mau_Matoken` varchar(255) NULL,
    `Mau_MaXacThuc_NgayGui` datetime NULL,
    `Mau_HopDong_So` varchar(255) NULL,
    `Mau_HopDong_NgayKy` datetime NULL,
    `Mau_TienTe_Ma` varchar(255) NULL,
    `Mau_TyGiaNgoaiTe` varchar(255) NULL,
    `Mau_GhiChu` varchar(255) NULL,
    `Mau_HoaDon_Loai` int NOT NULL,
    `Mau_HDGoc_Id` int NULL,
    `Mau_HDThayDoi_MoTa` varchar(255) NULL,
    `Mau_HDThayDoi_Ngay` datetime NULL,
    `DNBan_MST` varchar(255) NULL,
    `DNBan_Ten` varchar(255) NULL,
    `DNBan_DiaChi` varchar(255) NULL,
    `DNBan_MaBuuDien` varchar(255) NULL,
    `DNBan_QuanHuyen_Ten` varchar(255) NULL,
    `DNBan_TinhThanh_Ten` varchar(255) NULL,
    `DNBan_QuocGia` varchar(255) NULL,
    `DNBan_SDT` varchar(255) NULL,
    `DNBan_FAX` varchar(255) NULL,
    `DNBan_Email` varchar(255) NULL,
    `DNBan_NganHang_TaiKhoan` varchar(255) NULL,
    `DNBan_NganHang_TruSo` varchar(255) NULL,
    `DNBan_NguoiDaiDien` varchar(255) NULL,
    `DNBan_NguoiKy` varchar(255) NULL,
    `DNBan_NguoiGui` varchar(255) NULL,
    `DNBan_Website` varchar(255) NULL,
    `DNMua_TenNguoiMua` varchar(255) NULL,
    `DNMua_Ten` varchar(255) NULL,
    `DNMua_MST` varchar(255) NULL,
    `DNMua_DiaChi` varchar(255) NULL,
    `DNMua_DiaChiGiaoHang` varchar(255) NULL,
    `DNMua_MaBuuDien` varchar(255) NULL,
    `DNMua_QuanHuyen_Ten` varchar(255) NULL,
    `DNMua_TinhThanh_Ten` varchar(255) NULL,
    `DNMua_QuocGia` varchar(255) NULL,
    `DNMua_SDT` varchar(255) NULL,
    `DNMua_Fax` varchar(255) NULL,
    `DNMua_Email` varchar(255) NULL,
    `DNMua_NganHang_TaiKhoan` varchar(255) NULL,
    `DNMua_NganHang_TruSo` varchar(255) NULL,
    `DNMua_TrangThaiKy` int NULL,
    `DNMua_NguoiKy` varchar(255) NULL,
    `DNMua_NgayKy` datetime NULL,
    `ThanhToan_PhuongThuc` int NOT NULL,
    `ThanhToan_PhuongThuc_Ten` varchar(255) NULL,
    `ThanhToan_GhiChu` varchar(255) NULL,
    `ThanhToan_TongTien` decimal(18,2) NULL,
    `ThanhToan_ThoiHan` datetime NULL,
    `ThanhToan_DieuKhoan` varchar(255) NULL,
    `ThanhToan_NganHang` varchar(255) NULL,
    `ThanhToan_TaiKhoan` varchar(255) NULL,
    `VanChuyen_So` varchar(255) NULL,
    `VanChuyen_NgayXuat` datetime NULL,
    `VanChuyen_DieuDong` varchar(255) NULL,
    `VanChuyen_GiaoHang` varchar(255) NULL,
    `VanChuyen_KhoXuat` varchar(255) NULL,
    `VanChuyen_KhoNhap` varchar(255) NULL,
    `VanChuyen_PhuongThuc` varchar(255) NULL,
    `VanChuyen_LyDo` varchar(255) NULL,
    `VanChuyen_Lenh` varchar(255) NULL,
    `TongHop_TongTien_ChuaVAT` decimal(18,2) NOT NULL,
    `TongHop_TongTien_KhoanKhac` decimal(18,2) NULL,
    `TongHop_TienThue` decimal(18,2) NOT NULL,
    `TongHop_TongTien_CoVAT` decimal(18,2) NOT NULL,
    `TongHop_NgoaiTe_CoVAT` decimal(18,2) NULL,
    `TongHop_TongTien_ChietKhau_ThuongMai` decimal(18,2) NULL,
    `TongHop_TongTien_CoVAT_Chu` varchar(255) NULL,
    `TongHop_TongTien_ChuaVAT_TangGiam` bit NULL,
    `TongHop_TongTien_CoVAT_TangGiam` bit NULL,
    `TongHop_TienThue_TangGiam` bit NULL,
    `TongHop_TongTien_KhoanKhac_TangGiam` bit NULL,
    `TCT_DNBan_MST` varchar(255) NULL,
    `TCT_DNMua_MST` varchar(255) NULL,
    `TCT_TongTien_CoVat` decimal(18,2) NULL,
    `TCT_TienThue` decimal(18,2) NULL,
    `TCT_NgayXuat` datetime NULL,
    `TCT_Hash` varchar(255) NULL,
    `TCT_SoXacThuc_HDGoc` varchar(255) NULL,
    `TCT_SoXacThuc` varchar(255) NULL,
    `TCT_PSD_ChuKy` varchar(255) NULL,
    `TCT_PSD_Khoa` varchar(255) NULL,
    `VAN_QRCode` varchar(255) NULL,
    `TCT_MaHoaDon` varchar(255) NULL,
    `VAN_Ma` varchar(255) NULL,
    `VAN_CoQuanThue_Ma` varchar(255) NULL,
    `QuanLy_TBPH_So` varchar(255) NULL,
    `QuanLy_DieuChinh_Loai` int NULL,
    `QuanLy_XacThuc_Loai` int NULL,
    `QuanLy_ChuyenDoi` bit NULL,
    `QuanLy_ChuyenDoi_NguoiChuyenDoi` varchar(255) NULL,
    `QuanLy_ChuyenDoi_Ngay` datetime NULL,
    `QuanLy_GiuSo` int NULL,
    `QuanLy_TrangThai` int NOT NULL,
    `QuanLy_TrangThai_Thue` int NOT NULL,
    `QuanLy_Thue_NgayGui` datetime NULL,
    `QuanLy_Thue_NgayCapMa` datetime NULL,
    `QuanLy_Thue_MaLoi` varchar(255) NULL,
    `QuanLy_KySo_NguoiMua` int NULL,
    `QuanLy_KySo_NguoiBan` int NULL,
    `QuanLy_KySo_VAN` int NULL,
    `QuanLy_GuiEmail` int NULL,
    `QuanLy_GuiEmail_LanDau` datetime NULL,
    `QuanLy_VanBanThoaThuan` varchar(255) NULL,
    `QuanLy_VanBan_Id` int NULL,
    `QuanLy_FileXPS` varchar(255) NULL,
    `QuanLy_FileXML` varchar(255) NULL,
    `QuanLy_FileXML_HDPos` varchar(255) NULL,
    `QuanLy_FileXml_Thue` varchar(255) NULL,
    `QuanLy_FileXML_Version` varchar(255) NULL,
    `QuanLy_FileXSLT` varchar(255) NULL,
    `QuanLy_FileLogo` varchar(255) NULL,
    `QuanLy_FileHinhNen` varchar(255) NULL,
    `Mau_HDKhacGoc_Id` int NULL,
    `IsExtendData` bit NULL,
    `MaTraCuu_Khac` varchar(255) NULL,
    `HoSoId` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `DNban_ThongTin_BoSung` varchar(255) NULL,
    `LoaiHoaDon406` int NULL,
    `KhuPhiThueQuan` bit NULL
);
