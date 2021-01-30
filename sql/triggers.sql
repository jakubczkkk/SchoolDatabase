--------------------------
-- TRIGERRY PRZY INSERT --
--------------------------



CREATE OR REPLACE FUNCTION dodaj_lekcje()
RETURNS TRIGGER
AS $$ DECLARE
    ik TEXT;
    uczen_record record;
    dt INTEGER;
    pl INTEGER;
BEGIN
    SELECT EXTRACT(dow from NEW.dzien) INTO dt;
    SELECT CASE
        WHEN dzien_tygodnia='Poniedziałek' THEN 1
        WHEN dzien_tygodnia='Wtorek' THEN 2
        WHEN dzien_tygodnia='Środa' THEN 3
        WHEN dzien_tygodnia='Czwartek' THEN 4
        WHEN dzien_tygodnia='Piątek' THEN 5
    END "temp" INTO pl
    FROM plan_lekcji WHERE id_plan_lekcji=NEW.id_plan_lekcji;
    IF dt<>pl THEN
        RAISE EXCEPTION 'Na ten dzień nie są zaplanowane zajęcia';
    END IF;

    SELECT k.id_klasa INTO ik FROM klasa k
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_klasa=k.id_klasa
    JOIN plan_lekcji pl ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pl.id_plan_lekcji=NEW.id_plan_lekcji;
    FOR uczen_record IN SELECT * FROM uczen WHERE id_klasa = ik LOOP
        INSERT INTO frekwencja(id_uczen, id_lekcja, opis) VALUES (uczen_record.id_uczen, NEW.id_lekcja, 'Obecność');
    END LOOP;

    RETURN NEW;
    
END $$ LANGUAGE plpgsql;

CREATE TRIGGER insert_lekcja
    AFTER INSERT ON lekcja
    FOR EACH ROW
    EXECUTE PROCEDURE dodaj_lekcje();



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
    IF NEW.ile_do_zaplacenia <= 0 THEN
        RAISE EXCEPTION 'Podaj liczbę większą od zera';
    ELSIF NEW.id_uczen=0 THEN
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



--------------------------
-- TRIGERRY PRZY UPDATE --
--------------------------


CREATE OR REPLACE FUNCTION zmien_ocene()
RETURNS TRIGGER
AS $$ BEGIN
    IF (
    NEW.opis <> 5 AND NEW.opis <> 4.5 AND NEW.opis <> 4 AND NEW.opis <> 3.5
    AND NEW.opis <> 3 AND NEW.opis <> 2.5 AND NEW.opis <> 2 AND NEW.opis <> 1
    ) THEN
        RAISE EXCEPTION 'Niepoprawna ocena (można użyć 5, 4.5, 4, 3.5, 3, 2.5, 2, 1)';
    END IF;

    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER update_ocena
    BEFORE UPDATE ON ocena
    FOR EACH ROW
    EXECUTE PROCEDURE zmien_ocene();



CREATE OR REPLACE FUNCTION dodaj_wplate()
RETURNS TRIGGER
AS $$ DECLARE
    uczen_record record;
BEGIN
    IF NEW.ile_zostalo_zaplacone <= 0 THEN
        RAISE EXCEPTION 'Podaj liczbę większą od zera.';
    ELSIF NEW.ile_zostalo_zaplacone > (OLD.ile_do_zaplacenia - OLD.ile_zostalo_zaplacone) THEN
        RAISE EXCEPTION 'Za dużo! Wystarczy wpłacić %', (OLD.ile_do_zaplacenia - OLD.ile_zostalo_zaplacone);
    END IF;
    NEW.ile_zostalo_zaplacone = NEW.ile_zostalo_zaplacone + OLD.ile_zostalo_zaplacone;
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER update_oplata
    BEFORE UPDATE ON oplata
    FOR EACH ROW
    EXECUTE PROCEDURE dodaj_wplate();



CREATE OR REPLACE FUNCTION przenies_lekcje()
RETURNS TRIGGER
AS $$ DECLARE
    idn INTEGER;
    idk TEXT;
BEGIN

    SELECT pnk.id_nauczyciel, pnk.id_klasa INTO idn, idk
    FROM plan_lekcji pl
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pl.id_plan_lekcji=NEW.id_plan_lekcji;

    IF (SELECT EXISTS (
    SELECT 1 FROM plan_lekcji pl
    WHERE pl.id_sala=NEW.id_sala
    AND pl.dzien_tygodnia=NEW.dzien_tygodnia
    AND pl.id_godzina_lekcyjna=NEW.id_godzina_lekcyjna)) THEN
        RAISE EXCEPTION 'Sala jest zajęta w tym terminie';
    END IF;

    IF (SELECT EXISTS (
    SELECT 1 FROM plan_lekcji pl
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pnk.id_nauczyciel=idn AND pl.dzien_tygodnia=NEW.dzien_tygodnia AND pl.id_godzina_lekcyjna=NEW.id_godzina_lekcyjna
    )) THEN
        RAISE EXCEPTION 'Nauczyciel ma w tym czasie zajęcia';
    END IF;

    IF (SELECT EXISTS (
    SELECT 1 FROM plan_lekcji pl
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pnk.id_klasa=idk AND pl.dzien_tygodnia=NEW.dzien_tygodnia AND pl.id_godzina_lekcyjna=NEW.id_godzina_lekcyjna
    )) THEN
        RAISE EXCEPTION 'Klasa ma już w tym czasie zajęcia';
    END IF;
    RETURN NEW;
    
END $$ LANGUAGE plpgsql;

CREATE TRIGGER update_plan_lekcji
    BEFORE UPDATE ON plan_lekcji
    FOR EACH ROW
    EXECUTE PROCEDURE przenies_lekcje();



--------------------------
-- TRIGERRY PRZY DELETE --
--------------------------



CREATE OR REPLACE FUNCTION usun_ucznia()
RETURNS TRIGGER
AS $$ BEGIN
    DELETE FROM ocena o WHERE o.id_uczen=OLD.id_uczen;
    DELETE FROM oplata o WHERE o.id_uczen=OLD.id_uczen;
    DELETE FROM frekwencja f WHERE f.id_uczen=OLD.id_uczen;
    RETURN OLD;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER usun_ucznia
    BEFORE DELETE ON uczen
    FOR EACH ROW
    EXECUTE PROCEDURE usun_ucznia();



CREATE OR REPLACE FUNCTION usun_nauczyciela()
RETURNS TRIGGER
AS $$ BEGIN
    IF (SELECT EXISTS (SELECT 1 FROM klasa WHERE id_wychowawca=OLD.id_nauczyciel LIMIT 1)) THEN
        RAISE EXCEPTION 'Nie można usunąć nauczyciela, który jest wychowawcą';
    END IF;
    IF (SELECT EXISTS (SELECT 1 FROM przedmiot_nauczany_w_klasie pnk WHERE pnk.id_nauczyciel=OLD.id_nauczyciel LIMIT 1)) THEN
        RAISE EXCEPTION 'Nie można usunąć nauczyciela, który prowadzi zajęcia';
    END IF;
    RETURN OLD;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER usun_nauczyciela
    BEFORE DELETE ON nauczyciel
    FOR EACH ROW
    EXECUTE PROCEDURE usun_nauczyciela();