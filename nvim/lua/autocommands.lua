vim.o.t_EI = [[\e[2 q]]
if last_filetype == nil then
    last_filetype = {}
end
-- Standard autocommands
-- NB table of autocmd args takes group argument for augroup
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    command = [[
highlight NormalFloat guibg=#1f2335
highlight FloatBorder guifg=white guibg=#1f2335
highlight Pmenu guibg=#1f2335
highlight PmenuSel guibg=#cca300
highlight PmenuSBar guibg=white
highlight PmenuThumb guibg=#cca300
highlight rGlobEnvFun ctermfg=117 guifg=#87d7ff cterm=italic gui=italic
highlight LspReferenceRead guifg=LightGreen guibg=Yellow
highlight LspReferenceWrite guifg=Yellow guibg=Yellow
highlight LspSignatureActiveParameters guifg=Green
highlight ColorColumn guibg=MistyRose
highlight CmpItemAbbr guifg=wheat
highlight CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
highlight CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight CmpItemKindMethod guibg=NONE guifg=#C586C0
highlight CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight CmpItemMenu guibg=#507b96
highlight SignColumn guibg=#cca300
highlight LineNR guifg=#cca300
highlight CursorLineNR gui=bold guifg=#cca300 guibg=RoyalBlue1
highlight LineNRBelow guifg= #ccffcc
highlight LineNRAbove guifg=#ff8080
let g:rainbow_active = 1
let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']
]],
})

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    command = 'silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_macro = true}',
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

vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = "Terminal",
    command = [[if &buftype == 'terminal' | :startinsert | endif]],
})
vim.api.nvim_create_autocmd("TermOpen", {
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

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        if vim.b.source_on_save == 1 then
            M.refresh(vim.fn.expand("%:p"))
        end
    end,
})
vim.api.nvim_create_autocmd("FileType anki_vim", {
    pattern = "*",
    command = "let b:UltiSnipsSnippetDirectories = g:UltiSnipsSnippetDirectories",
})
vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = "*",
    callback = function()
        M.do_save_session()
    end,
})
--autocmd! FileChangedShell *.pdf v:fcs_choice]]})
--Maybe utils not sourced at this point?
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        if vim.fn.argc() == 0 then
            M.load_session()
        end
    end,
    desc = "Load latest session on startup if no arguments provided",
})
-- Save latest Rmd file for automatic knitting
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "rmd" then
            vim.g.last_rmd = vim.fn.expand("%:p")
        end
    end,
    desc = "Record latest Rmarkdown file for automatic knitting",
})
-- Trailing * in pattern matches /, unlike vanilla Bash
--
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = "~/R/Projects/spring_22/assistantship/textCF/*",
    command = 'let R_path="~/R-4.1.0/bin"',
    desc = "Point Nvim-R to old R executable for renv-controlled project built with old R version",
})
vim.api.nvim_create_autocmd("BufEnter", {
    callback = M.record_file_name,
    desc = "On entering file of any type, record its name, overwriting old value if it exists",
    pattern = "*",
})
