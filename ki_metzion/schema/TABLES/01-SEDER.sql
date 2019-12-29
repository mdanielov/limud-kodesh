USE KiMeTzion

SET NOCOUNT ON;

DROP TABLE IF EXISTS SEDER

CREATE TABLE SEDER
(
SEDER_ID INT NOT NULL IDENTITY,
SEDER_NAME NVARCHAR(120) NOT NULL,
ORDER_ID INT NOT NULL,
CONSTRAINT PK_SEDER PRIMARY KEY  (SEDER_ID),
);