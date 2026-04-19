return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local npairs = require("nvim-autopairs")
        local rule = require("nvim-autopairs.rule")
        npairs.setup()
        npairs.add_rules({
            rule("$", "$", {
                "tex",
                "latex",
                "markdown", -- need both markdown lines?
                "markdown_inline",
            }),
        })
    end,
}
