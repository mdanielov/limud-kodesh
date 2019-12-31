CREATE FUNCTION get_amud_id (@masechet_id nvarchar(60))
RETURNS nvarchar


BEGIN 
	SELECT bavli_daf_amud_id FROM KiMeTzion.dbo.[BAVLI_DAF]
	--WHERE MASSECHET_ID='@masechet_id'
	RETURN bavli_daf_amud_id;
END