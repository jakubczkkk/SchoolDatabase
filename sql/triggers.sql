DROP TRIGGER insert_lekcja ON lekcja;

CREATE OR REPLACE FUNCTION dodaj_frekwencje()
RETURNS TRIGGER
AS $$ DECLARE
    ik INTEGER;
    uczen_record record;
BEGIN
    SELECT k.id_klasa INTO ik FROM klasa k
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_klasa=k.id_klasa
    JOIN plan_lekcji pl ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pl.id_zajecia=NEW.id_zajecia;
    FOR uczen_record IN SELECT * FROM uczen WHERE id_klasa = '1A'
    LOOP
        INSERT INTO frekwencja(id_uczen, id_lekcja, opis) VALUES (uczen_record.id_uczen, NEW.id_lekcja, 'nieobecny');
    END LOOP;
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER insert_lekcja
    AFTER INSERT ON lekcja
    FOR EACH ROW
    EXECUTE PROCEDURE dodaj_frekwencje();

INSERT INTO lekcja (id_zajecia, dzien, temat) VALUES (1, '10-01-2020', 'Test');