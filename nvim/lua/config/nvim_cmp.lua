cmp_config = require('cmp')
local cmp_buffer = require('cmp_buffer')
   sources = {
    { name = 'nvim_lsp',
        max_item_count = 10,
        keyword_length = 2},
    { name = 'buffer',
        max_item_count = 10,
        keyword_length = 3},
    { name = 'path',
    keyword_length = 2},
      {name = "latex_symbols"},
      {name = "nvim_lua"},
    { name = 'ultisnips' }
  }
  --require('telescope').load_extension("fzf")

    local check_back_space = function()
      local col = vim.fn.col(".") - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
    end

    local has_any_words_before = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local press = function(key)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
  end
  cmp_config.setup({
    completion = {
        completeopt = 'menu,menuone,preview,noselect',
        get_trigger_characters = function(trigger_characters)
            if vim.bo.filetype == "r" or vim.bo.filetype == "rmd" then
                table.insert(trigger_characters, "$")
            end
            --bibliography completion
            if vim.bo.filetype == "tex" or vim.bo.filetype == "rmd" then
                table.insert(trigger_characters, "@")
            end
            return trigger_characters
        end,

        },
    documentation = {
        maxwidth = 80,
        --winhighlight=,
        maxheight = 60
    },
    experimental = {
        ghost_text = true
        },
    --documentation.winhighlight=,
    formatting = {
        format = lspkind.cmp_format({
        maxwidth = 50,
        with_text = false,
        menu = {
            buffer = "{buf}",
            nvim_lsp = "{LSP}",
            path = "{path}",
            spell = "{spell}",
            ultisnips = "{snip}"
        }
    })
},
    sorting= {
        comparators ={
           function(...) return cmp_buffer:compare_locality(...) end
        },
        priority_weight = 3},
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp_config.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp_config.mapping.scroll_docs(4),
      ['<C-e>'] = cmp_config.mapping.close(),
      ['<CR>'] = cmp_config.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp_config.mapping(function(fallback)
          if cmp_config.visible() then
            if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
              return press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
            end
            cmp_config.select_next_item()
          elseif has_any_words_before() then
            press("<Space>")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<Tab>"] = cmp_config.mapping(function(fallback)
          if vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
            press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
          elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            press("<ESC>:call UltiSnips#JumpForwards()<CR>")
          elseif cmp_config.visible() then
            cmp_config.select_next_item()
          elseif has_any_words_before() then
            press("<Tab>")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<C-z>"] = cmp_config.mapping(function(fallback)  --nested snippets
        if vim.fn["UltiSnips#CanJumpForwards"]() == 1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
            press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
        else
            fallback()
        end
    end, {"i",
    "s"}),
        ["<S-Tab>"] = cmp_config.mapping(function(fallback)
          if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
            press("<ESC>:call UltiSnips#JumpBackwards()<CR>")
          elseif cmp_config.visible() then
            cmp_config.select_prev_item()
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
      },
    sources = sources
  })

  --Extra completion sources

  cmp_config.setup.cmdline(':', {
    sources = {
      { name = 'cmdline' }
    }
  })

    cmp_config.setup.cmdline('?', {
    sources = {
      { name = 'buffer' }
    }
  })

  cmp_config.setup.cmdline('@', {
  sources = {
    { name = 'buffer' }
  }
})

  cmp_config.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })
