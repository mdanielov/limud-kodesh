CREATE TABLE [Persons].[Personalities]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(MAX) NULL,
	[BornHebrewYear] INT NULL, 
    [DeathHebrewYear] INT NULL, 
    [LivingArea] NVARCHAR(MAX) NULL, 
    [StudyPlace] NVARCHAR(MAX) NULL, 
    [Description] NVARCHAR(MAX) NULL, 
    [Comments] NVARCHAR(MAX) NULL
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה זו מכילה אישים אשר חיברו את הספרים או שבשמם נאמר דבר מה',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'Personalities'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שם האיש',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'Personalities',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שנת לידה עברית משוערת',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'Personalities',
    @level2type = N'COLUMN',
    @level2name = N'BornHebrewYear'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שנת פטירה עברית משוערת',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'Personalities',
    @level2type = N'COLUMN',
    @level2name = N'DeathHebrewYear'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'אזור מגורים',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'Personalities',
    @level2type = N'COLUMN',
    @level2name = N'LivingArea'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'אזור לימודים',
    @level0type = N'SCHEMA',
    @level0name = N'Persons',
    @level1type = N'TABLE',
    @level1name = N'Personalities',
    @level2type = N'COLUMN',
    @level2name = N'StudyPlace'