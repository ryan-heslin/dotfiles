
 --  Largely boilerplate from official repo
local apairs = require('nvim-autopairs')
apairs.setup{fast_wrap = {}, map_c_h = true}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp_config.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

-- Factory for function to put cursor on line between pair chars
local end_middle = function(chars) return function() return '-enter><enter>' ..chars ..'<up>' end end
apairs.add_rules({
    Rule("$$","$$","rmd")
        :replace_endpair(end_middle('$$')),
    Rule("`", "`", "rmd")
        :with_pair(cond.not_after_regex("`+")),
    Rule("\\[","\\]","rmd"),
    Rule("'", "'", 'r')
        :with_pair(cond.not_after_regex("[#]")),
    Rule('(', ')', '')
        :with_pair(function() return vim.bo.buftype == '' and cond.not_before_regex('%w') end),
      -- Rule([[%\begin%{%w+%}]], '', 'rmd')
         -- :use_regex(true, '<tab>')
         -- :replace_endpair(function(opts)
             -- return [[F}yi{o<enter>\end{<c-o>P}<up>]]
             -- end
             -- )
        })
