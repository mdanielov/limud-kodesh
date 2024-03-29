﻿CREATE TABLE [dbo].[TBL_USER_YERUSHALMI_INITIALS] (
    [USER_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [STATUS]         BIT            DEFAULT ((0)) NOT NULL,
    [MASSECHET_NAME] NVARCHAR (50)  NULL,
    [HALACHA_NAME]   NVARCHAR (3)   NULL,
    [PEREK_NAME]     NVARCHAR (1)   NULL,
    [WORD_POSITION]  INT            NOT NULL,
    [INITIAL]        NVARCHAR (50)  NULL,
    [EXPANDED]       NVARCHAR (100) NULL,
    [EXPANDED_ID]    INT            NULL
);

