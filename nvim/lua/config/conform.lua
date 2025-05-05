require("conform").setup({
    -- Map of filetype to formatters
    formatters_by_ft = {
        bash = { "shellharden" },
        html = { "html_beautify" },
        lua = { "stylua" },
        markdown = { "markdownlint", "mdformat" },
        -- Conform will run multiple formatters sequentially
        -- You can use a function here to determine the formatters dynamically
        python = { "isort", "autoflake", "black" },
        r = { "air" },
        sql = { "sqlfluff", "sql_formatter" },
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell", "trim_whitespace" },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
    },
    -- Set this to change the default values when calling conform.format()
    -- This will also affect the default values for format_on_save/format_after_save
    default_format_opts = {
        lsp_format = "first",
    },
    -- If this is set, Conform will run the formatter on save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = "first",
        timeout_ms = 1500,
    },
    -- If this is set, Conform will run the formatter asynchronously after save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_after_save = {
        lsp_format = "first",
    },
    -- Set the log level. Use `:ConformInfo` to see the location of the log file.
    log_level = vim.log.levels.ERROR,
    -- Conform will notify you when a formatter errors
    notify_on_error = true,
    -- Conform will notify you when no formatters are available for the buffer
    notify_no_formatters = true,
    -- Custom formatters and overrides for built-in formatters
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})
