local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        {
            trig = "cf",
            desc = "competitive programming template",
            docstring = {
                "#include <bits/stdc++.h>",
                " ",
                "using namespace std;",
                " ",
                "int main() {",
                "    return 0;",
                "}",
            },
        },
        fmt(
            [[
            #include <bits/stdc++.h>

            using namespace std;

            int main() {{
                {}
                return 0;
            }}
            ]],
            { i(1) }
        )
    ),
}
