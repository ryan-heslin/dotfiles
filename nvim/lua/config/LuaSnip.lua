local ls = require("luasnip")
local extras = require("luasnip.extras")
snippets_path = os.getenv("DOTFILES_DIR") .. "/nvim/LuaSnip"
local loader = require("luasnip.loaders.from_lua")
local km = vim.keymap
--TODO convert to Lua
vim.cmd([[
" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]])
loader.lazy_load({ paths = snippets_path })
-- Refresh snippets
km.set("n", "<Leader>L", function()
    require("luasnip.loaders.from_lua").load({ paths = snippets_path })
end)
vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
ls.setup({
    autosnippet = true,
    snip_env = {
        ls = ls,
        s = ls.snippet,
        sn = ls.snippet_node,
        isn = ls.indent_snippet_node,
        t = ls.text_node,
        i = ls.insert_node,
        f = ls.function_node,
        c = ls.choice_node,
        d = ls.dynamic_node,
        r = ls.restore_node,
        events = require("luasnip.util.events"),
        ai = require("luasnip.nodes.absolute_indexer"),
        extras = extras,
        l = extras.lambda,
        rep = extras.rep,
        p = extras.partial,
        m = extras.match,
        n = extras.nonempty,
        dl = extras.dynamic_lambda,
        fmt = require("luasnip.extras.fmt").fmt,
        fmta = require("luasnip.extras.fmt").fmta,
        conds = require("luasnip.extras.expand_conditions"),
        postfix = require("luasnip.extras.postfix").postfix,
        types = require("luasnip.util.types"),
        parse = require("luasnip.util.parser").parse_snippet,
        ms = ls.multi_snippet,
        -- rec_ls = function()
        --     return sn(nil, {
        --         c(1, {
        --             -- important!! Having the sn(...) as the first choice will cause infinite recursion.
        --             t({ "" }),
        --             -- The same dynamicNode as in the snippet (also note: self reference).
        --             sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
        --         }),
        --     })
        -- end,
    },
})
