CREATE OR REPLACE VIEW uczen_raport AS
SELECT id_uczen, imie, nazwisko, id_klasa
FROM uczen
ORDER BY id_klasa, nazwisko, imie;

CREATE OR REPLACE VIEW nauczyciel_raport AS
SELECT id_nauczyciel, imie, nazwisko
FROM nauczyciel
ORDER BY nazwisko, imie;

CREATE OR REPLACE VIEW klasa_raport AS
SELECT id_klasa, concat(imie, ' ', nazwisko) wychowawca
FROM klasa k
JOIN nauczyciel n ON n.id_nauczyciel=k.id_wychowawca;

CREATE OR REPLACE VIEW ocena_raport AS
SELECT o.id_ocena, u.imie, u.nazwisko, p.nazwa, o.opis FROM ocena o
JOIN uczen u ON u.id_uczen=o.id_uczen
JOIN przedmiot p ON p.id_przedmiot=o.id_przedmiot;

CREATE OR REPLACE VIEW frekwencja_raport AS
SELECT f.id_frekwencja, u.imie, u.nazwisko, f.id_lekcja, f.opis FROM frekwencja f
JOIN uczen u ON u.id_uczen=f.id_uczen;

CREATE OR REPLACE VIEW plan_lekcji_raport AS
SELECT pl.id_zajecia, k.id_klasa, pl.dzien_tygodnia, g.godzina_rozpoczecia, g.godzina_zakonczenia, p.nazwa, s.numer, concat(n.imie, ' ', n.nazwisko) nauczyciel FROM plan_lekcji pl
JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot
JOIN godzina_lekcyjna g ON g.id_godzina_lekcyjna=pl.godzina
JOIN klasa k ON k.id_klasa=pnk.id_klasa
JOIN sala s ON s.id_sala=pl.id_sala
JOIN nauczyciel n ON n.id_nauczyciel=pnk.id_nauczyciel;

CREATE OR REPLACE VIEW przedmiot_raport AS
SELECT id_przedmiot, nazwa FROM przedmiot ORDER BY nazwa;

CREATE OR REPLACE VIEW sala_raport AS
SELECT id_sala, numer FROM sala ORDER BY numer;

CREATE OR REPLACE VIEW oplata_raport AS
SELECT o.id_oplata, o.opis, o.ile_do_zaplacenia, o.ile_zostalo_zaplacone, u.imie, u.nazwisko
FROM oplata o
JOIN uczen u ON u.id_uczen=o.id_oplata;

CREATE OR REPLACE VIEW lekcja_raport AS
SELECT l.id_lekcja, l.temat, l.dzien, p.nazwa, pnk.id_klasa
FROM lekcja l
JOIN plan_lekcji pl ON pl.id_zajecia=l.id_zajecia
JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
JOIN przedmiot p ON pnk.id_przedmiot=p.id_przedmiot;

CREATE OR REPLACE VIEW godzina_lekcyjna_raport AS
SELECT id_godzina_lekcyjna, godzina_rozpoczecia, godzina_zakonczenia
FROM godzina_lekcyjna;

CREATE OR REPLACE VIEW przedmiot_nauczany_w_klasie_raport AS
SELECT id_przedmiot_nauczany_w_klasie, id_klasa, concat(n.imie, ' ', n.nazwisko) nauczyciel, p.nazwa
FROM przedmiot_nauczany_w_klasie pnk
JOIN nauczyciel n ON n.id_nauczyciel=pnk.id_nauczyciel
JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot;