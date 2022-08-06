import re  # ,vim
import vim
from functools import reduce


def get_filetype():
    return  # vim.eval("&filetype")


reference = {
    "r": {"start": "function", "end": "{"},
    "python": {"start": "def", "end": ":"},
}

comments = {"rmd": {"prefix": "<!--", "suffix": "-->"}}

# Surround visual selection with prefix and suffix tab, optionally padding with newlines
def surround_visual(
    snip, prefix=None, suffix=None, prefix_newline=False, suffix_newline=False
):
    if visual := snip.visual_text == "":
        return
    if prefix is None:
        prefix = comments[snip.ft]["prefix"]
    prefix = prefix + "\n" if prefix_newline else ""
    if suffix is None:
        suffix = comments[snip.ft]["suffix"]
    suffix = suffix + "\n" if suffix_newline else ""
    # snip.visual_mode
    snip.expand_anon(suffix + visual + suffix)


def get_definition(snip):
    return (
        line - 1
        if (
            line := int(
                # vim.eval("search('\\s*" + reference[snip.ft]["start"] + "(', 'bcW')")
            )
        )
        != 0
        else None
    )


def parse_snippet_count(snip, snippet_string):
    """Return number appended to a given snippet string in buffer, 0 if not found"""
    pattern = r"\s*" + snippet_string +r"(\d+)"
    number = re.match(pattern, snip.buffer[snip.line])
    out = 0 if number is None else int(number.group(1))
    return out

def clean_snippet_line(snip, snippet_string):
    """Strip buffer line of snippet invocation (e.g., def2)"""
    snip.buffer[snip.line] = re.sub(snippet_string + r"\d+", "", snip.buffer[snip.line])
    return snip

def generate_tabstops(template : str,  join = "\n",  repetitions = 1, offset = 0):
    """Repeats a tabstop template a given number of times, incrementing numbers appropriately"""
    # Must use double {{}} for format, e.g. ${{{0}:foo}}
    if repetitions == 0:
        return ( "", 0 )
    tabstops = len(re.findall(r"\d+", template))
    # Get start and end + 1 numbers for each repetition
    ranges = range(offset + 1, offset + tabstops * (repetitions + tabstops -1), tabstops)
    out = []
    # For each repetition, format template with integers from start to end
    for i in range(len(ranges) - 1):
        out.append(template.format(*range(ranges[i], ranges[i+1])))
    # Join with chosen string
    return join.join(out), tabstops * repetitions


#class Snippet
# Snippet manager class TODO
# def parse_snippet_line
# def clear_snippet_line
# def write_snippet

def name(arg : type = None, arg : type = None, arg : type = None) ->  None:
    pass
