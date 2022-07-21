vim.bo.tabstop = 2

local opts = { noremap = true, silent = true, buffer = true }
vim.keymap.set("i", [[--]], [[<Space><-<Space>]], opts)
vim.keymap.set("i", [[;fun]], [[<Space><- function(){<esc>o}<esc>kf)i]], opts)
vim.keymap.set("i", [[++]], [[<Space><bar>><Space>]], opts)
vim.keymap.set(
    "n",
    [[<leader>pd]],
    [[^yiWoprint(paste("<C-o>p<space>=",<space><C-o>p))<Esc>k^]],
    opts
)

vim.keymap.set(
    "n",
    [[<leader>ss]],
    [[execute "RSend source('" . expand('%:p') . "')"]],
    opts
)

vim.keymap.set(
    "n",
    [[<leader>ss]],
    [[execute "RSend source('" . expand('%:p') . "')"]],
    opts
)
vim.keymap.set("n", [[<leader>p-]], [[ d$k$bdaWj]], opts)
--  Delete pipeline - proud of this one
vim.keymap.set(
    { "n", "v" },
    [[<leader>dp]],
    [[:s/\v\s*((\|\>)|(\%\>\%))\s*(\_.^[^`].*((\|\>)|(\%\>\%))\s*)*(\_.^.+$)?/<CR>]],
    opts
)

--Break substrings after commas into new lines
vim.cmd([[autocmd! VimResized * vim.g.R_Rconsole_width = winwidth(0) / 4]])
vim.cmd([[
inoreabbrev T TRUE
inoreabbrev FA FALSE
]])

--vim.b.ale_set_balloons = 1
--vim.b.ale_change_sign_column_color = 1
--vim.b.ale_set_highlights = 1
--vim.b.ale_virtualtext_cursor = 1
local open = "[["
local close = "]]"
local member_open = open .. [["]]
local member_close = [["]] .. close
require("nvim-surround").buffer_setup({
    delimiters = {
        pairs = {
            --List element
            [open] = { open, close },
            [member_open] = { member_open, member_close},
        },
    },
})
