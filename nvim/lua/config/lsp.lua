local exclusions = U.utils.set({ "r", "lua" })
local do_format = function()
    vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
end

local create_formatter = function(excludes)
    -- Disable null-ls formatting for certain filetypes
    excludes = U.utils.set(excludes)
    local filter = function(client)
        return not (
            client.name == "null-ls"
            and excludes[vim.api.nvim_buf_get_option(0, "filetype")]
        )
    end

    return function()
        vim.lsp.buf.format({
            async = false,
            timeout_ms = 10000,
            filter = filter,
        })
    end
end

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1f2335" })
    end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "white", bg = "#1f2335" })
    end,
})

local formatter = create_formatter(exclusions)

local formatting = vim.api.nvim_create_augroup("LspFormatting", {})
local format_diagnostic = function(diagnostic)
    --They seem to be indices of global diagnostics table?
    if type(diagnostic) == "number" then
        diagnostic = vim.diagnostic.get(0)[diagnostic]
    end
    if type(diagnostic) == "nil" then
        return ""
    end
    -- Prepend type prefix
    local lookup = { [1] = "E", [2] = "W", [3] = "I", [4] = "H" }
    local code = lookup[diagnostic.severity] .. ": " or ""
    local message = code .. diagnostic.message

    local win_width = vim.api.nvim_win_get_width(0)
    -- Space in window right of last character on line
    local space = win_width - vim.fn.col("$")

    -- If not enough space, show diagnostic in float instead
    local length = string.len(message)
    if space < length + 3 then
        -- Constrain window width to reasonable range
        local width = U.utils.clamp(win_width - 5, 5, 40)
        -- Allocate one row for each line of formatted text
        local height = math.ceil(length / width) + 2
        vim.lsp.util.open_floating_preview(
            { "Diagnostic:", message, string.format("(%s)", diagnostic.source) },
            vim.bo.syntax,
            {
                height = height,
                width = width,
                wrap = true,
                max_width = width,
                max_height = height,
                pad_top = 0,
                pad_bottom = 1,
                close_events = { "CursorMoved", "BufHidden" },
                row = diagnostic.line or vim.fn.line("."),
                col = 0,
                border = "single",
                noautocmd = true,
            }
        )
        return ""
    end
    return message
end

on_attach = function(client, bufnr)
    --if  vim.b.zotcite_omnifunc then
    --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', [[zotcite#CompleteBib]])
    --else
    --vim.api.nvim_buf_set_option(bufnr, "omnifunc", vim.v.lua.vim.lsp.omnifunc)
    --or is it vim.v.lua.vim.lsp.lua.R_set_omnifunc
    --end

    vim.wo.signcolumn = "yes"
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set({ "n", "v" }, "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set({ "n", "v" }, "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set({ "n", "v" }, "K", vim.lsp.buf.hover, opts)
    vim.keymap.set({ "n", "v" }, "<leader>gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set({ "n", "v" }, "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set(
        { "n", "v" },
        "<leader>wa",
        vim.lsp.buf.add_workspace_folder,
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>wr",
        vim.lsp.buf.remove_workspace_folder,
        opts
    )
    vim.keymap.set({ "n", "v" }, "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set({ "n", "v" }, "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "gr", vim.lsp.buf.references, opts)
    vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
    vim.keymap.set({ "n", "v" }, "<leader>e", function()
        vim.diagnostic.open_float(nil, {
            header = "Line Diagnostics",
            --format = format_diagnostic,
            scope = "line",
        })
    end, opts)
    vim.keymap.set({ "n", "v" }, "<leader>so", function()
        require("telescope.builtin").lsp_document_symbols()
    end, opts)
    vim.api.nvim_create_user_command(
        "Format",
        formatter,
        { desc = "Format current buffer with attached language server" }
    )

    -- Open float on cursor hold
    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local float_opts = {
                focusable = false,
                close_events = {
                    "BufLeave",
                    "CursorMoved",
                    "InsertEnter",
                    "FocusLost",
                },
                border = "rounded",
                source = "always",
                prefix = " ",
                scope = "cursor",
            }
            vim.diagnostic.open_float(nil, float_opts)
        end,
    })

    -- From https://github.com/martinsione/dotfiles/blob/master/src/.config/nvim/lua/modules/config/nvim-lspconfig/on-attach.lua
    -- Don't use null-ls to format for filetypes with formatters already set
    if client then
        if
            client.supports_method("textDocument/formatting")
            and not (
                client.name == "null-ls"
                and exclusions[vim.api.nvim_buf_get_option(0, "filetype")]
            )
        then
            vim.api.nvim_clear_autocmds({ group = formatting, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = formatting,
                buffer = bufnr,
                callback = do_format,
            })
        end

        if client.server_capabilities.documentHighlightProvider then
            local ls_highlight = vim.api.nvim_create_namespace("ls_highlight")
            vim.api.nvim_set_hl(ls_highlight, "LspReferenceRead", {
                bold = true,
                --ctermbg = "yellow",
                fg = "SlateBlue",
                bg = "#808000",
            })
            vim.api.nvim_set_hl(ls_highlight, "LspReferenceText", {
                bold = true,
                --ctermbg = "red",
                fg = "SlateBlue",
                bg = "MidnightBlue",
            })
            vim.api.nvim_set_hl(ls_highlight, "LspReferenceWrite", {
                bold = true,
                --ctermbg = "yellow",
                fg = "DarkSlateBlue",
                bg = "MistyRose",
            })

            -- Trigger document highlighting on holding cursor
            local doc_highlight =
                vim.api.nvim_create_augroup("LSPDocumentHighlight", {})
            vim.api.nvim_clear_autocmds({
                group = doc_highlight,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("CursorHold", {
                callback = vim.lsp.buf.document_highlight,
                group = doc_highlight,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("CursorHoldI", {
                callback = vim.lsp.buf.document_highlight,
                group = doc_highlight,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                callback = vim.lsp.buf.clear_references,
                group = doc_highlight,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("CursorMovedI", {
                callback = vim.lsp.buf.clear_references,
                group = doc_highlight,
                buffer = bufnr,
            })
        end
    end
    --
end

-- Ensuring relevant server paths are known
local mason_dir = U.utils.join_paths({ vim.fn.stdpath("data"), "mason", "bin" })
local lua_dir = U.utils.join_paths({ mason_dir, "lua-language-server" })
local path = vim.fn.split(package.path, ";")
-- Maybe add failsafe here
local bashls = U.utils.join_paths({ mason_dir, "bash-language-server" })
table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")

local servers = {
    bashls = { filetypes = { "sh", "bash" }, cmd = bashls },
    clangd = {},
    html = {},
    jsonls = {},
    lua_ls = {
        Lua = {
            cmd = { lua_dir .. "/bin", "-E", lua_dir .. "/bin/main.lua" },
            IntelliSense = { traceBeSetted = true },
            color = { mode = "Grammar" },
            completion = {
                keywordSnippet = "Replace",
                callSnippet = "Replace",
            },
            runtime = {
                version = "LuaJIT",
                path = path,
            },
            diagnostics = {
                globals = { "vim" },
                disable = { "lowercase-global" },
            },
            workspace = {
                maxPreload = 10000,
                preloadFileSize = 5000,
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [U.utils.join_paths({ vim.fn.stdpath("config"), "lua" })] = true,
                },
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
    marksman = {},
    pyright = { filetypes = { "python", "quarto" } },
    r_language_server = {
        filetypes = { "r", "rmd", "quarto" },
    },
    racket_langserver = { filetypes = { "racket", "scheme" } },
    ruby_lsp = {},
    ts_ls = {},
}
local border = {
    { "🭽", "FloatBorder" },
    { "▔", "FloatBorder" },
    { "🭾", "FloatBorder" },
    { "▕", "FloatBorder" },
    { "🭿", "FloatBorder" },
    { "▁", "FloatBorder" },
    { "🭼", "FloatBorder" },
    { "▏", "FloatBorder" },
}

vim.diagnostic.config({
    update_in_insert = true,
    severity_sort = true,
    signs = true,
    virtual_text = true,
    underline = true,
    source = true,
    float = { source = true, severity_sort = true, update_in_insert = true },
    --format = format_diagnostic,
})
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Much of this from wiki
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

--see https://www.reddit.com/r/neovim/comments/q2s0cg/looking_for_function_signature_plugin/
local handlers = {
    ["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
            border = border,
            close_events = { "CursorMoved", "BufHidden" },
        }
    ),
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            virtual_text = {
                prefix = "<|",
                source = "if_many",
                --format = format_diagnostic,
            },
            update_in_insert = true,
            underline = true,
            severity_sort = true,
        }
    ),
    ["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = border }
    ),
}
-- From https://github-wiki-see.page/m/neovim/nvim-lspconfig/wiki/UI-customization
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local lspconfig = require("lspconfig")

for server, settings in pairs(servers) do
    --vim.lsp.config(server, flags = {debounce_text_changes = 150})
    --TODO
    --1. Create lsp directory in lua dir where `language.lua` returns a table of config data
    --2. Setup each server in `lsp.lua`
    --3. Set autocommands for filetypes to activate servers
    lspconfig[server].setup({
        capabilities = capabilities,
        handlers = handlers,
        on_attach = on_attach,
        settings = settings,
        flags = {
            debounce_text_changes = 150,
        },
    })
end
vim.lsp.set_log_level("error")
