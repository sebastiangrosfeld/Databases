/*
Z2, Sebastian Grosfeld, GR 2, 319041

*/


/*1)*/
SELECT o.imie, o.nazwisko ,
w.nazwa AS województwo,
 m.nazwa AS miasto 
 FROM MIASTA m  join OSOBY o ON (o.id_miasta = m.id_miasta) 
   join WOJ w ON (m.kod_woj = w.kod_woj)

/*2)*/
SELECT o.imie, o.nazwisko ,
STR(e.pensja, 5,0)	AS pensja,
	LEFT(mO.nazwa,10)	AS [miasto os]
	,	CONVERT(nvarchar(20), f.nazwa) AS firma
	,	LEFT(mF.nazwa,10)	AS [miasto fi]
FROM ETATY e
	join OSOBY o ON (o.id_osoby = e.id_osoby)
	join firmy f ON (e.id_firmy = f.nazwa_skr)
	join miasta mO /* miasta gdzie mieszka osoba */
				ON (mO.id_miasta = o.id_miasta)
	join miasta mF /* miasta gdzie jest FIRMA */
				ON (f.id_miasta = mF.id_miasta)
WHERE (LEFT(o.nazwisko,1)) = N'S' AND (RIGHT(o.nazwisko,1)IN(N'a',N'i'))
AND (e.pensja BETWEEN 3500 AND 5000) AND (o.id_miasta != f.id_miasta)

/*3)*/
DECLARE @max int
SELECT @max = MAX(LEN(o.nazwisko))
	FROM OSOBY o

SELECT o.imie, o.nazwisko FROM
OSOBY o WHERE (LEN(o.nazwisko) = @max)

/*4)*/
SELECT COUNT(DISTINCT o.id_osoby)
FROM OSOBY o
JOIN MIASTA m ON (o.id_miasta = m.id_miasta)
WHERE m.nazwa = N'Warszawa'


/*----------------------------------------------------------------------------------------------------------------------------------*/
/*
Pokazać dane podstawowe osoby, w jakim mieście mieszka i w jakim to jest województwie

1)
SELECT o.imie, o.nazwisko ,
w.nazwa AS województwo,
 m.nazwa AS miasto 
 FROM MIASTA m  join OSOBY o ON (o.id_miasta = m.id_miasta) 
   join WOJ w ON (m.kod_woj = w.kod_woj)

imie                                               nazwisko                                           województwo                                        miasto
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Jacek                                              Korytkowski                                        MAZOWIECKIE                                        Warszawa
Adam                                               Szpatuła                                           POMORSKIE                                          Wejherowo
Piotr                                              Rojman                                             MAZOWIECKIE                                        Węgrów
Tomasz                                             Wec                                                MAZOWIECKIE                                        Radom
Adam                                               Nawałka                                            POMORSKIE                                          Gdynia
Karol                                              Karolak                                            POMORSKIE                                          Gdańsk
Tymon                                              Szpatuła                                           POMORSKIE                                          Sopot
Samson                                             Szpatuła                                           MAZOWIECKIE                                        Płock
Patryk                                             Barszcz                                            MAZOWIECKIE                                        Radom
Aleksander                                         Wielki                                             MAZOWIECKIE                                        Warszawa
Szymon                                             Zapała                                             MAZOWIECKIE                                        Warszawa
Agieszka                                           Renegat                                            POMORSKIE                                          Sopot
Roman                                              Paszczak                                           POMORSKIE                                          Gdańsk
Katarzyna                                          Najman                                             POMORSKIE                                          Gdynia

(14 row(s) affected)
*/
/*
2)
Pokazać wszystkie osoby o nazwisku na literę M i ostatniej literze nazwiska i lub a
(jeżeli nie macie takowych to wybierzcie takie warunki - inną literę początkową i inne 2 końcowe)
które mają pensje pomiędzy 3000 a 5000 (też możecie zmienić jeżeli macie głownie inne zakresy)
mieszkajace w innym mieście niż znajduje się firma, w której mają etat
(wystarczą dane z tabel etaty, firmy, osoby , miasta)

SELECT o.imie, o.nazwisko ,
STR(e.pensja, 5,0)	AS pensja,
	LEFT(mO.nazwa,10)	AS [miasto os]
	,	CONVERT(nvarchar(20), f.nazwa) AS firma
	,	LEFT(mF.nazwa,10)	AS [miasto fi]
FROM ETATY e
	join OSOBY o ON (o.id_osoby = e.id_osoby)
	join firmy f ON (e.id_firmy = f.nazwa_skr)
	join miasta mO /* miasta gdzie mieszka osoba */
				ON (mO.id_miasta = o.id_miasta)
	join miasta mF /* miasta gdzie jest FIRMA */
				ON (f.id_miasta = mF.id_miasta)
WHERE (LEFT(o.nazwisko,1)) = N'S' AND (RIGHT(o.nazwisko,1)IN(N'a',N'i'))
AND (e.pensja BETWEEN 3500 AND 5000) AND (o.id_miasta != f.id_miasta)

*/
/*
imie                                               nazwisko                                           pensja miasto os  firma                miasto fi
-------------------------------------------------- -------------------------------------------------- ------ ---------- -------------------- ----------

(0 row(s) affected)

zmieniam dane pierwsza litera S ostatnie to a lub i oraz pensji na <3500,5000>

*/
/*
imie                                               nazwisko                                           pensja miasto os  firma                miasto fi
-------------------------------------------------- -------------------------------------------------- ------ ---------- -------------------- ----------
Tymon                                              Szpatuła                                            5000  Sopot      Pruszyński           Gdynia
Adam                                               Szpatuła                                            3500  Wejherowo  Fury                 Sopot
Tymon                                              Szpatuła                                            5000  Sopot      Allegro              Gdańsk

(3 row(s) affected)
*/
/*
3)
Pokazać kto ma najdłuższe nazwisko w bazie
(najpierw szukamy MAX z LEN(nazwisko) a potem pokazujemy te osoby z taką długością nazwiska)

DECLARE @max int
SELECT @max = MAX(LEN(o.nazwisko))
	FROM OSOBY o

SELECT o.imie, o.nazwisko FROM
OSOBY o WHERE (LEN(o.nazwisko) = @max)

imie                                               nazwisko
-------------------------------------------------- --------------------------------------------------
Jacek                                              Korytkowski

(1 row(s) affected)

*/
/*
4)
Policzyć liczbę osób w mieście o nazwie (tu daję Wam wybór - w którym mieście macie najwięcej)

SELECT COUNT(DISTINCT o.id_osoby)
FROM OSOBY o
JOIN MIASTA m ON (o.id_miasta = m.id_miasta)
WHERE m.nazwa = N'Warszawa'

wybieram osoby z Warszawy

-----------
3

W podpunkcie 1) widać że tylko 3 osoby są z Warszawy

(1 row(s) affected)
*/
