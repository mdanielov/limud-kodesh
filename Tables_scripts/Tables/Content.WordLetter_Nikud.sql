CREATE TABLE [Content].[WordLetter_Nikud]
(
[WLN_Id] [int] NOT NULL,
[NikudId] [int] NULL,
[WordLetterId] [int] NULL
)
GO
ALTER TABLE [Content].[WordLetter_Nikud] ADD CONSTRAINT [PK__WordLett__23B86CE6ECA69161] PRIMARY KEY CLUSTERED  ([WLN_Id])
GO
ALTER TABLE [Content].[WordLetter_Nikud] ADD CONSTRAINT [FK_NikudId_Nikud_Ref_Id] FOREIGN KEY ([NikudId]) REFERENCES [Content].[Nikud_Ref] ([NikudId]) ON DELETE CASCADE
GO
ALTER TABLE [Content].[WordLetter_Nikud] ADD CONSTRAINT [FK_WordLetterId_WordLetter_Id] FOREIGN KEY ([WordLetterId]) REFERENCES [Content].[WordLetter] ([WordLetterId]) ON DELETE CASCADE
GO
