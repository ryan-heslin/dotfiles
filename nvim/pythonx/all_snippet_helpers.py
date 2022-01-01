import vim
import re

reference = {
    "r": {"start": "function", "end": "{"},
    "python": {"start": "def", "end": ":"},
}


def get_filetype():
    return vim.eval("&filetype")


def get_definition(snip):
    return (
        line - 1
        if (
            line := int(
                vim.eval(
                    "search('\\s*" + reference[get_filetype()]["start"] + "(', 'bcW')"
                )
            )
        )
        != 0
        else None
    )
