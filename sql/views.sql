CREATE OR REPLACE VIEW uczen_raport AS
SELECT id_uczen "ID", imie "Imię", nazwisko "Nazwisko", id_klasa "Klasa"
FROM uczen
ORDER BY nazwisko, imie;

CREATE OR REPLACE VIEW nauczyciel_raport AS
SELECT id_nauczyciel "ID", imie "Imię", nazwisko "Nazwisko"
FROM nauczyciel
ORDER BY nazwisko, imie;

CREATE OR REPLACE VIEW klasa_raport AS
SELECT id_klasa "ID", concat(imie, ' ', nazwisko) "Wychowawca"
FROM klasa k
JOIN nauczyciel n ON n.id_nauczyciel=k.id_wychowawca;

CREATE OR REPLACE VIEW ocena_raport AS
SELECT o.id_ocena "ID", u.imie "Imię", u.nazwisko "Nazwisko", p.nazwa "Przedmiot", o.opis "Ocena"
FROM ocena o
JOIN uczen u ON u.id_uczen=o.id_uczen
JOIN przedmiot p ON p.id_przedmiot=o.id_przedmiot
ORDER BY u.nazwisko, u.imie, p.nazwa;

CREATE OR REPLACE VIEW frekwencja_raport AS
SELECT f.id_frekwencja "ID", u.imie "Imię", u.nazwisko "Nazwisko", f.id_lekcja "ID Lekcja", f.opis "Opis"
FROM frekwencja f
JOIN uczen u ON u.id_uczen=f.id_uczen
ORDER BY u.nazwisko, u.imie, f.id_lekcja;

CREATE OR REPLACE VIEW plan_lekcji_raport AS
SELECT pl.id_plan_lekcji "ID", k.id_klasa "Klasa", pl.dzien_tygodnia "Dzień", g.godzina_rozpoczecia "Godz. rozp.", g.godzina_zakonczenia "Godz. zak.", p.nazwa "Nazwa", s.numer "Sala", concat(n.imie, ' ', n.nazwisko) "Nauczyciel"
FROM plan_lekcji pl
JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot
JOIN godzina_lekcyjna g ON g.id_godzina_lekcyjna=pl.id_godzina_lekcyjna
JOIN klasa k ON k.id_klasa=pnk.id_klasa
JOIN sala s ON s.id_sala=pl.id_sala
JOIN nauczyciel n ON n.id_nauczyciel=pnk.id_nauczyciel
ORDER BY k.id_klasa, pl.id_plan_lekcji;

CREATE OR REPLACE VIEW przedmiot_raport AS
SELECT id_przedmiot "ID", nazwa "Przedmiot"
FROM przedmiot 
ORDER BY nazwa;

CREATE OR REPLACE VIEW sala_raport AS
SELECT id_sala "ID", numer "Sala"
FROM sala 
ORDER BY numer;

CREATE OR REPLACE VIEW oplata_raport AS
SELECT o.id_oplata "ID", o.opis "Opis", o.ile_do_zaplacenia "Do zapłaty", o.ile_zostalo_zaplacone "Zapłacono", u.imie "Imię", u.nazwisko "Nazwisko"
FROM oplata o
JOIN uczen u ON u.id_uczen=o.id_uczen
ORDER BY u.nazwisko, u.imie, o.id_oplata;

CREATE OR REPLACE VIEW lekcja_raport AS
SELECT l.id_lekcja "ID", l.temat "Temat", TO_CHAR(l.dzien, 'YYYY-MM-DD') "Dzień", p.nazwa "Przedmiot", pnk.id_klasa "Klasa"
FROM lekcja l
JOIN plan_lekcji pl ON pl.id_plan_lekcji=l.id_plan_lekcji
JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
JOIN przedmiot p ON pnk.id_przedmiot=p.id_przedmiot
ORDER BY pnk.id_klasa, p.nazwa, l.dzien;

CREATE OR REPLACE VIEW godzina_lekcyjna_raport AS
SELECT id_godzina_lekcyjna "ID", godzina_rozpoczecia "Godz. rozp.", godzina_zakonczenia "Godz. zak."
FROM godzina_lekcyjna;

CREATE OR REPLACE VIEW przedmiot_nauczany_w_klasie_raport AS
SELECT id_przedmiot_nauczany_w_klasie "ID", id_klasa "Klasa", concat(n.imie, ' ', n.nazwisko) "Nauczyciel", p.nazwa "Przedmiot"
FROM przedmiot_nauczany_w_klasie pnk
JOIN nauczyciel n ON n.id_nauczyciel=pnk.id_nauczyciel
JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot
ORDER BY pnk.id_klasa, p.nazwa;