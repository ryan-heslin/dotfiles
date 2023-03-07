--vim.g.UltiSnipsExpandTrigger='<F2>'
--vim.g.UltiSnipsJumpForwardTrigger='<Tab>'
--vim.g.UltiSnipsJumpBackwardTrigger='<S-Tab>'
--vim.g.UltiSnipsSnippetDirectories={ 'UltiSnips', 'custom_snippets' }
--vim.g.UliSnipsListSnippets='<F2>'
--vim.g.UltiSnipsRemoveSelectModeMappings = 0
--
local UltiSnips = vim.fn.stdpath("config") .. "/custom_snippets"
vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
vim.g.UltiSnipsRemoveSelectModeMappings = 0
vim.g.UltiSnipsEditSplit = "context"
vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = UltiSnips
vim.cmd(
    [=[let g:UltiSnipsSnippetDirectories =  ["UltiSnips", stdpath('config') . '/custom_snippets']]=]
)
