-- Table: vs_dm_ncc_smstemplate
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_SmsTemplate.cs
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
--   Sms_Loai int NOT NULL -- C# int
--   Sms_Ten varchar(255) NULL -- C# string
--   Sms_NoiDung varchar(255) NULL -- C# string
--   Sms_HieuLuc bit NULL -- C# bool?
--   Sms_BatDau datetime NULL -- C# DateTime?
--   Sms_KetThuc datetime NULL -- C# DateTime?
--   DaiLy_Id int NULL -- C# int?

CREATE TABLE `vs_dm_ncc_smstemplate` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Sms_Loai` int NOT NULL,
    `Sms_Ten` varchar(255) NULL,
    `Sms_NoiDung` varchar(255) NULL,
    `Sms_HieuLuc` bit NULL,
    `Sms_BatDau` datetime NULL,
    `Sms_KetThuc` datetime NULL,
    `DaiLy_Id` int NULL
);
