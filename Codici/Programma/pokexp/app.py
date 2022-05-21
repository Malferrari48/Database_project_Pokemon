from typing import Optional

import psycopg2

from database import connect, Database
from menu import db_home
from view import Stage, callback_choice, open_view, text, View, EditDataView

OTPIONS_FILE = 'connection.txt'
DEFAULT_OPTIONS = 'dbname=pokemon user=postgres password=password connect_timeout=3 port=5432 host=localhost'
README = '''Use '?' to get help of the current view, 'b' to go back and 'e' to exit'''


def db_conn_details(app: 'App') -> View:
    if app.db is not None:
        prefix = 'Connection: ok'
    else:
        prefix = 'Connection: error\n' + str(app.db_error)

    return callback_choice([
        ("Riprova", lambda a: a.reconnect()),
    ], prefix, default_back=True)(app)


def options(app: 'App') -> View:
    def parse_args():
        return {a[0]: a[1] for a in map(lambda x: x.split('=', 2), app.connection_args.split(' '))}

    try:
        d = parse_args()
    except:
        print("Invalid file args")
        app.save_args_and_reconnect(DEFAULT_OPTIONS)
        d = parse_args()

    e = {
        'dbname': [d['dbname'], str],
        'user': [d['user'], str],
        'password': [d['password'], str],
        'connect_timeout': [d['connect_timeout'], int],
        'port': [d['port'], int],
        'host': [d['host'], str]
    }

    def on_change(x):
        app.save_args_and_reconnect(' '.join(map(lambda a: f'{a[0]}={a[1][0]}', x.items())))
        app.stage.push(db_conn_details(app))

    return EditDataView(
        app,
        e,
        on_change
    )


def explore(app: 'App') -> View:
    if app.db is None:
        app.reconnect()

    if app.db is None:
        return text('Db connection failed')(app)
    else:
        return db_home()(app)


def read_args() -> str:
    try:
        with open(OTPIONS_FILE, 'r') as f:
            return f.read()
    except OSError:
        return DEFAULT_OPTIONS


class App:
    def __init__(self):
        home_view = callback_choice([
            ('Explore', open_view(explore)),
            ('Readme', open_view(text(README))),
            ('Connection', open_view(options)),
            ('Credits', open_view(text("Made by:\n- Malferrari Francesco\n- Sitta Lucrezia\n- Rossi Lorenzo"))),
        ])
        self.stage = Stage(self, home_view)
        self.connection_args = read_args()
        self.db = None  # type: Optional[Database]
        self.db_error = None  # type: Optional[psycopg2.Error]

        self.reconnect()

    def reconnect(self):
        if self.db is not None:
            self.db.stop()
            self.db = None

        try:
            self.db = connect(self.connection_args)
            self.db_error = None

            print(f"Connected\ndb: {self.db.version()}")
        except psycopg2.Error as e:
            print("Failed to connect to the server\n")
            self.db_error = e

    def save_args_and_reconnect(self, args):
        self.connection_args = args
        with open(OTPIONS_FILE, 'wt') as f:
            f.write(args)
        self.reconnect()

    def start(self):
        try:
            self.stage.run_sync()
        except (KeyboardInterrupt, EOFError):
            print("\nHey! You can just type 'exit' from almost anywhere")
        print("Bye bye")
