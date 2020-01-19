CREATE TABLE [Patterns].[CommonExpressions]
(
	[ID] INT NOT NULL PRIMARY KEY, 
    [ExpressionWords] NVARCHAR(MAX) NOT NULL
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מכילה את הביטויים הנפוצים בחזל כגון תא שמע תא חזי וכן הלאה טבלאות משנה יספקו קשרים ודברים מעניינים נוספים על גבי המילון הזה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'CommonExpressions'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מילות הביטוי כגון תא שמע וכן הלאה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'CommonExpressions',
    @level2type = N'COLUMN',
    @level2name = N'ExpressionWords'