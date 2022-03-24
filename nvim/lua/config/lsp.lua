local format_diagnostic = function(diagnostic)
        -- I think this should work ...?
        local lookup = {[1] = 'Error', [2] = 'Warning', [3] = 'Info', [4] = 'Hint'}
        local format = lookup[diagnostic.severity] or ''
        return string.format(format .. ': %s', diagnostic.message)
end

--if not vim.g.lsp_done then

--TODO store global LSP settings in L table like a civilized person
 lspkind = require('lspkind')
 on_attach = function(client, bufnr)
  --if  vim.b.zotcite_omnifunc then
       --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', [[zotcite#CompleteBib]])
  --else
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  --end

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float(nil, {header = "Line Diagnostics", format = format_diagnostic})<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
  -- From https://github.com/martinsione/dotfiles/blob/master/src/.config/nvim/lua/modules/config/nvim-lspconfig/on-attach.lua
  --Highlight group here screwing up syntax somehow
  --if client then
      --if client.name ~= 'null-ls' and client.resolved_capabilities.document_formatting then

      --vim.cmd [[
          ----augroup Format
            ----autocmd! * <buffer>
            ----autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()
          ----augroup END
          --]]
      --end
        --if client.resolved_capabilities.document_highlight then
              ----
              --vim.cmd [[
                --autocmd!
                --autocmd ColorScheme *
                --\ | highlight! default LspReferenceRead cterm=bold gui=Bold ctermbg=yellow guifg=yellow guibg=purple4
                --\ | highlight! default LspReferenceText cterm=bold gui=Bold ctermbg=red guifg=SlateBlue guibg=MidnightBlue
                --\ | highlight! default LspReferenceWrite cterm=bold gui=Bold ctermbg=red guifg=DarkSlateBlue guibg=MistyRose
                --augroup lsp_document_highlight
                  --autocmd! * <buffer>
                  --autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
                  --autocmd CursorHoldI  <buffer> lua vim.lsp.buf.document_highlight()
                  --autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                  --autocmd CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
                --augroup END
              --]]
    --end
--end
--
end

local lua_dir = vim.fn.expand('$HOME') .. '/.local/bin/lua-language-server'
local path = vim.fn.split(package.path, ';')
table.insert(path, 'lua/?.lua')
table.insert(path, 'lua/?/init.lua')

local servers = {r_language_server = {},
pyright={},
bashls={ filetypes = {'sh', 'bash'}},
sumneko_lua = { Lua = {
         cmd = {lua_dir .. '/bin', '-E', lua_dir .. '/main.lua'},
        IntelliSense = {traceBeSetted = true},
        color = {mode = 'Grammar'},
      runtime = {
        version = 'LuaJIT',
        path = path,
      },
      diagnostics = {
        globals = {'vim', 'use'},
        disable = {'lowercase-global'}
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      }
    }
  }
}



local border = {
      {'🭽', 'FloatBorder'},
      {'▔', 'FloatBorder'},
      {'🭾', 'FloatBorder'},
      {'▕', 'FloatBorder'},
      {'🭿', 'FloatBorder'},
      {'▁', 'FloatBorder'},
      {'🭼', 'FloatBorder'},
      {'▏', 'FloatBorder'},
}
vim.diagnostic.config({format = format_diagnostic, update_in_insert = true, severity_sort = true})
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
 --see https://www.reddit.com/r/neovim/comments/q2s0cg/looking_for_function_signature_plugin/
local handlers = { ['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help, {
                border = border,
                close_events = {'CursorMoved', 'BufHidden'},
            }
        ),
['textDocument/publishDiagnostics'] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        source = 'if_many',
    format = format_diagnostic},
    update_in_insert = true,
    underline = true,
    severity_sort = true
    }
),
['textDocument/hover'] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
}
-- From https://github-wiki-see.page/m/neovim/nvim-lspconfig/wiki/UI-customization
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end


local nvim_lsp = require('lspconfig')

for server, settings in pairs(servers) do
    nvim_lsp[server].setup{
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
    settings = settings,
    flags = {
        debounc_text_changes = 150
    }
    }
end
vim.g.lsp_done = true
--vim.lsp.set_log_level('debug')
--end
