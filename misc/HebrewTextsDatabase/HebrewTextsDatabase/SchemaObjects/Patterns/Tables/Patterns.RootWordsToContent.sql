CREATE TABLE [Patterns].[RootWordsToContent]
(
	[RootWordsToContentID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [RootWordID] INT NOT NULL, 
    [MainContentID] BIGINT NOT NULL, 
    [Comment] NVARCHAR(MAX) NULL, 
    CONSTRAINT [FK_RootWordsToContent_ToRootWords] FOREIGN KEY (RootWordID) REFERENCES Patterns.RootWords(RootWordID) ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [FK_RootWordsToContent_ToMainContent] FOREIGN KEY (MainContentID) REFERENCES Contents.MainContent(MainContentID) ON DELETE CASCADE ON UPDATE CASCADE
)


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלת הפניות של שורשים למילים בתנ"ך או בשאר ספרים',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWordsToContent'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הפניה לשורש המילה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWordsToContent',
    @level2type = N'COLUMN',
    @level2name = N'RootWordID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הפניה למילה בתנ"ך או בספר אחר',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWordsToContent',
    @level2type = N'COLUMN',
    @level2name = N'MainContentID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הערות על הפניה זו',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWordsToContent',
    @level2type = N'COLUMN',
    @level2name = N'Comment'