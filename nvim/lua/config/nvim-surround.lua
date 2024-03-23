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

local replace_chunk_surround = function()
    local new = config.get_input("Enter new chunk options: ")
    return { new, "" }
end

local add_chunk_surround = function()
    local language = config.get_input("Enter chunk language: ")
    local options = config.get_input("Enter chunk options: ")
    return { { "```{" .. language .. " " .. options .. "}\r" }, { "\r```" } }
end

local find_match = function(pattern, step, stop_pattern)
    local current = vim.api.nvim_get_current_line()
    local threshold = (step > 0 and vim.fn.line("$")) or 0
    while current ~= threshold do
        local line = vim.fn.line(current)
        local stop = string.match(line, stop_pattern)
        if stop then
            return nil
        end
        local match = string.match(line, pattern)
        if match then
            return match
        end
        current = current + step
    end
end

-- Matches reference to table key, e.g. foo["bar"] -> 'foo["]' , '"]'
local quoted_pattern = [=[([%w_]+%[["'])()[^"']*(["']%])()]=]
--  Indirect referernces: foo[bar] -> 'foo[", "]'
local unquoted_pattern = [=[([%w_]+%[)()[^]]+(%])()]=]
local chunk_pattern = [=[^(```[^`])(\n.+)(```)(%s*)$]=]
local chunk_surround = add_key_surround("c")
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
        ["~"] = {
            -- Surround with markdown code block, triple backticks.
            -- <https://github.com/kylechui/nvim-surround/issues/88>
            add = function()
                local config = require("nvim-surround.config")
                local result = config.get_input("Code block language: ")
                return {
                    { "```\n" .. result, "" },
                    { "", "```" },
                }
            end,
            find = chunk_pattern,
            delete = chunk_pattern,
            change = {
                target = [=[^```{?([^`)]}?)()\n.+()```()%s*$]=],
                replace_chunk_surround,
            },
        },
    },
})
