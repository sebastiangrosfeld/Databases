/* Z3 , Sebastian Grosfeld GR2 319041 */

1)
SELECT t.[liczba osob], m.nazwa AS [nazwa miasta] 
INTO #W
FROM (SELECT COUNT(*) AS [liczba osob], oW.id_miasta 
		FROM OSOBY oW
		GROUP BY oW.id_miasta 
) t
join miasta m ON (m.id_miasta = t.id_miasta)

2)
DECLARE @max int
SELECT @max = MAX([liczba osob])
FROM #W

SELECT *
FROM #W
WHERE [liczba osob] = @max

3)
SELECT w.nazwa AS [nazwa woj],COUNT(*) AS [liczba firm]
FROM FIRMY f
JOIN MIASTA m ON (m.id_miasta = f.id_miasta)
JOIN WOJ w ON (m.kod_woj = w.kod_woj)
GROUP BY w.nazwa

4)
SELECT * 
FROM WOJ w
WHERE NOT EXISTS
(SELECT 1
FROM FIRMY f
JOIN MIASTA m ON (m.id_miasta = f.id_miasta)
WHERE (m.kod_woj = w.kod_woj)
)
/*
1)
SELECT t.[liczba osob], m.nazwa AS [nazwa miasta] 
INTO #W
FROM (SELECT COUNT(*) AS [liczba osob], oW.id_miasta 
		FROM OSOBY oW
		GROUP BY oW.id_miasta 
) t
join miasta m ON (m.id_miasta = t.id_miasta)
*/
/*liczba osob nazwa miasta
----------- --------------------------------------------------
2           Gdañsk
2           Gdynia
2           Sopot
1           Wejherowo
1           P³ock
3           Warszawa
2           Radom
1           Wêgrów

(8 row(s) affected)
*/
/*

Zgadza siê z wynikiem 

SELECT o.imie AS [imiê], o.nazwisko AS [nazwisko], m.nazwa AS [miasto]
FROM MIASTA m
JOIN OSOBY o ON (o.id_miasta = m.id_miasta)
ORDER BY m.nazwa

imiê                                               nazwisko                                           miasto
-------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Karol                                              Karolak                                            Gdañsk
Roman                                              Paszczak                                           Gdañsk
Adam                                               Nawa³ka                                            Gdynia
Katarzyna                                          Najman                                             Gdynia
Samson                                             Szpatu³a                                           P³ock
Tomasz                                             Wec                                                Radom
Patryk                                             Barszcz                                            Radom
Tymon                                              Szpatu³a                                           Sopot
Agieszka                                           Renegat                                            Sopot
Jacek                                              Korytkowski                                        Warszawa
Aleksander                                         Wielki                                             Warszawa
Szymon                                             Zapa³a                                             Warszawa
Adam                                               Szpatu³a                                           Wejherowo
Piotr                                              Rojman                                             Wêgrów

(14 row(s) affected)


*/
---------------------------------------------------
/*
2)
DECLARE @max int
SELECT @max = MAX([liczba osob])
FROM #W

SELECT *
FROM #W
WHERE [liczba osob] = @max
*/
/*
liczba osob nazwa miasta
----------- --------------------------------------------------
3           Warszawa

(1 row(s) affected)
*/
-----------------------------------------
/*
3)
SELECT w.nazwa AS [nazwa woj],COUNT(*) AS [liczba firm]
FROM FIRMY f
JOIN MIASTA m ON (m.id_miasta = f.id_miasta)
JOIN WOJ w ON (m.kod_woj = w.kod_woj)
GROUP BY w.nazwa
*/
/*
nazwa woj                                          liczba firm
-------------------------------------------------- -----------
MAZOWIECKIE                                        2
POMORSKIE                                          6

(2 row(s) affected)

Pokrywa siê z wynikiem polecenia

SELECT f.nazwa AS [f_nazwa], w.nazwa AS [w_nazwa]
FROM FIRMY f 
JOIN MIASTA m ON (m.id_miasta = f.id_miasta)
JOIN WOJ w ON (m.kod_woj = w.kod_woj)


f_nazwa                                            w_nazwa
-------------------------------------------------- --------------------------------------------------
Adam                                               POMORSKIE
Allegro                                            POMORSKIE
Fury                                               POMORSKIE
Google                                             MAZOWIECKIE
Micha³                                             POMORSKIE
Orlen                                              POMORSKIE
Pruszyñski                                         POMORSKIE
Radoœæ                                             MAZOWIECKIE

(8 row(s) affected)
*/
/*
---------------------------------------------------------

4)
SELECT * 
FROM WOJ w
WHERE NOT EXISTS
(SELECT 1
FROM FIRMY f
JOIN MIASTA m ON (m.id_miasta = f.id_miasta)
WHERE (m.kod_woj = w.kod_woj)
)


kod_woj nazwa
------- --------------------------------------------------
LUBU    LUBUSKIE
OPOL    OPOLSKIE

Te¿ pokrywa siê z wynikiem polecenia z podpunktu poprzedniego.

(2 row(s) affected)

Zsumowane nazwy województw z podpunktów 3) i 4) daj¹ nam tabelê WOJ z województwami.

SELECT * FROM WOJ

kod_woj nazwa
------- --------------------------------------------------
LUBU    LUBUSKIE
MAZ     MAZOWIECKIE
OPOL    OPOLSKIE
POM     POMORSKIE

(4 row(s) affected)
*/

