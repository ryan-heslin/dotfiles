require("conform").setup({
    formatters_by_ft = {
        bash = { "shellharden" },
        html = { "html_beautify" },
        lua = { "stylua" },
        markdown = { "markdownlint", "mdformat" },
        python = { "isort", "autoflake", "black" },
        r = { "air" },
        sql = { "sqlfluff", "sql_formatter" },
        ["*"] = { "codespell", "trim_whitespace" },
        ["_"] = { "trim_whitespace" },
    },
    default_format_opts = {
        lsp_format = "first",
    },
    format_on_save = {
        lsp_format = "first",
        timeout_ms = 1500,
    },
    format_after_save = {
        lsp_format = "first",
    },
    log_level = vim.log.levels.ERROR,
    notify_on_error = true,
    notify_no_formatters = true,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})
