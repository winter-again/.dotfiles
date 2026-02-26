local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local f = ls.function_node

return {
    s(
        { trig = ";t", snippetType = "autosnippet", desc = "Current date" },
        f(function()
            return os.date("%Y-%m-%d")
        end)
    ),
    s(
        { trig = ";f", snippetType = "autosnippet", desc = "External file link" },
        fmta("[<>](file:///home/winteragain/Documents<>)", { i(1), i(2) })
    ),
    s({ trig = ";l", snippetType = "autosnippet", desc = "Link" }, fmta("[<>](<>)", { i(1), i(2) })),
    s({ trig = ";i", snippetType = "autosnippet", desc = "Image link" }, fmta("![image](<>)", { i(1) })),
    s({ trig = ";-", snippetType = "autosnippet", desc = "Checkbox" }, fmta("- [ ] <>", { i(1) })),
    s(
        { trig = ";c", snippetType = "autosnippet", desc = "Code block" },
        fmta(
            [[
            ```<>
            <>
            ```
            ]],
            { i(1), i(2) }
        )
    ),

    s({ trig = ";h1", snippetType = "autosnippet", desc = "H1 heading" }, fmta("# <>", { i(1) })),
    s({ trig = ";h2", snippetType = "autosnippet", desc = "H2 heading" }, fmta("## <>", { i(1) })),
    s({ trig = ";h3", snippetType = "autosnippet", desc = "H3 heading" }, fmta("### <>", { i(1) })),
    s({ trig = ";h4", snippetType = "autosnippet", desc = "H4 heading" }, fmta("#### <>", { i(1) })),
    s({ trig = ";h5", snippetType = "autosnippet", desc = "H5 heading" }, fmta("##### <>", { i(1) })),
    s({ trig = ";h6", snippetType = "autosnippet", desc = "H6 heading" }, fmta("###### <>", { i(1) })),
}
