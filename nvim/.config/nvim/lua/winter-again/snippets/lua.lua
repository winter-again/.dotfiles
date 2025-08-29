local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    s(
        {
            trig = "for ... in ipairs",
            desc = "ipairs() for loop",
            docstring = { "for index, value in ipairs(t) do", " ", "end" },
        },
        fmta(
            [[
            for <index>, <value> in ipairs(<t>) do
                <tt>
            end
            ]],
            { index = i(1), value = i(2), t = i(3), tt = i(4) }
        )
    ),
    s(
        {
            trig = "for ... in pairs",
            desc = "pairs() for loop",
            docstring = { "for key, value in pairs(t) do", " ", "end" },
        },
        fmta(
            [[
            for <key>, <value> in ipairs(<t>) do
                <tt>
            end
            ]],
            { key = i(1), value = i(2), t = i(3), tt = i(4) }
        )
    ),
    s(
        {
            trig = "function",
            desc = "function definition",
            docstring = { "function ()", " ", "end" },
        },
        fmta(
            [[
            function <>()
                <>
            end
            ]],
            { i(1), i(2) }
        )
    ),
}
