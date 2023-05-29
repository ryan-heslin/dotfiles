require("config/LuaSnip-helpers")
local field = "<>"

local make_matrix = function(nrow, ncol)
    local row = {}
    for _ in 1, ncol, 1 do
        table.insert(row, field)
    end

    local row_str = table.concat(row, " & ")
    local rows = { [[\begin{bmatrix}]] }
    for i in 1, nrow, 1 do
        table.insert(rows, row_str)
        -- Add linebreak on all but last row
        if i ~= nrow then
            rows[i] = rows[i] .. " \\"
        end
    end

    table.insert(rows, [[\end{bmatrix}]])
    local format = table.concat(rows, "\n")
    local snippets = {}

    for idx in 1, nrow * ncol, 1 do
        table.insert(
            snippets,
            i(idx, math.floor(idx / nrow) .. "," .. idx % ncol)
        )
    end
    return sn(nil, fmta(format, snippets))
end
local rec_ls = function()
    return sn(nil, {
        c(1, {
            -- important!! Having the sn(...) as the first choice will cause infinite recursion.
            t({ "" }),
            -- The same dynamicNode as in the snippet (also note: self reference).
            sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
        }),
    })
end
return sn({
    trig = "m(%d+)x(%d+)",
    snippetType = "autosnippet",
    wordTrig = false,
    regTrig = true,
    desc = "n by m matrix",
}, {
    d(1, function(_, snip, _, _)
        return make_matrix(
            tonumber(snip.captures[1]),
            tonumber(snip.captures[2])
        )
    end),
})
-- return {
--     s({ trig = "list" }, {
--         t({ "\\begin{itemize}", "\t\\item " }),
--         i(1),
--         d(2, rec_ls, {}, {}),
--         t({ "", "\\end{itemize}" }),
--         i(0),
