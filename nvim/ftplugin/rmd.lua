require("abbrev")
require('ftplugin/r')
require('ftplugin/tex')
require('ftplugin/md')
vim.api.nvim_buf_set_keymap(0, 'n', [[\kk]], [[:lua inline_send()<CR>]], {noremap = true, silent = true})
vim.api.nvim_buf_set_keymap(0, 'n', [[<leader>`]], [[I```{r}<CR><CR>```<esc>kI]], {noremap = true, silent = true})
vim.api.nvim_buf_set_keymap(0, 'n', [[<Leader>ck]], [[:lua jump("^```{", 1, '')<CR>]], {noremap = true, silent = true})
vim.api.nvim_buf_set_keymap(0, 'n', [[<Leader>bk]], [[:lua jump("^```{", 1, 'b')<CR>]], {noremap = true, silent = true})
vim.api.nvim_buf_set_keymap(0, 'i', [[;`]], [[<CR>```{r}<CR><CR>```<esc>kI]], {noremap = true, silent = true})
-- Zotcite path
vim.cmd[[noreabbrev zotcite '/home/rheslin/.local/share/nvim/plugged/zotcite/python3/zotref.py']]
vim.b.surround_99 = '<!--\r-->'
