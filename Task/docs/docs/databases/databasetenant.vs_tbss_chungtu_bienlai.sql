-- Table: vs_tbss_chungtu_bienlai
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/ChungTu/ThongBaoSaiSot_ChungTu_BienLai.cs
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
--   Tbss_Loai int NULL -- C# int?
--   Tbss_NgayLap datetime NULL -- C# DateTime?
--   Tbss_TrangThai int NULL -- C# int?
--   TenantId int NULL -- C# int?
--   Tbss_FilePath_Xml varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   DoanhNghiep_Ten varchar(255) NULL -- C# string
--   DoanhNghiep_KySo varchar(255) NULL -- C# string
--   DoanhNghiep_NgayKy datetime NULL -- C# DateTime?
--   ErrorCode varchar(255) NULL -- C# string
--   ErrorDescription varchar(255) NULL -- C# string
--   FilePath_Xml_Cqt varchar(255) NULL -- C# string
--   SoThongBao varchar(255) NULL -- C# string
--   NgayThongBao datetime NULL -- C# DateTime?

CREATE TABLE `vs_tbss_chungtu_bienlai` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Tbss_Loai` int NULL,
    `Tbss_NgayLap` datetime NULL,
    `Tbss_TrangThai` int NULL,
    `TenantId` int NULL,
    `Tbss_FilePath_Xml` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `DoanhNghiep_Ten` varchar(255) NULL,
    `DoanhNghiep_KySo` varchar(255) NULL,
    `DoanhNghiep_NgayKy` datetime NULL,
    `ErrorCode` varchar(255) NULL,
    `ErrorDescription` varchar(255) NULL,
    `FilePath_Xml_Cqt` varchar(255) NULL,
    `SoThongBao` varchar(255) NULL,
    `NgayThongBao` datetime NULL
);
