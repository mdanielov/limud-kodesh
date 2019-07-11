CREATE TABLE [UI].[GroupsProperties]
(
	[ID] INT NOT NULL PRIMARY KEY, 
    [GroupID] INT NOT NULL, 
    [PropertyName] NVARCHAR(4000) NULL, 
    [PropertyValue] NVARCHAR(MAX) NULL, 
    CONSTRAINT [FK_GroupsProperties_ToGroups] FOREIGN KEY ([GroupID]) REFERENCES [Contents].[ContentGroups]([GroupID]) ON DELETE CASCADE ON UPDATE CASCADE
)

GO

CREATE INDEX [IX_GroupsProperties_PropertyName] ON [UI].[GroupsProperties] ([PropertyName])
