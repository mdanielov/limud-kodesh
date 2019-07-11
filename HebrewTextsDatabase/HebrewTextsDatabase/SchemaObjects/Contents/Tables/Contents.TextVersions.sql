CREATE TABLE [Contents].[TextVersions]
(
	[VersionID] INT NOT NULL PRIMARY KEY IDENTITY (1,1), 
    [Name] NVARCHAR(50) NULL, 
    [Description] NVARCHAR(MAX) NULL, 
    [Comments] NVARCHAR(MAX) NULL, 
    [BookPublishing] NVARCHAR(MAX) NULL

)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ההוצאה לאור של גירסה זו',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'TextVersions',
    @level2type = N'COLUMN',
    @level2name = N'BookPublishing'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'שם הגירסה',
    @level0type = N'SCHEMA',
    @level0name = N'Contents',
    @level1type = N'TABLE',
    @level1name = N'TextVersions',
    @level2type = N'COLUMN',
    @level2name = N'Name'