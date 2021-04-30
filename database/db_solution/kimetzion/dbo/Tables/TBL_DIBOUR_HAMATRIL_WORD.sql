﻿CREATE TABLE [dbo].[TBL_DIBOUR_HAMATRIL_WORD] (
    [DIBOUR_HAMATRIL_WORD_ID] INT           IDENTITY (1, 1) NOT NULL,
    [DIBOUR_HAMATRIL_ID]      INT           NOT NULL,
    [DIBOUR_HAMATRIL_WORD]    NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TBL_DIBOUR_HAMATRIL_WORD] PRIMARY KEY CLUSTERED ([DIBOUR_HAMATRIL_WORD_ID] ASC),
    CONSTRAINT [FK_TBL_DIBOUR_HAMATRIL_WORD_DIBOUR_HAMATRIL_ID] FOREIGN KEY ([DIBOUR_HAMATRIL_ID]) REFERENCES [dbo].[TBL_DIBOUR_HAMATRIL] ([DIBOUR_HAMATRIL_ID])
);
