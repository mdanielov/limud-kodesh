
-- =============================================
-- Author:	נוצר ע"י מאיר מלכא
-- Create date: 18-07-2016
-- Description:פרוצדורה זו תפקידה לקבל מזהה של גרופ ולספק את התוכן של אותו גרופ
-- =============================================
CREATE PROCEDURE [Contents].[sp_GetContentByGroup]
	@groupID int
	
AS
BEGIN
 
	SET NOCOUNT ON;
create table #res(ID int, Content nvarchar(max));

--אם הגרופ קיים בתוכן המרכזי הנה מה טוב ומה נעים
if exists (select top 1 1  from Contents.MainContent where GroupID=@groupID)
insert #res (ID,Content)
select [MainContentID],Content from Contents.MainContent where GroupID=@groupID;
else if exists (select top 1 1  from Contents.[ContentToAlternateGroups] where GroupID=@groupID) 
--אם הגרופ קיים רק כגרופ משני דרך הסופרגרופ יש להתייחס בהתאם
insert #res (ID,Content)
select  [MainContentID],Content  from Contents.MainContent where GroupID=@groupID
else
--אם הגרופ לא מופיע כלל באחד מהמקומות הללו אות היא כי יש לבקשו במורד העץ עד למציאת צאצאיו המתייחסים באופן ישיר לתוכן
begin
select 'not implement'
end

	SELECT  * from #res;
END
RETURN 0
