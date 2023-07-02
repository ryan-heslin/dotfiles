vim.keymap.set(
    { "i" },
    [[;bb]],
    [[****<Esc>hi]],
    { noremap = true, silent = true }
)
vim.keymap.set(
    { "i" },
    [[;ii]],
    [[**<Esc>i]],
    { noremap = true, silent = true }
)
--Insert Markdown link around previous word, pasting URL from clipboard
vim.keymap.set({ "i" }, ";lk", '<Esc>Bi[<Esc>ea](<Esc>"+pA)<Space>', opts)
