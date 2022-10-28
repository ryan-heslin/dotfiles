-- Minimal configuration copied directly from repository
cmp_config = require("cmp")
cmp_config.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
        completion = cmp_config.config.window.bordered(),
        documentation = cmp_config.config.window.bordered(),
    },
    mapping = cmp_config.mapping.preset.insert({
        ["<C-b>"] = cmp_config.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp_config.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp_config.mapping.complete(),
        ["<C-e>"] = cmp_config.mapping.abort(),
        ["<CR>"] = cmp_config.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp_config.config.sources({
        { name = "nvim_lsp" },
        { name = "ultisnips" },
        { name = "buffer" },
    }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp_config.setup.cmdline("/", {
    mapping = cmp_config.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp_config.setup.cmdline(":", {
    mapping = cmp_config.mapping.preset.cmdline(),
    sources = cmp_config.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})
