vim.o.t_EI = [[\e[2 q]]
if last_filetype == nil then
    last_filetype = {}
end

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
    LspReferenceRead = { fg = "LightGreen", bg = "Yellow" },
    LspReferenceWrite = { fg = "Yellow", bg = "Yellow" },
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
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        for group, params in pairs(highlight_params) do
            vim.api.nvim_set_hl(0, group, params)
        end
        -- Configure rainbow parentheses
        vim.g.rainbow_active = 1
        vim.g.rainbow_guifgs = {
            "LightRed",
            "RoyalBlue3",
            "DarkOrange3",
            "DarkOrchid3",
            "FireBrick",
            "SeaGreen",
            "LightYellow",
            "LightCyan",
        }
        vim.g.rainbow_ctermfgs =
            { "lightblue", "lightgreen", "yellow", "red", "magenta" }
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
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
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    command = [[ if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif ]],
})
-- Unfold on enter
vim.api.nvim_create_autocmd(
    "BufReadPost",
    { pattern = "*", command = [[normal! zr]] }
)

-- Configure terminal on enter
vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = "Terminal",
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.cmd.startinsert()
        end
    end,
})
-- May need TermEnter if opening multiple buffers of same terminal
vim.api.nvim_create_autocmd("TermEnter", {
    pattern = "*",
    group = "Terminal",
    callback = function()
        M.set_term_opts()
    end,
})
vim.api.nvim_create_autocmd(
    "TermEnter",
    { pattern = "*", group = "Terminal", command = "startinsert" }
)

-- Toggle cursorline
vim.api.nvim_create_augroup("Cursor", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    group = "Cursor",
    callback = function()
        vim.o.cursorline = true
    end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    group = "Cursor",
    callback = function()
        vim.o.cursorline = false
    end,
})

vim.api.nvim_create_autocmd(
    "BufReadPost quickfix",
    { pattern = "*", command = [[nnoremap <buffer> <CR> <CR>]] }
)
vim.api.nvim_create_autocmd("User TelescopePreviewerLoaded", {
    pattern = "*",
    callback = function()
        vim.wo.wrap = true
    end,
})

-- Automatically source on save
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        if
            vim.b.source_on_save ~= 0
            and (vim.bo.filetype == "r" or vim.b.source_on_save == 1)
        then
            M.refresh()
        end
    end,
})
vim.api.nvim_create_autocmd("FileType anki_vim", {
    pattern = "*",
    callback = function()
        vim.b.UltiSnipsSnippetDirectories = vim.g.UltiSnipsSnippetDirectories
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = "*",
    callback = function()
        M.do_save_session()
    end,
})
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        if vim.fn.argc() == 0 then
            M.load_session()
        end
    end,
    nested = true,
    desc = "Load latest session on startup if no arguments provided",
})
-- Save latest Rmd file for automatic knitting
vim.api.nvim_create_autocmd("FileType", {
    -- From https://github.com/neovim/neovim/issues/20455
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "rmd" then
            vim.g.last_rmd = vim.fn.expand("%:p")
        end
    end,
    desc = "Record latest Rmarkdown file for automatic knitting",
})
vim.api.nvim_create_autocmd("BufEnter", {
    callback = M.record_file_name,
    desc = "On entering file of any type, record its name, overwriting old value if it exists",
    pattern = "*",
})
vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        recents["window"] = vim.fn.win_getid()
    end,
    desc = "On leaving a window, record its id",
    pattern = "*",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
    callback = function()
        vim.bo.filetype = "quarto"
    end,
    pattern = { "*.Qmd", "*.qmd" },
    desc = "Set Quarto filetype",
})
--vim.api.nvim_create_autocmd("FileType sql,mysql,plsql,sqlite", {
--function()
--require("cmp").setup.buffer({ sources = { { name = "vim-dadbod" } } })
--end,
--})
--
--local pycolors = vim.api.nvim_create_augroup("Pycolors", { clear = true })
-- From https://github.com/neovim/neovim/issues/20455
vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
        if vim.api.nvim_get_current_win() ~= tonumber(args.match) then
            return
        end
        vim.cmd.wincmd("p")
    end,
})
-- From https://www.reddit.com/r/neovim/comments/u24o3m/how_to_make_ctrli_work_in_neovim/
-- vim.api.nvim_create_autocmd("UIEnter", {
--     pattern = "*",
--     callback = function()
--         if vim.v.event.chan == vim.fn.expand("#") then
--             vim.fn.chansend(vim.v.stderr, "\x1b[>1u")
--         end
--     end,
-- })
-- vim.api.nvim_create_autocmd("UILeave", {
--     pattern = "*",
--     function()
--         if vim.v.event.chan == vim.fn.expand("#") then
--             vim.fn.chansend(vim.v.stderr, "\x1b[<1u")
--         end
--     end,
-- })
-- vim.api.nvim_create_autocmd("ColorScheme *", {
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
