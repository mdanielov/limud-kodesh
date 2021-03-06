﻿CREATE TABLE [dbo].[TBL_BAVLI_COMPLETE_DEF] (
    [COMP_DEF_ID] INT IDENTITY (1, 1) NOT NULL,
    [COMP_ID]     INT NOT NULL,
    [WORD_DEF_ID] INT NOT NULL,
    CONSTRAINT [PK_TBL_BAVLI_COMPLETE_DEF] PRIMARY KEY CLUSTERED ([COMP_DEF_ID] ASC),
    CONSTRAINT [FK_BAVLI_COMPLETION] FOREIGN KEY ([COMP_ID]) REFERENCES [dbo].[TBL_BAVLI_WORD_COMPLETE] ([COMP_ID]),
    CONSTRAINT [FK_COMPLETE_DEFITION] FOREIGN KEY ([WORD_DEF_ID]) REFERENCES [dbo].[TBL_WORD_DEF] ([WORD_DEF_ID])
);



