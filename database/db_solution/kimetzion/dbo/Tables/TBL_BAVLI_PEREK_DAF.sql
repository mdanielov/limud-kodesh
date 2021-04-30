﻿CREATE TABLE [dbo].[TBL_BAVLI_PEREK_DAF] (
    [BAVLI_PEREK_DAF_ID] INT IDENTITY (1, 1) NOT NULL,
    [PEREK_ID]           INT NOT NULL,
    [DAF_START]          INT NOT NULL,
    [AMUD_START]         INT NOT NULL,
    [DAF_END]            INT NOT NULL,
    [AMUD_END]           INT NOT NULL,
    CONSTRAINT [PK_TBL_BAVLI_PEREK_DAF_ID] PRIMARY KEY CLUSTERED ([BAVLI_PEREK_DAF_ID] ASC),
    CONSTRAINT [FK_TBL_BAVLI_PEREK_DAF_PEREK_ID] FOREIGN KEY ([PEREK_ID]) REFERENCES [dbo].[TBL_MASSECHET_PEREK] ([PEREK_ID])
);
