-- Table: vs_cauhinh_banner
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/CauHinh_Banner.cs
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
--   Name varchar(255) NULL -- C# string
--   Url varchar(255) NULL -- C# string
--   Status bit NULL -- C# bool?
--   Time_Start datetime NULL -- C# DateTime?
--   Time_End datetime NULL -- C# DateTime?
--   Description varchar(255) NULL -- C# string
--   Stt int NULL -- C# int?
--   Type int NULL -- C# int?
--   Number_Display_Session int NULL -- C# int?
--   File_Path varchar(255) NULL -- C# string
--   File_Type varchar(255) NULL -- C# string
--   Creator varchar(255) NULL -- C# string

CREATE TABLE `vs_cauhinh_banner` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Name` varchar(255) NULL,
    `Url` varchar(255) NULL,
    `Status` bit NULL,
    `Time_Start` datetime NULL,
    `Time_End` datetime NULL,
    `Description` varchar(255) NULL,
    `Stt` int NULL,
    `Type` int NULL,
    `Number_Display_Session` int NULL,
    `File_Path` varchar(255) NULL,
    `File_Type` varchar(255) NULL,
    `Creator` varchar(255) NULL
);
