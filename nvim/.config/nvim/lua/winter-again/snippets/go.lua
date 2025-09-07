local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    s(
        { trig = "iferr", snippetType = "autosnippet", desc = "Handle error" },
        fmta(
            [[
            if err != nil {
                <>
            }
            ]],
            { i(1) }
        )
    ),
    s(
        { trig = "err", desc = "Define and handle error in single line" },
        fmta(
            [[
            if err := <func>(); err != nil {
                <res>
            }
            ]],
            { func = i(1, "func"), res = i(2) }
        )
    ),
    s(
        { trig = "switch", desc = "switch statement" },
        fmta(
            [[
            switch <> {
            case <>:
                <>
            default:
                <>
            }
            ]],
            { i(1), i(2), i(3), i(4) }
        )
    ),
}
