-- Table: vs_bangke_thongbaochitiet
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/BaoCao/BangKe_ThongBaoChiTiet.cs
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
--   BangKeTongHop_Id int NOT NULL -- C# int
--   BangKeChiTiet_Id int NOT NULL -- C# int
--   MaLoi varchar(255) NULL -- C# string
--   MoTaLoi varchar(255) NULL -- C# string
--   HuongDan varchar(255) NULL -- C# string
--   GhiChu varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   KyHieu_MsHoaDon varchar(255) NULL -- C# string
--   KyHieu_HoaDon varchar(255) NULL -- C# string
--   SoHoaDon varchar(255) NULL -- C# string

CREATE TABLE `vs_bangke_thongbaochitiet` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `BangKeTongHop_Id` int NOT NULL,
    `BangKeChiTiet_Id` int NOT NULL,
    `MaLoi` varchar(255) NULL,
    `MoTaLoi` varchar(255) NULL,
    `HuongDan` varchar(255) NULL,
    `GhiChu` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `KyHieu_MsHoaDon` varchar(255) NULL,
    `KyHieu_HoaDon` varchar(255) NULL,
    `SoHoaDon` varchar(255) NULL
);
