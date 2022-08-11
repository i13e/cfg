# https://gist.github.com/zacharyvoase/955211
import inspect
import sys


def src(obj):
    """Read the source of an object in the interpreter."""

    def highlight(source):
        try:
            import pygments
            import pygments.formatters
            import pygments.lexers
        except ImportError:
            return source
        lexer = pygments.lexers.get_lexer_by_name("python")
        formatter = pygments.formatters.terminal.TerminalFormatter()
        return pygments.highlight(source, lexer, formatter)

    import subprocess

    source = inspect.getsource(obj)
    pager = subprocess.Popen(["less", "-R"], stdin=subprocess.PIPE)
    pager.communicate(highlight(source))
    pager.wait()


def _completion():
    import os
    import atexit
    import readline

    readline.parse_and_bind("tab: complete")

    history_dir = os.path.join(os.path.expandvars("$XDG_DATA_HOME"), "python")
    if not os.path.exists(history_dir):
        os.makedirs(history_dir)

    # Support multiple executables, including virtualenvs, by keying history
    # files against the inode of the current Python executable.
    executable_inode = str(os.stat(sys.executable).st_ino)
    history_file = os.path.join(history_dir, executable_inode)

    if os.path.exists(history_file):
        readline.read_history_file(history_file)
    atexit.register(readline.write_history_file, history_file)


try:
    _completion()
    del _completion
except Exception:
    print("Couldn't get completion and history working.", file=sys.stderr)
