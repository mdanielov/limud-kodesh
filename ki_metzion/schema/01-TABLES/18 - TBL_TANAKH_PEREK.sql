USE KiMeTzion;

SET NOCOUNT ON;

DROP TABLE IF EXISTS TBL_TANAKH_PEREK;

CREATE TABLE TBL_TANAKH_PEREK
(
TANAKH_PEREK_ID INT IDENTITY,
PEREK_ID INT NOT NULL,
PEREK_LETTER NVARCHAR(3),
CONSTRAINT PK_TBL_TANAKH_PEREK PRIMARY KEY (TANAKH_PEREK_ID)
);