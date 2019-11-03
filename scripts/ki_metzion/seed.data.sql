DECLARE @toshba_id INT

INSERT TOSHBA (WORK_NAME) VALUES('ששה סדרי משנה');

SET @toshba_id=SCOPE_IDENTITY()

INSERT SEDER(TOSHBA_ID,SEDER_NAME,ORDER_ID)
VALUES (@toshba_id,'זרעים',1)
,(@toshba_id,'מועד',2)
,(@toshba_id,'נשים',3)
,(@toshba_id,'נזיקין',4)
,(@toshba_id,'קדשים',5)
,(@toshba_id,'טהרות',6)