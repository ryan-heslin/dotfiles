local config = require("nvim-surround.config")

local add_key_surround = function()
    local container = config.get_input("Enter object name: ")
    if container then
        return {{container .. '["'}, { '"]'}}
    end
end

-- Matches reference to table key, e.g. foo["bar"] -> 'foo["]' , '"]'
local key_pattern = [=[([%w_]+%[["'])()[^"']*(["']%])()]=]

require("nvim-surround").setup( { surrounds = { ["k"] = {
add = add_key_surround,
find = key_pattern,
delete = key_pattern,
change = { target = key_pattern,
    replacement = add_key_surround
}
} } })
