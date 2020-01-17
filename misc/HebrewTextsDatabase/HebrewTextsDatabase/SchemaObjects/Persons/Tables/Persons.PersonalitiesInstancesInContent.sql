CREATE TABLE [Persons].[PersonalitiesInstancesInContent]
(
	[InstanceID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [PersonalityID] INT NOT NULL, 
    [ContentID] INT NULL, 
    [GroupID] INT NULL, 
    CONSTRAINT [FK_InstancesInContent_ToPersonalities] FOREIGN KEY (PersonalityID) REFERENCES Persons.Personalities(ID)
)
