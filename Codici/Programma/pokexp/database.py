from typing import Tuple, List, Optional

import psycopg2


MultimediaId = Tuple[str, int]
CharacterId = Tuple[str, Optional[str]]


class Database:
    def __init__(self, connection):
        self.connection = connection

    def version(self) -> str:
        with self.connection.cursor() as cursor:
            cursor.execute("SELECT version();")
            return cursor.fetchone()[0]

    def list_games(self) -> List[Tuple[str, int]]:
        with self.connection.cursor() as c:
            c.execute("SELECT nome, num_pokemon FROM gioco")
            return c.fetchall()

    def list_pokemons(self) -> List[Tuple[str, int]]:
        with self.connection.cursor() as c:
            c.execute("SELECT nome, id FROM pokemon")
            return c.fetchall()

    def list_multimedias(self) -> List[MultimediaId]:
        with self.connection.cursor() as c:
            c.execute("SELECT nome, anno FROM multimedia")
            return c.fetchall()

    def game_details(self, nome: str) -> Tuple[str, str, str, int]:
        with self.connection.cursor() as c:
            c.execute("SELECT nome, data_rilascio, casa_sviluppo, num_pokemon FROM gioco WHERE nome=%s", (nome,))
            return c.fetchone()

    def game_pokemons(self, game: str) -> List[Tuple[int, str, bool]]:
        with self.connection.cursor() as c:
            c.execute("SELECT p.id, p.nome, pg.is_leggendario FROM pokemoningioco pg, pokemon p"
                      " WHERE p.id = pg.pokemon AND gioco=%s", (game,))
            return c.fetchall()

    def pokemon_details(self, pokemon: int) -> Optional[Tuple[str, str, str, Optional[float], str, Optional[str],
                                                              Optional[int], Optional[str], int, int]]:
        with self.connection.cursor() as c:
            c.execute("SELECT p1.nome, p1.descrizione, p1.zona_cattura, p1.percentuale_sesso, p1.tipo1, p1.tipo2,"
                      " p2.id, p2.nome, (SELECT count(*) FROM evoluzione e1 WHERE e1.da = p1.id) as evolcnt,"
                      " (SELECT count(*) FROM personaggio WHERE rappresenta_pokemon = p1.id) as rapprcnt"
                      " FROM pokemon p1"
                      " LEFT JOIN evoluzione e ON p1.id = e.a"
                      " LEFT JOIN pokemon p2 ON p2.id = e.da"
                      " WHERE p1.id = %s",
                      (pokemon,))
            return c.fetchone()

    def pokemon_evolutions(self, pokemon: int) -> List[Tuple[str, int]]:
        with self.connection.cursor() as c:
            c.execute("SELECT p.nome, p.id FROM evoluzione e, pokemon p WHERE e.a=p.id AND e.da=%s", (pokemon,))
            return c.fetchall()

    def pokemon_moves(self, pokemon: int) -> List[Tuple[str, bool]]:
        with self.connection.cursor() as c:
            c.execute("SELECT mossa, partenza FROM imparamossa WHERE pokemon=%s", (pokemon,))
            return c.fetchall()

    def pokemon_go_locations(self, pokemon: int) -> List[Tuple[str, str, str]]:
        with self.connection.cursor() as c:
            c.execute("SELECT stato, citta, tipo_zona FROM zonacatturapokemongo WHERE pokemon=%s", (pokemon,))
            return c.fetchall()

    def pokemon_multimedias(self, pokemon: int) -> List[MultimediaId]:
        with self.connection.cursor() as c:
            c.execute("SELECT multimedia_nome, multimedia_anno FROM comparein WHERE pokemon=%s", (pokemon,))
            return c.fetchall()

    def pokemon_characters(self, pokemon: int) -> List[CharacterId]:
        with self.connection.cursor() as c:
            c.execute("SELECT personaggio_nome, personaggio_cognome FROM pokemonpossesso WHERE pokemon=%s",
                      (pokemon,))
            return c.fetchall()

    def pokemon_representations(self, pokemon: int) -> List[CharacterId]:
        with self.connection.cursor() as c:
            c.execute("SELECT nome, cognome FROM personaggio WHERE rappresenta_pokemon=%s",
                      (pokemon,))
            return c.fetchall()

    def move_details(self, mossa: str) -> Optional[Tuple[str, bool]]:
        with self.connection.cursor() as c:
            c.execute("SELECT tipo, is_tm, categoria, potenza FROM mossa WHERE nome=%s", (mossa,))
            return c.fetchone()

    def move_pokemons(self, mossa: str) -> List[Tuple[int, str, bool]]:
        with self.connection.cursor() as c:
            c.execute("SELECT p.id, p.nome, partenza FROM pokemon p, imparamossa i"
                      " WHERE p.id = i.pokemon AND i.mossa=%s", (mossa,))
            return c.fetchall()

    def multimedia_details(self, multimedia: MultimediaId) -> Optional[Tuple[str, str, str]]:
        with self.connection.cursor() as c:
            c.execute("SELECT casa_produzione, creatore, tipo_multimediale FROM multimedia WHERE nome=%s AND anno=%s",
                      multimedia)
            return c.fetchone()

    def multimedia_pokemons(self, mm: MultimediaId) -> List[Tuple[int, str]]:
        with self.connection.cursor() as c:
            c.execute("SELECT p.id, p.nome FROM comparein c, pokemon p WHERE p.id=c.pokemon AND"
                      " c.multimedia_nome=%s AND c.multimedia_anno=%s", mm)
            return c.fetchall()

    def multimedia_appearances(self, mm: MultimediaId) -> List[CharacterId]:
        with self.connection.cursor() as c:
            c.execute("SELECT personaggio_nome, personaggio_cognome FROM comparsa WHERE"
                      " multimedia_nome=%s AND multimedia_anno=%s", mm)
            return c.fetchall()

    def apperance_dubbings(self, mm: MultimediaId, ch: CharacterId) -> List[Tuple[str, str, str, str]]:
        with self.connection.cursor() as c:
            c.execute("SELECT lingua, d.cod_fis, d.nome, d.cognome FROM doppiaggio o, doppiatore d WHERE"
                      " d.cod_fis=o.doppiatore AND"
                      " o.multimedia_nome=%s AND o.multimedia_anno=%s AND"
                      " o.personaggio_nome=%s AND o.personaggio_cognome=%s", mm + ch)
            return c.fetchall()

    def dubber_details(self, cf: str) -> Optional[Tuple[str, str, str, int]]:
        with self.connection.cursor() as c:
            c.execute("SELECT nome, cognome, data_nascita,"
                      " (SELECT count(*) FROM doppiaggio d1 where d1.doppiatore = cod_fis) as dubs_c FROM doppiatore"
                      " WHERE cod_fis=%s", (cf,))
            return c.fetchone()

    def dubber_appearances(self, cf: str) -> List[Tuple[str, str, str, int, str]]:
        with self.connection.cursor() as c:
            c.execute("SELECT personaggio_nome, personaggio_cognome, multimedia_nome, multimedia_anno, lingua"
                      " FROM doppiaggio WHERE doppiatore = %s", (cf,))
            return c.fetchall()

    def character_details(self, ch: CharacterId) -> Optional[Tuple[Optional[str], Optional[int], int, int]]:
        with self.connection.cursor() as c:
            c.execute("SELECT p.nome, p.id, "
                      " (SELECT COUNT(*) FROM pokemonpossesso"
                      " WHERE personaggio_nome=q.nome AND personaggio_cognome=q.cognome) as pcnt,"
                      " (SELECT COUNT(*) FROM comparsa"
                      " WHERE personaggio_nome=q.nome AND personaggio_cognome=q.cognome) as pcmp"
                      " FROM personaggio q"
                      " LEFT JOIN pokemon p ON q.rappresenta_pokemon = p.id"
                      " WHERE q.nome=%s AND q.cognome=%s", ch)
            return c.fetchone()

    def character_pokemons(self, ch: CharacterId) -> List[Tuple[str, int]]:
        with self.connection.cursor() as c:
            c.execute("SELECT p.nome, p.id FROM pokemon p, pokemonpossesso q WHERE p.id = q.pokemon AND"
                      " personaggio_nome=%s AND personaggio_cognome=%s", ch)
            return c.fetchall()

    def character_appearances(self, ch: CharacterId) -> List[MultimediaId]:
        with self.connection.cursor() as c:
            c.execute("SELECT multimedia_nome, multimedia_anno FROM comparsa WHERE "
                      " personaggio_nome=%s AND personaggio_cognome=%s", ch)
            return c.fetchall()

    # -------------------------------------- META QUERIES
    def list_tables(self) -> List[str]:
        with self.connection.cursor() as c:
            c.execute("SELECT tablename"
                      " FROM pg_catalog.pg_tables"
                      " WHERE schemaname != 'pg_catalog' AND"
                      " schemaname != 'information_schema'", ())
            return c.fetchall()

    def table_columns(self, table: str) -> List[Tuple[str, any, str]]:
        with self.connection.cursor() as c:
            c.execute("SELECT column_name, column_default, is_nullable"
                      " FROM information_schema.columns"
                      " WHERE table_name = %s"
                      " ORDER BY ordinal_position", (table,))
            return c.fetchall()

    def table_primary_key(self, table: str) -> List[Tuple[str]]:
        # https://wiki.postgresql.org/wiki/Retrieve_primary_key_columns
        with self.connection.cursor() as c:
            c.execute("SELECT a.attname"
                      " FROM pg_index i"
                      " JOIN pg_attribute a ON a.attrelid = i.indrelid"
                      " AND a.attnum = ANY(i.indkey)"
                      " WHERE i.indrelid = %s::regclass"
                      " AND i.indisprimary", (table,))
            return c.fetchall()

    def stop(self):
        self.connection.close()


def connect(data: str) -> Database:
    return Database(psycopg2.connect(data))
