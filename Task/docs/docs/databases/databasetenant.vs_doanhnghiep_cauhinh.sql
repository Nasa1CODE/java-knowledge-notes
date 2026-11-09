-- Table: vs_doanhnghiep_cauhinh
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DoanhNghiep_CauHinh.cs
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
--   Tien_LamTron int NULL -- C# int?
--   GuiEmail_TuDong bit NULL -- C# bool?
--   GuiEmail_TuDongHoaDonHuy bit NULL -- C# bool?
--   NgayLap_NgayKy int NULL -- C# int?
--   HanThanhToan int NULL -- C# int?
--   KyGuiWs int NULL -- C# int?
--   ChietKhau_ChiTiet int NULL -- C# int?
--   NhieuChungThuSo bit NULL -- C# bool?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   IsLamTron_TienCuoi bit NULL -- C# bool?
--   IsChange_ThueSuat bit NULL -- C# bool?
--   TuDongGui_Sms int NULL -- C# int?
--   QuyDoiNgoaiTe_Vnd bit NULL -- C# bool?
--   Mail_SoLanGui int NULL -- C# int?
--   ThueSuat_TienCuoi bit NULL -- C# bool?
--   IsAutoCreateLookupAccount bit NULL -- C# bool?
--   HienThiPhiKhac bit NULL -- C# bool?
--   GuiEmail_ChungTuKy bit NULL -- C# bool?
--   GuiEmail_ChungTuHuy bit NULL -- C# bool?
--   TimeAutoSendPos varchar(255) NULL -- C# string
--   AutoCapSoPos int NULL -- C# int?
--   ChungTu_NgayKy int NULL -- C# int?
--   ChungTuTruong varchar(255) NULL -- C# string
--   Pmbh_GuiMaCoQuan bit NULL -- C# bool?
--   Cauhinh_Hienthitbss bit NULL -- C# bool?
--   Cauhinh_ThueSuat int NULL -- C# int?
--   IsThueSuat bit NULL -- C# bool?
--   KyTu_SoHoaDonExcel int NULL -- C# int?
--   Number_CQT int NULL -- C# int?
--   IsSetting_CQT bit NULL -- C# bool?
--   GuiEmail_BangKeDCTT bit NULL -- C# bool?

CREATE TABLE `vs_doanhnghiep_cauhinh` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Tien_LamTron` int NULL,
    `GuiEmail_TuDong` bit NULL,
    `GuiEmail_TuDongHoaDonHuy` bit NULL,
    `NgayLap_NgayKy` int NULL,
    `HanThanhToan` int NULL,
    `KyGuiWs` int NULL,
    `ChietKhau_ChiTiet` int NULL,
    `NhieuChungThuSo` bit NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `IsLamTron_TienCuoi` bit NULL,
    `IsChange_ThueSuat` bit NULL,
    `TuDongGui_Sms` int NULL,
    `QuyDoiNgoaiTe_Vnd` bit NULL,
    `Mail_SoLanGui` int NULL,
    `ThueSuat_TienCuoi` bit NULL,
    `IsAutoCreateLookupAccount` bit NULL,
    `HienThiPhiKhac` bit NULL,
    `GuiEmail_ChungTuKy` bit NULL,
    `GuiEmail_ChungTuHuy` bit NULL,
    `TimeAutoSendPos` varchar(255) NULL,
    `AutoCapSoPos` int NULL,
    `ChungTu_NgayKy` int NULL,
    `ChungTuTruong` varchar(255) NULL,
    `Pmbh_GuiMaCoQuan` bit NULL,
    `Cauhinh_Hienthitbss` bit NULL,
    `Cauhinh_ThueSuat` int NULL,
    `IsThueSuat` bit NULL,
    `KyTu_SoHoaDonExcel` int NULL,
    `Number_CQT` int NULL,
    `IsSetting_CQT` bit NULL,
    `GuiEmail_BangKeDCTT` bit NULL
);
