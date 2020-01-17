
-- =============================================
-- Author:	  מאיר מלכא
-- Create date: 18-07-2016
-- Description:פרוצדורה זו מאתחלת את הזרעת הנתונים לתוך מסד הנתונים כגון סוגי גרופים וכדומה
-- =============================================
CREATE PROCEDURE [Contents].[sp_InitSeedMetaData]
	 
AS


create table #groupsAndDividingTypes(Name  nvarchar(255),KeyWordIndex nvarchar(255),[Description] NVARCHAR(MAX) NULL, GroupLevel int null)
insert #groupsAndDividingTypes (Name,KeyWordIndex,GroupLevel,Description)
values
('ספר','Book',0,'הספר בכבודו ובעצמו כגון "ספר בראשית"'),
('קבוצת ספרים','BooksGroup',2,'הקבצה של מספר ספרים כגון "חמישה חומשי תורה", שישה סדרי משנה, תלמוד בבלי, וכן הלאה'),
('כרך','Volume',-1,'כרך של ספר המחולק לכרכים, לא מדובר בספר בן כמה חלקים!!!! אלא ספר שמבחינה פרקטית חילקו אותו לכרכים כגון אנציקלופדיה'),
('ספר בעל חלקים',null,1,'ספר שיש בו חלקים, כגון חלק אלף וחלק ב וכדומה, זוהי קבוצה שמעל הספר ברמה אחת (כגון מלכים א ומלכים ב)'),
('פרק','Chapter',-2,'פרק הוא תחת מסכת או תחת ספר, ולכן הוא רמה מתחת למסכת'),
('פסוק','Verse',-3,'פסוק לעולם תחת פרק'),
('פיסקה','Paragraph',0,'פיסקה בגמרא'),
('משפט','Statement',1,'משפט כלשהו בספר'),
('משנה בתלמוד','MishnaInTalmud',-3,'משנה בתוך התלמוד זהו בעצם גרופ שתפקידו לציין קטע משנה המשובץ בתוך התלמוד הבבלי'),
('גמרא בתלמוד','GmaraInTalmud',-3,'גמרא בתוך התלמוד זהו גרופ שתפקידו להצביע על כל קטע הגמרא שבין משנה למשנה')

--מעדכן מילות מפתח לאלו שקיימים
update g
set KeyWordIndex =tg.KeyWordIndex
from
Contents.GroupsAndDividingTypes g
join #groupsAndDividingTypes tg on g.Name=tg.Name
where g.KeyWordIndex is null 
and not exists(select top 1 1 from Contents.GroupsAndDividingTypes where KeyWordIndex = tg.KeyWordIndex)

--מוסיף את אלו שלא קיימים עדיין במערכת
insert Contents.GroupsAndDividingTypes(Name,KeyWordIndex,Description,GroupLevel)
select Name,KeyWordIndex,Description,GroupLevel
from #groupsAndDividingTypes
where KeyWordIndex not in (select KeyWordIndex from Contents.GroupsAndDividingTypes where KeyWordIndex is not null)

declare @GroupTypeBooksGroup int = (select top 1 ID from Contents.GroupsAndDividingTypes where KeyWordIndex='BooksGroup')


--מוסיף גרופים יסודיים במערכת כגון תנך משנה ותלמוד ומדרשים וכדומה

create table #contentGroups(GroupName nvarchar(max),KeyWordIndex nvarchar (50),GroupType int)
insert #contentGroups(GroupName,KeyWordIndex,GroupType)
values('תנך','Tanakh',@GroupTypeBooksGroup),
('משנה','Mishna',@GroupTypeBooksGroup),
('תלמוד בבלי','TalmudBavli',@GroupTypeBooksGroup)

--עדכון מילת מפתח למי שאין לו
update cg
set cg.KeyWordIndex = cgt.KeyWordIndex
from Contents.ContentGroups cg join #contentGroups cgt on cg.GroupName=cgt.GroupName and cg.GroupType=cgt.GroupType
--עדכון חדשים
insert Contents.ContentGroups(GroupName,KeyWordIndex,GroupType)
select GroupName,KeyWordIndex,GroupType
from #contentGroups tcg
where not exists(select 1 from Contents.ContentGroups where GroupName=tcg.GroupName and GroupType=tcg.GroupType and KeyWordIndex=tcg.KeyWordIndex)

RETURN 0
