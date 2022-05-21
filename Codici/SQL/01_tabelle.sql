CREATE TABLE tipo (
  nome varchar(20),
  PRIMARY KEY (nome)
);

CREATE TABLE Pokemon (
  id int check (id > 0),
  nome varchar(20) NOT NULL,
  descrizione varchar(300),
  zona_cattura varchar(20) check (zona_cattura in ('Foresta', 'Spiaggia', 'Caverna','Evento','Erba alta')) NOT NULL,
  percentuale_sesso float check (percentuale_sesso <= 100 AND percentuale_sesso >= 0),
  tipo1 varchar(20) NOT NULL,
  tipo2 varchar(20) check (tipo2 <> tipo1),
  PRIMARY KEY (id),
  FOREIGN KEY (tipo1) REFERENCES Tipo(nome),
  FOREIGN KEY (tipo2) REFERENCES Tipo(nome)
);

CREATE TABLE Evoluzione (
  da int,
  a int,
  livello int,
  richieste varchar(100),
  PRIMARY KEY (a),
  FOREIGN KEY (da) REFERENCES pokemon(id),
  FOREIGN KEY (a) REFERENCES pokemon(id)
);

CREATE TABLE ZonaCatturaPokemonGo (
  stato varchar(30),
  citta varchar(30),
  tipo_zona varchar(30) check (tipo_zona in ('Mare','Urbano','Rurale')),
  pokemon int NOT NULL,
  PRIMARY KEY(stato,citta,tipo_zona,pokemon),
  FOREIGN KEY (pokemon) REFERENCES pokemon(id)
);

CREATE TABLE gioco (
  nome varchar(50),
  num_pokemon int NOT NULL DEFAULT 0,
  data_rilascio date,
  casa_sviluppo varchar(20) NOT NULL,
  PRIMARY KEY (nome)
);

CREATE TABLE dispositivoweb (
  nome varchar(20),
  req_minimi varchar(100),
  PRIMARY KEY (nome)
);

CREATE TABLE dispositivomobile (
  nome varchar(20),
  req_minimi varchar(100),
  usa_fotocamera boolean,
  PRIMARY KEY (nome)
);

CREATE TABLE dispositivoconsole (
  nome varchar(20),
  data_rilascio date,
  portatile boolean,
  PRIMARY KEY (nome)
);

CREATE TABLE consoletipojoystick (
  nome varchar(20),
  tipo_joystick varchar(20) NOT NULL,
  PRIMARY KEY (nome),
  FOREIGN KEY (nome) REFERENCES dispositivoconsole(nome)
);

CREATE TABLE pubblicazioneweb (
  gioco varchar(50),
  dispositivo varchar(20),
  PRIMARY KEY (gioco,dispositivo),
  FOREIGN KEY (gioco) REFERENCES gioco(nome),
  FOREIGN KEY (dispositivo) REFERENCES dispositivoweb(nome)
);

CREATE TABLE pubblicazionemobile (
  gioco varchar(50),
  dispositivo varchar(20),
  PRIMARY KEY (gioco,dispositivo),
  FOREIGN KEY (gioco) REFERENCES gioco(nome),
  FOREIGN KEY (dispositivo) REFERENCES dispositivomobile(nome)
);

CREATE TABLE pubblicazioneconsole (
  gioco varchar(50),
  dispositivo varchar(20),
  PRIMARY KEY (gioco,dispositivo),
  FOREIGN KEY (gioco) REFERENCES gioco(nome),
  FOREIGN KEY (dispositivo) REFERENCES dispositivoconsole(nome)
);

CREATE TABLE pokemoningioco (
  pokemon int,
  gioco varchar(50),
  is_leggendario boolean NOT NULL,
  PRIMARY KEY (pokemon, gioco),
  FOREIGN KEY (gioco) REFERENCES gioco(nome),
  FOREIGN KEY (pokemon) REFERENCES pokemon(id)
);

CREATE TABLE ConfrontoTipo (
  da varchar(20),
  contro varchar(20),
  efficacia int check (efficacia in (0,1,2)) NOT NULL,
  PRIMARY KEY (da,contro),
  FOREIGN KEY (da) REFERENCES tipo(nome),
  FOREIGN KEY (contro) REFERENCES tipo(nome)
);

CREATE TABLE mossa (
  nome varchar(20),
  tipo varchar(20) NOT NULL,
  is_tm boolean NOT NULL,
  categoria varchar(10) check (categoria in ('Fisica','Speciale','Stato')) NOT NULL,
  potenza int NOT NULL,
  PRIMARY KEY (nome),
  FOREIGN KEY (tipo) REFERENCES tipo(nome)
);

CREATE TABLE imparamossa (
  pokemon int,
  mossa varchar(20),
  partenza boolean NOT NULL,
  PRIMARY KEY (pokemon,mossa),
  FOREIGN KEY (pokemon) REFERENCES pokemon(id),
  FOREIGN KEY (mossa) REFERENCES mossa(nome)
);

CREATE TABLE personaggio (
  nome varchar(20),
  cognome varchar(20),
  rappresenta_pokemon int,
  PRIMARY KEY (nome,cognome),
  FOREIGN KEY (rappresenta_pokemon) REFERENCES pokemon(id)
);

create table pokemonpossesso (
  personaggio_nome varchar(20),
  personaggio_cognome varchar(20),
  pokemon int,
  PRIMARY KEY (personaggio_nome,personaggio_cognome,pokemon),
  FOREIGN KEY (personaggio_nome,personaggio_cognome) REFERENCES personaggio(nome,cognome),
  FOREIGN KEY (pokemon) REFERENCES pokemon(id)
);

create table multimedia (
  nome varchar(40),
  anno int check (anno > 1980),
  casa_produzione varchar(40) NOT NULL,
  creatore varchar(40),
  tipo_multimediale varchar(20) check (tipo_multimediale in ('Manga','Serie anime','Film anime','Film live action')) NOT NULL,
  PRIMARY KEY (nome,anno)
);

CREATE TABLE comparein (
  pokemon int,
  multimedia_nome varchar(40),
  multimedia_anno int,
  PRIMARY KEY (pokemon,multimedia_nome,multimedia_anno),
  FOREIGN KEY (pokemon) REFERENCES pokemon(id),
  FOREIGN KEY (multimedia_nome,multimedia_anno) REFERENCES multimedia(nome,anno)
);

CREATE TABLE comparsa (
  personaggio_nome varchar(20),
  personaggio_cognome varchar(20),
  multimedia_nome varchar(40),
  multimedia_anno int,
  PRIMARY KEY(personaggio_nome,personaggio_cognome,multimedia_nome,multimedia_anno),
  FOREIGN KEY (personaggio_nome,personaggio_cognome) REFERENCES personaggio(nome,cognome),
  FOREIGN KEY (multimedia_nome,multimedia_anno) REFERENCES multimedia(nome,anno)
);

CREATE TABLE doppiatore (
  cod_fis char(16),
  nome varchar(20) NOT NULL,
  cognome varchar(20) NOT NULL,
  data_nascita date,
  PRIMARY KEY (cod_fis)
);

CREATE TABLE doppiaggio (
  personaggio_nome varchar(20),
  personaggio_cognome varchar(20),
  multimedia_nome varchar(40),
  multimedia_anno int,
  lingua varchar(20),
  doppiatore char(16),
  PRIMARY KEY(personaggio_nome,personaggio_cognome,multimedia_nome,multimedia_anno,lingua,doppiatore),
  FOREIGN KEY (personaggio_nome,personaggio_cognome,multimedia_nome,multimedia_anno) REFERENCES comparsa(personaggio_nome,personaggio_cognome,multimedia_nome,multimedia_anno),
  FOREIGN KEY (doppiatore) REFERENCES doppiatore(cod_fis)
);