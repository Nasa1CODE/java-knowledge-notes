-- Table: appchatmessages
-- Database scope: host
-- Source: BE/aspnet-core/src/zero/VS.Core/Chat/ChatMessage.cs
--
-- Fields inferred from C# entity properties. Verify exact SQL types, lengths, indexes, and constraints against real migrations/schema before deployment.
-- Fields:
--   Id int NOT NULL -- inherited Entity key
--   UserId bigint NOT NULL -- C# long
--   TenantId int NULL -- C# int?
--   TargetUserId bigint NOT NULL -- C# long
--   TargetTenantId int NULL -- C# int?
--   Message varchar(255) NULL -- C# string
--   CreationTime datetime NOT NULL -- C# DateTime
--   Side text NOT NULL -- C# ChatSide
--   SharedMessageId char(36) NULL -- C# Guid?

CREATE TABLE `appchatmessages` (
    `Id` int NOT NULL,
    `UserId` bigint NOT NULL,
    `TenantId` int NULL,
    `TargetUserId` bigint NOT NULL,
    `TargetTenantId` int NULL,
    `Message` varchar(255) NULL,
    `CreationTime` datetime NOT NULL,
    `Side` text NOT NULL,
    `SharedMessageId` char(36) NULL
);
