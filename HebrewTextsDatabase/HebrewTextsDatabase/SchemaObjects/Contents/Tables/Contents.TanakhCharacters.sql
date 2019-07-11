CREATE TABLE [Contents].[TanakhCharacters]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [MainContentID] BIGINT NOT NULL,
    [SequenceNumber] INT NOT NULL, 
    [LetterID] INT NOT NULL, 
    [NiqqudID] INT NULL, 
    [TaamID] INT NULL, 
    CONSTRAINT [FK_TanakhCharacters_ToMainContent] FOREIGN KEY (MainContentID) REFERENCES Contents.MainContent([MainContentID]) ON DELETE CASCADE ON UPDATE CASCADE,
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הפניה למילה המקורית בטבלת התוכן הראשי',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'TanakhCharacters',
    @level2type = N'COLUMN',
    @level2name = N'MainContentID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'אות הפניה לטבלת: [Contents].[Letters_Ref]',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'TanakhCharacters',
    @level2type = N'COLUMN',
    @level2name = N'LetterID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ניקוד הפנייה לטבלת: [Contents].[Niqqud_Ref]',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'TanakhCharacters',
    @level2type = N'COLUMN',
    @level2name = N'NiqqudID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טעם הפנייה לטבלת: [dbo].[Taamim_Ref]',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'TanakhCharacters',
    @level2type = N'COLUMN',
    @level2name = N'TaamID'