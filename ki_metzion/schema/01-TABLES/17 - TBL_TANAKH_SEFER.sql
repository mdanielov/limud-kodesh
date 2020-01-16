USE KiMeTzion
GO

SET NOCOUNT ON;

DROP TABLE IF EXISTS dbo.TBL_TANAKH_SEFER

CREATE TABLE dbo.TBL_TANAKH_SEFER
(
SEFER_ID INT IDENTITY NOT NULL,
CATEGORY_ID INT NOT NULL,
SEFER_HEBREW_NAME NVARCHAR(50) NOT NULL,
SEFER_ENGLISH_NAME NVARCHAR(50) NOT NULL,
CONSTRAINT PK_TBL_TANAKH_SEFER_SEFER_ID PRIMARY KEY (SEFER_ID),
CONSTRAINT FK_TBL_TANAKH_SEFER_CATEGORY_ID FOREIGN KEY (CATEGORY_ID) REFERENCES dbo.TBL_TANAKH_CATEGORY (CATEGORY_ID)
)
GO