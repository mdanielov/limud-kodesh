CREATE TABLE [Patterns].[ContentPatterns]
(
	[ContentPatternID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [PatternFormula] NVARCHAR(MAX) NULL, 
    [PatternDescription] NVARCHAR(MAX) NULL 
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מכילה תבניות של תוכן
	הכוונה כאן לתבניות של ביטויי תוכן שחז"ל משתמשים בהם באופן קבוע, כגון
	כשם שאלף כך בית
	לא היה כך וכך אלא בשביל כך וכך
	לא יהיה כך וכך עד שיהיה כך וכך
	כל מקום שנאמר בו א אינו אלא בשביל ב
	אל תקרי בנייך אלא בונייך
	תורה נקראת חיים, מים נקראו חיים
	מכאן אפשר לערוך מחקרים גם אודות דרשות חזל שבעצם דורשים לפי תבניות של פסוקים
	כל אלו סוגי משפטים שיש בהם נושא ונשוא והם מבוטאים בתבניות שונות
	לא רצינו להכניס את זה באותה טבלה עם ביטויים נפוצים אף על פי שיש ביניהם דמיון 
	מפני שכאן הביטויים מורכבים מאוד ואילו הטבלה של ביטויים נפוצים נועדה לתעד את הביטויים כשלעצמם ללא מורכבות של נושא ונשוא עם יחסים שונים
	',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ContentPatterns'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'נוסחה שאמורה להוות את התבנית באופן נורמלי ניתן להשתמש בביטוי רגולרי, אולם אין כאן משהו קבוע זה יפותח לפי העניין',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ContentPatterns',
    @level2type = N'COLUMN',
    @level2name = 'PatternFormula'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הסבר אודות התבנית',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ContentPatterns',
    @level2type = N'COLUMN',
    @level2name = N'PatternDescription'