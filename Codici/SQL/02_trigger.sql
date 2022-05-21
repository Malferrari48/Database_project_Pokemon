/*
 * Avoid cycles in evolution forest
 * How does this work?
 * 0. create the table search_graph (current, cycle)
 * 1. for each record x inserted in the search_graph table:
 *  a. Get the evolution y that has as child x.current
 *  b. Insert it as new records with (y.parent, y.parent == new.child)
 * 2. a record with (new.parent, new.parent == new.child) is inserted
 * The point 2 will let the hunt begin, so its parent will be pushed
 * and it will recur on their parent (it will be pushed too, ecc.)
 * the check in point b (y.parent == new.child) will detect if we have
 * looped back to the first record.
 * Now we just need to start the query filtering only the cycles
 */
CREATE OR REPLACE FUNCTION check_evolution_cycle() RETURNS trigger AS $$
BEGIN
    IF (TG_OP = 'INSERT' OR NEW.da <> OLD.da OR NEW.a <> OLD.a) AND EXISTS (
        WITH RECURSIVE search_graph(current, cycle) AS (
            SELECT NEW.da, (NEW.da = NEW.a)
            UNION ALL
                SELECT g.da, g.da = NEW.a
                FROM evoluzione g, search_graph sg
                WHERE g.a = sg.current AND NOT cycle
        )
        SELECT * FROM search_graph
                 WHERE cycle
                 LIMIT 1
        )
    THEN
        RAISE EXCEPTION 'Detected cycle in evolution';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;


CREATE TRIGGER detect_evolution_cycle_after_update
AFTER INSERT OR UPDATE ON evoluzione
FOR EACH ROW EXECUTE PROCEDURE check_evolution_cycle();





CREATE OR REPLACE FUNCTION check_impara_mossa_evolution() RETURNS trigger AS $$
BEGIN
    IF EXISTS (
        WITH RECURSIVE search_graph(current, duplication) AS (
            SELECT NEW.pokemon, false
            UNION ALL
                SELECT g.da, EXISTS (
                    SELECT * FROM imparamossa WHERE pokemon = g.da AND mossa = NEW.mossa)
                FROM evoluzione g, search_graph sg
                WHERE g.a = sg.current AND NOT duplication
        )
        SELECT * FROM search_graph
                 WHERE duplication
                 LIMIT 1
        )
    THEN
        RAISE EXCEPTION 'Move is already present in previous evolution';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;


CREATE TRIGGER dedup_impara_mossa_evolution
AFTER INSERT OR UPDATE ON imparamossa
FOR EACH ROW EXECUTE PROCEDURE check_impara_mossa_evolution();





CREATE OR REPLACE FUNCTION check_device_unique() RETURNS trigger AS $$
BEGIN
    IF (TG_OP = 'INSERT' OR OLD.nome <> NEW.nome) AND 1 < ( SELECT SUM(tbl.cnt) FROM (
            SELECT COUNT(*) as cnt FROM dispositivoweb WHERE nome = NEW.nome UNION ALL
            SELECT COUNT(*) as cnt FROM dispositivomobile WHERE nome = NEW.nome UNION ALL
            SELECT COUNT(*) as cnt FROM dispositivoconsole WHERE nome = NEW.nome
        ) tbl)
    THEN
        RAISE EXCEPTION 'Duplicated device found';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER detect_device_duplication_web
AFTER INSERT OR UPDATE ON dispositivoweb
FOR EACH ROW EXECUTE PROCEDURE check_device_unique();

CREATE TRIGGER detect_device_duplication_mobile
AFTER INSERT OR UPDATE ON dispositivomobile
FOR EACH ROW EXECUTE PROCEDURE check_device_unique();

CREATE TRIGGER detect_device_duplication_console
AFTER INSERT OR UPDATE ON dispositivoconsole
FOR EACH ROW EXECUTE PROCEDURE check_device_unique();






CREATE OR REPLACE FUNCTION update_gioco_pokemon_count() RETURNS trigger AS $$
BEGIN
    IF (TG_OP = 'DELETE' OR (TG_OP = 'UPDATE' AND NEW.gioco <> OLD.gioco))
    THEN
        UPDATE gioco SET num_pokemon = num_pokemon - 1 WHERE nome = OLD.gioco;
    END IF;
    IF (TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NEW.gioco <> OLD.gioco))
    THEN
        UPDATE gioco SET num_pokemon = num_pokemon + 1 WHERE nome = NEW.gioco;
    END IF;
    RETURN NULL; -- We're after the action, return type is not checked
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_gioco_pokemon_count_trigger
AFTER INSERT OR UPDATE OR DELETE ON pokemoningioco
FOR EACH ROW EXECUTE PROCEDURE update_gioco_pokemon_count();






-- https://it.wikipedia.org/wiki/Codice_fiscale#Generazione_del_codice_fiscale (sezione carattere di controllo)
CREATE OR REPLACE FUNCTION check_codice_fiscale_carattere_di_controllo(cod CHAR(16)) RETURNS BOOLEAN AS $$
DECLARE
    -- -1 is for filling since ASCII has spaces between '9' and 'A'
    -- Remember that PostgreSQL arrays are 1-based
    table1 constant integer[] := ARRAY [1, 0, 5, 7, 9, 13, 15, 17, 19, 21, -1, -1, -1, -1, -1, -1, -1, 1, 0, 5, 7, 9, 13, 15, 17, 19, 21,  2,  4, 18, 20, 11,  3,  6,  8, 12, 14, 16, 10, 22, 25, 24, 23];
    table2 constant integer[] := ARRAY [0, 1, 2, 3, 4,  5,  6,  7,  8,  9, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25];
    i integer := 0;
    s integer := 0;
    ch char(1) := ' ';
BEGIN
    IF char_length(cod) <> 16 THEN
        RETURN false;
    END IF;

    FOREACH ch IN ARRAY regexp_split_to_array(cod, '')
    LOOP
        IF i = 15 THEN
            RETURN ch = chr((s % 26) + ascii('A'));
        ELSIF (i & 1) = 0 THEN
            s := s + table1[ascii(ch) - ascii('0') + 1];
        ELSE
            s := s + table2[ascii(ch) - ascii('0') + 1];
        END IF;
        i := i + 1;
    END LOOP;

    RETURN NULL;
END
$$ LANGUAGE plpgsql;

ALTER TABLE doppiatore
ADD CONSTRAINT cod_fis_check
  CHECK (cod_fis ~ '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$' AND check_codice_fiscale_carattere_di_controllo(cod_fis));

