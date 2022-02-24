require("abbrev")
--require(vim.api.nvim_get_runtime_file("ftplugin/r.lua", false)[1])
--require(vim.api.nvim_get_runtime_file("ftplugin/tex.vim", false)[1])
--require(vim.api.nvim_get_runtime_file("ftplugin/md.vim", false)[1])
require("")
vim.api.nvim_set_keymap('n', [[\kk]], [[:lua inline_send()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', [[<leader>`]], [[I```{r}<CR><CR>```<esc>kI]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', [[<Leader>ck]], [[:lua jump("^```{", 1, '')<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', [[<Leader>bk]], [[:lua jump("^```{", 1, 'b')<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', [[;`]], [[<CR>```{r}<CR><CR>```<esc>kI]], {noremap = true, silent = true})
-- Zotcite path
vim.cmd[[noreabbrev zotcite '/home/rheslin/.local/share/nvim/plugged/zotcite/python3/zotref.py]]
vim.b.surround_99 = [[<!--\r-->]]
