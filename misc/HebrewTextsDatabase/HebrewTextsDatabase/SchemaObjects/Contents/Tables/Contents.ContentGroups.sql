CREATE TABLE [Contents].[ContentGroups]
(
	[GroupID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [GroupType] INT NULL, 
    [GroupName] NVARCHAR(50) NULL, 
	[SequenceNumber] INT NULL,
	[SequenceNumberByRootGroup] INT NULL,
	[ParentGroupID] INT NULL, 
    [XMLData] XML NULL, 
    [RoutePriority] INT NULL, 
    [NextGroupIDInLevel] INT NULL,
	[RootGroupID] int null,
	[KeyWordIndex] NVARCHAR(50) NULL 

    CONSTRAINT [FK_ContentGroups_ToGroupsAndDividingTypes] FOREIGN KEY (GroupType) REFERENCES [Contents].GroupsAndDividingTypes(ID) on update cascade, 
    [VersionID] INT NULL
	
)

GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מכילה מידע אודות הקבצות של התוכן של הספרים
	כל תוכן בעצם מקובץ בספר כאשר הספר עצמו מכיל קבוצות משנה כגון פרקים וסעיפים
	הספר עצמו נמצא בתוך קבוצה גדולה ממנו כגון ספר בראשית בתוך התנ"ך וכן הלאה
	טבלה זו היא בעצם העץ האינסופי של התכנים וכל רשומת תוכן מפנה לרשומה כלשהי בטבלה זו
	התכנים עצמם מאוחסים בטבלה הקרויה:
	[Contents].[MainContent]
	נמצאת גם בסכמה הנוכחית
	',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentGroups'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שם הגרופ כגון תנך או בראשית או פרק וכדומה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentGroups',
    @level2type = N'COLUMN',
    @level2name = N'GroupName'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מספר סידורי בתוך הענף של הגרופ הנוכחי למשל אם אנחנו בספר שמות הוא מספר 2 באותו צומת',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentGroups',
    @level2type = N'COLUMN',
    @level2name = N'SequenceNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הגרופ ההורה של הגרופ הנוכחי בעצם הפנייה לרשומה אחרת בטבלה זו אם למשל אנחנו בספר בראשית תהיה כאן הפנייה לרשומת חמישה חומשי תורה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentGroups',
    @level2type = N'COLUMN',
    @level2name = N'ParentGroupID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'סוג הגרופ למשל האם מדובר בפרק או ספר שדה זה איננו חובה ואיננו כל כך בעל משמעות גדולה לגבי הלוגיקה של המערכת
	תפקידו העיקרי הוא לתת לנו מושג היכן אנו נמצאים אולם הוא גם מאפשר לנו לפתוח צמתים נוספים תחת אותו גרופ
	למשל ספר בראשית מתחלק לפרקים אולם מתחלק גם לפרשיות 
	התלמוד מתחלק לדפים וגם לפרקים וכן הלאה
	שימוש בשדה זה מאפשר לפתוח צמתים רבים במקביל ולשייך אותם בסופו של דבר לתוכן 
	',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentGroups',
    @level2type = N'COLUMN',
    @level2name = N'GroupType'
GO

CREATE INDEX [IX_ContentGroups_ParentGroupID] ON [Contents].[ContentGroups] (ParentGroupID)

GO

CREATE INDEX [IX_ContentGroups_SequenceNumberByRootGroup] ON [Contents].[ContentGroups] (SequenceNumberByRootGroup)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'במקרה והמסלול הזה מתפצל מתוך צומת אחת מהי העדיפות והמזהה של מסלול זה
	כדוגמא ניתן לקחת בספר בראשית ישנם מספר מסלולים איך להמשיך במורד העץ, דהיינו פרקים ופסוקים או פרשיות השבוע
	או פרשיות סגורות ופתוחות
	ולכן בכל נקודת התפצלות כזו נצטרך לתת עדיפות ומזהה לנתיב ההתפצלות על מנת לאפשר לתת הוראות לתוכנה באיזה נתיב להמשיך כשיש התפצלות שכזו
	',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentGroups',
    @level2type = N'COLUMN',
    @level2name = N'RoutePriority'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שדה מיוחד שתפקידו לציין את הגרופ הבא בתור באותו לוול שבו אנו נמצאים
	לדוגמא אם הרשומה הזו היא הפסוק האחרון בפרק א יש לציין כאן שהבא בתור הוא הפסוק הראשון בפרק ב
	אם הרשומה הזו היא הפסוק האחרון בספר בראשית יש לציין כאן את הפסוק הראשון בספר שמות
	אם הרשומה הזו היא ספר דברים יהושע הוא הבא בתור
	אם הרשומה הזו היא פרק אחרון בספר דברים יצויין כאן המזהה של הפרק הראשון ביהושע
	וכן הלאה
	תפקידו של שדה זה ליצור סדר רציף בכל מאי דאפשר למען ירוץ הקורא בגרופים
	',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentGroups',
    @level2type = N'COLUMN',
    @level2name = N'NextGroupIDInLevel'
GO

CREATE INDEX [IX_ContentGroups_NextGroupIDInLevel] ON [Contents].[ContentGroups] (NextGroupIDInLevel)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה הקבוצה השורשית ביותר שאליה משוייך טקסט זה באופן ישיר כלומר הגרופ הכי גבוה שיש ביחס לעץ הגרופים לדוגמא בפסוקים מדובר בתנך',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentGroups',
    @level2type = N'COLUMN',
    @level2name = N'RootGroupID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מילת מפתח לזיהוי הגרופ במידה ומדבור בגרופ משמעותי מאוד כגון תנך או תלמוד בבלי',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentGroups',
    @level2type = N'COLUMN',
    @level2name = N'KeyWordIndex'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה גירסה, לפעמים הגרופים משתנים בהתאם לגירסאות שונות כלומר שהגרופ עצמו לפי גירסה אחת הוא שונה מהגרופ לפי גירסה אחרת
	אמנם זה די נדיר במקרים רבים שבהם מדובר בגרופים טכניים כגון פסוקים 
	אבל זה אפשרי מאוד בגרופים הקשורים לתוכן מהותי יותר כגון איך לחלק משפטים וכן הלאה
	 ',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'ContentGroups',
    @level2type = N'COLUMN',
    @level2name = N'VersionID'