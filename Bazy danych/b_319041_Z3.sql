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
2           Gda�sk
2           Gdynia
2           Sopot
1           Wejherowo
1           P�ock
3           Warszawa
2           Radom
1           W�gr�w

(8 row(s) affected)
*/
/*

Zgadza si� z wynikiem 

SELECT o.imie AS [imi�], o.nazwisko AS [nazwisko], m.nazwa AS [miasto]
FROM MIASTA m
JOIN OSOBY o ON (o.id_miasta = m.id_miasta)
ORDER BY m.nazwa

imi�                                               nazwisko                                           miasto
-------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Karol                                              Karolak                                            Gda�sk
Roman                                              Paszczak                                           Gda�sk
Adam                                               Nawa�ka                                            Gdynia
Katarzyna                                          Najman                                             Gdynia
Samson                                             Szpatu�a                                           P�ock
Tomasz                                             Wec                                                Radom
Patryk                                             Barszcz                                            Radom
Tymon                                              Szpatu�a                                           Sopot
Agieszka                                           Renegat                                            Sopot
Jacek                                              Korytkowski                                        Warszawa
Aleksander                                         Wielki                                             Warszawa
Szymon                                             Zapa�a                                             Warszawa
Adam                                               Szpatu�a                                           Wejherowo
Piotr                                              Rojman                                             W�gr�w

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

Pokrywa si� z wynikiem polecenia

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
Micha�                                             POMORSKIE
Orlen                                              POMORSKIE
Pruszy�ski                                         POMORSKIE
Rado��                                             MAZOWIECKIE

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

Te� pokrywa si� z wynikiem polecenia z podpunktu poprzedniego.

(2 row(s) affected)

Zsumowane nazwy wojew�dztw z podpunkt�w 3) i 4) daj� nam tabel� WOJ z wojew�dztwami.

SELECT * FROM WOJ

kod_woj nazwa
------- --------------------------------------------------
LUBU    LUBUSKIE
MAZ     MAZOWIECKIE
OPOL    OPOLSKIE
POM     POMORSKIE

(4 row(s) affected)
*/

