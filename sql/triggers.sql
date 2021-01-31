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

    -- sprawdzamy czy w tablicy plan_lekcji istnieje
    -- odpowiedni klucz
    IF (SELECT NOT EXISTS (SELECT 1 FROM plan_lekcji
    WHERE id_plan_lekcji = NEW.id_plan_lekcji LIMIT 1)) THEN
        RAISE EXCEPTION 'Nie ma ucznia o podanym ID';
    END IF;

    -- najpierw sprawdzamy jaki jest dzień tygodnia w dniu
    -- w którym tworzona jest nowa lekcja
    SELECT EXTRACT(dow from NEW.dzien) INTO dt;
    SELECT CASE
        WHEN dzien_tygodnia='Poniedziałek' THEN 1
        WHEN dzien_tygodnia='Wtorek' THEN 2
        WHEN dzien_tygodnia='Środa' THEN 3
        WHEN dzien_tygodnia='Czwartek' THEN 4
        WHEN dzien_tygodnia='Piątek' THEN 5
    END "temp" INTO pl
    FROM plan_lekcji WHERE id_plan_lekcji=NEW.id_plan_lekcji;

    -- jeśli dzień tygodnia nie zgadza się z planem lekcji,
    -- lekcja nie zostaje utworzona
    IF dt<>pl THEN
        RAISE EXCEPTION 'Na ten dzień nie są zaplanowane zajęcia';
    END IF;

    -- jeśli możemy utworzyć lekcję, to do tablicy frekwencja
    -- wrzucamy listę wszystkich uczniów z klasy, której dotyczy lekcja
    -- i ustawiamy domyślnie, że wszyscy są obecni
    SELECT k.id_klasa INTO ik FROM klasa k
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_klasa=k.id_klasa
    JOIN plan_lekcji pl ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pl.id_plan_lekcji=NEW.id_plan_lekcji;
    FOR uczen_record IN SELECT * FROM uczen WHERE id_klasa = ik LOOP
        INSERT INTO frekwencja(id_uczen, id_lekcja, opis) VALUES
        (uczen_record.id_uczen, NEW.id_lekcja, 'Obecność');
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
    -- możemy dodać ucznia tylko do klasy, która istnieje
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

    -- sprawdzamy czy istnieje uczeń, któremy chcemy dodać ocenę
    IF (SELECT NOT EXISTS (SELECT 1 FROM uczen WHERE id_uczen = NEW.id_uczen LIMIT 1)) THEN
        RAISE EXCEPTION 'Nie ma ucznia o podanym ID';
    END IF;

    -- sprawdzamy czy przedmiotu z którego wstawiamy ocenę jest dostępny
    -- w klasie ucznia
    SELECT u.id_klasa INTO ik FROM uczen u WHERE u.id_uczen=NEW.id_uczen;
    IF (SELECT NOT EXISTS (SELECT 1 FROM
    (SELECT pnk.id_przedmiot FROM przedmiot_nauczany_w_klasie pnk WHERE pnk.id_klasa=ik) t
    WHERE t.id_przedmiot=NEW.id_przedmiot LIMIT 1)) THEN
        RAISE EXCEPTION 'Przedmiot o podanym ID nie jest nauczany w klasie ucznia';
    END IF;

    -- na końcu sprawdzamy czy wpisana ocena jest dostępna
    -- (5, 4.5, 4, 3.5, 3, 2.5, 2, 1)
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

    -- sprawdzamy czy kwota do zapłaty jest liczbą dodatnią
    IF NEW.ile_do_zaplacenia <= 0 THEN
        RAISE EXCEPTION 'Podaj liczbę większą od zera';

    -- jeśli tak to najpierw sprawdzamy przypadek kiedy wpisano 
    -- ID ucznia równe 0
    ELSIF NEW.id_uczen=0 THEN
        -- dodajemy wszystkim uczniom taką samą opłatę
        FOR uczen_record IN SELECT id_uczen FROM uczen LOOP
            INSERT INTO oplata(id_uczen, ile_do_zaplacenia, opis)
            VALUES (uczen_record.id_uczen, NEW.ile_do_zaplacenia, NEW.opis);
        END LOOP;
        RETURN NULL;
    -- jeśli nie to sprawdzamy czy istnieje uczeń, któremu dajemy opłatę
    -- i ustawiamy że na razie zapłacono 0
    ELSE
        IF (SELECT NOT EXISTS (SELECT 1 FROM uczen WHERE id_uczen = NEW.id_uczen LIMIT 1)) THEN
            RAISE EXCEPTION 'Nie ma ucznia o podanym ID';
        END IF;
        NEW.ile_do_zaplacenia = NEW.ile_do_zaplacenia;
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

    -- sprawdzamy czy nowa ocena należy do zbioru prawidłowych ocen
    -- rozpoznawanych przez bazę danych (patrz dodaj_ocene())
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



CREATE OR REPLACE FUNCTION zmien_wychowawce()
RETURNS TRIGGER
AS $$ BEGIN

    -- najpierw sprawdzamy czy wogóle istnieje nauczyciel o takim id
    IF (SELECT NOT EXISTS (SELECT 1 FROM nauczyciel WHERE id_nauczyciel = NEW.id_wychowawca LIMIT 1)) THEN
        RAISE EXCEPTION 'Nie ma takiego nauczyciela';
    END IF;

    -- później sprawdzamy czy nauczyciel jest już wychowawcą innej klasy
    IF (SELECT EXISTS (SELECT 1 FROM klasa WHERE id_wychowawca = NEW.id_wychowawca LIMIT 1)) THEN
        RAISE EXCEPTION 'Nauczyciel jest już wychowawcą innej klasy';
    END IF;

    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER update_klasa
    BEFORE UPDATE ON klasa
    FOR EACH ROW
    EXECUTE PROCEDURE zmien_wychowawce();



CREATE OR REPLACE FUNCTION zmien_nauczyciela()
RETURNS TRIGGER
AS $$ DECLARE
    lekcje_nauczyciela record;
    lekcje_klasy record;
BEGIN

    -- zaczynamy od sprawdzenia czy istnieje nauczyciel o szukanym id
    IF (SELECT NOT EXISTS (SELECT 1 FROM nauczyciel WHERE id_nauczyciel = NEW.id_nauczyciel LIMIT 1)) THEN
        RAISE EXCEPTION 'Nie ma takiego nauczyciela';
    END IF;

    -- jeśli tak to zbieramy informacje o wszystkich zajęciach prowadzonych
    -- przez tego nauczyciela
    FOR lekcje_nauczyciela IN
    SELECT pl.id_godzina_lekcyjna, pl.dzien_tygodnia 
    FROM plan_lekcji pl
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pnk.id_nauczyciel=NEW.id_nauczyciel 
    LOOP
        -- następnie porównujemy sprawdzamy wszystkie nowe zajęcia, którego
        -- nauczyciel miałby przejąć
        FOR lekcje_klasy IN
        SELECT pl2.id_godzina_lekcyjna, pl2.dzien_tygodnia
        FROM plan_lekcji pl2
        WHERE pl2.id_przedmiot_nauczany_w_klasie=OLD.id_przedmiot_nauczany_w_klasie
        LOOP
            -- i sprawdzamy czy dochodzi do kolizji
            -- jeśli tak, to nie można zmienić nauczyciela
            IF lekcje_nauczyciela.id_godzina_lekcyjna=lekcje_klasy.id_godzina_lekcyjna
            AND lekcje_nauczyciela.dzien_tygodnia=lekcje_klasy.dzien_tygodnia
            THEN
                RAISE EXCEPTION 'Nowy nauczyciel ma już w tym czasie zajęcia.';
            END IF;
        END LOOP;
    END LOOP;
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER update_przedmiot_nauczany_w_klasie
    BEFORE UPDATE ON przedmiot_nauczany_w_klasie
    FOR EACH ROW
    EXECUTE PROCEDURE zmien_nauczyciela();



CREATE OR REPLACE FUNCTION dodaj_wplate()
RETURNS TRIGGER
AS $$ DECLARE
    uczen_record record;
BEGIN

    -- najpierw sprawdzamy czy opłata nie jest już przypadkiem opłacona
    IF OLD.ile_do_zaplacenia=OLD.ile_zostalo_zaplacone THEN
        RAISE EXCEPTION 'Opłata została już pokryta wcześniej';
    END IF;

    -- sprawdzamy czy podano liczbę dodatnią
    IF NEW.ile_zostalo_zaplacone <= 0 THEN
        RAISE EXCEPTION 'Podaj liczbę większą od zera.';
    -- sprawdzamy czy nie podano więcej pieniędzy niż potrzeba
    ELSIF NEW.ile_zostalo_zaplacone > (OLD.ile_do_zaplacenia - OLD.ile_zostalo_zaplacone) THEN
        RAISE EXCEPTION 'Za dużo! Wystarczy wpłacić %', (OLD.ile_do_zaplacenia - OLD.ile_zostalo_zaplacone);
    END IF;

    -- jeśli wszystko jest ok, to dodajemy wpłaconą wartość do ile_zostalo_zaplacone
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

    -- wyciągamy najpierw informacje o nauczycielu i klasie
    SELECT pnk.id_nauczyciel, pnk.id_klasa INTO idn, idk
    FROM plan_lekcji pl
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pl.id_plan_lekcji=NEW.id_plan_lekcji;

    -- sprawdzamy czy w tym terminie jest już zajęta nowa sala lekcyjna
    IF (SELECT EXISTS (
    SELECT 1 FROM plan_lekcji pl
    WHERE pl.id_sala=NEW.id_sala
    AND pl.dzien_tygodnia=NEW.dzien_tygodnia
    AND pl.id_godzina_lekcyjna=NEW.id_godzina_lekcyjna
    AND pl.id_plan_lekcji<>NEW.id_plan_lekcji)) THEN
        RAISE EXCEPTION 'Sala jest zajęta w tym terminie';
    END IF;

    -- sprawdzamy czy nauczyciel ma w tym czasie inne zajęcia
    IF (SELECT EXISTS (
    SELECT 1 FROM plan_lekcji pl
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pnk.id_nauczyciel=idn 
    AND pl.dzien_tygodnia=NEW.dzien_tygodnia 
    AND pl.id_godzina_lekcyjna=NEW.id_godzina_lekcyjna
    AND pl.id_plan_lekcji<>NEW.id_plan_lekcji)) THEN
        RAISE EXCEPTION 'Nauczyciel ma w tym czasie zajęcia';
    END IF;

    -- sprawdzamy czy klasa ma w tym czasie inne zajęcia
    IF (SELECT EXISTS (
    SELECT 1 FROM plan_lekcji pl
    JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie
    WHERE pnk.id_klasa=idk 
    AND pl.dzien_tygodnia=NEW.dzien_tygodnia 
    AND pl.id_godzina_lekcyjna=NEW.id_godzina_lekcyjna
    AND pl.id_plan_lekcji<>NEW.id_plan_lekcji)) THEN
        RAISE EXCEPTION 'Klasa ma już w tym czasie zajęcia';
    END IF;

    -- jeśli nie ma przeszkód, to dokonujemy zamiany
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
    -- usuwamy najpierw wszystkie informacje o uczniu na temat
    -- ocen, oplat i frekwencji
    DELETE FROM ocena o WHERE o.id_uczen=OLD.id_uczen;
    DELETE FROM oplata o WHERE o.id_uczen=OLD.id_uczen;
    DELETE FROM frekwencja f WHERE f.id_uczen=OLD.id_uczen;
    RETURN OLD;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER delete_uczen
    BEFORE DELETE ON uczen
    FOR EACH ROW
    EXECUTE PROCEDURE usun_ucznia();



CREATE OR REPLACE FUNCTION usun_nauczyciela()
RETURNS TRIGGER
AS $$ BEGIN

    -- sprawdzamy czy nauczyciel jest wychowawcą jakiejś klasy
    IF (SELECT EXISTS (SELECT 1 FROM klasa WHERE id_wychowawca=OLD.id_nauczyciel LIMIT 1)) THEN
        RAISE EXCEPTION 'Nie można usunąć nauczyciela, który jest wychowawcą';
    END IF;

    -- sprawdzamy czy nauczyciel prowadzi jakieś lekcje
    IF (SELECT EXISTS (SELECT 1 FROM przedmiot_nauczany_w_klasie pnk WHERE pnk.id_nauczyciel=OLD.id_nauczyciel LIMIT 1)) THEN
        RAISE EXCEPTION 'Nie można usunąć nauczyciela, który prowadzi zajęcia';
    END IF;

    RETURN OLD;

END $$ LANGUAGE plpgsql;

CREATE TRIGGER delete_nauczyciel
    BEFORE DELETE ON nauczyciel
    FOR EACH ROW
    EXECUTE PROCEDURE usun_nauczyciela();



CREATE OR REPLACE FUNCTION usun_lekcje()
RETURNS TRIGGER
AS $$ BEGIN
    -- usuwamy informacje o frekwencji na temat lekcji, którą
    -- chcemy usunąć
    DELETE FROM frekwencja f WHERE f.id_lekcja=OLD.id_lekcja;
    RETURN OLD;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER delete_lekcja
    BEFORE DELETE ON lekcja
    FOR EACH ROW
    EXECUTE PROCEDURE usun_lekcje();