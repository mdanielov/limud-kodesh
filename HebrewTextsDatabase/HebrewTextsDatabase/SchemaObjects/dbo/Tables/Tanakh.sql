CREATE TABLE [Import].[Tanakh] (
    [ID]       INT            NOT NULL,
    [BookID]   INT            NOT NULL,
    [Chapter]  INT            NOT NULL,
    [Verse]    INT            NOT NULL,
    [Content]  NVARCHAR (MAX) NOT NULL,
	[NetContent]  NVARCHAR (MAX) NULL,
    [TextOnly] NVARCHAR (MAX) NULL,
    [NewBookID] INT NULL, 
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

