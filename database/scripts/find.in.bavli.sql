﻿use KiMeTzion
select * from (
select top 100 percent
M.MASSECHET_NAME
,MD.MASSECHET_ID
,MP.PEREK_NAME
,D.DAF_NAME
--,D.DAF_NUM
,D.AMUD_NAME
--,D.AMUD_NUM
,MW.row_id
,MW.WORD_POSITION
,(select word from TBL_MASSECHET_WORD where word_id = MW.WORD_ID + 1) [next_word]
,MW.WORD
,(select word from TBL_MASSECHET_WORD where word_id = MW.WORD_ID - 1) [previous_word]
from TBL_MASSECHET_WORD MW 
JOIN TBL_MASSECHET_DAF MD ON MW.MASSECHET_DAF_ID = MD.MASSECHET_DAF_ID
JOIN TBL_DAF D ON MD.DAF_AMUD_ID = D.DAF_AMUD_ID
JOIN TBL_MASSECHET M ON M.MASSECHET_ID = MD.MASSECHET_ID
JOIN TBL_MASSECHET_PEREK MP ON MW.PEREK_ID = MP.PEREK_ID AND MD.MASSECHET_ID = MP.MASSECHET_ID
where 
word like '%חמו%' 
and MP.PEREK_ID=180
order by DAF_NUM,AMUD_NUM,row_id,WORD_POSITION
) A
--where [previous_word] = N'בא'
--order by DAF_NUM,AMUD_NUM,row_id,WORD_POSITION
order by MASSECHET_ID
