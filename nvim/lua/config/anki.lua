require("anki").setup({
    -- this function will add support for associating '.anki' extension with 'anki' filetype.
    tex_support = true,
    models = {
        -- Here you specify which notetype should be associated with which deck
        Basic = "Probability",
        ["Basic (and reversed card)"] = "Probability",
        Cloze = "Probability",
    },
})
