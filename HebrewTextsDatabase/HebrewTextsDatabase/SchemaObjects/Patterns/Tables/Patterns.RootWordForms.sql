CREATE TABLE [Patterns].[RootWordForms]
(
	[RootWordFormID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [RootWordID] INT NOT NULL, 
    [WordForm] NVARCHAR(50) NOT NULL, 
    [Comment] NVARCHAR(MAX) NULL, 
    CONSTRAINT [FK_RootWordForms_ToRootWord] FOREIGN KEY (RootWordID) REFERENCES Patterns.RootWords(RootWordID) ON DELETE CASCADE ON UPDATE CASCADE
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'טבלה המכילה צורות שונות של שורשים
לא לכל שורש אנחנו צריכים לפרט צורות מופעים
אלא רק לשורשים שאותם המכונה לא תוכל לזהות מבלי הצורות השונות
למשל שורש עשה מכיל גם צורה של ביום עשות אלהים ארץ ושמים
אולם איננו קשור למעיו עשת שן מעולפת ספירים
לכן כאשר יש צורך בפירוט צורות השורש 
על מנת לסייע למכונה למצוא את המופעים הנכונים בתנ"ך',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWordForms'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הפניה למזהה שורש המילה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWordForms',
    @level2type = N'COLUMN',
    @level2name = N'RootWordID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'צורת המילה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWordForms',
    @level2type = N'COLUMN',
    @level2name = N'WordForm'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הערות בנוגע לצורת המילה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RootWordForms',
    @level2type = N'COLUMN',
    @level2name = N'Comment'