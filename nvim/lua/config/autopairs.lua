local apairs = require('nvim-autopairs').setup{}
--fast_wrap = {}map_c_w = true
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp_config.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

local Rule = require('nvim-autopairs.rule')

apairs.add_rule(Rule("$$","$$","rmd"))
