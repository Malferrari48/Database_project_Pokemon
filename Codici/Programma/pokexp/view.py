from math import ceil
from time import sleep
from typing import List, TypeVar, Generic, Optional, Callable, Tuple, Dict
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from app import App

    ViewFactory = Callable[[App], 'View']
else:
    App = 'App'
    ViewFactory = 'ViewFactory'


ERROR_SLEEP_TIME = 1.5


class Stage:
    def __init__(self, app: App, start_view: ViewFactory):
        self.app = app
        self.view_stack = []  # type: List[View]
        self.start_view = start_view
        self.accept_input_prompt = None  # type: Optional[str]
        self.nav_control = True
        self.exit_action = open_view(confirm("Do you want to quit?", lambda app: app.stage.close()))

    def reset_status(self):
        self.accept_input_prompt = None
        self.nav_control = True

    def require_input(self, prompt: str):
        self.accept_input_prompt = prompt

    def push(self, view: 'View'):
        if self.view_stack:
            self.view_stack[-1].hide()
        view.enter_stack()
        self.view_stack.append(view)

    def pop(self):
        if self.view_stack:
            last_view = self.view_stack.pop()
            if last_view is not None:
                last_view.hide()
                last_view.exit_stack()

    def _run_nav(self, t: str) -> bool:
        t = t.strip().lower()
        if not self.nav_control:
            return False

        if t in ['e', 'exit', 'esci']:
            self.exit_action(self.app)
            return True
        if t in ['b', 'back', 'indietro']:
            self.app.stage.pop()
            return True
        if t in ['?', 'help', 'aiuto']:
            self.view_stack[-1].print_help()
            input("Ok>")
            return True
        return False

    def run_sync(self):
        self.push(self.start_view(self.app))
        raw_input = None
        while self.view_stack:
            self.reset_status()
            print("\n\n\n")
            if raw_input is None:
                self.view_stack[-1].show()
            else:
                err = self.view_stack[-1].on_input(raw_input)

                if err is not None:
                    print(err)
                    sleep(ERROR_SLEEP_TIME)

            if self.accept_input_prompt is not None:
                raw_input = input(self.accept_input_prompt)

                if self._run_nav(raw_input):
                    raw_input = None
            else:
                raw_input = None

    def close(self):
        while self.view_stack:
            self.pop()


class View:
    def __init__(self, app: App):
        self.app = app
        self.replace = False

    def enter_stack(self):
        pass

    def show(self):
        pass

    # Returns error or None
    def on_input(self, t: str) -> Optional[str]:
        return None

    def print_help(self):
        print("Help not present")

    def hide(self):
        pass

    def exit_stack(self):
        pass


class SimpleTextView(View):
    def __init__(self, app: App, text: str):
        super().__init__(app)
        self.text = text

    def show(self):
        print(self.text)
        self.app.stage.require_input("Back>")

    def on_input(self, t: str) -> Optional[str]:
        self.app.stage.pop()
        return None


class ConfirmView(View):
    def __init__(self, app: App, text: str, cb: Callable[[App], None], default: Optional[bool] = None):
        super().__init__(app)
        self.replace = True
        self.text = text
        self.cb = cb
        self.default = default

    def show(self):
        print(self.text)
        self.app.stage.require_input("Y/N>")

    def on_input(self, t: str) -> Optional[str]:
        t = t.strip().lower()
        parsed = None
        if t in ['yes', 'y', 'si', 's']:
            parsed = True
        elif t in ['no', 'n', 'no']:
            parsed = False

        if parsed is None:
            parsed = self.default

        if parsed is True:
            self.cb(self.app)
            return None
        elif parsed is False:
            self.app.stage.pop()
            return None

        return "Please use Y/N"

    def print_help(self):
        print("Write 'y' or 'yes' to confirm, 'n' or 'no' to dismiss" +
              (f" (default:{'yes' if self.default else 'no'}" if self.default is not None else ''))


class EditDataView(View):
    def __init__(self, app: App, data: Dict, callback=Callable[[Dict], None],  text=""):
        super().__init__(app)
        self.callback = callback
        self.text = text
        self.data = data
        self._changed = False

    def show(self):
        print(self.text)

        for index, (key, value) in enumerate(self.data.items()):
            print(f"{index}. {key}={value[0]}")

        print("[s=save, a=apply, b=back]")
        self.app.stage.require_input("Input>")

    def _save(self) -> bool:
        if not self._changed:
            return False
        self._changed = False
        self.callback(self.data)
        return True

    def on_input(self, i: str) -> Optional[str]:
        i = i.strip().lower()
        if i in ['a', 'apply', 'applica']:
            if not self._save():
                return 'Nothing to apply'
            return None
        if i in ['s', 'save', 'salva']:
            self.app.stage.pop()
            self._save()
            return None

        try:
            k = int(i)
            if k < 0 or k >= len(self.data):
                return "Invalid item"
            k = list(self.data.keys())[k]
        except ValueError:
            k = None

        if k is None:
            if i in self.data:
                k = i
            else:
                return "Invalid key"

        v = self.data[k]

        def cb(x):
            if self.data[k][0] != x:
                self.data[k][0] = x
                self._changed = True

        self.app.stage.push(EditDataItemView(self.app, k, v[0], v[1], cb))
        return None

    def print_help(self):
        print("Select a key to edit (or its number), when everything is like you want just "
              "Apply (a) to save your work and continue editing or Save (s) to save your "
              "changes and exit, you can always go back (b) and throw everything out")


class EditDataItemView(View):
    def __init__(self, app: App, name: str, val: any, processor: Callable[[str], any], callback: Callable[[any], None]):
        super().__init__(app)
        self.callback = callback
        self.name = name
        self.val = val
        self.processor = processor

    def show(self):
        print(f"Old value: {self.val}")
        self.app.stage.require_input("New value: ")

    def on_input(self, raw: str) -> Optional[str]:
        try:
            processed = self.processor(raw)
        except Exception as e:
            # The user wants to go back (example: required int but nothing inputted)
            if raw == '':
                self.app.stage.pop()
                return None
            return f"Error {e}"

        self.callback(processed)
        self.app.stage.pop()

    def print_help(self):
        print("Input the new value to replace the old one (or type 'b' to go back)")


PAGINATION_SIZE = 10


class PaginatedView(View):
    def __init__(self, app: App, default_back=False):
        super().__init__(app)
        self.size = 0

        self.current_page = 0
        self.next_page = 0
        self._max_page = -1
        self.default_back = default_back

    def _clamp_page(self):
        if self.current_page > self._max_page:
            self.current_page = self._max_page
        elif self.current_page < 0:
            self.current_page = 0

    def enter_stack(self):
        self.size = self.get_size()
        self._max_page = ceil(self.size / PAGINATION_SIZE) - 1
        self._clamp_page()
        self.on_page_change()
        self.next_page = self.current_page

    def print_help(self):
        print("Multi-page choice, use '<' and '>' to change page,"
              " '>>' to go to the last page and '<<' to go to the first one.\n"
              "You can always use 'b' to go back and 'e' to exit")

    def show(self):
        if self.next_page != self.current_page:
            self.current_page = self.next_page
            self._clamp_page()
            self.on_page_change()
        self._render()

    def on_input(self, i: str) -> Optional[str]:
        i = i.strip().lower()
        if i == '<':
            if self.current_page > 0:
                self.next_page = self.current_page - 1
                return None
            else:
                return "There's no previous page"
        if i == '<<':
            self.next_page = 0
            return None
        if i == '>':
            if self.current_page < self._max_page:
                self.next_page = self.current_page + 1
                return None
            else:
                return "There's no next page"
        if i == '>>':
            self.next_page = self._max_page
            return None

        if self.default_back and i == '':
            self.app.stage.pop()
            return None

        return self.on_page_input(i)

    def _render(self):
        self.page_render()

        if self._max_page != 0:
            page_options = "Page: [" + ("<" if self.current_page > 0 else " ") + " " + str(self.current_page) + " " +\
                       (">" if self.current_page < self._max_page else " ") + "]"
            print(page_options)

    def on_page_change(self):
        pass

    def on_page_input(self, i: str) -> Optional[str]:
        return "Unrecognized command"

    def page_render(self):
        pass

    def get_size(self) -> int:
        return 0


class TableView(PaginatedView):
    def __init__(self, app: App, headers: List[str], table: List[List[str]]):
        super().__init__(app, default_back=True)
        self.headers = headers
        self.table = table
        self.current_items = []
        self.current_maxs = []

    def on_page_change(self):
        min_index = self.current_page * PAGINATION_SIZE
        max_index = min_index + PAGINATION_SIZE
        self.current_items = self.table[min_index:max_index]
        width = len(self.headers)
        viewed_items = [self.headers] + self.current_items
        self.current_maxs = [max(len(ci[x]) for ci in viewed_items) for x in range(width)]

    def show(self):
        super().show()
        prompt = 'Input>'
        self.app.stage.require_input(prompt)

    def on_page_input(self, i: str) -> Optional[str]:
        return "Unrecognized"

    def _print_row(self, row: List[str]):
        first = True
        for maxn, cell in zip(self.current_maxs, row):

            if first:
                first = False
            else:
                print('|', end='')

            assert maxn >= len(cell)
            print(cell + ' ' * (maxn - len(cell)), end='')
        print()

    def page_render(self):
        self._print_row(self.headers)
        for x in self.current_items:
            self._print_row(x)

    def get_size(self) -> int:
        return len(self.table)


T = TypeVar('T')


class MultipleChoiceView(Generic[T], PaginatedView):
    def __init__(self, app: App, do_not_select=False, default_back=False):
        super().__init__(app, default_back=default_back)
        self.items = []  # type: List[T]

        self.do_not_select = do_not_select

    def _populate_current(self):
        self.items = self.populate(self.current_page * PAGINATION_SIZE, PAGINATION_SIZE)
        assert len(self.items) <= PAGINATION_SIZE

    def on_page_change(self):
        self._populate_current()

    def print_help(self):
        print("Multi-page choice, use '<' and '>' to change page and the number of the item you"
              " want to select it, '>>' to go to the last page and '<<' to go to the first one.\n"
              "You can always use 'b' to go back and 'e' to exit")

    def show(self):
        super().show()
        prompt = 'Input (b=back)>' if not self.default_back else 'Back>'
        self.app.stage.require_input(prompt)

    def on_page_input(self, i: str) -> Optional[str]:
        i = i.strip().lower()

        if self.do_not_select:
            return "Please change page or go back(b)"

        try:
            i = int(i)
        except ValueError:
            return "Please use an integer"
        if i < 0 or i >= self.size:
            return "Invalid item"

        if (i // PAGINATION_SIZE) == self.current_page:
            item = self.items[i % PAGINATION_SIZE]
        else:
            item = self.populate(i, 1)[0]
        self.select(item, i)
        return None

    def page_render(self):
        for [index, item] in enumerate(self.items):
            print("{}: {}".format(index + self.current_page * PAGINATION_SIZE, self.print(item, index)))

    def get_size(self) -> int:
        return 0

    def populate(self, skip: int, limit: int) -> List[T]:
        return []

    def print(self, item: T, index: int) -> str:
        pass

    def select(self, item: T, index: int):
        pass


M = TypeVar('M')
class FixedMultipleChoiceView(MultipleChoiceView[M]):
    def __init__(self, app: App, choices: List[M], printer: Callable[[M], str],
                 callback: Optional[Callable[[M, App], None]], prompt: Optional[str] = None, default_back=False):
        super().__init__(app, default_back=default_back)
        self.prompt = prompt
        self.printer = printer
        self.choices = choices
        self.callback = callback
        self.do_not_select = callback is None

    def get_size(self) -> int:
        return len(self.choices)

    def populate(self, skip: int, limit: int) -> List[M]:
        last = min(skip + limit, len(self.choices))
        return self.choices[skip:last]

    def _render(self):
        if self.prompt is not None:
            print(self.prompt)
        super()._render()

    def print(self, item: M, index: int) -> str:
        return self.printer(item)

    def select(self, item: M, index: int):
        self.callback(item, self.app)


def fixed_choice(data: List[M], printer: Callable[[M], str], callback: Optional[Callable[[M, App], None]],
                 prompt: Optional[str] = None, default_back=False):
    def create(app: App):
        return FixedMultipleChoiceView(
            app,
            data,
            printer,
            callback,
            prompt=prompt,
            default_back=default_back
        )
    return create


def callback_choice(data: List[Tuple[str, Callable[[App], None]]], prompt: Optional[str] = None, add_back=True,
                    default_back=False):
    if add_back and not default_back:
        data = data + [('Indietro', go_back)]

    def create(app: App):
        return FixedMultipleChoiceView(
            app,
            data,
            lambda x: x[0],
            lambda x, y: x[1](y),
            prompt=prompt,
            default_back=default_back
        )
    return create


def open_view(factory: ViewFactory) -> Callable[[App], None]:
    def wrapper(app: App):
        view = factory(app)
        app.stage.push(view)
    return wrapper


def go_back(app: App):
    app.stage.pop()


def text(t: str) -> ViewFactory:
    def create(app: App):
        return SimpleTextView(app, t)
    return create


def confirm(t: str, cb: Callable[[App], None]) -> ViewFactory:
    def create(app: App):
        return ConfirmView(app, t, cb)
    return create
