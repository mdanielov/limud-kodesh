CREATE TABLE [Content].[Taam_Ref]
(
[TaamId] [int] NOT NULL,
[Taam] [nvarchar] (30) COLLATE Hebrew_CI_AI NULL,
[Taam_name] [nvarchar] (50) COLLATE Hebrew_CI_AI NULL
)
GO
ALTER TABLE [Content].[Taam_Ref] ADD CONSTRAINT [PK__Taam_Ref__C991DDA2B419D953] PRIMARY KEY CLUSTERED  ([TaamId])
GO
