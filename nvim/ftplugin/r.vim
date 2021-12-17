setlocal cinwords=if,else,for,while,repeat,function
setlocal tabstop=2
inoremap -- <Space><-<Space>
inoremap ;fun <Space><- function(){<esc>o}<esc>kf)i
inoremap ++ <Space><bar>><Space>
inoreabbrev T TRUE
inoreabbrev FA FALSE
nnoremap <leader>pd ^yiWoprint(paste("<C-o>p<space>=",<space><C-o>p))<Esc>k^

nnoremap <leader>ss execute "RSend source('" . expand('%:p') . "')"
nnoremap  <leader>p-  d$k$bdaWj
let b:ale_set_balloons=1
let b:ale_change_sign_column_color=1
let b:ale_set_highlights=1
let b:ale_virtualtext_cursor=1
