CREATE FUNCTION get_daf_amud_id (@masechet_id nvarchar(60))
RETURNS nvarchar


BEGIN 
	SELECT DAF_AMUD_ID FROM KiMeTzion.dbo.[TBL_DAF] 
	--WHERE MASSECHET_ID='@masechet_id'
	RETURN DAF_AMUD_ID;
END