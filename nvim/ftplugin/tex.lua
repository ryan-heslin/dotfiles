vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;;]],
    [[$$<Esc>i]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;_]],
    [[__<Esc>i]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;*]],
    [[**<Esc>i]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "n",
    [[\:]],
    [[:RSend<Space>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "n",
    [[;M]],
    [[I<CR><CR>$$<CR><CR>$$<Esc>ki]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;\]],
    [[<esc>A\\<esc>j]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[~~]],
    [[\sim<Space>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;th]],
    [[\theta]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;m]],
    [[\mu]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;a]],
    [[\alpha]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;be]],
    [[\beta]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;de]],
    [[\delta]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;s]],
    [[\sigma]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;ss]],
    [[\sigma^2]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;ep]],
    [[\epsilon]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;S]],
    [[\Sigma]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;la]],
    [[\lambda]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;L]],
    [[\Lambda]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;g]],
    [[\gamma]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;G]],
    [[\Gamma]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;ph]],
    [[\phi]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;pi]],
    [[\pi]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;[]],
    [[\[<cr><cr>\]<Esc>ki<tab>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;E]],
    [[E[]<Esc>i]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;c]],
    [[^]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;inv]],
    [[^{-1}]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;h]],
    [[\hat{}<Esc>i]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;ba]],
    [[\bar{}<Esc>i]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;frac]],
    [[\frac{}{<++>}<Esc>ba]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;lr]],
    [[\left(\right)<Esc>bba]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;xx]],
    [[X_1,<Space>\ldots<Space>,X_n<Space>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;si]],
    [[\overset{\text{iid}}{\sim}<Space>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;yy]],
    [[Y_1,<Space>\ldots<Space>,Y_n<Space>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;su]],
    [[\sum_{i=<++>}^{<++>}<Space>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;pr]],
    [[\prod_{i=<++>}^{<++>}<Space>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;te]],
    [[\text{}<Esc>i]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;ri]],
    [[\rightarrow<Space>\infty<Space>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;ho]],
    [[H_0:<Space><++>=0\text{ vs. }H_A:<Space><++>\neq<Space>0]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;ali]],
    [[\[<CR>\begin{aligned}<CR><CR>\end{aligned}<CR>\]<Esc>2kA&<Space>]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;enum]],
    [[\begin{enumerate}<cr><cr>\end{enumerate}<esc>ki<tab>\item]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;ta]],
    [[\begin{tabular}{<++>}<CR><CR>\end{tabular}<Esc>ki]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;ca]],
    [[\begin{cases}<CR><CR>\end{cases}<Esc>ki]],
    { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
    0,
    "i",
    [[;ce]],
    [[\begin{center}<CR><CR>\end{center}<Esc>ki]],
    { noremap = true, silent = true }
)

vim.b.surround_101 = "\\begin{\1environment: \1}\r\\end{\1\1}"
vim.b.surround_108 = "\\\1command: \1{\r}"
