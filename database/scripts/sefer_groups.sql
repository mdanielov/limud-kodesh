use KiMeTzion

update TBL_TANAKH_SEFER set sefer_group=SEFER_ENGLISH_NAME
--update TBL_TANAKH_SEFER set sefer_group='Chumash' where SEFER_ID in (1,2,3,4,5)
update TBL_TANAKH_SEFER set sefer_group='Shmuel' where SEFER_ID in (8,9)
update TBL_TANAKH_SEFER set sefer_group='Melakhim' where SEFER_ID in (10,11)
update TBL_TANAKH_SEFER set sefer_group='DivreiHaYamim' where SEFER_ID in (35,36)
update TBL_TANAKH_SEFER set sefer_group='Ezra' where SEFER_ID in (38,39)
update TBL_TANAKH_SEFER set sefer_group='Trey Asar' where SEFER_ENGLISH_NAME in ('hoshea','yoel','amos','Ovadyah','yonah','Mikhah','Nahum','Havakuk','Tsefanya','Khagay','Zekharyah','Malakhi')
select distinct sefer_group from TBL_TANAKH_SEFER