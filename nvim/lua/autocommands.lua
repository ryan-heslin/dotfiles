vim.o.t_EI = [[\e[2 q]]
-- Standard autocommands
-- NB table of autocmd args takes group argument for augroup
vim.api.nvim_create_autocmd('ColorScheme', { command = [[
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
highlight ColorColumn guibg=wheat
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
]]
     }
)

vim.api.nvim_create_autocmd( 'TextYankPost',  {command =  'silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_macro = true}'})
-- Remember cursor position color
vim.api.nvim_create_autocmd('BufReadPost', { command =  [[ if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif ]]})
-- Unfold on enter
vim.api.nvim_create_autocmd('BufReadPost', {command = [[normal! g`"zv]]})

vim.api.nvim_create_augroup("Terminal", {clear = true})
vim.api.nvim_create_autocmd('BufEnter',  {group = "Terminal", command = [[if &buftype == 'terminal' | :startinsert | endif]]})
vim.api.nvim_create_autocmd('TermOpen',  {group = "Terminal", callback = function() set_term_opts() end })
vim.api.nvim_create_autocmd('TermEnter',  {group = 'Terminal', command = 'startinsert'})


-- Toggle cursorline
vim.api.nvim_create_augroup("Cursor", {clear = true})
vim.api.nvim_create_autocmd('InsertEnter',  {group = 'Cursor', callback = function() vim.o.cursorline = true end})
vim.api.nvim_create_autocmd('InsertLeave',  {group = 'Cursor', callback = function() vim.o.cursorline = false end })

vim.api.nvim_create_autocmd('BufReadPost quickfix ', {command = [[nnoremap <buffer> <CR> <CR>]]})
vim.api.nvim_create_autocmd('User TelescopePreviewerLoaded', {callback = function() vim.wo.wrap = true end})

vim.api.nvim_create_autocmd('BufWritePost', {callback = function() if vim.b.source_on_save == 1 then refresh(vim.fn.expand("%:p")) end end})
vim.api.nvim_create_autocmd('FileType anki_vim',  {command =  'let b:UltiSnipsSnippetDirectories = g:UltiSnipsSnippetDirectories' })
vim.api.nvim_create_autocmd('VimLeavePre', {command =  [[* if (luaeval("count_bufs_by_type(true)['normal']") > 1) && (luaeval("summarize_option('ft')['anki_vim'] == nil") == 1) | :call functions#SaveSession() | endif
--autocmd! FileChangedShell *.pdf v:fcs_choice]]})
