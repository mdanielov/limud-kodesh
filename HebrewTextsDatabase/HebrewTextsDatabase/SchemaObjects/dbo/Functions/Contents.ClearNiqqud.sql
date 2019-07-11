CREATE FUNCTION [dbo].[ClearNiqqud]
(
	@inputText nvarchar(max)
	
)
RETURNS nvarchar(max)
AS
BEGIN


-- מנקה את הניקוד מתוך טקסט נתון ומחזיר את הטקסט ללא ניקוד וללא מקפים כלל ועיקר

DECLARE @position int, @string nvarchar(max),@result nvarchar(max);
-- Initialize the variables.  
SET @position = 1;  
   DECLARE @currentChar char ;
   DECLARE @asciiVal int ;
WHILE @position <= DATALENGTH(@inputText)  
   BEGIN  
   SET @currentChar  = (SUBSTRING(@inputText, @position, 1));
   SET @asciiVal = (ASCII(@currentChar));

   IF @asciiVal  between 224 and 250 or @asciiVal = 32 --רק אותיות א עד ת או רווחים מותרים
   SET @result = CONCAT(@result,@currentChar)
   
   
    SET @position = @position + 1  
   END;  

RETURN @result;

END
