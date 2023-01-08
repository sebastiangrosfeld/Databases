/* Sebastian Grosfeld, GR 2, 319041 */



/* dla wygody */

GO
ALTER PROCEDURE dbo.TWORZ_PUSTA_PROC (@nazwa nvarchar(100), @debug bit = 0 )
AS
	SET @nazwa = LTRIM(RTRIM(@nazwa))

	IF NOT EXISTS 
	( SELECT 1 
		FROM sysobjects o
		WHERE	(o.[name] = @nazwa)
		AND		(OBJECTPROPERTY(o.[ID], N'IsProcedure')=1)
	)
	BEGIN
		/* skorzystamy z SP_sqlExec który wykonuje dowolne zapytanie SQL ze zmiennej */
		DECLARE @sql nvarchar(200)
		/* w napisie chc¹c uzyc ' nale podac ''  => ' '' ' */
		SET @sql = N'CREATE PROCEDURE dbo.' + @nazwa + ' AS SELECT ''' + @nazwa 
					+ N''' AS jestem_pusta_proc'
		IF @debug = 1
			SELECT @sql
		EXEC sp_sqlexec @sql
	END
GO

/* Z1 */

/* Jak taki jest to go usuwamy */
IF EXISTS ( SELECT 1 FROM sysobjects o WHERE (o.[name] = N'TR_rm_spaces') AND (OBJECTPROPERTY(o.[ID], N'IsTrigger')=1) )
	DROP TRIGGER dbo.TR_osoby_ins_up_remove_spaces
GO

/* Tworzenie triggera */
CREATE TRIGGER TR_rm_spaces ON OSOBY for INSERT,UPDATE
AS
	IF UPDATE(nazwisko)
	AND EXISTS (SELECT 1 FROM INSERTED AS I WHERE I.nazwisko LIKE N'% %')
		UPDATE OSOBY SET nazwisko = REPLACE(nazwisko, N' ', N'')
		WHERE id_osoby IN 
			(SELECT Iw.id_osoby 
			FROM INSERTED AS Iw 
			WHERE Iw.nazwisko LIKE N'% %')
GO

/* Command(s) completed successfully.
*/

/* Edycja triggera */
ALTER TRIGGER TR_rm_spaces ON OSOBY for INSERT,UPDATE
AS
	IF UPDATE(nazwisko)
	AND EXISTS (SELECT 1 FROM INSERTED AS I WHERE I.nazwisko LIKE N'% %')
		UPDATE OSOBY SET nazwisko = REPLACE(nazwisko, N' ', N'')
		WHERE id_osoby IN 
			(SELECT Iw.id_osoby 
			FROM INSERTED AS Iw 
			WHERE Iw.nazwisko LIKE N'% %')
GO

/* Command(s) completed successfully.
*/

/* Przyk³ad dzia³ania */
DELETE FROM OSOBY WHERE imie = N'Adam' AND nazwisko LIKE N'Kowal%miazga%adamczyk'
GO

DECLARE @id_miasta INT
SELECT TOP 1 @id_miasta = M.id_miasta FROM MIASTA AS M

INSERT INTO OSOBY (imie, nazwisko, id_miasta) VALUES (N'Adam', N'Kowal miazga adamczyk', @id_miasta)
GO

SELECT * FROM OSOBY AS O WHERE O.imie = N'Adam' AND O.nazwisko LIKE N'Kowal%miazga%adamczyk'
GO

/*
id_osoby    id_miasta   imie                                               nazwisko
----------- ----------- -------------------------------------------------- --------------------------------------------------
19          1           Adam                                               Kowalmiazgaadamczyk

(1 row(s) affected)
*/

/* Z2 */


EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'Procedura'
GO

GO
ALTER PROCEDURE Procedura(@imie_wzor nvarchar(20) = NULL , @nazwisko_wzor nvarchar(20) = NULL , @pokaz_zarobki bit = 0)
AS
DECLARE @sql nvarchar(1000)
SET @sql = N' '
IF @pokaz_zarobki = 0
BEGIN
SET @sql +=  N'SELECT o.imie, o.nazwisko,o.id_osoby, m.nazwa AS nazwa_miasta FROM OSOBY o join MIASTA m ON (m.id_miasta = o.id_miasta) ' 
IF @imie_wzor IS NOT NULL 
BEGIN
SET @sql += N'WHERE o.imie LIKE N''' + @imie_wzor + N''''
IF @nazwisko_wzor IS NOT NULL
SET @sql = @sql +N' AND '
END
IF @nazwisko_wzor IS NOT NULL
BEGIN
IF @imie_wzor IS NULL
SET @sql = @sql + N'WHERE '
SET @sql =@sql + N'o.nazwisko LIKE N''' + @nazwisko_wzor + N''''
END
END

IF @pokaz_zarobki = 1
BEGIN
SET @sql += N'SELECT o.imie, o.nazwisko,o.id_osoby, SUM(e.pensja) AS zarobki FROM OSOBY o join ETATY e ON (e.id_osoby = o.id_osoby) '

IF @imie_wzor IS NOT NULL 
BEGIN
SET @sql = @sql + N'WHERE o.imie LIKE ''' + @imie_wzor + N''''
IF @nazwisko_wzor IS NOT NULL
SET @sql = @sql +N' AND '
END
IF @nazwisko_wzor IS NOT NULL
BEGIN
IF @imie_wzor IS NULL
SET @sql = @sql + N'WHERE '
SET @sql =@sql + N'o.nazwisko LIKE ''' + @nazwisko_wzor + N''''
END
SET @sql = @sql +N' AND e.do IS NULL GROUP BY o.imie, o.nazwisko, o.id_osoby'
END
SELECT @sql
EXEC sp_sqlexec @sql
GO

/*
Command(s) completed successfully.
*/

/* Przyk³ady */

EXEC Procedura   @nazwisko_wzor = N'Korytkowski', @pokaz_zarobki = 1
/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT o.imie, o.nazwisko,o.id_osoby, SUM(e.pensja) AS zarobki FROM OSOBY o join ETATY e ON (e.id_osoby = o.id_osoby) WHERE o.nazwisko LIKE 'Korytkowski' AND e.do IS NULL GROUP BY o.imie, o.nazwisko, o.id_osoby

(1 row(s) affected)

imie                                               nazwisko                                           id_osoby    zarobki
-------------------------------------------------- -------------------------------------------------- ----------- ---------------------
Jacek                                              Korytkowski                                        1           12000,00

(1 row(s) affected)
*/

EXEC Procedura  @imie_wzor = N'Jacek', @nazwisko_wzor = N'Korytkowski', @pokaz_zarobki = 1
/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT o.imie, o.nazwisko,o.id_osoby, SUM(e.pensja) AS zarobki FROM OSOBY o join ETATY e ON (e.id_osoby = o.id_osoby) WHERE o.imie LIKE 'Jacek' AND o.nazwisko LIKE 'Korytkowski' AND e.do IS NULL GROUP BY o.imie, o.nazwisko, o.id_osoby

(1 row(s) affected)

imie                                               nazwisko                                           id_osoby    zarobki
-------------------------------------------------- -------------------------------------------------- ----------- ---------------------
Jacek                                              Korytkowski                                        1           12000,00

(1 row(s) affected)

*/

EXEC Procedura   @nazwisko_wzor = N'Szpatu³a'
/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT o.imie, o.nazwisko,o.id_osoby, m.nazwa AS nazwa_miasta FROM OSOBY o join MIASTA m ON (m.id_miasta = o.id_miasta) WHERE o.nazwisko LIKE N'Szpatu³a'

(1 row(s) affected)

imie                                               nazwisko                                           id_osoby    nazwa_miasta
-------------------------------------------------- -------------------------------------------------- ----------- --------------------------------------------------
Adam                                               Szpatu³a                                           2           Wejherowo
Tymon                                              Szpatu³a                                           7           Sopot
Samson                                             Szpatu³a                                           8           P³ock

(3 row(s) affected)
*/

EXEC Procedura   @nazwisko_wzor = N'Szpatu³a', @pokaz_zarobki = 1
/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT o.imie, o.nazwisko,o.id_osoby, SUM(e.pensja) AS zarobki FROM OSOBY o join ETATY e ON (e.id_osoby = o.id_osoby) WHERE o.nazwisko LIKE 'Szpatu³a' AND e.do IS NULL GROUP BY o.imie, o.nazwisko, o.id_osoby

(1 row(s) affected)

imie                                               nazwisko                                           id_osoby    zarobki
-------------------------------------------------- -------------------------------------------------- ----------- ---------------------
Adam                                               Szpatu³a                                           2           3500,00
Tymon                                              Szpatu³a                                           7           5000,00
Samson                                             Szpatu³a                                           8           3000,00

(3 row(s) affected)
*/


/* Pomocnicze */


/*
SELECT o.imie, o.nazwisko, o.id_osoby, SUM(e.pensja) AS zarobki
FROM OSOBY o
join ETATY e ON (e.id_osoby = o.id_osoby)
WHERE e.do IS NULL
GROUP BY o.imie, o.nazwisko, o.id_osoby

imie                                               nazwisko                                           id_osoby    zarobki
-------------------------------------------------- -------------------------------------------------- ----------- ---------------------
Jacek                                              Korytkowski                                        1           12000,00
Adam                                               Szpatu³a                                           2           3500,00
Piotr                                              Rojman                                             3           7000,00
Adam                                               Nawa³ka                                            5           24000,00
Karol                                              Karolak                                            6           10000,00
Tymon                                              Szpatu³a                                           7           5000,00
Samson                                             Szpatu³a                                           8           3000,00
Patryk                                             Barszcz                                            9           7000,00
Aleksander                                         Wielki                                             10          6000,00
Szymon                                             Zapa³a                                             11          8000,00
Agieszka                                           Renegat                                            12          14000,00
Roman                                              Paszczak                                           13          12000,00
Katarzyna                                          Najman                                             14          15000,00

(13 row(s) affected)



SELECT o.imie, o.nazwisko, o.id_osoby, m.nazwa AS nazwa_miasta 
FROM OSOBY o 
join MIASTA m ON (m.id_miasta = o.id_miasta)


imie                                               nazwisko                                           id_osoby    nazwa_miasta
-------------------------------------------------- -------------------------------------------------- ----------- --------------------------------------------------
Jacek                                              Korytkowski                                        1           Warszawa
Adam                                               Szpatu³a                                           2           Wejherowo
Piotr                                              Rojman                                             3           Wêgrów
Tomasz                                             Wec                                                4           Radom
Adam                                               Nawa³ka                                            5           Gdynia
Karol                                              Karolak                                            6           Gdañsk
Tymon                                              Szpatu³a                                           7           Sopot
Samson                                             Szpatu³a                                           8           P³ock
Patryk                                             Barszcz                                            9           Radom
Aleksander                                         Wielki                                             10          Warszawa
Szymon                                             Zapa³a                                             11          Warszawa
Agieszka                                           Renegat                                            12          Sopot
Roman                                              Paszczak                                           13          Gdañsk
Katarzyna                                          Najman                                             14          Gdynia

(14 row(s) affected)

*/


