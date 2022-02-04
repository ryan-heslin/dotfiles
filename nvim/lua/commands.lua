-- Custom commands
vim.cmd([[
command!  -range Embrace <line1>,<line2>s/\v(_|\^)\s*([^{}_\^ \$]+)/\1{\2}/g
command! -nargs=1 -range=% Sed <line1>,<line2>s/<args>//g
command! -nargs=1 -range=% Grab <line1>,<line2>g/<args>/yank Z
" Switch window to buffer already open
"TODO autocomplete something for zotref
command! -nargs=1 -complete=buffer E edit <args>
" From https://unix.stackexchange.com/questions/72051/vim-how-to-increase-each-number-in-visual-block
" Increments all by 1 in visual selection
command!-range Inc <line1>,<line2>s/\%V\d\+\%V/\=submatch(0)+1/g
" Delete buffer without closing window
command! BD :bprevious | split | bnext | bdelete
]])
