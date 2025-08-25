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
        { trig = "match", snippetType = "autosnippet", desc = "match statement" },
        fmta(
            [[
        match <cond>:
            case <c1>:
                <o1>
            case _:
                <default>
        ]],
            { cond = i(1), c1 = i(2), o1 = i(3), default = i(4) }
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
    s(
        { trig = ".fil", desc = "Polars multi-condition filter" },
        fmta(
            [[
        .filter(
            (pl.col(<col1>) <out1>)
            & (pl.col(<col2>) <out2>)
        )
        ]],
            { col1 = i(1), out1 = i(2), col2 = i(3), out2 = i(4) }
        )
    ),
    s(
        { trig = ".when", snippetType = "autosnippet", desc = "Polars when, then, otherwise construct" },
        fmta(
            " .when(pl.col(<col1>) <cond>).then(pl.col(<col2>) <out>).otherwise(pl.col(<otherwise>))",
            { col1 = i(1), cond = i(2), col2 = i(3), out = i(4), otherwise = i(5) }
        )
    ),
    s(
        { trig = "with pl.Con", snippetType = "autosnippet", desc = "Polars special print" },
        fmta(
            [[
        with pl.Config(tbl_<opt>=-1):
            print(<out>)
        ]],
            { opt = i(1), out = i(2) }
        )
    ),
}
