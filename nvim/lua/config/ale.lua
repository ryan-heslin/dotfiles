vim.g.ale_fix_on_save = 1
vim.g.ale_lint_on_save = 0
vim.g.ale_fixers = {
    r = { "styler" },
    rmarkdown = { "styler" },
    rmd = { "styler" },
    ["*"] = { "remove_trailing_lines", "trim_whitespace" },
    python = { "isort", "black" },
}
vim.g.ale_linters = {
    sh = { "shell" },
    bash = { "language_server" },
    python = { "pylint" },
    r = { "lintr" },
    rmd = { "lintr", "tex" },
    quarto = { "lintr", "tex", "pylint" },
}
vim.g.ale_warn_about_trailing_whitespace = 0
vim.g.ale_warn_about_trailing_blank_lines = 0
