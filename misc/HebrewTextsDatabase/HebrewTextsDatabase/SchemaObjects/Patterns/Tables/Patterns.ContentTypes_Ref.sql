CREATE TABLE [Patterns].[ContentTypes_Ref]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(MAX) NULL, 
    [Description] NVARCHAR(MAX) NULL,
)
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מכילה סוגים של תוכן
	כל תוכן טקסטואלי הוא מאמר או קושיה או תירוץ וכן הלאה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ContentTypes_Ref'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שמו של סוג התוכן כגון מאמר קושיה תירוץ סתירה וכדומה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ContentTypes_Ref',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הסבר אודות סוג התוכן',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ContentTypes_Ref',
    @level2type = N'COLUMN',
    @level2name = N'Description'