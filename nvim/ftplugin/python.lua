local opts = { noremap = true, silent = true, buffer = true }
vim.opt.cinwords:append({
    "if",
    "else",
    "for",
    "while",
    "try",
    "except",
    "finally",
    "def",
    "class",
    "with",
})

vim.keymap.set("n", [[<leader>sh]], [[ggO#!/usr/bin/python3<Esc><C-o>]], opts)
vim.keymap.set("n", [[\s]], [[:SlimeSend1 ipython<CR>]], opts)
vim.keymap.set("n", [[\e]], [[:w <bar> IPythonCellExecuteCell<CR>]], opts)
vim.keymap.set("n", [[\r]], [[:w <bar> IPythonCellRun<CR>]], opts)
vim.keymap.set("n", [[\p]], [[:IPythonCellPrevCommand<CR>]], opts)
vim.keymap.set("n", [[\\]], [[:IPythonCellRestart<CR>]], opts)
vim.keymap.set("n", [[\[c]], [[:IPythonCellPrevCell<CR>]], opts)
vim.keymap.set("n", [[\E]], [[:IPythonCellExecuteCellJump<CR>]], opts)
vim.keymap.set("n", [[\x]], [[:IPythonCellClose<CR>]], opts)
vim.keymap.set("n", [[\p]], [[:IPythonCellClear<CR>]], opts)
vim.keymap.set("n", [[\Q]], [[:IPythonCellRestart<CR>]], opts)
vim.keymap.set("n", [[\d]], [[:SlimeSend1 %debug<CR>]], opts)
vim.keymap.set("n", [[\q]], [[:SlimeSend1 exit<CR>]], opts)

-- Print object under cursor
vim.keymap.set("n", [[\pp]], [[yiW:SlimeSend1 print(<C-r><C-w>)<CR>]], opts)
vim.keymap.set("n", [[\o]], ":SlimeRegionSend<CR>", opts)
vim.keymap.set("n", [[\b]], [[:SlimeParagraphSend<CR>]], opts)
--vim.keymap.set("n", [[\l]], "<Plug>SlimeLineSend<CR>", opts)
vim.keymap.set("n", [[\m]], "<Plug>SlimeMotionSend<CR>", opts)

-- Set or remove breakpoints
vim.keymap.set("n", [[\pdb]], [[Obreakpoint()<Esc>j]], opts)
vim.keymap.set("n", [[\ddb]], [[:%s/^\s*breakpoint()\s*$//<CR>]], opts)

-- Print debug
vim.keymap.set(
    "n",
    [[<leader>pd]],
    [[^yWoIprint(f'<C-o>P = {<C-o>P}')<Esc>]],
    opts
)
--vim.keymap.set({"n", "v"}, [[:split | normal  | term | lua M.term_exec("ipython3")<CR>]])
vim.keymap.set("n", [[<leader>di]], [[Pa["<Esc>ea"]<Esc>B]], opts)
vim.keymap.set("i", [[<C-l>]], [[<Esc>A:<CR>]], opts)
vim.keymap.set({ "n", "v" }, [[\jj]], ":lua run_current_chunk()<CR>", opts)
vim.keymap.set({ "n", "v" }, [[\rr]], ":lua run_all_chunks()<CR>", opts)
vim.keymap.set({ "n", "v" }, [[\l]], ":lua run_line()<CR>", opts)
vim.keymap.set({ "n", "v" }, [[\ss]], ":lua send_visual_selection()<CR>", opts)

vim.keymap.set(
    { "n", "v" },
    [[\ca]],
    "<cmd>lua run_all_chunks(nil, vim.fn.line('.'))<CR>",
    opts
)
vim.keymap.set({ "n", "v" }, [[\pp]], ":lua run_word()<CR>", opts)
vim.keymap.set({ "n", "v" }, [[\hh]], ":lua run_paragraph()<CR>", opts)

-- Special Python highlighting
-- TODO highlight instance
-- local pycolors = vim.api.nvim_create_augroup("Pycolors", { clear = true })
-- vim.api.nvim_create_autocmd("ColorScheme", {
--     command = [=[
--    highlight pythonImportedObject ctermfg=127 guifg=127
--  \ | highlight pythonImportedFuncDef ctermfg=127 guifg=127
--  \ | highlight pythonImportedClassDef ctermfg=127 guifg=127
--  \ | syntax match Type /\v\.[a-zA-Z0-9_]+\ze(\[|\s|$|,|\]|\)|\.|:)/hs=s+1
--  \ | syntax match self /\(\W\|^\)\@<=self\(\.\)\@=/
--  \ | syntax match pythonFunction /\v[[:alnum:]_]+\ze(\s?\()/
--  \ | syntax match method /\v[[:alnum:]_]\.\zs[[:alnum:]_]+\ze\(/
--  \ | syntax match call /\v([(, ]|^)\zs[[:alnum:]_]+\ze\s*\(/
--  \ | highlight def link pythonFunction Function
--  \ | highlight self ctermfg=Yellow guifg=Yellow
--  \ | highlight call ctermfg=Blue guifg=RoyalBlue3
--  \ | highlight method guifg=DarkOrchid3
-- ]=],
--     group = pycolors,
--     pattern = "*.py",
-- })
