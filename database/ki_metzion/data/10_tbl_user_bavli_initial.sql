INSERT INTO TBL_USER_BAVLI_INITIALS
(
[MASSECHET_NAME]
,[DAF_NAME]
,[AMUD_NAME]
,[ROW_ID]
,[WORD_POSITION]
,[INITIAL]
)
select * from (
select --top 100
M.massechet_name
,D.daf_name
,D.amud_name
--,MW.Massechet_daf_id
,MW.row_id
,MW.word_position
,MW.word
from
TBL_BAVLI_WORD MW
JOIN TBL_MASSECHET_DAF MD ON MW.Massechet_daf_id = MD.massechet_daf_id
JOIN TBL_DAF D  ON MD.daf_amud_id = D.daf_amud_id
JOIN TBL_MASSECHET M ON M.massechet_id = MD.massechet_id
where 1=1
) x
where word like '%"%'