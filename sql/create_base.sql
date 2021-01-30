DROP TABLE IF EXISTS nauczyciel, klasa, sala, przedmiot, uczen, oplata, godzina_lekcyjna, przedmiot_nauczany_w_klasie, plan_lekcji, lekcja, frekwencja, ocena CASCADE;

CREATE TABLE nauczyciel (
  id_nauczyciel SERIAL PRIMARY KEY,
  imie TEXT,
  nazwisko TEXT
);

CREATE TABLE klasa (
  id_klasa TEXT PRIMARY KEY,
  id_wychowawca INTEGER REFERENCES nauczyciel(id_nauczyciel)
);

CREATE TABLE sala (
  id_sala SERIAL PRIMARY KEY,
  numer TEXT
);

CREATE TABLE przedmiot (
  id_przedmiot SERIAL PRIMARY KEY,
  nazwa TEXT
);

CREATE TABLE uczen (
  id_uczen SERIAL PRIMARY KEY,
  id_klasa TEXT REFERENCES klasa(id_klasa),
  imie TEXT,
  nazwisko TEXT
);

CREATE TABLE oplata (
  id_oplata SERIAL PRIMARY KEY,
  id_uczen INTEGER REFERENCES uczen(id_uczen),
  ile_do_zaplacenia FLOAT,
  ile_zostalo_zaplacone FLOAT,
  opis TEXT
);

CREATE TABLE przedmiot_nauczany_w_klasie (
  id_przedmiot_nauczany_w_klasie SERIAL PRIMARY KEY,
  id_klasa TEXT REFERENCES klasa(id_klasa),
  id_przedmiot INTEGER REFERENCES przedmiot(id_przedmiot),
  id_nauczyciel INTEGER REFERENCES nauczyciel(id_nauczyciel)
);

CREATE TABLE godzina_lekcyjna (
  id_godzina_lekcyjna SERIAL PRIMARY KEY,
  godzina_rozpoczecia TEXT,
  godzina_zakonczenia TEXT
);

CREATE TABLE plan_lekcji (
  id_plan_lekcji SERIAL PRIMARY KEY,
  id_przedmiot_nauczany_w_klasie INTEGER REFERENCES przedmiot_nauczany_w_klasie(id_przedmiot_nauczany_w_klasie),
  id_godzina_lekcyjna INTEGER REFERENCES godzina_lekcyjna(id_godzina_lekcyjna),
  dzien_tygodnia TEXT,
  id_sala INTEGER REFERENCES sala(id_sala)
);

CREATE TABLE lekcja (
  id_lekcja SERIAL PRIMARY KEY,
  id_plan_lekcji INTEGER REFERENCES plan_lekcji(id_plan_lekcji),
  dzien DATE,
  temat TEXT
);

CREATE TABLE frekwencja (
  id_frekwencja SERIAL PRIMARY KEY,
  id_uczen INTEGER REFERENCES uczen(id_uczen),
  id_lekcja INTEGER REFERENCES lekcja(id_lekcja),
  opis TEXT
);

CREATE TABLE ocena (
  id_ocena SERIAL PRIMARY KEY,
  id_uczen INTEGER REFERENCES uczen(id_uczen),
  id_przedmiot INTEGER REFERENCES przedmiot(id_przedmiot),
  opis FLOAT
);
