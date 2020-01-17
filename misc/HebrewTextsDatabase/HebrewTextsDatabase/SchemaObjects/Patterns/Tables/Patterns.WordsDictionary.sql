CREATE TABLE [Patterns].[WordsDictionary]
(
	[WordID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Word] NVARCHAR(50) NOT NULL, 
    [Comment] NVARCHAR(MAX) NULL
)

GO

CREATE INDEX [UQ_WordsDictionary_Word] ON [Patterns].[WordsDictionary] ([Word])

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'זהו מילון של מילים המכיל מילים שונות שיש צורך לעבוד איתם
	לדוגמא ראשי תיבות ת"ש = תא שמע יהיו כאן 2 הצורות של תא שמע בראשי תיבות וללא ראשי תיבות
	יהיה ביניהם סוג של ריליישן רבים לרבים וכדומה לצורך חיפושים
	כנ"ל מי שיחפש השם יכיל הפניה לאלהים אל וכדומה משמות הקודש
	בעיקר נועד עבור חיפושים
	',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'WordsDictionary'


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'המילה כצורתה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'WordsDictionary',
    @level2type = N'COLUMN',
    @level2name = N'Word'