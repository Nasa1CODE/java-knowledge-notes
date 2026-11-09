-- Table: vs_tbss_phanhoi_thongtin
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DanhSachSaiSotPhanHoiThongTin.cs
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
--   TransLogId int NULL -- C# int?
--   TbssId int NULL -- C# int?
--   TCTThongBao_MaLoi varchar(255) NULL -- C# string
--   TCTThongBao_MoTaLoi varchar(255) NULL -- C# string
--   TCTThongBao_HuongDan varchar(255) NULL -- C# string
--   TCTThongBao_GhiChu varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   DoanhNghiep_Mst varchar(255) NULL -- C# string

CREATE TABLE `vs_tbss_phanhoi_thongtin` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TransLogId` int NULL,
    `TbssId` int NULL,
    `TCTThongBao_MaLoi` varchar(255) NULL,
    `TCTThongBao_MoTaLoi` varchar(255) NULL,
    `TCTThongBao_HuongDan` varchar(255) NULL,
    `TCTThongBao_GhiChu` varchar(255) NULL,
    `TenantId` int NULL,
    `DoanhNghiep_Mst` varchar(255) NULL
);
