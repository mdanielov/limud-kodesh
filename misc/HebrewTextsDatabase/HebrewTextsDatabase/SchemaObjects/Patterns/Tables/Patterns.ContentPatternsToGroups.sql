CREATE TABLE [Patterns].[ContentPatternsToGroups]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [ContentPatternID] INT NOT NULL, 
    [GroupID] INT NOT NULL, 
    CONSTRAINT [FK_ContentPatternsToGroups_ToContentPatterns] FOREIGN KEY (ContentPatternID) REFERENCES Patterns.ContentPatterns([ContentPatternID]),
    CONSTRAINT [FK_ContentPatternsToGroups_ToContentGroups] FOREIGN KEY ([GroupID]) REFERENCES Contents.ContentGroups([GroupID])  ON DELETE CASCADE ON UPDATE CASCADE, 
)
