dofile(vim.api.nvim_get_runtime_file("ftplugin/rmd.lua", false)[1])
vim.cmd(
    "source "
        .. vim.fn.stdpath("data")
        .. "/plugged/Nvim-R/ftplugin/rmd_nvimr.vim"
)
