CREATE TABLE [Content].[Nikud_Ref]
(
[NikudId] [int] NOT NULL,
[Nikud] [nvarchar] (30) COLLATE Hebrew_CI_AI NULL,
[Nikud_name] [nvarchar] (50) COLLATE Hebrew_CI_AI NULL
)
GO
ALTER TABLE [Content].[Nikud_Ref] ADD CONSTRAINT [PK__Nikud_Re__AF39E574DC89ADAF] PRIMARY KEY CLUSTERED  ([NikudId])
GO
