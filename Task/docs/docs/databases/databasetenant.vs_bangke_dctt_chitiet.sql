-- Table: vs_bangke_dctt_chitiet
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/BangKeDCTT/BangKe_DCTT_ChiTiet.cs
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
--   TenantId int NULL -- C# int?
--   ThhDVGoc varchar(255) NULL -- C# string
--   Slgoc decimal(18,2) NULL -- C# decimal?
--   Dggoc decimal(18,2) NULL -- C# decimal?
--   Thtgoc decimal(18,2) NULL -- C# decimal?
--   Tsgoc int NULL -- C# int?
--   TTgoc decimal(18,2) NULL -- C# decimal?
--   Tgtkgoc decimal(18,2) NULL -- C# decimal?
--   TgTSTGoc decimal(18,2) NULL -- C# decimal?
--   Mau_KyHieu varchar(255) NULL -- C# string
--   Mau_MauSo varchar(255) NULL -- C# string
--   Mau_So varchar(255) NULL -- C# string
--   HoaDonGoc_Id int NULL -- C# int?
--   ThhDvtDoi varchar(255) NULL -- C# string
--   Sltdoi decimal(18,2) NULL -- C# decimal?
--   Dgtdoi decimal(18,2) NULL -- C# decimal?
--   Thttdoi decimal(18,2) NULL -- C# decimal?
--   TstDoi int NULL -- C# int?
--   TTTDoi decimal(18,2) NULL -- C# decimal?
--   Tgttdoi decimal(18,2) NULL -- C# decimal?
--   TgTSTTDoi decimal(18,2) NULL -- C# decimal?
--   TgTCTCLech decimal(18,2) NULL -- C# decimal?
--   TgTTCLech decimal(18,2) NULL -- C# decimal?
--   TgTKCLech decimal(18,2) NULL -- C# decimal?
--   TgTTTCLech decimal(18,2) NULL -- C# decimal?
--   BangKe_Id int NULL -- C# int?
--   DonViTinh_Ten varchar(255) NULL -- C# string
--   HangHoa_Loai int NULL -- C# int?
--   HangHoa_Loai_Doi int NULL -- C# int?

CREATE TABLE `vs_bangke_dctt_chitiet` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TenantId` int NULL,
    `ThhDVGoc` varchar(255) NULL,
    `Slgoc` decimal(18,2) NULL,
    `Dggoc` decimal(18,2) NULL,
    `Thtgoc` decimal(18,2) NULL,
    `Tsgoc` int NULL,
    `TTgoc` decimal(18,2) NULL,
    `Tgtkgoc` decimal(18,2) NULL,
    `TgTSTGoc` decimal(18,2) NULL,
    `Mau_KyHieu` varchar(255) NULL,
    `Mau_MauSo` varchar(255) NULL,
    `Mau_So` varchar(255) NULL,
    `HoaDonGoc_Id` int NULL,
    `ThhDvtDoi` varchar(255) NULL,
    `Sltdoi` decimal(18,2) NULL,
    `Dgtdoi` decimal(18,2) NULL,
    `Thttdoi` decimal(18,2) NULL,
    `TstDoi` int NULL,
    `TTTDoi` decimal(18,2) NULL,
    `Tgttdoi` decimal(18,2) NULL,
    `TgTSTTDoi` decimal(18,2) NULL,
    `TgTCTCLech` decimal(18,2) NULL,
    `TgTTCLech` decimal(18,2) NULL,
    `TgTKCLech` decimal(18,2) NULL,
    `TgTTTCLech` decimal(18,2) NULL,
    `BangKe_Id` int NULL,
    `DonViTinh_Ten` varchar(255) NULL,
    `HangHoa_Loai` int NULL,
    `HangHoa_Loai_Doi` int NULL
);
