IF OBJECT_ID('tempdb..#FromXml') IS NOT NULL DROP TABLE #FromXml

CREATE TABLE #FromXml(ID int IDENTITY(1,1) PRIMARY KEY,BookName nvarchar(100),
 Content nvarchar(max), Chapter int,
  Verse int, WordSequence int,
   StartPerekBeforeWord bit,
    EndPerekAfterWord bit,
	 IsParashaPtuchah bit)
GO

IF OBJECT_ID('tempdb..#FilesXml') IS NOT NULL DROP TABLE #FilesXml
CREATE TABLE #FilesXml(ID int IDENTITY(1,1) PRIMARY KEY, FileName nvarchar(100),BookSequence INT NULL)

INSERT INTO #FilesXml (FileName)
EXEC MASTER..xp_cmdshell 'dir /B C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\*.xml' 




DECLARE @i int;
DECLARE @NameFile nvarchar(100);
SET @i =1
WHILE @i <= (select max(ID-1) from #FilesXml)
BEGIN
	select @NameFile= FileName from #FilesXml where ID = @i

DECLARE @Xml XML
DECLARE @path nvarchar(max) = concat('C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\',@NameFile)
DECLARE @Sql nvarchar(max) = N'SELECT @XML= cast(BulkColumn AS XML) FROM OPENROWSET(BULK' + CHAR(39) + @path + CHAR(39) + ', SINGLE_BLOB) AS x'
EXEC sp_ExecuteSQL @Sql, N'@XML xml OUTPUT', @XML OUTPUT


--SELECT @Xml =  BulkColumn FROM OPENROWSET(BULK  'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartParashaBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndParashaAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @Xml.nodes('/Tanakh/Word') AS XTbl(Events);

	 Set @i = @i +1
END




DROP TABLE #FilesXml