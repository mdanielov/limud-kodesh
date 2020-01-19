CREATE TABLE [Patterns].[ConceptsDictionaryMeaningsToGroups]
(
	[ID] INT NOT NULL PRIMARY KEY, 
    [ConceptsDictionaryMeaningID] INT NOT NULL, 
    [GroupID] INT NOT NULL, 
    CONSTRAINT [FK_ConceptsDictionaryMeaningsToGroups_ToConceptsDictionaryMeanings] FOREIGN KEY ([ConceptsDictionaryMeaningID]) REFERENCES [Patterns].[ConceptsDictionaryMeanings]([ID])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה של המשמעות המילונית',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ConceptsDictionaryMeaningsToGroups',
    @level2type = N'COLUMN',
    @level2name = N'ConceptsDictionaryMeaningID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מזהה של גרופ',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'ConceptsDictionaryMeaningsToGroups',
    @level2type = N'COLUMN',
    @level2name = N'GroupID'