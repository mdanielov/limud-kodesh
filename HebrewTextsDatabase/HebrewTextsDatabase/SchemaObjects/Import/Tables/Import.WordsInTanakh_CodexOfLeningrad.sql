CREATE TABLE [Import].[WordsInTanakh_CodexOfLeningrad]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY,
	[BookName] NVARCHAR(100),
	[Chapter] INT,
	[Verse] INT, 
	[WordSequence] INT,
	[Word] NVARCHAR(MAX), 
	[WordWithNiqqud] NVARCHAR(MAX), 
	[StartParashaBeforeWord] BIT NULL,
	[EndParashaAfterWord] BIT NULL,
	[IsParashaPtuchah] BIT NULL,
	[KeyWordIndex] NVARCHAR(50) NULL
)


GO 

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מכילה ייבוא של התנ"ך מילה במילה מתוך קודקס אוף לנינגראד',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad';
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שם הספר באנגלית לפי התעתיק הנכון',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'BookName';
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'פרק',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'Chapter'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'פסוק',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'Verse'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מספר מילה',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'WordSequence'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'המילה עצמה ללא ניקוד וללא טעמי המקרא',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'Word'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'המילה עצמה עם ניקוד וטעמי המקרא',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'WordWithNiqqud'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'האם מתחילה פרשה לפני המילה',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'StartParashaBeforeWord'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'האם מסתיימת פרשה אחרי המילה',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'EndParashaAfterWord'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'האם הפרשה שמתחילה לפני המילה היא פרשה פתוחה',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'IsParashaPtuchah'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מפתח המכיל שרשור של שם הספר פרק פסוק ומילה עם הפרדה של נקודה בין אחד לשני לדוגמא הפסוק הראשון בבראשית: Bereshit.1.1.1',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'KeyWordIndex'