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
