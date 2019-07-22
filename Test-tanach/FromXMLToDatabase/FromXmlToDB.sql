
IF OBJECT_ID('tempdb..#FromXml') IS NOT NULL DROP TABLE #FromXml
CREATE TABLE #FromXml(ID int IDENTITY(1,1) PRIMARY KEY,BookName nvarchar(100),
 Content nvarchar(max), Chapter int,
  Verse int, WordSequence int,
   StartPerekBeforeWord bit,
    EndPerekAfterWord bit,
	 IsParashaPtuchah bit)
GO

DECLARE @XmlFile XML



--select * from #FromXml order by BookName, Chapter






SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Amos.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Bamidbar.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Bereshit.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Chemot.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Daniel.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Devarim.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)
SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\DivreiHaYamimA.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)
SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\DivreiHaYamimB.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Eikhah.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Ester.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Ezra.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Havakuk.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Hoshea.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Iyyobh.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Khagay.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Malakhi.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\MelakhimA.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\MelakhimB.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Mikhah.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Mishlei.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Nahum.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Nehemiah.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Ovadyah.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Qoheleth.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Ruth.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\ShemuelA.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\ShemuelB.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\ShirHashshirim.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)
SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Shoftim.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Tehillim.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Tsefanya.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Vayikra.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Yehoshua.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Yekhezqel.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Yeshayahu.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Yirmeyahu.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Yoel.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Yonah.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)

SELECT @XmlFile =  BulkColumn FROM OPENROWSET(BULK 'C:\Matarah\limud-kodesh\FilesAndStuffs\ImportsDataFrom3rdParty\Tanakh\FromSefaria\XMLFilesProcessed\Zekharyah.xml' ,SINGLE_BLOB) AS x
INSERT INTO #FromXml (BookName , Content, Chapter,Verse , WordSequence, StartPerekBeforeWord,EndPerekAfterWord,IsParashaPtuchah)
	SELECT
		BookName = Events.value('@Book', 'nvarchar(100)'),
		Content = Events.value('.', 'nvarchar(max)'),
		Chapter = Events.value('@Chapter', 'int'),
		Verse= Events.value('@Verse', 'int'),
		WordSequence = Events.value('@WordSequence','int'),
		CASE
		WHEN (Events.value('@StartPerekBeforeWord','bit')) = 'true' THEN '1'
		ELSE '0'
		END AS StartPerekBeforeWord,
		CASE
		WHEN (Events.value('@EndPerekAfterWord', 'bit')) = 'true' then '1'
		ELSE '0' 
		END AS EndPerekAfterWord,
		CASE 
		WHEN (Events.value('@IsParashaPtuchah','bit')) = 'true' THEN '1'
		ELSE '0' 
		END AS IsParashaPtuchah
	FROM
	 @XmlFile.nodes('/Tanakh/Word') AS XTbl(Events)