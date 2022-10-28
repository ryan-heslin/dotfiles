--Mostly copied defaults
local key = table.concat(text_extensions)
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
