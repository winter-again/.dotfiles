local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    s(
        { trig = "iferr", desc = "Handle err" },
        fmta(
            [[
        if err != nil {
            <res>
        }
        ]],
            { res = i(1) }
        )
    ),
    s(
        { trig = "err", desc = "Handle error single line" },
        fmta(
            [[
        if err := <func>(); err != nil {
            <res>
        }
        ]],
            { func = i(1, "func"), res = i(2, "res") }
        )
    ),
}
