import all_snippet_helpers as ash
import vim
def write_function_snippet(snip):
    """Create a snippet with a given number of function args and a body"""
    snippet_string = r"def"
    # Get number of repetitions, then remove trigger
    arity = ash.parse_snippet_count(snip, snippet_string)
    snip = ash.clean_snippet_line(snip, snippet_string)
    formals, highest_tabstop = ash.generate_tabstops(template = "${{{0}:arg}} : ${{{1}:type}}${{{2}: = None}}", repetitions = arity, offset = 1, join = ", ") 
    signature = f"def ${{1:name}}({formals}) -> ${{{highest_tabstop + 1}: None}}:" 
    snippet = "\n\t".join(( signature, f"${{{highest_tabstop + 2}:pass}}" ))
    snip.expand_anon(snippet)


