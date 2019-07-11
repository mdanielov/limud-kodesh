CREATE TABLE [dbo].[DistinctWords] (
    [ID]   INT           IDENTITY (1, 1) NOT NULL,
    [Word] NVARCHAR (50) NULL,
    CONSTRAINT [PK_DistinctWords] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_DistinctWords_Word]
    ON [dbo].[DistinctWords]([Word] ASC);

