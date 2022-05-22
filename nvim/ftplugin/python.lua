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

vim.api.nvim_set_keymap(
    "n",
    [[<leader>sh]],
    [[ggO#!/usr/bin/python3<Esc><C-o>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\s]],
    [[:SlimeSend1 ipython<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\e]],
    [[:w <bar> IPythonCellExecuteCell<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\r]],
    [[:w <bar> IPythonCellRun<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\p]],
    [[:IPythonCellPrevCommand<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\\]],
    [[:IPythonCellRestart<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\[c]],
    [[:IPythonCellPrevCell<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\E]],
    [[:IPythonCellExecuteCellJump<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\x]],
    [[:IPythonCellClose<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\p]],
    [[:IPythonCellClear<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\Q]],
    [[:IPythonCellRestart<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\d]],
    [[:SlimeSend1 %debug<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\q]],
    [[:SlimeSend1 exit<CR>]],
    { noremap = true, silent = true }
)
-- Print object under cursor
vim.api.nvim_set_keymap(
    "n",
    [[\pp]],
    [[yiW:SlimeSend1 print(<C-r><C-w>)<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\o]],
    ":SlimeRegionSend<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\b]],
    [[:SlimeParagraphSend<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\l]],
    "<Plug>SlimeLineSend<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\m]],
    "<Plug>SlimeMotionSend<CR>",
    { noremap = true, silent = true }
)

-- Set or remove breakpoints
vim.api.nvim_set_keymap(
    "n",
    [[\pdb]],
    [[Obreakpoint()<Esc>j]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[\ddb]],
    [[:%s/^\s*breakpoint()\s*$//<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[<leader>pd]],
    [[^yWoIprint(f'<C-o>P = {<C-o>P}')<Esc>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    [[<leader>di]],
    [[Pa["<Esc>ea"]<Esc>B]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "i",
    [[<C-l>]],
    [[<Esc>A:<CR>]],
    { noremap = true, silent = true }
)
-- Special Python highlighting
-- TODO highlight instance
vim.api.nvim_create_autocmd({
    "ColorScheme",
    command = [=[
augroup pycolors
  autocmd!
  autocmd ColorScheme * highlight pythonImportedObject ctermfg=127 guifg=127
 \ | highlight pythonImportedFuncDef ctermfg=127 guifg=127
 \ | highlight pythonImportedClassDef ctermfg=127 guifg=127
 \ | syntax match Type /\v\.[a-zA-Z0-9_]+\ze(\[|\s|$|,|\]|\)|\.|:)/hs=s+1
 \ | syntax match self /\(\W\|^\)\@<=self\(\.\)\@=/
 \ | syntax match pythonFunction /\v[[:alnum:]_]+\ze(\s?\()/
 \ | syntax match method /\v[[:alnum:]_]\.\zs[[:alnum:]_]+\ze\(/
 \ | syntax match call /\v[(, ]|^\zs[[:alnum:]_]+\ze\s*\(/
 \ | highlight self ctermfg=239 guifg=239
 \ | highlight call ctermfg=Blue guifg=RoyalBlue3
 \ | highlight method guifg=DarkOrchid3
augroup end
]=],
})
--\ | highlight def link pythonFunction Function
