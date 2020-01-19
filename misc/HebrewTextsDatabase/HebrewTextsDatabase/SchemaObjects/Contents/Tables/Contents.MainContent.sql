CREATE TABLE [Contents].[MainContent]
(
	[MainContentID]   BIGINT           NOT NULL IDENTITY, 
    [GroupID] int NOT NULL,
	[SequenceNumber] int NOT NULL,
	[RootGroupID] int NULL,
	[SequenceNumberByRootGroup] int NULL,
	[Content] NVARCHAR(255) NOT NULL, 
    [LargeContent] NVARCHAR(MAX) NULL, 
    [VersionSourceID] INT NULL, 
    [NextContentID] INT NULL, 
	[KeyWordIndex] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Content] PRIMARY KEY ([MainContentID]), 
    CONSTRAINT [FK_Content_ToContentGroups] FOREIGN KEY ([GroupID]) REFERENCES [Contents].[ContentGroups]([GroupID]) ON UPDATE CASCADE, 
    CONSTRAINT [FK_Content_ToVersions] FOREIGN KEY ([VersionSourceID]) REFERENCES Contents.[TextVersionSources]([VersionSourceID]) ON UPDATE CASCADE
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה הקבוצה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'MainContent',
    @level2type = N'COLUMN',
    @level2name = N'GroupID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הסדר הרציף של התוכן הנוכחי בתוך הקבוצה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'MainContent',
    @level2type = N'COLUMN',
    @level2name = N'SequenceNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'התוכן עצמו בדרך כלל מילה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'MainContent',
    @level2type = N'COLUMN',
    @level2name = N'Content'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'התוכן גדול יותר (ללא אינדקס מקומי) או תוכן עם ניקוד אם ישנו',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'MainContent',
    @level2type = N'COLUMN',
    @level2name = N'LargeContent'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה הגירסה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'MainContent',
    @level2type = N'COLUMN',
    @level2name = N'VersionSourceID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה הקבוצה השורשית ביותר שאליה משוייך טקסט זה באופן ישיר כלומר הגרופ הכי גבוה שיש ביחס לעץ הגרופים לדוגמא בפסוקים מדובר בתנך',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'MainContent',
    @level2type = N'COLUMN',
    @level2name = N'RootGroupID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הסדר הרציף של תוכן זה ביחס לגרופ השורש יעודכן מפעם לפעם על ידי קוד מיוחד שיטפל בזה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'MainContent',
    @level2type = N'COLUMN',
    @level2name = N'SequenceNumberByRootGroup'
GO

CREATE INDEX [IX_MainContent_GroupID] ON [Contents].[MainContent] (GroupID)

GO

CREATE INDEX [IX_MainContent_SequenceNumberByRootGroup] ON [Contents].[MainContent] (SequenceNumberByRootGroup) INCLUDE ([RootGroupID]) 

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'התוכן הבא שאמור לבוא אחרי התוכן הזה זוהי הפניה למזהה תוכן של הטבלה הזאת בעצמה כגון בראשית יפנה לברא ברא לאלהים וכן הלאה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'MainContent',
    @level2type = N'COLUMN',
    @level2name = N'NextContentID'
GO

CREATE INDEX [IX_MainContent_NextContentID] ON [Contents].[MainContent] (NextContentID)

GO

CREATE INDEX [IX_MainContent_Content] ON [Contents].[MainContent] (Content)

GO

CREATE INDEX [IX_MainContent_RootGroupID] ON [Contents].[MainContent] (RootGroupID)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מפתח לאיתור התוכן',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'MainContent',
    @level2type = N'COLUMN',
    @level2name = N'KeyWordIndex'