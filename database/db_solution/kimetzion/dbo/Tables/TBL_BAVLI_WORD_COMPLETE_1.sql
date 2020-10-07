﻿CREATE TABLE [dbo].[TBL_BAVLI_WORD_COMPLETE] (
    [COMP_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [BAVLI_WORD_ID] INT            NOT NULL,
    [COMPLETION]    NVARCHAR (120) NULL,
    CONSTRAINT [PK_TBL_BAVLI_WORD_COMPLETE] PRIMARY KEY CLUSTERED ([COMP_ID] ASC),
    CONSTRAINT [FK_BAVLI_WORD] FOREIGN KEY ([BAVLI_WORD_ID]) REFERENCES [dbo].[TBL_BAVLI_WORD] ([BAVLI_WORD_ID])
);

