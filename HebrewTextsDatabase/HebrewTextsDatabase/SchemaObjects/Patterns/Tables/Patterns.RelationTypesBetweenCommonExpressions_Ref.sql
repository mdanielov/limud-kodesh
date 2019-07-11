CREATE TABLE [Patterns].[RelationTypesBetweenCommonExpressions_Ref]
(
	[RelationTypeID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(50) NULL, 
    [Description] NVARCHAR(MAX) NULL

)

GO

CREATE UNIQUE INDEX [IX_RelationTypesBetweenCommonExpressions_Name] ON [Patterns].[RelationTypesBetweenCommonExpressions_Ref] (Name)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלת לוקאפ לסוגי קשרים בין ביטויים נפוצים',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RelationTypesBetweenCommonExpressions_Ref'


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שם ייחודי',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RelationTypesBetweenCommonExpressions_Ref',
    @level2type = N'COLUMN',
    @level2name = N'Name'