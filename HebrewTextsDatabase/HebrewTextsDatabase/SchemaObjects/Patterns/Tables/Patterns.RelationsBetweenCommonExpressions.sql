CREATE TABLE [Patterns].[RelationsBetweenCommonExpressions]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [FromCommonExpressionID] INT NOT NULL, 
    [ToCommonExpressionID] INT NOT NULL, 
    [RelationType] INT NOT NULL, 
    [RelationDescription] NVARCHAR(MAX) NULL, 
    CONSTRAINT [FK_RelationsBetweenCommonExpressions_ToTable] FOREIGN KEY (RelationType) REFERENCES  [Patterns].[RelationTypesBetweenCommonExpressions_Ref]([RelationTypeID])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'בטבלה זו ישנם קשרים בין ביטויים נפוצים מכיוון שישנם ביטויים נפוצים שיש ביניהם קשר
	למשל פוק חזי או צא וראה שזהו בעצם אותו ביטוי רק בתרגום שונה
	או לדוגמא תא חזי ופוק חזי ביטוי דומה מאוד וניתן לשאול מדוע השתמשו פעם בתא ופעם בפוק
	דוגמא עמוקה יותר תא שמע לעומת תא חזי כאן בוודאי שניתן למנות קשר האומר דרשני מתי השתמשו בשמיעה ומתי בראייה
	קשר יכול להיות גם אנטי קשר כלומר היפוך לדוגמא ביטויים שהם הפכים נוכל לרשום ביניהם קשר של היפוך
	',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenCommonExpressions'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הביטוי הנפוץ אליו מקשרים את הביטוי השני',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenCommonExpressions',
    @level2type = N'COLUMN',
    @level2name = N'FromCommonExpressionID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הביטוי השני המקושר אל הביטוי הראשון',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenCommonExpressions',
    @level2type = N'COLUMN',
    @level2name = N'ToCommonExpressionID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'סוג הקשר, זהות גמורה במילים שונות, תרגום מארמית לעברית, תוכן דומה, רעיון דומה וכן הלאה',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenCommonExpressions',
    @level2type = N'COLUMN',
    @level2name = N'RelationType'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'הסבר מילולי אודות הקשר',
    @level0type = N'SCHEMA',
    @level0name = N'Patterns',
    @level1type = N'TABLE',
    @level1name = N'RelationsBetweenCommonExpressions',
    @level2type = N'COLUMN',
    @level2name = N'RelationDescription'