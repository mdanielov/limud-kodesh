CREATE TABLE [Relations].[RelationsBetweenGroups]
(
	[ID] INT NOT NULL PRIMARY KEY, 
    [FromGroupID] INT NOT NULL, 
    [ToGroupID] INT NOT NULL, 
    [RelationType] INT NOT NULL, 
    [Description] NVARCHAR(MAX) NULL, 
    [Comment] NVARCHAR(MAX) NULL, 
    [XMLData] XML NULL
)

GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מנהלת את הקשרים שיש בין קבוצות שונות של תוכן טקסטואלי
	הקשר יכול להיות גם טכני וגם עיוני 
	דוגמא לקשר טכני: מאמר זהה במקומות שונים בשס
	דוגמא לקשר עיוני: מאמר שרעיונו זהה אולם תוכנו שונה
	קשר עיוני הוא כמובן תלוי ביוצר שלו והוא נזקק לאישור אנושי
	קשר יכול להיות גם שלילי כלומר מחלוקת או סתירה 
	קשר יכול להביע כל עניין אחר היוצר סוג של השלכה בין תוכן לתוכן
	טבלה זו תומכת בקשר בין שתי רשומות של תוכן, 
	קשר המכיל יותר משתי הפניות לתכנים שונים יירשם ברשומות נוספות
	קשר שעבורו נוצר גרופ חדש הוא אפשרי
	והגרופ הזה יווצר במיוחד עבור יצירת הקשר הלזה בלבד
	',
    @level0type = N'SCHEMA',
    @level0name = N'Relations',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenGroups'
 
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מאיזו קבוצה הקשר',
    @level0type = N'SCHEMA',
    @level0name = N'Relations',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenGroups',
    @level2type = N'COLUMN',
    @level2name = N'FromGroupID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'לאיזו קבוצה הקשר',
    @level0type = N'SCHEMA',
    @level0name = N'Relations',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenGroups',
    @level2type = N'COLUMN',
    @level2name = N'ToGroupID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'איזה סוג קשר מדובר טבלת לוקאפ תגדיר כגון דימוי סתירה וכדומה',
    @level0type = N'SCHEMA',
    @level0name = N'Relations',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenGroups',
    @level2type = N'COLUMN',
    @level2name = N'RelationType'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'תיאור מילולי של הקשר',
    @level0type = N'SCHEMA',
    @level0name = N'Relations',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenGroups',
    @level2type = N'COLUMN',
    @level2name = N'Description'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הערות על הקשר',
    @level0type = N'SCHEMA',
    @level0name = N'Relations',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenGroups',
    @level2type = N'COLUMN',
    @level2name = N'Comment'