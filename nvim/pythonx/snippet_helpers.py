import vim, re

reference = {
    "r": {"start": "function", "end": "{"},
    "python": {"start": "def", "end": ":"},
}


def get_definition(snip):
    return (
        line - 1
        if (
            line := int(
                vim.eval("search('\\s*" + reference[snip.ft]["start"] + "(', 'bcW')")
            )
        )
        != 0
        else None
    )
