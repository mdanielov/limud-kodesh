USE KiMeTzion;

SET NOCOUNT ON;

DROP TABLE IF EXISTS TBL_YERUSHALMI_HALACHA;

CREATE TABLE TBL_YERUSHALMI_HALACHA
(
HALACHA_ID INT IDENTITY NOT NULL,
HALACHA_NUM INT NOT NULL,
HALACHA_NAME NVARCHAR(2),
CONSTRAINT PK_YERUSHALMI_HALACHA PRIMARY KEY (HALACHA_ID)
);