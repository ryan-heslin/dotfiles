-- Makefiles require literal tabs
vim.bo.expandtab = false
-- Dry run
vim.api.nvim_buf_set_keymap('n', '<leader>dr', ':!make --just-print', {silent = true, noremap = true})
