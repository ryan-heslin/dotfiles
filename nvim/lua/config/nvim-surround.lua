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
        insert = "ys",
        insert_line = "yss",
        visual = "S",
        delete = "ds",
        change = "cs",
    },
    delimiters = {
        invalid_key_behavior = function(char)
            vim.api.nvim_err_writeln(
                "Error: Invalid surround character" .. char
            )
        end,
        pairs = {
            ["("] = { "( ", " )" },
            [")"] = { "(", ")" },
            ["{"] = { "{ ", " }" },
            ["}"] = { "{", "}" },
            ["<"] = { "< ", " >" },
            [">"] = { "<", ">" },
            ["["] = { "[ ", " ]" },
            ["]"] = { "[", "]" },
            -- Define pairs based on function evaluations!
            ["i"] = function()
                return {
                    require("nvim-surround.utils").get_input(
                        "Enter left delimiter: "
                    ),
                    require("nvim-surround.utils").get_input(
                        "Enter right delimiter: "
                    ),
                }
            end,
            ["f"] = function()
                return {
                    vim.fn.input(
                        "Enter function name: "
                    ) .. "(",
                    ")",
                }
            end,
            -- Transform name into element of container
            ["k"] =  function()
                return {
                vim.fn.input("Enter container name: ")..[=[["]=],
                [=["]]=]
            }
        end
        },
        separators = {
            ["'"] = { "'", "'" },
            ['"'] = { '"', '"' },
            ["`"] = { "`", "`" },
        },
        HTML = {
            ["t"] = "type", -- Change just the tag type
            ["T"] = "whole", -- Change the whole tag contents
        },
        aliases = aliases,
    },
    highlight_motion = { -- Highlight before inserting/changing surrounds
        duration = 0,
    },
})

-- Enable insert surrounds for non-table aliases
for alias, char in ipairs(aliases) do
    if type(char) == "string" then
        vim.keymap.set("o", alias, char)
    end
end
