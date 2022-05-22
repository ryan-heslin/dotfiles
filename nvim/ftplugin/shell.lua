vim.api.nvim_set_keymap(
    "n",
    "<leader>sh",
    ":1normal I#!/usr/bin/bash<Esc><C-o><CR>",
    { noremap = true, silent = true }
)
