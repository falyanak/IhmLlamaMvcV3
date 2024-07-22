IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Agents] (
    [Id] int NOT NULL IDENTITY,
    [Nom] nvarchar(max) NOT NULL,
    [Prenom] nvarchar(max) NOT NULL,
    [LoginWindows] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Agents] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [IaModels] (
    [Id] int NOT NULL IDENTITY,
    [Libelle] nvarchar(max) NOT NULL,
    [UrlApi] nvarchar(max) NOT NULL,
    [Version] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_IaModels] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Conversations] (
    [Id] int NOT NULL IDENTITY,
    [Intitule] nvarchar(max) NOT NULL,
    [DateCreation] datetime2 NOT NULL,
    [DateFin] datetime2 NULL,
    [ModeleIAId] int NOT NULL,
    [AgentId] int NOT NULL,
    CONSTRAINT [PK_Conversations] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Conversations_Agents_AgentId] FOREIGN KEY ([AgentId]) REFERENCES [Agents] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Conversations_IaModels_ModeleIAId] FOREIGN KEY ([ModeleIAId]) REFERENCES [IaModels] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [Questions] (
    [Id] int NOT NULL IDENTITY,
    [Libelle] nvarchar(max) NOT NULL,
    [ConversationId] int NULL,
    CONSTRAINT [PK_Questions] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Questions_Conversations_ConversationId] FOREIGN KEY ([ConversationId]) REFERENCES [Conversations] ([Id])
);
GO

CREATE TABLE [Reponses] (
    [Id] int NOT NULL,
    [Libelle] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Reponses] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Reponses_Questions_Id] FOREIGN KEY ([Id]) REFERENCES [Questions] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_Conversations_AgentId] ON [Conversations] ([AgentId]);
GO

CREATE INDEX [IX_Conversations_ModeleIAId] ON [Conversations] ([ModeleIAId]);
GO

CREATE INDEX [IX_Questions_ConversationId] ON [Questions] ([ConversationId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240722154343_InitialCreate', N'8.0.7');
GO

COMMIT;
GO

