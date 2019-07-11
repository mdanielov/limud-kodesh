CREATE TABLE [Patterns].[WordsRelations]
(
	[WordsRelationID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [FromWordID] INT NOT NULL, 
    [ToWordID] INT NOT NULL, 
    [RelationType] NVARCHAR(50) NOT NULL, 
    [Comment] NVARCHAR(MAX) NULL, 
    CONSTRAINT [CK_WordsRelations_RelationType] CHECK (
	RelationType in  (
	'Synonym', --מילה נרדפת
	'Acronyms' -- ראשי תיבות
	) ), 
    CONSTRAINT [FK_WordsRelations_ToWords] FOREIGN KEY (FromWordID) REFERENCES Patterns.WordsDictionary(WordID),
    CONSTRAINT [FK_WordsRelations_ToWords2] FOREIGN KEY (ToWordID) REFERENCES Patterns.WordsDictionary(WordID)

)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'מאיזה מזהה מילה הקשר',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'WordsRelations',
    @level2type = N'COLUMN',
    @level2name = N'FromWordID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'לאיזה מזהה מילה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'WordsRelations',
    @level2type = N'COLUMN',
    @level2name = N'ToWordID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'סוג הקשר כגון ראשי תיבות מילה נרדפת איות שונה וכן הלאה, מבוסס טקסט עם אפשרויות מוגבלות',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'WordsRelations',
    @level2type = N'COLUMN',
    @level2name = N'RelationType'
GO

CREATE INDEX [IX_WordsRelations_AllFields] ON [Patterns].[WordsRelations] ([FromWordID],ToWordID,RelationType)
