CREATE TABLE [Import].[WordsInTanakh_CodexOfLeningrad] (
    [ID]                     INT            IDENTITY (1, 1) NOT NULL,
    [BookName]               NVARCHAR (100) NULL,
    [Chapter]                INT            NULL,
    [Verse]                  INT            NULL,
    [WordSequence]           INT            NULL,
    [Word]                   NVARCHAR (MAX) NULL,
    [WordWithNiqqud]         NVARCHAR (MAX) NULL,
    [StartParashaBeforeWord] BIT            NULL,
    [EndParashaAfterWord]    BIT            NULL,
    [IsParashaPtuchah]       BIT            NULL,
    [KeyWordIndex]           NVARCHAR (50)  NULL,
    [IsKri] BIT NULL, 
    [IsKtiv] BIT NULL, 
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'מפתח המכיל שרשור של שם הספר פרק פסוק ומילה עם הפרדה של נקודה בין אחד לשני לדוגמא הפסוק הראשון בבראשית: Bereshit.1.1.1', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad', @level2type = N'COLUMN', @level2name = N'KeyWordIndex';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'האם הפרשה שמסתיימת אחרי המילה היא פרשה פתוחה', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad', @level2type = N'COLUMN', @level2name = N'IsParashaPtuchah';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'האם מסתיימת פרשה אחרי המילה', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad', @level2type = N'COLUMN', @level2name = N'EndParashaAfterWord';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'האם מתחילה פרשה לפני המילה', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad', @level2type = N'COLUMN', @level2name = N'StartParashaBeforeWord';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'המילה עצמה עם ניקוד וטעמי המקרא', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad', @level2type = N'COLUMN', @level2name = N'WordWithNiqqud';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'המילה עצמה ללא ניקוד וללא טעמי המקרא', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad', @level2type = N'COLUMN', @level2name = N'Word';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'מספר מילה', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad', @level2type = N'COLUMN', @level2name = N'WordSequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'פסוק', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad', @level2type = N'COLUMN', @level2name = N'Verse';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'פרק', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad', @level2type = N'COLUMN', @level2name = N'Chapter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'שם הספר באנגלית לפי התעתיק הנכון', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad', @level2type = N'COLUMN', @level2name = N'BookName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'טבלה זו מכילה ייבוא של התנ"ך מילה במילה מתוך קודקס אוף לנינגראד', @level0type = N'SCHEMA', @level0name = N'Import', @level1type = N'TABLE', @level1name = N'WordsInTanakh_CodexOfLeningrad';


GO

CREATE INDEX [IX_WordsInTanakh_CodexOfLeningrad_KeyWordIndex] ON [Import].[WordsInTanakh_CodexOfLeningrad] ([KeyWordIndex])

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'האם זה קרי',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'IsKri'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'האם זה כתיב',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'WordsInTanakh_CodexOfLeningrad',
    @level2type = N'COLUMN',
    @level2name = N'IsKtiv'