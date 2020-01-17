CREATE TABLE [Contents].[Letters_Ref]
(
	[LetterID] INT NOT NULL PRIMARY KEY, 
    [Letter] NVARCHAR(1) NOT NULL, 
    [NumericValue] INT NULL
)

GO

CREATE INDEX [IX_Letters_Ref_Letter] ON [Contents].[Letters_Ref] ([Letter])


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה המכילה את כל אותיות האלף בית העברי',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'Letters_Ref'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה קוד פנימי עבור האות',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'Letters_Ref',
    @level2type = N'COLUMN',
    @level2name = N'LetterID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N' האות עצמה כגון א, ב, ג וכדומה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'Letters_Ref',
    @level2type = N'COLUMN',
    @level2name = N'Letter'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ערך מספרי של האות כגון א=1 ב=2 ס=60',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'Letters_Ref',
    @level2type = N'COLUMN',
    @level2name = N'NumericValue'