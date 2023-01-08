/* Z4 , Sebastian Grosfeld GR2 319041 */

/*  Z4.1 */
SELECT o.id_osoby, o.imie, o.nazwisko
	FROM OSOBY o
	join MIASTA m ON (o.id_miasta = m.id_miasta)
	join WOJ w ON (w.kod_woj = m.kod_woj)
	WHERE NOT EXISTS 
	( SELECT 1 /* nie ma znaczenia co wybieramy 
				** liczy si� tylko czy chocia� jeden wiersz si� znajdzie 
				*/
 		FROM  ETATY eW
		join FIRMY fW ON (eW.id_firmy = fW.nazwa_skr)
		join MIASTA mW ON (fW.id_miasta = mW.id_miasta)
		join WOJ wW ON (wW.kod_woj =mW.kod_woj)
		
		WHERE 
		(o.id_osoby = eW.id_osoby) /* warunek ��cz�cy zapytanie g�rne z dolnym */
			/* o.id_osoby ID osoby z zewn�trznego zapytania
			** ew.ID_OSOBY - etaty z wewn�trzneo zapytania */
		 AND		(wW.kod_woj = N'MAZ')/* warunek wynikaj�cy z zapytania */
		 /* wewn�trzy SELECT pokazuje osoby z etatami w wojew�dztwie o kodzie MAZ wi�c z NOT EXISTS pokazuje pozosta�e */
	)
	AND (w.kod_woj = N'MAZ') /* i jeszcze wybieramy osoby z kodem wojew�dztwa MAZ */

/*  Z4.2 */

SELECT w.nazwa ,COUNT(DISTINCT o.id_osoby) AS liczba_os
FROM OSOBY o, WOJ w
join MIASTA m ON (m.kod_woj = w.kod_woj)
WHERE(o.id_miasta = m.id_miasta)
GROUP BY w.nazwa
HAVING COUNT(DISTINCT o.id_osoby) > 1/* stawiam warunek �eby ilo�� by�a wi�ksza od 1 */ 


/*  Z4.3 */

/*Wariant 2 > (srednia z firm w miastach) a liczba mieszka�c�w*/
SELECT m.nazwa ,AVG(e.pensja) AS �rednia
FROM MIASTA m, ETATY e
join FIRMY f ON (e.id_firmy = f.nazwa_skr)
WHERE(f.id_miasta = m.id_miasta)
GROUP BY m.nazwa

/*Wariant 1 -> etaty -> osoby -> miasta (srednia z os�b mieszkaj�cych)*/
SELECT m.nazwa ,AVG(e.pensja) AS �rednia
FROM MIASTA m, ETATY e
join OSOBY o ON (e.id_osoby = o.id_osoby)
WHERE(m.id_miasta = o.id_miasta)
GROUP BY m.nazwa

/*--------------------------------------------------------------------------------------------------------------*/

/*  Z4.1 */
SELECT o.id_osoby, o.imie, o.nazwisko
	FROM OSOBY o
	join MIASTA m ON (o.id_miasta = m.id_miasta)
	join WOJ w ON (w.kod_woj = m.kod_woj)
	WHERE NOT EXISTS 
	( SELECT 1 /* nie ma znaczenia co wybieramy 
				** liczy si� tylko czy chocia� jeden wiersz si� znajdzie 
				*/
 		FROM  ETATY eW
		join FIRMY fW ON (eW.id_firmy = fW.nazwa_skr)
		join MIASTA mW ON (fW.id_miasta = mW.id_miasta)
		join WOJ wW ON (wW.kod_woj =mW.kod_woj)
		
		WHERE 
		(o.id_osoby = eW.id_osoby) /* warunek ��cz�cy zapytanie g�rne z dolnym */
			/* o.id_osoby ID osoby z zewn�trznego zapytania
			** ew.ID_OSOBY - etaty z wewn�trzneo zapytania */
		 AND		(wW.kod_woj = N'MAZ')/* warunek wynikaj�cy z zapytania */
		 /* wewn�trzy SELECT pokazuje osoby z etatami w wojew�dztwie o kodzie MAZ wi�c z NOT EXISTS pokazuje pozosta�e */
	)
	AND (w.kod_woj = N'MAZ') /* i jeszcze wybieramy osoby z kodem wojew�dztwa MAZ */

	/* Wynik z powy�szego

id_osoby    imie                                               nazwisko
----------- -------------------------------------------------- --------------------------------------------------
3           Piotr                                              Rojman
4           Tomasz                                             Wec
8           Samson                                             Szpatu�a
9           Patryk                                             Barszcz
11          Szymon                                             Zapa�a

(5 row(s) affected)
*/
/* Na dow�d pos�u�� si� selectami :


	SELECT o.imie AS imie, o.nazwisko AS nazwisko, f.nazwa AS firma 
	FROM OSOBY o, FIRMY f
	join ETATY e ON (f.nazwa_skr = e.id_firmy)
	WHERE (o.id_osoby = e.id_osoby)

	Pokazuje imi�, nazwisko oraz firm� dla ka�dego z etat�w.

	imie                                               nazwisko                                           firma
-------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Jacek                                              Korytkowski                                        Google
Samson                                             Szpatu�a                                           Orlen
Tymon                                              Szpatu�a                                           Pruszy�ski
Katarzyna                                          Najman                                             Rado��
Karol                                              Karolak                                            Google
Roman                                              Paszczak                                           Google
Adam                                               Szpatu�a                                           Fury
Patryk                                             Barszcz                                            Allegro
Aleksander                                         Wielki                                             Rado��
Szymon                                             Zapa�a                                             Orlen
Agieszka                                           Renegat                                            Google
Adam                                               Nawa�ka                                            Pruszy�ski
Piotr                                              Rojman                                             Orlen
Tomasz                                             Wec                                                Allegro
Piotr                                              Rojman                                             Fury
Adam                                               Nawa�ka                                            Allegro
Samson                                             Szpatu�a                                           Pruszy�ski
Tymon                                              Szpatu�a                                           Allegro
Katarzyna                                          Najman                                             Rado��
Roman                                              Paszczak                                           Google

(20 row(s) affected)



	SELECT o.imie AS imie, o.nazwisko AS nazwisko, w.nazwa AS nazwa_woj
	FROM OSOBY o, WOJ w
	join MIASTA m ON(m.kod_woj =w.kod_woj)
	WHERE (o.id_miasta = m.id_miasta)

	Pokazuje imi�, nazwisko oraz z jakiego wojew�dztwa jest dana osoba.

	imie                                               nazwisko                                           nazwa_woj
-------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Jacek                                              Korytkowski                                        MAZOWIECKIE
Adam                                               Szpatu�a                                           POMORSKIE
Piotr                                              Rojman                                             MAZOWIECKIE
Tomasz                                             Wec                                                MAZOWIECKIE
Adam                                               Nawa�ka                                            POMORSKIE
Karol                                              Karolak                                            POMORSKIE
Tymon                                              Szpatu�a                                           POMORSKIE
Samson                                             Szpatu�a                                           MAZOWIECKIE
Patryk                                             Barszcz                                            MAZOWIECKIE
Aleksander                                         Wielki                                             MAZOWIECKIE
Szymon                                             Zapa�a                                             MAZOWIECKIE
Agieszka                                           Renegat                                            POMORSKIE
Roman                                              Paszczak                                           POMORSKIE
Katarzyna                                          Najman                                             POMORSKIE

(14 row(s) affected)
	
	SELECT f.nazwa AS nazwa_firmy , w.nazwa AS nazwa_woj
	FROM FIRMY f, WOJ w
	join MIASTA m ON (m.kod_woj = w.kod_woj)
	WHERE(m.id_miasta = f.id_miasta)

	Pokazuje z jakiego wojew�dztwa jest ka�da firma.

	nazwa_firmy                                        nazwa_woj
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


Por�wnuj�c powy�sze dane widzimy �e osoby w rozwi�zaniu s� z wojew�dztwa Mazowieckiego, ale nie pracowa�y w nim nigdy.*/

/*  Z4.2 */

SELECT w.nazwa ,COUNT(DISTINCT o.id_osoby) AS liczba_os
FROM OSOBY o, WOJ w
join MIASTA m ON (m.kod_woj = w.kod_woj)
WHERE(o.id_miasta = m.id_miasta)
GROUP BY w.nazwa
HAVING COUNT(DISTINCT o.id_osoby) > 1/* stawiam warunek �eby ilo�� by�a wi�ksza od 1 */ 

/*
nazwa                                              liczba_os
-------------------------------------------------- -----------
MAZOWIECKIE                                        7
POMORSKIE                                          7

(2 row(s) affected)

Jako dow�d mo�e pos�u�y� wynik selectu 

SELECT o.imie AS imie, o.nazwisko AS nazwisko, w.nazwa AS nazwa_woj
	FROM OSOBY o, WOJ w
	join MIASTA m ON(m.kod_woj =w.kod_woj)
	WHERE (o.id_miasta = m.id_miasta)

	,kt�ry pokazuje imi�, nazwisko oraz z jakiego wojew�dztwa jest dana osoba.

	imie                                               nazwisko                                           nazwa_woj
-------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Jacek                                              Korytkowski                                        MAZOWIECKIE
Adam                                               Szpatu�a                                           POMORSKIE
Piotr                                              Rojman                                             MAZOWIECKIE
Tomasz                                             Wec                                                MAZOWIECKIE
Adam                                               Nawa�ka                                            POMORSKIE
Karol                                              Karolak                                            POMORSKIE
Tymon                                              Szpatu�a                                           POMORSKIE
Samson                                             Szpatu�a                                           MAZOWIECKIE
Patryk                                             Barszcz                                            MAZOWIECKIE
Aleksander                                         Wielki                                             MAZOWIECKIE
Szymon                                             Zapa�a                                             MAZOWIECKIE
Agieszka                                           Renegat                                            POMORSKIE
Roman                                              Paszczak                                           POMORSKIE
Katarzyna                                          Najman                                             POMORSKIE

(14 row(s) affected)
*/

/*  Z4.3 */

/*Wariant 2*/
SELECT m.nazwa ,AVG(e.pensja) AS �rednia
FROM MIASTA m, ETATY e
join FIRMY f ON (e.id_firmy = f.nazwa_skr)
WHERE(f.id_miasta = m.id_miasta)
GROUP BY m.nazwa
/*
nazwa                                              �rednia
-------------------------------------------------- ---------------------
Gda�sk                                             7428,5714
Gdynia                                             7000,00
Radom                                              8500,00
Sopot                                              5250,00
Warszawa                                           11400,00

(5 row(s) affected)
*/


/*Wariant 1*/
SELECT m.nazwa ,AVG(e.pensja) AS �rednia
FROM MIASTA m, ETATY e
join OSOBY o ON (e.id_osoby = o.id_osoby)
WHERE(m.id_miasta = o.id_miasta)
GROUP BY m.nazwa
/*
nazwa                                              �rednia
-------------------------------------------------- ---------------------
Gda�sk                                             10333,3333
Gdynia                                             10875,00
P�ock                                              6000,00
Radom                                              7500,00
Sopot                                              8000,00
Warszawa                                           8666,6666
Wejherowo                                          3500,00
W�gr�w                                             5500,00

(8 row(s) affected)
*/