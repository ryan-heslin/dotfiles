--Mostly copied defaults
-- TODO enable for text filetypes
local key = table.concat(vim.g.text_extensions)
    require("cmp_dictionary").setup({
        dic = {
            [key] = { "/usr/share/dict/words" },
        },
        exact = 2,
        first_case_insensitive = false,
        document = false,
        document_command = "wn %s -over",
        async = false,
        capacity = 5,
        debug = false,
    })
