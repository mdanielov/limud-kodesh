CREATE TABLE [Contents].[ContentOtherVersions]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY (1,1), 
    [MainContentID] BIGINT NOT NULL, 
    [VersionSourceID] INT NOT NULL, 
    [VersionOperation] NVARCHAR(10) NOT NULL, 
    [SequenceNumber] INT NOT NULL, 
    [Content] NVARCHAR(MAX) NULL, 
    CONSTRAINT [CK_ContentOtherVersions_VersionOperation] 
	CHECK (
	[VersionOperation] = 'Delete' --גירסה זו מוחקת מילה מהגירסה המרכזית
	or [VersionOperation] = 'InsertBefore' --גירסה זו מוסיפה לפני המילה הנוכחית בגירסה המרכזית
	or [VersionOperation] = 'InsertAfter' --גירסה זו מוסיפה אחרי המילה בגירסה המרכזית
	or [VersionOperation] = 'Change' -- גירסה זו מחליפה את המילה הנוכחית שבגירסה המרכזית במילה אחרת
	or [VersionOperation] = 'Equal' --גירסה זו תומכת בגירסה המרכזית ייתכן למשל שבאופן משתמע נוכל לגלות שגירסה כלשהי תומכת למרות ששאר הגירסאות מתנגדות וכן הלאה
	), 
    CONSTRAINT [FK_ContentOtherVersions_ToMainContent] FOREIGN KEY (MainContentID) REFERENCES Contents.MainContent(MainContentID) ON DELETE CASCADE ON UPDATE CASCADE, 
    -- CONSTRAINT [FK_ContentOtherVersions_ToTextVersion] FOREIGN KEY (VersionID) REFERENCES Contents.TextVersions(VersionID) ON DELETE CASCADE ON UPDATE CASCADE
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו היא טבלת ניהול גירסאות עבור תכנים לכל תוכן ייתכנו מספר גירסאות ועבור כך נבנתה הטבלה הנוכחית
	כעיקרון אין צורך לשמור את כל הטקסט בכל הגירסאות, כי במקומות שכל הגירסאות מסכימות עם התוכן אין טעם לשמור עותק נוסף
	לכן בטבלה זו יאוחסנו אך ורק השינויים שבין הגירסאות השונות כאשר ישנן חמישה פעולות שגירסה עשויה להשפיע  בהן
	ראו בתיעוד של השדות עצמן
	',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentOtherVersions'
 

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'התוכן שבגירסה המרכזית מצביע לטבלת התכנים המרכזית',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentOtherVersions',
    @level2type = N'COLUMN',
    @level2name = N'MainContentID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'באיזו גירסה מדובר הפנייה לטבלת הגירסאות השונות',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentOtherVersions',
    @level2type = N'COLUMN',
    @level2name = N'VersionSourceID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'פעולת הגירסה יש חמישה פעולות אפשריות ראה באילוץ שנכתב לשם כך יש שם גם תיעוד',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentOtherVersions',
    @level2type = N'COLUMN',
    @level2name = N'VersionOperation'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הסדר הכרונולוגי של התוכן הזה ייתכנו מספר תכנים בגירסה כגון הוספה של כמה מילים אחרי מילה מסויימת וכן הלאה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentOtherVersions',
    @level2type = N'COLUMN',
    @level2name = N'SequenceNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'התוכן הנוכחי שהגירסה הנוכחית מציגה - נשאר ריק במקרה ופעולת הגירסה הנוכחית היא מחיקה של מילה מהגירסה המרכזית',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentOtherVersions',
    @level2type = N'COLUMN',
    @level2name = N'Content'