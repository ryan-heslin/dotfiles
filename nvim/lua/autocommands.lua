-- Standard autocommands
vim.cmd([[
augroup Colors
    autocmd!
    autocmd ColorScheme * highlight NormalFloat guibg=#1f2335
    \ | highlight! FloatBorder guifg=white guibg=#1f2335
    \ | highlight! Pmenu guibg=#1f2335
    \ | highlight! PmenuSel guibg=#cca300
    \ | highlight! PmenuSBar guibg=white
    \ | highlight! PmenuThumb guibg=#cca300
    \ | highlight! rGlobEnvFun ctermfg=117 guifg=#87d7ff cterm=italic gui=italic
    \ | highlight! LspReferenceRead guifg=LightGreen guibg=Yellow
    \ | highlight! LspReferenceWrite guifg=Yellow guibg=Yellow
    \ | highlight! LspSignatureActiveParameters guifg=Green
    \ | highlight! ColorColumn  guibg=wheat guifg=wheat
    \ | highlight! CmpItemAbbr guifg=wheat
    \ | highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
    \ | highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
    \ | highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
    \ | highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
    \ | highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
    \ | highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
    \ | highlight! CmpItemMenu guibg=#507b96
    \ | let g:rainbow_active = 1
    \ | let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
    \ | let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']
augroup end
]])

-- Remember cursor position color
vim.cmd([[
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
            \| execute "normal! g'\"" | endif
autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
autocmd TermEnter * :lua set_term_opts()
autocmd FileType text setlocal textwidth=78
]])

vim.cmd([[
augroup Cursor
    autocmd!
    let &t_EI = "\e[2 q"
    " highlight current line when in insert mode
    autocmd InsertEnter * set cursorline
    " turn off current line hightlighting when leaving insert mode
    autocmd InsertLeave * set nocursorline
augroup END
]])

vim.cmd([[
autocmd! BufReadPost quickfix nnoremap <buffer> <CR> <CR>

autocmd! User TelescopePreviewerLoaded setlocal wrap
autocmd! User TelescopePreviewerLoaded setlocal wrap
autocmd! BufWritePost * if ( get(b:, 'source_on_save') == 1 )
            \| execute 'lua refresh(vim.fn.expand("%:p"))'
            \| endif
autocmd! FileType anki_vim let b:UltiSnipsSnippetDirectories = g:UltiSnipsSnippetDirectories
autocmd! VimLeavePre * if (luaeval("count_bufs_by_type(true)['normal']") > 1) && (luaeval("summarize_option('ft')['anki_vim'] == nil") == 1) | :call functions#SaveSession() | endif
autocmd VimLeave let g:UltiSnipsDebugServerEnable = 0
]])
