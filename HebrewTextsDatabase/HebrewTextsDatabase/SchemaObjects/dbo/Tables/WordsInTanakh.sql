CREATE TABLE [dbo].[WordsInTanakh] (
    [ID]             INT            NOT NULL,
    [Word]           NVARCHAR (50)  NOT NULL,
    [WordWithNiqqud] NVARCHAR (MAX) NOT NULL,
    [VerseID]        INT            NOT NULL,
    [SequenceNumber]     INT            NULL,
    CONSTRAINT [PK_WordsInTanakh] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [OldID]
    ON [dbo].[WordsInTanakh]([ID] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_WordsInTanakh_Word]
    ON [dbo].[WordsInTanakh]([Word] ASC);

