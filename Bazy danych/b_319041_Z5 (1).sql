/*
Z5 Sebastian Grosfeld 319041, grupa 2
*/

/*
/*Z5.1*/
SELECT f.nazwa, X.srednia_zarobkow
	FROM FIRMY f
	join (SELECT eW.id_firmy, AVG(ew.pensja) AS srednia_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_firmy
		) X ON (X.id_firmy = f.nazwa_skr)
UNION ALL
SELECT f.nazwa, CONVERT(money,0) AS XX
	FROM FIRMY f
	WHERE NOT EXISTS (SELECT 1 FROM etaty eW WHERE eW.id_firmy = f.nazwa_skr AND eW.do is null)
	ORDER BY 2

/*Z5.2*/
SELECT f.nazwa, ISNULL(X.srednia_zarobkow,0)
	FROM FIRMY f
	left outer
	join (SELECT eW.id_firmy, AVG(ew.pensja) AS srednia_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_firmy
		) X ON (X.id_firmy = f.nazwa_skr)
	ORDER BY 2

/*Z5.3*/
GO

ALTER PROCEDURE dbo.P1 (@id_miasta int )
AS
SELECT m.nazwa AS miasto, f.nazwa AS firma, ISNULL(X.srednia_zarobkow,0)
	FROM MIASTA m
	left outer
	join FIRMY f ON (m.id_miasta =f.id_miasta)
	left outer
	join (SELECT eW.id_firmy, AVG(ew.pensja) AS srednia_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_firmy
		) X ON (X.id_firmy = f.nazwa_skr)
		WHERE (m.id_miasta = @id_miasta)
	ORDER BY 2
GO

EXEC P1 1
*/





/*Z5.1*/
SELECT f.nazwa, X.srednia_zarobkow
	FROM FIRMY f
	join (SELECT eW.id_firmy, AVG(ew.pensja) AS srednia_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_firmy
		) X ON (X.id_firmy = f.nazwa_skr)
UNION ALL
SELECT f.nazwa, CONVERT(money,0) AS XX
	FROM FIRMY f
	WHERE NOT EXISTS (SELECT 1 FROM etaty eW WHERE eW.id_firmy = f.nazwa_skr AND eW.do is null)
	ORDER BY 2

/*
nazwa                                              srednia_zarobkow
-------------------------------------------------- ---------------------
Adam                                               0,00
Micha³                                             0,00
Fury                                               5250,00
Orlen                                              5500,00
Pruszyñski                                         6000,00
Radoœæ                                             10500,00
Google                                             12000,00
Allegro                                            12000,00

(8 row(s) affected)

Firmy Adam i Micha³ nie maj¹ etatów wiêc œrednia w tych firmach to 0.

Mozna u¿yæ ALL bo zbiory firm z jak¹œ sredni¹ lub bez niej s¹ roz³¹czne.
*/

/*Z5.2*/
SELECT f.nazwa, ISNULL(X.srednia_zarobkow,0)
	FROM FIRMY f
	left outer
	join (SELECT eW.id_firmy, AVG(ew.pensja) AS srednia_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_firmy
		) X ON (X.id_firmy = f.nazwa_skr)
	ORDER BY 2

/*
nazwa                                              
-------------------------------------------------- ---------------------
Adam                                               0,00
Micha³                                             0,00
Fury                                               5250,00
Orlen                                              5500,00
Pruszyñski                                         6000,00
Radoœæ                                             10500,00
Google                                             12000,00
Allegro                                            12000,00

(8 row(s) affected)

Taki sam wynik jak w 1.
*/

/*Z5.3*/
GO

ALTER PROCEDURE dbo.P1 (@id_miasta int )/* wczeœniej by³o u¿yte CREATE ale zmieni³em w trakcie wiêc teraz jest ALTER */
AS
SELECT m.nazwa AS miasto, f.nazwa AS firma, ISNULL(X.srednia_zarobkow,0)
	FROM MIASTA m
	left outer
	join FIRMY f ON (m.id_miasta =f.id_miasta)
	left outer
	join (SELECT eW.id_firmy, AVG(ew.pensja) AS srednia_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_firmy
		) X ON (X.id_firmy = f.nazwa_skr)
		WHERE (m.id_miasta = @id_miasta)
	ORDER BY 2
GO

EXEC P1 1
/*
nazwa                                              
-------------------------------------------------- ---------------------
Gdynia                                             6000,00

(1 row(s) affected)

*/
/*
Pomocniczy SELECT pokazuje id_miasta ,nazwê miasta, nazwê firmy oraz œredni¹ zarobków dla miasta.

SELECT m.id_miasta ,m.nazwa, f.nazwa, ISNULL(X.srednia_zarobkow,0)
	FROM MIASTA m
	left outer
	join FIRMY f ON (m.id_miasta =f.id_miasta)
	left outer
	join (SELECT eW.id_firmy, AVG(ew.pensja) AS srednia_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_firmy
		) X ON (X.id_firmy = f.nazwa_skr)
		
	ORDER BY 2

id_miasta   nazwa                                              nazwa                                              
----------- -------------------------------------------------- -------------------------------------------------- ---------------------
1           Gdañsk                                             Allegro                                            12000,00
1           Gdañsk                                             Micha³                                             0,00
1           Gdañsk                                             Orlen                                              5500,00
2           Gdynia                                             Pruszyñski                                         6000,00
4           Hel                                                NULL                                               0,00
6           P³ock                                              NULL                                               0,00
8           Radom                                              Radoœæ                                             10500,00
3           Sopot                                              Fury                                               5250,00
7           Warszawa                                           Google                                             12000,00
5           Wejherowo                                          Adam                                               0,00
9           Wêgrów                                             NULL                                               0,00

(11 row(s) affected)

*/
