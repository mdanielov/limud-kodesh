CREATE TABLE [Contents].[SetContentLog]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [GrpupID] INT NOT NULL, 
    [FullContent] NVARCHAR(MAX) NOT NULL, 
    [Status] NVARCHAR(50) NULL,
    [AddedRecordDate] DATETIME NOT NULL DEFAULT getdate()
)
