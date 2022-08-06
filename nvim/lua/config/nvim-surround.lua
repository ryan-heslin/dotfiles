-- Mostly copied from defaults
local aliases = {
    ["a"] = ">", -- Single character aliases apply everywhere
    ["p"] = ")",
    ["B"] = "}",
    ["r"] = "]",
    -- Table aliases only apply for changes/deletions
    ["q"] = { '"', "'", "`" }, -- Any quote character
    ["s"] = { ")", "]", "}", ">", "'", '"', "`" }, -- Any surrounding delimiter
}
require("nvim-surround").setup({
    keymaps = { -- vim-surround style keymaps
        insert = "yss",
        insert_line = "ysss",
        visual = "S",
        delete = "ds",
        change = "cs",
    },
    -- Each pattern should be a valid Lua pattern with left and right groups 
    -- representing start and end characters
    surrounds = {
            ["("] = {
                add = { "( ", " )" },
                find = function()
                    return M.get_selection({ textobject = "(" })
                end,
                delete = "^(. ?)().-( ?.)()$",
                change = {
                    target = "^(. ?)().-( ?.)()$",
                },
            },
            [")"] = {
                add = { "(", ")" },
                find = function()
                    return M.get_selection({ textobject = ")" })
                end,
                delete = "^(.)().-(.)()$",
                change = {
                    target = "^(.)().-(.)()$",
                },
            },
            ["{"] = {
                add = { "{ ", " }" },
                find = function()
                    return M.get_selection({ textobject = "{" })
                end,
                delete = "^(. ?)().-( ?.)()$",
                change = {
                    target = "^(. ?)().-( ?.)()$",
                },
            },
            ["}"] = {
                add = { "{", "}" },
                find = function()
                    return M.get_selection({ textobject = "}" })
                end,
                delete = "^(.)().-(.)()$",
                change = {
                    target = "^(.)().-(.)()$",
                },
            },
            ["<"] = {
                add = { "< ", " >" },
                find = function()
                    return M.get_selection({ textobject = "<" })
                end,
                delete = "^(. ?)().-( ?.)()$",
                change = {
                    target = "^(. ?)().-( ?.)()$",
                },
            },
            [">"] = {
                add = { "<", ">" },
                find = function()
                    return M.get_selection({ textobject = ">" })
                end,
                delete = "^(.)().-(.)()$",
                change = {
                    target = "^(.)().-(.)()$",
                },
            },
            ["["] = {
                add = { "[ ", " ]" },
                find = function()
                    return M.get_selection({ textobject = "[" })
                end,
                delete = "^(. ?)().-( ?.)()$",
                change = {
                    target = "^(. ?)().-( ?.)()$",
                },
            },
            ["]"] = {
                add = { "[", "]" },
                find = function()
                    return M.get_selection({ textobject = "]" })
                end,
                delete = "^(.)().-(.)()$",
                change = {
                    target = "^(.)().-(.)()$",
                },
            },
            ["'"] = {
                add = { "'", "'" },
                find = function()
                    return M.get_selection({ textobject = "'" })
                end,
                delete = "^(.)().-(.)()$",
                change = {
                    target = "^(.)().-(.)()$",
                },
            },
            ['"'] = {
                add = { '"', '"' },
                find = function()
                    return M.get_selection({ textobject = '"' })
                end,
                delete = "^(.)().-(.)()$",
                change = {
                    target = "^(.)().-(.)()$",
                },
            },
            ["`"] = {
                add = { "`", "`" },
                find = function()
                    return M.get_selection({ textobject = "`" })
                end,
                delete = "^(.)().-(.)()$",
                change = {
                    target = "^(.)().-(.)()$",
                },
            },
            ["i"] = { -- TODO: Add find/delete/change functions
                add = function()
                    local left_delimiter = M.get_input("Enter the left delimiter: ")
                    local right_delimiter = left_delimiter and M.get_input("Enter the right delimiter: ")
                    if right_delimiter then
                        return { { left_delimiter }, { right_delimiter } }
                    end
                end,
                find = function() end,
                delete = function() end,
                change = { target = function() end },
            },
            ["t"] = {
                add = function()
                    local input = M.get_input("Enter the HTML tag: ")
                    if input then
                        local element = input:match("^<?([%w-]+)")
                        local attributes = input:match("%s+([^>]+)>?$")
                        if not element then
                            return nil
                        end

                        local open = attributes and element .. " " .. attributes or element
                        local close = element

                        return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
                    end
                end,
                find = function()
                    return M.get_selection({ textobject = "t" })
                end,
                delete = "^(%b<>)().-(%b<>)()$",
                change = {
                    target = "^<([%w-]*)().-([^/]*)()>$",
                    replacement = function()
                        local element = M.get_input("Enter the HTML element: ")
                        if element then
                            return { { element }, { element } }
                        end
                    end,
                },
            },
            ["T"] = {
                add = function()
                    local input = M.get_input("Enter the HTML tag: ")
                    if input then
                        local element = input:match("^<?([%w-]+)")
                        local attributes = input:match("%s+([^>]+)>?$")
                        if not element then
                            return nil
                        end

                        local open = attributes and element .. " " .. attributes or element
                        local close = element

                        return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
                    end
                end,
                find = function()
                    return M.get_selection({ textobject = "t" })
                end,
                delete = "^(%b<>)().-(%b<>)()$",
                change = {
                    target = "^<([^>]*)().-([^%/]*)()>$",
                    replacement = function()
                        local input = M.get_input("Enter the HTML tag: ")
                        if input then
                            local element = input:match("^<?([%w-]+)")
                            local attributes = input:match("%s+([^>]+)>?$")
                            if not element then
                                return nil
                            end

                            local open = attributes and element .. " " .. attributes or element
                            local close = element

                            return { { open }, { close } }
                        end
                    end,
                },
            },
            ["f"] = {
                add = function()
                    local result = M.get_input("Enter the function name: ")
                    if result then
                        return { { result .. "(" }, { ")" } }
                    end
                end,
                find = "[%w%-_:.>]+%b()",
                delete = "^([%w%-_:.>]+%()().-(%))()$",
                change = {
                    target = "^.-([%w_]+)()%b()()()$",
                    replacement = function()
                        local result = M.get_input("Enter the function name: ")
                        if result then
                            return { { result }, { "" } }
                        end
                    end,
                },
            },
            invalid_key_behavior = {
                add = function(char)
                    return { { char }, { char } }
                end,
                find = function(char)
                    return M.get_selection({
                        pattern = vim.pesc(char) .. ".-" .. vim.pesc(char),
                    })
                end,
                delete = function(char)
                    return M.get_selections({
                        char = char,
                        pattern = "^(.)().-(.)()$",
                    })
                end,
                change = {
                    target = function(char)
                        return M.get_selections({
                            char = char,
                            pattern = "^(.)().-(.)()$",
                        })
                    end,
                },
            },
        },
        --invalid_key_behavior = function(char)
            --vim.api.nvim_err_writeln(
                --"Error: Invalid surround character " .. M.surround_string(char)
            --)
        --end,
        --pairs = {
            --["("] = { "( ", " )" },
            --[")"] = { "(", ")" },
            --["{"] = { "{ ", " }" },
            --["}"] = { "{", "}" },
            --["<"] = { "< ", " >" },
            --[">"] = { "<", ">" },
            --["["] = { "[ ", " ]" },
            --["]"] = { "[", "]" },
            ---- Define pairs based on function evaluations!
            --["i"] = function()
                --return {
                    --vim.fn.input(
                        --"Enter left delimiter: "
                    --),
                    --vim.fn.input(
                        --"Enter right delimiter: "
                    --),
                --}
            --end,
            --["f"] = function()
                --return {
                    --vim.fn.input(
                        --"Enter function name: "
                    --) .. "(",
                    --")",
                --}
            --end,
            ---- Transform name into element of container
            --["k"] =  function()
                --return {
                --vim.fn.input("Enter container name: ")..[=[["]=],
                --[=["]]=]
            --}
        --end
        --},
        --separators = {
            --["'"] = { "'", "'" },
            --['"'] = { '"', '"' },
            --["`"] = { "`", "`" },
        --},
        --HTML = {
            --["t"] = "type", -- Change just the tag type
            --["T"] = "whole", -- Change the whole tag contents
        --},
        aliases = aliases,
    highlight= { -- Highlight before inserting/changing surrounds
        duration = 0,
    },
})

-- Enable insert surrounds for non-table aliases
for alias, char in ipairs(aliases) do
    if type(char) == "string" then
        vim.keymap.set("o", alias, char)
    end
end
