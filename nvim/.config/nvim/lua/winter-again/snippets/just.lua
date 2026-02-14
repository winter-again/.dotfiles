local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    s(
        { trig = "just", desc = "justfile default recipe for listing recipes" },
        fmta(
            [[
            @_:
                just --list

            <>
            ]],
            { i(1) }
        )
    ),
}
