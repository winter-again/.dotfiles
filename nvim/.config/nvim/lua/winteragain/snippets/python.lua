local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
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
}
