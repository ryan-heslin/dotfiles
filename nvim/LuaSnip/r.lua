require("config/LuaSnip-helpers")

return {
    s(
        { trig = "for", desc = "for loop" },
        fmta(
            [[
    for(<> in <>){
        <>
    }
 ]],
            { i(1, "iterator"), i(2, "vector"), i(3, "body") }
        )
    ),
    s(
        { trig = "while", desc = "while loop" },
        fmta(
            [[
while(<>){
    <>
}
<>]],
            { i(1, "condition"), i(2, "body"), i(0) }
        )
    ),
    -- s(
    --     { trig = "ggpl", desc = "dynamic ggplot" },
    --     fmta(
    --         [[
    -- ggplot(<>, aes(x = <>, y = <> <>)) +
    --     geom_<>()
    -- ]],
    --         {
    --             i(1, "data"),
    --             i(2, ","),
    --             i(3, "x"),
    --             i(4, "y"),
    --             i(5, ","),
    --             i(6, "extra"),
    --             c(7, { t("point"), t("line"), t("col") }),
    --         }
    --     )
    -- ),
}
