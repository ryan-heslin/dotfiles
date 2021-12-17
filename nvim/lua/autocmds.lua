vim.api.nvim_command([[
augroup Term
autocmd!
autocmd BufEnter * if &buftype == 'terminal' :startinsert
\ | lua vim.wo.number = false
\ | lua vim.wo.relativenumber = false
\ | endif
augroup end
]] )
