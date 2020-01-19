CREATE TABLE [Contents].[GroupsAndDividingTypes]
(
[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(50) NOT NULL, 
    [Description] NVARCHAR(MAX) NULL, 
    [GroupLevel] INT NULL,
    [XMLData] XML NULL, 
    [KeyWordIndex] NVARCHAR(50) NULL 

)

GO
	EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מחזיקה סוגים של הקבצות ושל חלוקות פנימיות של ספרים כגון פרק פסוק הלכה וכדומה כמו גם הקבצות שונות לדוגמא זרעים מועד נשים תורה נביאים כתובים וכן הלאה
	יודגש שכאן אנחנו מדברים על אבסטרקציה של ההקבצות וחלוקות, ולא על ההקבצות והחלוקות בעצמם כי לזה יש טבלה נפרדת
	למשל עבור סוג חלוקה פרק או פסוק תהיה כאן
	סוג הקבצה קבוצת ספרים היא רשומה כאן, וההקבצה בפועל של תורה או סדר זרעים תהיה בטבלה נוספת שאחראית על ניהול אותם הקבוצות	',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'GroupsAndDividingTypes'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שם החלוקה או הקבצה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'GroupsAndDividingTypes',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הסבר על אודות החלוקה או ההקבצה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'GroupsAndDividingTypes',
    @level2type = N'COLUMN',
    @level2name = N'Description'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מידע נוסף באקסמל',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'GroupsAndDividingTypes',
    @level2type = N'COLUMN',
    @level2name = N'XMLData'

GO


EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הרמה של הקבוצה כאשר הספר עצמו הוא נקודת הציר והוא רמה אפס כל מספר שמעל אפס פירושו הקבצה שמעל הספר וכל מספר שמתחת לאפס פירושו חלוקה לקבוצות בתוך הספר',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'GroupsAndDividingTypes',
    @level2type = N'COLUMN',
    @level2name = N'GroupLevel'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מילת מפתח ואינדקס על מנת לאפשר תחזוקה של סוגי גרופים נפוצים בקוד באופן נקי וברור לדוגמא תנך תהיה לו מילת מפתח Tanakh',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'GroupsAndDividingTypes',
    @level2type = N'COLUMN',
    @level2name = N'KeyWordIndex'
GO

CREATE UNIQUE INDEX [UQ_GroupsAndDividingTypes_KeyWordIndex] ON [Contents].[GroupsAndDividingTypes] (KeyWordIndex)
