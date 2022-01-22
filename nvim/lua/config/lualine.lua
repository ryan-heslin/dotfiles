-- Lightly modified from defaults
local lualine = require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox_dark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '|', right = '|'},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode', {'getcwd'}},
    lualine_b = {'branch', 'diff', {'diagnostics',
update_in_insert = true}
},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {{'%L'}, 'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
  lualine_a = {{'buffers',
  mode = 2,
  }
  },
  lualine_b = {},
  lualine_c = {'filename'},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {'tabs'}
},
  extensions = {}
}
