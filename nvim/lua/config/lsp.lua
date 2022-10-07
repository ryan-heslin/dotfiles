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
        local width = M.clamp(win_width - 5, 5, 40)
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
    --print(space)
    --print(string.len(diagnostic.message))
    -- Does not seem to work
    return message
end

lspkind = require("lspkind")
on_attach = function(client, bufnr)
    --if  vim.b.zotcite_omnifunc then
    --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', [[zotcite#CompleteBib]])
    --else
    --vim.api.nvim_buf_set_option(bufnr, "omnifunc", vim.v.lua.vim.lsp.omnifunc)
    --or is it vim.v.lua.vim.lsp.lua.R_set_omnifunc
    --end

    local opts = { noremap = true, silent = true }
    vim.keymap.set(
        { "n", "v" },
        "gD",
        "<cmd>lua vim.lsp.buf.declaration()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "gd",
        "<cmd>lua vim.lsp.buf.definition()<CR>",
        opts
    )
    vim.keymap.set({ "n", "v" }, "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.keymap.set(
        { "n", "v" },
        "<leader>gi",
        "<cmd>lua vim.lsp.buf.implementation()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<C-k>",
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>wa",
        "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>wr",
        "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>wl",
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>D",
        "<cmd>lua vim.lsp.buf.type_definition()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>rn",
        "<cmd>lua vim.lsp.buf.rename()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "gr",
        "<cmd>lua vim.lsp.buf.references()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>ca",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        opts
    )
    vim.keymap.set(
        "v",
        "<leader>ca",
        "<cmd>lua vim.lsp.buf.range_code_action()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>e",
        '<cmd>lua vim.diagnostic.open_float(nil, {header = "Line Diagnostics", format = format_diagnostic, scope = "line"})<CR>'
        ,
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "[d",
        "<cmd>lua vim.diagnostic.goto_prev()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "]d",
        "<cmd>lua vim.diagnostic.goto_next()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>q",
        "<cmd>lua vim.diagnostic.set_loclist()<CR>",
        opts
    )
    vim.keymap.set(
        { "n", "v" },
        "<leader>so",
        [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
        opts
    )
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({async = false})' ]])
    -- From https://github.com/martinsione/dotfiles/blob/master/src/.config/nvim/lua/modules/config/nvim-lspconfig/on-attach.lua
    if client then
        if client.supports_method("textDocument/formatting")
            and client.name ~= "null-ls"
        then
            vim.api.nvim_clear_autocmds({ group = formatting, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = formatting,
                buffer = bufnr,
                callback = vim.lsp.buf.format,
            })
        end

        if client.server_capabilities.document_highlight then
            vim.cmd([[
                 highlight LspReferenceRead cterm=bold gui=Bold ctermbg=yellow guifg=SlateBlue guibg=#ffff99
                 highlight LspReferenceText cterm=bold gui=Bold ctermbg=red guifg=SlateBlue guibg=MidnightBlue
                 highlight LspReferenceWrite cterm=bold gui=Bold ctermbg=red guifg=DarkSlateBlue guibg=MistyRose
                 ]])

            -- Trigger document highlighting on holding cursor
            local doc_highlight = vim.api.nvim_create_augroup(
                "LSPDocumentHighlight",
                {}
            )
            vim.api.nvim_clear_autocmds({
                group = LSPDocumentHighlight,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("CursorHold", {
                callback = vim.lsp.buf.document_highlight,
                group = LSPDocumentHighlight,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("CursorHoldI", {
                callback = vim.lsp.buf.document_highlight,
                group = LSPDocumentHighlight,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                callback = vim.lsp.buf.clear_references,
                roup = LSPDocumentHighlight,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("CursorMovedI", {
                callback = vim.lsp.buf.clear_references,
                augroup = LSPDocumentHighlight,
                buffer = bufnr,
            })
        end
    end
    --
end

-- Ensuring relevant server paths are known
local lua_dir = vim.fn.expand("$HOME/.local/bin/lua-language-server")
local path = vim.fn.split(package.path, ";")
-- Maybe add failsafe here
local bashls = vim.fn.systemlist("which bash-language-server")[1]
table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")

local servers = {
    bashls = { filetypes = { "sh", "bash" }, cmd = bashls },
    pyright = { filetypes = { "python", "quarto" } },
    r_language_server = {
        --root_dir = function(fname)
        --   return require("lspconfig.util").find_git_ancestor(fname)
        --      or vim.loop.os_homedir()
        --end,
        filetypes = { "r", "rmd", "quarto" },
    },
    racket_langserver = { filetypes = { "racket", "scheme" } },
    sumneko_lua = {
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
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
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
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
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
            --virtual_text = {
            --   source = 'if_many',
            --format = format_diagnostic},
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

local nvim_lsp = require("lspconfig")

for server, settings in pairs(servers) do
    nvim_lsp[server].setup({
        capabilities = capabilities,
        handlers = handlers,
        on_attach = on_attach,
        settings = settings,
        flags = {
            debounce_text_changes = 150,
        },
    })
end
vim.g.lsp_done = true
vim.wo.signcolumn = "yes"
vim.lsp.set_log_level('debug')
--end
--

--Actual capabilities
--{
--disable = <function 1>,
--enable = <function 2>,
--get = <function 3>,
--get_all = <function 4>,
--get_count = <function 5>,
--get_line_diagnostics = <function 6>,
--get_namespace = <function 7>,
--get_next = <function 8>,
--get_next_pos = <function 9>,
--get_prev = <function 10>,
--get_prev_pos = <function 11>,
--get_virtual_text_chunks_for_line = <function 12>,
--goto_next = <function 13>,
--goto_prev = <function 14>,
--on_publish_diagnostics = <function 15>,
--redraw = <function 16>,
--reset = <function 17>,
--save = <function 18>,
--set_loclist = <function 19>,
--set_qflist = <function 20>,
--set_signs = <function 21>,
--set_underline = <function 22>,
--set_virtual_text = <function 23>,
--show_line_diagnostics = <function 24>,
--show_position_diagnostics = <function 25>
--}
--library = vim.api.nvim_get_runtime_file("", true)
