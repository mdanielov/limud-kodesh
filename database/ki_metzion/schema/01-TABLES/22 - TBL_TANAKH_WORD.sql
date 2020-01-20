USE KiMeTzion

SET NOCOUNT ON;

DROP TABLE IF EXISTS TBL_TANAKH_WORD

CREATE TABLE TBL_TANAKH_WORD
(
WORD_ID INT IDENTITY NOT NULL,
PEREK_PASUK_ID INT NOT NULL,
ROW_NUM INT NOT NULL,
WORD_POSITION INT NOT NULL,
IS_KTIV BIT NOT NULL,
IS_KRI BIT NOT NULL,
WORD NVARCHAR(100) NOT NULL,
CONSTRAINT PK_TBL_TANAKH_WORD_WORD_ID PRIMARY KEY (WORD_ID),
CONSTRAINT FK_TBL_TANAKH_WORD_PEREK_PASUK_ID FOREIGN KEY (PEREK_PASUK_ID) REFERENCES TBL_TANAKH_PEREK_PASUK (PEREK_PASUK_ID)
);