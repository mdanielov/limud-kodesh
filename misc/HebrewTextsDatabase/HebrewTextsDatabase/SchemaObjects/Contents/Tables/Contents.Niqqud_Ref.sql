CREATE TABLE [Contents].[Niqqud_Ref]
(
	[NiqqudID] INT NOT NULL PRIMARY KEY, 
    [Niqqud] NVARCHAR NOT NULL, 
    [NiqqudName] NVARCHAR(50) NOT NULL, 
    [Comments] NVARCHAR(MAX) NULL
)


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מכילה את כל הניקוד באלף בית העברי כל סימן ניקוד יקבל כאן ערך',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'Niqqud_Ref'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה קוד פנימי עבור הניקוד',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'Niqqud_Ref',
    @level2type = N'COLUMN',
    @level2name = N'NiqqudID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הניקוד עצמו בUTF-8',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'Niqqud_Ref',
    @level2type = N'COLUMN',
    @level2name = N'Niqqud'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שם הנקודה כגון שווא מפיק וכדומה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'Niqqud_Ref',
    @level2type = N'COLUMN',
    @level2name = N'NiqqudName'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הערות',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'Niqqud_Ref',
    @level2type = N'COLUMN',
    @level2name = N'Comments'