vim.bo.tabstop=2
vim.api.nvim_buf_set_keymap(0, 'i', [[--]], [[<Space><-<Space>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', [[;fun]], [[<Space><- function(){<esc>o}<esc>kf)i]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', [[++]], [[<Space><bar>><Space>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', [[<leader>pd]], [[^yiWoprint(paste("<C-o>p<space>=",<space><C-o>p))<Esc>k^]], {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', [[<leader>ss]], [[execute "RSend source('" . expand('%:p') . "')"]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', [[<leader>p-]], [[ d$k$bdaWj]], {noremap = true, silent = true})
--  Delete pipeline - proud of this one
vim.api.nvim_set_keymap('n', [[<leader>dp]], [[:s/\v\s*((\|\>)|(\%\>\%))\s*(\_.^.+((\|\>)|(\%\>\%))\s*)*(\_.^.+$)?/<CR>]], {noremap = true, silent = true})

--Break substrings after commas into new lines
vim.cmd [[autocmd! VimResized * vim.g.R_Rconsole_width = winwidth(0) / 4]]
vim.cmd([[
inoreabbrev T TRUE
inoreabbrev FA FALSE
]])

vim.b.ale_set_balloons=1
vim.b.ale_change_sign_column_color=1
vim.b.ale_set_highlights=1
vim.b.ale_virtualtext_cursor=1
