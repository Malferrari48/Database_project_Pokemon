from typing import TYPE_CHECKING, Tuple

from database import MultimediaId, CharacterId
from editdb import db_edit_home
from pmq import pmq_home
from view import callback_choice, open_view, text, fixed_choice, ViewFactory

if TYPE_CHECKING:
    from view import View
    from app import App
else:
    View = 'View'
    App = 'App'


def db_home() -> ViewFactory:
    return callback_choice([
        ('Games', open_view(games)),
        ('Pokemons', open_view(pokemons)),
        ('Multimedias', open_view(multimedias)),
        ('Pre-made queries', open_view(pmq_home())),
        ('Edit queries', open_view(db_edit_home())),
    ])


def games(app: App) -> View:
    data = app.db.list_games()
    return fixed_choice(
        data,
        lambda x: f"{x[0]} ({x[1]})",
        lambda x, y: app.stage.push(show_game(app, x[0]))
    )(app)


def pokemons(app: App) -> View:
    data = app.db.list_pokemons()
    return fixed_choice(
        data,
        lambda x: f"{x[0]}",
        lambda x, y: app.stage.push(show_pokemon(app, x[1]))
    )(app)


def multimedias(app: App) -> View:
    data = app.db.list_multimedias()
    return fixed_choice(
        data,
        lambda x: f"{x[0]} ({x[1]})",
        lambda x, y: app.stage.push(show_multimedia(app, x))
    )(app)


def show_game(app: App, game: str) -> View:
    data = app.db.game_details(game)
    s = f'''Nome: {data[0]}
Data rilascio: {data[1]}
Casa sviluppo: {data[2]}
Pokemon presenti: {data[3]}'''
    return callback_choice([
        ('Visualizza pokemon', open_view(lambda a: show_game_pokemons(a, game))),
    ], prompt=s)(app)


def show_game_pokemons(app: App, game: str) -> View:
    pokemons = app.db.game_pokemons(game)
    return fixed_choice(
        pokemons,
        lambda x: x[1] + (" (leggendario)" if x[2] else ""),
        lambda x, y: app.stage.push(show_pokemon(app, x[0]))
    )(app)


def show_pokemon(app: App, pokemon: int) -> View:
    data = app.db.pokemon_details(pokemon)

    if data is None:
        return text('Not found')(app)

    sesso = data[3]
    sesso = 'Sconosciuto' if sesso is None else f'''{sesso}% maschio, {100 - sesso}% femmina'''
    evoluzione = '' if data[6] is None else f"\nEvoluto da: {data[7]}"
    arr_evoluzione = [
        (data[7], open_view(lambda a: show_pokemon(a, data[6]))),
    ] if data[6] is not None else []

    arr_evoluzioni = [
        (f'Evoluzioni ({data[8]})', open_view(lambda a: show_pokemon_evolutions(a, pokemon)))
    ] if data[8] > 0 else []

    arr_personaggi = [
        (f'Personaggi rappresentati ({data[9]})', open_view(lambda a: show_pokemon_representations(a, pokemon)))
    ] if data[9] > 0 else []

    s = f'''\t {data[0]}
{data[1]}
National Pokedex: {pokemon}
Trovabile in: {data[2]}
Sesso: {sesso}
Tipo: {data[4]} {data[5] if data[5] is not None else ''}{evoluzione}'''
    return callback_choice([
        ('Mosse', open_view(lambda a: show_pokemon_moves(a, pokemon))),
        ('Cerca in Pokemon GO', open_view(lambda a: show_pokemon_go_zones(a, pokemon)))] +
                           arr_evoluzione + arr_evoluzioni + arr_personaggi + [
        ('Comparse multimediali', open_view(lambda a: show_pokemon_multimedias(a, pokemon))),
        ('Appartenenza personaggi', open_view(lambda a: show_pokemon_characters(a, pokemon)))
    ], prompt=s)(app)


def show_pokemon_moves(app: App, pokemon: int) -> View:
    moves = app.db.pokemon_moves(pokemon)
    return fixed_choice(
        moves,
        lambda x: x[0] + (" (default)" if x[1] else ""),
        lambda x, y: app.stage.push(show_move(app, x[0]))
    )(app)


def show_pokemon_characters(app: App, pokemon: int) -> View:
    data = app.db.pokemon_characters(pokemon)
    return fixed_choice(
        data,
        lambda x: f"{x[0]} {x[1] if x[1] is not None else ''}",
        lambda x, y: app.stage.push(show_character(app, x))
    )(app)


def show_pokemon_evolutions(app: App, pokemon: int) -> View:
    data = app.db.pokemon_evolutions(pokemon)
    return fixed_choice(
        data,
        lambda x: f"{x[0]}",
        lambda x, y: app.stage.push(show_pokemon(app, x[1]))
    )(app)


def show_pokemon_representations(app: App, pokemon: int) -> View:
    data = app.db.pokemon_representations(pokemon)
    return fixed_choice(
        data,
        lambda x: f"{x[0]} {x[1] if x[1] is not None else ''}",
        lambda x, y: app.stage.push(show_character(app, x))
    )(app)


def show_pokemon_multimedias(app: App, pokemon: int) -> View:
    data = app.db.pokemon_multimedias(pokemon)
    return fixed_choice(
        data,
        lambda x: f"{x[0]} ({x[1]})",
        lambda x, y: app.stage.push(show_multimedia(app, x))
    )(app)


def show_pokemon_go_zones(app: App, pokemon: int):
    moves = app.db.pokemon_go_locations(pokemon)
    return fixed_choice(
        moves,
        lambda x: f"{x[0]} {x[1]} {x[2]}",
        None
    )(app)


def show_move(app: App, move: str) -> View:
    data = app.db.move_details(move)

    if data is None:
        return text('Not found')(app)

    s = f'''\t {move} {'TM' if data[1] else ''}
Tipo: {data[0]}
Categoria: {data[2]}
Potenza: {data[3]}'''
    return callback_choice([
        ('Pokemon che la imparano', open_view(lambda a: show_move_pokemons(a, move)))
    ], prompt=s)(app)


def show_move_pokemons(app: App, move: str) -> View:
    moves = app.db.move_pokemons(move)
    return fixed_choice(
        moves,
        lambda x: x[1] + (" (default)" if x[2] else ""),
        lambda x, y: app.stage.push(show_pokemon(app, x[0]))
    )(app)


def show_dubber_appearances(app: App, cf: str):
    data = app.db.dubber_appearances(cf)
    return fixed_choice(
        data,
        lambda x: f"{x[0]} {x[1] if x[1] is not None else ''} - {x[2]} ({x[3]}) [{x[4]}]",
        lambda x, y: app.stage.push(show_appaerance(app, (x[2], x[3]), (x[0], x[1])))
    )(app)


def show_dubber(app: App, cf: str) -> View:
    data = app.db.dubber_details(cf)

    if data is None:
        return text('Not found')(app)

    s = f'''\t{data[0]} ({data[1]})
Data di nascita: {data[2]}
CF: {cf}
Doppiaggi conosciuti: {data[3]}'''
    return callback_choice([
        ('Doppiaggi', open_view(lambda a: show_dubber_appearances(a, cf)))
    ], prompt=s)(app)


def show_appearance_dubbings(app: App, mm: MultimediaId, ch: CharacterId) -> View:
    data = app.db.apperance_dubbings(mm, ch)
    return fixed_choice(
        data,
        lambda x: f"{x[2]} {x[3]} ({x[0]})",
        lambda x, y: app.stage.push(show_dubber(app, x[1]))
    )(app)


def show_character_pokemons(app: App, ch: CharacterId) -> View:
    data = app.db.character_pokemons(ch)
    return fixed_choice(
        data,
        lambda x: f"{x[0]}",
        lambda x, y: app.stage.push(show_pokemon(app, x[1]))
    )(app)


def show_character_appearances(app: App, ch: CharacterId) -> View:
    data = app.db.character_appearances(ch)
    return fixed_choice(
        data,
        lambda x: f"{x[0]} ({x[1]})",
        lambda x, y: app.stage.push(show_appaerance(app, x, ch))
    )(app)


def show_character(app: App, ch: CharacterId) -> View:
    data = app.db.character_details(ch)

    pokemons_array = [
        ('Squadra pokemon', open_view(lambda a: show_character_pokemons(a, ch)))
    ] if data[2] > 0 else []

    appearances_array = [
        ('Comparse', open_view(lambda a: show_character_appearances(a, ch)))
    ] if data[3] > 0 else []

    rappr_array = [
        (data[0], open_view(lambda a: show_pokemon(app, data[1])))
    ] if data[0] is not None else []

    s = f'''\t{ch[0]} {ch[1] if ch[1] is not None else ''}''' +\
        (f'\nRappresenta: {data[0]}' if data[0] is not None else '') +\
        f'\nPokemon: {data[2]}\nComparse: {data[3]}'

    return callback_choice(
        pokemons_array + appearances_array + rappr_array,
        prompt=s
    )(app)


def show_appaerance(app: App, mm: MultimediaId, ch: CharacterId) -> View:
    s = f'''Personaggio: {ch[0]} {ch[1] if ch[1] is not None else ''}
Multimedia: {mm[0]} ({mm[1]})'''
    return callback_choice([
        ('Personaggio', open_view(lambda a: show_character(a, ch))),
        ('Multimedia', open_view(lambda a: show_multimedia(a, mm))),
        ('Doppiaggi', open_view(lambda a: show_appearance_dubbings(a, mm, ch)))
    ], prompt=s)(app)


def show_multimedia_appearances(app: App, mm: MultimediaId) -> View:
    data = app.db.multimedia_appearances(mm)
    return fixed_choice(
        data,
        lambda x: f"{x[0]} {x[1] if x[1] is not None else ''}",
        lambda x, y: app.stage.push(show_appaerance(app, mm, x))
    )(app)
    pass


def show_multimedia_pokemons(app: App, mm: Tuple[str, int]) -> View:
    data = app.db.multimedia_pokemons(mm)
    return fixed_choice(
        data,
        lambda x: f"{x[1]}",
        lambda x, y: app.stage.push(show_pokemon(app, x[0]))
    )(app)


def show_multimedia(app: App, mm: Tuple[str, int]) -> View:
    data = app.db.multimedia_details(mm)

    if data is None:
        return text('Not found')(app)

    s = f'''\t{mm[0]} ({mm[1]})
Casa di Produzione: {data[0]}
Creatore: {data[1]}
Tipo: {data[2]}'''
    return callback_choice([
        ('Comparse personaggi', open_view(lambda a: show_multimedia_appearances(a, mm))),
        ('Comparse pokemon', open_view(lambda a: show_multimedia_pokemons(a, mm)))
    ], prompt=s)(app)
