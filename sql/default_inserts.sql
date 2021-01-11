INSERT INTO nauczyciel (imie, nazwisko) VALUES
  ('Paulina', 'Sobczak'),
  ('Henryk', 'Bąk'),
  ('Kazimierz', 'Górski'),
  ('Irena', 'Wójcik'),
  ('Marian', 'Chmielewski'),
  ('Małgorzata', 'Jaworska'),
  ('Ewa', 'Duda'),
  ('Jakub', 'Malinowski'),
  ('Jadwiga', 'Brzezińska'),
  ('Roman', 'Sawicki');

INSERT INTO klasa (nazwa, id_wychowawca) VALUES
  ('1A', 5),
  ('1B', 4),
  ('2A', 3),
  ('2B', 7),
  ('3A', 8),
  ('3B', 1);

INSERT INTO uczen (id_klasa, imie, nazwisko) VALUES
  (1, 'Marcin', 'Szymczak'),
  (1, 'Joanna', 'Baranowska'),
  (1, 'Maciej', 'Szczepański'),
  (1, 'Czesław', 'Wróbel'),
  (1, 'Grażyna', 'Górska'),
  (1, 'Wanda', 'Krawczyk'),
  (1, 'Renata', 'Urbańska'),
  (1, 'Wiesława', 'Tomaszewska'),
  (1, 'Bożena', 'Baranowska'),
  (1, 'Ewelina', 'Malinowska'),
  (1, 'Anna', 'Krajewska'),
  (1, 'Mieczysław', 'Zając'),
  (1, 'Wiesław', 'Przybylski'),
  (1, 'Dorota', 'Tomaszewska'),
  (1, 'Jerzy', 'Wróblewski'),
  (2, 'Magdalena', 'Adamczyk'),
  (2, 'Władysław', 'Piotrowski'),
  (2, 'Marek', 'Wiśniewski'),
  (2, 'Stanisława', 'Głowacka'),
  (2, 'Agata', 'Kubiak'),
  (2, 'Marian', 'Kowalski'),
  (2, 'Piotr', 'Szymański'),
  (2, 'Stanisław', 'Kowalski'),
  (2, 'Aleksandra', 'Szulc'),
  (2, 'Tomasz', 'Kucharski'),
  (2, 'Marcin', 'Mazurek'),
  (2, 'Sebastian', 'Baranowski'),
  (2, 'Agata', 'Wysocka'),
  (2, 'Grażyna', 'Mazur'),
  (2, 'Marcin', 'Gajewski'),
  (3, 'Krystyna', 'Sikorska'),
  (3, 'Krzysztof', 'Kowalski'),
  (3, 'Małgorzata', 'Mazurek'),
  (3, 'Adam', 'Jasiński'),
  (3, 'Patrycja', 'Makowska'),
  (3, 'Piotr', 'Adamczyk'),
  (3, 'Waldemar', 'Wieczorek'),
  (3, 'Edward', 'Szulc'),
  (3, 'Janusz', 'Andrzejewski'),
  (3, 'Edyta', 'Nowakowska'),
  (3, 'Joanna', 'Woźniak'),
  (3, 'Mateusz', 'Michalak'),
  (3, 'Marta', 'Sobczak'),
  (3, 'Waldemar', 'Makowski'),
  (3, 'Marzena', 'Jabłońska'),
  (4, 'Maciej', 'Sikora'),
  (4, 'Monika', 'Szewczyk'),
  (4, 'Genowefa', 'Cieślak'),
  (4, 'Edyta', 'Nowicka'),
  (4, 'Piotr', 'Malinowski'),
  (4, 'Krzysztof', 'Głowacki'),
  (4, 'Andrzej', 'Szewczyk'),
  (4, 'Mariusz', 'Grabowski'),
  (4, 'Stefania', 'Król'),
  (4, 'Wiesław', 'Szczepański'),
  (4, 'Małgorzata', 'Wasilewska'),
  (4, 'Józef', 'Szczepański'),
  (4, 'Mariusz', 'Kowalczyk'),
  (4, 'Janina', 'Kozłowska'),
  (4, 'Roman', 'Kwiatkowski'),
  (5, 'Jadwiga', 'Kamińska'),
  (5, 'Agnieszka', 'Zając'),
  (5, 'Robert', 'Włodarczyk'),
  (5, 'Henryk', 'Kowalski'),
  (5, 'Kazimiera', 'Zalewska'),
  (5, 'Sylwia', 'Kaźmierczak'),
  (5, 'Dorota', 'Maciejewska'),
  (5, 'Jacek', 'Laskowski'),
  (5, 'Michał', 'Sobczak'),
  (5, 'Genowefa', 'Lis'),
  (5, 'Mirosław', 'Czerwiński'),
  (5, 'Agata', 'Gajewska'),
  (5, 'Zofia', 'Bąk'),
  (5, 'Marek', 'Adamczyk'),
  (5, 'Agata', 'Pawlak'),
  (6, 'Adam', 'Jankowski'),
  (6, 'Mieczysław', 'Adamczyk'),
  (6, 'Wanda', 'Czarnecka'),
  (6, 'Andrzej', 'Ziółkowski'),
  (6, 'Jarosław', 'Laskowski'),
  (6, 'Iwona', 'Urbańska'),
  (6, 'Aneta', 'Jakubowska'),
  (6, 'Zdzisław', 'Król'),
  (6, 'Maria', 'Wiśniewska'),
  (6, 'Grzegorz', 'Borkowski'),
  (6, 'Maria', 'Głowacka'),
  (6, 'Jakub', 'Pietrzak'),
  (6, 'Danuta', 'Piotrowska'),
  (6, 'Sebastian', 'Chmielewski'),
  (6, 'Adam', 'Andrzejewski');

INSERT INTO przedmiot(nazwa) VALUES
  ('Język polski'),
  ('Język angielski'),
  ('Język niemiecki'),
  ('Język francuski'),
  ('Matematyka'),
  ('Historia'),
  ('Wiedza o społeczeństwie'),
  ('Geografia'),
  ('Biologia'),
  ('Fizyka'),
  ('Chemia'),
  ('Wychowanie fizyczne');

INSERT INTO sala(numer) VALUES
  ('1'), ('2'), ('3'), ('4'), ('5'), ('6'), ('7'), ('Sala gimnastyczna');

INSERT INTO godzina_lekcyjna(godzina_rozpoczecia, godzina_zakonczenia) VALUES
  ('8:00', '8:45'),
  ('8:55', '9:40'),
  ('9:50', '10:35'),
  ('10:45', '11:30'),
  ('12:00', '12:45'),
  ('12:55', '13:40'),
  ('13:50', '14:35'),
  ('14:45', '15:30');

INSERT INTO przedmiot_nauczany_w_klasie(id_klasa, id_przedmiot, id_nauczyciel) VALUES
  (1, 1, 1),
  (1, 2, 1),
  (1, 3, 1),
  (1, 5, 1),
  (1, 6, 1),
  (1, 7, 1),
  (1, 8, 1),
  (1, 9, 1),
  (1, 10, 1),
  (1, 11, 1),
  (1, 12, 1),
  (2, 1, 1),
  (2, 2, 1),
  (2, 4, 1),
  (2, 5, 1),
  (2, 6, 1),
  (2, 7, 1),
  (2, 8, 1),
  (2, 9, 1),
  (2, 10, 1),
  (2, 11, 1),
  (2, 12, 1),
  (3, 1, 1),
  (3, 2, 1),
  (3, 3, 1),
  (3, 5, 1),
  (3, 10, 1),
  (3, 11, 1),
  (3, 12, 1),
  (4, 1, 1),
  (4, 2, 1),
  (4, 4, 1),
  (4, 5, 1),
  (4, 6, 1),
  (4, 7, 1),
  (4, 12, 1),
  (5, 1, 1),
  (5, 2, 1),
  (5, 3, 1),
  (5, 5, 1),
  (5, 10, 1),
  (5, 11, 1),
  (5, 12, 1),
  (6, 1, 1),
  (6, 2, 1),
  (6, 4, 1),
  (6, 5, 1),
  (6, 6, 1),
  (6, 7, 1),
  (6, 12, 1);

INSERT INTO plan_lekcji(id_przedmiot_nauczany_w_klasie, godzina, dzien_tygodnia, id_sala) VALUES
  (2, 1, 'Poniedziałek', 3),
  (2, 2, 'Poniedziałek', 3),
  (1, 3, 'Poniedziałek', 3),
  (1, 4, 'Poniedziałek', 3),
  (11, 5, 'Poniedziałek', 8),
  (11, 6, 'Poniedziałek', 8),
  (4, 3, 'Wtorek', 5),
  (4, 4, 'Wtorek', 5),
  (3, 5, 'Wtorek', 1),
  (5, 6, 'Wtorek', 2),
  (4, 3, 'Środa', 1),
  (4, 4, 'Środa', 1),
  (10, 5, 'Środa', 1),
  (6, 6, 'Środa', 1),
  (7, 3, 'Czwatek', 1),
  (8, 4, 'Czwartek', 1),
  (9, 5, 'Czwartek', 1),
  (1, 1, 'Piatek', 3),
  (1, 2, 'Piatek', 3),
  (2, 3, 'Piatek', 3),
  (2, 4, 'Piatek', 3),
  (9, 5, 'Piatek', 4),

  (18, 3, 'Poniedzialek', 8),
  (19, 4, 'Poniedzialek', 8),
  (12, 5, 'Poniedzialek', 8),
  (12, 6, 'Poniedzialek', 8),
  (22, 7, 'Poniedzialek', 8),
  (22, 8, 'Poniedzialek', 8),
  (15, 1, 'Wtorek', 1),
  (15, 2, 'Wtorek', 1),
  (12, 3, 'Wtorek', 1),
  (12, 4, 'Wtorek', 1),
  (13, 1, 'Środa', 1),
  (13, 2, 'Środa', 1),
  (15, 3, 'Środa', 1),
  (15, 4, 'Środa', 1),
  (20, 3, 'Czwartek', 1),
  (17, 4, 'Czwartek', 1),
  (14, 5, 'Czwartek', 1),
  (16, 6, 'Czwartek', 1),
  (14, 3, 'Piatek', 1),
  (13, 4, 'Piatek', 1),
  (13, 5, 'Piatek', 1),
  (21, 6, 'Piatek', 1),

  (26, 1, 'Poniedziałek', 1),
  (26, 2, 'Poniedziałek', 1),
  (23, 3, 'Poniedziałek', 1),
  (25, 4, 'Poniedziałek', 1),
  (23, 3, 'Wtorek', 1),
  (25, 4, 'Wtorek', 1),
  (29, 5, 'Wtorek', 1),
  (29, 6, 'Wtorek', 1),
  (26, 1, 'Środa', 1),
  (26, 2, 'Środa', 1),
  (23, 3, 'Środa', 1),
  (24, 4, 'Środa', 1),
  (28, 1, 'Czwartek', 1),
  (28, 2, 'Czwartek', 1),
  (27, 3, 'Czwartek', 1),
  (27, 4, 'Czwartek', 1),
  (24, 5, 'Piątek', 1),
  (24, 6, 'Piątek', 1),
  (26, 7, 'Piątek', 1),
  (26, 8, 'Piątek', 1),

  (31, 5, 'Poniedziałek', 1),
  (34, 6, 'Poniedziałek', 1),
  (34, 7, 'Poniedziałek', 1),
  (33, 8, 'Poniedziałek', 1),
  (35, 5, 'Wtorek', 2),
  (35, 6, 'Wtorek', 2),
  (36, 7, 'Wtorek', 8),
  (36, 8, 'Wtorek', 8),
  (33, 1, 'Środa', 8),
  (33, 2, 'Środa', 8),
  (30, 3, 'Środa', 8),
  (30, 4, 'Środa', 8),
  (30, 1, 'Czwartek', 8),
  (30, 2, 'Czwartek', 8),
  (31, 3, 'Czwartek', 8),
  (32, 4, 'Czwartek', 8),
  (30, 1, 'Piątek', 8),
  (30, 2, 'Piątek', 8),
  (31, 3, 'Piątek', 8),
  (32, 4, 'Piątek', 8),

  (42, 3, 'Poniedziałek', 1),
  (42, 4, 'Poniedziałek', 1),
  (41, 5, 'Poniedziałek', 1),
  (41, 6, 'Poniedziałek', 1),
  (40, 3, 'Wtorek', 1),
  (40, 4, 'Wtorek', 1),
  (37, 5, 'Wtorek', 1),
  (37, 6, 'Wtorek', 1),
  (38, 3, 'Środa', 1),
  (39, 4, 'Środa', 1),
  (43, 5, 'Środa', 8),
  (43, 6, 'Środa', 8),
  (40, 1, 'Czwartek', 1),
  (40, 2, 'Czwartek', 1),
  (38, 3, 'Czwartek', 1),
  (38, 4, 'Czwartek', 1),
  (39, 1, 'Piątek', 1),
  (37, 2, 'Piątek', 1),
  (40, 3, 'Piątek', 1),
  (40, 4, 'Piątek', 1),

  (46, 1, 'Poniedziałek', 1),
  (47, 2, 'Poniedziałek', 1),
  (44, 3, 'Poniedziałek', 1),
  (44, 4, 'Poniedziałek', 1),
  (44, 1, 'Wtorek', 1),
  (44, 2, 'Wtorek', 1),
  (47, 3, 'Wtorek', 1),
  (47, 4, 'Wtorek', 1),
  (44, 5, 'Środa', 1),
  (44, 6, 'Środa', 1),
  (50, 7, 'Środa', 8),
  (50, 8, 'Środa', 8),
  (45, 5, 'Czwartek', 1),
  (49, 6, 'Czwartek', 1),
  (49, 7, 'Czwartek', 1),
  (46, 8, 'Czwartek', 1),
  (48, 5, 'Piątek', 1),
  (48, 6, 'Piątek', 1),
  (45, 7, 'Piątek', 1),
  (45, 8, 'Piątek', 1);