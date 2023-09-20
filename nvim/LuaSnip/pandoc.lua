require("config/LuaSnip-helpers")

return {
    s(
        { trig = "ch", desc = "code chunk" },
        fmta([[
    ```{<>}
    <>
    ```
    ]]   ),
        { i(1, "header"), i(0, "body") }
    ),
}
