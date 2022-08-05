import re  # ,vim


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
    pattern = f"{snippet_string}\d+"
    number = re.match(pattern, snip.buffer[snip.line])
    out = 0 if number is None else float(number.group(1))
    return out

def generate_tabstops(template, before = "", join = "\n", after = "", repetitions = 1):
    # * to stand for tabstop numbers 
    for i in range(repetitions):
        f"{before}{after}"


