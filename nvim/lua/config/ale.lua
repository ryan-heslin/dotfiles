vim.g.ale_fix_on_save = 1
vim.g.ale_lint_on_save = 0
vim.g.ale_fixers = {
    --r = { "styler" },
    --rmarkdown = { "styler" },
    --rmd = { "styler" },
    ["sml"] = { "remove_trailing_lines", "trim_whitespace" },
    --python = { "isort", "black" },
}
vim.g.ale_linters = {
    --sh = { "shell" },
    --bash = { "language_server" },
    --python = { "pylint" },
    --r = { "lintr" },
    --rmd = { "lintr", "tex" },
    --quarto = { "lintr", "tex", "pylint" },
}
vim.g.ale_warn_about_trailing_whitespace = 0
vim.g.ale_warn_about_trailing_blank_lines = 0
--let g:ale_r_lintr_options='lintr::with_defaults(absolute_path_linter = absolute_path_linter(lax = FALSE),
--\ cyclocomp_linter = cyclocomp_linter(20),
--\ implicit_integer_linter = implicit_integer_linter(),
--\ line_length_linter(120),
--\ object_usage_linter = object_usage_linter(),
--\ spaces_left_parentheses_linter = spaces_left_parentheses_linter(),
--\ unneeded_concatenation_linter = unneeded_concatenation_linter()
--\ )'
--let g:ale_r_lintr_options='lintr::with_defaults()'
--highlight ALEErrorSign guifg=Red
--highlight ALEWarningSign guifg=Yellow

