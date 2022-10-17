require("abbrev")
local opts = {silent = true, noremap = true, buffer = true}
dofile(vim.api.nvim_get_runtime_file("ftplugin/r.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/tex.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/md.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/rmd.lua", false)[1])


vim.keymap.set({"n", "v"}, [[\jj]], ":lua run_current_chunk()<CR>", opts)
vim.keymap.set({"n", "v"}, [[\rr]], ":lua run_all_chunks()<CR>", opts)
vim.keymap.set({"n", "v"}, [[\l]], ":lua run_line()<CR>", opts)
vim.keymap.set({"n", "v"}, [[\ss]], ":lua send_visual_selection()<CR>", opts)
vim.keymap.set({"n", "v"}, [[\ca]], ":lua run_all_chunks(nil, vim.fn.line('.'))<CR>", opts)
vim.keymap.set({"n", "v"}, [[\pp]], ":lua run_word()<CR>", opts)
vim.keymap.set({"n", "v"}, [[\hh]], ":lua run_paragraph()<CR>", opts)

-- From https://vim.fandom.com/wiki/Different_syntax_highlighting_within_regions_of_a_file
vim.cmd([[
syntax include @python_chunk syntax/python.vim
syntax region pythonChunk start="^```{python" end="^```" matchgroup=chunk contains=@python_chunk
highlight link chunk SpecialComment
]])
