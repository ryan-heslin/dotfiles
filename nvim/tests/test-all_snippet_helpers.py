import all_snippet_helpers
print(generate_tabstops("${{{0}:arg}} : ${{{1}:type}}", repetitions = 2, join = ", "))
print(generate_tabstops("${{{0}:arg}} : ${{{1}:${{{2}: = None}}}}", repetitions = 2, join = ", "))
print(generate_tabstops("${{{0}:arg}} : ${{{1}:${{{2}: = None}}}}", repetitions = 2, join = ", ", offset = 1))
