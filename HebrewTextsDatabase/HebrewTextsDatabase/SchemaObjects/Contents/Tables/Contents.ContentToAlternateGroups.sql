CREATE TABLE [Contents].[ContentToAlternateGroups]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [GroupID] INT NOT NULL, 
    [FromContentID] BIGINT NOT NULL, 
    [ToContentID] BIGINT NOT NULL, 
    [VersionID] INT NULL, 
    CONSTRAINT [FK_ContentToAlternateGroups_ToContentGroups] FOREIGN KEY ([GroupID]) REFERENCES [Contents].ContentGroups([GroupID]) ,--TODO זה לא עובד משום מהON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [FK_ContentToAlternateGroups_ToContent] FOREIGN KEY ([FromContentID]) REFERENCES [Contents].[MainContent]([MainContentID]) ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [FK_ContentToAlternateGroups_ToContent2] FOREIGN KEY (ToContentID) REFERENCES [Contents].[MainContent]([MainContentID]) 
)

GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מכילה את היכולת לשייך תוכן לקבוצות מרובות כלומר סופר גרופ
	מתוך הנחה שהתוכן המרכזי משוייך לפי הקבוצות הקטנות ביותר האפשריות כך שייקל עלינו לשייך את אותו תוכן עצמו לקבוצות אחרות
	ההצבעה על טווח התוכן שאותו אנו משייכים לקבוצה הנוספת שכאן היא באמצעות מזהה של רשומה בטבלת התוכן המרכזי שהיא תחילת התוכן
	ואז הצבעה על סיום התוכן בטבלת התוכן המרכזי על ידי ציון המזהה של סיום התוכן
	הסדר של התוכן חייב להישמר לפי הכרונולוגיה של הטבלה המרכזית ולכן כל הצבעה על התחלה וסיום תחשב לפי הכרונלוגיה המצויינת בקבוצות המסומנות בטבלת התוכן המרכזי
	ניתן עם זאת להצביע על סיום לפי נקודת ציון כרונולוגית בטבלת התוכן המרכזי
	לדוגמא: בתנך טבלת התוכן המרכזי היא לפי קבוצות של פסוקים
	ואולם כאשר נרצה לציין קבוצה של פרשייה סגורה או פתוחה
	היא בדרך כלל מתחילה בתחילת פסוק ומסתיימת בסוף פסוק אחרי מספר פסוקים אולם ייתכן שהפרשה מתחילה באמצע פסוק או מסתיימת באמצעו
	ואז נוכל לציין כאן את המילה שבה מתחילה הפרשה ואת המילה שבה מסתיימת הפרשה 
	מתוך הנחה שכל הטווח שבינתיים הוא מסודר לפי הסדר המרכזי של פסוקים ופרקים שיש להם סדר כרונולוגי מוקפד
	',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentToAlternateGroups'
 
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה הקבוצה עליה מדובר',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentToAlternateGroups',
    @level2type = N'COLUMN',
    @level2name = N'GroupID'

GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מאיזו רשומת תוכן מתחיל התוכן של קבוצה זו',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentToAlternateGroups',
    @level2type = N'COLUMN',
    @level2name = N'FromContentID'
GO

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'עד איזו רשומת תוכן מסתיים התוכן של קבוצה זו',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentToAlternateGroups',
    @level2type = N'COLUMN',
    @level2name = N'ToContentID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'בהתאם לאיזו גירסה נקבע גרופ זה - כי לדוגמא לגבי פרשיות פתוחות וסגורות יש גם הרבה הבדלי גירסאות',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentToAlternateGroups',
    @level2type = N'COLUMN',
    @level2name = N'VersionID'