local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local f = ls.function_node

return {
    s(
        { trig = "cday", snippetType = "autosnippet", desc = "Current date" },
        f(function()
            return os.date("%Y-%m-%d")
        end)
    ),
    s({ trig = "ln", snippetType = "autosnippet", desc = "Link" }, fmt("[{}]({})", { i(1), i(2) })),
    s({ trig = "img", desc = "Image link" }, fmt("![image]({})", { i(1) })),
    s({ trig = "!-", snippetType = "autosnippet", desc = "Checkbox" }, fmt("- [ ] {}", { i(1) })),
    s(
        { trig = "code", desc = "Code block" },
        fmt(
            [[
        ```{}
        {}
        ```
        ]],
            { i(1), i(2) }
        )
    ),

    s({ trig = "h1", desc = "H1 heading" }, fmt("# {}", { i(1) })),
    s({ trig = "h2", desc = "H2 heading" }, fmt("## {}", { i(1) })),
    s({ trig = "h3", desc = "H3 heading" }, fmt("### {}", { i(1) })),
    s({ trig = "h4", desc = "H4 heading" }, fmt("#### {}", { i(1) })),
}
