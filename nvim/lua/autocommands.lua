vim.o.t_EI = [[\e[2 q]]

--From https://github.com/neovim/nvim-lspconfig/wiki/Code-Actions
local code_action_listener = function()
    local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
    local params = vim.lsp.util.make_range_params()
    params.context = context
    vim.lsp.buf_request(
        0,
        "textDocument/codeAction",
        params,
        function(err, _, result)
            --vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            --TODO sign for code actions
            local signs =
            { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
            -- do something with result - e.g. check if empty and show some indication such as a sign
        end
    )
end

local autocmd = vim.api.nvim_create_autocmd

-- Standard autocommands
-- NB table of autocmd args takes group argument for augroup
-- Global highlight group parameters
highlight_params = {
    NormalFloat = { bg = "#1f2335" },
    FloatBorder = { fg = "white", bg = "#1f2335" },
    Pmenu = { bg = "#1f2335" },
    PmenuSel = { bg = "#cca300" },
    PmenuSBar = { bg = "white" },
    PmenuThumb = { bg = "#cca300" },
    rGlobEnvFun = { ctermfg = 117, fg = "#87d7ff", italic = true },
    LspReferenceRead = { fg = "White", bg = "MistyRose" },
    LspReferenceWrite = { fg = "White", bg = "LightYellow" },
    LspReferenceText = { fg = "White", bg = "LightGreen" },
    LspSignatureActiveParameters = { fg = "Green" },
    ColorColumn = { bg = "MistyRose" },
    CmpItemAbbr = { fg = "wheat" },
    CmpItemAbbrMatch = { bg = nil, fg = "#569cd6" },
    CmpItemAbbrMatchFuzzy = { bg = nil, fg = "#569cd6" },
    CmpItemKindFunction = { bg = nil, fg = "#c586c0" },
    CmpItemKindMethod = { bg = nil, fg = "#c586c0" },
    CmpItemKindVariable = { bg = nil, fg = "#9cdcfe" },
    CmpItemKindKeyword = { bg = nil, fg = "#d4d4d4" },
    CmpItemMenu = { bg = "#507b96" },
    SignColumn = { bg = "#cca300" },
    LineNR = { fg = "#cca300" },
    CursorLineNR = { bold = true, fg = "#cca300", bg = "RoyalBlue1" },
    LineNRBelow = { fg = "#ccffcc" },
    LineNRAbove = { fg = "#ff8080" },
}
-- https://www.reddit.com/r/neovim/comments/12gvms4/this_is_why_your_higlights_look_different_in_90/
local links = {
    ["@lsp.type.namespace"] = "@namespace",
    ["@lsp.type.type"] = "@type",
    ["@lsp.type.class"] = "@type",
    ["@lsp.type.enum"] = "@type",
    ["@lsp.type.interface"] = "@type",
    ["@lsp.type.struct"] = "@structure",
    ["@lsp.type.parameter"] = "@parameter",
    ["@lsp.type.variable"] = "@variable",
    ["@lsp.type.property"] = "@property",
    ["@lsp.type.enumMember"] = "@constant",
    ["@lsp.type.function"] = "@function",
    ["@lsp.type.method"] = "@method",
    ["@lsp.type.macro"] = "@macro",
    ["@lsp.type.decorator"] = "@function",
}
autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        for group, params in pairs(highlight_params) do
            vim.api.nvim_set_hl(0, group, params)
        end
        for newgroup, oldgroup in pairs(links) do
            vim.api.nvim_set_hl(
                0,
                newgroup,
                { link = oldgroup, default = true }
            )
        end
        -- Configure rainbow parentheses
        vim.g.rainbow_active = 1
        vim.g.rainbow_guifgs = {
            "LightRed",
            "RoyalBlue3",
            "DarkOrange3",
            "DarkOrchid3",
            "FireBrick",
            "Green",
            "Yellow",
            "Cyan",
        }
        vim.g.rainbow_ctermfgs =
        { "lightblue", "lightgreen", "yellow", "red", "magenta" }
    end,
})

autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 300,
            on_macro = true,
        })
    end,
})
-- Remember cursor position color
autocmd("BufReadPost", {
    pattern = "*",
    command = [[ if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif ]],
})
-- Unfold on enter
autocmd("BufReadPost", { pattern = "*", command = [[normal! zr]] })

-- Configure terminal on enter
vim.api.nvim_create_augroup("Terminal", { clear = true })
autocmd("BufEnter", {
    pattern = "*",
    group = "Terminal",
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.cmd.startinsert()
        end
    end,
})
-- May need TermEnter if opening multiple buffers of same terminal
autocmd("TermEnter", {
    pattern = "*",
    group = "Terminal",
    callback = function()
        U.terminal.set_term_opts()
    end,
})
autocmd(
    "TermEnter",
    { pattern = "*", group = "Terminal", command = "startinsert" }
)

-- Configure vim-slime
autocmd("TermEnter", {
    pattern = "*",
    group = "Terminal",
    callback = function()
        if term_state == nil
            or term_state["last_terminal_win_id"] == nil
            or term_state["last_terminal_chan_id"] == nil
        then
            return
        else
            if vim.g.slime_default_config == nil then
                vim.g.slime_default_config =
                { jobid = term_state["last_terminal_chan_id"] }
            end
            vim.g.slime_target = "neovim"
            vim.g.slime_dont_ask_default = true
        end
    end,
})

-- Toggle cursorline and absolute numbers
vim.api.nvim_create_augroup("Cursor", { clear = true })
autocmd("InsertEnter", {
    pattern = "*",
    group = "Cursor",
    callback = function()
        vim.o.cursorline = true
        vim.o.relativenumber = false
    end,
})
autocmd("InsertLeave", {
    pattern = "*",
    group = "Cursor",
    callback = function()
        vim.o.cursorline = false
        vim.o.relativenumber = true
    end,
})

autocmd(
    "BufReadPost",
    { pattern = "*", command = [[nnoremap <buffer> <CR> <CR>]] }
)
-- autocmd("TelescopePreviewerLoaded", {
--     pattern = "*",
--     callback = function()
--         vim.wo.wrap = true
--     end,
-- })

-- Automatically source on save
autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        if vim.b.source_on_save ~= 0
            and (vim.bo.filetype == "r" or vim.b.source_on_save == 1)
        then
            U.utils.refresh()
        end
    end,
})

autocmd("VimLeavePre", {
    pattern = "*",
    callback = function()
        U.utils.do_save_session()
    end,
})
autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        if vim.fn.argc() == 0 then
            U.utils.load_session()
        end
    end,
    nested = true,
    desc = "Load latest session on startup if no arguments provided",
})
-- Save latest Rmd file for automatic knitting
-- autocmd("FileType", {
--     -- From https://github.com/neovim/neovim/issues/20455
--     pattern = "*",
--     callback = function()
--         if vim.bo.filetype == "rmd" then
--             vim.g.last_rmd = vim.fn.expand("%:p")
--         end
--     end,
--     desc = "Record latest Rmarkdown file for automatic knitting",
-- })
autocmd("BufEnter", {
    callback = U.data.record_file_name,
    desc = "On entering file of any type, record its name, overwriting old value if it exists",
    pattern = "*",
})
autocmd("WinLeave", {
    callback = function()
        U.data.recents["window"] = vim.fn.win_getid()
    end,
    desc = "On leaving a window, record its id",
    pattern = "*",
})

-- autocmd({ "BufEnter", "BufNewFile" }, {
--     callback = function()
--         vim.bo[0].filetype = "quarto"
--     end,
--     pattern = { "*.Qmd", "*.qmd" },
--     desc = "Set Quarto filetype",
-- })
--autocmd("FileType sql,mysql,plsql,sqlite", {
--function()
--require("cmp").setup.buffer({ sources = { { name = "vim-dadbod" } } })
--end,
--})
--
--local pycolors = vim.api.nvim_create_augroup("Pycolors", { clear = true })
-- From https://github.com/neovim/neovim/issues/20455
autocmd("WinClosed", {
    callback = function(args)
        if vim.api.nvim_get_current_win() ~= tonumber(args.match) then
            return
        end
        vim.cmd.wincmd("p")
    end,
})
-- From https://www.reddit.com/r/neovim/comments/u24o3m/how_to_make_ctrli_work_in_neovim/
-- autocmd("UIEnter", {
--     pattern = "*",
--     callback = function()
--         if vim.v.event.chan == vim.fn.expand("#") then
--             vim.fn.chansend(vim.v.stderr, "\x1b[>1u")
--         end
--     end,
-- })
-- autocmd("UILeave", {
--     pattern = "*",
--     function()
--         if vim.v.event.chan == vim.fn.expand("#") then
--             vim.fn.chansend(vim.v.stderr, "\x1b[<1u")
--         end
--     end,
-- })
-- autocmd("ColorScheme *", {
--     command = [=[
--    highlight pythonImportedObject ctermfg=127 guifg=127
--  \ | highlight pythonImportedFuncDef ctermfg=127 guifg=127
--  \ | highlight pythonImportedClassDef ctermfg=127 guifg=127
--  \ | syntax match Type /\v\.[a-zA-Z0-9_]+\ze(\[|\s|$|,|\]|\)|\.|:)/hs=s+1
--  \ | syntax match self /\(\W\|^\)\@<=self\(\.\)\@=/
--  \ | syntax match pythonFunction /\v[[:alnum:]_]+\ze(\s?\()/
--  \ | syntax match method /\v[[:alnum:]_]\.\zs[[:alnum:]_]+\ze\(/
--  \ | syntax match call /\v([(, ]|^)\zs[[:alnum:]_]+\ze\s*\(/
--  \ | highlight def link pythonFunction Function
--  \ | highlight self ctermfg=Yellow guifg=Yellow
--  \ | highlight call ctermfg=Blue guifg=RoyalBlue3
--  \ | highlight method guifg=DarkOrchid3
-- ]=],
--     group = pycolors,
--     pattern = "*.py",
-- })
-- From https://github.com/hrsh7th/nvim-cmp/issues/519#issuecomment-1091109258
-- autocmd({ "TextChangedI", "TextChangedP" }, {
--     callback = function()
--         local line = vim.api.nvim_get_current_line()
--         local cursor = vim.api.nvim_win_get_cursor(0)[2]
--
--         local current = string.sub(line, cursor, cursor + 1)
--         if current == "." or current == "," or current == " " then
--             require("cmp").close()
--         end
--
--         local before_line = string.sub(line, 1, cursor + 1)
--         local after_line = string.sub(line, cursor + 1, -1)
--         if not string.match(before_line, "^%s+$") then
--             if
--                 after_line == ""
--                 or string.match(before_line, " $")
--                 or string.match(before_line, "%.$")
--             then
--                 require("cmp").complete()
--             end
--         end
--     end,
--     pattern = "*",
-- })
--nvim-dap completion
-- TODO: Find why this breaks everything
-- autocmd("FileType dap-repl", {
--     callback = function()
--         use_debug = true
--         if use_debug then
--             require("dap.ext.autocompl").attach()
--         end
--     end,
-- })
autocmd(
    { "CursorHold", "CursorHoldI" },
    { pattern = "*", callback = code_action_listener }
)
