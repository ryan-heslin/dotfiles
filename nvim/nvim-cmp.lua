local cmp = require('cmp')
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
  cmp.setup({
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
        priority_weight = 3},
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
     -- TODO update using latest features from Ultisnips cmp completion source repo map
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
              return press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
            end
            cmp.select_next_item()
          elseif has_any_words_before() then
            press("<Space>")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
            press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
          elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            press("<ESC>:call UltiSnips#JumpForwards()<CR>")
          elseif cmp.visible() then
            cmp.select_next_item()
          elseif has_any_words_before() then
            press("<Tab>")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<C-z>"] = cmp.mapping(function(fallback)  --nested snippets
        if vim.fn["UltiSnips#CanJumpForwards"]() == 1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
            press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
        else
            fallback()
        end
    end, {"i",
    "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
            press("<ESC>:call UltiSnips#JumpBackwards()<CR>")
          elseif cmp.visible() then
            cmp.select_prev_item()
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
