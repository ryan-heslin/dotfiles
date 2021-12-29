# Produce roxygen documentation
def render_roxygen(args, signature, line):
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


# Helper to compose these tasks
def document(snip):
    # Get rid of trigger
    snip.buffer[snip.line] = re.sub("(?:\s*|^)rox", "", snip.buffer[snip.line])
    line = get_definition(snip)
    # Bail out if no match
    if line is None:
        snip.cursor.set(snip.line, snip.column)
        return None
    fun = get_function_name(line)
    args, signature = extract_args(line, fun)
    render_roxygen(args, signature, line)
