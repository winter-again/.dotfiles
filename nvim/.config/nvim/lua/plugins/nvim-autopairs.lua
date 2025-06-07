return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    -- dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        require("nvim-autopairs").setup()

        -- automatically insert parentheses after cmp selection (functions/method items)
        -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        -- local cmp = require("cmp")
        -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}
