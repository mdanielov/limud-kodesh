CREATE TABLE [Content].[WordLetter_Taam]
(
[WLT_Id] [int] NOT NULL,
[TaamId] [int] NULL,
[WordLetterId] [int] NULL
)
GO
ALTER TABLE [Content].[WordLetter_Taam] ADD CONSTRAINT [PK__WordLett__EFE41DEE444997C1] PRIMARY KEY CLUSTERED  ([WLT_Id])
GO
ALTER TABLE [Content].[WordLetter_Taam] ADD CONSTRAINT [FK_Taam_WordLetterId_WordLetter_Id] FOREIGN KEY ([WordLetterId]) REFERENCES [Content].[WordLetter] ([WordLetterId]) ON DELETE CASCADE
GO
ALTER TABLE [Content].[WordLetter_Taam] ADD CONSTRAINT [FK_TaamId_Taam_Ref_Id] FOREIGN KEY ([TaamId]) REFERENCES [Content].[Taam_Ref] ([TaamId]) ON DELETE CASCADE
GO
