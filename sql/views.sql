CREATE VIEW uczen_raport AS
SELECT id_uczen, imie, nazwisko, id_klasa
FROM uczen
ORDER BY id_klasa, nazwisko, imie;

CREATE VIEW nauczyciel_raport AS
SELECT id_nauczyciel, imie, nazwisko
FROM nauczyciel
ORDER BY nazwisko, imie;

CREATE VIEW klasa_raport AS
SELECT id_klasa, concat(imie, ' ', nazwisko) wychowawca
FROM klasa k
JOIN nauczyciel n ON n.id_nauczyciel=k.id_wychowawca