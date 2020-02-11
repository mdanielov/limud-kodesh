USE KiMeTzion;

SET NOCOUNT ON;

DROP TABLE IF EXISTS TBL_YERUSHALMI_MASSECHET_WORD;

CREATE TABLE TBL_YERUSHALMI_MASSECHET_WORD
(
WORD_ID INT IDENTITY NOT NULL,
MASSECHET_HALACHA_ID INT NOT NULL,
WORD_TYPE BIT NOT NULL, -- 0 mishna or 1 gemara
WORD NVARCHAR (50) NOT NULL,
W_DELETED bit NOT NULL,
W_ADDED bit NOT NULL,
CONSTRAINT PK_TBL_YERUSHALMI_MASSECHET_WORD PRIMARY KEY (WORD_ID),
CONSTRAINT FK_TBL_YERUSHALMI_MASSECHET_WORD_MASSECHET_HALACHA_ID FOREIGN KEY (MASSECHET_HALACHA_ID) REFERENCES TBL_YERUSHALMI_MASSECHET_HALACHA(MASSECHET_HALACHA_ID)
);