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
Micha�                                             0,00
Fury                                               5250,00
Orlen                                              5500,00
Pruszy�ski                                         6000,00
Rado��                                             10500,00
Google                                             12000,00
Allegro                                            12000,00

(8 row(s) affected)

Firmy Adam i Micha� nie maj� etat�w wi�c �rednia w tych firmach to 0.

Mozna u�y� ALL bo zbiory firm z jak�� sredni� lub bez niej s� roz��czne.
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
Micha�                                             0,00
Fury                                               5250,00
Orlen                                              5500,00
Pruszy�ski                                         6000,00
Rado��                                             10500,00
Google                                             12000,00
Allegro                                            12000,00

(8 row(s) affected)

Taki sam wynik jak w 1.
*/

/*Z5.3*/
GO

ALTER PROCEDURE dbo.P1 (@id_miasta int )/* wcze�niej by�o u�yte CREATE ale zmieni�em w trakcie wi�c teraz jest ALTER */
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
Pomocniczy SELECT pokazuje id_miasta ,nazw� miasta, nazw� firmy oraz �redni� zarobk�w dla miasta.

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
1           Gda�sk                                             Allegro                                            12000,00
1           Gda�sk                                             Micha�                                             0,00
1           Gda�sk                                             Orlen                                              5500,00
2           Gdynia                                             Pruszy�ski                                         6000,00
4           Hel                                                NULL                                               0,00
6           P�ock                                              NULL                                               0,00
8           Radom                                              Rado��                                             10500,00
3           Sopot                                              Fury                                               5250,00
7           Warszawa                                           Google                                             12000,00
5           Wejherowo                                          Adam                                               0,00
9           W�gr�w                                             NULL                                               0,00

(11 row(s) affected)

*/
