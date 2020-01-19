CREATE PROCEDURE [Contents].[SetContentForGroup]
	@groupID int,
	@content nvarchar(max)
AS
-- מוחק את כל התוכן של אותו גרופ אם קיים ומגדיר אותו מחדש

--יש לבדוק תחילה שאכן ישנו כזה גרופ בנמצא
--אם לא נמצא גרופ כזה יש לזרוק שגיאה


declare @SequenceNumber int = 1;
;with tmp(SequenceNumber, ContentItem, Data) as (
select @SequenceNumber, LEFT( @content, CHARINDEX(' ', @content+' ')-1), STUFF( @content, 1, CHARINDEX(' ', @content+' '), '')
union all
select SequenceNumber+1, LEFT(Data, CHARINDEX(' ',Data+' ')-1),STUFF(Data, 1, CHARINDEX(' ',Data+' '), '')
from tmp
where Data > ''
)
select SequenceNumber,ContentItem into #contentTable
from tmp
order by SequenceNumber

insert SetContentLog(GrpupID,FullContent)
select @groupID,@content 

delete from Contents.[MainContent] where GroupID=@groupID;

insert Contents.[MainContent](GroupID,[SequenceNumber],Content)
select @groupID,SequenceNumber,ContentItem
 from #contentTable;

drop table #contentTable;

RETURN 0
