IF OBJECT_ID('tempdb..#TMP_WORD') IS NOT NULL DROP TABLE #TMP_WORD

CREATE TABLE #TMP_WORD (WORD NVARCHAR(100))

INSERT INTO #TMP_WORD (WORD)
select DISTINCT WORD FROM TBL_TANAKH_WORD

INSERT INTO #TMP_WORD (WORD)
select distinct word from tbl_bavli_word

INSERT INTO #TMP_WORD (WORD)
select distinct word from TBL_YERUSHALMI_MASSECHET_WORD 

INSERT INTO TBL_WORD
select distinct word from #TMP_WORD where word not like '' order by 1

select * from TBL_WORD