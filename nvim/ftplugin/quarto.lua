require("abbrev")
dofile(vim.api.nvim_get_runtime_file("ftplugin/r.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/tex.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/md.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/rmd.lua", false)[1])
--Nvim-R Rmarkdown syntax file
vim.cmd(
    "source "
        .. vim.fn.stdpath("data")
        .. "/plugged/Nvim-R/ftplugin/rmd_nvimr.vim"
)
vim.keymap.set({"n"}, "<leader>jj", ":lua send_chunk()<CR>", opts)
