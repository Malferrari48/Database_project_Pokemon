-- 1) Attacchi più forti della media
-- 2) Trovare il personaggio doppiato da doppiatori diversi nella stessa lingua e nello stesso multimedia
-- 3) Seleziona per ogni personaggio il Pokémon che rappresenta (se esiste), il suo id, il numero di Pokémon che possiede e il numero di comparse
-- 4) Raggruppare i Pokémon in base alla percentuale del sesso con il quale si possono trovare
-- 5) Individuare i Pokémon con più di un evoluzione
-- 6) Ordinare le mosse in base alla potenza
-- 7) Mostrare il doppiatore che ha doppiato un personaggio in tutte le lingue disponibili
-- 8) Trovare il tipo predefinito di Pokémon più adatto per affrontarne un altro scelto
-- 9) Seleziona dato un pokemon i suoi dati (nome, zona_cattura, percentuale_sesso, tipo1, tipo2), id e nome del Pokémon padre (da cui
--    è evoluto), numero di sotto-evoluzioni e numero di personaggi che lo rappresentano
-- 10) Dato il nome del gioco elencare i Pokémon leggendari presenti al suo interno

-- 1)

select * from mossa
where potenza > (select avg(potenza) from mossa);

-- 2)

select dopp.*,doppiatore.nome,doppiatore.cognome,doppiatore.data_nascita 
from (select distinct d1.* from doppiaggio as d1, doppiaggio as d2
where d1.personaggio_nome=d2.personaggio_nome and
d1.personaggio_cognome=d2.personaggio_cognome and
d1.multimedia_nome=d2.multimedia_nome and
d1.multimedia_anno=d2.multimedia_anno and
d1.lingua=d2.lingua and d1.doppiatore<>d2.doppiatore) as dopp
join doppiatore on dopp.doppiatore=doppiatore.cod_fis;

-- 3)

select q.*,p.nome,
(select count(*) from pokemonpossesso
where personaggio_nome=q.nome and personaggio_cognome=q.cognome) as pcnt,
(select count(*) from comparsa
where personaggio_nome=q.nome and personaggio_cognome=q.cognome) as pcmp
from personaggio as q
left join pokemon as p on q.rappresenta_pokemon=p.id;

-- 4)

select count(*) as nPokemon,pokemon.percentuale_sesso from pokemon
group by pokemon.percentuale_sesso;

-- 5)

select da, count(*) as nEvoluzioni from evoluzione
group by da
having count(*) > 1;

-- 6)

select * from mossa
order by potenza desc;

-- 7)

select * from doppiatore
where not exists ( select lingua from doppiaggio as d1
    where not exists (
        select * from doppiaggio as d2
        where d1.lingua=d2.lingua and doppiatore.cod_fis=d2.doppiatore
    )
);

-- 8)

select confrontotipo.* from (select da, max(efficacia) as eff from confrontotipo
group by da) as parte
join confrontotipo on confrontotipo.efficacia = parte.eff and confrontotipo.da=parte.da;


-- 9)

select p1.*,p2.id,p2.nome,
(select count(*) from evoluzione e1 where e1.da=p1.id) as evolcnt,
(select count(*) from personaggio where personaggio.rappresenta_pokemon=p1.id) as rapprcnt
from pokemon p1
left join evoluzione as e ON p1.id = e.a
left join pokemon as p2 ON p2.id = e.da
order by p1.id;

-- 10)

select PG.gioco, P.* from pokemoningioco as PG
join pokemon as P ON P.id=PG.pokemon
where PG.is_leggendario=true
order by PG.gioco,P.id;
