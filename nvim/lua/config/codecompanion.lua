require("codecompanion").setup({
    adapters = {
        openai = function()
            return require("codecompanion.adapters").extend("openai", {
                env = {
                    api_key = "",
                },
            })
        end,
    },
})
