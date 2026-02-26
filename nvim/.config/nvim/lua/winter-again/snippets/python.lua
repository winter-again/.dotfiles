local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

return {
    s(
        {
            trig = "main",
            desc = "main function boilerplate",
            docstring = {
                "def main() -> int:",
                " ",
                "    return 0",
                " ",
                " ",
                'if __name__ == "__main__":',
                "    raise SystemExit(main())",
            },
        },
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
        {
            trig = "ifmain",
            desc = 'if __name__ == "__main__" guard',
            docstring = {
                'if __name__ == "__main__":',
                "    raise SystemExit(main())",
            },
        },
        fmta(
            [[
            <>

            if __name__ == "__main__":
                raise SystemExit(main())
            ]],
            { i(1) }
        )
    ),
    s(
        {
            trig = "cf",
            desc = "competitive programming template",
            docstring = {
                "import sys",
                " ",
                " ",
                "def main() -> int:",
                " ",
                "    return 0",
                " ",
                " ",
                'if __name__ == "__main__":',
                "    raise SystemExit(main())",
            },
        },
        fmt(
            [[
            import sys


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
        {
            trig = "def",
            desc = "define function",
            docstring = {
                "def <func>(<arg>) -> <ret>:",
            },
        },
        fmta(
            [[
            def <func>(<arg>) ->> <ret>:
                <>
            ]],
            { func = i(1), arg = i(2), ret = i(3), i(4) }
        )
    ),
    s(
        { trig = "match", desc = "match statement" },
        fmta(
            [[
            match <var>:
                case <cond>:
                    <outcome>
                case _:
                    <default>
            ]],
            { var = i(1, "var"), cond = i(2, "cond"), outcome = i(3, "outcome"), default = i(4, "default") }
        )
    ),
    s(
        { trig = "class", desc = "class" },
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
        { trig = "dcl", snippetType = "autosnippet", desc = "dataclass" },
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
        { trig = "arg", desc = "argparse boilerplate" },
        fmta(
            [[
            import argparse
            from collections.abc import Sequence


            def main(argv: Sequence[str] | None = None) ->> int:
                parser = argparse.ArgumentParser()
                parser.add_argument("-<arg_short>", "--<arg_long>")

                args = parser.parse_args(argv)
                print(vars(args))

                return 0


            if __name__ == "__main__":
                raise SystemExit(main())
            ]],
            { arg_short = i(1, "arg-short"), arg_long = i(2, "arg-long") }
        )
    ),
    s(
        { trig = "filter", desc = "Polars multi-condition filter" },
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
        { trig = "when", desc = "Polars when, then, otherwise construct" },
        fmta(
            " .when(pl.col(<col1>) <cond>).then(pl.col(<col2>) <out>).otherwise(pl.col(<otherwise>))",
            { col1 = i(1), cond = i(2), col2 = i(3), out = i(4), otherwise = i(5) }
        )
    ),
    s(
        {
            trig = "with pl.Conf",
            snippetType = "autosnippet",
            desc = "Polars special print",
            docstring = {
                "with pl.Config(tbl_<opt>=-1):",
                "    print(<out>)",
            },
        },
        fmta(
            [[
            with pl.Config(tbl_<opt>=-1):
                print(<out>)
            ]],
            { opt = i(1), out = i(2) }
        )
    ),
}
