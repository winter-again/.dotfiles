local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s({ trig = "h1", desc = "H1 heading" }, fmt("# {}", { i(1) })),
    s({ trig = "h2", desc = "H2 heading" }, fmt("## {}", { i(1) })),
    s({ trig = "h3", desc = "H3 heading" }, fmt("### {}", { i(1) })),
    s({ trig = "h4", desc = "H4 heading" }, fmt("#### {}", { i(1) })),
    s({ trig = "link", desc = "Link" }, fmt("[{}]({})", { i(1), i(2) })),
    s({ trig = "img", desc = "Image link" }, fmt("![image]({})", { i(1) })),
    s({ trig = "cb", desc = "Checkbox" }, fmt("- [ ] {}", { i(1) })),
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
}
