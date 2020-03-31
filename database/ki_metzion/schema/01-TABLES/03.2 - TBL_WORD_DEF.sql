SET NOCOUNT ON;

DROP TABLE IF EXISTS TBL_WORD_DEF;

CREATE TABLE TBL_WORD_DEF
(
WORD_DEF_ID INT IDENTITY NOT NULL,
WORD_ID INT NOT NULL,
WORD_DEF NVARCHAR (100) NOT NULL,
CONSTRAINT PK_TBL_WORD_DEF_ID PRIMARY KEY (WORD_DEF_ID),
CONSTRAINT FK_TBL_WORD_DEF_WORD_ID FOREIGN KEY (WORD_ID) REFERENCES TBL_WORD (WORD_ID)
);