"call functions#CheckLoaded("b:did_ftplugin")
runtime! ftplugin/r.vim
runtime! ftplugin/tex.vim
runtime! ftplugin/md.vim

nnoremap \kk :call functions#InlineSend()<CR>
nnoremap <leader>` I```{r}<CR><CR>```<esc>kI
nnoremap <Leader>ck :lua jump("^```{", 1, '')<CR>
nnoremap <Leader>bk :lua jump("^```{", 1, 'b')<CR>
inoremap ;` <CR>```{r}<CR><CR>```<esc>kI
lua <<EOF
require("abbrev")
EOF
" Zotcite path
inoreabbrev zotcite '/home/rheslin/.local/share/nvim/plugged/zotcite/python3/zotref.py'
