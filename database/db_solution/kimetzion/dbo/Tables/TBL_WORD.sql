﻿CREATE TABLE [dbo].[TBL_WORD] (
    [WORD_ID] INT            IDENTITY (1, 1) NOT NULL,
    [WORD]    NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_TBL_WORD_ID] PRIMARY KEY CLUSTERED ([WORD_ID] ASC)
);

