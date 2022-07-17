local word_regex = [[\w\+]]
local validate_buffer = function(bufnr, max_size, ignore_hidden, filetype)
    local max_size = M.default_arg(max_size, 1024 * 1024)
    local ignore_hidden = M.default_arg(hidden, true)
    local filetype = M.default_arg(vim.bo.filetype)
    return (not ignore_hidden or vim.api.nvim_buf_is_loaded(bufnr))
        and vim.api.nvim_buf_get_offset(
            bufnr,
            vim.api.nvim_buf_line_count(bufnr)
        ) <= max_size
        and vim.api.nvim_buf_get_option(bufnr, "filetype") == filetype
end

-- From documentation: complete from all visible buffers
-- Not working
local get_bufnrs = function(ignore_hidden)
    local megabyte = 1024 * 1024
    local buffers = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        buffers[bufnr] = validate_buffer(bufnr, megabyte, ignore_hidden)
    end
    return vim.tbl_keys(buffers)
end

cmp_config = require("cmp")
local cmp_buffer = require("cmp_buffer")

sources = {
    {
        name = "nvim_lsp",
        max_item_count = 10,
        keyword_length = 2,
        priority = 8,
    },
    { name = "nvim_lsp_signature_help" },
    {
        name = "buffer",
        max_item_count = 10,
        keyword_length = 3,
        priority = 7,
    },
    { name = "dictionary", keyword_length = 2 },
    { name = "path", keyword_length = 2, priority = 7 },
    { name = "tags", ft = { "r", "rmd", "python" } },
    { name = "nvim_lua" },
    { name = "ultisnips" },
    { name = "calc" },
    { name = "latex_symbols" },
    --comparators = {
    --function(...) return cmp_buffer:compare_locality(...) end
    --},
    --get_bufnrs = {function() return get_bufnrs() end}
}
--require('telescope').load_extension('fzf')
local check_back_space = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

local has_any_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
                :sub(col, col)
                :match("%s")
            == nil
end

local press = function(key)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(key, true, true, true),
        "n",
        true
    )
end

-- From official repo
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
local M = {}
function M.expand_or_jump_forwards(fallback)
    M.compose({ "expand", "jump_forwards", "select_next_item" })(fallback)
end

function M.jump_backwards(fallback)
    M.compose({ "jump_backwards", "select_prev_item" })(fallback)
end
cmp_config.setup({
    completion = {
        completeopt = "menu,menuone,preview,noselect",
        get_trigger_characters = function(trigger_characters)
            if false or vim.bo.filetype == "r" or vim.bo.filetype == "rmd" then
                --table.insert(trigger_characters, '$')
                trigger_characters["$"] = 1
            end
            if
                false
                or vim.bo.filetype == "tex"
                or vim.bo.filetype == "rmd"
            then
                --table.insert(trigger_characters, '@')
                trigger_characters["@"] = 1
            end
            return trigger_characters
        end,
    },
    window = {
        completion = cmp_config.config.window.bordered(),
        documentation = cmp_config.config.window.bordered(),
    },
    experimental = {
        ghost_text = true,
    },
    --view = {entries = 'native'},
    formatting = {
        format = lspkind.cmp_format({
            maxwidth = 50,
            with_text = false,
            menu = {
                buffer = "{buf}",
                dictionary = "{dict}",
                latex_symbols = "{TeX}",
                nvim_lsp = "{LSP}",
                path = "{path}",
                spell = "{spell}",
                tags = "{tags}",
                ultisnips = "{snip}",
            },
        }),
    },
    -- Order suggested by https://www.reddit.com/r/neovim/comments/u3c3kw/how_do_you_sorting_cmp_completions_items/
    sorting = {
        comparators = {
            -- cmp_config.config.compare.score_offset,
            cmp_config.config.compare.locality,
            cmp_config.config.compare.recently_used,
            cmp_config.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
            --require("cmp-under-comparator").under,
            cmp_config.config.compare.offset,
            cmp_config.config.compare.order,
            -- cmp_config.config.compare.scopes, -- what?
            -- cmp_config.config.compare.sort_text,
            -- cmp_config.config.compare.exact,
            -- cmp_config.config.compare.kind,
            -- cmp_config.config.compare.length, -- useless
        },
        priority_weight = 1,
    },
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = cmp_config.mapping.preset.insert({
        ["<C-d>"] = cmp_config.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp_config.mapping.scroll_docs(4),
        ["<C-n>"] = cmp_config.mapping.select_next_item(),
        ["<C-h>"] = cmp_config.mapping.select_prev_item(),
        ["<C-e>"] = cmp_config.mapping.close(),
        ["<CR>"] = cmp_config.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp_config.mapping(function(fallback)
            if cmp_config.visible() then
                cmp_config.select_next_item()
            elseif has_any_words_before() then
                press("<Space>")
            else
                fallback()
            end
        end, {
            "i",
            "s",
            "c",
        }),
        ["<Tab>"] = cmp_config.mapping(function(fallback)
            cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
        end, {
            "i",
            "s",
            "c",
        }),
        ["<C-z>"] = cmp_config.mapping(function(fallback) --nested snippets
            if
                vim.fn["UltiSnips#CanJumpForwards"]() == 1
                and vim.fn["UltiSnips#CanExpandSnippet"]() == 1
            then
                press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp_config.mapping(function(fallback)
            cmp_ultisnips_mappings.jump_backwards(fallback)
        end, {
            "i",
            "s",
            "c",
        }),
    }),
    sources = cmp_config.config.sources(sources),
})

--Extra completion sources

cmp_config.setup.cmdline(":", {
    sources = {
        { name = "cmdline" },
        { name = "path" },
    },
})

cmp_config.setup.cmdline("?", {
    sources = {
        { name = "buffer" },
    },
})

cmp_config.setup.cmdline("@", {
    sources = {
        { name = "buffer" },
    },
})

cmp_config.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})

local spell_filetypes = { "", "rmd", "txt", "pandoc", "quarto" }
local spell_sources = {
    name = "spell",
    max_item_count = 5,
    keyword_length = 3,
    priority = 5,
    keyword_pattern = word_regex,
}
--TODO add dictionary
table.insert(sources, spell_sources)
table.insert(sources, { name = "dictionary", keyword_length = 2 })
for _, ft in ipairs(spell_filetypes) do
    cmp_config.setup.filetype(
        ft,
        { sources = cmp_config.config.sources(sources) }
    )
end
