/*
Z2, Sebastian Grosfeld, GR 2, 319041

*/


/*1)*/
SELECT o.imie, o.nazwisko ,
w.nazwa AS wojew�dztwo,
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
Pokaza� dane podstawowe osoby, w jakim mie�cie mieszka i w jakim to jest wojew�dztwie

1)
SELECT o.imie, o.nazwisko ,
w.nazwa AS wojew�dztwo,
 m.nazwa AS miasto 
 FROM MIASTA m  join OSOBY o ON (o.id_miasta = m.id_miasta) 
   join WOJ w ON (m.kod_woj = w.kod_woj)

imie                                               nazwisko                                           wojew�dztwo                                        miasto
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Jacek                                              Korytkowski                                        MAZOWIECKIE                                        Warszawa
Adam                                               Szpatu�a                                           POMORSKIE                                          Wejherowo
Piotr                                              Rojman                                             MAZOWIECKIE                                        W�gr�w
Tomasz                                             Wec                                                MAZOWIECKIE                                        Radom
Adam                                               Nawa�ka                                            POMORSKIE                                          Gdynia
Karol                                              Karolak                                            POMORSKIE                                          Gda�sk
Tymon                                              Szpatu�a                                           POMORSKIE                                          Sopot
Samson                                             Szpatu�a                                           MAZOWIECKIE                                        P�ock
Patryk                                             Barszcz                                            MAZOWIECKIE                                        Radom
Aleksander                                         Wielki                                             MAZOWIECKIE                                        Warszawa
Szymon                                             Zapa�a                                             MAZOWIECKIE                                        Warszawa
Agieszka                                           Renegat                                            POMORSKIE                                          Sopot
Roman                                              Paszczak                                           POMORSKIE                                          Gda�sk
Katarzyna                                          Najman                                             POMORSKIE                                          Gdynia

(14 row(s) affected)
*/
/*
2)
Pokaza� wszystkie osoby o nazwisku na liter� M i ostatniej literze nazwiska i lub a
(je�eli nie macie takowych to wybierzcie takie warunki - inn� liter� pocz�tkow� i inne 2 ko�cowe)
kt�re maj� pensje pomi�dzy 3000 a 5000 (te� mo�ecie zmieni� je�eli macie g�ownie inne zakresy)
mieszkajace w innym mie�cie ni� znajduje si� firma, w kt�rej maj� etat
(wystarcz� dane z tabel etaty, firmy, osoby , miasta)

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
Tymon                                              Szpatu�a                                            5000  Sopot      Pruszy�ski           Gdynia
Adam                                               Szpatu�a                                            3500  Wejherowo  Fury                 Sopot
Tymon                                              Szpatu�a                                            5000  Sopot      Allegro              Gda�sk

(3 row(s) affected)
*/
/*
3)
Pokaza� kto ma najd�u�sze nazwisko w bazie
(najpierw szukamy MAX z LEN(nazwisko) a potem pokazujemy te osoby z tak� d�ugo�ci� nazwiska)

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
Policzy� liczb� os�b w mie�cie o nazwie (tu daj� Wam wyb�r - w kt�rym mie�cie macie najwi�cej)

SELECT COUNT(DISTINCT o.id_osoby)
FROM OSOBY o
JOIN MIASTA m ON (o.id_miasta = m.id_miasta)
WHERE m.nazwa = N'Warszawa'

wybieram osoby z Warszawy

-----------
3

W podpunkcie 1) wida� �e tylko 3 osoby s� z Warszawy

(1 row(s) affected)
*/
