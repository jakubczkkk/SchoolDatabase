CREATE OR REPLACE FUNCTION plan_lekcji_klasy(TEXT)
RETURNS TABLE (Godzina INTEGER, Poniedziałek TEXT, Wtorek TEXT, Środa TEXT, Czwartek TEXT, Piątek TEXT )
AS $$ BEGIN
    IF (SELECT NOT EXISTS (SELECT 1 FROM klasa WHERE id_klasa=$1)) THEN
        RAISE EXCEPTION 'Nie ma takiej klasy';
    END IF;
    RETURN QUERY 
    SELECT g.id_godzina_lekcyjna, 
    CASE WHEN t1.nazwa IS NULL THEN '' ELSE t1.nazwa END, 
    CASE WHEN t2.nazwa IS NULL THEN '' ELSE t2.nazwa END, 
    CASE WHEN t3.nazwa IS NULL THEN '' ELSE t3.nazwa END, 
    CASE WHEN t4.nazwa IS NULL THEN '' ELSE t4.nazwa END, 
    CASE WHEN t5.nazwa IS NULL THEN '' ELSE t5.nazwa END 
    FROM godzina_lekcyjna g
    LEFT JOIN (SELECT p.nazwa, pl.id_godzina_lekcyjna FROM plan_lekcji pl JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot WHERE pnk.id_klasa = $1 AND pl.dzien_tygodnia = 'Poniedziałek') t1 ON t1.id_godzina_lekcyjna = g.id_godzina_lekcyjna
    LEFT JOIN (SELECT p.nazwa, pl.id_godzina_lekcyjna FROM plan_lekcji pl JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot WHERE pnk.id_klasa = $1 AND pl.dzien_tygodnia = 'Wtorek') t2 ON t2.id_godzina_lekcyjna = g.id_godzina_lekcyjna
    LEFT JOIN (SELECT p.nazwa, pl.id_godzina_lekcyjna FROM plan_lekcji pl JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot WHERE pnk.id_klasa = $1 AND pl.dzien_tygodnia = 'Środa') t3 ON t3.id_godzina_lekcyjna = g.id_godzina_lekcyjna
    LEFT JOIN (SELECT p.nazwa, pl.id_godzina_lekcyjna FROM plan_lekcji pl JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot WHERE pnk.id_klasa = $1 AND pl.dzien_tygodnia = 'Czwartek') t4 ON t4.id_godzina_lekcyjna = g.id_godzina_lekcyjna
    LEFT JOIN (SELECT p.nazwa, pl.id_godzina_lekcyjna FROM plan_lekcji pl JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot WHERE pnk.id_klasa = $1 AND pl.dzien_tygodnia = 'Piątek') t5 ON t5.id_godzina_lekcyjna= g.id_godzina_lekcyjna;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION oceny_ucznia(INTEGER)
RETURNS TABLE ("Przedmiot" TEXT, "Średnia" TEXT, "Ocena końcowa" INTEGER)
AS $$ BEGIN
    RETURN QUERY
    SELECT p.nazwa "Przedmiot", TO_CHAR(AVG(o.opis), 'FM999999999.00') "Średnia", 
    CASE
    WHEN AVG(o.opis) >= 4.75 THEN 5
    WHEN AVG(o.opis) >= 3.75 THEN 4
    WHEN AVG(o.opis) >= 2.75 THEN 3
    WHEN AVG(o.opis) >= 2 THEN 2
    ELSE 1
    END "Ocena końcowa"
    FROM ocena o 
    JOIN przedmiot p ON p.id_przedmiot=o.id_przedmiot
    WHERE o.id_uczen=$1
    GROUP BY p.nazwa;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION info_frekwencja(INTEGER)
RETURNS TABLE ("Wszystkie lekcje" BIGINT, "Obecność" BIGINT, "Nieob. uspr." BIGINT, "Nieob. nieuspr." BIGINT, "Frekwencja" TEXT)
AS $$ BEGIN
    RETURN QUERY
    SELECT
    (SELECT COUNT(*) FROM frekwencja WHERE id_uczen=$1) "Wszystkie lekcje",
    (SELECT COUNT(*) FROM frekwencja WHERE id_uczen=$1 AND opis='Obecność') "Obecność",
    (SELECT COUNT(*) FROM frekwencja WHERE id_uczen=$1 AND opis='Nieobecność usprawiedliwiona') "Nieob. uspr.",
    (SELECT COUNT(*) FROM frekwencja WHERE id_uczen=$1 AND opis='Nieobecność nieusprawiedliwiona') "Nieob. nieuspr.",
    TO_CHAR((SELECT CAST(COUNT(*) AS FLOAT) FROM frekwencja WHERE id_uczen=$1 AND opis='Obecność') / (SELECT CAST(COUNT(*) AS FLOAT) FROM frekwencja WHERE id_uczen=$1) * 100, '999D99%') "Frekwencja";
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION info_oplata(INTEGER)
RETURNS TABLE ("ID Opłaty" INTEGER, "Ile brakuje" float8, "Opis" TEXT)
AS $$ BEGIN
    RETURN QUERY
    SELECT id_oplata "ID Opłaty", ile_do_zaplacenia - ile_zostalo_zaplacone "Ile brakuje", opis "Opis" FROM oplata WHERE id_uczen=$1 AND ile_do_zaplacenia-ile_zostalo_zaplacone > 0;
END $$ LANGUAGE plpgsql;