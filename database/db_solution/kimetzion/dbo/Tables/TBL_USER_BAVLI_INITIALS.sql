CREATE TABLE [dbo].[TBL_USER_BAVLI_INITIALS] (
    [USER_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [STATUS]         BIT            DEFAULT ((0)) NOT NULL,
    [MASSECHET_NAME] NVARCHAR (50)  NULL,
    [DAF_NAME]       NVARCHAR (3)   NULL,
    [AMUD_NAME]      NVARCHAR (1)   NULL,
    [ROW_ID]         INT            NULL,
    [WORD_POSITION]  INT            NULL,
    [INITIAL]        NVARCHAR (50)  NULL,
    [EXPANDED]       NVARCHAR (100) NULL
);

