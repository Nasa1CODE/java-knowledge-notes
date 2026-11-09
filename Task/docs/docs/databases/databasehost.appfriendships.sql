-- Table: appfriendships
-- Database scope: host
-- Source: BE/aspnet-core/src/zero/VS.Core/Friendships/Friendship.cs
--
-- Fields inferred from C# entity properties. Verify exact SQL types, lengths, indexes, and constraints against real migrations/schema before deployment.
-- Fields:
--   Id int NOT NULL -- inherited Entity key
--   UserId bigint NOT NULL -- C# long
--   TenantId int NULL -- C# int?
--   FriendUserId bigint NOT NULL -- C# long
--   FriendTenantId int NULL -- C# int?
--   FriendUserName varchar(255) NULL -- C# string
--   FriendTenancyName varchar(255) NULL -- C# string
--   FriendProfilePictureId char(36) NULL -- C# Guid?
--   State text NOT NULL -- C# FriendshipState
--   CreationTime datetime NOT NULL -- C# DateTime

CREATE TABLE `appfriendships` (
    `Id` int NOT NULL,
    `UserId` bigint NOT NULL,
    `TenantId` int NULL,
    `FriendUserId` bigint NOT NULL,
    `FriendTenantId` int NULL,
    `FriendUserName` varchar(255) NULL,
    `FriendTenancyName` varchar(255) NULL,
    `FriendProfilePictureId` char(36) NULL,
    `State` text NOT NULL,
    `CreationTime` datetime NOT NULL
);
