local config = require("nvim-surround.config")

-- Factory that returns function that surrounds key with a given character
local add_key_surround = function(surround)
    return function()
        local container = config.get_input("Enter object name: ")
        if container then
            return { { container .. "[" .. surround }, { surround .. "]" } }
        end
    end
end

-- Matches reference to table key, e.g. foo["bar"] -> 'foo["]' , '"]'
local quoted_pattern = [=[([%w_]+%[["'])()[^"']*(["']%])()]=]
--  Indirect referernces: foo[bar] -> 'foo[", "]'
local unquoted_pattern = [=[([%w_]+%[)()[^]]+(%])()]=]
local quoted_surround = add_key_surround([["]])
local unquoted_surround = add_key_surround("")

require("nvim-surround").setup({
    surrounds = {
        ["k"] = {
            add = quoted_surround,
            find = quoted_pattern,
            delete = quoted_pattern,
            change = {
                target = quoted_pattern,
            },
        },
        ["K"] = {
            add = unquoted_surround,
            find = unquoted_pattern,
            delete = unquoted_pattern,
            change = {
                target = unquoted_pattern,
            },
        },
    },
})
