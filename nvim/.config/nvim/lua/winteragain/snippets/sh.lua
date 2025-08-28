local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    s(
        { trig = ";s", desc = "shebang" },
        fmta(
            [[
            #!/usr/bin/env bash

            <>
            ]],
            { i(1) }
        )
    ),
}
