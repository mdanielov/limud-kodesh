CREATE TABLE [Persons].[RelationsSources]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [RelationID] INT NOT NULL, 
    [GroupSourceID] INT NOT NULL, 
    CONSTRAINT [FK_RelationsSources_ToRelations] FOREIGN KEY (RelationID) REFERENCES Persons.RelationsBetweenPersonalities(ID),
    CONSTRAINT [FK_RelationsSources_ToContentGroups] FOREIGN KEY (GroupSourceID) REFERENCES Contents.ContentGroups([GroupID])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'בטבלה זו יש מקורות לקשרים המופיעים בטבלת הקשרים שבין האנשים ייתכן יותר ממקור אחד לקשר כלשהו ולכן ייתכנו ריבוי רשומות פר קשר',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'RelationsSources'


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה הקשר בטבלת הקשרים',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'RelationsSources',
    @level2type = N'COLUMN',
    @level2name = N'RelationID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה קבוצת התוכן המהווה מקור לקשר זה',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'RelationsSources',
    @level2type = N'COLUMN',
    @level2name = N'GroupSourceID'