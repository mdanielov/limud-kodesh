USE KiMeTzion;

DROP TABLE IF EXISTS dbo.TBL_TANAKH_CATEGORY


CREATE TABLE dbo.TBL_TANAKH_CATEGORY
(
CATEGORY_ID INT IDENTITY NOT NULL,
CATEGORY_HEBREW_NAME NVARCHAR(50) NOT NULL,
CATEGORY_ENGLISH_NAME NVARCHAR(50) NOT NULL,
CONSTRAINT PK_TBL_TANAKH_CATEGORY_CATEGORY_ID PRIMARY KEY (CATEGORY_ID)
)
