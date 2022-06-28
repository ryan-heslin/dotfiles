-- Makefiles require literal tabs
vim.bo.expandtab = false
-- Dry run
vim.keymap.set(
    { "n" },
    "<leader>dr",
    ":!make --just-print",
    { silent = true, noremap = true }
)
