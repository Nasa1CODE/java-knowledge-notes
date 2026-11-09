-- Table: vs_hd_hoso
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/NhapExcel/HD_HoSo.cs
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
--   HoSo_Loai int NOT NULL -- C# int
--   HoSo_TrangThai int NOT NULL -- C# int
--   HoSo_Ma varchar(255) NULL -- C# string
--   HoSo_TienChietKhau decimal(18,2) NOT NULL -- C# decimal
--   HoSo_TienThue decimal(18,2) NOT NULL -- C# decimal
--   HoSo_TongTien_ChuaVAT decimal(18,2) NOT NULL -- C# decimal
--   HoSo_TongTien_CoVAT decimal(18,2) NOT NULL -- C# decimal
--   HoSo_DuongDan varchar(255) NULL -- C# string
--   HoSo_SoLuongHoaDon int NOT NULL -- C# int
--   HoSo_SoLuongChiTiet int NOT NULL -- C# int
--   HoSo_ThongBao varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   ExecutionTime datetime NULL -- C# DateTime?

CREATE TABLE `vs_hd_hoso` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `HoSo_Loai` int NOT NULL,
    `HoSo_TrangThai` int NOT NULL,
    `HoSo_Ma` varchar(255) NULL,
    `HoSo_TienChietKhau` decimal(18,2) NOT NULL,
    `HoSo_TienThue` decimal(18,2) NOT NULL,
    `HoSo_TongTien_ChuaVAT` decimal(18,2) NOT NULL,
    `HoSo_TongTien_CoVAT` decimal(18,2) NOT NULL,
    `HoSo_DuongDan` varchar(255) NULL,
    `HoSo_SoLuongHoaDon` int NOT NULL,
    `HoSo_SoLuongChiTiet` int NOT NULL,
    `HoSo_ThongBao` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `ExecutionTime` datetime NULL
);
