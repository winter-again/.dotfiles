local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        { trig = "iferr", desc = "Err check" },
        fmt(
            [[
        if err != nil {{
            {}
        }}
        ]],
            { i(1, "return err") }
        )
    ),
}
