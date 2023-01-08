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
Pokazaæ dane podstawowe osoby, w jakim mieœcie mieszka i w jakim to jest województwie

1)
SELECT o.imie, o.nazwisko ,
w.nazwa AS województwo,
 m.nazwa AS miasto 
 FROM MIASTA m  join OSOBY o ON (o.id_miasta = m.id_miasta) 
   join WOJ w ON (m.kod_woj = w.kod_woj)

imie                                               nazwisko                                           województwo                                        miasto
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Jacek                                              Korytkowski                                        MAZOWIECKIE                                        Warszawa
Adam                                               Szpatu³a                                           POMORSKIE                                          Wejherowo
Piotr                                              Rojman                                             MAZOWIECKIE                                        Wêgrów
Tomasz                                             Wec                                                MAZOWIECKIE                                        Radom
Adam                                               Nawa³ka                                            POMORSKIE                                          Gdynia
Karol                                              Karolak                                            POMORSKIE                                          Gdañsk
Tymon                                              Szpatu³a                                           POMORSKIE                                          Sopot
Samson                                             Szpatu³a                                           MAZOWIECKIE                                        P³ock
Patryk                                             Barszcz                                            MAZOWIECKIE                                        Radom
Aleksander                                         Wielki                                             MAZOWIECKIE                                        Warszawa
Szymon                                             Zapa³a                                             MAZOWIECKIE                                        Warszawa
Agieszka                                           Renegat                                            POMORSKIE                                          Sopot
Roman                                              Paszczak                                           POMORSKIE                                          Gdañsk
Katarzyna                                          Najman                                             POMORSKIE                                          Gdynia

(14 row(s) affected)
*/
/*
2)
Pokazaæ wszystkie osoby o nazwisku na literê M i ostatniej literze nazwiska i lub a
(je¿eli nie macie takowych to wybierzcie takie warunki - inn¹ literê pocz¹tkow¹ i inne 2 koñcowe)
które maj¹ pensje pomiêdzy 3000 a 5000 (te¿ mo¿ecie zmieniæ je¿eli macie g³ownie inne zakresy)
mieszkajace w innym mieœcie ni¿ znajduje siê firma, w której maj¹ etat
(wystarcz¹ dane z tabel etaty, firmy, osoby , miasta)

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
Tymon                                              Szpatu³a                                            5000  Sopot      Pruszyñski           Gdynia
Adam                                               Szpatu³a                                            3500  Wejherowo  Fury                 Sopot
Tymon                                              Szpatu³a                                            5000  Sopot      Allegro              Gdañsk

(3 row(s) affected)
*/
/*
3)
Pokazaæ kto ma najd³u¿sze nazwisko w bazie
(najpierw szukamy MAX z LEN(nazwisko) a potem pokazujemy te osoby z tak¹ d³ugoœci¹ nazwiska)

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
Policzyæ liczbê osób w mieœcie o nazwie (tu dajê Wam wybór - w którym mieœcie macie najwiêcej)

SELECT COUNT(DISTINCT o.id_osoby)
FROM OSOBY o
JOIN MIASTA m ON (o.id_miasta = m.id_miasta)
WHERE m.nazwa = N'Warszawa'

wybieram osoby z Warszawy

-----------
3

W podpunkcie 1) widaæ ¿e tylko 3 osoby s¹ z Warszawy

(1 row(s) affected)
*/
