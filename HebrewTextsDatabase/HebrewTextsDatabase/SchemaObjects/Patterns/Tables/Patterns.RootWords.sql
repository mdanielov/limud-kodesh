CREATE TABLE [Patterns].[RootWords]
(
	[RootWordID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [RootWord] NVARCHAR(20) NOT NULL, 
    [Comment] NVARCHAR(MAX) NULL
)

GO

CREATE INDEX [UQ_RootWords_RootWord] ON [Patterns].[RootWords] ([RootWord])

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלת שורשי מילים',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWords'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שורש המילה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWords',
    @level2type = N'COLUMN',
    @level2name = N'RootWord'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הערות',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWords',
    @level2type = N'COLUMN',
    @level2name = N'Comment'