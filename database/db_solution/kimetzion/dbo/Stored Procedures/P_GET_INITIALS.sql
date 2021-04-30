﻿CREATE PROCEDURE P_GET_INITIALS  
@INITIAL NVARCHAR(30)  
  
AS  
  
BEGIN  
  
SELECT a.MASSECHET_NAME, a.DAF_NAME, a.AMUD_NAME, a.ROW_ID  
FROM TBL_USER_BAVLI_INITIALS a   
LEFT JOIN TBL_INITIALS b ON b.INITIALS = a.INITIAL and a.EXPANDED = b.EXPANDED
WHERE b.INITIALS is NULL
and A.INITIAL = @INITIAL  
AND A.EXPANDED is NULL  
END