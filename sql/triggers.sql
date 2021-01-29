CREATE OR REPLACE FUNCTION dodaj_frekwencje()
RETURNS TRIGGER
AS $$ DECLARE
    ik TEXT;
    uczen_record record;
BEGIN
    SELECT k.id_klasa INTO ik FROM klasa k
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_klasa=k.id_klasa
    JOIN plan_lekcji pl ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pl.id_plan_lekcji=NEW.id_plan_lekcji;
    FOR uczen_record IN SELECT * FROM uczen WHERE id_klasa = ik
    LOOP
        INSERT INTO frekwencja(id_uczen, id_lekcja, opis) VALUES (uczen_record.id_uczen, NEW.id_lekcja, 'Obecność');
    END LOOP;
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER insert_lekcja
    AFTER INSERT ON lekcja
    FOR EACH ROW
    EXECUTE PROCEDURE dodaj_frekwencje();

CREATE OR REPLACE FUNCTION dodaj_ucznia()
RETURNS TRIGGER
AS $$ 
BEGIN
    IF (SELECT NOT EXISTS (SELECT 1 FROM klasa WHERE id_klasa = NEW.id_klasa LIMIT 1)) THEN
        RAISE EXCEPTION 'Nie ma takiej klasy';
    END IF;
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER insert_uczen
    BEFORE INSERT ON uczen
    FOR EACH ROW
    EXECUTE PROCEDURE dodaj_ucznia();

CREATE OR REPLACE FUNCTION dodaj_ocene()
RETURNS TRIGGER
AS $$ DECLARE
    ik TEXT;
BEGIN
    SELECT u.id_klasa INTO ik FROM uczen u WHERE u.id_uczen=NEW.id_uczen;

    IF (SELECT NOT EXISTS (SELECT 1 FROM uczen WHERE id_uczen = NEW.id_uczen LIMIT 1)) THEN
        RAISE EXCEPTION 'Nie ma ucznia o podanym ID';
    END IF;

    IF (SELECT NOT EXISTS (SELECT 1 FROM
    (SELECT pnk.id_przedmiot FROM przedmiot_nauczany_w_klasie pnk WHERE pnk.id_klasa=ik) t
    WHERE t.id_przedmiot=NEW.id_przedmiot LIMIT 1)) THEN
        RAISE EXCEPTION 'Przedmiot o podanym ID nie jest nauczany w klasie ucznia';
    END IF;

    IF (
    NEW.opis <> 5 AND NEW.opis <> 4.5 AND NEW.opis <> 4 AND NEW.opis <> 3.5
    AND NEW.opis <> 3 AND NEW.opis <> 2.5 AND NEW.opis <> 2 AND NEW.opis <> 1
    ) THEN
        RAISE EXCEPTION 'Niepoprawna ocena (można użyć 5, 4.5, 4, 3.5, 3, 2.5, 2, 1)';
    END IF;

    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER insert_ocena
    BEFORE INSERT ON ocena
    FOR EACH ROW
    EXECUTE PROCEDURE dodaj_ocene();

CREATE OR REPLACE FUNCTION dodaj_oplate()
RETURNS TRIGGER
AS $$ DECLARE
    uczen_record record;
BEGIN
    IF NEW.id_uczen=0 THEN
        FOR uczen_record IN SELECT id_uczen FROM uczen LOOP
            INSERT INTO oplata(id_uczen, ile_do_zaplacenia, opis)
            VALUES (uczen_record.id_uczen, NEW.ile_do_zaplacenia, NEW.opis);
        END LOOP;
        RETURN NULL;
    ELSE
        NEW.ile_zostalo_zaplacone = 0;
        RETURN NEW;
    END IF;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER insert_oplata
    BEFORE INSERT ON oplata
    FOR EACH ROW
    EXECUTE PROCEDURE dodaj_oplate();