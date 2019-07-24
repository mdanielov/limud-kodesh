--DECLARE @xmlFilesPath NVARCHAR(255) = 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Amos.xml';
--DECLARE @versionName NVARCHAR(100) = '';
CREATE TABLE #FromXml(BookName nvarchar(100),Content nvarchar(max), Chapter int, Verse int, WordSequence int,StartPerekBeforeWord bit case
,EndPerekAfterWord bit , IsParashaPtuchah bit);
-- LOOP over all files
--drop table  #FromXml

DECLARE @XmlFile XML

SELECT @XmlFile = BulkColumn
FROM  OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Amos.xml', SINGLE_BLOB) x;

INSERT INTO  #FromXml(BookName,Content,Chapter,Verse,WordSequence,StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
SELECT
	BookName= Events.value('@Book','nvarchar(100)'),
	Content=Events.value('.','nvarchar(max)'),
	Chapter= Events.value('@Chapter','int'),
	Verse= Events.value('@Verse','int'),
	WordSequence= Events.value('@WordSequence','int'),
	StartPerekBeforeWord=Events.value('@StartPerekBeforeWord','bit'),
	EndPerekAfterWord=Events.value('@EndPerekAfterWord','bit'),
	IsParashaPtuchah=Events.value('@IsParashaPtuchah','bit')

	FROM @XmlFile.nodes('Tanakh/Word') AS XTbl(Events)

	Update #FromXml Set StartPerekBeforeWord = 0
	Where StartPerekBeforeWord Is Null;
	Update #FromXml Set EndPerekAfterWord = 0
	Where EndPerekAfterWord Is Null; 
	Update #FromXml Set IsParashaPtuchah = 0
	Where IsParashaPtuchah Is Null; 

select * from #FromXml

	--TRUNCATE TABLE #FromXml