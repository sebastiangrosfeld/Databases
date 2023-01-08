/* Z4 , Sebastian Grosfeld GR2 319041 */

/*  Z4.1 */
SELECT o.id_osoby, o.imie, o.nazwisko
	FROM OSOBY o
	join MIASTA m ON (o.id_miasta = m.id_miasta)
	join WOJ w ON (w.kod_woj = m.kod_woj)
	WHERE NOT EXISTS 
	( SELECT 1 /* nie ma znaczenia co wybieramy 
				** liczy siê tylko czy chocia¿ jeden wiersz siê znajdzie 
				*/
 		FROM  ETATY eW
		join FIRMY fW ON (eW.id_firmy = fW.nazwa_skr)
		join MIASTA mW ON (fW.id_miasta = mW.id_miasta)
		join WOJ wW ON (wW.kod_woj =mW.kod_woj)
		
		WHERE 
		(o.id_osoby = eW.id_osoby) /* warunek ³¹cz¹cy zapytanie górne z dolnym */
			/* o.id_osoby ID osoby z zewnêtrznego zapytania
			** ew.ID_OSOBY - etaty z wewnêtrzneo zapytania */
		 AND		(wW.kod_woj = N'MAZ')/* warunek wynikaj¹cy z zapytania */
		 /* wewnêtrzy SELECT pokazuje osoby z etatami w województwie o kodzie MAZ wiêc z NOT EXISTS pokazuje pozosta³e */
	)
	AND (w.kod_woj = N'MAZ') /* i jeszcze wybieramy osoby z kodem województwa MAZ */

/*  Z4.2 */

SELECT w.nazwa ,COUNT(DISTINCT o.id_osoby) AS liczba_os
FROM OSOBY o, WOJ w
join MIASTA m ON (m.kod_woj = w.kod_woj)
WHERE(o.id_miasta = m.id_miasta)
GROUP BY w.nazwa
HAVING COUNT(DISTINCT o.id_osoby) > 1/* stawiam warunek ¿eby iloœæ by³a wiêksza od 1 */ 


/*  Z4.3 */

/*Wariant 2 > (srednia z firm w miastach) a liczba mieszkañców*/
SELECT m.nazwa ,AVG(e.pensja) AS œrednia
FROM MIASTA m, ETATY e
join FIRMY f ON (e.id_firmy = f.nazwa_skr)
WHERE(f.id_miasta = m.id_miasta)
GROUP BY m.nazwa

/*Wariant 1 -> etaty -> osoby -> miasta (srednia z osób mieszkaj¹cych)*/
SELECT m.nazwa ,AVG(e.pensja) AS œrednia
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
				** liczy siê tylko czy chocia¿ jeden wiersz siê znajdzie 
				*/
 		FROM  ETATY eW
		join FIRMY fW ON (eW.id_firmy = fW.nazwa_skr)
		join MIASTA mW ON (fW.id_miasta = mW.id_miasta)
		join WOJ wW ON (wW.kod_woj =mW.kod_woj)
		
		WHERE 
		(o.id_osoby = eW.id_osoby) /* warunek ³¹cz¹cy zapytanie górne z dolnym */
			/* o.id_osoby ID osoby z zewnêtrznego zapytania
			** ew.ID_OSOBY - etaty z wewnêtrzneo zapytania */
		 AND		(wW.kod_woj = N'MAZ')/* warunek wynikaj¹cy z zapytania */
		 /* wewnêtrzy SELECT pokazuje osoby z etatami w województwie o kodzie MAZ wiêc z NOT EXISTS pokazuje pozosta³e */
	)
	AND (w.kod_woj = N'MAZ') /* i jeszcze wybieramy osoby z kodem województwa MAZ */

	/* Wynik z powy¿szego

id_osoby    imie                                               nazwisko
----------- -------------------------------------------------- --------------------------------------------------
3           Piotr                                              Rojman
4           Tomasz                                             Wec
8           Samson                                             Szpatu³a
9           Patryk                                             Barszcz
11          Szymon                                             Zapa³a

(5 row(s) affected)
*/
/* Na dowód pos³u¿ê siê selectami :


	SELECT o.imie AS imie, o.nazwisko AS nazwisko, f.nazwa AS firma 
	FROM OSOBY o, FIRMY f
	join ETATY e ON (f.nazwa_skr = e.id_firmy)
	WHERE (o.id_osoby = e.id_osoby)

	Pokazuje imiê, nazwisko oraz firmê dla ka¿dego z etatów.

	imie                                               nazwisko                                           firma
-------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Jacek                                              Korytkowski                                        Google
Samson                                             Szpatu³a                                           Orlen
Tymon                                              Szpatu³a                                           Pruszyñski
Katarzyna                                          Najman                                             Radoœæ
Karol                                              Karolak                                            Google
Roman                                              Paszczak                                           Google
Adam                                               Szpatu³a                                           Fury
Patryk                                             Barszcz                                            Allegro
Aleksander                                         Wielki                                             Radoœæ
Szymon                                             Zapa³a                                             Orlen
Agieszka                                           Renegat                                            Google
Adam                                               Nawa³ka                                            Pruszyñski
Piotr                                              Rojman                                             Orlen
Tomasz                                             Wec                                                Allegro
Piotr                                              Rojman                                             Fury
Adam                                               Nawa³ka                                            Allegro
Samson                                             Szpatu³a                                           Pruszyñski
Tymon                                              Szpatu³a                                           Allegro
Katarzyna                                          Najman                                             Radoœæ
Roman                                              Paszczak                                           Google

(20 row(s) affected)



	SELECT o.imie AS imie, o.nazwisko AS nazwisko, w.nazwa AS nazwa_woj
	FROM OSOBY o, WOJ w
	join MIASTA m ON(m.kod_woj =w.kod_woj)
	WHERE (o.id_miasta = m.id_miasta)

	Pokazuje imiê, nazwisko oraz z jakiego województwa jest dana osoba.

	imie                                               nazwisko                                           nazwa_woj
-------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Jacek                                              Korytkowski                                        MAZOWIECKIE
Adam                                               Szpatu³a                                           POMORSKIE
Piotr                                              Rojman                                             MAZOWIECKIE
Tomasz                                             Wec                                                MAZOWIECKIE
Adam                                               Nawa³ka                                            POMORSKIE
Karol                                              Karolak                                            POMORSKIE
Tymon                                              Szpatu³a                                           POMORSKIE
Samson                                             Szpatu³a                                           MAZOWIECKIE
Patryk                                             Barszcz                                            MAZOWIECKIE
Aleksander                                         Wielki                                             MAZOWIECKIE
Szymon                                             Zapa³a                                             MAZOWIECKIE
Agieszka                                           Renegat                                            POMORSKIE
Roman                                              Paszczak                                           POMORSKIE
Katarzyna                                          Najman                                             POMORSKIE

(14 row(s) affected)
	
	SELECT f.nazwa AS nazwa_firmy , w.nazwa AS nazwa_woj
	FROM FIRMY f, WOJ w
	join MIASTA m ON (m.kod_woj = w.kod_woj)
	WHERE(m.id_miasta = f.id_miasta)

	Pokazuje z jakiego województwa jest ka¿da firma.

	nazwa_firmy                                        nazwa_woj
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


Porównuj¹c powy¿sze dane widzimy ¿e osoby w rozwi¹zaniu s¹ z województwa Mazowieckiego, ale nie pracowa³y w nim nigdy.*/

/*  Z4.2 */

SELECT w.nazwa ,COUNT(DISTINCT o.id_osoby) AS liczba_os
FROM OSOBY o, WOJ w
join MIASTA m ON (m.kod_woj = w.kod_woj)
WHERE(o.id_miasta = m.id_miasta)
GROUP BY w.nazwa
HAVING COUNT(DISTINCT o.id_osoby) > 1/* stawiam warunek ¿eby iloœæ by³a wiêksza od 1 */ 

/*
nazwa                                              liczba_os
-------------------------------------------------- -----------
MAZOWIECKIE                                        7
POMORSKIE                                          7

(2 row(s) affected)

Jako dowód mo¿e pos³u¿yæ wynik selectu 

SELECT o.imie AS imie, o.nazwisko AS nazwisko, w.nazwa AS nazwa_woj
	FROM OSOBY o, WOJ w
	join MIASTA m ON(m.kod_woj =w.kod_woj)
	WHERE (o.id_miasta = m.id_miasta)

	,który pokazuje imiê, nazwisko oraz z jakiego województwa jest dana osoba.

	imie                                               nazwisko                                           nazwa_woj
-------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Jacek                                              Korytkowski                                        MAZOWIECKIE
Adam                                               Szpatu³a                                           POMORSKIE
Piotr                                              Rojman                                             MAZOWIECKIE
Tomasz                                             Wec                                                MAZOWIECKIE
Adam                                               Nawa³ka                                            POMORSKIE
Karol                                              Karolak                                            POMORSKIE
Tymon                                              Szpatu³a                                           POMORSKIE
Samson                                             Szpatu³a                                           MAZOWIECKIE
Patryk                                             Barszcz                                            MAZOWIECKIE
Aleksander                                         Wielki                                             MAZOWIECKIE
Szymon                                             Zapa³a                                             MAZOWIECKIE
Agieszka                                           Renegat                                            POMORSKIE
Roman                                              Paszczak                                           POMORSKIE
Katarzyna                                          Najman                                             POMORSKIE

(14 row(s) affected)
*/

/*  Z4.3 */

/*Wariant 2*/
SELECT m.nazwa ,AVG(e.pensja) AS œrednia
FROM MIASTA m, ETATY e
join FIRMY f ON (e.id_firmy = f.nazwa_skr)
WHERE(f.id_miasta = m.id_miasta)
GROUP BY m.nazwa
/*
nazwa                                              œrednia
-------------------------------------------------- ---------------------
Gdañsk                                             7428,5714
Gdynia                                             7000,00
Radom                                              8500,00
Sopot                                              5250,00
Warszawa                                           11400,00

(5 row(s) affected)
*/


/*Wariant 1*/
SELECT m.nazwa ,AVG(e.pensja) AS œrednia
FROM MIASTA m, ETATY e
join OSOBY o ON (e.id_osoby = o.id_osoby)
WHERE(m.id_miasta = o.id_miasta)
GROUP BY m.nazwa
/*
nazwa                                              œrednia
-------------------------------------------------- ---------------------
Gdañsk                                             10333,3333
Gdynia                                             10875,00
P³ock                                              6000,00
Radom                                              7500,00
Sopot                                              8000,00
Warszawa                                           8666,6666
Wejherowo                                          3500,00
Wêgrów                                             5500,00

(8 row(s) affected)
*/