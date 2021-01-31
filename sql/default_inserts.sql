-- plik zawiera podstawowe inserty umożliwijące pokazanie działania bazy danych

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
  ('Roman', 'Sawicki'),
  ('Jakub', 'Pietrzak'),
  ('Danuta', 'Piotrowska'),
  ('Sebastian', 'Chmielewski'),
  ('Adam', 'Andrzejewski');

INSERT INTO klasa (id_klasa, id_wychowawca) VALUES
  ('1A', 1),
  ('1B', 2),
  ('1C', 3);

INSERT INTO uczen (id_klasa, imie, nazwisko) VALUES
  ('1A', 'Marcin', 'Szymczak'),
  ('1A', 'Joanna', 'Baranowska'),
  ('1A', 'Maciej', 'Szczepański'),
  ('1A', 'Czesław', 'Wróbel'),
  ('1A', 'Grażyna', 'Górska'),
  ('1A', 'Wanda', 'Krawczyk'),
  ('1A', 'Renata', 'Urbańska'),
  ('1A', 'Wiesława', 'Tomaszewska'),
  ('1A', 'Bożena', 'Baranowska'),
  ('1A', 'Ewelina', 'Malinowska'),
  ('1B', 'Anna', 'Krajewska'),
  ('1B', 'Mieczysław', 'Zając'),
  ('1B', 'Wiesław', 'Przybylski'),
  ('1B', 'Dorota', 'Tomaszewska'),
  ('1B', 'Jerzy', 'Wróblewski'),
  ('1B', 'Magdalena', 'Adamczyk'),
  ('1B', 'Władysław', 'Piotrowski'),
  ('1B', 'Marek', 'Wiśniewski'),
  ('1B', 'Stanisława', 'Głowacka'),
  ('1B', 'Agata', 'Kubiak'),
  ('1C', 'Marian', 'Kowalski'),
  ('1C', 'Piotr', 'Szymański'),
  ('1C', 'Stanisław', 'Kowalski'),
  ('1C', 'Aleksandra', 'Szulc'),
  ('1C', 'Tomasz', 'Kucharski'),
  ('1C', 'Marcin', 'Mazurek'),
  ('1C', 'Sebastian', 'Baranowski'),
  ('1C', 'Agata', 'Wysocka'),
  ('1C', 'Grażyna', 'Mazur'),
  ('1C', 'Marcin', 'Gajewski');

INSERT INTO przedmiot(nazwa) VALUES
  ('Język polski'),
  ('Język angielski'),
  ('Język niemiecki'),
  ('Język francuski'),
  ('Język rosyjski'),
  ('Matematyka'),
  ('Historia'),
  ('Wiedza o społeczeństwie'),
  ('Geografia'),
  ('Biologia'),
  ('Fizyka'),
  ('Chemia'),
  ('Wychowanie fizyczne');

INSERT INTO sala(numer) VALUES
  ('1'), ('2'), ('3'), ('4'), ('Sala gimnastyczna');

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
  ('1A', 1, 1),
  ('1A', 2, 2),
  ('1A', 3, 4),
  ('1A', 6, 7),
  ('1A', 7, 8),
  ('1A', 8, 9),
  ('1A', 9, 9),
  ('1A', 10, 10),
  ('1A', 11, 11),
  ('1A', 12, 12),
  ('1A', 13, 14),
  ('1B', 1, 1),
  ('1B', 2, 2),
  ('1B', 4, 5),
  ('1B', 6, 7),
  ('1B', 7, 8),
  ('1B', 8, 9),
  ('1B', 9, 9),
  ('1B', 10, 10),
  ('1B', 11, 11),
  ('1B', 12, 12),
  ('1B', 13, 14),
  ('1C', 1, 1),
  ('1C', 2, 3),
  ('1C', 5, 6),
  ('1C', 6, 7),
  ('1C', 7, 8),
  ('1C', 8, 9),
  ('1C', 9, 9),
  ('1C', 10, 10),
  ('1C', 11, 11),
  ('1C', 12, 12),
  ('1C', 13, 14);
 

INSERT INTO plan_lekcji(id_przedmiot_nauczany_w_klasie, id_godzina_lekcyjna, dzien_tygodnia, id_sala) VALUES
  (2, 1, 'Poniedziałek', 1),
  (2, 2, 'Poniedziałek', 1),
  (1, 3, 'Poniedziałek', 1),
  (1, 4, 'Poniedziałek', 1),
  (11, 5, 'Poniedziałek', 5),
  (11, 6, 'Poniedziałek', 5),
  (4, 3, 'Wtorek', 2),
  (4, 4, 'Wtorek', 2),
  (3, 5, 'Wtorek', 2),
  (5, 6, 'Wtorek', 2),
  (4, 3, 'Środa', 3),
  (4, 4, 'Środa', 3),
  (10, 5, 'Środa', 3),
  (6, 6, 'Środa', 3),
  (7, 3, 'Czwartek', 4),
  (8, 4, 'Czwartek', 4),
  (3, 5, 'Czwartek', 4),
  (1, 1, 'Piątek', 1),
  (1, 2, 'Piątek', 1),
  (2, 3, 'Piątek', 1),
  (2, 4, 'Piątek', 1),
  (9, 5, 'Piątek', 1),

  (18, 3, 'Poniedziałek', 2),
  (19, 4, 'Poniedziałek', 2),
  (12, 5, 'Poniedziałek', 2),
  (12, 6, 'Poniedziałek', 2),
  (22, 7, 'Poniedziałek', 5),
  (22, 8, 'Poniedziałek', 5),
  (15, 1, 'Wtorek', 3),
  (15, 2, 'Wtorek', 3),
  (12, 3, 'Wtorek', 3),
  (12, 4, 'Wtorek', 3),
  (13, 1, 'Środa', 4),
  (13, 2, 'Środa', 4),
  (15, 3, 'Środa', 4),
  (15, 4, 'Środa', 4),
  (20, 3, 'Czwartek', 1),
  (17, 4, 'Czwartek', 1),
  (14, 5, 'Czwartek', 1),
  (16, 6, 'Czwartek', 1),
  (14, 3, 'Piątek', 2),
  (13, 4, 'Piątek', 2),
  (13, 5, 'Piątek', 2),
  (21, 6, 'Piątek', 2),

  (33, 3, 'Poniedziałek', 5),
  (33, 4, 'Poniedziałek', 5),
  (23, 5, 'Poniedziałek', 3),
  (23, 6, 'Poniedziałek', 3),
  (23, 3, 'Wtorek', 4),
  (23, 4, 'Wtorek', 4),
  (24, 5, 'Wtorek', 4),
  (24, 6, 'Wtorek', 4),
  (26, 1, 'Środa', 1),
  (26, 2, 'Środa', 1),
  (27, 3, 'Środa', 1),
  (28, 4, 'Środa', 1),
  (30, 1, 'Czwartek', 2),
  (29, 2, 'Czwartek', 2),
  (31, 3, 'Czwartek', 2),
  (32, 4, 'Czwartek', 2),
  (27, 3, 'Piątek', 3),
  (25, 4, 'Piątek', 3),
  (24, 5, 'Piątek', 3),
  (24, 6, 'Piątek', 3),
  (26, 7, 'Piątek', 3),
  (26, 8, 'Piątek', 3);

INSERT INTO lekcja (id_plan_lekcji, dzien, temat) VALUES
  (1, '2021-02-01', 'Język angielski, lekcja 1'),
  (2, '2021-02-01', 'Język angielski, lekcja 2'),
  (3, '2021-02-01', 'Język polski, lekcja 1'),
  (4, '2021-02-01', 'Język polski, lekcja 2'),
  (3, '2021-02-01', 'WF, lekcja 1'),
  (4, '2021-02-01', 'WF, lekcja 2');

INSERT INTO ocena (id_uczen, id_przedmiot, opis) VALUES
  (1, 1, 4.5),
  (1, 1, 4),
  (1, 1, 4.5),
  (1, 1, 5),
  (1, 2, 5),
  (1, 2, 3),
  (1, 2, 1),
  (1, 2, 5),
  (1, 2, 5),
  (1, 2, 5),
  (1, 3, 4.5),
  (1, 3, 4.5),
  (1, 6, 1),
  (1, 6, 2),
  (1, 6, 1);

INSERT INTO oplata (id_uczen, ile_do_zaplacenia, opis) VALUES
  (0, 50, 'Ubezpieczenie');