local opts = { noremap = true, silent = true, buffer = true }
local km = vim.keymap
-- Many of these are copied from a source I failed to note
km.set("i", [[;;]], [[$$<Esc>i]], opts)
km.set("i", [[;_]], [[__<Esc>i]], opts)
km.set("i", [[;*]], [[**<Esc>i]], opts)
km.set("n", [[;M]], [[I<CR><CR>$$<CR><CR>$$<Esc>ki]], opts)
km.set("i", [[;\]], [[<esc>A\\<esc>j]], opts)
km.set("i", [[~~]], [[\sim<Space>]], opts)
km.set("i", [[;th]], [[\theta]], opts)
km.set("i", [[;m]], [[\mu]], opts)
km.set("i", [[;a]], [[\alpha]], opts)
km.set("i", [[;be]], [[\beta]], opts)
km.set("i", [[;de]], [[\delta]], opts)
km.set("i", [[;s]], [[\sigma]], opts)
km.set("i", [[;ss]], [[\sigma^2]], opts)
km.set("i", [[;ep]], [[\epsilon]], opts)
km.set("i", [[;S]], [[\Sigma]], opts)
km.set("i", [[;la]], [[\lambda]], opts)
km.set("i", [[;L]], [[\Lambda]], opts)
km.set("i", [[;g]], [[\gamma]], opts)
km.set("i", [[;G]], [[\Gamma]], opts)
km.set("i", [[;ph]], [[\phi]], opts)
km.set("i", [[;pi]], [[\pi]], opts)
km.set("i", [[;[]], [[\[<cr><cr>\]<Esc>ki<tab>]], opts)
km.set("i", [[;E]], [[E[]<Esc>i]], opts)
km.set("i", [[;c]], [[^]], opts)
km.set("i", [[;inv]], [[^{-1}]], opts)
km.set("i", [[;h]], [[\hat{}<Esc>i]], opts)
km.set("i", [[;ba]], [[\bar{}<Esc>i]], opts)
km.set("i", [[;frac]], [[\frac{}{<++>}<Esc>ba]], opts)
km.set("i", [[;lr]], [[\left(\right)<Esc>bba]], opts)
km.set("i", [[;xx]], [[X_1,<Space>\ldots<Space>,X_n<Space>]], opts)
km.set("i", [[;si]], [[\overset{\text{iid}}{\sim}<Space>]], opts)
km.set("i", [[;yy]], [[Y_1,<Space>\ldots<Space>,Y_n<Space>]], opts)
km.set("i", [[;su]], [[\sum_{i=<++>}^{<++>}<Space>]], opts)
km.set("i", [[;pr]], [[\prod_{i=<++>}^{<++>}<Space>]], opts)
km.set("i", [[;te]], [[\text{}<Esc>i]], opts)
km.set("i", [[;ri]], [[\rightarrow<Space>\infty<Space>]], opts)
km.set(

    "i",
    [[;ho]],
    [[H_0:<Space><++>=0\text{ vs. }H_A:<Space><++>\neq<Space>0]],
    opts
)
km.set(

    "i",
    [[;ali]],
    [[\[<CR>\begin{aligned}<CR><CR>\end{aligned}<CR>\]<Esc>2kA&<Space>]],
    opts
)
km.set(

    "i",
    [[;enum]],
    [[\begin{enumerate}<cr><cr>\end{enumerate}<esc>ki<tab>\item]],
    opts
)
km.set(
    "i",
    [[;ta]],
    [[\begin{tabular}{<++>}<CR><CR>\end{tabular}<Esc>ki]],
    opts
)
km.set("i", [[;ca]], [[\begin{cases}<CR><CR>\end{cases}<Esc>ki]], opts)
km.set("i", [[;ce]], [[\begin{center}<CR><CR>\end{center}<Esc>ki]], opts)
--Paste equation RHS on line below
km.set({ "i" }, ";eq", "<Esc>F=y$A\\<Esc>o&<Space><Esc>pF=", opts)
