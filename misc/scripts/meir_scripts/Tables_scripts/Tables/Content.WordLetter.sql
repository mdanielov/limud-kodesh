CREATE TABLE [Content].[WordLetter]
(
[WordLetterId] [int] NOT NULL,
[LetterRefId] [int] NULL,
[SequenceId] [int] NULL,
[WordId] [int] NULL
)
GO
ALTER TABLE [Content].[WordLetter] ADD CONSTRAINT [PK__WordLett__BFAD4C0322A78527] PRIMARY KEY CLUSTERED  ([WordLetterId])
GO
ALTER TABLE [Content].[WordLetter] ADD CONSTRAINT [FK_LetterRefId_Letter_Ref_Id] FOREIGN KEY ([LetterRefId]) REFERENCES [Content].[Letter_Ref] ([LetterId]) ON DELETE CASCADE
GO
