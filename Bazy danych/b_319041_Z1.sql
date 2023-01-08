/* Sebastian Grosfeld 319041 */

IF OBJECT_ID(N'ETATY') IS NOT NULL
    DROP TABLE ETATY
GO

IF OBJECT_ID(N'OSOBY') IS NOT NULL
    DROP TABLE OSOBY
GO

IF OBJECT_ID(N'FIRMY') IS NOT NULL
    DROP TABLE FIRMY
GO

IF OBJECT_ID(N'MIASTA') IS NOT NULL
    DROP TABLE MIASTA
GO

IF OBJECT_ID(N'WOJ') IS NOT NULL
    DROP TABLE WOJ
GO
/* usuwam wczeœniej powsta³e tabele
i towrzê nowe*/
CREATE TABLE dbo.WOJ 
(	kod_woj nchar(4)	NOT NULL CONSTRAINT PK_WOJ PRIMARY KEY
,	nazwa	nvarchar(50) NOT NULL
)
GO
CREATE TABLE dbo.MIASTA
(	id_miasta	int				not null IDENTITY CONSTRAINT PK_MIASTA PRIMARY KEY
,	kod_woj		nchar(4)		NOT NULL 
	CONSTRAINT FK_MIASTA_WOJ FOREIGN KEY REFERENCES WOJ(kod_woj)
,	nazwa		nvarchar(50)	NOT NULL
)
GO
CREATE TABLE dbo.OSOBY
(	id_osoby int NOT NULL IDENTITY	CONSTRAINT PK_OSOBY PRIMARY KEY
,	id_miasta	int				not null CONSTRAINT FK_OSOBY_MIASTA FOREIGN KEY
		REFERENCES MIASTA(id_miasta)
,	imie		nvarchar(50)	NOT NULL
,	nazwisko	nvarchar(50)	NOT NULL 

)
GO
CREATE TABLE dbo.FIRMY 
(	nazwa_skr nchar(10)	NOT NULL CONSTRAINT PK_FIRMY PRIMARY KEY
,	id_miasta	int NOT NULL 
    CONSTRAINT FK_FIRMY_MIASTA FOREIGN KEY REFERENCES MIASTA(id_miasta)
,	nazwa nvarchar(50) NOT NULL
,	kod_pocztowy nvarchar(8) NOT NULL
,	ulica nvarchar(50) NOT NULL
)
GO
CREATE TABLE dbo.ETATY
(	id_osoby	int				not null CONSTRAINT FK_ETATY_OSOBY FOREIGN KEY REFERENCES OSOBY(id_osoby)
,	id_firmy		nchar(10)	NOT NULL CONSTRAINT FK_ETATY_FIRMY FOREIGN KEY REFERENCES FIRMY(nazwa_skr)
,	stanowisko nvarchar(50)		NOT NULL
,	pensja money NOT NULL 
,	od datetime NOT NULL
,	do datetime NULL
,	id_etatu int NOT NULL IDENTITY CONSTRAINT PK_ETATY PRIMARY KEY
)
GO
/* tworzê tabele */
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'MAZ', N'MAZOWIECKIE')
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'OPOL', N'OPOLSKIE')
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'POM', N'POMORSKIE')
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'LUBU', N'LUBUSKIE')
/*dodaje województwa
SELECT * FROM WOJ*/
/*kod_woj nazwa
------- --------------------------------------------------
LUBU    LUBUSKIE
MAZ     MAZOWIECKIE
OPOL    OPOLSKIE
POM     POMORSKIE

(4 row(s) affected)*/


DECLARE @id_wa int ,@id_gda int,@id_so int,@id_gdy int,@id_we int,@id_pl int,@id_ra int,@id_wg int,@id_he int

INSERT INTO MIASTA (nazwa, kod_woj)VALUES (N'Gdañsk', N'POM')
SET @id_gda = SCOPE_IDENTITY() /* zwraca jakie ID nadano automatycznie w poprzednim poleceniu */
INSERT INTO MIASTA (nazwa, kod_woj)VALUES (N'Gdynia', N'POM')
SET @id_gdy = SCOPE_IDENTITY()
INSERT INTO MIASTA (nazwa, kod_woj)VALUES (N'Sopot', N'POM')
SET @id_so = SCOPE_IDENTITY()
INSERT INTO MIASTA (nazwa, kod_woj)VALUES (N'Hel', N'POM')
SET @id_he = SCOPE_IDENTITY()
INSERT INTO MIASTA (nazwa, kod_woj)VALUES (N'Wejherowo', N'POM')
SET @id_we = SCOPE_IDENTITY()
INSERT INTO MIASTA (nazwa, kod_woj)VALUES (N'P³ock', N'MAZ')
SET @id_pl = SCOPE_IDENTITY()
INSERT INTO MIASTA (nazwa, kod_woj)VALUES (N'Warszawa', N'MAZ')
SET @id_wa = SCOPE_IDENTITY()
INSERT INTO MIASTA (nazwa, kod_woj)VALUES (N'Radom', N'MAZ')
SET @id_ra = SCOPE_IDENTITY()
INSERT INTO MIASTA (nazwa, kod_woj)VALUES (N'Wêgrów', N'MAZ')
SET @id_wg = SCOPE_IDENTITY()
/*dodaje miasta
SELECT * FROM MIASTA*/
/*id_miasta   kod_woj nazwa
----------- ------- --------------------------------------------------
1           POM     Gdañsk
2           POM     Gdynia
3           POM     Sopot
4           POM     Hel
5           POM     Wejherowo
6           MAZ     P³ock
7           MAZ     Warszawa
8           MAZ     Radom
9           MAZ     Wêgrów

(9 row(s) affected)*/
/*dodaje miasta*/
DECLARE @id_jk int ,@id_as int,@id_pr int,@id_tw int,@id_an int,@id_kk int,@id_ts int,@id_ss int,@id_pb int, @id_aw int ,@id_sz int,@id_ar int,@id_rp int,@id_kn int


INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_wa, N'Jacek' , N'Korytkowski')
SET @id_jk = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_we, N'Adam' , N'Szpatu³a')
SET @id_as = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_wg, N'Piotr' , N'Rojman')
SET @id_pr = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_ra, N'Tomasz' , N'Wec')
SET @id_tw = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_gdy, N'Adam' , N'Nawa³ka')
SET @id_an = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_gda, N'Karol' , N'Karolak')
SET @id_kk = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_so, N'Tymon' , N'Szpatu³a')
SET @id_ts = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_pl, N'Samson' , N'Szpatu³a')
SET @id_ss = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_ra, N'Patryk' , N'Barszcz')
SET @id_pb = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_wa, N'Aleksander' , N'Wielki')
SET @id_aw = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_wa, N'Szymon' , N'Zapa³a')
SET @id_sz = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_so, N'Agieszka' , N'Renegat')
SET @id_ar = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_gda, N'Roman' , N'Paszczak')
SET @id_rp = SCOPE_IDENTITY()
INSERT INTO OSOBY (id_miasta, imie, nazwisko) VALUES (@id_gdy, N'Katarzyna' , N'Najman')
SET @id_kn = SCOPE_IDENTITY()
/*dodaje osoby
SELECT * FROM OSOBY */
/*id_osoby    id_miasta   imie                                               nazwisko
----------- ----------- -------------------------------------------------- --------------------------------------------------
1           7           Jacek                                              Korytkowski
2           5           Adam                                               Szpatu³a
3           9           Piotr                                              Rojman
4           8           Tomasz                                             Wec
5           2           Adam                                               Nawa³ka
6           1           Karol                                              Karolak
7           3           Tymon                                              Szpatu³a
8           6           Samson                                             Szpatu³a
9           8           Patryk                                             Barszcz
10          7           Aleksander                                         Wielki
11          7           Szymon                                             Zapa³a
12          3           Agieszka                                           Renegat
13          1           Roman                                              Paszczak
14          2           Katarzyna                                          Najman

(14 row(s) affected)
*/
INSERT INTO FIRMY(nazwa_skr,id_miasta,nazwa,kod_pocztowy,ulica) VALUES (N'ALG', @id_gda , N'Allegro', N'11-456' , N'Koszykowa')
INSERT INTO FIRMY(nazwa_skr,id_miasta,nazwa,kod_pocztowy,ulica) VALUES (N'GOO', @id_wa , N'Google', N'11-434' , N'D³uga')
INSERT INTO FIRMY(nazwa_skr,id_miasta,nazwa,kod_pocztowy,ulica) VALUES (N'ORL', @id_gda , N'Orlen', N'15-456' , N'Morska')
INSERT INTO FIRMY(nazwa_skr,id_miasta,nazwa,kod_pocztowy,ulica) VALUES (N'PRU', @id_gdy , N'Pruszyñski', N'17-456' , N'Koszykowa')
INSERT INTO FIRMY(nazwa_skr,id_miasta,nazwa,kod_pocztowy,ulica) VALUES (N'RAD', @id_ra , N'Radoœæ', N'19-456' , N'Koszykowa')
INSERT INTO FIRMY(nazwa_skr,id_miasta,nazwa,kod_pocztowy,ulica) VALUES (N'ADA', @id_we , N'Adam', N'16-456' , N'Rogowa')
INSERT INTO FIRMY(nazwa_skr,id_miasta,nazwa,kod_pocztowy,ulica) VALUES (N'MIC', @id_gda , N'Micha³', N'18-456' , N'Koszykowa')
INSERT INTO FIRMY(nazwa_skr,id_miasta,nazwa,kod_pocztowy,ulica) VALUES (N'FUR', @id_so , N'Fury', N'13-456' , N'Koszykowa')
/*dodaje firmy
SELECT * FROM FIRMY
nazwa_skr  id_miasta   nazwa                                              kod_pocztowy ulica
---------- ----------- -------------------------------------------------- ------------ --------------------------------------------------
ADA        5           Adam                                               16-456       Rogowa
ALG        1           Allegro                                            11-456       Koszykowa
FUR        3           Fury                                               13-456       Koszykowa
GOO        7           Google                                             11-434       D³uga
MIC        1           Micha³                                             18-456       Koszykowa
ORL        1           Orlen                                              15-456       Morska
PRU        2           Pruszyñski                                         17-456       Koszykowa
RAD        8           Radoœæ                                             19-456       Koszykowa

(8 row(s) affected)*/

INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_jk, N'GOO' , N'kierownik', 12000 , CONVERT(datetime,'20210823',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_ss, N'ORL' , N'kasjer', 3000 , CONVERT(datetime,'20210423',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_ts, N'PRU' , N'dostawca', 5000 , CONVERT(datetime,'20210101',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_kn, N'RAD' , N'dyrektor', 15000 , CONVERT(datetime,'20180404',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_kk, N'GOO' , N'grafik', 10000 , CONVERT(datetime,'20210823',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_rp, N'GOO' , N'programista', 12000 , CONVERT(datetime,'20210820',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_as, N'FUR' , N'woŸny', 3500 , CONVERT(datetime,'20210612',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_pb, N'ALG' , N'kosultant', 7000 , CONVERT(datetime,'20210416',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_aw, N'RAD' , N'kierowca', 6000 , CONVERT(datetime,'20200711',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_sz, N'ORL' , N'kierownik', 8000 , CONVERT(datetime,'20220105',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_ar, N'GOO' , N'programista', 14000 , CONVERT(datetime,'20210507',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_an, N'PRU' , N'monter', 7000 , CONVERT(datetime,'20210823',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od,do) VALUES (@id_pr, N'ORL' , N'ochroniarz', 4000 , CONVERT(datetime,'20131223',112),CONVERT(datetime,'20210520',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od,do) VALUES (@id_tw, N'ALG' , N'tester', 8000 , CONVERT(datetime,'20161223',112),CONVERT(datetime,'20211120',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_pr, N'FUR' , N'serwisant', 7000 , CONVERT(datetime,'20210520',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_an, N'ALG' , N'full_stack developer', 17000 , CONVERT(datetime,'20211120',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od,do) VALUES (@id_ss, N'PRU' , N'menad¿er', 9000 , CONVERT(datetime,'20080509',112),CONVERT(datetime,'20210823',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od,do) VALUES (@id_ts, N'ALG' , N'magazynier', 5000 , CONVERT(datetime,'20100914',112),CONVERT(datetime,'20210323',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od,do) VALUES (@id_kn, N'RAD' , N'sekretarz', 4500 , CONVERT(datetime,'20060914',112),CONVERT(datetime,'20180404',112))
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od,do) VALUES (@id_rp, N'GOO' , N'analityk', 9000 , CONVERT(datetime,'20070617',112),CONVERT(datetime,'20210820',112))
/*
dodajê etaty
SELECT * FROM ETATY
id_osoby    id_firmy   stanowisko                                         pensja                od                      do                      id_etatu
----------- ---------- -------------------------------------------------- --------------------- ----------------------- ----------------------- -----------
1           GOO        kierownik                                          12000,00              2021-08-23 00:00:00.000 NULL                    1
8           ORL        kasjer                                             3000,00               2021-04-23 00:00:00.000 NULL                    2
7           PRU        dostawca                                           5000,00               2021-01-01 00:00:00.000 NULL                    3
14          RAD        dyrektor                                           15000,00              2018-04-04 00:00:00.000 NULL                    4
6           GOO        grafik                                             10000,00              2021-08-23 00:00:00.000 NULL                    5
13          GOO        programista                                        12000,00              2021-08-20 00:00:00.000 NULL                    6
2           FUR        woŸny                                              3500,00               2021-06-12 00:00:00.000 NULL                    7
9           ALG        kosultant                                          7000,00               2021-04-16 00:00:00.000 NULL                    8
10          RAD        kierowca                                           6000,00               2020-07-11 00:00:00.000 NULL                    9
11          ORL        kierownik                                          8000,00               2022-01-05 00:00:00.000 NULL                    10
12          GOO        programista                                        14000,00              2021-05-07 00:00:00.000 NULL                    11
5           PRU        monter                                             7000,00               2021-08-23 00:00:00.000 NULL                    12
3           ORL        ochroniarz                                         4000,00               2013-12-23 00:00:00.000 2021-05-20 00:00:00.000 13
4           ALG        tester                                             8000,00               2016-12-23 00:00:00.000 2021-11-20 00:00:00.000 14
3           FUR        serwisant                                          7000,00               2021-05-20 00:00:00.000 NULL                    15
5           ALG        full_stack developer                               17000,00              2021-11-20 00:00:00.000 NULL                    16
8           PRU        menad¿er                                           9000,00               2008-05-09 00:00:00.000 2021-08-23 00:00:00.000 17
7           ALG        magazynier                                         5000,00               2010-09-14 00:00:00.000 2021-03-23 00:00:00.000 18
14          RAD        sekretarz                                          4500,00               2006-09-14 00:00:00.000 2018-04-04 00:00:00.000 19
13          GOO        analityk                                           9000,00               2007-06-17 00:00:00.000 2021-08-20 00:00:00.000 20

(20 row(s) affected)*/
/*
INSERT INTO ETATY(id_osoby,id_firmy,stanowisko,pensja,od) VALUES (@id_aa, N'GOO' , N'kierownik', 12000 , CONVERT(datetime,'20210823',112))
Msg 137, Level 15, State 2, Line 177
Must declare the scalar variable "@id_aa".

Nie da siê dodaæ nieistniej¹cej osoby do tabeli ETATY*/

/*
DELETE FROM MIASTA WHERE nazwa = 'Hel'

W Helu nie ma osób ani firm dlatego mo¿emy go usun¹æ.

DELETE FROM MIASTA WHERE nazwa = 'Warszawa'
Msg 547, Level 16, State 0, Line 187
The DELETE statement conflicted with the REFERENCE constraint "FK_OSOBY_MIASTA". The conflict occurred in database "master", table "dbo.OSOBY", column 'id_miasta'.

Nie da siê Warszawy bo s¹ w niej osoby.*/

/*IF OBJECT_ID(N'OSOBY') IS NOT NULL
    DROP TABLE OSOBY
	Msg 3726, Level 16, State 1, Line 194
Could not drop object 'OSOBY' because it is referenced by a FOREIGN KEY constraint.

nie mozna usunac tabeli osoby jezeli jest tabela etaty*/