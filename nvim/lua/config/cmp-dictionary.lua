--Mostly copied defaults
-- local paths = { ft = {} }
-- for ft in { "rmarkdown", "text", "quarto", "" } do
--     paths["ft"][ft] = "/usr/share/dict/words.pre-dictionaries-common"
-- end

require("cmp_dictionary").setup({
    paths = {},
    -- document = false,
    -- document_command = "wn %s -over",
    exact_length = 3,
    first_case_insensitive = false,
    max_number_items = 8,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "rmarkdown", "quarto", "" },
    callback = function()
        --local paths = dict.ft[ev.match] or {}
        --vim.list_extend(paths, {"/usr/share/dict/words.pre-dictionaries-common"})
        require("cmp_dictionary").setup({
            paths = { "/usr/share/dict/words.pre-dictionaries-common" },
        })
    end,
})
