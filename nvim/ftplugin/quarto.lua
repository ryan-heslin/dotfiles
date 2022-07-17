require("abbrev")
dofile(vim.api.nvim_get_runtime_file("ftplugin/r.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/tex.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/md.lua", false)[1])
vim.cmd(
    "source "
        .. vim.fn.stdpath("data")
        .. "/plugged/Nvim-R/ftplugin/rmd_nvimr.vim"
)
