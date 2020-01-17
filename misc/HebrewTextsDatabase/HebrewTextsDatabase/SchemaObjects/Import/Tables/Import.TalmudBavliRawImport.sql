CREATE TABLE [Import].[TalmudBavliRawImport]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY,
	[GeneralSequenceNumber] BIGINT,
	[Masechet] NVARCHAR(4000),
	[DafNumber] INT,
	[AmudNumber] INT,
	[RowNumber] INT,
	[Content] NVARCHAR(MAX), 
    [StartMishnaPosition] INT NULL, 
    [EndMishnaPosition] INT NULL, 
    [StartGemaraPosition] INT NULL, 
    [EndGemaraPosition] INT NULL, 
    [StartChapterName] NVARCHAR(50) NULL,
	[KeyWordIndex] NVARCHAR(50) NULL, 
    [GroupID] INT NULL
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מספר סידורי כללי של שורה ביחס לכל השס כולו',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'GeneralSequenceNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מסכת',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'Masechet'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מספר דף',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'DafNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מספר עמוד 1 או 2',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'AmudNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מספר שורה',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'RowNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'תוכן שורה',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'Content'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מילה שבה מתחילה משנה אם ישנה מילה כזו בשורה הלזו אם אין אזי הערך הוא אפס אם יש התחלה של משנה הערך יהיה מספר המילה',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'StartMishnaPosition'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'סיום משנה כנל',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'EndMishnaPosition'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'התחלת גמרא כנל',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'StartGemaraPosition'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'סיום גמרא כנל',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'EndGemaraPosition'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'אם מתחיל כאן פרק מה שם הפרק ההנחה היא שפרק לא מתחיל אף פעם באמצע שורה לכן זה פחות רלוונטי הפוזיציה',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'StartChapterName'
GO

CREATE INDEX [IX_TalmudBavliRawImport_KeyWordIndex] ON [Import].[TalmudBavliRawImport] ([KeyWordIndex])

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה גרופ של השורה על שם העתיד כשיהיה כזה אחד יעודכן כאן',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'GroupID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'אינדקס ייחודי של מילת מפתח המבטאת את המסכת הדף העמוד והשורה',
    @level0type = N'SCHEMA',
    @level0name = N'Import',
    @level1type = N'TABLE',
    @level1name = N'TalmudBavliRawImport',
    @level2type = N'COLUMN',
    @level2name = N'KeyWordIndex'