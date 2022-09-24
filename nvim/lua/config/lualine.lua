-- Replaces path to home directory with ~, or just current directory if too long
local home_path = function()
    local cur_wd = vim.fn.getcwd(vim.api.nvim_get_current_win())
    local modifier = (string.len(cur_wd) <= 30) and ":~" or ":t"
    return vim.fn.fnamemodify(cur_wd, modifier)
end

-- Lightly modified from defaults
 require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "gruvbox_dark",
        component_separators = { left = "", right = "" },
        section_separators = { left = "|", right = "|" },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode", { home_path } },
        lualine_b = {
            "branch",
            "diff",
            {
                "diagnostics",
                update_in_insert = true,
                sources = { "nvim_lsp",  "ale" },
            },
        },
        lualine_c = { { "filename", newfile_status = true } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { { "%L" }, "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {
        lualine_a = {
            {
                "buffers",
                mode = 2,
                max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                filetype_names = {
                    TelescopePrompt = "Telescope",
                    packer = "Packer",
                    fzf = "FZF",
                }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

                buffers_color = {
                    -- Same values as the general color option can be used here.
                    active = "TabLineSel", -- Color for active buffer.
                    inactive = "TabLineFill", -- Color for inactive buffer.
                },
                symbols = {
                    modified = " +", -- Text to show when the buffer is modified
                    alternate_file = "#", -- Text to show to identify the alternate file
                    directory = "", -- Text to show when the buffer is a directory
                },
            },
        },
        lualine_b = {
            {
                "windows",
                show_filename_only = true, -- Shows shortened relative path when set to false.
                show_modified_status = true, -- Shows indicator when the window is modified.

                mode = 0, -- 0: Shows window name
                -- 1: Shows window index
                -- 2: Shows window name + window index

                max_length = vim.o.columns * 2 / 3, -- Maximum width of windows component,
                -- it can also be a function that returns
                -- the value of `max_length` dynamically.
                filetype_names = {
                    TelescopePrompt = "Telescope",
                    packer = "Packer",
                    fzf = "FZF",
                }, -- Shows specific window name for that filetype ( { `filetype` = `window_name`, ... } )

                disabled_buftypes = { "quickfix", "prompt" }, -- Hide a window if its buffer's type is disabled

                windows_color = {
                    -- Same values as the general color option can be used here.
                    active = "lualine_b_normal", -- Color for active window.
                    inactive = "lualine_b_inactive", -- Color for inactive window.
                },
            },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
            {
                "tabs",
                max_length = vim.o.columns / 3, -- Maximum width of tabs component.
                -- Note:
                -- It can also be a function that returns
                -- the value of `max_length` dynamically.
                mode = 2, -- 0: Shows tab_nr
                -- 1: Shows tab_name
                -- 2: Shows tab_nr + tab_name

                tabs_color = {
                    -- Same values as the general color option can be used here.
                    active = "lualine_z_normal", -- Color for active tab.
                    inactive = "lualine_z_inactive", -- Color for inactive tab.
                },
            },
        },
    },
    extensions = {},
})
