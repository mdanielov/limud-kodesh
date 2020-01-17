CREATE TABLE [Persons].[RelationsBetweenPersonalities]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [FromPersonID] INT NOT NULL, 
    [ToPersonID] INT NOT NULL, 
    [RelationType] INT NOT NULL, 
    [Description] NVARCHAR(MAX) NULL, 
    [FromHebrewYear] INT NULL, 
    [ToHebrewYear] INT NULL, 
    CONSTRAINT [FK_RelationsBetweenPersonalities_ToPersons] FOREIGN KEY (FromPersonID) REFERENCES Persons.Personalities(ID),
	CONSTRAINT [FK_RelationsBetweenPersonalities_ToPersons2] FOREIGN KEY (ToPersonID) REFERENCES Persons.Personalities(ID)
	
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו אחראית לרכז את כל הקשרים בין האישים שיש להם נגיעה בתוכן כגון רב ותלמיד חברים אב ובנו וכן הלאה',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenPersonalities'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'האישיות בצד הראשון של הקשר - כגון רב',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenPersonalities',
    @level2type = N'COLUMN',
    @level2name = N'FromPersonID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'האישיות בצד השני של הקשר - כגון תלמיד',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenPersonalities',
    @level2type = N'COLUMN',
    @level2name = N'ToPersonID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'סוג הקשר - כגון רב, חבר, אב,  בר פלוגתא וכן הלאה',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenPersonalities',
    @level2type = N'COLUMN',
    @level2name = N'RelationType'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'תיאור כללי אם יש צורך בכך',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenPersonalities',
    @level2type = N'COLUMN',
    @level2name = N'Description'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מאיזו שנה עברית בערך התחיל הקשר',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenPersonalities',
    @level2type = N'COLUMN',
    @level2name = N'FromHebrewYear'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'עד איזו שנה עברית נמשך הקשר',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenPersonalities',
    @level2type = N'COLUMN',
    @level2name = N'ToHebrewYear'