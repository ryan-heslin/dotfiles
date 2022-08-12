require("abbrev")
local opts = {silent = true, noremap = true, buffer = true}
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
vim.keymap.set({"n", "v"}, [[\jj]], ":lua run_chunk()<CR>", opts)
vim.keymap.set({"n", "v"}, [[\rr]], ":lua run_all_chunks()<CR>", opts)
vim.keymap.set({"n", "v"}, [[\l]], ":lua run_line()<CR>", opts)
vim.keymap.set({"n", "v"}, [[\ss]], ":lua send_visual_selection()<CR>", opts)
vim.keymap.set({"n", "v"}, [[\ca]], ":lua run_all_chunks(nil, vim.fn.line('.'))<CR>", opts)
