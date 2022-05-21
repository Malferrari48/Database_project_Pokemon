from typing import TYPE_CHECKING, Optional, List, Tuple, Callable

from view import View, ViewFactory, callback_choice, open_view, fixed_choice, EditDataItemView, text

if TYPE_CHECKING:
    from app import App
else:
    App = 'App'


# All of the types that we use can be decoded by postgres as strings, everyone except nulls
def db2str(x: any, keep_null: bool = False) -> Optional[str]:
    return str(x) if x is not None else (None if keep_null else '<null>')


def str2db(x: str) -> str:
    return x if x != '<null>' else None


def db_edit_home() -> ViewFactory:
    return callback_choice([
        ('Insert', open_view(select_table(insert_table))),
        ('Delete', open_view(select_table(remove_table))),
    ])


def select_table(cb: Callable[[App, str], View]) -> ViewFactory:
    def f(app: App):
        data = app.db.list_tables()
        return fixed_choice(
            data,
            lambda x: x[0],
            lambda x, y: app.stage.push(cb(app, x[0]))
        )(app)
    return f


def insert_table(app: App, table: str) -> View:
    def _insert(data: List[str]) -> int:
        with app.db.connection.cursor() as c:
            try:
                c.execute(f"INSERT INTO {table} VALUES %s", (tuple(str2db(x) for x in data),))
                c.execute("COMMIT")
            except Exception as e:
                c.execute("ROLLBACK")
                raise e

            return c.rowcount

    def try_insert(data: List[str]) -> Optional[str]:
        try:
            _insert(data)
        except Exception as e:
            return str(e)

        app.stage.pop()
        open_view(text("Insert successful!"))(app)
        return None

    columns = app.db.table_columns(table)
    columns = [(c[0], c[1], c[2] == 'YES') for c in columns]
    columns = [(c[0], db2str(c[1], not c[2]), c[2]) for c in columns]
    return TableDataEditView(app, columns, "Insert>", try_insert)


def remove_table(app: App, table: str) -> View:
    columns = app.db.table_primary_key(table)
    columns = [c[0] for c in columns]

    def _remove(data: List[str]) -> int:
        clause = ' AND '.join(f"{c}=%s" for c in columns)

        with app.db.connection.cursor() as c:
            try:
                c.execute(f"DELETE FROM {table} WHERE {clause}", data)
                c.execute("COMMIT")
                return c.rowcount
            except Exception as e:
                c.execute("ROLLBACK")
                raise e

    def try_remove(data: List[str]) -> Optional[str]:
        try:
            c = _remove(data)
        except Exception as e:
            return str(e)

        app.stage.pop()
        open_view(text(f"Deleted {c} rows!"))(app)
        return None

    cols = [(c, None, False) for c in columns]
    return TableDataEditView(app, cols, "Delete>", try_remove)


class TableDataEditView(View):
    def __init__(self, app: App, columns: List[Tuple[str, Optional[str], bool]], prompt: str,
                 callback: Callable[[List[str]], Optional[str]]):
        super().__init__(app)
        self.prompt = prompt
        self.callback = callback
        self.columns = columns
        self.data = [c[1] for c in columns]

    def show(self):
        for index, ((key, _, _), val) in enumerate(zip(self.columns, self.data)):
            print(f"{index}. {key}={val if val is not None else '<missing>'}")

        print("[g=go, b=back]")

        self.app.stage.require_input(self.prompt)

    def check_null_errors(self) -> List[str]:
        res = []
        for (key, _, nullable), val in zip(self.columns, self.data):
            if val is None:
                res.append(f"{key} is Empty")
                continue
            if not nullable and val == "<null>":
                res.append(f"{key} cannot be null")
        return res

    def on_input(self, i: str) -> Optional[str]:
        i = i.strip().lower()
        if i in ['g', 'go']:
            return self.try_go()

        try:
            k = int(i)
            if k < 0 or k >= len(self.data):
                return "Invalid item"
        except ValueError:
            k = None

        if k is None:
            try:
                k = [x[0] for x in self.columns].index(i)
            except ValueError:
                return "Invalid key"

        v = self.data[k]

        def cb(x):
            if v != x:
                self.data[k] = x

        self.app.stage.push(EditDataItemView(self.app, self.columns[k][0], v, str, cb))
        return None

    def try_go(self) -> Optional[str]:
        errs = self.check_null_errors()
        if len(errs) > 0:
            return '\n'.join(errs)

        return self.callback(self.data)

    def print_help(self):
        print("Select a key to edit (or its number), when everything is like you want just "
              "Go (g) to apply your operation, or you can always go back (b) and throw everything out")
