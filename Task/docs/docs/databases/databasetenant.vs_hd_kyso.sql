-- Table: vs_hd_kyso
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_KySo.cs
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
--   DoiTuongKy_Loai int NOT NULL -- C# int
--   DoiTuongKy_MST varchar(255) NULL -- C# string
--   DoiTuongKy_Ten varchar(255) NULL -- C# string
--   Cert_BatDau datetime NULL -- C# DateTime?
--   Cert_KetThuc datetime NULL -- C# DateTime?
--   Cert_DVCungCap varchar(255) NULL -- C# string
--   ChuKy_NgayKy datetime NULL -- C# DateTime?
--   ChuKy_LoaiKiemTra int NOT NULL -- C# int
--   ChuKy_OCSP varchar(255) NULL -- C# string
--   ChuKy_CRL varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_hd_kyso` (
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
    `DoiTuongKy_Loai` int NOT NULL,
    `DoiTuongKy_MST` varchar(255) NULL,
    `DoiTuongKy_Ten` varchar(255) NULL,
    `Cert_BatDau` datetime NULL,
    `Cert_KetThuc` datetime NULL,
    `Cert_DVCungCap` varchar(255) NULL,
    `ChuKy_NgayKy` datetime NULL,
    `ChuKy_LoaiKiemTra` int NOT NULL,
    `ChuKy_OCSP` varchar(255) NULL,
    `ChuKy_CRL` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
