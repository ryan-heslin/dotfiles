local km = vim.keymap
require("leap").setup({
    max_phase_one_targets = nil,
    highlight_unlabeled_phase_one_targets = true,
    max_highlighted_traversal_targets = 10,
    case_sensitive = true,
    equivalence_classes = { " \t", "\r\n" },
    substitute_chars = { ["\r"] = "¬", ["\n"] = "¬" },
    safe_labels = { "s", "f", "n", "u", "t" },
    labels = { "s", "f", "n", "j", "k" },
    special_keys = {
        repeat_search = "<enter>",
        next_phase_one_target = "<enter>",
        next_target = { "<enter>", ";" },
        prev_target = { "<tab>", "," },
        next_group = "<space>",
        prev_group = "<tab>",
        multi_accept = "<enter>",
        multi_revert = "<backspace>",
    },
})

km.set({ "n", "v" }, "<Leader>ll", "<plug>(leap-forward-to)", { remap = true })
km.set({ "n", "v" }, "<Leader>LL", "<plug>(leap-backward-to)", { remap = true })
km.set(
    { "n", "v" },
    "<Leader>ww",
    "<plug>(leap-cross-window)",
    { remap = true }
)
km.set(
    { "n", "v" },
    "<Leader>jj",
    "<plug>(leap-forward-till)",
    { remap = true }
)
km.set(
    { "n", "v" },
    "<Leader>JJ",
    "<plug>(leap-backward-till)",
    { remap = true }
)
