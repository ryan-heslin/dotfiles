require("abbrev")
dofile(vim.api.nvim_get_runtime_file("ftplugin/r.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/tex.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/md.lua", false)[1])

vim.api.nvim_buf_set_keymap(
    0,
    "n",
    [[\kk]],
    [[:lua M.inline_send()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "n",
    [[<leader>`]],
    [[I```{r}<CR><CR>```<esc>kI]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "n",
    [[<Leader>ck]],
    [[:lua jump("^```{", 1, '')<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "n",
    [[<Leader>bk]],
    [[:lua jump("^```{", 1, 'b')<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;`]],
    [[<CR>```{r}<CR><CR>```<esc>kI]],
    { noremap = true, silent = true }
)
-- Zotcite path
vim.cmd([[noreabbrev zotcite '/home/rheslin/.local/share/nvim/plugged/zotcite/python3/zotref.py']])
vim.b.surround_99 = "<!--\r-->"
