CREATE TABLE [Patterns].[CommonExpressionsToGroups]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [CommonExpressionID] INT NULL, 
    [GroupID] INT NULL, 
    CONSTRAINT [FK_CommonExpressionsToGroups_ToCommonExpressions] FOREIGN KEY (CommonExpressionID) REFERENCES Patterns.CommonExpressions(ID) ON DELETE Cascade ON UPDATE Cascade, 
    CONSTRAINT [FK_CommonExpressionsToGroups_ToContentGroups] FOREIGN KEY ([GroupID]) REFERENCES Contents.ContentGroups([GroupID])  ON DELETE Cascade ON UPDATE Cascade, 
)
