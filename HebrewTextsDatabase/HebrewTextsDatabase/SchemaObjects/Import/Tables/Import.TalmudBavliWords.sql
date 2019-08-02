CREATE TABLE [Import].[TalmudBavliWords] (
    [KeyWordIndex]   NVARCHAR (75)  NOT NULL,
    [Word]           NVARCHAR (MAX) NULL,
    [SequenceNumber] BIGINT         NULL,
    [RootGroupID]    INT            NOT NULL
);

