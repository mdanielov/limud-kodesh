CREATE TABLE [Content].[Letter_Ref]
(
[LetterId] [int] NOT NULL,
[Letter] [nvarchar] (5) COLLATE Hebrew_CI_AI NULL,
[Letter_name] [nvarchar] (20) COLLATE Hebrew_CI_AI NULL,
[MotsaId] [int] NULL,
[Is_Sofi] [int] NULL
)
GO
ALTER TABLE [Content].[Letter_Ref] ADD CONSTRAINT [PK__Letter_R__AE46E8F1F7A8F72C] PRIMARY KEY CLUSTERED  ([LetterId])
GO
