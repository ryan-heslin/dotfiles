require("config/LuaSnip-helpers")

return {
    s(
        { trig = "for", desc = "for loop" },
        fmta(
            [[
for <> in <>:
    <>

 ]]          ,
            { i(1, "iterator"), i(2, "iterable"), i(3, "body") }
        )
    ),
    s(
        { trig = "while", desc = "while loop" },
        fmta(
            [[
while <>:
    <>
    ]]       ,
            { i(1, "condition"), i(2, "body") }
        )
    ),
    s(
        { trig = "def", desc = "function definition" },
        fmta(
            [[
def <>(<>):
    <>
    ]]       ,
            { i(1, "name"), i(2, "args"), i(3, "body") }
        )
    ),
}
