import re
from regex import sub as rsub
from all_snippet_helpers import *

# Produce roxygen documentation
def render_roxygen(snip, args, signature, line):
    mark = "#'"
    # Only generate argument tabstops if function actually has them
    args_text = (
        [mark + " @param " + arg + " $" + str(num + 6) for num, arg in enumerate(args)]
        if (offset := len(args))
        else []
    )
    text = (
        [
            mark + " ${1:${2:@inheritParams ${3:}}}",
            mark,
            mark + " @title ${4:}",
            mark + " @description ${5:}",
        ]
        + args_text
        + [mark + " @details $" + str(offset + 6)]
        + [
            mark,
            mark + " @return $" + str(offset + 7),
            mark + " ${" + str(offset + 8) + ":@export}",
            mark,
            mark + " @examples",
            mark,
        ]
    )
    vim.current.window.cursor = [max(line, 1), 0]
    snip.expand_anon("\n" + "\n".join(text) + "\n")


def get_function_name(snip, line):
    fun_line = line if re.match("[^<]+<-", snip.buffer[snip.line]) else line - 1
    fun = re.match(r"^\s*([^ ]+).*", snip.buffer[fun_line])
    return fun.group(1) if fun else None


def extract_args(snip, start, fun):
    line = snip.buffer[start]
    # Handle signatures that flow ove multiple lines: not as annoying as feared!
    if not re.match(r"\)\s*\{\s*$", line):
        # stop = int(vim.eval("searchpairpos('function(', '', ')\\s*{\\s*$')")[0])
        stop = int(vim.eval("search(')\\s*{\\s*$')"))
        vim.command("echom '" + str(stop) + "'")
        line = " ".join(
            [line] + [snip.buffer[i].lstrip() for i in range(start + 1, stop)]
        )
        # snip.cursor.set(*orig)
    line = re.sub(r"^[\w.]*\s*(?:<-)?\s*function\s*\(", "", line)
    signature = str(fun) + "(" + re.sub(r"\s*\{\s*$", "", line)
    line = rsub(r"[\w.]*\((((?>[^()]+)|(?R))*)\)", "", line)
    line = re.sub(r"\).*$", "", line)
    # vim.command('echo "' + str(line) + '"')
    args = re.findall(r"(?:^|,)\s*([\w\.]+)", line)
    return args, signature


# Helper to compose these tasks
def document(snip):
    # Get rid of trigger
    line = get_definition(snip)
    # Bail out if no match
    if line is None:
        snip.cursor.set(snip.line, snip.column)
        return None
    fun = get_function_name(snip, line)
    args, signature = extract_args(snip, line, fun)
    render_roxygen(snip, args, signature, line)
