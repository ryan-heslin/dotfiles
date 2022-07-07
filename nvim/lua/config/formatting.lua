-- From official repository
local null_ls = require("null-ls")
local text_extensions = { ".txt", ".md", ".Rmd", ".qmd", "" }

--
-- TODO tweak source options, diagnostic options
local sources = {

    --null_ls.builtins.diagnostics.jsonlint.with({
    --prefer_local = '/usr/bin/jsonlint'}),
    null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.vint,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.formatting.latexindent,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.reorder_python_imports,
    null_ls.builtins.formatting.shellharden,
    null_ls.builtins.formatting.sqlformat,
    --null_ls.builtins.formatting.styler.with({
   --     disabled_filetypes = { "r", "rmd" },
    --}),
    null_ls.builtins.formatting.stylua.with({
        extra_args = { "--config-path", vim.fn.expand("$HOME/stylua.toml") },
    }),
    null_ls.builtins.formatting.trim_newlines,
    null_ls.builtins.formatting.trim_whitespace,
    --null_ls.builtins.diagnostics.write_good,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.proselint.with({
        filetypes = text_extensions,
    }),
    null_ls.builtins.hover.dictionary.with({
        filetypes = text_extensions,
    }),
}

null_ls.setup({
    on_attach = on_attach,
    sources = sources,
    update_on_insert = true,
})
