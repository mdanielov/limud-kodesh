CREATE TABLE [Import].[RawImportStuffs]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY,
	GroupSequenceLevel1 INT, 
    [GroupSequenceLevel2] INT NULL, 
    [GroupSequenceLevel3] INT NULL, 
    [Content] NVARCHAR(MAX) NULL, 
    [Description] NVARCHAR(MAX) NULL, 
    [Source] NVARCHAR(MAX) NULL,
)
