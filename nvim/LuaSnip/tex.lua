require("config/LuaSnip-helpers")

local make_matrix = function(rows, cols)
    local open = [[\begin{bmatrix}]]
    local close = [[\end{bmatrix}]]
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
return {
    s({ trig = "list" }, {
        t({ "\\begin{itemize}", "\t\\item " }),
        i(1),
        d(2, rec_ls, {}, {}),
        t({ "", "\\end{itemize}" }),
        i(0),
    }),
}
