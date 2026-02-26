local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

return {
    s(
        { trig = "main", desc = "main func setup" },
        fmt(
            [[
        def main() -> int:
            {}
            return 0


        if __name__ == "__main__":
            raise SystemExit(main())
        ]],
            { i(1) }
        )
    ),
    s(
        { trig = "ifmain", desc = "if __name__ block" },
        fmt(
            [[
        {}

        if __name__ == "__main__":
            raise SystemExit(main())
        ]],
            { i(1) }
        )
    ),
    s(
        { trig = "cla", desc = "class" },
        fmta(
            [[
        class <name>:
            <attr>: <attr_type>

            def __init__(self, <>: <>):
                self.<> = <>
        ]],
            { name = i(1), attr = i(2), attr_type = i(3), rep(2), rep(3), rep(2), rep(2) }
        )
    ),
    s(
        { trig = "dcl", desc = "dataclass" },
        fmta(
            [[
        @dataclass
        class <name>:
            <attr>: <attr_type>
        ]],
            { name = i(1), attr = i(2), attr_type = i(3) }
        )
    ),
    s(
        { trig = "nt", desc = "typing.NamedTuple" },
        fmta(
            [[
        class <name>(NamedTuple):
            <field>: <field_type>
        ]],
            { name = i(1), field = i(2), field_type = i(3) }
        )
    ),
}
