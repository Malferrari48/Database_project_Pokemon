from typing import TYPE_CHECKING, Tuple, Dict, Optional, Callable

from view import View
from view import callback_choice, open_view, ViewFactory, TableView, EditDataItemView


if TYPE_CHECKING:
    from app import App
else:
    App = 'App'


class EditQueryView(View):
    def __init__(self, app: App, description: str, query: str, params: Dict[(str, str)] = None):
        super().__init__(app)
        if params is None:
            params = {}
        self.description = description
        self.query = query
        self.params = params
        self.params = params

    def show(self):
        print(self.description)
        print(self.query)

        print("0. Run!")

        for index, (key, value) in enumerate(self.params.items()):
            print(f"{index}. {key}={value[0]}")

        self.app.stage.require_input("Input>")

    def on_input(self, i: str) -> Optional[str]:
        i = i.strip().lower()
        if i in ['0', 'r', 'run']:
            self.app.stage.pop()
            view = execute_and_show_query(self.app, self.query, tuple(self.params.values()))
            self.app.stage.push(view)
            return None

        try:
            k = int(i)
            if k < 1 or k > len(self.params):
                return "Invalid item"
            k = list(self.params.keys())[k - 1]
        except ValueError:
            k = None

        if k is None:
            if i in self.params:
                k = i
            else:
                return "Invalid key"

        v = self.params[k]

        def cb(x):
            self.params[k] = x

        self.app.stage.push(EditDataItemView(self.app, k, v, str, cb))
        return None

    def print_help(self):
        print("Select a number to edit the query parameters, then select 0 (or 'run') to run it!")


def execute_and_show_query(app: App, query: str, params: Tuple) -> View:
    with app.db.connection.cursor() as c:
        c.execute(query, params)
        headers = [x.name for x in c.description]
        table = c.fetchall()

    table = [[str(s) for s in xs] for xs in table]
    return TableView(app, headers, table)


def premade_query(description: str, query: str, params: Dict[str, str] = None) -> ViewFactory:
    def x(app: App):
        return EditQueryView(app, description, query, params)

    return x


def pmq_home() -> ViewFactory:
    def entry(description: str, query: str, params: Dict[str, str] = None) -> Tuple[str, Callable[[App], None]]:
        return description, open_view(premade_query(description, query, params))

    return callback_choice([
        entry(
            'Attacchi più forti della media',
            '''select * from mossa where potenza > (select avg(potenza) from mossa);'''
        ),
        entry(
            'Trovare il personaggio doppiato da doppiatori diversi nella stessa lingua e nello stesso multimedia',
            '''select dopp.*,doppiatore.nome,doppiatore.cognome,doppiatore.data_nascita 
from (select distinct d1.* from doppiaggio as d1, doppiaggio as d2
where d1.personaggio_nome=d2.personaggio_nome and
d1.personaggio_cognome=d2.personaggio_cognome and
d1.multimedia_nome=d2.multimedia_nome and
d1.multimedia_anno=d2.multimedia_anno and
d1.lingua=d2.lingua and d1.doppiatore<>d2.doppiatore) as dopp
join doppiatore on dopp.doppiatore=doppiatore.cod_fis;'''
        ),
        entry(
            'Seleziona per ogni personaggio il Pokémon che rappresenta (se esiste), il suo id, il numero di Pokémon'
            ' che possiede e il numero di comparse',
            '''select q.*,p.nome,
(select count(*) from pokemonpossesso
where personaggio_nome=q.nome and personaggio_cognome=q.cognome) as pcnt,
(select count(*) from comparsa
where personaggio_nome=q.nome and personaggio_cognome=q.cognome) as pcmp
from personaggio as q
left join pokemon as p on q.rappresenta_pokemon=p.id;'''
        ),
        entry(
            'Raggruppare i Pokémon in base alla percentuale del sesso con il quale si possono trovare',
            'select count(*) as nPokemon,pokemon.percentuale_sesso from pokemon group by pokemon.percentuale_sesso;',
        ),
        entry(
            'Individuare i Pokémon con più di un evoluzione',
            '''select da, count(*) as nEvoluzioni from evoluzione
group by da
having count(*) > 1;'''
        ),
        entry(
            'Ordinare le mosse in base alla potenza',
            '''select * from mossa order by potenza desc;'''
        ),
        entry(
            'Mostrare il doppiatore che ha doppiato un personaggio in tutte le lingue disponibili',
            '''select * from doppiatore
            where not exists ( select lingua from doppiaggio as d1
                where not exists (
                    select * from doppiaggio as d2
                    where d1.lingua=d2.lingua and doppiatore.cod_fis=d2.doppiatore
               )
            );'''
        ),
        entry(
            'Trovare il tipo predefinito di Pokémon più adatto per affrontarne un altro scelto',
            '''select confrontotipo.* from (select da, max(efficacia) as eff from confrontotipo
group by da) as parte
join confrontotipo on confrontotipo.efficacia = parte.eff and confrontotipo.da=parte.da;''',
        ),
        entry(
            'Seleziona dato un pokemon i suoi dati (nome, zona_cattura, percentuale_sesso, tipo1, tipo2),'
            ' id e nome del pokemon padre (da cui è evoluto), numero di sotto-evoluzioni e numero di personaggi'
            ' che lo rappresentano',
            '''select p1.*,p2.id,p2.nome,
(select count(*) from evoluzione e1 where e1.da=p1.id) as evolcnt,
(select count(*) from personaggio where personaggio.rappresenta_pokemon=p1.id) as rapprcnt
from pokemon p1
left join evoluzione as e ON p1.id = e.a
left join pokemon as p2 ON p2.id = e.da
order by p1.id;'''
        ),
        entry(
            'Dato il nome del gioco elencare i Pokémon leggendari presenti al suo interno',
            '''select PG.gioco, P.* from pokemoningioco as PG
right join pokemon as P ON P.id=PG.pokemon
where PG.is_leggendario=true
group by PG.gioco,P.id;'''
        ),
    ])
