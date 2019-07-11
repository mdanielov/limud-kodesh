CREATE TABLE [Patterns].[ConceptsDictionary]
(
	[ConceptDictionaryID] INT NOT NULL PRIMARY KEY IDENTITY,
    [ConceptRootWord] NVARCHAR(255) NOT NULL, 
    [Description] NVARCHAR(MAX) NULL
)


GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מכילה מילון של כל המושגים בהם התורה וחזל עושים שימוש
המילים עשויות להיות בעלי משמעויות שונות ולכן אנו מקבצים אותן כאן במילון 
ובטבלאות נפרדות נוכל לנהל את המשמעויות השונות שקיבלו מילים אלו
מושג עשוי להיות בעל פרשנות ממשית סמלית או משמעית
לדוגמא המושג יד כפי המופיע במורה הנבוכים יש לו משמעות של איבר בגוף האדם
משמעות סמלית לפעמים כגון להציל מידיו וכגון הכביד את ידו
ומשמעות משמעית יותר כגון יד השם דהיינו פעולותיו וכן הלאה
ההפשטה הזו מטופלת על ידי השוואות המופיעות בטבלאות השונות',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ConceptsDictionary'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שורש המילה בעברית',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ConceptsDictionary',
    @level2type = N'COLUMN',
    @level2name = 'ConceptRootWord'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הסבר ותיאור של המילה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ConceptsDictionary',
    @level2type = N'COLUMN',
    @level2name = N'Description'