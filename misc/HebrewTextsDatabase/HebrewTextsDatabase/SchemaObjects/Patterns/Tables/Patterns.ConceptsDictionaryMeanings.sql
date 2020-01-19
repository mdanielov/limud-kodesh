CREATE TABLE [Patterns].[ConceptsDictionaryMeanings]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [ConceptDictionaryID] INT NOT NULL, 
    [Meaning] NVARCHAR(MAX) NOT NULL, 
    [Comment] NVARCHAR(MAX) NULL, 
    [AddedDate] DATETIME NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_ConceptsDictionaryMeanings_ToConceptsDictionary] FOREIGN KEY ([ConceptDictionaryID]) REFERENCES [Patterns].[ConceptsDictionary]([ConceptDictionaryID])
)



GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו לוקחת מושגים מילוניים ומצמידה להם משמעויות שונות 
כמו למשל ראשית במובן פשוט מילולי וטכני התחלה זמנית
לעומת ראשית בתור דבר חשוב
לעומת ראשית וירא ראשית לו
וכן מילונו של רמבם יד השם וכדומה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ConceptsDictionaryMeanings'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה של המושג במילון',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ConceptsDictionaryMeanings',
    @level2type = N'COLUMN',
    @level2name = N'ConceptDictionaryID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'משמעות המושג',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ConceptsDictionaryMeanings',
    @level2type = N'COLUMN',
    @level2name = N'Meaning'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הערות',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ConceptsDictionaryMeanings',
    @level2type = N'COLUMN',
    @level2name = N'Comment'