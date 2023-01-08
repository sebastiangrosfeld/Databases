/* Sebastian Grosfeld , Gr 2, 319041 */

/* Projekt na 3 zaj�cia /
/ stworzy� bibliotek� (uproszczon�)
**
** Tabela Ksiazka (tytul, autor, id_ksiazki, stan_bibl, stan_dostepny - dom 0)
** Skorzysta� z tabeli OSOBY kt�r� macie
** Tabela WYP (id_osoby, id_ksiazki, liczba, data, id_wyp PK)
** Tabela ZWR (id_osoby, id_ksiazki, liczba, data, id_zwr PK (int not null IDENTITY))
** Napisa� triggery aby:
** dodanie rekordow do WYP powodowalo aktualizacj� Ksiazka (stan_dostepny)
** UWAGA zakladamy ze na raz mozna dodawac wiele rekordow
** w tym dla tej samej osoby, z tym samym id_ksiazki
/
CREATE TABLE #wyp(id_os int not null, id_ks int not null, liczba int not null)
INSERT INTO #wyp (id_os, id_ks, liczba) VALUES (1, 1, 1), (1, 1, 2), (2, 5, 6)
/
Zwrot zwi�ksza stan_dostepny
** UWAGA
** Zrealizowa� TRIGERY na kasowanie z WYP lub ZWR
**
** Zrealizowa� triggery, ze nastapi�a pomy�ka czyli UPDATE na WYP lub ZWR
** Wydaje mi sie, ze mozna napisac po jednym triggerze na WYP lub ZWR na
** wszystkie akcje INSERT / UPDATE / DELETE
**
** Testowanie: stworzcie procedur�, kt�ra pokaze wszystkie ksi�zki,
** dane ksi�zki, stan_bibl, stan_dost + SUM(liczba) z ZWR - SUM(liczba) z WYP =>
** ISNULL(SUM(Liczba),0)
** te dwie kolumny powiny by� r�wne
** po wielu dzialaniach w bazie
** dzialania typu kasowanie rejestrowac w tabeli skasowane
** (rodzaj (wyp/zwr), id_os, id_ks, liczba)
** osobne triggery na DELETE z WYP i ZWR kt�re b�d� rejestrowa� skasowania
*/

/* Tworzenie potrzebnych tabel */
IF OBJECT_ID(N'ZWR') IS NOT NULL
    DROP TABLE ZWR
GO

IF OBJECT_ID(N'WYP') IS NOT NULL
    DROP TABLE WYP
GO


IF OBJECT_ID(N'Ksiazka') IS NOT NULL
    DROP TABLE Ksiazka
GO

IF OBJECT_ID(N'SKASOWANE') IS NOT NULL
	DROP TABLE SKASOWANE
GO


CREATE TABLE dbo.Ksiazka
(	tytul nvarchar(50) NOT NULL,
	autor nvarchar(50) NOT NULL,
	id_ksiazki int not null IDENTITY CONSTRAINT PK_Ksiazka PRIMARY KEY,
	stan_bibl int not null ,
	stan_dostepny int not null
)
GO

CREATE TABLE dbo.WYP
(	id_osoby  int  not null CONSTRAINT FK_WYP_OSOBY FOREIGN KEY REFERENCES OSOBY(id_osoby)
,	id_wyp int NOT NULL IDENTITY CONSTRAINT PK_WYP PRIMARY KEY,
	id_ksiazki int not null CONSTRAINT FK_WYP_Ksiazka FOREIGN KEY REFERENCES Ksiazka(id_ksiazki),
	liczba int not null,
	data datetime NOT NULL

)
GO

CREATE TABLE dbo.ZWR
(	id_osoby  int  not null CONSTRAINT FK_ZWR_OSOBY FOREIGN KEY REFERENCES OSOBY(id_osoby)
,	id_zwr int NOT NULL IDENTITY CONSTRAINT PK_ZWR PRIMARY KEY,
	id_ksiazki int not null CONSTRAINT FK_ZWR_Ksiazka FOREIGN KEY REFERENCES Ksiazka(id_ksiazki),
	liczba int not null,
	data datetime NOT NULL
)
GO

CREATE TABLE dbo.SKASOWANE
( rodzaj nvarchar(20) NOT NULL,
	id_os  int  not null,
	id_ks int not null,
	liczba int not null
)
GO


DECLARE @id_pt int , @id_kr int , @id_we int , @id_ba int, @id_zm int 

INSERT INTO Ksiazka (tytul,autor,stan_bibl,stan_dostepny) VALUES (N'Pan Tadeusz',N'Adam Mickiewicz',20,20)
SET @id_pt = SCOPE_IDENTITY()
INSERT INTO Ksiazka (tytul,autor,stan_bibl,stan_dostepny) VALUES (N'Krzy�acy',N'Henryk Sienkiewicz',30,30)
SET @id_kr = SCOPE_IDENTITY()
INSERT INTO Ksiazka (tytul,autor,stan_bibl,stan_dostepny) VALUES (N'Wesele',N'Stanis�aw Wyspia�ski',15,15)
SET @id_we = SCOPE_IDENTITY()
INSERT INTO Ksiazka (tytul,autor,stan_bibl,stan_dostepny) VALUES (N'Balladyna',N'Juliusz S�owacki',30,30)
SET @id_ba = SCOPE_IDENTITY()
INSERT INTO Ksiazka (tytul,autor,stan_bibl,stan_dostepny) VALUES (N'Zemsta',N'Aleksander Fredro',40,40)
SET @id_zm = SCOPE_IDENTITY()
/*
Select * from Ksiazka

tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          20
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)
*/

/* TRIGGERY */
/* Testy dla poszczeg�lnych zosta�y przedstawione w dalszej cz�ci sprawozdania */

/* Tworzenie trigger�w  na WYP i ZWR*/
GO
CREATE TRIGGER dbo.TR_updated ON ZWR for INSERT
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny + X.nowe
FROM Ksiazka
join (SELECT i.id_ksiazki,SUM( i.liczba) AS nowe
				FROM inserted i 
				GROUP BY i.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
GO
GO
CREATE TRIGGER dbo.TR_deleted ON WYP for INSERT
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny - X.nowe
FROM Ksiazka
join (SELECT d.id_ksiazki, SUM( d.liczba) AS nowe
				FROM inserted d 
				GROUP BY d.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
GO

/* Triggery na usuwanie z WYP i ZWR*/
GO
CREATE TRIGGER dbo.eraseWyp ON WYP for DELETE
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny + X.nowe
FROM Ksiazka
join (SELECT i.id_ksiazki,SUM( i.liczba) AS nowe
				FROM deleted i 
				GROUP BY i.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
GO

GO
CREATE TRIGGER dbo.eraseZwr ON ZWR for DELETE
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny - X.nowe
FROM Ksiazka
join (SELECT i.id_ksiazki,SUM( i.liczba) AS nowe
				FROM deleted i 
				GROUP BY i.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
GO

/* triggery na pomy�ki */
GO
CREATE TRIGGER dbo.pomylkawyp ON WYP for UPDATE
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny + X.stare - S.nowe
FROM Ksiazka
join (SELECT i.id_ksiazki,SUM( i.liczba) AS stare
				FROM deleted i 
				GROUP BY i.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
join (SELECT i.id_ksiazki,SUM( i.liczba) AS nowe
				FROM inserted i 
				GROUP BY i.id_ksiazki
			) S ON (S.id_ksiazki = Ksiazka.id_ksiazki)
GO

GO
CREATE TRIGGER dbo.pomylkazwr ON ZWR for UPDATE
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny - X.stare + S.nowe
FROM Ksiazka
join (SELECT i.id_ksiazki,SUM( i.liczba) AS stare
				FROM deleted i 
				GROUP BY i.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
join (SELECT i.id_ksiazki,SUM( i.liczba) AS nowe
				FROM inserted i 
				GROUP BY i.id_ksiazki
			) S ON (S.id_ksiazki = Ksiazka.id_ksiazki)				
GO

/* TRIGGERy na usuni�te  */
GO
CREATE TRIGGER dbo.deleted ON WYP for DELETE
AS
INSERT into SKASOWANE (rodzaj,id_os,id_ks,liczba) 
SELECT N'wyp',i.id_osoby,i.id_ksiazki,i.liczba
FROM deleted i

GO 

GO
CREATE TRIGGER dbo.deleted2 ON ZWR for DELETE
AS
INSERT into SKASOWANE (rodzaj,id_os,id_ks,liczba) 
SELECT N'zwr',i.id_osoby,i.id_ksiazki,i.liczba
FROM deleted i
GO

/* Trigger zabezpieczaj�cy */
GO
CREATE TRIGGER dbo.ksiazka_zabezpiecz ON KSIAZKA FOR UPDATE
AS
	DECLARE @err INT
	SET @err = 0
	IF UPDATE(stan_dostepny)
	SELECT @err = ISNULL(SUM(INS.error), 0) FROM
		(SELECT IIF(I.stan_dostepny < 0 OR I.stan_dostepny > I.stan_bibl, 1, 0) AS error FROM inserted AS I) AS INS

	IF @err <> 0
	BEGIN
		RAISERROR(N'Nieprawid�owa warto�� dla stan_dostepny', 16, 3)
		ROLLBACK
	END
GO

/* Procedura sprawdzaj�ca */
GO
CREATE PROCEDURE dbo.test_ksiazki AS
	
	IF OBJECT_ID(N'tempdb..#ZWR_SUM') IS NOT NULL
	BEGIN
		DROP TABLE #ZWR_SUM
	END

	
	IF OBJECT_ID(N'tempdb..#WYP_SUM') IS NOT NULL
	BEGIN
		DROP TABLE #WYP_SUM
	END

	
	SELECT Z.id_ksiazki, ISNULL(SUM(Z.liczba), 0) AS suma_zwr INTO #ZWR_SUM FROM ZWR AS Z
		GROUP BY Z.id_ksiazki
	
	
	SELECT W.id_ksiazki, ISNULL(SUM(W.liczba), 0) AS suma_wyp INTO #WYP_SUM FROM WYP AS W
		GROUP BY W.id_ksiazki

	
	SELECT K.id_ksiazki, K.tytul, K.autor, K.stan_bibl, (K.stan_dostepny + ISNULL(W.suma_wyp, 0) - ISNULL(Z.suma_zwr, 0)) AS stan_bibl_po_operacjach FROM KSIAZKA AS K
		LEFT JOIN #ZWR_SUM AS Z ON Z.id_ksiazki = K.id_ksiazki
		LEFT JOIN #WYP_SUM AS W ON W.id_ksiazki = K.id_ksiazki
GO


/* Poni�ej przyk�ady potwierdzaj�ce skuteczno�� trigger�w i procedur. */

/*---------------------------------------------------*/

/* Tworzenie trigger�w  na WYP i ZWR*/

GO
CREATE TRIGGER dbo.TR_updated ON ZWR for INSERT
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny + X.nowe
FROM Ksiazka
join (SELECT i.id_ksiazki,SUM( i.liczba) AS nowe
				FROM inserted i 
				GROUP BY i.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
GO
GO
CREATE TRIGGER dbo.TR_deleted ON WYP for INSERT
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny - X.nowe
FROM Ksiazka
join (SELECT d.id_ksiazki, SUM( d.liczba) AS nowe
				FROM inserted d 
				GROUP BY d.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
GO

DECLARE @id_wyp int
INSERT INTO WYP (id_osoby,id_ksiazki,liczba,data) VALUES (1,1,10,GETDATE())
SET @id_wyp = SCOPE_IDENTITY()

Select * from WYP
/*
id_osoby    id_wyp      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           10          2022-05-17 10:55:20.287

(1 row(s) affected)
*/
Select * from Ksiazka
/*stan dostepny ksi��kki o id 1 zmniejszy� si� o 10*/
/*tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          10
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)*/

DECLARE @id_zwr int
INSERT INTO ZWR (id_osoby,id_ksiazki,liczba,data) VALUES (1,1,10,GETDATE())
SET @id_zwr = SCOPE_IDENTITY()

Select * from ZWR
/*
id_osoby    id_zwr      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           10          2022-05-24 10:40:09.890

(1 row(s) affected)
*/
Select * from Ksiazka
/*
Po zwrocie stan dost�pny ksia�ki o id = 1 zwi�kszy� si� o 10.

tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          20
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)

*/

/*------------------------------------------*/


/* Triggery na usuwanie z WYP i ZWR*/
GO
CREATE TRIGGER dbo.eraseWyp ON WYP for DELETE
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny + X.nowe
FROM Ksiazka
join (SELECT i.id_ksiazki,SUM( i.liczba) AS nowe
				FROM deleted i 
				GROUP BY i.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
GO

GO
CREATE TRIGGER dbo.eraseZwr ON ZWR for DELETE
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny - X.nowe
FROM Ksiazka
join (SELECT i.id_ksiazki,SUM( i.liczba) AS nowe
				FROM deleted i 
				GROUP BY i.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
GO

DECLARE @id_wyp int
INSERT INTO WYP(id_osoby,id_ksiazki,liczba,data) VALUES (1,1,10,GETDATE())
SET @id_wyp = SCOPE_IDENTITY()

Select * from WYP
/*
Nowe wyp o id 4.

id_osoby    id_wyp      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           10          2022-05-17 11:50:43.203
1           2           1           10          2022-05-24 10:58:07.143
1           4           1           10          2022-05-24 11:07:53.563

(3 row(s) affected)
*/

Select* from Ksiazka 
/*
tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          10
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)
*/

DELETE FROM WYP where id_wyp =4
/*
id_osoby    id_wyp      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           10          2022-05-17 11:50:43.203
1           2           1           10          2022-05-24 10:58:07.143

(2 row(s) affected)
*/
/*
tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          20
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)

Po usuni�ciu rekorda z WYP stan dostepny powr�ci� do stanu sprzed dodania wypo�yczenia.
*/

GO
DECLARE @id_wyp int
INSERT INTO WYP(id_osoby,id_ksiazki,liczba,data) VALUES (1,1,10,GETDATE())
SET @id_wyp = SCOPE_IDENTITY()
/*
id_osoby    id_wyp      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           10          2022-05-26 15:01:50.533

(1 row(s) affected)
tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          10
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)
*/


DECLARE @id_zwr int
INSERT INTO ZWR (id_osoby,id_ksiazki,liczba,data) VALUES (1,1,10,GETDATE())
SET @id_zwr = SCOPE_IDENTITY()
/*
id_osoby    id_zwr      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           10          2022-05-26 15:04:15.347

(1 row(s) affected)
tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          20
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)

Po dodaniu zwroru
*/

DELETE FROM ZWR WHERE id_zwr =1
/*
id_osoby    id_zwr      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------

(0 row(s) affected)
tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          10
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)

Po usuni�ciu zwrotu stan dost�pny cofna� si� do stanu sprzed dodania zwrotu
*/


/*---------------------------------------------------------*/





/* triggery na pomy�ki */
GO
CREATE TRIGGER dbo.pomylkawyp ON WYP for UPDATE
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny + X.stare - S.nowe
FROM Ksiazka
join (SELECT i.id_ksiazki,SUM( i.liczba) AS stare
				FROM deleted i 
				GROUP BY i.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
join (SELECT i.id_ksiazki,SUM( i.liczba) AS nowe
				FROM inserted i 
				GROUP BY i.id_ksiazki
			) S ON (S.id_ksiazki = Ksiazka.id_ksiazki)
GO

GO
CREATE TRIGGER dbo.pomylkazwr ON ZWR for UPDATE
AS
UPDATE Ksiazka SET stan_dostepny = stan_dostepny - X.stare + S.nowe
FROM Ksiazka
join (SELECT i.id_ksiazki,SUM( i.liczba) AS stare
				FROM deleted i 
				GROUP BY i.id_ksiazki
			) X ON (X.id_ksiazki = Ksiazka.id_ksiazki)
join (SELECT i.id_ksiazki,SUM( i.liczba) AS nowe
				FROM inserted i 
				GROUP BY i.id_ksiazki
			) S ON (S.id_ksiazki = Ksiazka.id_ksiazki)				
GO

SELECT * FROM WYP
/*
id_osoby    id_wyp      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           10          2022-05-26 15:01:50.533

(1 row(s) affected)

tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          10
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)
*/
GO
DECLARE @id_wyp int
INSERT INTO WYP(id_osoby,id_ksiazki,liczba,data) VALUES (1,1,10,GETDATE())
SET @id_wyp = SCOPE_IDENTITY()
/*
id_osoby    id_wyp      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           10          2022-05-26 15:32:40.120

(1 row(s) affected)
*/
UPDATE WYP SET liczba=20 where id_wyp = 1
/*
id_osoby    id_wyp      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           20          2022-05-26 15:01:50.533

(1 row(s) affected)

tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          0
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)

Po update zmieni� si� stan dost�pny.
*/

DECLARE @id_zwr int
INSERT INTO ZWR (id_osoby,id_ksiazki,liczba,data) VALUES (1,1,20,GETDATE())
SET @id_zwr = SCOPE_IDENTITY()
/*
id_osoby    id_zwr      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           20          2022-05-26 15:37:45.773

(1 row(s) affected)
tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          20
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)
*/
UPDATE ZWR SET liczba=10 where id_zwr = 1
/*
id_osoby    id_zwr      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           1           1           10          2022-05-26 15:37:45.773

(1 row(s) affected)
tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          10
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)

Po update na ZWR zmieni� si� stan dost�pny.
*/

/*-----------------------------------------------*/

/* TRIGGERy na usuni�te  */
GO
CREATE TRIGGER dbo.deleted ON WYP for DELETE
AS
INSERT into SKASOWANE (rodzaj,id_os,id_ks,liczba) 
SELECT N'wyp',i.id_osoby,i.id_ksiazki,i.liczba
FROM deleted i

GO 

GO
CREATE TRIGGER dbo.deleted2 ON ZWR for DELETE
AS
INSERT into SKASOWANE (rodzaj,id_os,id_ks,liczba) 
SELECT N'zwr',i.id_osoby,i.id_ksiazki,i.liczba
FROM deleted i
GO

DELETE FROM WYP where id_wyp =1

SELECT * FROM SKASOWANE
/*
rodzaj               id_os       id_ks       liczba
-------------------- ----------- ----------- -----------
wyp                  1           1           20

(1 row(s) affected)
*/



SELECT * FROM ZWR
/*
id_osoby    id_zwr      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           2           1           10          2022-05-26 15:37:45.773

(1 row(s) affected)
*/

DELETE FROM ZWR where id_zwr =2
SELECT * FROM SKASOWANE
/*
rodzaj               id_os       id_ks       liczba
-------------------- ----------- ----------- -----------
wyp                  1           1           20
zwr                  1           1           10

(2 row(s) affected)

Skasowane wyp i zwr s� w tabeli skasowane
*/



SELECT * FROM Ksiazka
SELECT * FROM WYP
SELECT * FROM ZWR
SELECT * FROM SKASOWANE


/* Procedura sprawdzaj�ca */
GO
CREATE PROCEDURE dbo.test_ksiazki AS
	
	IF OBJECT_ID(N'tempdb..#ZWR_SUM') IS NOT NULL
	BEGIN
		DROP TABLE #ZWR_SUM
	END

	
	IF OBJECT_ID(N'tempdb..#WYP_SUM') IS NOT NULL
	BEGIN
		DROP TABLE #WYP_SUM
	END

	
	SELECT Z.id_ksiazki, ISNULL(SUM(Z.liczba), 0) AS suma_zwr INTO #ZWR_SUM FROM ZWR AS Z
		GROUP BY Z.id_ksiazki
	
	
	SELECT W.id_ksiazki, ISNULL(SUM(W.liczba), 0) AS suma_wyp INTO #WYP_SUM FROM WYP AS W
		GROUP BY W.id_ksiazki

	
	SELECT K.id_ksiazki, K.tytul, K.autor, K.stan_bibl, (K.stan_dostepny + ISNULL(W.suma_wyp, 0) - ISNULL(Z.suma_zwr, 0)) AS stan_bibl_po_operacjach FROM KSIAZKA AS K
		LEFT JOIN #ZWR_SUM AS Z ON Z.id_ksiazki = K.id_ksiazki
		LEFT JOIN #WYP_SUM AS W ON W.id_ksiazki = K.id_ksiazki
GO

GO
DECLARE @id_wyp int
INSERT INTO WYP(id_osoby,id_ksiazki,liczba,data) VALUES (1,1,10,GETDATE())
SET @id_wyp = SCOPE_IDENTITY()

SELECT * FROM WYP
/*
id_osoby    id_wyp      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------
1           2           1           10          2022-05-26 19:34:52.493

(1 row(s) affected)
*/

SELECT * FROM ZWR
/*
id_osoby    id_zwr      id_ksiazki  liczba      data
----------- ----------- ----------- ----------- -----------------------

(0 row(s) affected)

*/

SELECT * FROM Ksiazka
/*
tytul                                              autor                                              id_ksiazki  stan_bibl   stan_dostepny
-------------------------------------------------- -------------------------------------------------- ----------- ----------- -------------
Pan Tadeusz                                        Adam Mickiewicz                                    1           20          10
Krzy�acy                                           Henryk Sienkiewicz                                 2           30          30
Wesele                                             Stanis�aw Wyspia�ski                               3           15          15
Balladyna                                          Juliusz S�owacki                                   4           30          30
Zemsta                                             Aleksander Fredro                                  5           40          40

(5 row(s) affected)
*/

EXEC dbo.test_ksiazki
/*
(0 row(s) affected)

(1 row(s) affected)
id_ksiazki  tytul                                              autor                                              stan_bibl   stan_bibl_po_operacjach
----------- -------------------------------------------------- -------------------------------------------------- ----------- -----------------------
1           Pan Tadeusz                                        Adam Mickiewicz                                    20          20
2           Krzy�acy                                           Henryk Sienkiewicz                                 30          30
3           Wesele                                             Stanis�aw Wyspia�ski                               15          15
4           Balladyna                                          Juliusz S�owacki                                   30          30
5           Zemsta                                             Aleksander Fredro                                  40          40

(5 row(s) affected)


Stan biblioteczny przed i po si� zgadza czyli trigerry dzia�aj� poprawnie.
*/

/* Trigger zabezpieczaj�cy */
GO
CREATE TRIGGER dbo.ksiazka_zabezpiecz ON KSIAZKA FOR UPDATE
AS
	DECLARE @err INT
	SET @err = 0
	IF UPDATE(stan_dostepny)
	SELECT @err = ISNULL(SUM(INS.error), 0) FROM
		(SELECT IIF(I.stan_dostepny < 0 OR I.stan_dostepny > I.stan_bibl, 1, 0) AS error FROM inserted AS I) AS INS

	IF @err <> 0
	BEGIN
		RAISERROR(N'Nieprawid�owa warto�� dla stan_dostepny', 16, 3)
		ROLLBACK
	END
GO

GO
DECLARE @id_wyp int
INSERT INTO WYP(id_osoby,id_ksiazki,liczba,data) VALUES (1,1,100,GETDATE())
SET @id_wyp = SCOPE_IDENTITY()
/*
Msg 50000, Level 16, State 3, Procedure ksiazka_zabezpiecz, Line 11
Nieprawid�owa warto�� dla stan_dostepny
Msg 3609, Level 16, State 1, Procedure TR_deleted, Line 3
The transaction ended in the trigger. The batch has been aborted.
*/