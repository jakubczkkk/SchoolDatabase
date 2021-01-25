CREATE OR REPLACE FUNCTION plan_lekcji_klasy(TEXT)
RETURNS TABLE (godzina INTEGER, Poniedziałek TEXT, Wtorek TEXT, Środa TEXT, Czwartek TEXT, Piątek TEXT )
AS $$ BEGIN
RETURN QUERY SELECT g.id_godzina_lekcyjna, t1.nazwa, t2.nazwa, t3.nazwa, t4.nazwa, t5.nazwa
FROM godzina_lekcyjna g
LEFT JOIN (SELECT p.nazwa, pl.godzina FROM plan_lekcji pl JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot WHERE pnk.id_klasa = $1 AND pl.dzien_tygodnia = 'Poniedziałek') t1 ON t1.godzina = g.id_godzina_lekcyjna
LEFT JOIN (SELECT p.nazwa, pl.godzina FROM plan_lekcji pl JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot WHERE pnk.id_klasa = $1 AND pl.dzien_tygodnia = 'Wtorek') t2 ON t2.godzina = g.id_godzina_lekcyjna
LEFT JOIN (SELECT p.nazwa, pl.godzina FROM plan_lekcji pl JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot WHERE pnk.id_klasa = $1 AND pl.dzien_tygodnia = 'Środa') t3 ON t3.godzina = g.id_godzina_lekcyjna
LEFT JOIN (SELECT p.nazwa, pl.godzina FROM plan_lekcji pl JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot WHERE pnk.id_klasa = $1 AND pl.dzien_tygodnia = 'Czwartek') t4 ON t4.godzina = g.id_godzina_lekcyjna
LEFT JOIN (SELECT p.nazwa, pl.godzina FROM plan_lekcji pl JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=pl.id_przedmiot_nauczany_w_klasie JOIN przedmiot p ON p.id_przedmiot=pnk.id_przedmiot WHERE pnk.id_klasa = $1 AND pl.dzien_tygodnia = 'Piątek') t5 ON t5.godzina = g.id_godzina_lekcyjna;
END $$ LANGUAGE plpgsql;