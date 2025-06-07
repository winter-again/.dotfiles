local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        { trig = "#!", desc = "Shebang" },
        fmt(
            [[
        #!/usr/bin/env bash
        {}
        ]],
            { i(1) }
        )
    ),
}
