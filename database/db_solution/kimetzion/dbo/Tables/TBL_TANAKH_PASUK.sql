﻿CREATE TABLE [dbo].[TBL_TANAKH_PASUK] (
    [PASUK_ID]         INT          IDENTITY (1, 1) NOT NULL,
    [PASUK_NUM]        INT          NOT NULL,
    [PASUK_HEBREW_NUM] NVARCHAR (3) NOT NULL,
    CONSTRAINT [PK_TBL_TANAKH_PASUK_PASUK_ID] PRIMARY KEY CLUSTERED ([PASUK_ID] ASC)
);
